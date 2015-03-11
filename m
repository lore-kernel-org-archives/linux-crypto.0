From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt - fix uninit sg entries in
 test_acipher_speed
Date: Thu, 12 Mar 2015 01:12:48 +1100
Message-ID: <20150311141248.GA5713@gondor.apana.org.au>
References: <1425910498-9174-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Cristian Stoica <cristian.stoica@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:43963 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbCKOMv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 10:12:51 -0400
Content-Disposition: inline
In-Reply-To: <1425910498-9174-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 09, 2015 at 04:14:58PM +0200, Horia Geanta wrote:
> Commit 5be4d4c94b1f ("crypto: replace scatterwalk_sg_next with sg_next")
> did not consider the fact that scatterwalk_sg_next() was looking at
> sg entry length, while sg_next() looks at the "chained" sg bit.
> 
> This should have no effect in theory. However in practice, there are
> cases where the sg table is initialized to a number of entries and
> some of them are not properly configured. While scatterwalk_sg_next()
> would have returned NULL (since sg length = 0 and sg page_link = 0),
> sg_next() happily returns the next unconfigured sg entry.
> 
> insmod tcrypt.ko mode=500 sec=1
> 
> testing speed of async cbc(aes) (cbc-aes-talitos) encryption
> test 0 (128 bit key, 16 byte blocks):
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc00d79e4
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=8 P1022 DS
> Modules linked in: tcrypt(+) talitos
> CPU: 0 PID: 2670 Comm: insmod Not tainted 4.0.0-rc1-QorIQ-SDK-V1.6+g904f1ca82209 #1
> task: e8de3200 ti: e70bc000 task.ti: e70bc000
> NIP: c00d79e4 LR: f92d223c CTR: c00d79c8
> REGS: e70bda00 TRAP: 0300   Not tainted  (4.0.0-rc1-QorIQ-SDK-V1.6+g904f1ca82209)
> MSR: 00029000 <CE,EE,ME>  CR: 84428f22  XER: 00000000
> DEAR: 00000000 ESR: 00000000
> GPR00: f92d223c e70bdab0 e8de3200 00000000 e70bdbb8 00000001 00000000 00000000
> GPR08: 00000000 00000000 c08b0380 27282010 c00d79c8 1003a634 00000000 e70bdf1c
> GPR16: e70bdef0 00000020 00000000 c08c0000 00000010 00000000 e70bdbb8 00000010
> GPR24: e976d3a8 00000010 00000000 e70bdbd8 e8961010 00000001 c086e560 00000000
> NIP [c00d79e4] page_address+0x1c/0x110
> LR [f92d223c] talitos_map_sg+0x130/0x184 [talitos]
> Call Trace:
> [e70bdab0] [00000010] 0x10 (unreliable)
> [e70bdad0] [f92d223c] talitos_map_sg+0x130/0x184 [talitos]
> [e70bdb00] [f92d30d8] common_nonsnoop.constprop.13+0xc0/0x304 [talitos]
> [e70bdb30] [f933fd90] test_acipher_speed+0x434/0x7dc [tcrypt]
> [e70bdcc0] [f934318c] do_test+0x2478/0x306c [tcrypt]
> [e70bdd80] [f11fe058] tcrypt_mod_init+0x58/0x100 [tcrypt]
> [e70bdda0] [c0002354] do_one_initcall+0x90/0x1f4
> [e70bde10] [c061fe00] do_init_module+0x60/0x1ac
> [e70bde30] [c00a79f0] load_module+0x185c/0x1f88
> [e70bdee0] [c00a82b0] SyS_finit_module+0x7c/0x98
> [e70bdf40] [c000e8b0] ret_from_syscall+0x0/0x3c
> --- interrupt: c01 at 0xff1985c
>     LR = 0x10012df0
> Instruction dump:
> 54ea402e 7d494b78 55292834 7c634a14 4e800020 9421ffe0 7c0802a6 3d40c08b
> 394a0380 bf61000c 7c7f1b78 90010024 <81230000> 552917be 1d290320 7d295214
> ---[ end trace ff191e5b504b4671 ]---
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
