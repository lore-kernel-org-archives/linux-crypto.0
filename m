From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 16/17] crypto: Add userspace report for cipher type
 algorithms
Date: Wed, 21 Sep 2011 11:11:41 +0200
Message-ID: <20110921091141.GU1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:41650 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1IUJLn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 05:11:43 -0400
Content-Disposition: inline
In-Reply-To: <20110921085855.GE1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |   29 +++++++++++++++++++++++++++++
 include/linux/cryptouser.h |    8 ++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index a5e92a3..cd08b2f 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -70,6 +70,25 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 	return alg;
 }
 
+static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_cipher rcipher;
+
+	snprintf(rcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "cipher");
+
+	rcipher.blocksize = alg->cra_blocksize;
+	rcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
+	rcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_CIPHER,
+		sizeof(struct crypto_report_cipher), &rcipher);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_user_alg *ualg, struct sk_buff *skb)
 {
@@ -97,6 +116,16 @@ static int crypto_report_one(struct crypto_alg *alg,
 	if (alg->cra_type && alg->cra_type->report) {
 		if (alg->cra_type->report(skb, alg))
 			goto nla_put_failure;
+
+		goto out;
+	}
+
+	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
+	case CRYPTO_ALG_TYPE_CIPHER:
+		if (crypto_report_cipher(skb, alg))
+			goto nla_put_failure;
+
+		break;
 	}
 
 out:
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index d2dce62..797dfd9 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -46,6 +46,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_NIVAEAD,	/* struct crypto_report_aead */
 	CRYPTOCFGA_REPORT_PCOMPRESS,	/* struct crypto_report_comp */
 	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
+	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -72,6 +73,13 @@ struct crypto_report_hash {
 	unsigned int digestsize;
 };
 
+struct crypto_report_cipher {
+	char type[CRYPTO_MAX_ALG_NAME];
+	unsigned int blocksize;
+	unsigned int min_keysize;
+	unsigned int max_keysize;
+};
+
 struct crypto_report_blkcipher {
 	char type[CRYPTO_MAX_NAME];
 	char geniv[CRYPTO_MAX_NAME];
-- 
1.7.0.4
