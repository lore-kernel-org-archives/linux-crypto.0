From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 06/17] crypto: talitos - Add talitos2.c to isolate SEC2 specific functions
Date: Fri,  6 Mar 2015 17:39:25 +0100 (CET)
Message-ID: <20150306163925.B4C071A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:54004 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbbCFQj2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 11:39:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC1 doesn't have IPSec descriptor, so all functions using that descriptor
are specific to SEC2. This patch moves them in a new talitos2.c file
dedicated to SEC2

We also move to talitos2.c all the functions that will be different for
SEC1, like the handling of mapping/unmapping of input/output scatterlists

We move to talitos.h some of the helpers that are used by both talitos.c
and talitos2.c

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/Kconfig    |   4 +
 drivers/crypto/Makefile   |   1 +
 drivers/crypto/talitos.c  | 666 +---------------------------------------------
 drivers/crypto/talitos.h  | 133 +++++++++
 drivers/crypto/talitos2.c | 614 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 758 insertions(+), 660 deletions(-)
 create mode 100644 drivers/crypto/talitos2.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2fb0fdf..4fd6d7e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -211,6 +211,7 @@ config CRYPTO_DEV_TALITOS
 	select CRYPTO_ALGAPI
 	select CRYPTO_AUTHENC
 	select HW_RANDOM
+	select CRYPTO_DEV_TALITOS2
 	depends on FSL_SOC
 	help
 	  Say 'Y' here to use the Freescale Security Engine (SEC)
@@ -222,6 +223,9 @@ config CRYPTO_DEV_TALITOS
 	  To compile this driver as a module, choose M here: the module
 	  will be called talitos.
 
+config CRYPTO_DEV_TALITOS2
+	bool
+
 config CRYPTO_DEV_IXP4XX
 	tristate "Driver for IXP4xx crypto hardware acceleration"
 	depends on ARCH_IXP4XX && IXP4XX_QMGR && IXP4XX_NPE
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 3924f93..f26159f 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
+obj-$(CONFIG_CRYPTO_DEV_TALITOS2) += talitos2.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
 obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 76e636b..114c5e5 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -55,39 +55,6 @@
 
 #include "talitos.h"
 
-static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_addr_t dma_addr)
-{
-	talitos_ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	talitos_ptr->eptr = upper_32_bits(dma_addr);
-}
-
-/*
- * map virtual single (contiguous) pointer to h/w descriptor pointer
- */
-static void map_single_talitos_ptr(struct device *dev,
-				   struct talitos_ptr *talitos_ptr,
-				   unsigned short len, void *data,
-				   unsigned char extent,
-				   enum dma_data_direction dir)
-{
-	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
-
-	talitos_ptr->len = cpu_to_be16(len);
-	to_talitos_ptr(talitos_ptr, dma_addr);
-	talitos_ptr->j_extent = extent;
-}
-
-/*
- * unmap bus single (contiguous) h/w descriptor pointer
- */
-static void unmap_single_talitos_ptr(struct device *dev,
-				     struct talitos_ptr *talitos_ptr,
-				     enum dma_data_direction dir)
-{
-	dma_unmap_single(dev, be32_to_cpu(talitos_ptr->ptr),
-			 be16_to_cpu(talitos_ptr->len), dir);
-}
-
 static unsigned int do_reset_channel(struct talitos_private *priv, int ch)
 {
 	unsigned int timeout = TALITOS_TIMEOUT;
@@ -646,20 +613,6 @@ static void talitos_unregister_rng(struct device *dev)
  * crypto alg
  */
 #define TALITOS_CRA_PRIORITY		3000
-#define TALITOS_MAX_KEY_SIZE		96
-#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
-
-struct talitos_ctx {
-	struct device *dev;
-	int ch;
-	__be32 desc_hdr_template;
-	u8 key[TALITOS_MAX_KEY_SIZE];
-	u8 iv[TALITOS_MAX_IV_LENGTH];
-	unsigned int keylen;
-	unsigned int enckeylen;
-	unsigned int authkeylen;
-	unsigned int authsize;
-};
 
 #define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
 #define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
@@ -678,426 +631,6 @@ struct talitos_ahash_req_ctx {
 	struct scatterlist *psrc;
 };
 
-static int aead_setauthsize(struct crypto_aead *authenc,
-			    unsigned int authsize)
-{
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-
-	ctx->authsize = authsize;
-
-	return 0;
-}
-
-static int aead_setkey(struct crypto_aead *authenc,
-		       const u8 *key, unsigned int keylen)
-{
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct crypto_authenc_keys keys;
-
-	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
-		goto badkey;
-
-	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
-		goto badkey;
-
-	memcpy(ctx->key, keys.authkey, keys.authkeylen);
-	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
-
-	ctx->keylen = keys.authkeylen + keys.enckeylen;
-	ctx->enckeylen = keys.enckeylen;
-	ctx->authkeylen = keys.authkeylen;
-
-	return 0;
-
-badkey:
-	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
-}
-
-/*
- * talitos_edesc - s/w-extended descriptor
- * @assoc_nents: number of segments in associated data scatterlist
- * @src_nents: number of segments in input scatterlist
- * @dst_nents: number of segments in output scatterlist
- * @assoc_chained: whether assoc is chained or not
- * @src_chained: whether src is chained or not
- * @dst_chained: whether dst is chained or not
- * @iv_dma: dma address of iv for checking continuity and link table
- * @dma_len: length of dma mapped link_tbl space
- * @dma_link_tbl: bus physical address of link_tbl
- * @desc: h/w descriptor
- * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
- *
- * if decrypting (with authcheck), or either one of src_nents or dst_nents
- * is greater than 1, an integrity check value is concatenated to the end
- * of link_tbl data
- */
-struct talitos_edesc {
-	int assoc_nents;
-	int src_nents;
-	int dst_nents;
-	bool assoc_chained;
-	bool src_chained;
-	bool dst_chained;
-	dma_addr_t iv_dma;
-	int dma_len;
-	dma_addr_t dma_link_tbl;
-	struct talitos_desc desc;
-	struct talitos_ptr link_tbl[0];
-};
-
-static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
-			  unsigned int nents, enum dma_data_direction dir,
-			  bool chained)
-{
-	if (unlikely(chained))
-		while (sg) {
-			dma_map_sg(dev, sg, 1, dir);
-			sg = sg_next(sg);
-		}
-	else
-		dma_map_sg(dev, sg, nents, dir);
-	return nents;
-}
-
-static void talitos_unmap_sg_chain(struct device *dev, struct scatterlist *sg,
-				   enum dma_data_direction dir)
-{
-	while (sg) {
-		dma_unmap_sg(dev, sg, 1, dir);
-		sg = sg_next(sg);
-	}
-}
-
-static void talitos_sg_unmap(struct device *dev,
-			     struct talitos_edesc *edesc,
-			     struct scatterlist *src,
-			     struct scatterlist *dst)
-{
-	unsigned int src_nents = edesc->src_nents ? : 1;
-	unsigned int dst_nents = edesc->dst_nents ? : 1;
-
-	if (src != dst) {
-		if (edesc->src_chained)
-			talitos_unmap_sg_chain(dev, src, DMA_TO_DEVICE);
-		else
-			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
-
-		if (dst) {
-			if (edesc->dst_chained)
-				talitos_unmap_sg_chain(dev, dst,
-						       DMA_FROM_DEVICE);
-			else
-				dma_unmap_sg(dev, dst, dst_nents,
-					     DMA_FROM_DEVICE);
-		}
-	} else
-		if (edesc->src_chained)
-			talitos_unmap_sg_chain(dev, src, DMA_BIDIRECTIONAL);
-		else
-			dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
-}
-
-static void ipsec_esp_unmap(struct device *dev,
-			    struct talitos_edesc *edesc,
-			    struct aead_request *areq)
-{
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6], DMA_FROM_DEVICE);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[3], DMA_TO_DEVICE);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
-
-	if (edesc->assoc_chained)
-		talitos_unmap_sg_chain(dev, areq->assoc, DMA_TO_DEVICE);
-	else if (areq->assoclen)
-		/* assoc_nents counts also for IV in non-contiguous cases */
-		dma_unmap_sg(dev, areq->assoc,
-			     edesc->assoc_nents ? edesc->assoc_nents - 1 : 1,
-			     DMA_TO_DEVICE);
-
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
-
-	if (edesc->dma_len)
-		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
-				 DMA_BIDIRECTIONAL);
-}
-
-/*
- * ipsec_esp descriptor callbacks
- */
-static void ipsec_esp_encrypt_done(struct device *dev,
-				   struct talitos_desc *desc, void *context,
-				   int err)
-{
-	struct aead_request *areq = context;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
-	void *icvdata;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
-	ipsec_esp_unmap(dev, edesc, areq);
-
-	/* copy the generated ICV to dst */
-	if (edesc->dst_nents) {
-		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2 +
-					   edesc->assoc_nents];
-		sg = sg_last(areq->dst, edesc->dst_nents);
-		memcpy((char *)sg_virt(sg) + sg->length - ctx->authsize,
-		       icvdata, ctx->authsize);
-	}
-
-	kfree(edesc);
-
-	aead_request_complete(areq, err);
-}
-
-static void ipsec_esp_decrypt_swauth_done(struct device *dev,
-					  struct talitos_desc *desc,
-					  void *context, int err)
-{
-	struct aead_request *req = context;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
-	void *icvdata;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
-	ipsec_esp_unmap(dev, edesc, req);
-
-	if (!err) {
-		/* auth check */
-		if (edesc->dma_len)
-			icvdata = &edesc->link_tbl[edesc->src_nents +
-						   edesc->dst_nents + 2 +
-						   edesc->assoc_nents];
-		else
-			icvdata = &edesc->link_tbl[0];
-
-		sg = sg_last(req->dst, edesc->dst_nents ? : 1);
-		err = memcmp(icvdata, (char *)sg_virt(sg) + sg->length -
-			     ctx->authsize, ctx->authsize) ? -EBADMSG : 0;
-	}
-
-	kfree(edesc);
-
-	aead_request_complete(req, err);
-}
-
-static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
-					  struct talitos_desc *desc,
-					  void *context, int err)
-{
-	struct aead_request *req = context;
-	struct talitos_edesc *edesc;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
-	ipsec_esp_unmap(dev, edesc, req);
-
-	/* check ICV auth status */
-	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
-		     DESC_HDR_LO_ICCR1_PASS))
-		err = -EBADMSG;
-
-	kfree(edesc);
-
-	aead_request_complete(req, err);
-}
-
-/*
- * convert scatterlist to SEC h/w link table format
- * stop at cryptlen bytes
- */
-static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
-			   int cryptlen, struct talitos_ptr *link_tbl_ptr)
-{
-	int n_sg = sg_count;
-
-	while (n_sg--) {
-		to_talitos_ptr(link_tbl_ptr, sg_dma_address(sg));
-		link_tbl_ptr->len = cpu_to_be16(sg_dma_len(sg));
-		link_tbl_ptr->j_extent = 0;
-		link_tbl_ptr++;
-		cryptlen -= sg_dma_len(sg);
-		sg = sg_next(sg);
-	}
-
-	/* adjust (decrease) last one (or two) entry's len to cryptlen */
-	link_tbl_ptr--;
-	while (be16_to_cpu(link_tbl_ptr->len) <= (-cryptlen)) {
-		/* Empty this entry, and move to previous one */
-		cryptlen += be16_to_cpu(link_tbl_ptr->len);
-		link_tbl_ptr->len = 0;
-		sg_count--;
-		link_tbl_ptr--;
-	}
-	be16_add_cpu(&link_tbl_ptr->len, cryptlen);
-
-	/* tag end of link table */
-	link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-
-	return sg_count;
-}
-
-/*
- * fill in and submit ipsec_esp descriptor
- */
-static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
-		     u64 seq, void (*callback) (struct device *dev,
-						struct talitos_desc *desc,
-						void *context, int error))
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *dev = ctx->dev;
-	struct talitos_desc *desc = &edesc->desc;
-	unsigned int cryptlen = areq->cryptlen;
-	unsigned int authsize = ctx->authsize;
-	unsigned int ivsize = crypto_aead_ivsize(aead);
-	int sg_count, ret;
-	int sg_link_tbl_len;
-
-	/* hmac key */
-	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
-			       0, DMA_TO_DEVICE);
-
-	/* hmac data */
-	desc->ptr[1].len = cpu_to_be16(areq->assoclen + ivsize);
-	if (edesc->assoc_nents) {
-		int tbl_off = edesc->src_nents + edesc->dst_nents + 2;
-		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
-
-		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
-			       sizeof(struct talitos_ptr));
-		desc->ptr[1].j_extent = DESC_PTR_LNKTBL_JUMP;
-
-		/* assoc_nents - 1 entries for assoc, 1 for IV */
-		sg_count = sg_to_link_tbl(areq->assoc, edesc->assoc_nents - 1,
-					  areq->assoclen, tbl_ptr);
-
-		/* add IV to link table */
-		tbl_ptr += sg_count - 1;
-		tbl_ptr->j_extent = 0;
-		tbl_ptr++;
-		to_talitos_ptr(tbl_ptr, edesc->iv_dma);
-		tbl_ptr->len = cpu_to_be16(ivsize);
-		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
-	} else {
-		if (areq->assoclen)
-			to_talitos_ptr(&desc->ptr[1],
-				       sg_dma_address(areq->assoc));
-		else
-			to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
-		desc->ptr[1].j_extent = 0;
-	}
-
-	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma);
-	desc->ptr[2].len = cpu_to_be16(ivsize);
-	desc->ptr[2].j_extent = 0;
-	/* Sync needed for the aead_givencrypt case */
-	dma_sync_single_for_device(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
-
-	/* cipher key */
-	map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
-			       (char *)&ctx->key + ctx->authkeylen, 0,
-			       DMA_TO_DEVICE);
-
-	/*
-	 * cipher in
-	 * map and adjust cipher len to aead request cryptlen.
-	 * extent is bytes of HMAC postpended to ciphertext,
-	 * typically 12 for ipsec
-	 */
-	desc->ptr[4].len = cpu_to_be16(cryptlen);
-	desc->ptr[4].j_extent = authsize;
-
-	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ? : 1,
-				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
-							   : DMA_TO_DEVICE,
-				  edesc->src_chained);
-
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src));
-	} else {
-		sg_link_tbl_len = cryptlen;
-
-		if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
-			sg_link_tbl_len = cryptlen + authsize;
-
-		sg_count = sg_to_link_tbl(areq->src, sg_count, sg_link_tbl_len,
-					  &edesc->link_tbl[0]);
-		if (sg_count > 1) {
-			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
-			to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl);
-			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-						   edesc->dma_len,
-						   DMA_BIDIRECTIONAL);
-		} else {
-			/* Only one segment now, so no link tbl needed */
-			to_talitos_ptr(&desc->ptr[4],
-				       sg_dma_address(areq->src));
-		}
-	}
-
-	/* cipher out */
-	desc->ptr[5].len = cpu_to_be16(cryptlen);
-	desc->ptr[5].j_extent = authsize;
-
-	if (areq->src != areq->dst)
-		sg_count = talitos_map_sg(dev, areq->dst,
-					  edesc->dst_nents ? : 1,
-					  DMA_FROM_DEVICE, edesc->dst_chained);
-
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst));
-	} else {
-		int tbl_off = edesc->src_nents + 1;
-		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
-
-		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
-			       tbl_off * sizeof(struct talitos_ptr));
-		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
-					  tbl_ptr);
-
-		/* Add an entry to the link table for ICV data */
-		tbl_ptr += sg_count - 1;
-		tbl_ptr->j_extent = 0;
-		tbl_ptr++;
-		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-		tbl_ptr->len = cpu_to_be16(authsize);
-
-		/* icv data follows link tables */
-		to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl +
-			       (tbl_off + edesc->dst_nents + 1 +
-				edesc->assoc_nents) *
-			       sizeof(struct talitos_ptr));
-		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
-		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
-	}
-
-	/* iv out */
-	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
-			       DMA_FROM_DEVICE);
-
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
-	if (ret != -EINPROGRESS) {
-		ipsec_esp_unmap(dev, edesc, areq);
-		kfree(edesc);
-	}
-	return ret;
-}
-
 /*
  * derive number of elements in scatterlist
  */
@@ -1121,7 +654,7 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
 /*
  * allocate and map the extended descriptor
  */
-static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
+struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 struct scatterlist *assoc,
 						 struct scatterlist *src,
 						 struct scatterlist *dst,
@@ -1225,109 +758,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	return edesc;
 }
 
-static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
-					      int icv_stashing, bool encrypt)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	unsigned int ivsize = crypto_aead_ivsize(authenc);
-
-	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
-				   iv, areq->assoclen, areq->cryptlen,
-				   ctx->authsize, ivsize, icv_stashing,
-				   areq->base.flags, encrypt);
-}
-
-static int aead_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
-
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 0, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
-
-	return ipsec_esp(edesc, req, 0, ipsec_esp_encrypt_done);
-}
-
-static int aead_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	unsigned int authsize = ctx->authsize;
-	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
-	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
-	void *icvdata;
-
-	req->cryptlen -= authsize;
-
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 1, false);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	if ((priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
-	    ((!edesc->src_nents && !edesc->dst_nents) ||
-	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
-
-		/* decrypt and check the ICV */
-		edesc->desc.hdr = ctx->desc_hdr_template |
-				  DESC_HDR_DIR_INBOUND |
-				  DESC_HDR_MODE1_MDEU_CICV;
-
-		/* reset integrity check result bits */
-		edesc->desc.hdr_lo = 0;
-
-		return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_hwauth_done);
-	}
-
-	/* Have to check the ICV with software */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
-
-	/* stash incoming ICV for later cmp with ICV generated by the h/w */
-	if (edesc->dma_len)
-		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2 +
-					   edesc->assoc_nents];
-	else
-		icvdata = &edesc->link_tbl[0];
-
-	sg = sg_last(req->src, edesc->src_nents ? : 1);
-
-	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
-	       ctx->authsize);
-
-	return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_swauth_done);
-}
-
-static int aead_givencrypt(struct aead_givcrypt_request *req)
-{
-	struct aead_request *areq = &req->areq;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
-
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(areq, req->giv, 0, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
-
-	memcpy(req->giv, ctx->iv, crypto_aead_ivsize(authenc));
-	/* avoid consecutive packets going out with same IV */
-	*(__be64 *)req->giv ^= cpu_to_be64(req->seq);
-
-	return ipsec_esp(edesc, areq, req->seq, ipsec_esp_encrypt_done);
-}
-
 static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 			     const u8 *key, unsigned int keylen)
 {
@@ -1339,15 +769,6 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
-static void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
-				 struct scatterlist *dst, unsigned int len,
-				 struct talitos_edesc *edesc,
-				 struct talitos_ptr *ptr_in,
-				 struct talitos_ptr *ptr_out)
-{
-	talitos_sg_unmap(dev, edesc, src, dst);
-}
-
 static void common_nonsnoop_unmap(struct device *dev,
 				  struct talitos_edesc *edesc,
 				  struct ablkcipher_request *areq)
@@ -1380,65 +801,6 @@ static void ablkcipher_done(struct device *dev,
 	areq->base.complete(&areq->base, err);
 }
 
-int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
-			  unsigned int len, struct talitos_edesc *edesc,
-			  enum dma_data_direction dir, struct talitos_ptr *ptr)
-{
-	int sg_count;
-
-	ptr->len = cpu_to_be16(len);
-	ptr->j_extent = 0;
-
-	sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
-				  edesc->src_chained);
-
-	if (sg_count == 1) {
-		to_talitos_ptr(ptr, sg_dma_address(src));
-	} else {
-		sg_count = sg_to_link_tbl(src, sg_count, len,
-					  &edesc->link_tbl[0]);
-		if (sg_count > 1) {
-			to_talitos_ptr(ptr, edesc->dma_link_tbl);
-			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
-			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-						   edesc->dma_len,
-						   DMA_BIDIRECTIONAL);
-		} else {
-			/* Only one segment now, so no link tbl needed */
-			to_talitos_ptr(ptr, sg_dma_address(src));
-		}
-	}
-	return sg_count;
-}
-
-void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
-			    unsigned int len, struct talitos_edesc *edesc,
-			    enum dma_data_direction dir,
-			    struct talitos_ptr *ptr, int sg_count)
-{
-	ptr->len = cpu_to_be16(len);
-	ptr->j_extent = 0;
-
-	if (dir != DMA_NONE)
-		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
-					  dir, edesc->dst_chained);
-
-	if (sg_count == 1) {
-		to_talitos_ptr(ptr, sg_dma_address(dst));
-	} else {
-		struct talitos_ptr *link_tbl_ptr =
-			&edesc->link_tbl[edesc->src_nents + 1];
-
-		to_talitos_ptr(ptr, edesc->dma_link_tbl +
-					      (edesc->src_nents + 1) *
-					      sizeof(struct talitos_ptr));
-		ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
-		sg_count = sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
-	}
-}
-
 static int common_nonsnoop(struct talitos_edesc *edesc,
 			   struct ablkcipher_request *areq,
 			   void (*callback) (struct device *dev,
@@ -2399,7 +1761,7 @@ struct talitos_crypto_alg {
 	struct talitos_alg_template algt;
 };
 
-static int talitos_cra_init(struct crypto_tfm *tfm)
+int talitos_cra_init(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg = tfm->__crt_alg;
 	struct talitos_crypto_alg *talitos_alg;
@@ -2431,18 +1793,6 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int talitos_cra_init_aead(struct crypto_tfm *tfm)
-{
-	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	talitos_cra_init(tfm);
-
-	/* random first IV */
-	get_random_bytes(ctx->iv, TALITOS_MAX_IV_LENGTH);
-
-	return 0;
-}
-
 static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -2537,6 +1887,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	t_alg->algt = *template;
 
 	switch (t_alg->algt.type) {
+		int ret;
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		alg = &t_alg->algt.alg.crypto;
 		alg->cra_init = talitos_cra_init;
@@ -2548,14 +1899,9 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.crypto;
-		alg->cra_init = talitos_cra_init_aead;
-		alg->cra_type = &crypto_aead_type;
-		alg->cra_aead.setkey = aead_setkey;
-		alg->cra_aead.setauthsize = aead_setauthsize;
-		alg->cra_aead.encrypt = aead_encrypt;
-		alg->cra_aead.decrypt = aead_decrypt;
-		alg->cra_aead.givencrypt = aead_givencrypt;
-		alg->cra_aead.geniv = "<built-in>";
+		ret = talitos_alg_alloc_aead(alg);
+		if (ret)
+			return ERR_PTR(ret);
 		break;
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 102dc99..566dc92 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -133,11 +133,144 @@ struct talitos_private {
 	struct hwrng rng;
 };
 
+/*
+ * talitos_edesc - s/w-extended descriptor
+ * @assoc_nents: number of segments in associated data scatterlist
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @assoc_chained: whether assoc is chained or not
+ * @src_chained: whether src is chained or not
+ * @dst_chained: whether dst is chained or not
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @dma_len: length of dma mapped link_tbl space
+ * @dma_link_tbl: bus physical address of link_tbl
+ * @desc: h/w descriptor
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
+ *
+ * if decrypting (with authcheck), or either one of src_nents or dst_nents
+ * is greater than 1, an integrity check value is concatenated to the end
+ * of link_tbl data
+ */
+struct talitos_edesc {
+	int assoc_nents;
+	int src_nents;
+	int dst_nents;
+	bool assoc_chained;
+	bool src_chained;
+	bool dst_chained;
+	dma_addr_t iv_dma;
+	int dma_len;
+	dma_addr_t dma_link_tbl;
+	struct talitos_desc desc;
+	struct talitos_ptr link_tbl[0];
+};
+
+#define TALITOS_MAX_KEY_SIZE		96
+/* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
+#define TALITOS_MAX_IV_LENGTH		16
+
+struct talitos_ctx {
+	struct device *dev;
+	int ch;
+	__be32 desc_hdr_template;
+	u8 key[TALITOS_MAX_KEY_SIZE];
+	u8 iv[TALITOS_MAX_IV_LENGTH];
+	unsigned int keylen;
+	unsigned int enckeylen;
+	unsigned int authkeylen;
+	unsigned int authsize;
+};
+
+static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
+{
+	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	ptr->eptr = upper_32_bits(dma_addr);
+}
+
+/*
+ * map virtual single (contiguous) pointer to h/w descriptor pointer
+ */
+static inline void map_single_talitos_ptr(struct device *dev,
+				   struct talitos_ptr *talitos_ptr,
+				   unsigned short len, void *data,
+				   unsigned char extent,
+				   enum dma_data_direction dir)
+{
+	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
+
+	talitos_ptr->len = cpu_to_be16(len);
+	to_talitos_ptr(talitos_ptr, dma_addr);
+	talitos_ptr->j_extent = extent;
+}
+
+/*
+ * unmap bus single (contiguous) h/w descriptor pointer
+ */
+static inline void unmap_single_talitos_ptr(struct device *dev,
+				     struct talitos_ptr *talitos_ptr,
+				     enum dma_data_direction dir)
+{
+	dma_unmap_single(dev, be32_to_cpu(talitos_ptr->ptr),
+			 be16_to_cpu(talitos_ptr->len), dir);
+}
+
+static inline int talitos_map_sg(struct device *dev, struct scatterlist *sg,
+			  unsigned int nents, enum dma_data_direction dir,
+			  bool chained)
+{
+	if (unlikely(chained))
+		while (sg) {
+			dma_map_sg(dev, sg, 1, dir);
+			sg = sg_next(sg);
+		}
+	else
+		dma_map_sg(dev, sg, nents, dir);
+	return nents;
+}
+
+static inline void talitos_unmap_sg_chain(struct device *dev,
+					  struct scatterlist *sg,
+					  enum dma_data_direction dir)
+{
+	while (sg) {
+		dma_unmap_sg(dev, sg, 1, dir);
+		sg = sg_next(sg);
+	}
+}
+
+extern void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
+				 struct scatterlist *dst, unsigned int len,
+				 struct talitos_edesc *edesc,
+				 struct talitos_ptr *ptr_in,
+				 struct talitos_ptr *ptr_out);
+extern int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  enum dma_data_direction dir, struct talitos_ptr *ptr);
+extern void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
+			    unsigned int len, struct talitos_edesc *edesc,
+			    enum dma_data_direction dir,
+			    struct talitos_ptr *ptr, int sg_count);
+
+
 extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 			  void (*callback)(struct device *dev,
 					   struct talitos_desc *desc,
 					   void *context, int error),
 			  void *context);
+extern struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
+						 struct scatterlist *assoc,
+						 struct scatterlist *src,
+						 struct scatterlist *dst,
+						 u8 *iv,
+						 unsigned int assoclen,
+						 unsigned int cryptlen,
+						 unsigned int authsize,
+						 unsigned int ivsize,
+						 int icv_stashing,
+						 u32 cryptoflags,
+						 bool encrypt);
+extern int talitos_alg_alloc_aead(struct crypto_alg *alg);
+extern int talitos_cra_init(struct crypto_tfm *tfm);
 
 /* .features flag */
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
diff --git a/drivers/crypto/talitos2.c b/drivers/crypto/talitos2.c
new file mode 100644
index 0000000..024cbbd
--- /dev/null
+++ b/drivers/crypto/talitos2.c
@@ -0,0 +1,614 @@
+/*
+ * talitos2 - Freescale Integrated Security Engine (SEC2) device driver
+ *
+ * Copyright (c) 2008-2011 Freescale Semiconductor, Inc.
+ *
+ * Scatterlist Crypto API glue code copied from files with the following:
+ * Copyright (c) 2006-2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * Crypto algorithm registration code copied from hifn driver:
+ * 2007+ Copyright (c) Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/crypto.h>
+#include <linux/hw_random.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/rtnetlink.h>
+#include <linux/slab.h>
+
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+
+#include "talitos.h"
+
+static void talitos_sg_unmap(struct device *dev,
+			     struct talitos_edesc *edesc,
+			     struct scatterlist *src,
+			     struct scatterlist *dst)
+{
+	unsigned int src_nents = edesc->src_nents ? : 1;
+	unsigned int dst_nents = edesc->dst_nents ? : 1;
+
+	if (src != dst) {
+		if (edesc->src_chained)
+			talitos_unmap_sg_chain(dev, src, DMA_TO_DEVICE);
+		else
+			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
+
+		if (dst) {
+			if (edesc->dst_chained)
+				talitos_unmap_sg_chain(dev, dst,
+						       DMA_FROM_DEVICE);
+			else
+				dma_unmap_sg(dev, dst, dst_nents,
+					     DMA_FROM_DEVICE);
+		}
+	} else
+		if (edesc->src_chained)
+			talitos_unmap_sg_chain(dev, src, DMA_BIDIRECTIONAL);
+		else
+			dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
+}
+
+void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
+				 struct scatterlist *dst, unsigned int len,
+				 struct talitos_edesc *edesc,
+				 struct talitos_ptr *ptr_in,
+				 struct talitos_ptr *ptr_out)
+{
+	talitos_sg_unmap(dev, edesc, src, dst);
+}
+
+/*
+ * convert scatterlist to SEC h/w link table format
+ * stop at cryptlen bytes
+ */
+static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
+			   int cryptlen, struct talitos_ptr *link_tbl_ptr)
+{
+	int n_sg = sg_count;
+
+	while (n_sg--) {
+		to_talitos_ptr(link_tbl_ptr, sg_dma_address(sg));
+		link_tbl_ptr->len = cpu_to_be16(sg_dma_len(sg));
+		link_tbl_ptr->j_extent = 0;
+		link_tbl_ptr++;
+		cryptlen -= sg_dma_len(sg);
+		sg = sg_next(sg);
+	}
+
+	/* adjust (decrease) last one (or two) entry's len to cryptlen */
+	link_tbl_ptr--;
+	while (be16_to_cpu(link_tbl_ptr->len) <= (-cryptlen)) {
+		/* Empty this entry, and move to previous one */
+		cryptlen += be16_to_cpu(link_tbl_ptr->len);
+		link_tbl_ptr->len = 0;
+		sg_count--;
+		link_tbl_ptr--;
+	}
+	be16_add_cpu(&link_tbl_ptr->len, cryptlen);
+
+	/* tag end of link table */
+	link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+
+	return sg_count;
+}
+
+int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  enum dma_data_direction dir, struct talitos_ptr *ptr)
+{
+	int sg_count;
+
+	ptr->len = cpu_to_be16(len);
+	ptr->j_extent = 0;
+
+	sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
+				  edesc->src_chained);
+
+	if (sg_count == 1) {
+		to_talitos_ptr(ptr, sg_dma_address(src));
+	} else {
+		sg_count = sg_to_link_tbl(src, sg_count, len,
+					  &edesc->link_tbl[0]);
+		if (sg_count > 1) {
+			to_talitos_ptr(ptr, edesc->dma_link_tbl);
+			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
+		} else {
+			/* Only one segment now, so no link tbl needed */
+			to_talitos_ptr(ptr, sg_dma_address(src));
+		}
+	}
+	return sg_count;
+}
+
+void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
+			    unsigned int len, struct talitos_edesc *edesc,
+			    enum dma_data_direction dir,
+			    struct talitos_ptr *ptr, int sg_count)
+{
+	ptr->len = cpu_to_be16(len);
+	ptr->j_extent = 0;
+
+	if (dir != DMA_NONE)
+		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
+					  dir, edesc->dst_chained);
+
+	if (sg_count == 1) {
+		to_talitos_ptr(ptr, sg_dma_address(dst));
+	} else {
+		struct talitos_ptr *link_tbl_ptr =
+			&edesc->link_tbl[edesc->src_nents + 1];
+
+		to_talitos_ptr(ptr, edesc->dma_link_tbl +
+					      (edesc->src_nents + 1) *
+					      sizeof(struct talitos_ptr));
+		ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+		sg_count = sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	}
+}
+
+int aead_setauthsize(struct crypto_aead *authenc,
+			    unsigned int authsize)
+{
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+
+	ctx->authsize = authsize;
+
+	return 0;
+}
+
+int aead_setkey(struct crypto_aead *authenc,
+		       const u8 *key, unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct crypto_authenc_keys keys;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
+		goto badkey;
+
+	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
+		goto badkey;
+
+	memcpy(ctx->key, keys.authkey, keys.authkeylen);
+	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
+
+	ctx->keylen = keys.authkeylen + keys.enckeylen;
+	ctx->enckeylen = keys.enckeylen;
+	ctx->authkeylen = keys.authkeylen;
+
+	return 0;
+
+badkey:
+	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
+static void ipsec_esp_unmap(struct device *dev,
+			    struct talitos_edesc *edesc,
+			    struct aead_request *areq)
+{
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6], DMA_FROM_DEVICE);
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[3], DMA_TO_DEVICE);
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
+
+	if (edesc->assoc_chained)
+		talitos_unmap_sg_chain(dev, areq->assoc, DMA_TO_DEVICE);
+	else if (areq->assoclen)
+		/* assoc_nents counts also for IV in non-contiguous cases */
+		dma_unmap_sg(dev, areq->assoc,
+			     edesc->assoc_nents ? edesc->assoc_nents - 1 : 1,
+			     DMA_TO_DEVICE);
+
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
+
+	if (edesc->dma_len)
+		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
+				 DMA_BIDIRECTIONAL);
+}
+
+/*
+ * ipsec_esp descriptor callbacks
+ */
+static void ipsec_esp_encrypt_done(struct device *dev,
+				   struct talitos_desc *desc, void *context,
+				   int err)
+{
+	struct aead_request *areq = context;
+	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_edesc *edesc;
+	struct scatterlist *sg;
+	void *icvdata;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
+	ipsec_esp_unmap(dev, edesc, areq);
+
+	/* copy the generated ICV to dst */
+	if (edesc->dst_nents) {
+		icvdata = &edesc->link_tbl[edesc->src_nents +
+					   edesc->dst_nents + 2 +
+					   edesc->assoc_nents];
+		sg = sg_last(areq->dst, edesc->dst_nents);
+		memcpy((char *)sg_virt(sg) + sg->length - ctx->authsize,
+		       icvdata, ctx->authsize);
+	}
+
+	kfree(edesc);
+
+	aead_request_complete(areq, err);
+}
+
+static void ipsec_esp_decrypt_swauth_done(struct device *dev,
+					  struct talitos_desc *desc,
+					  void *context, int err)
+{
+	struct aead_request *req = context;
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_edesc *edesc;
+	struct scatterlist *sg;
+	void *icvdata;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
+	ipsec_esp_unmap(dev, edesc, req);
+
+	if (!err) {
+		/* auth check */
+		if (edesc->dma_len)
+			icvdata = &edesc->link_tbl[edesc->src_nents +
+						   edesc->dst_nents + 2 +
+						   edesc->assoc_nents];
+		else
+			icvdata = &edesc->link_tbl[0];
+
+		sg = sg_last(req->dst, edesc->dst_nents ? : 1);
+		err = memcmp(icvdata, (char *)sg_virt(sg) + sg->length -
+			     ctx->authsize, ctx->authsize) ? -EBADMSG : 0;
+	}
+
+	kfree(edesc);
+
+	aead_request_complete(req, err);
+}
+
+static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
+					  struct talitos_desc *desc,
+					  void *context, int err)
+{
+	struct aead_request *req = context;
+	struct talitos_edesc *edesc;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
+	ipsec_esp_unmap(dev, edesc, req);
+
+	/* check ICV auth status */
+	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
+		     DESC_HDR_LO_ICCR1_PASS))
+		err = -EBADMSG;
+
+	kfree(edesc);
+
+	aead_request_complete(req, err);
+}
+
+/*
+ * fill in and submit ipsec_esp descriptor
+ */
+static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
+		     u64 seq, void (*callback) (struct device *dev,
+						struct talitos_desc *desc,
+						void *context, int error))
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *dev = ctx->dev;
+	struct talitos_desc *desc = &edesc->desc;
+	unsigned int cryptlen = areq->cryptlen;
+	unsigned int authsize = ctx->authsize;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+	int sg_count, ret;
+	int sg_link_tbl_len;
+
+	/* hmac key */
+	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
+			       0, DMA_TO_DEVICE);
+
+	/* hmac data */
+	desc->ptr[1].len = cpu_to_be16(areq->assoclen + ivsize);
+	if (edesc->assoc_nents) {
+		int tbl_off = edesc->src_nents + edesc->dst_nents + 2;
+		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
+
+		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
+			       sizeof(struct talitos_ptr));
+		desc->ptr[1].j_extent = DESC_PTR_LNKTBL_JUMP;
+
+		/* assoc_nents - 1 entries for assoc, 1 for IV */
+		sg_count = sg_to_link_tbl(areq->assoc, edesc->assoc_nents - 1,
+					  areq->assoclen, tbl_ptr);
+
+		/* add IV to link table */
+		tbl_ptr += sg_count - 1;
+		tbl_ptr->j_extent = 0;
+		tbl_ptr++;
+		to_talitos_ptr(tbl_ptr, edesc->iv_dma);
+		tbl_ptr->len = cpu_to_be16(ivsize);
+		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	} else {
+		if (areq->assoclen)
+			to_talitos_ptr(&desc->ptr[1],
+				       sg_dma_address(areq->assoc));
+		else
+			to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
+		desc->ptr[1].j_extent = 0;
+	}
+
+	/* cipher iv */
+	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma);
+	desc->ptr[2].len = cpu_to_be16(ivsize);
+	desc->ptr[2].j_extent = 0;
+	/* Sync needed for the aead_givencrypt case */
+	dma_sync_single_for_device(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
+
+	/* cipher key */
+	map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
+			       (char *)&ctx->key + ctx->authkeylen, 0,
+			       DMA_TO_DEVICE);
+
+	/*
+	 * cipher in
+	 * map and adjust cipher len to aead request cryptlen.
+	 * extent is bytes of HMAC postpended to ciphertext,
+	 * typically 12 for ipsec
+	 */
+	desc->ptr[4].len = cpu_to_be16(cryptlen);
+	desc->ptr[4].j_extent = authsize;
+
+	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ? : 1,
+				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
+							   : DMA_TO_DEVICE,
+				  edesc->src_chained);
+
+	if (sg_count == 1) {
+		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src));
+	} else {
+		sg_link_tbl_len = cryptlen;
+
+		if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
+			sg_link_tbl_len = cryptlen + authsize;
+
+		sg_count = sg_to_link_tbl(areq->src, sg_count, sg_link_tbl_len,
+					  &edesc->link_tbl[0]);
+		if (sg_count > 1) {
+			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
+			to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl);
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
+		} else {
+			/* Only one segment now, so no link tbl needed */
+			to_talitos_ptr(&desc->ptr[4],
+				       sg_dma_address(areq->src));
+		}
+	}
+
+	/* cipher out */
+	desc->ptr[5].len = cpu_to_be16(cryptlen);
+	desc->ptr[5].j_extent = authsize;
+
+	if (areq->src != areq->dst)
+		sg_count = talitos_map_sg(dev, areq->dst,
+					  edesc->dst_nents ? : 1,
+					  DMA_FROM_DEVICE, edesc->dst_chained);
+
+	if (sg_count == 1) {
+		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst));
+	} else {
+		int tbl_off = edesc->src_nents + 1;
+		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
+
+		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
+			       tbl_off * sizeof(struct talitos_ptr));
+		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
+					  tbl_ptr);
+
+		/* Add an entry to the link table for ICV data */
+		tbl_ptr += sg_count - 1;
+		tbl_ptr->j_extent = 0;
+		tbl_ptr++;
+		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+		tbl_ptr->len = cpu_to_be16(authsize);
+
+		/* icv data follows link tables */
+		to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl +
+			       (tbl_off + edesc->dst_nents + 1 +
+				edesc->assoc_nents) *
+			       sizeof(struct talitos_ptr));
+		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
+		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	}
+
+	/* iv out */
+	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
+			       DMA_FROM_DEVICE);
+
+	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	if (ret != -EINPROGRESS) {
+		ipsec_esp_unmap(dev, edesc, areq);
+		kfree(edesc);
+	}
+	return ret;
+}
+
+static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
+					      int icv_stashing, bool encrypt)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	unsigned int ivsize = crypto_aead_ivsize(authenc);
+
+	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
+				   iv, areq->assoclen, areq->cryptlen,
+				   ctx->authsize, ivsize, icv_stashing,
+				   areq->base.flags, encrypt);
+}
+
+static int aead_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_edesc *edesc;
+
+	/* allocate extended descriptor */
+	edesc = aead_edesc_alloc(req, req->iv, 0, true);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* set encrypt */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+
+	return ipsec_esp(edesc, req, 0, ipsec_esp_encrypt_done);
+}
+
+static int aead_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	unsigned int authsize = ctx->authsize;
+	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
+	struct talitos_edesc *edesc;
+	struct scatterlist *sg;
+	void *icvdata;
+
+	req->cryptlen -= authsize;
+
+	/* allocate extended descriptor */
+	edesc = aead_edesc_alloc(req, req->iv, 1, false);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	if ((priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
+	    ((!edesc->src_nents && !edesc->dst_nents) ||
+	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
+
+		/* decrypt and check the ICV */
+		edesc->desc.hdr = ctx->desc_hdr_template |
+				  DESC_HDR_DIR_INBOUND |
+				  DESC_HDR_MODE1_MDEU_CICV;
+
+		/* reset integrity check result bits */
+		edesc->desc.hdr_lo = 0;
+
+		return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_hwauth_done);
+	}
+
+	/* Have to check the ICV with software */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+
+	/* stash incoming ICV for later cmp with ICV generated by the h/w */
+	if (edesc->dma_len)
+		icvdata = &edesc->link_tbl[edesc->src_nents +
+					   edesc->dst_nents + 2 +
+					   edesc->assoc_nents];
+	else
+		icvdata = &edesc->link_tbl[0];
+
+	sg = sg_last(req->src, edesc->src_nents ? : 1);
+
+	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
+	       ctx->authsize);
+
+	return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_swauth_done);
+}
+
+static int aead_givencrypt(struct aead_givcrypt_request *req)
+{
+	struct aead_request *areq = &req->areq;
+	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_edesc *edesc;
+
+	/* allocate extended descriptor */
+	edesc = aead_edesc_alloc(areq, req->giv, 0, true);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* set encrypt */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+
+	memcpy(req->giv, ctx->iv, crypto_aead_ivsize(authenc));
+	/* avoid consecutive packets going out with same IV */
+	*(__be64 *)req->giv ^= cpu_to_be64(req->seq);
+
+	return ipsec_esp(edesc, areq, req->seq, ipsec_esp_encrypt_done);
+}
+
+static int talitos_cra_init_aead(struct crypto_tfm *tfm)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	talitos_cra_init(tfm);
+
+	/* random first IV */
+	get_random_bytes(ctx->iv, TALITOS_MAX_IV_LENGTH);
+
+	return 0;
+}
+
+int talitos_alg_alloc_aead(struct crypto_alg *alg)
+{
+	alg->cra_init = talitos_cra_init_aead;
+	alg->cra_type = &crypto_aead_type;
+	alg->cra_aead.setkey = aead_setkey;
+	alg->cra_aead.setauthsize = aead_setauthsize;
+	alg->cra_aead.encrypt = aead_encrypt;
+	alg->cra_aead.decrypt = aead_decrypt;
+	alg->cra_aead.givencrypt = aead_givencrypt;
+	alg->cra_aead.geniv = "<built-in>";
+
+	return 0;
+}
-- 
2.1.0
