Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2195 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727237AbfARF7C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 00:59:02 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@kernel.org>
CC: <wangxiongfeng2@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH V3 4/5] crypto: ctr - use template array registering API to simplify the code
Date: Fri, 18 Jan 2019 13:58:14 +0800
Message-ID: <1547791095-48339-5-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1547791095-48339-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1547791095-48339-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

Use crypto template array registering API to simplify the code.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ctr.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 4c743a9..ec8f8b6 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -171,12 +171,6 @@ static int crypto_ctr_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return err;
 }
 
-static struct crypto_template crypto_ctr_tmpl = {
-	.name = "ctr",
-	.create = crypto_ctr_create,
-	.module = THIS_MODULE,
-};
-
 static int crypto_rfc3686_setkey(struct crypto_skcipher *parent,
 				 const u8 *key, unsigned int keylen)
 {
@@ -366,36 +360,28 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	goto out;
 }
 
-static struct crypto_template crypto_rfc3686_tmpl = {
-	.name = "rfc3686",
-	.create = crypto_rfc3686_create,
-	.module = THIS_MODULE,
+static struct crypto_template crypto_ctr_tmpls[] = {
+	{
+		.name = "ctr",
+		.create = crypto_ctr_create,
+		.module = THIS_MODULE,
+	}, {
+		.name = "rfc3686",
+		.create = crypto_rfc3686_create,
+		.module = THIS_MODULE,
+	},
 };
 
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
+	return crypto_register_templates(crypto_ctr_tmpls,
+					 ARRAY_SIZE(crypto_ctr_tmpls));
 }
 
 static void __exit crypto_ctr_module_exit(void)
 {
-	crypto_unregister_template(&crypto_rfc3686_tmpl);
-	crypto_unregister_template(&crypto_ctr_tmpl);
+	crypto_unregister_templates(crypto_ctr_tmpls,
+				    ARRAY_SIZE(crypto_ctr_tmpls));
 }
 
 module_init(crypto_ctr_module_init);
-- 
1.7.12.4
