Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:17552 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730077AbfAPCvc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 21:51:32 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH 4/5] crypto: ctr - use template array registering API to simplify the code
Date: Wed, 16 Jan 2019 10:50:33 +0800
Message-ID: <1547607034-40948-5-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use crypto template array registering API to simplify the code.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 crypto/ctr.c | 46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 30f3946..ef51099 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -248,13 +248,6 @@ static void crypto_ctr_free(struct crypto_instance *inst)
 	kfree(inst);
 }
 
-static struct crypto_template crypto_ctr_tmpl = {
-	.name = "ctr",
-	.alloc = crypto_ctr_alloc,
-	.free = crypto_ctr_free,
-	.module = THIS_MODULE,
-};
-
 static int crypto_rfc3686_setkey(struct crypto_skcipher *parent,
 				 const u8 *key, unsigned int keylen)
 {
@@ -444,36 +437,31 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	goto out;
 }
 
-static struct crypto_template crypto_rfc3686_tmpl = {
-	.name = "rfc3686",
-	.create = crypto_rfc3686_create,
-	.module = THIS_MODULE,
+static struct crypto_template crypto_ctr_tmpl[] = {
+	{
+		.name = "ctr",
+		.alloc = crypto_ctr_alloc,
+		.free = crypto_ctr_free,
+		.module = THIS_MODULE,
+	},
+	{
+		.name = "rfc3686",
+		.create = crypto_rfc3686_create,
+		.module = THIS_MODULE,
+	},
 };
 
+
 static int __init crypto_ctr_module_init(void)
 {
-	int err;
-
-	err = crypto_register_template(&crypto_ctr_tmpl);
-	if (err)
-		goto out;
-
-	err = crypto_register_template(&crypto_rfc3686_tmpl);
-	if (err)
-		goto out_drop_ctr;
-
-out:
-	return err;
-
-out_drop_ctr:
-	crypto_unregister_template(&crypto_ctr_tmpl);
-	goto out;
+	return crypto_register_templates(crypto_ctr_tmpl,
+			ARRAY_SIZE(crypto_ctr_tmpl));
 }
 
 static void __exit crypto_ctr_module_exit(void)
 {
-	crypto_unregister_template(&crypto_rfc3686_tmpl);
-	crypto_unregister_template(&crypto_ctr_tmpl);
+	crypto_unregister_templates(crypto_ctr_tmpl,
+			ARRAY_SIZE(crypto_ctr_tmpl));
 }
 
 module_init(crypto_ctr_module_init);
-- 
1.7.12.4
