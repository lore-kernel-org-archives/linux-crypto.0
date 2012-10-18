From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Kernel 3.7.0-rc1 crash after TrueCrypt mount device on a computer
 with Intel i5
Date: Thu, 18 Oct 2012 09:13:25 -0700
Message-ID: <CA+55aFxKBQwU8TxvzS2XY=grM090Pw5zEcXg9BTyO2WYu91TYw@mail.gmail.com>
References: <508025FD.7010602@winsoft.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Krzysztof Kolasa <kkolasa@winsoft.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Kim Phillips <kim.phillips@freescale.com>,
	Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54423 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab2JRQOc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Oct 2012 12:14:32 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so7355634wgb.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Oct 2012 09:14:30 -0700 (PDT)
In-Reply-To: <508025FD.7010602@winsoft.pl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Krzysztof, please try to cc the appropriate people/list.

I've added linux-crypto and the people who touched aesni-intel since
3.6, and am re-quoting the whole email (except for the continuation
oopses that won't be relevant)

It seems to crash on the very first instruction of _aesni_enc1, which is just a

   movaps (KEYP), KEY

where on x86-32, KEYP is %edi and KEY is %xmm2.

In the oops register dump, %edi is 0xf169fe64, which looks like a
valid kernel pointer (depending on amount of memory), but it looks
like the problem is that it's not 16-byte aligned.

I dunno. None of the asm code seems to have changed since 3.6 afaik,
so some calling code change triggers this? Guys, ideas?

                   Linus

On Thu, Oct 18, 2012 at 8:53 AM, Krzysztof Kolasa <kkolasa@winsoft.pl> wrote:
> after mount crypted device (volume, pendrive) kernel crash on HP machine
> (mounting on AMILO Pro v3405 working properly ), rs232 console output :
>
> [  124.613648] general protection fault: 0000 [#1] SMP
> [  124.672862] Modules linked in: dm_crypt fglrx(PO) bnep rfcomm bluetooth
> binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_ine
> [  125.356439] Pid: 55, comm: kworker/0:1 Tainted: P           O
> 3.7.0-rc1-winsoft-pae #1 Hewlett-Packard HP ProBook 6560b/1619
> [  125.490351] EIP: 0060:[<f85bb2bc>] EFLAGS: 00010216 CPU: 0
> [  125.555762] EIP is at _aesni_enc1+0x0/0x9c [aesni_intel]
> [  125.619087] EAX: c1959000 EBX: 00000001 ECX: f001392c EDX: f06de000
> [  125.693829] ESI: f169fdb4 EDI: f169fe64 EBP: f169fda4 ESP: f169fd30
> [  125.768578]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  125.832951] CR0: 80050033 CR2: b7710000 CR3: 01963000 CR4: 000407f0
> [  125.907694] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  125.982436] DR6: ffff0ff0 DR7: 00000400
> [  126.028115] Process kworker/0:1 (pid: 55, ti=f169e000 task=f1679940
> task.ti=f169e000)
> [  126.121547] Stack:
> [  126.145429]  f85bb2b4 00000008 f169fe34 f85703a9 f169fe64 c1959000
> f06de000 00000008
> [  126.237894]  00000200 00000000 f06de000 f23b3bc0 f06de000 f23b3bc0
> f06de000 f00138f4
> [  126.330358]  00000000 00000200 f001390c 00000000 00000200 00000000
> 00000000 f001392c
> [  126.422804] Call Trace:
> [  126.451881]  [<f85bb2b4>] ? aesni_enc+0x1c/0x24 [aesni_intel]
> [  126.520399]  [<f85703a9>] ? init_tfm+0x129/0x250 [xts]
> [  126.581652]  [<f85bbd6e>] xts_decrypt+0x7e/0xc0 [aesni_intel]
> [  126.650174]  [<c15c5a95>] ? notifier_call_chain+0x45/0x60
> [  126.714543]  [<c107f61d>] ? update_curr+0x20d/0x380
> [  126.772681]  [<c1142f48>] ? __kmalloc+0xd8/0x1f0
> [  126.827715]  [<c11077f3>] ? mempool_kmalloc+0x13/0x20
> [  126.887935]  [<f85bb298>] ? aesni_set_key+0x1d8/0x1d8 [aesni_intel]
> [  126.962681]  [<f85bb960>] ? __aes_encrypt+0x30/0x30 [aesni_intel]
> [  127.035353]  [<f855e157>] ablk_decrypt+0x47/0xb0 [ablk_helper]
> [  127.104912]  [<f8ae1c9b>] crypt_convert+0x26b/0x2d0 [dm_crypt]
> [  127.174468]  [<f8ae23b0>] kcryptd_crypt+0x280/0x360 [dm_crypt]
> [  127.244028]  [<c10647a0>] process_one_work+0x110/0x380
> [  127.305282]  [<c15c97b3>] ? common_interrupt+0x33/0x38
> [  127.366537]  [<c10624a0>] ? wake_up_worker+0x30/0x30
> [  127.425716]  [<f8ae2130>] ? crypt_convert_init.isra.15+0x70/0x70
> [dm_crypt]
> [  127.508768]  [<c10651d9>] worker_thread+0x119/0x350
> [  127.566910]  [<c10650c0>] ? manage_workers+0x260/0x260
> [  127.628164]  [<c1069854>] kthread+0x94/0xa0
> [  127.678001]  [<c1070000>] ? blocking_notifier_chain_unregister+0x50/0xa0
> [  127.757938]  [<c15c91b7>] ret_from_kernel_thread+0x1b/0x28
> [  127.823350]  [<c10697c0>] ? flush_kthread_worker+0x90/0x90
> [  127.888757] Code: 31 c0 5f c3 8d 76 00 57 53 8b 7c 24 0c 8b 44 24 10 8b
> 54 24 14 8b 9f e0 01 00 00 0f 10 02 e8 08 00 00 00 0f 11 004
> [  128.113500] EIP: [<f85bb2bc>] _aesni_enc1+0x0/0x9c [aesni_intel] SS:ESP
> 0068:f169fd30
> [  128.207699] ---[ end trace ff0828d34a0b516e ]---
>
> subsequent errors after the above kernel crash (one cpu 100% busy) :
>
> [  128.262830] BUG: scheduling while atomic: kworker/0:1/55/0x10000001

.. snipped - not interesting, since a kworker dying will always result
in lots of noise.
