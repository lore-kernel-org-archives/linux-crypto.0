From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Mon, 09 Oct 2017 17:13:48 +0200
Message-ID: <1629795.0592ersqdG@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de> <12183583.FhH6M9YiZ5@positron.chronox.de> <20171009141925.GA7592@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34822 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754649AbdJIPNw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2017 11:13:52 -0400
In-Reply-To: <20171009141925.GA7592@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 9. Oktober 2017, 16:19:25 CEST schrieb Herbert Xu:

Hi Herbert,

> On Sat, Oct 07, 2017 at 02:56:24PM +0200, Stephan Müller wrote:
> > Though, this opens up the shash issue I tried to fix.
> 
> Does this patch fix the crash?

I get the following during boot:

[    1.042673] ------------[ cut here ]------------
[    1.043208] kernel BUG at crypto/asymmetric_keys/public_key.c:96!
[    1.044235] invalid opcode: 0000 [#1] SMP
[    1.044661] Modules linked in:
[    1.044964] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.14.0-rc1+ #556
[    1.045638] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.10.2-1.fc26 04/01/2014
[    1.046397] task: ffff8ecefc880000 task.stack: ffffa776c031c000
[    1.046943] RIP: 0010:public_key_verify_signature+0x25c/0x270
[    1.047539] RSP: 0018:ffffa776c031fcd8 EFLAGS: 00010246
[    1.047997] RAX: ffffffffa5cb1d5f RBX: ffff8eceb61f9780 RCX: 
0000000000000000
[    1.048618] RDX: ffff8eceb6169cc0 RSI: ffff8eceb6169cc0 RDI: 
ffff8ecefc99be80
[    1.049261] RBP: ffffa776c031fcf0 R08: 00000000000000c9 R09: 
ffff8ecefd003800
[    1.049870] R10: ffffc78580d88100 R11: 7fffffffffffffff R12: 
0000000000000001
[    1.050487] R13: ffff8eceb61fa2a0 R14: ffffffffa60c5870 R15: 
0000000000000542
[    1.051118] FS:  0000000000000000(0000) GS:ffff8eceffd00000(0000) knlGS:
0000000000000000
[    1.051805] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.052295] CR2: 00007f89a5ee2000 CR3: 0000000036036004 CR4: 
00000000003606e0
[    1.052853] Call Trace:
[    1.053069]  ? x509_check_for_self_signed+0x86/0xd0
[    1.053446]  x509_cert_parse+0x15e/0x1c0
[    1.053764]  x509_key_preparse+0x26/0x1e0
[    1.054094]  asymmetric_key_preparse+0x5c/0xd0
[    1.054438]  key_create_or_update+0x137/0x430
[    1.054789]  ? set_debug_rodata+0x17/0x17
[    1.055119]  load_system_certificate_list+0x99/0xfa
[    1.055494]  ? system_trusted_keyring_init+0x66/0x66
[    1.055890]  ? set_debug_rodata+0x17/0x17
[    1.056221]  do_one_initcall+0x41/0x160
[    1.056519]  kernel_init_freeable+0x173/0x201
[    1.056867]  ? rest_init+0xb0/0xb0
[    1.057161]  kernel_init+0xe/0x110
[    1.057426]  ret_from_fork+0x25/0x30
[    1.057714] Code: 40 00 85 c0 b8 7f ff ff ff 44 0f 45 f8 eb 8a 48 8d bd e0 
fe ff ff e8 d4 ad 40 00 44 8b bd 00 ff ff ff e9 5a ff ff ff 0f 0b 0f 0b <0f> 
0b 0f 0b 41 bf ea ff ff ff e9 7a ff ff ff 0f 1f 44 00 00 0f 
[    1.059208] RIP: public_key_verify_signature+0x25c/0x270 RSP: 
ffffa776c031fcd8
[    1.059782] ---[ end trace 5363a8b61ab8b581 ]---
[    1.060236] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b
[    1.060236] 
[    1.061073] Kernel Offset: 0x24000000 from 0xffffffff81000000 (relocation 
range: 0xffffffff80000000-0xffffffffbfffffff)
[    1.061990] ---[ end Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b
Ciao
Stephan
