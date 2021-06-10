Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429EAC47094
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 06:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C935613CB
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 06:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhFJGYM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 02:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhFJGYL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 02:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A2F613C6;
        Thu, 10 Jun 2021 06:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623306135;
        bh=72TN9omId61IJS4+e4qfytxdlcJKrvXsUI726KlmhcU=;
        h=From:To:Cc:Subject:Date:From;
        b=uzGDALwmZ6js2fmyYM6meEZuMeylXBgpnpjGVd4Y8TkMnCtH612yLME4rV/7zJUf4
         cmsPEMeTUx5QsalRhOpqJ0EFYf0CdvSE+nG+v3R9a4QmCgV/JfwqzRZlEikJbFWcyG
         2x2Tm/sTTJetOuQgeYfTHvRiZJgKExFYXfpG2GRgKtCpDFymPi82YKO06mekkl1Z77
         2HOkb9R547gb0409UrXC1O7eUv2bBnNiXVgGgkA0DcvCQGX/2YslQU9RplKuo46JFH
         faxOFX2vpeDUj4+JLvqA2if8+F7qE++k4J8v/IyPGdEpspG1DWQF+N73Ymog/CCasO
         muFPrpyTs1R1w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3] crypto: shash - avoid comparing pointers to exported functions under CFI
Date:   Thu, 10 Jun 2021 08:21:50 +0200
Message-Id: <20210610062150.212779-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_shash_alg_has_setkey() is implemented by testing whether the
.setkey() member of a struct shash_alg points to the default version,
called shash_no_setkey(). As crypto_shash_alg_has_setkey() is a static
inline, this requires shash_no_setkey() to be exported to modules.

Unfortunately, when building with CFI, function pointers are routed
via CFI stubs which are private to each module (or to the kernel proper)
and so this function pointer comparison may fail spuriously.

Let's fix this by turning crypto_shash_alg_has_setkey() into an out of
line function.

Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v3: improve comment as per Eric's suggestion
v2: add code comment to explain why the function needs to remain out of
line

 crypto/shash.c                 | 18 +++++++++++++++---
 include/crypto/internal/hash.h |  8 +-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 2e3433ad9762..0a0a50cb694f 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -20,12 +20,24 @@
 
 static const struct crypto_type crypto_shash_type;
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen)
+static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+			   unsigned int keylen)
 {
 	return -ENOSYS;
 }
-EXPORT_SYMBOL_GPL(shash_no_setkey);
+
+/*
+ * Check whether an shash algorithm has a setkey function.
+ *
+ * For CFI compatibility, this must not be an inline function.  This is because
+ * when CFI is enabled, modules won't get the same address for shash_no_setkey
+ * (if it were exported, which inlining would require) as the core kernel will.
+ */
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+{
+	return alg->setkey != shash_no_setkey;
+}
+EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);
 
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 0a288dddcf5b..25806141db59 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -75,13 +75,7 @@ void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen);
-
-static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
-{
-	return alg->setkey != shash_no_setkey;
-}
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
 
 static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
 {
-- 
2.30.2

