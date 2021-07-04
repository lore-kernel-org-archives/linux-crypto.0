Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0EFC07E9A
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Jul 2021 23:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F98961364
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Jul 2021 23:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhGDXRz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Jul 2021 19:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234542AbhGDXPN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81445611ED;
        Sun,  4 Jul 2021 23:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440357;
        bh=F42cCTH/utOiDjZj6SlUMUviirUJIk8fA4Dqdm1MB4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXI16QixEICaICtD4nBTxx6o9agtwnOVLzqe1uRHpqMSjLcoczunDa0J9FZHQ1bWp
         7Qbk2VAlAhssU5w4EL3vDi/oeXE1wWFoZvhM1DUVyXLQOHwzhbwUYyjsshNWIc3wDA
         8XnVxoOHtEEq+CPqW0JgRH6S8QBT81Z7l7sm0RGKdMaHLMQlEkt/X6HkJX6auRQzps
         7CieNUapgtFiCnlnourZRLWoSe/O1UQ/H/n/uu6DvkwP5gW7fKj9HCqDNkoijH31KU
         ghbZSk4qQT3VDxwfHGsrIg27sIvJHoeBelPfMvp4OVlTeO9NYib+lD/l/xlvIneEBg
         S46lzdn87Q7Yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/15] crypto: shash - avoid comparing pointers to exported functions under CFI
Date:   Sun,  4 Jul 2021 19:12:17 -0400
Message-Id: <20210704231222.1492037-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231222.1492037-1-sashal@kernel.org>
References: <20210704231222.1492037-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 22ca9f4aaf431a9413dcc115dd590123307f274f ]

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
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/shash.c                 | 18 +++++++++++++++---
 include/crypto/internal/hash.h |  8 +-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 4f89f78031e2..8f162476d214 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -24,12 +24,24 @@
 
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
index dab9569f22bf..e51741670a60 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -83,13 +83,7 @@ int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 void ahash_free_instance(struct crypto_instance *inst);
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen);
-
-static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
-{
-	return alg->setkey != shash_no_setkey;
-}
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
 
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
 
-- 
2.30.2

