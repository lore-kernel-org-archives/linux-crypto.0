Return-Path: <SRS0=a5OM=NO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbeKDHJ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Nov 2018 02:09:56 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>,
        Stafford Horne <shorne@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] crypto: crypto_user - remove redundant reporting functions
Date: Sat,  3 Nov 2018 14:56:02 -0700
Message-Id: <20181103215603.16250-4-ebiggers@kernel.org>
In-Reply-To: <20181103215603.16250-1-ebiggers@kernel.org>
References: <20181103215603.16250-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The acomp, akcipher, and kpp algorithm types already have .report
methods defined, so there's no need to duplicate this functionality in
crypto_user itself; the duplicate functions are actually never executed.
Remove the unused code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_user_base.c | 59 ---------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index 784748dbb19f0..1ecd9b08e38f4 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -113,51 +113,6 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 	return -EMSGSIZE;
 }
 
-static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_acomp racomp;
-
-	strncpy(racomp.type, "acomp", sizeof(racomp.type));
-
-	if (nla_put(skb, CRYPTOCFGA_REPORT_ACOMP,
-		    sizeof(struct crypto_report_acomp), &racomp))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
-}
-
-static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_akcipher rakcipher;
-
-	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
-
-	if (nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER,
-		    sizeof(struct crypto_report_akcipher), &rakcipher))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
-}
-
-static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_kpp rkpp;
-
-	strncpy(rkpp.type, "kpp", sizeof(rkpp.type));
-
-	if (nla_put(skb, CRYPTOCFGA_REPORT_KPP,
-		    sizeof(struct crypto_report_kpp), &rkpp))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
-}
-
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_user_alg *ualg, struct sk_buff *skb)
 {
@@ -202,20 +157,6 @@ static int crypto_report_one(struct crypto_alg *alg,
 			goto nla_put_failure;
 
 		break;
-	case CRYPTO_ALG_TYPE_ACOMPRESS:
-		if (crypto_report_acomp(skb, alg))
-			goto nla_put_failure;
-
-		break;
-	case CRYPTO_ALG_TYPE_AKCIPHER:
-		if (crypto_report_akcipher(skb, alg))
-			goto nla_put_failure;
-
-		break;
-	case CRYPTO_ALG_TYPE_KPP:
-		if (crypto_report_kpp(skb, alg))
-			goto nla_put_failure;
-		break;
 	}
 
 out:
-- 
2.19.1
