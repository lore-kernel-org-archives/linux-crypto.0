Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:17550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728619AbfAPCvR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 21:51:17 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH 1/5] crypto: api - add a helper to (un)register a array of templates
Date: Wed, 16 Jan 2019 10:50:30 +0800
Message-ID: <1547607034-40948-2-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch add a helper to (un)register a array of templates. The
following patches will use this helper to simplify the code.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 crypto/algapi.c         | 27 +++++++++++++++++++++++++++
 include/crypto/algapi.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8b65ada..59a6599 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -494,6 +494,24 @@ int crypto_register_template(struct crypto_template *tmpl)
 }
 EXPORT_SYMBOL_GPL(crypto_register_template);
 
+int crypto_register_templates(struct crypto_template *tmpl, int num)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++) {
+		err = crypto_register_template(&tmpl[i]);
+		if (err)
+			goto out;
+	}
+	return 0;
+
+out:
+	for (i -= 1; i >= 0; i--)
+		crypto_unregister_template(&tmpl[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_register_templates);
+
 void crypto_unregister_template(struct crypto_template *tmpl)
 {
 	struct crypto_instance *inst;
@@ -523,6 +541,15 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_template);
 
+void crypto_unregister_templates(struct crypto_template *tmpl, int num)
+{
+	int i;
+
+	for (i = num - 1; i >= 0; i--)
+		crypto_unregister_template(&tmpl[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_templates);
+
 static struct crypto_template *__crypto_lookup_template(const char *name)
 {
 	struct crypto_template *q, *tmpl = NULL;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 4a5ad10..e879a20 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -143,7 +143,9 @@ struct ablkcipher_walk {
 void crypto_mod_put(struct crypto_alg *alg);
 
 int crypto_register_template(struct crypto_template *tmpl);
+int crypto_register_templates(struct crypto_template *tmpl, int num);
 void crypto_unregister_template(struct crypto_template *tmpl);
+void crypto_unregister_templates(struct crypto_template *tmpl, int num);
 struct crypto_template *crypto_lookup_template(const char *name);
 
 int crypto_register_instance(struct crypto_template *tmpl,
-- 
1.7.12.4
