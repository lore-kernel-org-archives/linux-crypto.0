Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1740C33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 616A82467A
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b9ZF2ddh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgANOAQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54620 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgANOAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 09:00:04 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so13872648wmj.4;
        Tue, 14 Jan 2020 06:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AaGocOWYYqqxxVSnuFJaes6fIuVCOqjGVL46fuoWceA=;
        b=b9ZF2ddhd9zGkBUQfYFINe52pfdd1cQRB5F71PoXqYhsv0I8C5zSpPdxZldg1b50IX
         rRbXf0DOHBwabaizpHXOVgrzXx5h1pybWotTD745Mh2HMmCt3jeVIpDjfrBOLPWRn2hw
         sdpmhM8LJLIUpPTw60uqNDGVdrNhK5EgVjV/Sva1mfNFlROzQfwcX7Gkj9tTwPCLXPlI
         RZ5xfscNXx+zApX/Fy0SGHwyPKv7Vwcl/HsdZ1P4zFADNJyFc6Xuwpp6gatMrFaf15bK
         MlKgfS22UUABgUklrYWfOLgo9eaCJJ7QX/eXvzzcsumnQhuGTe7TfacEeL6CGr/7pTqK
         E8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AaGocOWYYqqxxVSnuFJaes6fIuVCOqjGVL46fuoWceA=;
        b=mzx2uIVQntkHBvtKtFDdMkOsFngNjmPiaXG+wP8vo5bBuu2Ry88074LF6XK5YyBNT0
         DvzsUEF7MogSeN5D3GPgqc3xRzYgF6t7NWpsgHe9rqbf57JGDkeTC0/lYa1/XhLl+Qdt
         64tys/h+55dQ6HMUUWEh+qtkbnKR5kPAR1erF47LBFFm9iLbuYgw50wjAON6Zi5ILPah
         QV2d+IljGk/KmxLzpQgzfKDjR2k2Ovy/ptC0kha8Urb1rlKXf6chrcNkCDqyHCiHM/gQ
         K2LdGIQVjFV8h1O8pli2A2qY/UVsWYB6NPOvby6G1ex27eJkbnbQ8In3MNeD8gMkewAM
         0+PA==
X-Gm-Message-State: APjAAAVakV5MyfL8D5f9uRGBLm10f1eTGB/bm+h28l4YBkFxYW2ORuwT
        cJnC1Subfn7i1CzGg/kRh0A=
X-Google-Smtp-Source: APXvYqx+OxKcWRqq8m9tk4fmOp55+mC1hDkwaWDzxu8S8kxilLu0l5ArdfWrRaXSdKdve/5st6FN/Q==
X-Received: by 2002:a05:600c:2383:: with SMTP id m3mr28610665wma.32.1579010402204;
        Tue, 14 Jan 2020 06:00:02 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.06.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 06:00:01 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     alexandre.torgue@st.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, mcoquelin.stm32@gmail.com,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 08/10] crypto: engine: add slot parameter
Date:   Tue, 14 Jan 2020 14:59:34 +0100
Message-Id: <20200114135936.32422-9-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

prepare/unprepare functions should be able to know which slot in a batch
should be used for preparing a request.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c                              | 4 ++--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 6 ++----
 drivers/crypto/omap-aes-gcm.c                       | 2 +-
 drivers/crypto/omap-aes.c                           | 4 ++--
 drivers/crypto/omap-des.c                           | 4 ++--
 drivers/crypto/stm32/stm32-cryp.c                   | 8 ++++----
 drivers/crypto/stm32/stm32-hash.c                   | 4 ++--
 include/crypto/engine.h                             | 4 ++--
 8 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 591dea5ddeec..e23a398ba330 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -40,7 +40,7 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 			enginectx = crypto_tfm_ctx(engine->cur_reqs[i].req->tfm);
 			if (engine->cur_reqs[i].prepared &&
 			    enginectx->op.unprepare_request) {
-				ret = enginectx->op.unprepare_request(engine, engine->cur_reqs[i].req);
+				ret = enginectx->op.unprepare_request(engine, engine->cur_reqs[i].req, i);
 				if (ret)
 					dev_err(engine->dev, "failed to unprepare request\n");
 			}
@@ -143,7 +143,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	enginectx = crypto_tfm_ctx(async_req->tfm);
 
 	if (enginectx->op.prepare_request) {
-		ret = enginectx->op.prepare_request(engine, async_req);
+		ret = enginectx->op.prepare_request(engine, async_req, engine->ct);
 		if (ret) {
 			dev_err(engine->dev, "failed to prepare request: %d\n",
 				ret);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index d56c992fbf93..41d18c18d1d1 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -78,7 +78,7 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
 	return err;
 }
 
-static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req)
+static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req, int slot)
 {
 	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
@@ -96,7 +96,6 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	int flow, i;
 	int nr_sgs = 0;
 	int nr_sgd = 0;
-	int slot = 0;
 	int err = 0;
 
 	if (slot < 0 || slot >= MAXTASK)
@@ -296,7 +295,7 @@ int sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
 	return 0;
 }
 
-static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_req)
+static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_req, int slot)
 {
 	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
@@ -308,7 +307,6 @@ static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_r
 	unsigned int ivsize, offset;
 	int nr_sgs = rctx->nr_sgs;
 	int nr_sgd = rctx->nr_sgd;
-	int slot = 0;
 	int flow;
 
 	flow = rctx->flow;
diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 32dc00dc570b..0fea3dd40378 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -213,7 +213,7 @@ static int omap_aes_gcm_handle_queue(struct omap_aes_dev *dd,
 	return 0;
 }
 
-static int omap_aes_gcm_prepare_req(struct crypto_engine *engine, void *areq)
+static int omap_aes_gcm_prepare_req(struct crypto_engine *engine, void *areq, int slot)
 {
 	struct aead_request *req = container_of(areq, struct aead_request,
 						base);
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 824ddf2a66ff..4d9caa7ce8da 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -427,7 +427,7 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 }
 
 static int omap_aes_prepare_req(struct crypto_engine *engine,
-				void *areq)
+				void *areq, int slot)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct omap_aes_ctx *ctx = crypto_skcipher_ctx(
@@ -632,7 +632,7 @@ static int omap_aes_ctr_decrypt(struct skcipher_request *req)
 }
 
 static int omap_aes_prepare_req(struct crypto_engine *engine,
-				void *req);
+				void *req, int slot);
 static int omap_aes_crypt_req(struct crypto_engine *engine,
 			      void *req);
 
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 8eda43319204..92c5fb1d4b83 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -524,7 +524,7 @@ static int omap_des_handle_queue(struct omap_des_dev *dd,
 }
 
 static int omap_des_prepare_req(struct crypto_engine *engine,
-				void *areq)
+				void *areq, int slot)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct omap_des_ctx *ctx = crypto_skcipher_ctx(
@@ -711,7 +711,7 @@ static int omap_des_cbc_decrypt(struct skcipher_request *req)
 }
 
 static int omap_des_prepare_req(struct crypto_engine *engine,
-				void *areq);
+				void *areq, int slot);
 static int omap_des_crypt_req(struct crypto_engine *engine,
 			      void *areq);
 
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index d347a1d6e351..7c65b526d20e 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -684,7 +684,7 @@ static int stm32_cryp_cpu_start(struct stm32_cryp *cryp)
 
 static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq);
 static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
-					 void *areq);
+					 void *areq, int slot);
 
 static int stm32_cryp_init_tfm(struct crypto_skcipher *tfm)
 {
@@ -700,7 +700,7 @@ static int stm32_cryp_init_tfm(struct crypto_skcipher *tfm)
 
 static int stm32_cryp_aead_one_req(struct crypto_engine *engine, void *areq);
 static int stm32_cryp_prepare_aead_req(struct crypto_engine *engine,
-				       void *areq);
+				       void *areq, int slot);
 
 static int stm32_cryp_aes_aead_init(struct crypto_aead *tfm)
 {
@@ -1015,7 +1015,7 @@ static int stm32_cryp_prepare_req(struct skcipher_request *req,
 }
 
 static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
-					 void *areq)
+					 void *areq, int slot)
 {
 	struct skcipher_request *req = container_of(areq,
 						      struct skcipher_request,
@@ -1039,7 +1039,7 @@ static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq)
 	return stm32_cryp_cpu_start(cryp);
 }
 
-static int stm32_cryp_prepare_aead_req(struct crypto_engine *engine, void *areq)
+static int stm32_cryp_prepare_aead_req(struct crypto_engine *engine, void *areq, int slot)
 {
 	struct aead_request *req = container_of(areq, struct aead_request,
 						base);
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 167b80eec437..4a696c48126c 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -824,7 +824,7 @@ static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 }
 
 static int stm32_hash_one_request(struct crypto_engine *engine, void *areq);
-static int stm32_hash_prepare_req(struct crypto_engine *engine, void *areq);
+static int stm32_hash_prepare_req(struct crypto_engine *engine, void *areq, int slot);
 
 static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
 				   struct ahash_request *req)
@@ -832,7 +832,7 @@ static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
 	return crypto_transfer_hash_request_to_engine(hdev->engine, req);
 }
 
-static int stm32_hash_prepare_req(struct crypto_engine *engine, void *areq)
+static int stm32_hash_prepare_req(struct crypto_engine *engine, void *areq, int slot)
 {
 	struct ahash_request *req = container_of(areq, struct ahash_request,
 						 base);
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 021136a47b93..55d3dbc2498c 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -85,9 +85,9 @@ struct crypto_engine {
  */
 struct crypto_engine_op {
 	int (*prepare_request)(struct crypto_engine *engine,
-			       void *areq);
+			       void *areq, int slot);
 	int (*unprepare_request)(struct crypto_engine *engine,
-				 void *areq);
+				 void *areq, int slot);
 	int (*do_one_request)(struct crypto_engine *engine,
 			      void *areq);
 };
-- 
2.24.1

