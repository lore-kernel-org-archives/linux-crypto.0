From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING: kernel stack regs has bad 'bp' value (2)
Date: Wed, 27 Dec 2017 19:29:32 +0100
Message-ID: <CACT4Y+aUt1Y1Y9tHGaAare-6+DcGpee85NgJFk7EYrb=b4RT3g@mail.gmail.com>
References: <001a113f2cd26f3532055f0f4a79@google.com> <20171130091724.GC5451@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot
        <bot+e01a53d277c86c4e61e7c84ec83432ed395c7df8@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171130091724.GC5451@zzz.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 30, 2017 at 10:17 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Tue, Nov 28, 2017 at 10:36:01AM -0800, syzbot wrote:
>> WARNING: kernel stack regs at ffff8801c1e5f468 in syzkaller196611:6199 has
>> bad 'bp' value 0000000000000001
>> unwind stack type:0 next_sp:          (null) mask:0x6 graph_idx:0
>> ffff8801db4075a8: ffff8801db407630 (0xffff8801db407630)
>> ffff8801db4075b0: ffffffff8128a84e (__save_stack_trace+0x6e/0xd0)
>> ffff8801db4075b8: 0000000000000000 ...
>> ffff8801db4075c0: ffff8801c1e58000 (0xffff8801c1e58000)
>> ffff8801db4075c8: ffff8801c1e60000 (0xffff8801c1e60000)
>> ffff8801db4075d0: 0000000000000000 ...
>> ffff8801db4075d8: 0000000000000006 (0x6)
>> ffff8801db4075e0: ffff8801c1e4e000 (0xffff8801c1e4e000)
>> ffff8801db4075e8: 0000010100000000 (0x10100000000)
>> ffff8801db4075f0: 0000000000000000 ...
>> ffff8801db4075f8: ffff8801db4075a8 (0xffff8801db4075a8)
>> ffff8801db407600: ffffffff8134ff7d (__twofish_enc_blk_3way+0x1b1d/0x1b30)
>
> Looks like the x86_64 "3 way" version of Twofish (twofish-x86_64-asm_64-3way.S)
> needs to be updated to not use %rbp.


This is what is supposed to be fixed with "crypto: x86/twofish-3way -
Fix %rbp usage", right? Was it merged anywhere?
This is one of top crashers with 15K crashes.
