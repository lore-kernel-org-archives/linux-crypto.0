Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E690C43141
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7217D21781
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051858;
	bh=iVeUiUs/ZUpqhRL/0mqrx/Uxstwgq2SwevxdXmZr3h8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mhtCvm2spD6HDpUEN3WNzBCGIh3+IK54+5bLwb7JoX38+dsJujz7WEV90CE/U0fBB
	 CqjlIUnnrQHdLETjdN+sc9/21eBtmeh1+ISpBycFWVU6oaXpvjBwat6mjAPMQP4S9T
	 tz2O2BFYbj3drtGblDmfU2+JSK6R/24FgeGUcWjY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfK2SYS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfK2SYR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:24:17 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DCE421774
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051857;
        bh=iVeUiUs/ZUpqhRL/0mqrx/Uxstwgq2SwevxdXmZr3h8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HXTg05XH/NwZssX5BTLc+9QP2Z7mcZBLhd8U3/8mdeGwFLhBZ7k2QL6KXTxN5H2tC
         OhZEeq9wDqhhbtxdUPGN5QosCfN+VDoE7UySRLxyyhdXiy+Lpck2Z9LjXEUyFx60vv
         0wyKCpMaPAEVavO4cB7SdB52o8BeJ7fp88F1JU38=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/6] crypto: skcipher - remove crypto_skcipher::setkey
Date:   Fri, 29 Nov 2019 10:23:05 -0800
Message-Id: <20191129182308.53961-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191129182308.53961-1-ebiggers@kernel.org>
References: <20191129182308.53961-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Due to the removal of the blkcipher and ablkcipher algorithm types,
crypto_skcipher::setkey now always points to skcipher_setkey().

Simplify by removing this function pointer and instead just making
skcipher_setkey() be crypto_skcipher_setkey() directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c         | 4 ++--
 include/crypto/skcipher.h | 9 ++-------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 6cfafd80c7e6..4197b5ed57c4 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -610,7 +610,7 @@ static int skcipher_setkey_unaligned(struct crypto_skcipher *tfm,
 	return ret;
 }
 
-static int skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct skcipher_alg *cipher = crypto_skcipher_alg(tfm);
@@ -635,6 +635,7 @@ static int skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_skcipher_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
 
 int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
@@ -683,7 +684,6 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(skcipher);
 
-	skcipher->setkey = skcipher_setkey;
 	skcipher->encrypt = alg->encrypt;
 	skcipher->decrypt = alg->decrypt;
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index d8c28c8186a4..ea94cc422b94 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -35,8 +35,6 @@ struct skcipher_request {
 };
 
 struct crypto_skcipher {
-	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
-	              unsigned int keylen);
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
 
@@ -364,11 +362,8 @@ static inline void crypto_sync_skcipher_clear_flags(
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-static inline int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
-					 const u8 *key, unsigned int keylen)
-{
-	return tfm->setkey(tfm, key, keylen);
-}
+int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
+			   const u8 *key, unsigned int keylen);
 
 static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
 					 const u8 *key, unsigned int keylen)
-- 
2.24.0

