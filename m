From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3 06/17] crypto: Add userspace report for larval type
 algorithms
Date: Wed, 21 Sep 2011 11:04:08 +0200
Message-ID: <20110921090408.GK1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:35717 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1IUJEK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 05:04:10 -0400
Content-Disposition: inline
In-Reply-To: <20110921085855.GE1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |   12 ++++++++++++
 include/linux/cryptouser.h |    5 +++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 12cec5e..a5e92a3 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -83,11 +83,23 @@ static int crypto_report_one(struct crypto_alg *alg,
 	ualg->cru_priority = alg->cra_priority;
 	ualg->cru_refcnt = atomic_read(&alg->cra_refcnt);
 
+	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
+		struct crypto_report_larval rl;
+
+		snprintf(rl.type, CRYPTO_MAX_ALG_NAME, "%s", "larval");
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
index 424d991..59d801f 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -36,6 +36,7 @@ enum {
 enum crypto_attr_type_t {
 	CRYPTOCFGA_UNSPEC,
 	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
+	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -51,3 +52,7 @@ struct crypto_user_alg {
 	__u32 cru_refcnt;
 	__u32 cru_flags;
 };
+
+struct crypto_report_larval {
+	char type[CRYPTO_MAX_NAME];
+};
-- 
1.7.0.4
