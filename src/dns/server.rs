use std::str::FromStr;
use std::thread;
use std::net::UdpSocket;
use std::net::Ipv4Addr;
use std::net::SocketAddrV4;

use config::Config;
use dns::header::Header;
use dns::answer::Answer;
use dns::message::Message;

pub struct Server {
    pub thread: thread::JoinHandle<u8>,
}

impl Server {
    pub fn create(config: &Config) -> Server {
        let thread = Server::create_thread(config.dns_port);

        Server{
            thread: thread,
        }
    }

    fn create_thread(port: u16) -> thread::JoinHandle<u8> {
        thread::spawn(move || {
            let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::from_str("127.0.0.1").unwrap(), port)).unwrap();

            let mut buffer: [u8; 512] = [0; 512];

            loop {
                let (size, source) = socket.recv_from(&mut buffer).unwrap();

                let query_message = Message::unpack(&buffer[..size]);

                let answer_message: Message;

                if query_message.questions[0].name.last().unwrap() == "local" {
                    let mut answers = Vec::new();

                    answers.push(Answer{
                        name: query_message.questions[0].name.clone(),
                        rrtype: 1,
                        class: 1,
                        ttl: 0,
                        length: 4,
                        data: vec!(127, 0, 0, 1),
                    });

                    answer_message = Message {
                        header: Header {
                            query_response: 1,
                            answer_count: 1,
                            ns_count: 0,
                            ar_count: 0,
                            ..query_message.header
                        },
                        answers: answers,
                        ..query_message
                    };
                } else {
                    answer_message = Message {
                        header: Header {
                            query_response: 1,
                            answer_count: 0,
                            ns_count: 0,
                            ar_count: 0,
                            error_code: 3,
                            ..query_message.header
                        },
                        ..query_message
                    };
                }

                let size = answer_message.pack(&mut buffer);

                socket.send_to(&buffer[..size], &source).unwrap();
            }
        })
    }
}

