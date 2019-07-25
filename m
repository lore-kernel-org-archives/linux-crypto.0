Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8499AC7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 671C522BEF
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390466AbfGYNrf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:47:35 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47880 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390433AbfGYNrc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 09:47:32 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0CC3020071C;
        Thu, 25 Jul 2019 15:47:30 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F381920071A;
        Thu, 25 Jul 2019 15:47:29 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A8E2E205E8;
        Thu, 25 Jul 2019 15:47:29 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 1/2] crypto: gcm - helper functions for assoclen/authsize check
Date:   Thu, 25 Jul 2019 16:47:10 +0300
Message-Id: <1564062431-8873-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1564062431-8873-1-git-send-email-iuliana.prodan@nxp.com>
References: <1564062431-8873-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added inline helper functions to check authsize and assoclen for
gcm and rfc4106.
These are used in the generic implementation of gcm and rfc4106.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/gcm.c         | 41 +++++++++++++++-------------------------
 include/crypto/gcm.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 33f45a9..f69c251 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -155,20 +155,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
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
+	return check_gcm_authsize(authsize);
 }
 
 static void crypto_gcm_init_common(struct aead_request *req)
@@ -765,15 +752,11 @@ static int crypto_rfc4106_setauthsize(struct crypto_aead *parent,
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
+	err = check_rfc4106_authsize(authsize);
+	if (err)
+		return err;
 
 	return crypto_aead_setauthsize(ctx->child, authsize);
 }
@@ -821,8 +804,11 @@ static struct aead_request *crypto_rfc4106_crypt(struct aead_request *req)
 
 static int crypto_rfc4106_encrypt(struct aead_request *req)
 {
-	if (req->assoclen != 16 && req->assoclen != 20)
-		return -EINVAL;
+	int err;
+
+	err = check_ipsec_assoclen(req->assoclen);
+	if (err)
+		return err;
 
 	req = crypto_rfc4106_crypt(req);
 
@@ -831,8 +817,11 @@ static int crypto_rfc4106_encrypt(struct aead_request *req)
 
 static int crypto_rfc4106_decrypt(struct aead_request *req)
 {
-	if (req->assoclen != 16 && req->assoclen != 20)
-		return -EINVAL;
+	int err;
+
+	err = check_ipsec_assoclen(req->assoclen);
+	if (err)
+		return err;
 
 	req = crypto_rfc4106_crypt(req);
 
diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index c50e057..9834b97 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -5,4 +5,57 @@
 #define GCM_RFC4106_IV_SIZE 8
 #define GCM_RFC4543_IV_SIZE 8
 
+/*
+ * validate authentication tag for GCM
+ */
+static inline int check_gcm_authsize(unsigned int authsize)
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
+static inline int check_rfc4106_authsize(unsigned int authsize)
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
+static inline int check_ipsec_assoclen(unsigned int assoclen)
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

