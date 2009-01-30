From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH] crypto: shash - fix module refcount
Date: Fri, 30 Jan 2009 21:09:39 +0100
Message-ID: <1233346179-6779-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailx.swiss-it.ch ([81.6.4.203]:33633 "EHLO mailx.swiss-it.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZA3UJm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Jan 2009 15:09:42 -0500
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Module reference counting for shash is incorrect: when
a new shash transformation is created the refcount is not
increased as it should.

Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
---
 crypto/shash.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index c9df367..d5a2b61 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -388,10 +388,15 @@ static int crypto_init_shash_ops_compat(struct crypto_tfm *tfm)
 	struct shash_desc *desc = crypto_tfm_ctx(tfm);
 	struct crypto_shash *shash;
 
+	if (!crypto_mod_get(calg))
+		return -EAGAIN;
+
 	shash = __crypto_shash_cast(crypto_create_tfm(
 		calg, &crypto_shash_type));
-	if (IS_ERR(shash))
+	if (IS_ERR(shash)) {
+		crypto_mod_put(calg);
 		return PTR_ERR(shash);
+	}
 
 	desc->tfm = shash;
 	tfm->exit = crypto_exit_shash_ops_compat;
-- 
1.5.2.5

