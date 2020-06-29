Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3087C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2746206F1
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pRKyjljs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388493AbgF2VMd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbgF2S5o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:57:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3205DC00F813
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2020 05:30:17 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j4so13902362wrp.10
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2020 05:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJzVhpJJAv65Qazp2aPfqaE5/RwoX3RLz4Z8bcbSMRY=;
        b=pRKyjljsaQEzYd/ZTriBGti7UFYvW3HNq59C0GxU7Os8zRMWbFWUMRj3M06J5MzDlV
         vIaE8Ml1b3R2geKPTQuPHi0k8gxdJWzU/+9zRgsvtmmmql0m5TZgeU4zDB0+yx/AWOAJ
         0AjDk8p6eJ9DH+NvXRrUP7M2kRklGw7lArXXNQhUPumIZYQQudDavWKt0u4DFSBrRT3m
         pUhLKJwwToAo+RwJXhWKcWkk1OI119FZRjaPRJlZ9TC/zhhiTlHGsy8t33DnoHDR0qfk
         4dXuRgRa1sUvhPZkzCVhHCY+k4jL3cExflco1rek0UXuoZA2huIC6wGPNqZKL04EAIKn
         wBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJzVhpJJAv65Qazp2aPfqaE5/RwoX3RLz4Z8bcbSMRY=;
        b=B59ApV0x28V4owm+RTuVo+NuVzubDtugxClC8KyHKOwtt00MquGswGGjybgk8yiwCK
         vt4fRtxfQOd5g5QTaZlRJKzsCEwjHHj/ZHO6npyYiWAdlb398fbbxRvcKuU5SvqI7mSM
         WPBlQLdZSMtwOFw2pooUvreLQCqKWUPAKNsX6RfP0D3v8AOpHwF5SMA9nlrgeiT7zNrw
         YcjrR6DPki6A4wRWQ9PVBaG5uwUCEoon2XJfDOko5JDX0uCrCPN/pVLy3mFEq1ww6wlO
         Dt1tYFFkR2kLVPfrhirjM/UhWM/7KOrS9c1Mkz7/seXGycqk2l3+0G6AiK44ktVu8NcU
         2XGw==
X-Gm-Message-State: AOAM532SXVu7hYbEKybbIOCZz6UEw4zGwKPztWgeVVGiC9eRGSztxx/b
        VL4YlOpX2YsqyJ8wAGKo/T4N9g==
X-Google-Smtp-Source: ABdhPJyJCgqEzM0dRcjMBFFJyWUUkmlGDMG9BE8MzW+qrGWD2FeLjOf3tbRfUrqURp7S6UzoC8eBqg==
X-Received: by 2002:adf:8b18:: with SMTP id n24mr17862490wra.372.1593433815872;
        Mon, 29 Jun 2020 05:30:15 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id g144sm32676472wme.2.2020.06.29.05.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:30:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/1] crypto: ux500: hash: Add namespacing to hash_init()
Date:   Mon, 29 Jun 2020 13:30:03 +0100
Message-Id: <20200629123003.1014387-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A recent change to the Regulator consumer API (which this driver
utilises) add prototypes for the some suspend functions.  These
functions require including header file include/linux/suspend.h.

The following tree of includes affecting this driver will be
present:

   In file included from include/linux/elevator.h:6,
                    from include/linux/blkdev.h:288,
                    from include/linux/blk-cgroup.h:23,
                    from include/linux/writeback.h:14,
                    from include/linux/memcontrol.h:22,
                    from include/linux/swap.h:9,
                    from include/linux/suspend.h:5,
                    from include/linux/regulator/consumer.h:35,
                    from drivers/crypto/ux500/hash/hash_core.c:28:

include/linux/elevator.h pulls in include/linux/hashtable.h which
contains its own version of hash_init().  This confuses the build
system and results in the following error (amongst others):

 drivers/crypto/ux500/hash/hash_core.c:1362:19: error: passing argument 1 of '__hash_init' from incompatible pointer type [-Werror=incompatible-pointer-types]
 1362 |  return hash_init(req);

Fix this by namespacing the local hash_init() such that the
source of confusion is removed.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---

Ideally this should go into v5.8's -rcs else it runs the risk of
breaking when Linus pulls everything in for v5.9-rc1.

 drivers/crypto/ux500/hash/hash_core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index c24f2db8d5e83..a5ee8c2fb4e0b 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -545,7 +545,7 @@ static bool hash_dma_valid_data(struct scatterlist *sg, int datasize)
  *
  * Initialize structures.
  */
-static int hash_init(struct ahash_request *req)
+static int ux500_hash_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -1359,7 +1359,7 @@ static int ahash_sha1_init(struct ahash_request *req)
 	ctx->config.oper_mode = HASH_OPER_MODE_HASH;
 	ctx->digestsize = SHA1_DIGEST_SIZE;
 
-	return hash_init(req);
+	return ux500_hash_init(req);
 }
 
 static int ahash_sha256_init(struct ahash_request *req)
@@ -1372,7 +1372,7 @@ static int ahash_sha256_init(struct ahash_request *req)
 	ctx->config.oper_mode = HASH_OPER_MODE_HASH;
 	ctx->digestsize = SHA256_DIGEST_SIZE;
 
-	return hash_init(req);
+	return ux500_hash_init(req);
 }
 
 static int ahash_sha1_digest(struct ahash_request *req)
@@ -1425,7 +1425,7 @@ static int hmac_sha1_init(struct ahash_request *req)
 	ctx->config.oper_mode	= HASH_OPER_MODE_HMAC;
 	ctx->digestsize		= SHA1_DIGEST_SIZE;
 
-	return hash_init(req);
+	return ux500_hash_init(req);
 }
 
 static int hmac_sha256_init(struct ahash_request *req)
@@ -1438,7 +1438,7 @@ static int hmac_sha256_init(struct ahash_request *req)
 	ctx->config.oper_mode	= HASH_OPER_MODE_HMAC;
 	ctx->digestsize		= SHA256_DIGEST_SIZE;
 
-	return hash_init(req);
+	return ux500_hash_init(req);
 }
 
 static int hmac_sha1_digest(struct ahash_request *req)
@@ -1515,7 +1515,7 @@ static struct hash_algo_template hash_algs[] = {
 		.conf.algorithm = HASH_ALGO_SHA1,
 		.conf.oper_mode = HASH_OPER_MODE_HASH,
 		.hash = {
-			.init = hash_init,
+			.init = ux500_hash_init,
 			.update = ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha1_digest,
@@ -1538,7 +1538,7 @@ static struct hash_algo_template hash_algs[] = {
 		.conf.algorithm	= HASH_ALGO_SHA256,
 		.conf.oper_mode	= HASH_OPER_MODE_HASH,
 		.hash = {
-			.init = hash_init,
+			.init = ux500_hash_init,
 			.update	= ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha256_digest,
@@ -1561,7 +1561,7 @@ static struct hash_algo_template hash_algs[] = {
 		.conf.algorithm = HASH_ALGO_SHA1,
 		.conf.oper_mode = HASH_OPER_MODE_HMAC,
 			.hash = {
-			.init = hash_init,
+			.init = ux500_hash_init,
 			.update = ahash_update,
 			.final = ahash_final,
 			.digest = hmac_sha1_digest,
@@ -1585,7 +1585,7 @@ static struct hash_algo_template hash_algs[] = {
 		.conf.algorithm = HASH_ALGO_SHA256,
 		.conf.oper_mode = HASH_OPER_MODE_HMAC,
 		.hash = {
-			.init = hash_init,
+			.init = ux500_hash_init,
 			.update = ahash_update,
 			.final = ahash_final,
 			.digest = hmac_sha256_digest,
-- 
2.25.1

