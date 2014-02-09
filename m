From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos: init the priv->alg_list more earlier in
 talitos_probe()
Date: Sun, 9 Feb 2014 17:21:30 +0800
Message-ID: <20140209092130.GE19429@gondor.apana.org.au>
References: <1390911443-17936-1-git-send-email-haokexin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Kevin Hao <haokexin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50329 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaBIJVc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Feb 2014 04:21:32 -0500
Content-Disposition: inline
In-Reply-To: <1390911443-17936-1-git-send-email-haokexin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 28, 2014 at 08:17:23PM +0800, Kevin Hao wrote:
> In function talitos_probe(), it will jump to err_out when getting an
> error in talitos_probe_irq(). Then the uninitialized list head
> priv->alg_list will be used in function talitos_remove(). In this case
> we would get a call trace like the following. So move up the
> initialization of priv->alg_list.
> 
>   Unable to handle kernel paging request for data at address 0x00000000
>   Faulting instruction address: 0xc0459ff4
>   Oops: Kernel access of bad area, sig: 11 [#1]
>   SMP NR_CPUS=8 P1020 RDB
>   Modules linked in:
>   CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-08789-g54c0a4b46150 #33
>   task: cf050000 ti: cf04c000 task.ti: cf04c000
>   NIP: c0459ff4 LR: c0459fd4 CTR: c02f2438
>   REGS: cf04dcb0 TRAP: 0300   Tainted: G        W     (3.13.0-08789-g54c0a4b46150)
>   MSR: 00029000 <CE,EE,ME>  CR: 82000028  XER: 20000000
>   DEAR: 00000000 ESR: 00000000
>   GPR00: c045ac28 cf04dd60 cf050000 cf2579c0 00021000 00000000 c02f35b0 0000014e
>   GPR08: c07e702c cf104300 c07e702c 0000014e 22000024 00000000 c0002a3c 00000000
>   GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 c082e4e0 000000df
>   GPR24: 00000000 00100100 00200200 cf257a2c cf0efe10 cf2579c0 cf0efe10 00000000
>   NIP [c0459ff4] talitos_remove+0x3c/0x1c8
>   LR [c0459fd4] talitos_remove+0x1c/0x1c8
>   Call Trace:
>   [cf04dd60] [c07485d8] __func__.13331+0x1241c8/0x1391c0 (unreliable)
>   [cf04dd90] [c045ac28] talitos_probe+0x244/0x998
>   [cf04dde0] [c0306a74] platform_drv_probe+0x28/0x68
>   [cf04ddf0] [c0304d38] really_probe+0x78/0x250
>   [cf04de10] [c030505c] __driver_attach+0xc8/0xcc
>   [cf04de30] [c0302e98] bus_for_each_dev+0x6c/0xb8
>   [cf04de60] [c03043cc] bus_add_driver+0x168/0x220
>   [cf04de80] [c0305798] driver_register+0x88/0x130
>   [cf04de90] [c0002458] do_one_initcall+0x14c/0x198
>   [cf04df00] [c079f904] kernel_init_freeable+0x138/0x1d4
>   [cf04df30] [c0002a50] kernel_init+0x14/0x124
>   [cf04df40] [c000ec40] ret_from_kernel_thread+0x5c/0x64
> 
> Signed-off-by: Kevin Hao <haokexin@gmail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
