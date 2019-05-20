Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45033C04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1213121726
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558371330;
	bh=BPPLCAQ20Y/EJV4m5xTTlaHxjS7C+6g4yLsARgAr1vU=;
	h=From:To:Subject:Date:List-ID:From;
	b=FRLTJH0/jNFy/JCjOmP/P4JSdzkXuR+L35VRJSBOBR34azliuW9WapBsAVHZnBRyc
	 4YD9DFXeZFinsVoGUSRkMApYQoPzzuVNNBlpulKe5efByMC5bl3hPyVHqcIw8Yguk1
	 v3ftwWvUdXats0B5KNC8ArLmx3LolCqp1bgOrNa8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389604AbfETQz3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388746AbfETQz3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:55:29 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A1582171F;
        Mon, 20 May 2019 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558371328;
        bh=BPPLCAQ20Y/EJV4m5xTTlaHxjS7C+6g4yLsARgAr1vU=;
        h=From:To:Subject:Date:From;
        b=lVKMKqlLuXGW42khCnillFELWpzqJoydkdxIUEnzshyCx6wG25apPSrZjT5kzJopU
         8nn8Gla/85fOxeIsS9lYtszrP1Nbh23gp+8lL2zMENzqjjYJCuaIDZo8jOzQIeX+47
         W/1F71ez0jBjD/EJBsdrp9NPhpvppHKMyytdNPvw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: algapi - remove crypto_tfm_in_queue()
Date:   Mon, 20 May 2019 09:55:15 -0700
Message-Id: <20190520165515.169823-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove the crypto_tfm_in_queue() function, which is unused.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c                | 13 -------------
 include/crypto/algapi.h        |  7 -------
 include/crypto/internal/hash.h |  6 ------
 3 files changed, 26 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 4c9c86b557381..7c51f45d1cf16 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -952,19 +952,6 @@ struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
 }
 EXPORT_SYMBOL_GPL(crypto_dequeue_request);
 
-int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm)
-{
-	struct crypto_async_request *req;
-
-	list_for_each_entry(req, &queue->list, list) {
-		if (req->tfm == tfm)
-			return 1;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_tfm_in_queue);
-
 static inline void crypto_inc_byte(u8 *a, unsigned int size)
 {
 	u8 *b = (a + size);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 4be38cd0b8d55..964a26fa4ff46 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -194,7 +194,6 @@ void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
 int crypto_enqueue_request(struct crypto_queue *queue,
 			   struct crypto_async_request *request);
 struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue);
-int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm);
 static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 {
 	return queue->qlen;
@@ -376,12 +375,6 @@ static inline void *ablkcipher_request_ctx(struct ablkcipher_request *req)
 	return req->__ctx;
 }
 
-static inline int ablkcipher_tfm_in_queue(struct crypto_queue *queue,
-					  struct crypto_ablkcipher *tfm)
-{
-	return crypto_tfm_in_queue(queue, crypto_ablkcipher_tfm(tfm));
-}
-
 static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
 						     u32 type, u32 mask)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index e355fdb642a92..669b4ee5c16d2 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -201,12 +201,6 @@ static inline struct ahash_request *ahash_dequeue_request(
 	return ahash_request_cast(crypto_dequeue_request(queue));
 }
 
-static inline int ahash_tfm_in_queue(struct crypto_queue *queue,
-					  struct crypto_ahash *tfm)
-{
-	return crypto_tfm_in_queue(queue, crypto_ahash_tfm(tfm));
-}
-
 static inline void *crypto_shash_ctx(struct crypto_shash *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
-- 
2.21.0.1020.gf2820cf01a-goog

