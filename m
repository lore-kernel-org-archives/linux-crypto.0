From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 05/16] crypto: Add userspace report for larval type
 algorithms
Date: Thu, 11 Aug 2011 13:29:03 +0200
Message-ID: <20110811112903.GI16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:44086 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab1HKL2a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:28:30 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |   13 +++++++++++++
 include/linux/cryptouser.h |    6 ++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 49f302a..fa68965 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -88,11 +88,24 @@ static int crypto_report_one(struct crypto_alg *alg,
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
index 056c451..d0766e3 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -34,6 +34,7 @@ enum {
 enum crypto_attr_type_t {
 	CRYPTOCFGA_UNSPEC,
 	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
+	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -56,3 +57,8 @@ struct crypto_report_base {
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
