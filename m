Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680FEC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DACF64E8B
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhBHJpv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:45:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12494 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhBHJmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:42:38 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DZ1GH6y94zjBW5;
        Mon,  8 Feb 2021 17:40:07 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 17:41:20 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 3/9] crypto: atmel-ecc - move curve_id of ECDH from the key to algorithm name
Date:   Mon, 8 Feb 2021 17:38:51 +0800
Message-ID: <1612777137-51067-4-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
References: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As curve id of ECDH will be moved from its key into algorithm name,
we cannot use 'curve_id' in 'struct ecdh', so we should modify ECDH
driver in atmel, and make ECDH algorithm name be the same as crypto
(like 'ecdh-nist-pxxx');

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/atmel-ecc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9bd8e51..9ade6ad 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -104,7 +104,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 		return -EINVAL;
 	}
 
-	ctx->n_sz = atmel_ecdh_supported_curve(params.curve_id);
+	ctx->n_sz = atmel_ecdh_supported_curve(ctx->curve_id);
 	if (!ctx->n_sz || params.key_size) {
 		/* fallback to ecdh software implementation */
 		ctx->do_fallback = true;
@@ -125,7 +125,6 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 		goto free_cmd;
 
 	ctx->do_fallback = false;
-	ctx->curve_id = params.curve_id;
 
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
@@ -263,6 +262,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct crypto_kpp *fallback;
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	ctx->curve_id = ECC_CURVE_NIST_P256;
 	ctx->client = atmel_ecc_i2c_client_alloc();
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
@@ -306,7 +306,7 @@ static unsigned int atmel_ecdh_max_size(struct crypto_kpp *tfm)
 	return ATMEL_ECC_PUBKEY_SIZE;
 }
 
-static struct kpp_alg atmel_ecdh = {
+static struct kpp_alg atmel_ecdh_nist_p256 = {
 	.set_secret = atmel_ecdh_set_secret,
 	.generate_public_key = atmel_ecdh_generate_public_key,
 	.compute_shared_secret = atmel_ecdh_compute_shared_secret,
@@ -315,7 +315,7 @@ static struct kpp_alg atmel_ecdh = {
 	.max_size = atmel_ecdh_max_size,
 	.base = {
 		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-		.cra_name = "ecdh",
+		.cra_name = "ecdh-nist-p256",
 		.cra_driver_name = "atmel-ecdh",
 		.cra_priority = ATMEL_ECC_PRIORITY,
 		.cra_module = THIS_MODULE,
@@ -340,14 +340,14 @@ static int atmel_ecc_probe(struct i2c_client *client,
 		      &driver_data.i2c_client_list);
 	spin_unlock(&driver_data.i2c_list_lock);
 
-	ret = crypto_register_kpp(&atmel_ecdh);
+	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
 		spin_lock(&driver_data.i2c_list_lock);
 		list_del(&i2c_priv->i2c_client_list_node);
 		spin_unlock(&driver_data.i2c_list_lock);
 
 		dev_err(&client->dev, "%s alg registration failed\n",
-			atmel_ecdh.base.cra_driver_name);
+			atmel_ecdh_nist_p256.base.cra_driver_name);
 	} else {
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
@@ -365,7 +365,7 @@ static int atmel_ecc_remove(struct i2c_client *client)
 		return -EBUSY;
 	}
 
-	crypto_unregister_kpp(&atmel_ecdh);
+	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
-- 
2.8.1

