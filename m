From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH 3/4] crypto: akcipher: add crypto_akcipher_type methods needed by templates.
Date: Fri, 13 Nov 2015 12:01:34 +0100
Message-ID: <1447412495-4370-3-git-send-email-andrew.zaborowski@intel.com>
References: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36271 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbbKMLBx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Nov 2015 06:01:53 -0500
Received: by wmww144 with SMTP id w144so23802435wmw.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2015 03:01:52 -0800 (PST)
Received: from localhost.localdomain (9.Red-2-136-109.dynamicIP.rima-tde.net. [2.136.109.9])
        by smtp.gmail.com with ESMTPSA id w73sm3401681wme.12.2015.11.13.03.01.51
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Nov 2015 03:01:52 -0800 (PST)
In-Reply-To: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add two dummy methods that are required by the crypto API internals:
.ctxsize and .init
(just because the framework calls them without checking if they were
provided).  They're only required by the complicated code path needed to
instantiate a template algorithm.  Also expose crypto_akcipher_type like
other crypto types are exposed to be used from outside modules.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 crypto/akcipher.c       | 16 +++++++++++++++-
 include/crypto/algapi.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 120ec04..6ef7f99 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -53,6 +53,11 @@ static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_puts(m, "type         : akcipher\n");
 }
 
+static int crypto_akcipher_init(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	return 0;
+}
+
 static void crypto_akcipher_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_akcipher *akcipher = __crypto_akcipher_tfm(tfm);
@@ -75,8 +80,16 @@ static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static const struct crypto_type crypto_akcipher_type = {
+static unsigned int crypto_akcipher_ctxsize(struct crypto_alg *alg, u32 type,
+					    u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+const struct crypto_type crypto_akcipher_type = {
+	.ctxsize = crypto_akcipher_ctxsize,
 	.extsize = crypto_alg_extsize,
+	.init = crypto_akcipher_init,
 	.init_tfm = crypto_akcipher_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_akcipher_show,
@@ -87,6 +100,7 @@ static const struct crypto_type crypto_akcipher_type = {
 	.type = CRYPTO_ALG_TYPE_AKCIPHER,
 	.tfmsize = offsetof(struct crypto_akcipher, base),
 };
+EXPORT_SYMBOL_GPL(crypto_akcipher_type);
 
 struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
 					      u32 mask)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index c9fe145..1089f20 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -130,6 +130,7 @@ struct ablkcipher_walk {
 
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_blkcipher_type;
+extern const struct crypto_type crypto_akcipher_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
-- 
2.1.4
