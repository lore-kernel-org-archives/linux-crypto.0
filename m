Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9099EEB64D9
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jul 2023 09:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjGGJlq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jul 2023 05:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjGGJlp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2023 05:41:45 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29CC2106
        for <linux-crypto@vger.kernel.org>; Fri,  7 Jul 2023 02:41:43 -0700 (PDT)
Received: from fsav311.sakura.ne.jp (fsav311.sakura.ne.jp [153.120.85.142])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 3679fe4l054573;
        Fri, 7 Jul 2023 18:41:40 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav311.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp);
 Fri, 07 Jul 2023 18:41:40 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 3679fdZc054567
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 7 Jul 2023 18:41:40 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <63006262-f808-50ab-97b8-c2193c7a9ba1@I-love.SAKURA.ne.jp>
Date:   Fri, 7 Jul 2023 18:41:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
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
 <8c989395-0f20-a957-6611-8a356badcf3c@I-love.SAKURA.ne.jp>
 <35970e3b-8142-8e00-c12a-da8c6925c12c@I-love.SAKURA.ne.jp>
 <20230706135319.66d3cb78@kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20230706135319.66d3cb78@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023/07/07 5:53, Jakub Kicinski wrote:
> On Tue, 4 Jul 2023 22:32:00 +0900 Tetsuo Handa wrote:
>> I found a simplified reproducer.
>> This problem happens when splice() and sendmsg() run in parallel.
> 
> Could you retry with the upstream (tip of Linus's tree) and see if it
> still repros? I tried to get a KMSAN kernel to boot on QEMU but it
> the kernel doesn't want to start, no idea what's going on :(

I can't reproduce this problem as of commit a452483508d7 of linux.git tree, for
the simplified reproducer is failing with EBADMSG error. Unless what the simplified
reproducer is doing has become illegal, I need to bisect between

  commit 219d92056ba3 ("splice, net: Fix SPLICE_F_MORE signalling in splice_direct_to_actor()")

which fails with EBADMSG error and

  commit 8a0d57df8938 ("tls: improve lockless access safety of tls_err_abort()")

which shows this problem, with

  commit e6bc8833d80f ("string: use __builtin_memcpy() in strlcpy/strlcat")

backported...

----------------------------------------
root@fuzz:~# strace -f ./a.out
execve("./a.out", ["./a.out"], 0x7ffedb58a368 /* 26 vars */) = 0
brk(NULL)                               = 0x564cb3f30000
arch_prctl(0x3001 /* ARCH_??? */, 0x7ffd9c8980a0) = -1 EINVAL (Invalid argument)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f463d4e6000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=37735, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 37735, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f463d4dc000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\237\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0 \0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0"..., 48, 848) = 48
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0i8\235HZ\227\223\333\350s\360\352,\223\340."..., 68, 896) = 68
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=2216304, ...}, AT_EMPTY_PATH) = 0
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
mmap(NULL, 2260560, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f463d200000
mmap(0x7f463d228000, 1658880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x28000) = 0x7f463d228000
mmap(0x7f463d3bd000, 360448, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1bd000) = 0x7f463d3bd000
mmap(0x7f463d415000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x214000) = 0x7f463d415000
mmap(0x7f463d41b000, 52816, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f463d41b000
close(3)                                = 0
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f463d4d9000
arch_prctl(ARCH_SET_FS, 0x7f463d4d9740) = 0
set_tid_address(0x7f463d4d9a10)         = 3444
set_robust_list(0x7f463d4d9a20, 24)     = 0
rseq(0x7f463d4da0e0, 0x20, 0, 0x53053053) = 0
mprotect(0x7f463d415000, 16384, PROT_READ) = 0
mprotect(0x564cb38ac000, 4096, PROT_READ) = 0
mprotect(0x7f463d520000, 8192, PROT_READ) = 0
prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
munmap(0x7f463d4dc000, 37735)           = 0
socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
pipe2([4, 5], 0)                        = 0
setsockopt(3, SOL_TCP, TCP_REPAIR, [1], 4) = 0
connect(3, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28) = 0
setsockopt(3, SOL_TCP, TCP_ULP, [7564404], 4) = 0
setsockopt(3, SOL_TLS, TLS_TX, "\3\0035\0%T\244\205\333\f0\362B\221\243\234\206\216\220\243u\347\342P|1\24}Q@\377\227"..., 40) = 0
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLDstrace: Process 3445 attached
, child_tidptr=0x7f463d4d9a10) = 3445
[pid  3444] close(4 <unfinished ...>
[pid  3445] set_robust_list(0x7f463d4d9a20, 24 <unfinished ...>
[pid  3444] <... close resumed>)        = 0
[pid  3445] <... set_robust_list resumed>) = 0
[pid  3444] write(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 32768 <unfinished ...>
[pid  3445] splice(4, NULL, 3, NULL, 1048576, SPLICE_F_MORE <unfinished ...>
[pid  3444] <... write resumed>)        = 32768
[pid  3444] poll(NULL, 0, 1)            = 0 (Timeout)
[pid  3444] sendmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="@@@@@@@@@@@@@@@@", iov_len=16}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_FASTOPEN}, MSG_DONTWAIT|MSG_MORE) = -1 EBADMSG (Bad message)
[pid  3445] <... splice resumed>)       = -1 EBADMSG (Bad message)
[pid  3444] exit_group(0 <unfinished ...>
[pid  3445] exit_group(0 <unfinished ...>
[pid  3444] <... exit_group resumed>)   = ?
[pid  3445] <... exit_group resumed>)   = ?
[pid  3444] +++ exited with 0 +++
+++ exited with 0 +++
----------------------------------------

