Return-Path: <SRS0=YBhh=TS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCBAC072A4
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 21:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EC420989
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 21:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fN4JIGbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfERV2R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 May 2019 17:28:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35120 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729427AbfERV2R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 May 2019 17:28:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id m3so10355986wrv.2
        for <linux-crypto@vger.kernel.org>; Sat, 18 May 2019 14:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=buuRA0+ZNjk9EJqhO5LGsGtnzENoOkV4mmvnkS4RRvc=;
        b=fN4JIGbJm9T56VsW3CLNO79vnc6IgJxVrGUQJyuzqeDBqnyc3JdX5R6bY9XJzjuBrS
         fUHObH6WEobLB+ORlSCa9odqX+1mapLvVbJdxg5C14l/Kt0T2VTnJyYZCW8+2n4Zkw+O
         G7yJOQPO1oIE2vGTf37bppfxwgs8lP6jMY2N4ABSTOfZAXu3RAksjQX8tHSC9JRPGQbi
         0OiptjRGjtYI08jiPrGvw3f/X7ZUDA47wHSGQj2Y8Vy2Kr6WPW9VFqjEkjekyHGtSG0P
         siFt6davg4FXJqKiK+TsIjBk749vIPZILuq4LLRcjx2HYAKhnNeBEzekr+4b4gQT6DcC
         jRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=buuRA0+ZNjk9EJqhO5LGsGtnzENoOkV4mmvnkS4RRvc=;
        b=eiTDMoOOqRosBiR0/U6D5AxpNY40yJH0xvXaMUgQqHpvKdK4qUhug054+wVIYVwA6F
         y9xXYAhyne/AKucQBsb1ssPai9otUYBmI8VMctpNPCmbPeGmN4o8J2vqOQ7oiC3HEXbq
         1jheAQ5Aa9m3DnRw+tmcAMmLHkwl0GW/jv2N60kKf9KbFtbVLm/RC6kvx9uSK0K4vB9V
         dEb2rk75zb+wNylMryLiacsJ2oxz0FTUhesM6+oezF9h+1Vlnld1Gqa9E8kIcTl8T1jI
         QwOsUwS1oPGivbcHNUTFvj+hiYMqEYy6YA2U2R8KBlWEV1jKzVY66fdqN2eVnsLLV1PO
         qdCw==
X-Gm-Message-State: APjAAAXGvoQ1JLP1AQ5fa6OLnbizYqQXMyaxjxoognNesvXAo9/izYr1
        oFKdLBxlrSJSbLZy0GioRXwhhDJG
X-Google-Smtp-Source: APXvYqwIUyOQ8YedrbgsvKzF0rpHuc4nFi1nWrZ91Y9qbuee5kvI9puBDdZTBBZXNKSkdZ7pV2IWQQ==
X-Received: by 2002:a5d:4d51:: with SMTP id a17mr6158106wru.260.1558214893952;
        Sat, 18 May 2019 14:28:13 -0700 (PDT)
Received: from debian64.daheim (p4FD0962E.dip0.t-ipconnect.de. [79.208.150.46])
        by smtp.gmail.com with ESMTPSA id x5sm13762549wrt.72.2019.05.18.14.28.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 May 2019 14:28:12 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hS6sG-0005aB-23; Sat, 18 May 2019 23:28:12 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: crypto4xx - block ciphers should only accept complete blocks
Date:   Sat, 18 May 2019 23:28:12 +0200
Message-Id: <20190518212812.21414-2-chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190518212812.21414-1-chunkeey@gmail.com>
References: <20190518212812.21414-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The hardware automatically zero pads incomplete block ciphers
blocks without raising any errors. This is a screw-up. This
was noticed by CONFIG_CRYPTO_MANAGER_EXTRA_TESTS tests that
sent a incomplete blocks and expect them to fail.

This fixes:
cbc-aes-ppc4xx encryption unexpectedly succeeded on test vector
"random: len=2409 klen=32"; expected_error=-22, cfg="random:
may_sleep use_digest src_divs=[96.90%@+2295, 2.34%@+4066,
0.32%@alignmask+12, 0.34%@+4087, 0.9%@alignmask+1787, 0.1%@+3767]
iv_offset=6"

ecb-aes-ppc4xx encryption unexpectedly succeeded on test vector
"random: len=1011 klen=32"; expected_error=-22, cfg="random:
may_sleep use_digest src_divs=[100.0%@alignmask+20]
dst_divs=[3.12%@+3001, 96.88%@+4070]"

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org [4.19, 5.0 and 5.1]
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

---

Note: This bug was present in the original driver code from
the very beginning in 2009. However the crypto4xx driver only
started to become useful for RevB 460EX, 460SX and later cores
(like the APM821xx) by
commit b66c685a482 ("crypto: crypto4xx - support Revision B parts")
---
 drivers/crypto/amcc/crypto4xx_alg.c  | 36 +++++++++++++++++++---------
 drivers/crypto/amcc/crypto4xx_core.c | 16 ++++++-------
 drivers/crypto/amcc/crypto4xx_core.h | 10 ++++----
 3 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 307f5cfa9ba4..26f86fd7532b 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -76,12 +76,16 @@ static void set_dynamic_sa_command_1(struct dynamic_sa_ctl *sa, u32 cm,
 }
 
 static inline int crypto4xx_crypt(struct skcipher_request *req,
-				  const unsigned int ivlen, bool decrypt)
+				  const unsigned int ivlen, bool decrypt,
+				  bool check_blocksize)
 {
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
 	struct crypto4xx_ctx *ctx = crypto_skcipher_ctx(cipher);
 	__le32 iv[AES_IV_SIZE];
 
+	if (check_blocksize && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE))
+		return -EINVAL;
+
 	if (ivlen)
 		crypto4xx_memcpy_to_le32(iv, req->iv, ivlen);
 
@@ -90,24 +94,34 @@ static inline int crypto4xx_crypt(struct skcipher_request *req,
 		ctx->sa_len, 0, NULL);
 }
 
-int crypto4xx_encrypt_noiv(struct skcipher_request *req)
+int crypto4xx_encrypt_noiv_block(struct skcipher_request *req)
+{
+	return crypto4xx_crypt(req, 0, false, true);
+}
+
+int crypto4xx_encrypt_iv_stream(struct skcipher_request *req)
+{
+	return crypto4xx_crypt(req, AES_IV_SIZE, false, false);
+}
+
+int crypto4xx_decrypt_noiv_block(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, 0, false);
+	return crypto4xx_crypt(req, 0, true, true);
 }
 
-int crypto4xx_encrypt_iv(struct skcipher_request *req)
+int crypto4xx_decrypt_iv_stream(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, AES_IV_SIZE, false);
+	return crypto4xx_crypt(req, AES_IV_SIZE, true, false);
 }
 
-int crypto4xx_decrypt_noiv(struct skcipher_request *req)
+int crypto4xx_encrypt_iv_block(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, 0, true);
+	return crypto4xx_crypt(req, AES_IV_SIZE, false, true);
 }
 
-int crypto4xx_decrypt_iv(struct skcipher_request *req)
+int crypto4xx_decrypt_iv_block(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, AES_IV_SIZE, true);
+	return crypto4xx_crypt(req, AES_IV_SIZE, true, true);
 }
 
 /**
@@ -278,8 +292,8 @@ crypto4xx_ctr_crypt(struct skcipher_request *req, bool encrypt)
 		return ret;
 	}
 
-	return encrypt ? crypto4xx_encrypt_iv(req)
-		       : crypto4xx_decrypt_iv(req);
+	return encrypt ? crypto4xx_encrypt_iv_stream(req)
+		       : crypto4xx_decrypt_iv_stream(req);
 }
 
 static int crypto4xx_sk_setup_fallback(struct crypto4xx_ctx *ctx,
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 5f2709cffc5b..45f65d638caf 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1219,8 +1219,8 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.ivsize	= AES_IV_SIZE,
 		.setkey = crypto4xx_setkey_aes_cbc,
-		.encrypt = crypto4xx_encrypt_iv,
-		.decrypt = crypto4xx_decrypt_iv,
+		.encrypt = crypto4xx_encrypt_iv_block,
+		.decrypt = crypto4xx_decrypt_iv_block,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
@@ -1239,8 +1239,8 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.ivsize	= AES_IV_SIZE,
 		.setkey	= crypto4xx_setkey_aes_cfb,
-		.encrypt = crypto4xx_encrypt_iv,
-		.decrypt = crypto4xx_decrypt_iv,
+		.encrypt = crypto4xx_encrypt_iv_stream,
+		.decrypt = crypto4xx_decrypt_iv_stream,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
@@ -1299,8 +1299,8 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.min_keysize = AES_MIN_KEY_SIZE,
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.setkey	= crypto4xx_setkey_aes_ecb,
-		.encrypt = crypto4xx_encrypt_noiv,
-		.decrypt = crypto4xx_decrypt_noiv,
+		.encrypt = crypto4xx_encrypt_noiv_block,
+		.decrypt = crypto4xx_decrypt_noiv_block,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
@@ -1319,8 +1319,8 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.ivsize	= AES_IV_SIZE,
 		.setkey	= crypto4xx_setkey_aes_ofb,
-		.encrypt = crypto4xx_encrypt_iv,
-		.decrypt = crypto4xx_decrypt_iv,
+		.encrypt = crypto4xx_encrypt_iv_stream,
+		.decrypt = crypto4xx_decrypt_iv_stream,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index c624f8cd3d2e..8ca082666736 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -182,10 +182,12 @@ int crypto4xx_setkey_rfc3686(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
 int crypto4xx_encrypt_ctr(struct skcipher_request *req);
 int crypto4xx_decrypt_ctr(struct skcipher_request *req);
-int crypto4xx_encrypt_iv(struct skcipher_request *req);
-int crypto4xx_decrypt_iv(struct skcipher_request *req);
-int crypto4xx_encrypt_noiv(struct skcipher_request *req);
-int crypto4xx_decrypt_noiv(struct skcipher_request *req);
+int crypto4xx_encrypt_iv_stream(struct skcipher_request *req);
+int crypto4xx_decrypt_iv_stream(struct skcipher_request *req);
+int crypto4xx_encrypt_iv_block(struct skcipher_request *req);
+int crypto4xx_decrypt_iv_block(struct skcipher_request *req);
+int crypto4xx_encrypt_noiv_block(struct skcipher_request *req);
+int crypto4xx_decrypt_noiv_block(struct skcipher_request *req);
 int crypto4xx_rfc3686_encrypt(struct skcipher_request *req);
 int crypto4xx_rfc3686_decrypt(struct skcipher_request *req);
 int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
-- 
2.20.1

