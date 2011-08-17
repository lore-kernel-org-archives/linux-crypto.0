From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 04/15] crypto: Add userspace report for larval type
 algorithms
Date: Wed, 17 Aug 2011 14:11:26 +0200
Message-ID: <20110817121126.GB16877@secunet.com>
References: <20110817120859.GX16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:41251 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab1HQMK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:10:29 -0400
Content-Disposition: inline
In-Reply-To: <20110817120859.GX16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |   13 +++++++++++++
 include/linux/cryptouser.h |    6 ++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index cb3a722..68d405d 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -81,11 +81,24 @@ static int crypto_report_one(struct crypto_alg *alg,
 	rb->priority = alg->cra_priority;
 	rb->refcnt = atomic_read(&alg->cra_refcnt);
 
+	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
+		struct crypto_report_larval rl;
+
+		snprintf(rl.type, CRYPTO_MAX_ALG_NAME, "%s", "larval");
+		rl.flags = alg->cra_flags;
+
+		NLA_PUT(skb, CRYPTOCFGA_REPORT_LARVAL,
+			sizeof(struct crypto_report_larval), &rl);
+
+		goto out;
+	}
+
 	if (alg->cra_type && alg->cra_type->report) {
 		if (alg->cra_type->report(skb, alg))
 			goto nla_put_failure;
 	}
 
+out:
 	return 0;
 
 nla_put_failure:
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 3245081..d77b16c 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -33,6 +33,7 @@ enum {
 enum crypto_attr_type_t {
 	CRYPTOCFGA_UNSPEC,
 	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
+	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -55,3 +56,8 @@ struct crypto_report_base {
 	int priority;
 	int refcnt;
 };
+
+struct crypto_report_larval {
+	char type[CRYPTO_MAX_NAME];
+	__u32 flags;
+};
-- 
1.7.0.4
