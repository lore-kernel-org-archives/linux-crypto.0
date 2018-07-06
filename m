From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KMSAN: uninit-value in af_alg_free_areq_sgls
Date: Fri, 6 Jul 2018 10:19:07 +0200
Message-ID: <CACT4Y+Yv8M93-N3J1U6r1X=Oy2SaKQpJU1S6iJeFC8bJMnjuKg@mail.gmail.com>
References: <1616306.R4SzcgHSdy@positron.chronox.de> <000000000000363e2e0570502d42@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000363e2e0570502d42@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 6, 2018 at 10:09 AM, syzbot
<syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot tried to test the proposed patch but build/boot failed:
>
> lost connection to test machine

Looking into this.

> [....] Starting enhanced syslogd: rsyslogd [?25l [?1c 7 [1G[ [32m ok [39;49m
> 8 [?25h [?0c.
> [....] Starting periodic command scheduler: cron [?25l [?1c 7 [1G[ [32m ok
> [39;49m 8 [?25h [?0c.
> [....] Starting OpenBSD Secure Shell server: sshd[   21.709280] random:
> sshd: uninitialized urandom read (32 bytes read)
> [?25l [?1c 7 [1G[ [32m ok  [39;49m 8 [?25h [?0c.
>
> Debian GNU/Linux 7 syzkaller ttyS0
>
> syzkaller login: [   26.229113] random: sshd: uninitialized urandom read (32
> bytes read)
> [   26.532843] random: sshd: uninitialized urandom read (32 bytes read)
> [   27.787277] random: sshd: uninitialized urandom read (32 bytes read)
> Warning: Permanently added '10.128.0.2' (ECDSA) to the list of known hosts.
> [   33.299368] random: sshd: uninitialized urandom read (32 bytes read)
> flag provided but not defined: -os
> Usage of ./syz-fuzzer:
>   -abort_signal int
>         initial signal to send to executor in error conditions; upgrades to
> SIGKILL if executor does not exit
>   -arch string
>         target arch (default "amd64")
>   -buffer_size uint
>         internal buffer size (in bytes) for executor output
>   -collide
>         collide syscalls to provoke data races (default true)
>   -cover
>         collect feedback signals (coverage)
>   -debug
>         debug output from executor
>   -executor string
>         path to executor binary (default "./syz-executor")
>   -ipc string
>         ipc scheme (pipe/shmem)
>   -leak
>         detect memory leaks
>   -manager string
>         manager rpc address
>   -name string
>         unique name for manager (default "test")
>   -output string
>         write programs to none/stdout/dmesg/file (default "stdout")
>   -pprof string
>         address to serve pprof profiles
>   -procs int
>         number of parallel test processes (default 1)
>   -sandbox string
>         sandbox for fuzzing (none/setuid/namespace) (default "none")
>   -test
>         enable image testing mode
>   -threaded
>         use threaded mode in executor (default true)
>   -timeout duration
>         execution timeout
>   -v int
>         verbosity
>
>
>
> Tested on:
>
> commit:         9c9df9f275f0 kmsan: remove kmsan_threads_ready
> git tree:       https://github.com/google/kmsan.git/master
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b11f4cfb262ee607
> compiler:       clang version 7.0.0 (trunk 334104)
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=16a5af84400000
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/000000000000363e2e0570502d42%40google.com.
>
> For more options, visit https://groups.google.com/d/optout.
