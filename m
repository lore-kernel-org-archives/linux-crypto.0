From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/2] crypto: caamhash: - fix uninitialized
 edesc->sec4_sg_bytes field
Date: Fri, 6 Mar 2015 18:36:23 -0600
Message-ID: <20150306183623.64e5c6ca4453d70678819ce3@freescale.com>
References: <1425609282-16568-1-git-send-email-yanjiang.jin@windriver.com>
	<1425609282-16568-2-git-send-email-yanjiang.jin@windriver.com>
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
Received: from mail-bn1bon0113.outbound.protection.outlook.com ([157.56.111.113]:7529
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752659AbbCGAlo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 19:41:44 -0500
In-Reply-To: <1425609282-16568-2-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 6 Mar 2015 10:34:41 +0800
<yanjiang.jin@windriver.com> wrote:

> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> sec4_sg_bytes not being properly initialized causes ahash_done
> to try to free unallocated DMA memory:
> 
> caam_jr ffe301000.jr: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0xdeadbeefdeadbeef] [size=3735928559 bytes]
> ------------[ cut here ]------------
> WARNING: at lib/dma-debug.c:1093
> Modules linked in:
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.0.0-rc1+ #6
> task: e9598c00 ti: effca000 task.ti: e95a2000
> NIP: c04ef24c LR: c04ef24c CTR: c0549730
> REGS: effcbd40 TRAP: 0700   Not tainted  (4.0.0-rc1+)
> MSR: 00029002 <CE,EE,ME>  CR: 22008084  XER: 20000000
> 
> GPR00: c04ef24c effcbdf0 e9598c00 00000096 c08f7424 c00ab2b0 00000000 00000001
> GPR08: c0fe7510 effca000 00000000 000001c3 22008082 00000000 c1048e77 c1050000
> GPR16: c0c36700 493c0040 0000002c e690e4a0 c1054fb4 c18bac40 00029002 c18b0788
> GPR24: 00000014 e690e480 effcbe48 00000000 c0fde128 e6ffac10 deadbeef deadbeef
> NIP [c04ef24c] check_unmap+0x93c/0xb40
> LR [c04ef24c] check_unmap+0x93c/0xb40
> Call Trace:
> [effcbdf0] [c04ef24c] check_unmap+0x93c/0xb40 (unreliable)
> [effcbe40] [c04ef4f4] debug_dma_unmap_page+0xa4/0xc0
> [effcbec0] [c070cda8] ahash_done+0x128/0x1a0
> [effcbef0] [c0700070] caam_jr_dequeue+0x1d0/0x290
> [effcbf40] [c0045f40] tasklet_action+0x110/0x1f0
> [effcbf80] [c0044bc8] __do_softirq+0x188/0x700
> [effcbfe0] [c00455d8] irq_exit+0x108/0x120
> [effcbff0] [c000f520] call_do_irq+0x24/0x3c
> [e95a3e20] [c00059b8] do_IRQ+0xc8/0x170
> [e95a3e50] [c0011bc8] ret_from_except+0x0/0x18
> 
> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
> ---

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
