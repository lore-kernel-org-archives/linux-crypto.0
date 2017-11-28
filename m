From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Tue, 28 Nov 2017 14:40:49 -0800
Message-ID: <20171128224049.GH45321@gmail.com>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <20171128053738.GA2383@zzz.localdomain>
 <6174444.U6zRo7pOhC@tauon.chronox.de>
 <1943686.EAKghbSqDq@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:41235 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbdK1Wkx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 17:40:53 -0500
Content-Disposition: inline
In-Reply-To: <1943686.EAKghbSqDq@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 10:33:09PM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> I verified the correctnes of the patch with Eric's test program.
> Without the patch, the issue is present. With the patch, the kernel
> happily lives ever after.
> 
> Changes v2: change the submission into a proper patch
> 
> Ciao
> Stephan
> 
> ---8<---
> 
> The function af_alg_get_rsgl may sleep to wait for additional data. In
> this case, the socket lock may be dropped. This allows user space to
> change values in the socket data structure. Hence, all variables of the
> context that are needed before and after the af_alg_get_rsgl must be
> copied into a local variable.
> 
> This issue applies to the ctx->enc variable only. Therefore, this
> value is copied into a local variable that is used for all operations
> before and after the potential sleep and lock release. This implies that
> any changes on this variable while the kernel waits for data will only
> be picked up in another recvmsg operation.
> 

This isn't enough because ->aead_assoclen is also affected.  Below is a program
which causes a crash even with your patch applied.

Also I feel this is just papering over the real problem which is that the wait
is in the wrong place -- and therefore the socket lock is being dropped in the
wrong place.  If it's necessary at all it seems it should happen earlier, before
the stuff from the 'ctx' starts being used.  At the very least, it is very
difficult to understand whether the current code is correct or not.  (Which
usually means it's not.)

#include <linux/if_alg.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define SOL_ALG 0x117
#define ALG_SET_AEAD_ASSOCLEN 4

int main()
{
	srand(time(NULL));
        for (;;) {
                int algfd, reqfd;
                char buf[12];
                char key[16] = { 0 };
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
			.op = ALG_OP_ENCRYPT,
                };
                struct msghdr set_op_msg = {
                        .msg_control = &set_op,
                        .msg_controllen = sizeof(set_op),
                };
                struct {
                        struct cmsghdr hdr1;
                        __u32 assoclen;
                        struct cmsghdr hdr2;
                        __u32 op;
                } set_assoclen = {
                        .hdr1 = {
                                .cmsg_len = sizeof(set_assoclen),
                                .cmsg_level = SOL_ALG,
                                .cmsg_type = ALG_SET_AEAD_ASSOCLEN,
                        },
			.assoclen = 1000,
                        .hdr2 = {
                                .cmsg_len = sizeof(set_assoclen),
                                .cmsg_level = SOL_ALG,
                                .cmsg_type = ALG_SET_OP,
                        },
			.op = ALG_OP_ENCRYPT,
                };
                struct msghdr set_assoclen_msg = {
			.msg_iov = &(struct iovec) { .iov_base = buf,
						     .iov_len = 64 },
			.msg_iovlen = 1,
                        .msg_control = &set_assoclen,
                        .msg_controllen = sizeof(set_assoclen),
                };

                algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);

                bind(algfd, (void *)&addr, sizeof(addr));

                setsockopt(algfd, SOL_ALG, ALG_SET_KEY, key, sizeof(key));

                reqfd = accept(algfd, NULL, NULL);

                sendmsg(reqfd, &set_op_msg, 0);

                if (fork() == 0) {
			usleep(rand() % 10000);
                        sendmsg(reqfd, &set_assoclen_msg, 0);
                        break;
                }

		usleep(rand() % 10000);
                read(reqfd, buf, sizeof(buf));
                wait(NULL);
		close(algfd);
		close(reqfd);
        }
}
