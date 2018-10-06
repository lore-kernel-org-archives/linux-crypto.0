From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in sha1_mb_mgr_get_comp_job_avx2
Date: Sat, 6 Oct 2018 15:06:30 +0200
Message-ID: <CACT4Y+aVZTpjzMzPQ2Rtgx_cRjXdwJG7BaAEO78UAitm-AnptA@mail.gmail.com>
References: <0000000000002e9bdb0576c70441@google.com> <20181005223206.GA184636@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot <syzbot+87dbe4b17debcec16d71@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, megha.dey@linux.intel.com,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        tim.c.chen@linux.intel.com,
        "the arch/x86 maintainers" <x86@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005223206.GA184636@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 6, 2018 at 12:32 AM, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Sep 26, 2018 at 07:27:04AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    a38523185b40 erge tag 'libnvdimm-fixes-4.19-rc6' of git://..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1767b7fa400000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dfb440e26f0a6f6f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=87dbe4b17debcec16d71
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+87dbe4b17debcec16d71@syzkaller.appspotmail.com
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000034
>> PGD 1b8b87067 P4D 1b8b87067 PUD 1b8b88067 PMD 0
>> Oops: 0002 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 24 Comm: kworker/1:1 Not tainted 4.19.0-rc5+ #32
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Workqueue: crypto mcryptd_flusher
>> RIP: 0010:sha1_mb_mgr_get_comp_job_avx2+0x62/0xba
>> arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S:256
>> Code: 04 c4 e2 69 3b d3 c4 c1 79 7e d0 49 f7 c0 f0 ff ff ff 75 6e 49 6b d8
>> 08 48 8d 9c 1f 08 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7> 40 34 02 00 00
>> 00 48 8b 9f 00 01 00 00 48 c1 e3 04 4c 09 c3 48
>> kobject: 'loop1' (00000000307f8c2f): kobject_uevent_env
>> RSP: 0018:ffff8801d94473c0 EFLAGS: 00010206
>> RAX: 0000000000000000 RBX: ffff8801d4818688 RCX: 1ffff1003b2869e1
>> RDX: 1ffffd1ffffa2591 RSI: ffffffff81454f3a RDI: ffff8801d4818580
>> RBP: ffff8801d9447520 R08: 0000000000000000 R09: 0000000000000006
>> kobject: 'loop1' (00000000307f8c2f): fill_kobj_path: path =
>> '/devices/virtual/block/loop1'
>> R10: 0000000000000000 R11: ffff8801d9434640 R12: ffff8801d94474f8
>> R13: 0000000000000001 R14: ffff8801bb509720 R15: 0000000000000200
>> FS:  0000000000000000(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> kobject: 'loop4' (00000000fa342cfc): kobject_uevent_env
>> CR2: 0000000000000034 CR3: 00000001b8b85000 CR4: 00000000001406e0
>> kobject: 'loop4' (00000000fa342cfc): fill_kobj_path: path =
>> '/devices/virtual/block/loop4'
>> Call Trace:
>>  sha1_mb_flusher+0x2f4/0x60b arch/x86/crypto/sha1-mb/sha1_mb.c:918
>>  mcryptd_flusher+0x3af/0x520 crypto/mcryptd.c:208
>>  process_one_work+0xc90/0x1b90 kernel/workqueue.c:2153
>>  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
>>  kthread+0x35a/0x420 kernel/kthread.c:246
>>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413
>> Modules linked in:
>> CR2: 0000000000000034
>> ---[ end trace 7d3a48e5625a9543 ]---
>> RIP: 0010:sha1_mb_mgr_get_comp_job_avx2+0x62/0xba
>> arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S:256
>> Code: 04 c4 e2 69 3b d3 c4 c1 79 7e d0 49 f7 c0 f0 ff ff ff 75 6e 49 6b d8
>> 08 48 8d 9c 1f 08 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7> 40 34 02 00 00
>> 00 48 8b 9f 00 01 00 00 48 c1 e3 04 4c 09 c3 48
>> RSP: 0018:ffff8801d94473c0 EFLAGS: 00010206
>> RAX: 0000000000000000 RBX: ffff8801d4818688 RCX: 1ffff1003b2869e1
>> RDX: 1ffffd1ffffa2591 RSI: ffffffff81454f3a RDI: ffff8801d4818580
>> RBP: ffff8801d9447520 R08: 0000000000000000 R09: 0000000000000006
>> R10: 0000000000000000 R11: ffff8801d9434640 R12: ffff8801d94474f8
>> R13: 0000000000000001 R14: ffff8801bb509720 R15: 0000000000000200
>> FS:  0000000000000000(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000034 CR3: 00000001b8b85000 CR4: 00000000001406e0
>>
>>
>> ---
>> This bug is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this bug report. See:
>> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
>> syzbot.
>
> The "fix" for this is queued in cryptodev:
>
> #syz fix: crypto: x86 - remove SHA multibuffer routines and mcryptd

That's the best type of fix! :)
