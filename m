Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7138C5B578
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977E62063F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="nbbnNL/v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfF1E1z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:27:55 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46410 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfF1E1z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:27:55 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4Rjom053737;
        Thu, 27 Jun 2019 23:27:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696065;
        bh=DSA/ZAIZgUYuQAI7wUCealzIjACaDYkjfETlnAsTImY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=nbbnNL/vBTHnKRKISvr8RZnSvdspp4eWMfB/HKcFs14Ku+a9k8tkEhDdCW4NkaGAQ
         WpBPfB3W1jpIocJAN1fZa1cYPhzMRn0eEt0QCueg0DEU4T9j1BZToV9Ezqjio6ACIM
         xQfqaGXTVemX8a+JxHLemDMWYepmL7NJJdnAYYrU=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4RjfH113450
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:45 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:45 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:45 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPR062595;
        Thu, 27 Jun 2019 23:27:42 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 07/10] crypto: sa2ul: Add hmac(sha1) HMAC algorithm support
Date:   Fri, 28 Jun 2019 09:57:42 +0530
Message-ID: <20190628042745.28455-8-j-keerthy@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628042745.28455-1-j-keerthy@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

HMAC hash-based message authentication code) is a specific type of
message authentication code (MAC) involving a cryptographic hash
function and a secret cryptographic key. It may be used to
simultaneously verify both the data integrity and the authentication
of a message, as with any MAC. Add hmac(sha1) HMAC algorithm support
and the message digest size is 20 bytes.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/crypto/sa2ul.c | 347 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 347 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 9c9008e21867..e3a1321f0666 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1408,6 +1408,307 @@ static int sa_aead_decrypt(struct aead_request *req)
 	return sa_aead_run(req, req->iv, 0);
 }
 
+static int sa_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
+{
+	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
+	int ret;
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_AHASH) {
+		memset(ctx, 0, sizeof(*ctx));
+		ctx->dev_data = data;
+		ret = sa_init_ctx_info(&ctx->enc, data);
+		if (ret)
+			return ret;
+	}
+
+	if (alg_base) {
+		ctx->shash = crypto_alloc_shash(alg_base, 0,
+						CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(ctx->shash)) {
+			pr_err("base driver %s couldn't be loaded\n", alg_base);
+			return PTR_ERR(ctx->shash);
+		}
+	}
+
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
+		ctx->dec.sc_id, &ctx->dec.sc_phys);
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct sa_dma_req_ctx) +
+				 SHA512_BLOCK_SIZE);
+
+	return 0;
+}
+
+static void sa_sham_dma_in_callback(void *data)
+{
+	struct sa_rx_data *rxd = (struct sa_rx_data *)data;
+	struct ahash_request *req = (struct ahash_request *)rxd->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	unsigned int authsize = crypto_ahash_digestsize(tfm);
+	int i, sg_nents;
+	size_t ml, pl;
+	u32 *mdptr, *result;
+
+	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl, &ml);
+	result = (u32 *)req->result;
+
+	kfree(rxd);
+
+	for (i = 0; i < (authsize / 4); i++)
+		result[i] = htonl(mdptr[i + 4]);
+
+	sg_nents = sg_nents_for_len(req->src, req->nbytes);
+	dma_unmap_sg(rxd->ddev, req->src, sg_nents, DMA_FROM_DEVICE);
+
+	ahash_request_complete(req, 0);
+
+	kfree(rxd);
+}
+
+static int sa_sham_digest(struct ahash_request *req)
+{
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct sa_ctx_info *sa_ctx = &ctx->enc;
+	struct dma_async_tx_descriptor *tx_in, *tx_out;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
+	struct sa_dma_req_ctx req_ctx;
+	struct sa_rx_data *rxd;
+	u8 enc_offset;
+	int sg_nents;
+	int psdata_offset;
+	u8 auth_offset = 0;
+	u8 *auth_iv = NULL;
+	u8 *aad = NULL;
+	u8 aad_len = 0;
+	u16 enc_len;
+	u16 auth_len = 0;
+	u32 req_type;
+	u32 *mdptr;
+	struct dma_chan *dma_rx;
+	gfp_t flags;
+	size_t pl, ml;
+	struct device *ddev;
+
+	flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+			GFP_KERNEL : GFP_ATOMIC;
+	enc_len = 0;
+	auth_len = req->nbytes;
+	enc_offset = 0;
+
+	if (enc_len > 256)
+		dma_rx = pdata->dma_rx2;
+	else
+		dma_rx = pdata->dma_rx1;
+
+	ddev = dma_rx->device->dev;
+	/* Allocate descriptor & submit packet */
+	sg_nents = sg_nents_for_len(req->src, req->nbytes);
+
+	memcpy(req_ctx.cmdl, sa_ctx->cmdl, sa_ctx->cmdl_size);
+	/* Update Command Label */
+	sa_update_cmdl(sa_k3_dev, enc_offset, enc_len,
+		       NULL, auth_offset, auth_len,
+		       auth_iv, aad_len, aad,
+		       &sa_ctx->cmdl_upd_info, req_ctx.cmdl);
+
+	/*
+	 * Last 2 words in PSDATA will have the crypto alg type &
+	 * crypto request pointer
+	 */
+	req_type = CRYPTO_ALG_TYPE_AHASH;
+
+	psdata_offset = sa_ctx->cmdl_size / sizeof(u32);
+	req_ctx.cmdl[psdata_offset++] = req_type;
+
+	/* map the packet */
+	req_ctx.src = req->src;
+	req_ctx.src_nents = dma_map_sg(ddev, req->src, sg_nents, DMA_TO_DEVICE);
+
+	if (unlikely(req_ctx.src_nents != sg_nents)) {
+		dev_warn_ratelimited(sa_k3_dev, "failed to map tx pkt\n");
+		return -EIO;
+	}
+
+	req_ctx.dev_data = pdata;
+	req_ctx.pkt = true;
+
+	dma_sync_sg_for_device(pdata->dev, req->src, req_ctx.src_nents,
+			       DMA_TO_DEVICE);
+
+	tx_in = dmaengine_prep_slave_sg(dma_rx, req->src, req_ctx.src_nents,
+					DMA_DEV_TO_MEM,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!tx_in) {
+		dev_err(pdata->dev, "IN prep_slave_sg() failed\n");
+		return -EINVAL;
+	}
+
+	rxd = kzalloc(sizeof(*rxd), GFP_KERNEL);
+	rxd->req = (void *)req;
+	rxd->tx_in = tx_in;
+	rxd->ddev = ddev;
+	tx_in->callback = sa_sham_dma_in_callback;
+	tx_in->callback_param = rxd;
+
+	tx_out = dmaengine_prep_slave_sg(pdata->dma_tx, req->src,
+					 req_ctx.src_nents, DMA_MEM_TO_DEV,
+					 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!tx_out) {
+		dev_err(pdata->dev, "OUT prep_slave_sg() failed\n");
+		return -EINVAL;
+	}
+
+	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
+	sa_prepare_tx_desc(mdptr, (sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS *
+			   sizeof(u32))), req_ctx.cmdl,
+			   sizeof(sa_ctx->epib), sa_ctx->epib);
+
+	dmaengine_desc_set_metadata_len(tx_out, 28);
+
+	dmaengine_submit(tx_out);
+	dmaengine_submit(tx_in);
+
+	dma_async_issue_pending(dma_rx);
+	dma_async_issue_pending(pdata->dma_tx);
+
+	return -EINPROGRESS;
+}
+
+static int sa_sham_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	dev_dbg(sa_k3_dev, "init: digest size: %d\n",
+		crypto_ahash_digestsize(tfm));
+
+	return 0;
+}
+
+static int sa_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
+				const u8 *data, unsigned int len, u8 *out)
+{
+	SHASH_DESC_ON_STACK(shash, tfm);
+
+	shash->tfm = tfm;
+
+	return crypto_shash_digest(shash, data, len, out);
+}
+
+static int sa_sham_setkey(struct crypto_ahash *tfm, const u8 *key,
+			  unsigned int keylen, struct  algo_data *ad)
+{
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	int bs = crypto_shash_blocksize(ctx->shash);
+	int ds = crypto_shash_digestsize(ctx->shash);
+	int cmdl_len;
+	struct sa_cmdl_cfg cfg;
+	int err;
+
+	if (keylen > bs) {
+		err = sa_sham_shash_digest(ctx->shash,
+					   crypto_shash_get_flags(ctx->shash),
+					   key, keylen, ctx->authkey);
+		if (err)
+			return err;
+		keylen = ds;
+	} else {
+		memcpy(ctx->authkey, key, keylen);
+	}
+
+	memset(ctx->authkey + keylen, 0, bs - keylen);
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.enc1st = 0;
+	cfg.aalg = ad->aalg_id;
+	cfg.enc_eng_id = ad->enc_eng.eng_id;
+	cfg.auth_eng_id = ad->auth_eng.eng_id;
+	cfg.iv_size = 0;
+	cfg.akey = ctx->authkey;
+	cfg.akey_len = keylen;
+
+	/* Setup Encryption Security Context & Command label template */
+	if (sa_init_sc(&ctx->enc, NULL, 0, ctx->authkey, keylen, ad, 0,
+		       &ctx->enc.epib[1], true))
+		goto badkey;
+
+	cmdl_len = sa_format_cmdl_gen(&cfg,
+				      (u8 *)ctx->enc.cmdl,
+				      &ctx->enc.cmdl_upd_info);
+	if (cmdl_len <= 0 || (cmdl_len > SA_MAX_CMDL_WORDS * sizeof(u32)))
+		goto badkey;
+
+	ctx->enc.cmdl_size = cmdl_len;
+
+	kfree(ad);
+
+	return 0;
+badkey:
+	dev_err(sa_k3_dev, "%s: badkey\n", __func__);
+	return -EINVAL;
+}
+
+static int sa_sham_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
+
+	ad->enc_eng.eng_id = SA_ENG_ID_NONE;
+	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
+	ad->auth_eng.eng_id = SA_ENG_ID_AM1;
+	ad->auth_eng.sc_size = SA_CTX_AUTH_TYPE2_SZ;
+	ad->mci_enc = NULL;
+	ad->mci_dec = NULL;
+	ad->inv_key = false;
+	ad->keyed_mac = true;
+	ad->ealg_id = SA_EALG_ID_NONE;
+	ad->aalg_id = SA_AALG_ID_HMAC_SHA1;
+	ad->hash_size = SHA1_DIGEST_SIZE;
+	ad->auth_ctrl = 0x2;
+	ad->prep_iopad = sa_hmac_sha1_get_pad;
+
+	return sa_sham_setkey(tfm, key, keylen, ad);
+}
+
+static int sa_sham_cra_sha1_init(struct crypto_tfm *tfm)
+{
+	return sa_sham_cra_init_alg(tfm, "sha1");
+}
+
+static void sa_sham_cra_exit(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
+
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
+		ctx->dec.sc_id, &ctx->dec.sc_phys);
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_AHASH)
+	    == CRYPTO_ALG_TYPE_AHASH) {
+		sa_free_ctx_info(&ctx->enc, data);
+	}
+}
+
+static int sa_sham_update(struct ahash_request *req)
+{
+	return -ENOTSUPP;
+}
+
+static int sa_sham_final(struct ahash_request *req)
+{
+	return sa_sham_digest(req);
+}
+
+static int sa_sham_finup(struct ahash_request *req)
+{
+	return sa_sham_digest(req);
+}
+
 static struct sa_alg_tmpl sa_algs[] = {
 	{.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 	 .alg.crypto = {
@@ -1512,6 +1813,34 @@ static struct sa_alg_tmpl sa_algs[] = {
 	},
 };
 
+static struct ahash_alg algs_sha[] = {
+{
+	.init		= sa_sham_init,
+	.update		= sa_sham_update,
+	.final		= sa_sham_final,
+	.finup		= sa_sham_finup,
+	.digest		= sa_sham_digest,
+	.setkey		= sa_sham_sha1_setkey,
+	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.statesize		= 128,
+	.halg.base	= {
+		.cra_name		= "hmac(sha1)",
+		.cra_driver_name	= "sa-hmac-sha1",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct sa_tfm_ctx),
+		.cra_alignmask		= SA_ALIGN_MASK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= sa_sham_cra_sha1_init,
+		.cra_exit		= sa_sham_cra_exit,
+	}
+},
+};
+
 /* Register the algorithms in crypto framework */
 void sa_register_algos(const struct device *dev)
 {
@@ -1539,6 +1868,15 @@ void sa_register_algos(const struct device *dev)
 		else
 			sa_algs[i].registered = 1;
 	}
+
+	num_algs = ARRAY_SIZE(algs_sha);
+	for (i = 0; i < num_algs; i++) {
+		alg_name =  algs_sha[i].halg.base.cra_name;
+		err = crypto_register_ahash(&algs_sha[i]);
+		if (err)
+			dev_err(dev, "Failed to register '%s'\n",
+				alg_name);
+	}
 }
 
 /* Unregister the algorithms in crypto framework */
@@ -1560,6 +1898,15 @@ void sa_unregister_algos(const struct device *dev)
 
 		sa_algs[i].registered = 0;
 	}
+
+	num_algs = ARRAY_SIZE(algs_sha);
+	for (i = 0; i < num_algs; i++) {
+		alg_name =  algs_sha[i].halg.base.cra_name;
+		err = crypto_unregister_ahash(&algs_sha[i]);
+		if (err)
+			dev_err(dev, "Failed to register '%s'\n",
+				alg_name);
+	}
 }
 
 static int sa_init_mem(struct sa_crypto_data *dev_data)
-- 
2.17.1

