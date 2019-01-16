Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:56336 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730089AbfAPCvc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 21:51:32 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH 5/5] crypto: chacha20poly1305 - use template array registering API to simplify the code
Date: Wed, 16 Jan 2019 10:50:34 +0800
Message-ID: <1547607034-40948-6-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use crypto template array registering API to simplify the code.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 crypto/chacha20poly1305.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index fef1144..f5134d3 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -701,37 +701,29 @@ static int rfc7539esp_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return chachapoly_create(tmpl, tb, "rfc7539esp", 8);
 }
 
-static struct crypto_template rfc7539_tmpl = {
-	.name = "rfc7539",
-	.create = rfc7539_create,
-	.module = THIS_MODULE,
-};
-
-static struct crypto_template rfc7539esp_tmpl = {
-	.name = "rfc7539esp",
-	.create = rfc7539esp_create,
-	.module = THIS_MODULE,
+static struct crypto_template rfc7539_tmpl[] = {
+	{
+		.name = "rfc7539",
+		.create = rfc7539_create,
+		.module = THIS_MODULE,
+	},
+	{
+		.name = "rfc7539esp",
+		.create = rfc7539esp_create,
+		.module = THIS_MODULE,
+	},
 };
 
 static int __init chacha20poly1305_module_init(void)
 {
-	int err;
-
-	err = crypto_register_template(&rfc7539_tmpl);
-	if (err)
-		return err;
-
-	err = crypto_register_template(&rfc7539esp_tmpl);
-	if (err)
-		crypto_unregister_template(&rfc7539_tmpl);
-
-	return err;
+	return crypto_register_templates(rfc7539_tmpl,
+			ARRAY_SIZE(rfc7539_tmpl));
 }
 
 static void __exit chacha20poly1305_module_exit(void)
 {
-	crypto_unregister_template(&rfc7539esp_tmpl);
-	crypto_unregister_template(&rfc7539_tmpl);
+	crypto_unregister_templates(rfc7539_tmpl,
+			ARRAY_SIZE(rfc7539_tmpl));
 }
 
 module_init(chacha20poly1305_module_init);
-- 
1.7.12.4
