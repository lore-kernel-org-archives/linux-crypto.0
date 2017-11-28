From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in blkcipher_walk_done
Date: Mon, 27 Nov 2017 21:37:38 -0800
Message-ID: <20171128053738.GA2383@zzz.localdomain>
References: <001a113f2cd2d62b59055efb7618@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:39171 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdK1Fhm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 00:37:42 -0500
Content-Disposition: inline
In-Reply-To: <001a113f2cd2d62b59055efb7618@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 27, 2017 at 10:56:47AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers

Still happens on latest Linus tree (v4.15-rc1) with crypto/master merged in.  It
seems that _aead_recvmsg() is being confused by the operation mode being changed
from encryption to decryption while it has dropped the socket lock in
af_alg_wait_for_data().  Here's a simplified reproducer:

#include <linux/if_alg.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>

int main()
{
        for (;;) {
                int algfd, reqfd;
                struct sockaddr_alg addr = {
                        .salg_type = "aead",
                        .salg_name = "gcm(aes)",
                };
                struct {
                        struct cmsghdr hdr;
                        __u32 op;
                } set_op = {
                        .hdr = {
                                .cmsg_len = sizeof(set_op),
                                .cmsg_level = SOL_ALG,
                                .cmsg_type = ALG_SET_OP,
                        },
                };
                struct msghdr set_op_msg = {
                        .msg_control = &set_op,
                        .msg_controllen = sizeof(set_op),
                };
                char key[16] = { 0 };
                char buf[4096];

                algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);

                bind(algfd, (void *)&addr, sizeof(addr));

                setsockopt(algfd, SOL_ALG, ALG_SET_KEY, key, sizeof(key));

                reqfd = accept(algfd, NULL, NULL);

                set_op.op = ALG_OP_ENCRYPT;
                sendmsg(reqfd, &set_op_msg, 0);

                if (fork() == 0) {
                        set_op.op = ALG_OP_DECRYPT;
                        sendmsg(reqfd, &set_op_msg, 0);
                        break;
                }

                read(reqfd, buf, sizeof(buf));
                wait(NULL);
        }
}
