From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-des: Fix unmapping of dma channels
Date: Mon, 6 Jul 2015 16:29:42 +0800
Message-ID: <20150706082942.GA20741@gondor.apana.org.au>
References: <1435842208-31382-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57904 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbGFI3r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 04:29:47 -0400
Content-Disposition: inline
In-Reply-To: <1435842208-31382-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2015 at 06:33:28PM +0530, Lokesh Vutla wrote:
> dma_unmap_sg() is being called twice after completing the
> task. Looks like this is a copy paste error when creating
> des driver.
> With this the following warn appears during boot:
> 
> [    4.210457] ------------[ cut here ]------------
> [    4.215114] WARNING: CPU: 0 PID: 0 at lib/dma-debug.c:1080 check_unmap+0x710/0x9a0()
> [    4.222899] omap-des 480a5000.des: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x00000000ab2ce000] [size=8 bytes]
> [    4.236785] Modules linked in:
> [    4.239860] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.39-02999-g1bc045a-dirty #182
> [    4.247918] [<c001678c>] (unwind_backtrace) from [<c0012574>] (show_stack+0x10/0x14)
> [    4.255710] [<c0012574>] (show_stack) from [<c05a37e8>] (dump_stack+0x84/0xb8)
> [    4.262977] [<c05a37e8>] (dump_stack) from [<c0046464>] (warn_slowpath_common+0x68/0x8c)
> [    4.271107] [<c0046464>] (warn_slowpath_common) from [<c004651c>] (warn_slowpath_fmt+0x30/0x40)
> [    4.279854] [<c004651c>] (warn_slowpath_fmt) from [<c02d50a4>] (check_unmap+0x710/0x9a0)
> [    4.287991] [<c02d50a4>] (check_unmap) from [<c02d5478>] (debug_dma_unmap_sg+0x90/0x19c)
> [    4.296128] [<c02d5478>] (debug_dma_unmap_sg) from [<c04a77d8>] (omap_des_done_task+0x1cc/0x3e4)
> [    4.304963] [<c04a77d8>] (omap_des_done_task) from [<c004a090>] (tasklet_action+0x84/0x124)
> [    4.313370] [<c004a090>] (tasklet_action) from [<c004a4ac>] (__do_softirq+0xf0/0x20c)
> [    4.321235] [<c004a4ac>] (__do_softirq) from [<c004a840>] (irq_exit+0x98/0xec)
> [    4.328500] [<c004a840>] (irq_exit) from [<c000f9ac>] (handle_IRQ+0x50/0xb0)
> [    4.335589] [<c000f9ac>] (handle_IRQ) from [<c0008688>] (gic_handle_irq+0x28/0x5c)
> 
> Removing the duplicate call to dma_unmap_sg().
> 
> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
