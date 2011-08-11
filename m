From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 04/16] crypto: Add a report function pointer to crypto_type
Date: Thu, 11 Aug 2011 13:28:23 +0200
Message-ID: <20110811112823.GH16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:44076 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab1HKL1v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:27:51 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We add a report function pointer to struct crypto_type. This function
pointer is used from the crypto userspace configuration API to report
crypto algorithms to userspace.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c    |    8 ++++++++
 include/crypto/algapi.h |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index c288ada..49f302a 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -88,7 +88,15 @@ static int crypto_report_one(struct crypto_alg *alg,
 	rb->priority = alg->cra_priority;
 	rb->refcnt = atomic_read(&alg->cra_refcnt);
 
+	if (alg->cra_type && alg->cra_type->report) {
+		if (alg->cra_type->report(skb, alg))
+			goto nla_put_failure;
+	}
+
 	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
 }
 
 static int crypto_report_alg(struct crypto_alg *alg,
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
