Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354E4C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbiKRJEW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbiKRJEQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BA182BFA
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10514623B1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7DCC43141;
        Fri, 18 Nov 2022 09:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762250;
        bh=dN9lqJsqSknnJEVWfdbcH4PBv1COtt2elsbRPuqKWpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liqNp19oNyCipr9vwmUXYl94kRjIRI2R4Ks7FBDJWaZW/5/EuRAhr/i12ZO3dqwJP
         sIqNH+Jm/2M9dp86/CFzURzWn2glS35cKQ90JbEiRXZMJTCuw0I530QCO8Ky/pLakU
         7PwI6ceXuN1oko89Q51kX8xlOEHPjAWuCrwXNpwKbkPJgppTkcii8c6fzUwxrE50SL
         4rlviybpw4WjTC11URRRuqmpOza2fS6yhoHkrimgQPFWhu8jVzuWuUD5F1G/NIr9sn
         b93AtG0dxbXnWmfEoxmRkT4wW7raI2Wcmz1wMFy8WG+BQpTJpHTq1hVIFMbypx0MST
         U6EzSEKEO/KtA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 11/11] Revert "crypto: shash - avoid comparing pointers to exported functions under CFI"
Date:   Fri, 18 Nov 2022 01:02:20 -0800
Message-Id: <20221118090220.398819-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This reverts commit 22ca9f4aaf431a9413dcc115dd590123307f274f because CFI
no longer breaks cross-module function address equality, so
crypto_shash_alg_has_setkey() can now be an inline function like before.

This commit should not be backported to kernels that don't have the new
CFI implementation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c                 | 18 +++---------------
 include/crypto/internal/hash.h |  8 +++++++-
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 4c88e63b3350f..0f85431588267 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -20,24 +20,12 @@
 
 static const struct crypto_type crypto_shash_type;
 
-static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-			   unsigned int keylen)
+int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+		    unsigned int keylen)
 {
 	return -ENOSYS;
 }
-
-/*
- * Check whether an shash algorithm has a setkey function.
- *
- * For CFI compatibility, this must not be an inline function.  This is because
- * when CFI is enabled, modules won't get the same address for shash_no_setkey
- * (if it were exported, which inlining would require) as the core kernel will.
- */
-bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
-{
-	return alg->setkey != shash_no_setkey;
-}
-EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);
+EXPORT_SYMBOL_GPL(shash_no_setkey);
 
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 25806141db591..0a288dddcf5be 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -75,7 +75,13 @@ void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 
-bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
+int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+		    unsigned int keylen);
+
+static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+{
+	return alg->setkey != shash_no_setkey;
+}
 
 static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
 {
-- 
2.38.1

