From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] crypto: marvell/cesa - replace dma_to_phys with
 dma_map_single
Date: Thu, 17 Mar 2016 23:50:20 +0000
Message-ID: <20160317235020.GB19428@n2100.arm.linux.org.uk>
References: <1458252137-24497-1-git-send-email-okaya@codeaurora.org>
 <20160317225459.GA19428@n2100.arm.linux.org.uk>
 <80402e2f82651814b1411a25b1740288@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, timur@codeaurora.org,
	cov@codeaurora.org, nwatters@codeaurora.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: okaya@codeaurora.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42359 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbcCQXui (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Mar 2016 19:50:38 -0400
Content-Disposition: inline
In-Reply-To: <80402e2f82651814b1411a25b1740288@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 17, 2016 at 07:17:24PM -0400, okaya@codeaurora.org wrote:
> What is the correct way? I don't want to write engine->sram_dma = sram

Well, what the driver _is_ wanting to do is to go from a CPU physical
address to a device DMA address.  phys_to_dma() looks like the correct
thing there to me, but I guess that's just an offset and doesn't take
account of any IOMMU that may be in the way.

If you have an IOMMU, then the whole phys_to_dma() thing is a total
failure as it only does a linear translation, and there are no
interfaces in the kernel to take account of an IOMMU in the way.  So,
it needs something designed for the job, implemented and discussed by
the normal methods of proposing a new cross-arch interface for drivers
to use.

What I'm certain of, though, is that the change proposed in this patch
will break current users of this driver: virt_to_page() on an address
returned by ioremap() is completely undefined, and will result in
either a kernel oops, or if not poking at memory which isn't a struct
page, ultimately resulting in something that isn't SRAM being pointed
to by "engine->sram_dma".

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
