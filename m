From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 15/16] crypto: Add userspace report for cipher type
 algorithms
Date: Thu, 11 Aug 2011 13:35:24 +0200
Message-ID: <20110811113524.GS16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56401 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab1HKLew (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:34:52 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |   29 +++++++++++++++++++++++++++++
 include/linux/cryptouser.h |    8 ++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index fa68965..82f9fad 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -76,6 +76,25 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p)
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
 			     struct crypto_report_base *rb, struct sk_buff *skb)
 {
@@ -103,6 +122,16 @@ static int crypto_report_one(struct crypto_alg *alg,
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
index 2219964..82ec52d 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -44,6 +44,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_NIVAEAD,	/* struct crypto_report_aead */
 	CRYPTOCFGA_REPORT_PCOMPRESS,	/* struct crypto_report_comp */
 	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
+	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -85,6 +86,13 @@ struct crypto_report_ahash {
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
