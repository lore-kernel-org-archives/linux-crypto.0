Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85263C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 657F5206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbfGaNGI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 09:06:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:33810 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387726AbfGaNGH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 09:06:07 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C0C8D1A040D;
        Wed, 31 Jul 2019 15:06:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B3DB01A01AC;
        Wed, 31 Jul 2019 15:06:04 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 65C9B205F3;
        Wed, 31 Jul 2019 15:06:04 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v3 1/2] crypto: gcm - helper functions for assoclen/authsize check
Date:   Wed, 31 Jul 2019 16:05:54 +0300
Message-Id: <1564578355-9639-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1564578355-9639-1-git-send-email-iuliana.prodan@nxp.com>
References: <1564578355-9639-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added inline helper functions to check authsize and assoclen for
gcm, rfc4106 and rfc4543.
These are used in the generic implementation of gcm, rfc4106 and
rfc4543.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/gcm.c         | 41 ++++++++++++++-------------------------
 include/crypto/gcm.h | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 26 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index f254e2d..2f3b50f 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -152,20 +152,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 static int crypto_gcm_setauthsize(struct crypto_aead *tfm,
 				  unsigned int authsize)
 {
-	switch (authsize) {
-	case 4:
-	case 8:
-	case 12:
-	case 13:
-	case 14:
-	case 15:
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
+	return crypto_gcm_check_authsize(authsize);
 }
 
 static void crypto_gcm_init_common(struct aead_request *req)
@@ -762,15 +749,11 @@ static int crypto_rfc4106_setauthsize(struct crypto_aead *parent,
 				      unsigned int authsize)
 {
 	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(parent);
+	int err;
 
-	switch (authsize) {
-	case 8:
-	case 12:
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
+	err = crypto_rfc4106_check_authsize(authsize);
+	if (err)
+		return err;
 
 	return crypto_aead_setauthsize(ctx->child, authsize);
 }
@@ -818,8 +801,11 @@ static struct aead_request *crypto_rfc4106_crypt(struct aead_request *req)
 
 static int crypto_rfc4106_encrypt(struct aead_request *req)
 {
-	if (req->assoclen != 16 && req->assoclen != 20)
-		return -EINVAL;
+	int err;
+
+	err = crypto_ipsec_check_assoclen(req->assoclen);
+	if (err)
+		return err;
 
 	req = crypto_rfc4106_crypt(req);
 
@@ -828,8 +814,11 @@ static int crypto_rfc4106_encrypt(struct aead_request *req)
 
 static int crypto_rfc4106_decrypt(struct aead_request *req)
 {
-	if (req->assoclen != 16 && req->assoclen != 20)
-		return -EINVAL;
+	int err;
+
+	err = crypto_ipsec_check_assoclen(req->assoclen);
+	if (err)
+		return err;
 
 	req = crypto_rfc4106_crypt(req);
 
diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index c50e057..9d7eff0 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -1,8 +1,63 @@
 #ifndef _CRYPTO_GCM_H
 #define _CRYPTO_GCM_H
 
+#include <linux/errno.h>
+
 #define GCM_AES_IV_SIZE 12
 #define GCM_RFC4106_IV_SIZE 8
 #define GCM_RFC4543_IV_SIZE 8
 
+/*
+ * validate authentication tag for GCM
+ */
+static inline int crypto_gcm_check_authsize(unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12:
+	case 13:
+	case 14:
+	case 15:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * validate authentication tag for RFC4106
+ */
+static inline int crypto_rfc4106_check_authsize(unsigned int authsize)
+{
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * validate assoclen for RFC4106/RFC4543
+ */
+static inline int crypto_ipsec_check_assoclen(unsigned int assoclen)
+{
+	switch (assoclen) {
+	case 16:
+	case 20:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
 #endif
-- 
2.1.0

