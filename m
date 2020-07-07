Return-Path: <SRS0=MSze=AS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B69DC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 06:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08CB52074F
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 06:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594103626;
	bh=/hSweZjB6DuQzljyPwbZtGwfSoV4H4jE/MTAEhkVsHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PKHYMR8xOVbg7JPwVoDhjg4OtrSR0AOw+ZmewN+mbxvrDIrr51JoA4g24rmBQo49A
	 7pGqNuQzok+agTJsTXXGIeQWOAPAfyPymAxPsFrGxSeqeQQr9zbahbpwptF3+6iDjT
	 fzo+dvGP3R0teyjGFl1nkL65F8c6ey6J3IMitkPs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgGGGdp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jul 2020 02:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgGGGdp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jul 2020 02:33:45 -0400
Received: from e123331-lin.nice.arm.com (adsl-70.109.242.21.tellas.gr [109.242.21.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF904206DF;
        Tue,  7 Jul 2020 06:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594103624;
        bh=/hSweZjB6DuQzljyPwbZtGwfSoV4H4jE/MTAEhkVsHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yn8DbHgBm15HCFv/Sbc882J6rbUrtnX9WkL2K17XMntzNaPeLGw1b5/sg3cvI83q5
         kacEAPuwVmO528qp7LOXl5jFn2l/Q7sScKPipGqI1My5Hu1CwZg3bkglGt4UbT41b2
         SuVmz97de7RU69WTymTRg5dcZH9Iw9yqjCwzM4Eo=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Eric Biggers <ebiggers@google.com>,
        Tero Kristo <t-kristo@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v4 09/13] crypto: mxs-dcp - permit asynchronous skcipher as fallback
Date:   Tue,  7 Jul 2020 09:31:59 +0300
Message-Id: <20200707063203.5018-10-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200707063203.5018-1-ardb@kernel.org>
References: <20200707063203.5018-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Even though the mxs-dcp driver implements asynchronous versions of
ecb(aes) and cbc(aes), the fallbacks it allocates are required to be
synchronous. Given that SIMD based software implementations are usually
asynchronous as well, even though they rarely complete asynchronously
(this typically only happens in cases where the request was made from
softirq context, while SIMD was already in use in the task context that
it interrupted), these implementations are disregarded, and either the
generic C version or another table based version implemented in assembler
is selected instead.

Since falling back to synchronous AES is not only a performance issue, but
potentially a security issue as well (due to the fact that table based AES
is not time invariant), let's fix this, by allocating an ordinary skcipher
as the fallback, and invoke it with the completion routine that was given
to the outer request.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/mxs-dcp.c | 33 ++++++++++----------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d84530293036..909a7eb748e3 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -97,7 +97,7 @@ struct dcp_async_ctx {
 	unsigned int			hot:1;
 
 	/* Crypto-specific context */
-	struct crypto_sync_skcipher	*fallback;
+	struct crypto_skcipher		*fallback;
 	unsigned int			key_len;
 	uint8_t				key[AES_KEYSIZE_128];
 };
@@ -105,6 +105,7 @@ struct dcp_async_ctx {
 struct dcp_aes_req_ctx {
 	unsigned int	enc:1;
 	unsigned int	ecb:1;
+	struct skcipher_request fallback_req;	// keep at the end
 };
 
 struct dcp_sha_req_ctx {
@@ -426,21 +427,20 @@ static int dcp_chan_thread_aes(void *data)
 static int mxs_dcp_block_fallback(struct skcipher_request *req, int enc)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	struct dcp_async_ctx *ctx = crypto_skcipher_ctx(tfm);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 	int ret;
 
-	skcipher_request_set_sync_tfm(subreq, ctx->fallback);
-	skcipher_request_set_callback(subreq, req->base.flags, NULL, NULL);
-	skcipher_request_set_crypt(subreq, req->src, req->dst,
+	skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+	skcipher_request_set_callback(&rctx->fallback_req, req->base.flags,
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(&rctx->fallback_req, req->src, req->dst,
 				   req->cryptlen, req->iv);
 
 	if (enc)
-		ret = crypto_skcipher_encrypt(subreq);
+		ret = crypto_skcipher_encrypt(&rctx->fallback_req);
 	else
-		ret = crypto_skcipher_decrypt(subreq);
-
-	skcipher_request_zero(subreq);
+		ret = crypto_skcipher_decrypt(&rctx->fallback_req);
 
 	return ret;
 }
@@ -510,24 +510,25 @@ static int mxs_dcp_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	 * but is supported by in-kernel software implementation, we use
 	 * software fallback.
 	 */
-	crypto_sync_skcipher_clear_flags(actx->fallback, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(actx->fallback,
+	crypto_skcipher_clear_flags(actx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(actx->fallback,
 				  tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
-	return crypto_sync_skcipher_setkey(actx->fallback, key, len);
+	return crypto_skcipher_setkey(actx->fallback, key, len);
 }
 
 static int mxs_dcp_aes_fallback_init_tfm(struct crypto_skcipher *tfm)
 {
 	const char *name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 	struct dcp_async_ctx *actx = crypto_skcipher_ctx(tfm);
-	struct crypto_sync_skcipher *blk;
+	struct crypto_skcipher *blk;
 
-	blk = crypto_alloc_sync_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
+	blk = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(blk))
 		return PTR_ERR(blk);
 
 	actx->fallback = blk;
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct dcp_aes_req_ctx));
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct dcp_aes_req_ctx) +
+					 crypto_skcipher_reqsize(blk));
 	return 0;
 }
 
@@ -535,7 +536,7 @@ static void mxs_dcp_aes_fallback_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct dcp_async_ctx *actx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(actx->fallback);
+	crypto_free_skcipher(actx->fallback);
 }
 
 /*
-- 
2.17.1

