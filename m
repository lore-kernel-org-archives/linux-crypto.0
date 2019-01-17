Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2248 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725982AbfAQGsx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 01:48:53 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@kernel.org>
CC: <wangxiongfeng2@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH V2 1/5] crypto: api - add a helper to (un)register a array of templates
Date: Thu, 17 Jan 2019 14:47:59 +0800
Message-ID: <1547707683-45878-2-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
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
index 713baab..4c9c86b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -494,6 +494,24 @@ int crypto_register_template(struct crypto_template *tmpl)
 }
 EXPORT_SYMBOL_GPL(crypto_register_template);
 
+int crypto_register_templates(struct crypto_template *tmpls, int count)
+{
+	int i, err;
+
+	for (i = 0; i < count; i++) {
+		err = crypto_register_template(&tmpls[i]);
+		if (err)
+			goto out;
+	}
+	return 0;
+
+out:
+	for (--i; i >= 0; --i)
+		crypto_unregister_template(&tmpls[i]);
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
 
+void crypto_unregister_templates(struct crypto_template *tmpls, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_template(&tmpls[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_templates);
+
 static struct crypto_template *__crypto_lookup_template(const char *name)
 {
 	struct crypto_template *q, *tmpl = NULL;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 093869f..4be38cd 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -143,7 +143,9 @@ struct ablkcipher_walk {
 void crypto_mod_put(struct crypto_alg *alg);
 
 int crypto_register_template(struct crypto_template *tmpl);
+int crypto_register_templates(struct crypto_template *tmpls, int count);
 void crypto_unregister_template(struct crypto_template *tmpl);
+void crypto_unregister_templates(struct crypto_template *tmpls, int count);
 struct crypto_template *crypto_lookup_template(const char *name);
 
 int crypto_register_instance(struct crypto_template *tmpl,
-- 
1.7.12.4
