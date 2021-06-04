Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CEDC4743C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 19:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12F6C61414
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 19:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFDTCP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 15:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhFDTCN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 15:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B999610E5;
        Fri,  4 Jun 2021 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622833226;
        bh=TeBTRyQn+daQzLq4UNFRpGaMejosUhDSTSuNz5ezEWE=;
        h=From:To:Cc:Subject:Date:From;
        b=YP6BWlzvYwdNINCXjj6I+p+OnZ4XOeUEV7zEO1RJqs1SR93okbclL70vvCuqpLGIi
         3dekr6MENWh8tSES5TBD+TnGGLnh+l7ViCKDpaKGFtKnlXGuAbe6Xxm98yz1ZpcMWj
         bgIpUkt8l7rOBNrElIJTbbpU9RqT7iIXSx4IIlR4jK79h2VU/SzjShsnbvJOHgFVnR
         7ACjjsG7gkSZrnCoUnUjldwg8/FRUlFjs5MjO1qXc3+nrv8qVhi0L7GUF+0QZcpT7K
         Fsp53g6tu8L7Wcke9nAt7hZY7AIdzTioY++eJ/y/mhkGCKNeUSOHY7oSMz6jAXyS23
         FdhCRfSDLEtrg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] crypto: shash - stop comparing function pointers to avoid breaking CFI
Date:   Fri,  4 Jun 2021 21:00:09 +0200
Message-Id: <20210604190009.33022-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_shash_alg_has_setkey() is implemented by testing whether the
.setkey() member of a struct shash_alg points to the default version
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
 crypto/shash.c                 | 11 ++++++++---
 include/crypto/internal/hash.h |  8 +-------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 2e3433ad9762..e0ddfcd13ac7 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -20,12 +20,17 @@
 
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
+       return alg->setkey != shash_no_setkey;
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

