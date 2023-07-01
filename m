Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FC3EB64DC
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jul 2023 04:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjGAEMl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jul 2023 00:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGAEMl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2023 00:12:41 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89B392
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 21:12:38 -0700 (PDT)
Received: from fsav112.sakura.ne.jp (fsav112.sakura.ne.jp [27.133.134.239])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 3614Cb31069421;
        Sat, 1 Jul 2023 13:12:37 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav112.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp);
 Sat, 01 Jul 2023 13:12:37 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 3614CaW8069416
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 1 Jul 2023 13:12:36 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <8c989395-0f20-a957-6611-8a356badcf3c@I-love.SAKURA.ne.jp>
Date:   Sat, 1 Jul 2023 13:12:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Content-Language: en-US
To:     Ard Biesheuvel <ardb@kernel.org>,
        Alexander Potapenko <glider@google.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+828dfc12440b4f6f305d@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <0000000000008a7ae505aef61db1@google.com>
 <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
 <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com>
 <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
 <CAG_fn=UWZWc+FZ_shCr+T9Y3gV9Bue-ZFHKJj78YXBq3JfnUKA@mail.gmail.com>
 <CAMj1kXE_PjQT6+A9a0Y=ZfbOr_H+umYSqHuRrM6AT_gFJxxP1w@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAMj1kXE_PjQT6+A9a0Y=ZfbOr_H+umYSqHuRrM6AT_gFJxxP1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I'm trying to write a simplified reproducer that reproduces

----------------------------------------
[  162.905919][ T3399] required_size=2461 ret=0
[  162.916796][ T3399] required_size=6557 ret=0
[  162.919587][ T3399] required_size=10653 ret=0
[  162.923090][ T3399] required_size=14749 ret=0
[  162.928686][ T3399] required_size=16413 ret=0
[  162.936894][ T3399] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=1664
[  162.962097][ T3399] required_size=2461 ret=0
[  162.967270][ T3399] required_size=6557 ret=0
[  162.992866][ T3399] required_size=10653 ret=0
[  162.999962][ T3399] required_size=14765 ret=0
[  163.006420][ T3399] required_size=16413 ret=0
[  163.012163][ T3399] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=1648
----------------------------------------

part, and came to wonder if serialization between splice() and sendmsg() is correct.

A program where splice() and sendmsg() cannot run in parallel due to single-threaded
is shown below.

----------------------------------------
#define _GNU_SOURCE
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#define SOL_TCP 6
#define TCP_REPAIR 19
#define TCP_ULP 31
#define TLS_TX 1

int main(int argc, char *argv[])
{
	struct iovec iov = {
		.iov_base = "@@@@@@@@@@@@@@@@",
		.iov_len = 16
	};
	struct msghdr hdr = {
		.msg_iov = &iov,
		.msg_iovlen = 1,
		.msg_flags = MSG_FASTOPEN
	};
	const struct sockaddr_in6 addr = { .sin6_family = AF_INET6, .sin6_addr = in6addr_loopback };
	const int one = 1;
	int ret_ignored = 0;
	const int fd = socket(PF_INET6, SOCK_STREAM, IPPROTO_IP);
	int pipe_fds[2] = { -1, -1 };
	static char buf[32768] = { };

	ret_ignored += pipe(pipe_fds);
	setsockopt(fd, SOL_TCP, TCP_REPAIR, &one, sizeof(one));
	connect(fd, (struct sockaddr *) &addr, sizeof(addr));
	setsockopt(fd, SOL_TCP, TCP_ULP, "tls", 4);
	setsockopt(fd, SOL_TLS, TLS_TX,"\3\0035\0%T\244\205\333\f0\362B\221\243\234\206\216\220\243u\347\342P|1\24}Q@\377\227\353\222B\354\264u[\346", 40);
	ret_ignored += write(pipe_fds[1], buf, 2432);
	ret_ignored += write(pipe_fds[1], buf, 10676);
	ret_ignored += write(pipe_fds[1], buf, 17996);
	if (argc == 1) {
		ret_ignored += splice(pipe_fds[0], NULL, fd, NULL, 1048576, 0);
		ret_ignored += sendmsg(fd, &hdr, MSG_DONTWAIT | MSG_MORE);
	} else {
		ret_ignored += sendmsg(fd, &hdr, MSG_DONTWAIT | MSG_MORE);
		ret_ignored += splice(pipe_fds[0], NULL, fd, NULL, 1048576, 0);
	}
	return ret_ignored * 0;
}
----------------------------------------

If you run this program with argc == 1, you will get below output.

----------------------------------------
[ 4030.292376] [ T3896] required_size=2461 ret=0
[ 4030.292376] [ T3896] required_size=6557 ret=0
[ 4030.292376] [ T3896] required_size=10653 ret=0
[ 4030.292376] [ T3896] required_size=14749 ret=0
[ 4030.292376] [ T3896] required_size=16413 ret=0
[ 4030.292376] [ T3896] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=1664
[ 4030.330185] [ T3896] required_size=2461 ret=0
[ 4030.330185] [ T3896] required_size=6557 ret=0
[ 4030.330185] [ T3896] required_size=10653 ret=0
[ 4030.335443] [ T3896] required_size=14749 ret=0
[ 4030.335443] [ T3896] full_record=0 eor=1 sk_msg_full(msg_pl)=0 copied=4096
----------------------------------------

If you run this program with argc != 1, you will get below output.

----------------------------------------
[ 4044.312696] [ T3898] required_size=2477 ret=0
[ 4044.312696] [ T3898] required_size=6573 ret=0
[ 4044.312696] [ T3898] required_size=10669 ret=0
[ 4044.312696] [ T3898] required_size=14765 ret=0
[ 4044.312696] [ T3898] required_size=16413 ret=0
[ 4044.312696] [ T3898] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=1648
[ 4044.340425] [ T3898] required_size=2477 ret=0
[ 4044.350515] [ T3898] required_size=6573 ret=0
[ 4044.350515] [ T3898] required_size=10669 ret=0
[ 4044.350515] [ T3898] required_size=14765 ret=0
[ 4044.350515] [ T3898] full_record=0 eor=1 sk_msg_full(msg_pl)=0 copied=4096
----------------------------------------

The difference is that the required_size= value differs by "struct iovec"->iov_len
bytes which is the value passed to sendmsg().

If splice() happens before sendmsg() happens, the output does not include
bytes passed to sendmsg(). If sendmsg() happens before splice() happens,
the output includes bytes passed to sendmsg(). 

Then, where does the difference between

----------------------------------------
[  162.919587][ T3399] required_size=10653 ret=0
[  162.923090][ T3399] required_size=14749 ret=0
[  162.928686][ T3399] required_size=16413 ret=0
----------------------------------------

and

----------------------------------------
[  162.992866][ T3399] required_size=10653 ret=0
[  162.999962][ T3399] required_size=14765 ret=0
[  163.006420][ T3399] required_size=16413 ret=0
----------------------------------------

come from? Both output had the same values until 10653, but
the next value differs by 16. This might suggest that a race between
splice() and sendmsg() caused unexpected required_size= value...

This could explain "for the second time" part below.

  >   4125+8221+12317+16413=41076 (the lower 4 bits are 0100)
  >   2461+6557+10653+14749+16413=50833 (the lower 4 bits are 0001)
  >   2461+6573+10669+14765+16413=50881 (the lower 4 bits are 0001)
  > 
  > KMSAN reports this problem when the lower 4 bits became 0001 for the second time.
  > Unless KMSAN's reporting is asynchronous, maybe the reason of "for the second time"
  > part is that the previous state is relevant...

