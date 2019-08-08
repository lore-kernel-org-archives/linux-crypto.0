Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C415C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 08:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1445B218BA
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 08:00:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aw0j37JX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbfHHIA3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 04:00:29 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36392 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfHHIA2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 04:00:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so43206497plt.3;
        Thu, 08 Aug 2019 01:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EGfX5s28Zn4JMCVt23BeVJ6/iwEeV8A1FICQP/6Qc8M=;
        b=Aw0j37JXhgQQ9904NKJiZfiFxsWHGRKrKkn63RwQSTAgeSi6vqCw/wuwxPah88r3f+
         7EKmoBxdz2OWWI4o8Zm2CslI9kp7QVaYyG4XZQgFVNiEUhNjHhYR10GLp9Liw1U3FPM3
         HlNHGt9cBDNAzJkhl9n1KScfZg6VFLpmpJyl/cV3V91TlAwDUcajrJTd59lq6jmO3xQk
         lnH0Dgqir+FHaQRda2fgmpakvk9u0Fwyo/MT9CSYEwE26I2Wt7KXp1oYt9dYzn+xP/ko
         utPWvLsFCWqT8ogzysExQX660COltNY/Yws6BBniJf94umnDBXRtHHSYYq6cG+kYJ/Yu
         sspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EGfX5s28Zn4JMCVt23BeVJ6/iwEeV8A1FICQP/6Qc8M=;
        b=StpQ2/j/PTjD91WZoICqVyEI1GswxO77s2bOYlF9N6V9Sjm/R1Wk5dSwevyHWTw6ry
         70DF4RK/fupuX+wFaY7/E8LSS1B2Gjw/mn3KZuvkX0EPedrpBZ+oeRzXNoxGa4Xmx42N
         7KF28Ot4oX8NqHKtow0Dd94xnaVBsW5yU07G2cyhMVQVV2vVbsWYkt9ngym5Bnt73MTk
         FpfJ+K206BU+5DySXaGgwaje22FwuDQVKkKGDpoJaZye1uznpJ8vhOW7ZLAnX2dlagOE
         YaprxbqEsqxvfhq7kO/iFhfklgFuyme72XrGot4WwM6L5dhFu6RJYhj1ed0nSt/KjGOH
         4SsQ==
X-Gm-Message-State: APjAAAWaEVSjPNBFTcYpbhENS7U/AKpGPzH58ghnSb0H9txtWiTHVTVI
        gTSsBFpXaCBrc0AkwZaZA38kdSlQbYMiBA==
X-Google-Smtp-Source: APXvYqyTD1Bi7oq5NPVtV3ZvKjSfb/obH8AbG2WG1VaEwtPCmH1ouo+PzKxUTOunyQV9Zh5ng9+Idw==
X-Received: by 2002:a17:902:b497:: with SMTP id y23mr12512683plr.68.1565251227998;
        Thu, 08 Aug 2019 01:00:27 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id g1sm152988789pgg.27.2019.08.08.01.00.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 01:00:27 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] crypto: cryptd - Use refcount_t for refcount
Date:   Thu,  8 Aug 2019 16:00:22 +0800
Message-Id: <20190808080022.7688-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reference counters are preferred to use refcount_t instead of
atomic_t.
This is because the implementation of refcount_t can prevent
overflows and detect possible use-after-free.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 crypto/cryptd.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 3748f9b4516d..927760b316a4 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -16,7 +16,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/cryptd.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -63,7 +63,7 @@ struct aead_instance_ctx {
 };
 
 struct cryptd_skcipher_ctx {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct crypto_sync_skcipher *child;
 };
 
@@ -72,7 +72,7 @@ struct cryptd_skcipher_request_ctx {
 };
 
 struct cryptd_hash_ctx {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct crypto_shash *child;
 };
 
@@ -82,7 +82,7 @@ struct cryptd_hash_request_ctx {
 };
 
 struct cryptd_aead_ctx {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct crypto_aead *child;
 };
 
@@ -127,7 +127,7 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 {
 	int cpu, err;
 	struct cryptd_cpu_queue *cpu_queue;
-	atomic_t *refcnt;
+	refcount_t *refcnt;
 
 	cpu = get_cpu();
 	cpu_queue = this_cpu_ptr(queue->cpu_queue);
@@ -140,10 +140,10 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 
 	queue_work_on(cpu, cryptd_wq, &cpu_queue->work);
 
-	if (!atomic_read(refcnt))
+	if (!refcount_read(refcnt))
 		goto out_put_cpu;
 
-	atomic_inc(refcnt);
+	refcount_inc(refcnt);
 
 out_put_cpu:
 	put_cpu();
@@ -270,13 +270,13 @@ static void cryptd_skcipher_complete(struct skcipher_request *req, int err)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
-	int refcnt = atomic_read(&ctx->refcnt);
+	int refcnt = refcount_read(&ctx->refcnt);
 
 	local_bh_disable();
 	rctx->complete(&req->base, err);
 	local_bh_enable();
 
-	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+	if (err != -EINPROGRESS && refcnt && refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_skcipher(tfm);
 }
 
@@ -521,13 +521,13 @@ static void cryptd_hash_complete(struct ahash_request *req, int err)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	int refcnt = atomic_read(&ctx->refcnt);
+	int refcnt = refcount_read(&ctx->refcnt);
 
 	local_bh_disable();
 	rctx->complete(&req->base, err);
 	local_bh_enable();
 
-	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+	if (err != -EINPROGRESS && refcnt && refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_ahash(tfm);
 }
 
@@ -772,13 +772,13 @@ static void cryptd_aead_crypt(struct aead_request *req,
 
 out:
 	ctx = crypto_aead_ctx(tfm);
-	refcnt = atomic_read(&ctx->refcnt);
+	refcnt = refcount_read(&ctx->refcnt);
 
 	local_bh_disable();
 	compl(&req->base, err);
 	local_bh_enable();
 
-	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+	if (err != -EINPROGRESS && refcnt && refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_aead(tfm);
 }
 
@@ -979,7 +979,7 @@ struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
 	}
 
 	ctx = crypto_skcipher_ctx(tfm);
-	atomic_set(&ctx->refcnt, 1);
+	refcount_set(&ctx->refcnt, 1);
 
 	return container_of(tfm, struct cryptd_skcipher, base);
 }
@@ -997,7 +997,7 @@ bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
-	return atomic_read(&ctx->refcnt) - 1;
+	return refcount_read(&ctx->refcnt) - 1;
 }
 EXPORT_SYMBOL_GPL(cryptd_skcipher_queued);
 
@@ -1005,7 +1005,7 @@ void cryptd_free_skcipher(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
-	if (atomic_dec_and_test(&ctx->refcnt))
+	if (refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_skcipher(&tfm->base);
 }
 EXPORT_SYMBOL_GPL(cryptd_free_skcipher);
@@ -1029,7 +1029,7 @@ struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
 	}
 
 	ctx = crypto_ahash_ctx(tfm);
-	atomic_set(&ctx->refcnt, 1);
+	refcount_set(&ctx->refcnt, 1);
 
 	return __cryptd_ahash_cast(tfm);
 }
@@ -1054,7 +1054,7 @@ bool cryptd_ahash_queued(struct cryptd_ahash *tfm)
 {
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
 
-	return atomic_read(&ctx->refcnt) - 1;
+	return refcount_read(&ctx->refcnt) - 1;
 }
 EXPORT_SYMBOL_GPL(cryptd_ahash_queued);
 
@@ -1062,7 +1062,7 @@ void cryptd_free_ahash(struct cryptd_ahash *tfm)
 {
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
 
-	if (atomic_dec_and_test(&ctx->refcnt))
+	if (refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_ahash(&tfm->base);
 }
 EXPORT_SYMBOL_GPL(cryptd_free_ahash);
@@ -1086,7 +1086,7 @@ struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
 	}
 
 	ctx = crypto_aead_ctx(tfm);
-	atomic_set(&ctx->refcnt, 1);
+	refcount_set(&ctx->refcnt, 1);
 
 	return __cryptd_aead_cast(tfm);
 }
@@ -1104,7 +1104,7 @@ bool cryptd_aead_queued(struct cryptd_aead *tfm)
 {
 	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(&tfm->base);
 
-	return atomic_read(&ctx->refcnt) - 1;
+	return refcount_read(&ctx->refcnt) - 1;
 }
 EXPORT_SYMBOL_GPL(cryptd_aead_queued);
 
@@ -1112,7 +1112,7 @@ void cryptd_free_aead(struct cryptd_aead *tfm)
 {
 	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(&tfm->base);
 
-	if (atomic_dec_and_test(&ctx->refcnt))
+	if (refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_aead(&tfm->base);
 }
 EXPORT_SYMBOL_GPL(cryptd_free_aead);
-- 
2.20.1

