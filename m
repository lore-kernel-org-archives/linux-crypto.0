From: Christian Hohnstaedt <chohnstaedt@innominate.com>
Subject: Re: ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Wed, 25 Feb 2009 12:54:07 +0100
Message-ID: <20090225115407.GB6283@elara.bln.innominate.local>
References: <49A2E421.5050806@hiramoto.org> <49A3F3FA.1000801@hiramoto.org> <20090225090735.GA6283@elara.bln.innominate.local> <49A5110B.2050803@hiramoto.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Transfer-Encoding: 8bit
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:41833 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZBYLyL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 06:54:11 -0500
Content-Disposition: inline
In-Reply-To: <49A5110B.2050803@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Feb 25, 2009 at 10:36:11AM +0100, Karl Hiramoto wrote:
> Christian Hohnstaedt wrote:
> > On Tue, Feb 24, 2009 at 02:19:54PM +0100, Karl Hiramoto wrote:
> >   
> >> [42949542.250000] count_sg:758 len=0 sg_is_last(sg)=0
> >> [42949542.260000] kernel BUG at lib/scatterlist.c:26!
> >> [42949542.260000] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> >>     
> >
> > This differs from the issue you mentioned first.
> > The first one was in "dma_cache_maint".
> >
> >   
> When i turned on CONFIG_DEBUG_SG    i hit the BUG()      call in the
> scatterlist, instead of the dma_cache_maint..
> 
> 

looks like there are different, incompatible sg chaining implementations:

include/crypto/scatterwalk.h:scatterwalk_sg_chain()  uses
sg->lenght == 0 as indicator for a chained sg

include/linux/scatterlist.h:sg_chain() uses
bit 0 of sg->page_link to indicate chaining

Maybe the matters for b2ab4a57b018aafbba35bff088218f5cc3d2142e
are obsolete now...

However the scatterlist iteration in the arm implementation of
dma_map_sg() uses neither of them, but simply sg++

Please try the attached compile-tested patch.


Christian

-- 
Hardware
        n, "The parts of a computer system that can be kicked."
 — Henri Karrenbeld

--OgqxwSJOaUobr8KG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="scatterwalk.patch"

diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index aecc6c3..4948a3a 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -30,6 +30,7 @@
 #include <linux/dmapool.h>
 #include <linux/list.h>
 #include <linux/scatterlist.h>
+#include <crypto/scatterwalk.h>
 
 #include <asm/cacheflush.h>
 
@@ -442,7 +443,7 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 	BUG_ON(dir == DMA_NONE);
 
-	for (i = 0; i < nents; i++, sg++) {
+	for (i = 0; i < nents; i++, sg = scatterwalk_sg_next(sg)) {
 		struct page *page = sg_page(sg);
 		unsigned int offset = sg->offset;
 		unsigned int length = sg->length;
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 2d637e0..57c1c03 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -751,7 +751,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 static int count_sg(struct scatterlist *sg, int nbytes)
 {
 	int i;
-	for (i = 0; nbytes > 0; i++, sg = sg_next(sg))
+	for (i = 0; nbytes > 0; i++, sg = scatterwalk_sg_next(sg))
 		nbytes -= sg->length;
 	return i;
 }
@@ -795,7 +795,7 @@ static struct buffer_desc *chainup_buffers(struct scatterlist *sg,
 		buf->buf_len = len;
 next:
 		if (nbytes > 0) {
-			sg = sg_next(sg);
+			sg = scatterwalk_sg_next(sg);
 		}
 	}
 	return buf;
@@ -983,7 +983,7 @@ static int hmac_inconsistent(struct scatterlist *sg, unsigned start,
 			break;
 
 		offset += sg->length;
-		sg = sg_next(sg);
+		sg = scatterwalk_sg_next(sg);
 	}
 	return (start + nbytes > offset + sg->length);
 }

--OgqxwSJOaUobr8KG--
