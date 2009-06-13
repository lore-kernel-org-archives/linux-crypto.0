From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Sat, 13 Jun 2009 12:07:26 +0200
Message-ID: <20090613100726.GA31922@Chamillionaire.breakpoint.cc>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc> <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc> <alpine.LFD.2.00.0906111513420.31536@xanadu.home> <20090611201530.GA11486@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111625280.31536@xanadu.home> <20090611210734.GA11920@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Nicolas Pitre <nico@cam.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48901 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZFMKIJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Jun 2009 06:08:09 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Nicolas Pitre | 2009-06-11 17:19:22 [-0400]:

>> >What is your plan for this driver?  Submit it now and add incremental 
>> >improvements afterward or wait until it is more functional?
>> I would like to get it squeezed into this merge window unless there are
>> any objections and improve it afterwards.
>> If you thing it is too early I can keep hacking in my own git tree until
>> I get the dmac_flush_range() hack out or so.
>
>I have no problem with you submitting it now.  It is not complete yet 
>but what is there is plenty functional.  However I'd prefer if you used 
>the API based on sg_copy_buffer() which includes a call to 
>flush_kernel_dcache_page() already for mainline inclusion, so to have 
>good style up front. ( a patch to fix flush_kernel_dcache_page() on ARM 
>is already queued).
sg_copy_from_buffer() since the other one is static. I'm little unhappy
with it because this forces me to have the entire buffer "ready". This
is not a problem for dm-crypt because I get just one scatterlist entry
with 512 bytes. I don't know about others but this will put a
limitation / break them.

It looks like sg_miter_start() which is exported doesn't provide the
the required flush interface. What about:

--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -259,12 +259,6 @@ static void dequeue_complete_req(void)
 		dst_copy = min(cpg->p.crypt_len, cpg->p.sg_dst_left);
 
 		memcpy(buf, cpg->sram + SRAM_DATA_OUT_START, dst_copy);
-		/*
-		 * XXX This is a temporary hack to flush data from cache back
-		 * into phys ram so user space sees correct data. This goes
-		 * away as soon as DMA support is added to this driver
-		 */
-		dmac_flush_range(buf, buf + dst_copy);
 
 		cpg->p.sg_dst_left -= dst_copy;
 		cpg->p.crypt_len -= dst_copy;
@@ -309,7 +303,7 @@ static void mv_enqueue_new_req(struct ablkcipher_request *req)
 	sg_miter_start(&cpg->p.src_sg_it, req->src, num_sgs, 0);
 
 	num_sgs = count_sgs(req->dst, req->nbytes);
-	sg_miter_start(&cpg->p.dst_sg_it, req->dst, num_sgs, 0);
+	sg_miter_start(&cpg->p.dst_sg_it, req->dst, num_sgs, SG_MITER_FLUSH_CACHE);
 	mv_process_current_q(1);
 }
 
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index e599698..8f98450 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -242,6 +242,7 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
  */
 
 #define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
+#define SG_MITER_FLUSH_CACHE	(1 << 1)	 /* flash cache on unmap */
 
 struct sg_mapping_iter {
 	/* the following three fields can be accessed directly */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a295e40..4b07f7a 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -394,6 +394,9 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
 
+		if (miter->__flags & SG_MITER_FLUSH_CACHE)
+			flush_kernel_dcache_page(miter->page);
+
 		if (miter->__flags & SG_MITER_ATOMIC) {
 			WARN_ON(!irqs_disabled());
 			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
-- 
1.6.0.6


>
>
>Nicolas

Sebastian
