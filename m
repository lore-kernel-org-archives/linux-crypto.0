From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 05/17] crypto: Add a report function pointer to
 crypto_type
Date: Tue, 27 Sep 2011 07:24:29 +0200
Message-ID: <20110927052429.GG1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:59809 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1I0FYb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:24:31 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We add a report function pointer to struct crypto_type. This function
pointer is used from the crypto userspace configuration API to report
crypto algorithms to userspace.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c    |    5 +++++
 include/crypto/algapi.h |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 513cfe7..aa67c74 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -84,6 +84,11 @@ static int crypto_report_one(struct crypto_alg *alg,
 
 	NLA_PUT_U32(skb, CRYPTOCFGA_PRIORITY_VAL, alg->cra_priority);
 
+	if (alg->cra_type && alg->cra_type->report) {
+		if (alg->cra_type->report(skb, alg))
+			goto nla_put_failure;
+	}
+
 	return 0;
 
 nla_put_failure:
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 59c3e5b..ecc721d 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -15,6 +15,7 @@
 #include <linux/crypto.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
+#include <linux/skbuff.h>
 
 struct module;
 struct rtattr;
@@ -26,6 +27,7 @@ struct crypto_type {
 	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
 	int (*init_tfm)(struct crypto_tfm *tfm);
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
+	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
 	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask);
 
 	unsigned int type;
-- 
1.7.0.4
