Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbfARF7C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 00:59:02 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@kernel.org>
CC: <wangxiongfeng2@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH V3 5/5] crypto: chacha20poly1305 - use template array registering API to simplify the code
Date: Fri, 18 Jan 2019 13:58:15 +0800
Message-ID: <1547791095-48339-6-git-send-email-wangxiongfeng2@huawei.com>
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
 crypto/chacha20poly1305.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index fef1144..ed2e12e 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -701,37 +701,28 @@ static int rfc7539esp_create(struct crypto_template *tmpl, struct rtattr **tb)
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
+static struct crypto_template rfc7539_tmpls[] = {
+	{
+		.name = "rfc7539",
+		.create = rfc7539_create,
+		.module = THIS_MODULE,
+	}, {
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
+	return crypto_register_templates(rfc7539_tmpls,
+					 ARRAY_SIZE(rfc7539_tmpls));
 }
 
 static void __exit chacha20poly1305_module_exit(void)
 {
-	crypto_unregister_template(&rfc7539esp_tmpl);
-	crypto_unregister_template(&rfc7539_tmpl);
+	crypto_unregister_templates(rfc7539_tmpls,
+				    ARRAY_SIZE(rfc7539_tmpls));
 }
 
 module_init(chacha20poly1305_module_init);
-- 
1.7.12.4
