Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41623 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504040AbeKWWqt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 17:46:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id x10so12104611wrs.8
        for <linux-crypto@vger.kernel.org>; Fri, 23 Nov 2018 04:02:51 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 11/11] crypto: crypto_user_stat: Add crypto_stats_init
Date: Fri, 23 Nov 2018 12:02:21 +0000
Message-Id: <1542974541-23024-12-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
References: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch add the crypto_stats_init() function.
This will permit to remove some ifdef from __crypto_register_alg().

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/algapi.c        | 11 ++++++++---
 include/linux/crypto.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 84e9b4e5389a..0a76d8464d9f 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -258,9 +258,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &crypto_alg_list);
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
-#ifdef CONFIG_CRYPTO_STATS
-	memset(&alg->stats, 0, sizeof(alg->stats));
-#endif
+	crypto_stats_init(alg);
 
 out:
 	return larval;
@@ -1073,6 +1071,11 @@ int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
 EXPORT_SYMBOL_GPL(crypto_type_has_alg);
 
 #ifdef CONFIG_CRYPTO_STATS
+void crypto_stats_init(struct crypto_alg *alg)
+{
+	memset(&alg->stats, 0, sizeof(alg->stats));
+}
+
 void crypto_stats_get(struct crypto_alg *alg)
 {
 	crypto_alg_get(alg);
@@ -1284,6 +1287,8 @@ void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
 	crypto_alg_put(alg);
 }
 #else
+void crypto_stats_init(struct crypto_alg *alg)
+{}
 void crypto_stats_get(struct crypto_alg *alg)
 {}
 void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 132a052b3483..4fa9903c0887 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -613,6 +613,7 @@ struct crypto_alg {
 
 } CRYPTO_MINALIGN_ATTR;
 
+void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
 void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret, struct crypto_alg *alg);
 void crypto_stats_ablkcipher_decrypt(unsigned int nbytes, int ret, struct crypto_alg *alg);
-- 
2.18.1
