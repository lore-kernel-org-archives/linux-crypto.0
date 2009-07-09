From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/16] crypto: api - Add new template create function
Date: Thu, 09 Jul 2009 12:53:46 +0800
Message-ID: <E1MOldi-0005VJ-H5@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44856 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266AbZGIExs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:48 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldj-0006DA-AW
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:47 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Add new template create function

This patch introduces the template->create function intended
to replace the existing alloc function.  The intention is for
create to handle the registration directly, whereas currently
the caller of alloc has to handle the registration.

This allows type-specific code to be run prior to registration.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algboss.c        |    5 +++++
 include/crypto/algapi.h |    1 +
 2 files changed, 6 insertions(+)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 9908dd8..412241c 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -68,6 +68,11 @@ static int cryptomgr_probe(void *data)
 		goto err;
 
 	do {
+		if (tmpl->create) {
+			err = tmpl->create(tmpl, param->tb);
+			continue;
+		}
+
 		inst = tmpl->alloc(param->tb);
 		if (IS_ERR(inst))
 			err = PTR_ERR(inst);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 0105454..ce010a3 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -52,6 +52,7 @@ struct crypto_template {
 
 	struct crypto_instance *(*alloc)(struct rtattr **tb);
 	void (*free)(struct crypto_instance *inst);
+	int (*create)(struct crypto_template *tmpl, struct rtattr **tb);
 
 	char name[CRYPTO_MAX_ALG_NAME];
 };
