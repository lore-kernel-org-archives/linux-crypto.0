From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] crypto: caam_rng: fix rng_unmap_ctx's DMA_UNMAP
 size problem
Date: Fri, 6 Mar 2015 18:37:12 -0600
Message-ID: <20150306183712.4486a7905cfd4a571244b04d@freescale.com>
References: <1425609282-16568-1-git-send-email-yanjiang.jin@windriver.com>
	<1425609282-16568-3-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: <yanjiang.jin@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:1979
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756348AbbCGA6L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 19:58:11 -0500
In-Reply-To: <1425609282-16568-3-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 6 Mar 2015 10:34:42 +0800
<yanjiang.jin@windriver.com> wrote:

> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> Fix rng_unmap_ctx's DMA_UNMAP size problem for caam_rng, else system would
> report the below calltrace during cleanup caam_rng.
> Since rng_create_sh_desc() creates a fixed descriptor of exactly 4
> command-lengths now, also update DESC_RNG_LEN to (4 * CAAM_CMD_SZ).
> 
> caam_jr ffe301000.jr: DMA-API: device driver frees DMA memory with different size [device address=0x000000007f080010] [map size=16 bytes] [unmap size=40 bytes]
> ------------[ cut here ]------------
> WARNING: at lib/dma-debug.c:887
> Modules linked in:
> task: c0000000f7cdaa80 ti: c0000000e5340000 task.ti: c0000000e5340000
> NIP: c0000000004f5bc8 LR: c0000000004f5bc4 CTR: c0000000005f69b0
> REGS: c0000000e53433c0 TRAP: 0700   Not tainted
> MSR: 0000000080029000 <CE,EE,ME>  CR: 24088482  XER: 00000000
> SOFTE: 0
> 
> GPR00: c0000000004f5bc4 c0000000e5343640 c0000000012af360 000000000000009f
> GPR04: 0000000000000000 00000000000000a0 c000000000d02070 c000000015980660
> GPR08: c000000000cff360 0000000000000000 0000000000000000 c0000000012da018
> GPR12: 00000000000001e3 c000000001fff780 00000000100f0000 0000000000000001
> GPR16: 0000000000000002 0000000000000000 0000000000000000 0000000000000000
> GPR20: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000001
> GPR24: 0000000000000001 0000000000000001 0000000000000000 0000000000000001
> GPR28: c000000001556b90 c000000001565b80 c0000000e5343750 c0000000f9427480
> NIP [c0000000004f5bc8] .check_unmap+0x538/0x9c0
> LR [c0000000004f5bc4] .check_unmap+0x534/0x9c0
> Call Trace:
> [c0000000e5343640] [c0000000004f5bc4] .check_unmap+0x534/0x9c0 (unreliable)
> [c0000000e53436e0] [c0000000004f60d4] .debug_dma_unmap_page+0x84/0xb0
> [c0000000e5343810] [c00000000082f9d4] .caam_cleanup+0x1d4/0x240
> [c0000000e53438a0] [c00000000056cc88] .hwrng_unregister+0xd8/0x1c0
> Instruction dump:
> 7c641b78 41de0410 e8a90050 2fa50000 419e0484 e8de0028 e8ff0030 3c62ff90
> e91e0030 38638388 48546ed9 60000000 <0fe00000> 3c62ff8f 38637fc8 48546ec5
> ---[ end trace e43fd1734d6600df ]---
> 
> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
> ---

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
