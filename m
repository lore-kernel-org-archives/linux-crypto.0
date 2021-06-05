Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8CEC47082
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 06:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 919D0613E7
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 06:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFEHA5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Jun 2021 03:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFEHA5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Jun 2021 03:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95BA9613E3;
        Sat,  5 Jun 2021 06:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622876349;
        bh=Da+1WNQ39wFhCUEpaZs/RRloBaMvA9HhxEx76b3BICo=;
        h=From:To:Cc:Subject:Date:From;
        b=ZNgTUIZ5rusSd/rwdXk2UfwvpvfWDtI6nCzvFjo42RMIctGmVjzHGT6RMPGJmZSGY
         JmohFUJW9cFdB9p5d+743owXDe4dtPDK554D5b5EhlqRk/Q6+I0urgPpq1cDLC00g+
         Qvq7WlQdd+11BAKFPgwT2nsoSk+qRLI26e4Cf5+N4Edacz5dMlxospS5N6wwEEdrED
         UuintWGLYD3n1q1CQS+FK0rNBCOeObIlO0AjawOaRwYfCZrRM1ahfPHwaBKLWzNaIq
         /0HDBaIWExxHZDwob43sbtkRpbxyV4V+SYwwD670WOUY21UU4wX7DqVoEx8E3SR2Zb
         0Q/3utRTmXLRg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH v2] crypto: shash - avoid comparing pointers to exported functions under CFI
Date:   Sat,  5 Jun 2021 08:59:02 +0200
Message-Id: <20210605065902.53268-1-ardb@kernel.org>
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
line function, which makes the problem go away.

Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: add code comment to explain why the function needs to remain out of
line

 crypto/shash.c                 | 20 +++++++++++++++++---
 include/crypto/internal/hash.h |  8 +-------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 2e3433ad9762..36579c37e27d 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -20,12 +20,26 @@
 
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
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+{
+	/*
+	 * Function pointer comparisons such as the one below will not work as
+	 * expected when CFI is enabled, and the comparison involves an
+	 * exported symbol: as indirect function calls are routed via CFI stubs
+	 * that are private to each module, the pointer values may be different
+	 * even if they refer to the same function.
+	 *
+	 * Therefore, this function must remain out of line.
+	 */
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

