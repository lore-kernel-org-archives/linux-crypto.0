From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 15/15] crypto: Add userspace report for compress type
 algorithms
Date: Wed, 17 Aug 2011 14:18:26 +0200
Message-ID: <20110817121825.GM16877@secunet.com>
References: <20110817120859.GX16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:50786 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1HQMR2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:17:28 -0400
Content-Disposition: inline
In-Reply-To: <20110817120859.GX16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |   21 +++++++++++++++++++++
 include/linux/cryptouser.h |    1 +
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 9d10d2f..2cc3694 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -88,6 +88,22 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_comp rcomp;
+
+	snprintf(rcomp.type, CRYPTO_MAX_ALG_NAME, "%s", "compression");
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_COMPRESS,
+		sizeof(struct crypto_report_comp), &rcomp);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_report_base *rb, struct sk_buff *skb)
 {
@@ -125,6 +141,11 @@ static int crypto_report_one(struct crypto_alg *alg,
 			goto nla_put_failure;
 
 		break;
+	case CRYPTO_ALG_TYPE_COMPRESS:
+		if (crypto_report_comp(skb, alg))
+			goto nla_put_failure;
+
+		break;
 	}
 
 out:
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 4af8222..56992c1 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -44,6 +44,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_PCOMPRESS,	/* struct crypto_report_comp */
 	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
 	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
+	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
-- 
1.7.0.4
