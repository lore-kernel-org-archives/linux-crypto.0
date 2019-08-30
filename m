Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEC0C3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A01D6238CD
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X823E9xI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfH3Iob (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:44:31 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40690 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbfH3Iob (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:44:31 -0400
Received: by mail-ed1-f66.google.com with SMTP id v38so1250456edm.7
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NEAtynAIdLSzAkOH6i/a2KtA5frGxmWsUO/f1fcazaY=;
        b=X823E9xIxjV+KkhkapSV+ZNOFXRjy8RVf9bdqkj80ncvIUQnBAXtcd4la040+y3tD3
         juxbCMWENctVZwtMrfcby6bSp3cfp0Emzn6hjWUCndohjFR0fc8RygUKmIZWvSgMKHYO
         axh33iBibljyBs42h/45wi2Lx46rbsoO0lYeJwNGSx62n9Q31PPp7b87S+EEHvwXuV6b
         QoYlV+HHKJUwDnSXXnbnXgvmnYZxtKyMaXt0+yPrBpWPyG9KvIGd22A1opDBkD0AZS7R
         +pSP+GUPQvBRFcTlE1XeijiFBhrSF5AOc2Ek4c1P/CYYi+CLv0wpQrquai8veYy3xlY6
         NYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NEAtynAIdLSzAkOH6i/a2KtA5frGxmWsUO/f1fcazaY=;
        b=s8/N4kBODXVKDTzR0h4Flh75/CuJhnM2zIDi5xklVNNm2JXDonPo6GJQzaI/xg96sj
         nWX10hJpGUeNccA1oQ0RPSOSNzla2wa48rbPRhlgzs3U9jQMwTqzmgP34yvjyOvo8MDm
         TsUbsz+OgVCLpN+MLY3sskVNJFt2naM+49oFE9cnqI3Q7dKxKWKOs0c27ouZzMTltMHB
         g2XhMXIPOAuIO0Zo3LOIiZ9wp5JtksEodOjHUmHNoERxtuNX1Nw6YdKgEy4NR48Jb1Az
         QpOfEzAmN8k4mm3EEJ9J1dZ/WIdRrLo52fh2ubxF+qtqmU3aos/n9KwWDIs+/5yu9f7E
         kpwA==
X-Gm-Message-State: APjAAAW56oziiTKzRYAdEFqNtaVscSBDSPop0HBikRed2TLhwporL8Z8
        igqNhwV++ukLvPKVdYOOnQ/6FMxc
X-Google-Smtp-Source: APXvYqxb01mwsYFPB0vMeLkXOQ6lwRdlqP/nHfz+kg5HJChcMNumhkWSuIY0E+142Q1cY0f1fWUVlg==
X-Received: by 2002:a50:b15a:: with SMTP id l26mr13938795edd.162.1567154667755;
        Fri, 30 Aug 2019 01:44:27 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id i15sm885589edq.21.2019.08.30.01.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:44:27 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Made .cra_priority value a define
Date:   Fri, 30 Aug 2019 09:41:47 +0200
Message-Id: <1567150907-10741-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of having a fixed value (of 300) all over the place, the value for
for .cra_priority is now made into a define (SAFEXCEL_CRA_PRIORITY).
This makes it easier to play with, e.g. during development.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.h        |  3 ++
 drivers/crypto/inside-secure/safexcel_cipher.c | 38 +++++++++++++-------------
 drivers/crypto/inside-secure/safexcel_hash.c   | 24 ++++++++--------
 3 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b5ff62f..1e575a1 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -598,6 +598,9 @@ enum safexcel_eip_version {
 	EIP197_DEVBRD
 };
 
+/* Priority we use for advertising our algorithms */
+#define SAFEXCEL_CRA_PRIORITY		300
+
 /* EIP algorithm presence flags */
 enum safexcel_eip_algorithms {
 	SAFEXCEL_ALG_BC0      = BIT(5),
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 2bf75ea..7656678 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1050,7 +1050,7 @@ struct safexcel_alg_template safexcel_alg_ecb_aes = {
 		.base = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "safexcel-ecb-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1086,7 +1086,7 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 		.base = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "safexcel-cbc-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1161,7 +1161,7 @@ struct safexcel_alg_template safexcel_alg_ctr_aes = {
 		.base = {
 			.cra_name = "rfc3686(ctr(aes))",
 			.cra_driver_name = "safexcel-ctr-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1222,7 +1222,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des = {
 		.base = {
 			.cra_name = "cbc(des)",
 			.cra_driver_name = "safexcel-cbc-des",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -1257,7 +1257,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
 		.base = {
 			.cra_name = "ecb(des)",
 			.cra_driver_name = "safexcel-ecb-des",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -1316,7 +1316,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
 		.base = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "safexcel-cbc-des3_ede",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1351,7 +1351,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 		.base = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "safexcel-ecb-des3_ede",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1420,7 +1420,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1455,7 +1455,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1490,7 +1490,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha224),cbc(aes))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1525,7 +1525,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha512),cbc(aes))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1560,7 +1560,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha384),cbc(aes))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1594,7 +1594,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 		.base = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des3_ede",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1628,7 +1628,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1662,7 +1662,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-ctr-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1696,7 +1696,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-ctr-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1730,7 +1730,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-ctr-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1764,7 +1764,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 		.base = {
 			.cra_name = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-ctr-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1880,7 +1880,7 @@ struct safexcel_alg_template safexcel_alg_xts_aes = {
 		.base = {
 			.cra_name = "xts(aes)",
 			.cra_driver_name = "safexcel-xts-aes",
-			.cra_priority = 300,
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = XTS_BLOCK_SIZE,
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index e60838f..2effb6d 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -860,7 +860,7 @@ struct safexcel_alg_template safexcel_alg_sha1 = {
 			.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "safexcel-sha1",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
@@ -1102,7 +1102,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha1 = {
 			.base = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "safexcel-hmac-sha1",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
@@ -1157,7 +1157,7 @@ struct safexcel_alg_template safexcel_alg_sha256 = {
 			.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "safexcel-sha256",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
@@ -1212,7 +1212,7 @@ struct safexcel_alg_template safexcel_alg_sha224 = {
 			.base = {
 				.cra_name = "sha224",
 				.cra_driver_name = "safexcel-sha224",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
@@ -1282,7 +1282,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha224 = {
 			.base = {
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "safexcel-hmac-sha224",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
@@ -1352,7 +1352,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha256 = {
 			.base = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "safexcel-hmac-sha256",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
@@ -1407,7 +1407,7 @@ struct safexcel_alg_template safexcel_alg_sha512 = {
 			.base = {
 				.cra_name = "sha512",
 				.cra_driver_name = "safexcel-sha512",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
@@ -1462,7 +1462,7 @@ struct safexcel_alg_template safexcel_alg_sha384 = {
 			.base = {
 				.cra_name = "sha384",
 				.cra_driver_name = "safexcel-sha384",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
@@ -1532,7 +1532,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha512 = {
 			.base = {
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "safexcel-hmac-sha512",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
@@ -1602,7 +1602,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha384 = {
 			.base = {
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "safexcel-hmac-sha384",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
@@ -1657,7 +1657,7 @@ struct safexcel_alg_template safexcel_alg_md5 = {
 			.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "safexcel-md5",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
@@ -1728,7 +1728,7 @@ struct safexcel_alg_template safexcel_alg_hmac_md5 = {
 			.base = {
 				.cra_name = "hmac(md5)",
 				.cra_driver_name = "safexcel-hmac-md5",
-				.cra_priority = 300,
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-- 
1.8.3.1

