From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/14] crypto: aead - Add type-safe function for freeing instances
Date: Thu, 09 Jul 2015 07:17:17 +0800
Message-ID: <E1ZCyab-0007XU-5X@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35827 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbbGHXRT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:19 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyab-0005Df-In
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:17 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a type-safe function for freeing AEAD instances
to struct aead_instance.  This replaces the existing free function
in struct crypto_template which does not know the type of the
instance that it's freeing.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |   13 +++++++++++++
 include/crypto/internal/aead.h |    1 +
 2 files changed, 14 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 07bf997..8cd45a7 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -307,9 +307,22 @@ static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "geniv        : <none>\n");
 }
 
+static void crypto_aead_free_instance(struct crypto_instance *inst)
+{
+	struct aead_instance *aead = aead_instance(inst);
+
+	if (!aead->free) {
+		inst->tmpl->free(inst);
+		return;
+	}
+
+	aead->free(aead);
+}
+
 static const struct crypto_type crypto_new_aead_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_aead_init_tfm,
+	.free = crypto_aead_free_instance,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_aead_show,
 #endif
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index c3942f4..a292e96 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -21,6 +21,7 @@
 struct rtattr;
 
 struct aead_instance {
+	void (*free)(struct aead_instance *inst);
 	union {
 		struct {
 			char head[offsetof(struct aead_alg, base)];
