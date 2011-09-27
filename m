From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 06/17] crypto: Add userspace report for larval type
 algorithms
Date: Tue, 27 Sep 2011 07:25:05 +0200
Message-ID: <20110927052505.GH1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:59818 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1I0FZH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:25:07 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |   12 ++++++++++++
 include/linux/cryptouser.h |    5 +++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index aa67c74..8a0c5c6 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -84,11 +84,23 @@ static int crypto_report_one(struct crypto_alg *alg,
 
 	NLA_PUT_U32(skb, CRYPTOCFGA_PRIORITY_VAL, alg->cra_priority);
 
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
index b874e38..7a849b4 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -36,6 +36,7 @@ enum {
 enum crypto_attr_type_t {
 	CRYPTOCFGA_UNSPEC,
 	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
+	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -50,3 +51,7 @@ struct crypto_user_alg {
 	__u32 cru_refcnt;
 	__u32 cru_flags;
 };
+
+struct crypto_report_larval {
+	char type[CRYPTO_MAX_NAME];
+};
-- 
1.7.0.4
