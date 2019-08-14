Return-Path: <SRS0=c3b/=WK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CBCC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 16:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2CA02084F
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 16:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ragNVR52"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfHNQiD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Aug 2019 12:38:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41060 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfHNQiD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Aug 2019 12:38:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so9453735wrr.8
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2019 09:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=huVoFUpMc5dzWwrmJm9Qwvn6MCUViGlDp2QJ3557fZk=;
        b=ragNVR52SU7yFm2HpInP2o5CswTXmWmluhWWZcb6B2i/bJKQfv6DK7xYdwkvG2Dic4
         niKD1R8UlOoSIe8R9wwCCa0cuWJ3h6g/bNQmr4j4AktQCs/RWFHGmUFngeUfFFkWQ62g
         pnDp32CwMFe/wHekoMuBI5/klyRwYRtgpVmnRKHKLE1X9x6KCiCxFErMB405Ev/6OQQz
         Rx23vI6cnQo28529RKsaaiw5lsoMb5kgYke18SP9608ZOW/54xy3qVTU81b0puV7VFvN
         Pqf6agW69/JI1nJ0Bxq0KwOdHFdFNQTQfxnbidKSc0nCN9E9iDaNs6ppEOJjwedQDnME
         Vbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=huVoFUpMc5dzWwrmJm9Qwvn6MCUViGlDp2QJ3557fZk=;
        b=PVhufv7GZzObdnTpx6wUSvOTiA+TctoUs4l74K0ZDJKfWO7AezXOTySWPhw3PvqkuK
         Raz0FogHVCRPA/O/0XgBNNdnzS/1xLZ+u0TIHzZd8rleU53zI/YKhhdar083ut7gi+XD
         lniwlsjW06bCpKWvm1DwqeM9OCBpL9GnlxD4ykqWj6/7cuOryAxvx6zBCCN2kWo0tqUH
         AZ8K7SURg2KpfeKDbdfOCG8hMog7B7V4LXWeBOs5R91Q/RB0tHw2zm+jP/AS8JsCnTY9
         /pT020wjhI/eRbMQEuChlxgS0SPF8nR5f5cPMovKPvMTb8KJNVd1vDBMGgKGNt++g2/m
         qaCg==
X-Gm-Message-State: APjAAAXdkPvt2ttzRLO72y6c4yxC8zN0T6wm3xVtxFK09mPEATh4YDUo
        oDr5jqJnYneeRFE004LjfAVcc2Hngqw4VA==
X-Google-Smtp-Source: APXvYqwHNORZCnin+4ezRGp4YwerfDUFzkrHwOl+Q4sbbejzq105yi5d1EoHWGATPrU0pDK6hfGpUg==
X-Received: by 2002:a05:6000:1c8:: with SMTP id t8mr630438wrx.296.1565800679948;
        Wed, 14 Aug 2019 09:37:59 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:1c0e:f938:89a1:8e17])
        by smtp.gmail.com with ESMTPSA id 39sm610724wrc.45.2019.08.14.09.37.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:37:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v11 3/4] crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
Date:   Wed, 14 Aug 2019 19:37:45 +0300
Message-Id: <20190814163746.3525-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The plain CBC driver and the CTS one share some code that iterates over
a scatterwalk and invokes the CBC asm code to do the processing. The
upcoming ESSIV/CBC mode will clone that pattern for the third time, so
let's factor it out first.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 82 ++++++++++----------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 55d6d4838708..23abf335f1ee 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -186,46 +186,64 @@ static int ecb_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int cbc_encrypt(struct skcipher_request *req)
+static int cbc_encrypt_walk(struct skcipher_request *req,
+			    struct skcipher_walk *walk)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, rounds = 6 + ctx->key_length / 4;
-	struct skcipher_walk walk;
+	int err = 0, rounds = 6 + ctx->key_length / 4;
 	unsigned int blocks;
 
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
-		aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				ctx->key_enc, rounds, blocks, walk.iv);
+		aes_cbc_encrypt(walk->dst.virt.addr, walk->src.virt.addr,
+				ctx->key_enc, rounds, blocks, walk->iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
 
-static int cbc_decrypt(struct skcipher_request *req)
+static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
-	unsigned int blocks;
+	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+	return cbc_encrypt_walk(req, &walk);
+}
 
-	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+static int cbc_decrypt_walk(struct skcipher_request *req,
+			    struct skcipher_walk *walk)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err = 0, rounds = 6 + ctx->key_length / 4;
+	unsigned int blocks;
+
+	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
-		aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				ctx->key_dec, rounds, blocks, walk.iv);
+		aes_cbc_decrypt(walk->dst.virt.addr, walk->src.virt.addr,
+				ctx->key_dec, rounds, blocks, walk->iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
 
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+	return cbc_decrypt_walk(req, &walk);
+}
+
 static int cts_cbc_init_tfm(struct crypto_skcipher *tfm)
 {
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct cts_cbc_req_ctx));
@@ -251,22 +269,12 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	}
 
 	if (cbc_blocks > 0) {
-		unsigned int blocks;
-
 		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
 					   cbc_blocks * AES_BLOCK_SIZE,
 					   req->iv);
 
-		err = skcipher_walk_virt(&walk, &rctx->subreq, false);
-
-		while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
-			kernel_neon_begin();
-			aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-					ctx->key_enc, rounds, blocks, walk.iv);
-			kernel_neon_end();
-			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
-		}
+		err = skcipher_walk_virt(&walk, &rctx->subreq, false) ?:
+		      cbc_encrypt_walk(&rctx->subreq, &walk);
 		if (err)
 			return err;
 
@@ -316,22 +324,12 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	}
 
 	if (cbc_blocks > 0) {
-		unsigned int blocks;
-
 		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
 					   cbc_blocks * AES_BLOCK_SIZE,
 					   req->iv);
 
-		err = skcipher_walk_virt(&walk, &rctx->subreq, false);
-
-		while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
-			kernel_neon_begin();
-			aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-					ctx->key_dec, rounds, blocks, walk.iv);
-			kernel_neon_end();
-			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
-		}
+		err = skcipher_walk_virt(&walk, &rctx->subreq, false) ?:
+		      cbc_decrypt_walk(&rctx->subreq, &walk);
 		if (err)
 			return err;
 
-- 
2.17.1

