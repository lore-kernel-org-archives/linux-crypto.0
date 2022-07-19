Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91741C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 14:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbiGSOV4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 10:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbiGSOVo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 10:21:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95E466AD6
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 07:04:42 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id y11so24963126lfs.6
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 07:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WdRTVyCdTTwubFWw4IXfWR+49iRAdq+tYcE8B4mQc/A=;
        b=MDRO0S8ci1HeYnEziTQ3KexD8UoHyKptQidl56Fw54xRotrDIqk8egsE1t0JVN5r+h
         wKQI30MArxGdp9OtPsjWtylODQOCxNv4niXTDbOizh+8Qi61NKEvXcnflCcvSdL/x109
         oxCcZg+fFsXA/kJjRSg6RGAfSa/vm8StSZ+liMY1Qr5O5z1h7ANOPuaGQdM2UgWlQy0d
         Oi88Kv1LYz5LAjH5jhYs6y5Ijzrb7UMFSmeWficwZADnw9/dzedRMd/wMOhq1ZRqnBIv
         XiAMYrCSZ3HeZeJ+45Xs1/vJK1QsaQd3JjvjcHD6IxLG+42jJAfH0sKnw0HvOKd4qzop
         P4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WdRTVyCdTTwubFWw4IXfWR+49iRAdq+tYcE8B4mQc/A=;
        b=jEMFOnzpIjSY4T/ZJWWQbeeC9spq2Z71ArfmjgXcVL/NH5s9gHVpgYzMb2WmNUlwT7
         n7OatVHDW0g2b9srN9KVdY0kUq4IF/M4zFNSrIJKXhUB4ZTMZcTUOaUnBEY/g0Hf63cR
         /K2xn6us82HRqUao5onHgEy94F6W0r3yd60ndB76CQPOZ+qYZpOsn2jlzCsA5wWpTWhd
         qWAKaqCY/K9ACiboCZN/V7yfwszGhT1lfAn5YF6GcIlk4s4UOoAhIzQxZgsO7VWg3qW0
         PFFMvNsUzy/RI/l1Fc5Isve22x6TQWaEB7KEmLf+XoDTyleL3Mcse5r8ytn1drefpRbS
         TB3Q==
X-Gm-Message-State: AJIora8I4mIsfzLp0RxpEY4+1hvykHCi5eC7kx6wT1FJt6w43ArvG1o/
        b38akNFjkl77DHlS6tQ7+XTGHMAFTHyn2jZx
X-Google-Smtp-Source: AGRyM1t1GmDJQ0Iz3PPHK+IVEb8FBJbT6AYepyEYETB8DTUhEosZlCqH3Wtr9a38WYKHsK1CMAHCJg==
X-Received: by 2002:a05:6512:3103:b0:489:cdd7:b360 with SMTP id n3-20020a056512310300b00489cdd7b360mr18071229lfb.111.1658239480854;
        Tue, 19 Jul 2022 07:04:40 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id e1-20020a05651236c100b00478f3fe716asm3228786lfs.200.2022.07.19.07.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:04:40 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] crypto: ux500/hash: Implement .export and .import
Date:   Tue, 19 Jul 2022 16:02:38 +0200
Message-Id: <20220719140238.127690-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The .export and .import callbacks are just implemented as stubs
which makes the tests fail:

 alg: ahash: hmac-sha256-ux500 export() failed with err -38 on
   test vector 0, cfg="import/export"
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 92 at crypto/testmgr.c:5777
   alg_test.part.0+0x160/0x3ec
 alg: self-tests for hmac-sha256-ux500 (hmac(sha256)) failed (rc=-38)

The driver already has code for saving and restoring the hardware
state. Pass the tests by simply implementing the callbacks
properly.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 48 ++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 265ef3e96fdd..150d3fc8ed85 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1413,14 +1413,38 @@ static int ahash_sha256_digest(struct ahash_request *req)
 	return ret1 ? ret1 : ret2;
 }
 
-static int ahash_noimport(struct ahash_request *req, const void *in)
+static int ahash_import(struct ahash_request *req, const void *in)
 {
-	return -ENOSYS;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct hash_device_data *device_data;
+	int ret;
+
+	ret = hash_get_device_data(ctx, &device_data);
+	if (ret)
+		return ret;
+
+	/* Import state */
+	hash_resume_state(device_data, &device_data->state);
+
+	return 0;
 }
 
-static int ahash_noexport(struct ahash_request *req, void *out)
+static int ahash_export(struct ahash_request *req, void *out)
 {
-	return -ENOSYS;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct hash_device_data *device_data;
+	int ret;
+
+	ret = hash_get_device_data(ctx, &device_data);
+	if (ret)
+		return ret;
+
+	/* Export state */
+	hash_save_state(device_data, &device_data->state);
+
+	return 0;
 }
 
 static int hmac_sha1_init(struct ahash_request *req)
@@ -1527,8 +1551,8 @@ static struct hash_algo_template hash_algs[] = {
 			.update = ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha1_digest,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
@@ -1550,8 +1574,8 @@ static struct hash_algo_template hash_algs[] = {
 			.update	= ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha256_digest,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
@@ -1574,8 +1598,8 @@ static struct hash_algo_template hash_algs[] = {
 			.final = ahash_final,
 			.digest = hmac_sha1_digest,
 			.setkey = hmac_sha1_setkey,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
@@ -1598,8 +1622,8 @@ static struct hash_algo_template hash_algs[] = {
 			.final = ahash_final,
 			.digest = hmac_sha256_digest,
 			.setkey = hmac_sha256_setkey,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
-- 
2.36.1

