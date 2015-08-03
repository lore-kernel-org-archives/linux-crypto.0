From: Aaron Sierra <asierra@xes-inc.com>
Subject: [PATCH v2] crypto: talitos: Remove zero_entry static initializer
Date: Mon, 3 Aug 2015 11:14:37 -0500 (CDT)
Message-ID: <926902712.309275.1438618477197.JavaMail.zimbra@xes-inc.com>
References: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:9603 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbbHCQPs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 12:15:48 -0400
In-Reply-To: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Compiling the talitos driver with my GCC 4.3.1 e500v2 cross-compiler
resulted in a failed build due to the anonymous union/structures
introduced in this commit:

  crypto: talitos - enhanced talitos_desc struct for SEC1

The build error was:

  drivers/crypto/talitos.h:56: error: unknown field 'len' specified in initializer
  drivers/crypto/talitos.h:56: warning: missing braces around initializer
  drivers/crypto/talitos.h:56: warning: (near initialization for 'zero_entry.<anonymous>')
  drivers/crypto/talitos.h:57: error: unknown field 'j_extent' specified in initializer
  drivers/crypto/talitos.h:58: error: unknown field 'eptr' specified in initializer
  drivers/crypto/talitos.h:58: warning: excess elements in struct initializer
  drivers/crypto/talitos.h:58: warning: (near initialization for 'zero_entry')
  make[2]: *** [drivers/crypto/talitos.o] Error 1
  make[1]: *** [drivers/crypto] Error 2
  make: *** [drivers] Error 2

This patch eliminates the errors by moving the static constant
zero_entry to the talitos_private structure. As a member of that
structure, zero_entry gets initialized for free (and compatibly) by
the kzalloc() during device probe.

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 drivers/crypto/talitos.c | 14 +++++++-------
 drivers/crypto/talitos.h |  8 +-------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 83aca95..5347570 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1663,7 +1663,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* first DWORD empty */
-	desc->ptr[0] = zero_entry;
+	desc->ptr[0] = priv->zero_entry;
 
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, is_sec1);
@@ -1693,7 +1693,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 			       DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
-	desc->ptr[6] = zero_entry;
+	desc->ptr[6] = priv->zero_entry;
 
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
@@ -1833,7 +1833,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* first DWORD empty */
-	desc->ptr[0] = zero_entry;
+	desc->ptr[0] = priv->zero_entry;
 
 	/* hash context in */
 	if (!req_ctx->first || req_ctx->swinit) {
@@ -1843,7 +1843,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       DMA_TO_DEVICE);
 		req_ctx->swinit = 0;
 	} else {
-		desc->ptr[1] = zero_entry;
+		desc->ptr[1] = priv->zero_entry;
 		/* Indicate next op is not the first. */
 		req_ctx->first = 0;
 	}
@@ -1853,7 +1853,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
 				       (char *)&ctx->key, DMA_TO_DEVICE);
 	else
-		desc->ptr[2] = zero_entry;
+		desc->ptr[2] = priv->zero_entry;
 
 	/*
 	 * data in
@@ -1862,7 +1862,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 			      DMA_TO_DEVICE, &desc->ptr[3]);
 
 	/* fifth DWORD empty */
-	desc->ptr[4] = zero_entry;
+	desc->ptr[4] = priv->zero_entry;
 
 	/* hash/HMAC out -or- hash context out */
 	if (req_ctx->last)
@@ -1875,7 +1875,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       req_ctx->hw_context, DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
-	desc->ptr[6] = zero_entry;
+	desc->ptr[6] = priv->zero_entry;
 
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 314daf5..153c56a 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -52,13 +52,6 @@ struct talitos_ptr {
 	__be32 ptr;     /* address */
 };
 
-static const struct talitos_ptr zero_entry = {
-	.len = 0,
-	.j_extent = 0,
-	.eptr = 0,
-	.ptr = 0
-};
-
 /* descriptor */
 struct talitos_desc {
 	__be32 hdr;                     /* header high bits */
@@ -142,6 +135,7 @@ struct talitos_private {
 	unsigned int fifo_len;
 
 	struct talitos_channel *chan;
+	const struct talitos_ptr zero_entry;
 
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan ____cacheline_aligned;
-- 
1.9.1
