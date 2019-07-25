Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72539C7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50ADB22C7D
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390491AbfGYNrk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:47:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:39508 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390434AbfGYNrc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 09:47:32 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 51A841A0708;
        Thu, 25 Jul 2019 15:47:30 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 45A3C1A0703;
        Thu, 25 Jul 2019 15:47:30 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0DAEE205E8;
        Thu, 25 Jul 2019 15:47:30 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 2/2] crypto: aes - helper function to validate key length for AES algorithms
Date:   Thu, 25 Jul 2019 16:47:11 +0300
Message-Id: <1564062431-8873-3-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1564062431-8873-1-git-send-email-iuliana.prodan@nxp.com>
References: <1564062431-8873-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add inline helper function to check key length for AES algorithms.
The key can be 128, 192 or 256 bits size.
This function is used in the generic aes and aes_ti implementations.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/aes_generic.c |  7 ++++---
 crypto/aes_ti.c      |  8 ++++----
 include/crypto/aes.h | 17 +++++++++++++++++
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index f217568..f5b7cf6 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1219,10 +1219,11 @@ int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		unsigned int key_len)
 {
 	u32 i, t, u, v, w, j;
+	int err;
 
-	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
-			key_len != AES_KEYSIZE_256)
-		return -EINVAL;
+	err = check_aes_keylen(key_len);
+	if (err)
+		return err;
 
 	ctx->key_length = key_len;
 
diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 1ff9785b..786311c 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -172,11 +172,11 @@ static int aesti_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 {
 	u32 kwords = key_len / sizeof(u32);
 	u32 rc, i, j;
+	int err;
 
-	if (key_len != AES_KEYSIZE_128 &&
-	    key_len != AES_KEYSIZE_192 &&
-	    key_len != AES_KEYSIZE_256)
-		return -EINVAL;
+	err = check_aes_keylen(key_len);
+	if (err)
+		return err;
 
 	ctx->key_length = key_len;
 
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 0fdb542..c3a92ca 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -33,6 +33,23 @@ extern const u32 crypto_fl_tab[4][256] ____cacheline_aligned;
 extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
 extern const u32 crypto_il_tab[4][256] ____cacheline_aligned;
 
+/*
+ * validate key length for AES algorithms
+ */
+static inline int check_aes_keylen(unsigned int keylen)
+{
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
 int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
-- 
2.1.0

