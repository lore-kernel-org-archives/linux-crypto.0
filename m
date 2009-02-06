From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: LRW endian issues?
Date: Fri, 6 Feb 2009 11:18:46 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902061117570.26894@vixen.sonytel.be>
References: <20090206040124.GA4299@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: rsnel@cube.dyndns.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65047 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752705AbZBFKSs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2009 05:18:48 -0500
In-Reply-To: <20090206040124.GA4299@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 6 Feb 2009, Herbert Xu wrote:
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > When running "modprobe tcrypt mode=3D10" on ppc64 (PS3), I get the =
following
> > error:
> >=20
> > | alg: skcipher: Test 8 failed on encryption for lrw(aes-generic)
> > | 00000000: 1a 1d a9 30 ad f9 2f 9b b6 1d ae ef f0 2f f8 5a=20
> > | 00000010: 3d de 22 4d 7e b1 75 e0 d2 db 9e ba 64 b2 5d 93=20
> > | 00000020: 4d 14 3d b8 5b 80 9d 57 2e 64 c7 95 d8 b5 a7 3b=20
> > | 00000030: 3d 39 8a 9b 59 1c 73 12 2f 58 00 6f 28 3f 72 23=20
> > | 00000040: ad 75 cd c0 17 2b bf 62 d2 b2 f9 b7 3f de 3e 83=20
> > | 00000050: f2 fa e2 3a e3 03 14 84 3b 47 0e 94 ad 7f e0 dc=20
> > | 00000060: 13 c7 56 75 3c 8f 38 88 dd 7f b7 44 b9 30 aa f6=20
> > | 00000070: 61 dc b7 4d 72 7e 43 3e 19 a9 fb 1b d4 18 d6 1c=20
> > | 00000080: 1d 73 9b 47 7a c9 c7 4b 30 2a 12 4f d7 1e eb bc=20
> > | 00000090: e3 13 5b 1c f0 41 33 ae f8 81 a4 54 42 d0 fc 6c=20
> > | 000000a0: 65 c5 b2 d8 96 43 ba 11 8d 89 a7 4d 75 e4 3e 07=20
> > | 000000b0: 82 11 74 47 70 ff 37 5d 03 ef ec 1d 43 9b 28 10=20
> > | 000000c0: ea 67 4e f9 10 9a f4 70 36 e6 af db cb 05 22 54=20
> > | 000000d0: 56 41 fa 15 01 c3 ed ce 2f 15 35 df 0e fc 88 bc=20
> > | 000000e0: c1 a9 df 2e 25 74 64 5a 21 81 e7 7d 43 ea 85 fc=20
> > | 000000f0: 50 d2 5c e6 70 be 56 8a dc cb d1 c3 98 e5 d8 0d=20
> > | 00000100: c5 93 2a 30 b7 0e 29 44 6a a4 ca 64 f8 a8 21 6a=20
> > | 00000110: 48 8e fc 5f e7 d7 d3 73 20 e6 fe 97 cd d4 33 2e=20
> > | 00000120: 0c 57 0c 55 15 e4 4e 62 cf 6a 0a 5f b0 c0 2e da=20
> > | 00000130: 86 f8 97 7b 8c ba fc 28 11 29 60 a1 84 0e 4d be=20
> > | 00000140: 75 04 45 8d 9b 43 e9 69 e3 46 87 8d 4c c9 c9 e8=20
> > | 00000150: cf 35 82 38 c8 91 13 db cd 4e 8f 39 13 0f fd c9=20
> > | 00000160: 70 73 d2 8d e3 1b 2b 3b 1d b2 bc 53 bc 05 ca 69=20
> > | 00000170: ee c7 62 77 4e 40 d2 88 7e 1b 81 54 38 9d 98 f1=20
> > | 00000180: ef cb dd 4b 14 50 fe 57 0a 2c 5c ed 27 a8 de e3=20
> > | 00000190: 73 c1 55 d3 43 1a f0 98 54 7c 82 9f 7b fa 48 5c=20
> > | 000001a0: b5 b9 90 e2 62 f4 5d 3d 28 34 34 52 47 58 9d ec=20
> > | 000001b0: d3 82 07 aa 75 c1 7e f5 03 1f 7f 4b 89 ac a9 89=20
> > | 000001c0: 3c 91 85 7e 5f 70 00 20 55 aa 31 84 3c a9 d2 44=20
> > | 000001d0: 88 da 71 71 d8 e0 c3 86 c6 6e c2 5e cb 5a 6c fc=20
> > | 000001e0: a7 52 0d bf 42 0e c2 fa 9f 59 a6 9b ca 4d fa 50=20
> > | 000001f0: 02 fa 55 94 a7 d0 5b 68 3c 35 49 0f 49 d4 3d b4=20
>=20
> I'll look into it.
>=20
> > and the modprobe hangs.
>=20
> That's not supposed to happen.  Could you get a stack backtrace
> to see why it's hanging?

Here's a backtrace from the RCU stall detector on PS3:

| INFO: RCU detected CPU 1 stall (t=3D4294906597/2500 jiffies)
| Call Trace:
| [c00000000c186fc0] [c00000000000f850] .show_stack+0x6c/0x16c (unrelia=
ble)
| [c00000000c187070] [c000000000098a04] .__rcu_pending+0x94/0x2c0
| [c00000000c187110] [c000000000098c7c] .rcu_pending+0x4c/0xa4
| [c00000000c1871b0] [c00000000005fa04] .update_process_times+0x40/0x94
| [c00000000c187240] [c00000000007b25c] .tick_sched_timer+0x154/0x1ac
| [c00000000c187300] [c000000000070df4] .__run_hrtimer+0x8c/0xfc
| [c00000000c1873a0] [c000000000071e6c] .hrtimer_interrupt+0x144/0x1e8
| [c00000000c187490] [c00000000001d46c] .timer_interrupt+0xb0/0xe4
| [c00000000c187520] [c00000000000360c] decrementer_common+0x10c/0x180
| --- Exception: 901 at .crypto_alg_mod_lookup+0x4/0xa8
|     LR =3D .crypto_lookup_skcipher+0x38/0x2b8
| [c00000000c187810] [c0000000001bf790] .crypto_lookup_skcipher+0x284/0=
x2b8 (unreliable)
| [c00000000c187930] [c0000000001bf824] .crypto_alloc_ablkcipher+0x60/0=
xf4
| [c00000000c1879e0] [c0000000001c6454] .alg_test_skcipher+0x38/0xdc
| [c00000000c187a70] [c0000000001c6728] .alg_test+0x17c/0x1f8
| [c00000000c187b60] [d0000000026f21f0] .do_test+0x444/0xe34 [tcrypt]
| [c00000000c187c10] [d0000000026f2c48] .tcrypt_mod_init+0x64/0x41c [tc=
rypt]
| [c00000000c187ca0] [c000000000007eec] .do_one_initcall+0x80/0x1a4
| [c00000000c187d90] [c00000000008bcf8] .SyS_init_module+0xd8/0x234
| [c00000000c187e30] [c0000000000074dc] syscall_exit+0x0/0x40
| INFO: RCU detected CPU 1 stall (t=3D4294914102/10005 jiffies)
| Call Trace:
| [c00000000c186c10] [c00000000000f850] .show_stack+0x6c/0x16c (unrelia=
ble)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
