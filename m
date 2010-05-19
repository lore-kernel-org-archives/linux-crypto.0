From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 5/4] Provide __dma_aligned macro
Date: Wed, 19 May 2010 14:49:08 +0100
Message-ID: <1274276948.6930.10117.camel@macbook.infradead.org>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274266725.6930.9823.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
	mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
	michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Frysinger <vapier@gentoo.org>,
	Nick Piggin <npiggin@suse.de>, os@emlix.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49797 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0ESNtn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 09:49:43 -0400
In-Reply-To: <1274266725.6930.9823.camel@macbook.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 3843384a055496dfed3c93ae883d964d8290fdab ("Input: ad7877 - keep
dma rx buffers in seperate cache lines")[sic] introduced the use of
____cacheline_aligned to ensure that buffers used for DMA as part of a
structure were suitably separated from the rest of the structure.

However, aligning to the cache line size isn't necessary on
cache-coherent architectures. To avoid wasting space, the correct value
to use for the alignment is ARCH_KMALLOC_MINALIGN.

This patch provides a __dma_aligned macro which does the right thing.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ca32ed7..4487cf3 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -5,6 +5,9 @@
 #include <linux/err.h>
 #include <linux/dma-attrs.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
+
+#define __dma_aligned __attribute__((__aligned__(ARCH_KMALLOC_MINALIGN)))
 
 /* These definitions mirror those in pci.h, so they can be used
  * interchangeably with their PCI_ counterparts */

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation
