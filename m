From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/4] scatterlist: add sg_alloc_table_from_buf() helper
Date: Thu, 31 Mar 2016 15:14:13 +0100
Message-ID: <20160331141412.GK19428@n2100.arm.linux.org.uk>
References: <1459427384-21374-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459427384-21374-3-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vinod Koul <vinod.koul@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
	linux-spi@vger.kernel.org, Vignesh R <vigneshr@ti.com>,
	linux-mm@kvack.org, iommu@lists.linux-foundation.org,
	Mark Brown <broonie@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-media@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:44795 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbcCaOOn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Mar 2016 10:14:43 -0400
Content-Disposition: inline
In-Reply-To: <1459427384-21374-3-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 31, 2016 at 02:29:42PM +0200, Boris Brezillon wrote:
> sg_alloc_table_from_buf() provides an easy solution to create an sg_table
> from a virtual address pointer. This function takes care of dealing with
> vmallocated buffers, buffer alignment, or DMA engine limitations (maximum
> DMA transfer size).

Please note that the DMA API does not take account of coherency of memory
regions other than non-high/lowmem - there are specific extensions to
deal with this.

What this means is that having an API that takes any virtual address
pointer, converts it to a scatterlist which is then DMA mapped, is
unsafe.

It'll be okay for PIPT and non-aliasing VIPT cache architectures, but
for other cache architectures this will hide this problem and make
review harder.

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
