From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: qat - Make several functions static
Date: Tue,  6 Feb 2018 23:36:42 +0000
Message-ID: <20180206233642.14591-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58257 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754129AbeBFXgy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 18:36:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Functions qat_rsa_set_n, qat_rsa_set_e and qat_rsa_set_n are local to
the source and do not need to be in global scope, so make them static.

Cleans up sparse warnings:
drivers/crypto/qat/qat_common/qat_asym_algs.c:972:5: warning: symbol
'qat_rsa_set_n' was not declared. Should it be static?
drivers/crypto/qat/qat_common/qat_asym_algs.c:1003:5: warning: symbol
'qat_rsa_set_e' was not declared. Should it be static?
drivers/crypto/qat/qat_common/qat_asym_algs.c:1027:5: warning: symbol
'qat_rsa_set_d' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 13c52d6bf630..320e7854b4ee 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -969,7 +969,8 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	return ret;
 }
 
-int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
+static int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value,
+			 size_t vlen)
 {
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
@@ -1000,7 +1001,8 @@ int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
 	return ret;
 }
 
-int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
+static int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value,
+			 size_t vlen)
 {
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
@@ -1024,7 +1026,8 @@ int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
 	return 0;
 }
 
-int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
+static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
+			 size_t vlen)
 {
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
-- 
2.15.1
