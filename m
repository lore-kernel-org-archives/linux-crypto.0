Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2250 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728295AbfAQGsx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 01:48:53 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@kernel.org>
CC: <wangxiongfeng2@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH V2 2/5] crypto: ccm - use template array registering API to simplify the code
Date: Thu, 17 Jan 2019 14:48:00 +0800
Message-ID: <1547707683-45878-3-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use crypto template array registering API to simplify the code.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 crypto/ccm.c | 78 ++++++++++++++++++------------------------------------------
 1 file changed, 23 insertions(+), 55 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index b242fd0..50df8f0 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -589,12 +589,6 @@ static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
 					mac_name);
 }
 
-static struct crypto_template crypto_ccm_tmpl = {
-	.name = "ccm",
-	.create = crypto_ccm_create,
-	.module = THIS_MODULE,
-};
-
 static int crypto_ccm_base_create(struct crypto_template *tmpl,
 				  struct rtattr **tb)
 {
@@ -618,12 +612,6 @@ static int crypto_ccm_base_create(struct crypto_template *tmpl,
 					cipher_name);
 }
 
-static struct crypto_template crypto_ccm_base_tmpl = {
-	.name = "ccm_base",
-	.create = crypto_ccm_base_create,
-	.module = THIS_MODULE,
-};
-
 static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,
 				 unsigned int keylen)
 {
@@ -854,12 +842,6 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	goto out;
 }
 
-static struct crypto_template crypto_rfc4309_tmpl = {
-	.name = "rfc4309",
-	.create = crypto_rfc4309_create,
-	.module = THIS_MODULE,
-};
-
 static int crypto_cbcmac_digest_setkey(struct crypto_shash *parent,
 				     const u8 *inkey, unsigned int keylen)
 {
@@ -999,51 +981,37 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return err;
 }
 
-static struct crypto_template crypto_cbcmac_tmpl = {
-	.name = "cbcmac",
-	.create = cbcmac_create,
-	.free = shash_free_instance,
-	.module = THIS_MODULE,
+static struct crypto_template crypto_ccm_tmpls[] = {
+	{
+		.name = "cbcmac",
+		.create = cbcmac_create,
+		.free = shash_free_instance,
+		.module = THIS_MODULE,
+	}, {
+		.name = "ccm_base",
+		.create = crypto_ccm_base_create,
+		.module = THIS_MODULE,
+	}, {
+		.name = "ccm",
+		.create = crypto_ccm_create,
+		.module = THIS_MODULE,
+	}, {
+		.name = "rfc4309",
+		.create = crypto_rfc4309_create,
+		.module = THIS_MODULE,
+	},
 };
 
 static int __init crypto_ccm_module_init(void)
 {
-	int err;
-
-	err = crypto_register_template(&crypto_cbcmac_tmpl);
-	if (err)
-		goto out;
-
-	err = crypto_register_template(&crypto_ccm_base_tmpl);
-	if (err)
-		goto out_undo_cbcmac;
-
-	err = crypto_register_template(&crypto_ccm_tmpl);
-	if (err)
-		goto out_undo_base;
-
-	err = crypto_register_template(&crypto_rfc4309_tmpl);
-	if (err)
-		goto out_undo_ccm;
-
-out:
-	return err;
-
-out_undo_ccm:
-	crypto_unregister_template(&crypto_ccm_tmpl);
-out_undo_base:
-	crypto_unregister_template(&crypto_ccm_base_tmpl);
-out_undo_cbcmac:
-	crypto_register_template(&crypto_cbcmac_tmpl);
-	goto out;
+	return crypto_register_templates(crypto_ccm_tmpls,
+					 ARRAY_SIZE(crypto_ccm_tmpls));
 }
 
 static void __exit crypto_ccm_module_exit(void)
 {
-	crypto_unregister_template(&crypto_rfc4309_tmpl);
-	crypto_unregister_template(&crypto_ccm_tmpl);
-	crypto_unregister_template(&crypto_ccm_base_tmpl);
-	crypto_unregister_template(&crypto_cbcmac_tmpl);
+	crypto_unregister_templates(crypto_ccm_tmpls,
+				    ARRAY_SIZE(crypto_ccm_tmpls));
 }
 
 module_init(crypto_ccm_module_init);
-- 
1.7.12.4
