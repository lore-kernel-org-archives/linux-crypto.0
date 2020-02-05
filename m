Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B26C35249
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 05:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE88217BA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 05:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgBEFT3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 00:19:29 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:40162 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgBEFT3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 00:19:29 -0500
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0155J7iS019895;
        Tue, 4 Feb 2020 21:19:23 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH crypto/chcr 1/2] This fixes the libkcapi's cbc(aes) aio fail test cases
Date:   Wed,  5 Feb 2020 10:48:41 +0530
Message-Id: <20200205051842.29324-2-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.25.0.114.g5b0ca87
In-Reply-To: <20200205051842.29324-1-ayush.sawal@chelsio.com>
References: <20200205051842.29324-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The libkcapi "cbc(aes)" failed tests are
symmetric asynchronous cipher one shot multiple test,
symmetric asynchronous cipher stream multiple test,
Symmetric asynchronous cipher vmsplice multiple test

In this patch a wait_for_completion is added in the chcr_aes_encrypt function,
which completes when the response of comes from the hardware.
This adds serialization for encryption in cbc(aes) aio case.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 20 +++++++++++++++++++-
 drivers/crypto/chelsio/chcr_crypto.h |  1 +
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index b4b9b22125d1..699e3053895a 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1102,6 +1102,7 @@ static int chcr_handle_cipher_resp(struct skcipher_request *req,
 				   unsigned char *input, int err)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chcr_context *ctx = c_ctx(tfm);
 	struct uld_ctx *u_ctx = ULD_CTX(c_ctx(tfm));
 	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(tfm));
 	struct sk_buff *skb;
@@ -1166,10 +1167,20 @@ static int chcr_handle_cipher_resp(struct skcipher_request *req,
 	chcr_send_wr(skb);
 	reqctx->last_req_len = bytes;
 	reqctx->processed += bytes;
+	if (get_cryptoalg_subtype(tfm) ==
+		CRYPTO_ALG_SUB_TYPE_CBC && req->base.flags ==
+			CRYPTO_TFM_REQ_MAY_SLEEP ) {
+		complete(&ctx->cbc_aes_aio_done);
+	}
 	return 0;
 unmap:
 	chcr_cipher_dma_unmap(&ULD_CTX(c_ctx(tfm))->lldi.pdev->dev, req);
 complete:
+	if (get_cryptoalg_subtype(tfm) ==
+		CRYPTO_ALG_SUB_TYPE_CBC && req->base.flags ==
+			CRYPTO_TFM_REQ_MAY_SLEEP ) {
+		complete(&ctx->cbc_aes_aio_done);
+	}
 	chcr_dec_wrcount(dev);
 	req->base.complete(&req->base, err);
 	return err;
@@ -1289,6 +1300,7 @@ static int process_cipher(struct skcipher_request *req,
 static int chcr_aes_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chcr_context *ctx;
 	struct chcr_dev *dev = c_ctx(tfm)->dev;
 	struct sk_buff *skb = NULL;
 	int err, isfull = 0;
@@ -1313,6 +1325,12 @@ static int chcr_aes_encrypt(struct skcipher_request *req)
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, c_ctx(tfm)->tx_qidx);
 	chcr_send_wr(skb);
+	if (get_cryptoalg_subtype(tfm) ==
+		CRYPTO_ALG_SUB_TYPE_CBC && req->base.flags ==
+			CRYPTO_TFM_REQ_MAY_SLEEP ) {
+			ctx=c_ctx(tfm);
+			wait_for_completion(&ctx->cbc_aes_aio_done);
+        }
 	return isfull ? -EBUSY : -EINPROGRESS;
 error:
 	chcr_dec_wrcount(dev);
@@ -1401,7 +1419,7 @@ static int chcr_init_tfm(struct crypto_skcipher *tfm)
 		pr_err("failed to allocate fallback for %s\n", alg->base.cra_name);
 		return PTR_ERR(ablkctx->sw_cipher);
 	}
-
+	init_completion(&ctx->cbc_aes_aio_done);
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct chcr_skcipher_req_ctx));
 
 	return chcr_device_init(ctx);
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 6db2df8c8a05..9207d88c5538 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -254,6 +254,7 @@ struct chcr_context {
 	unsigned char rx_qidx;
 	unsigned char tx_chan_id;
 	unsigned char pci_chan_id;
+	struct completion cbc_aes_aio_done;
 	struct __crypto_ctx crypto_ctx[0];
 };
 
-- 
2.25.0.114.g5b0ca87

