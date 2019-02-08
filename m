Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD66AC282CB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 988DE20869
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfBHNvU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:51:20 -0500
Received: from inva020.nxp.com ([92.121.34.13]:53852 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbfBHNvS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 08:51:18 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F3F01A027F;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 736651A027A;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1DA7620138;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 2/4] crypto: export arc4 defines
Date:   Fri,  8 Feb 2019 15:50:08 +0200
Message-Id: <1549633810-10380-3-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some arc4 cipher algorithm defines show up in two places:
crypto/arc4.c and drivers/crypto/bcm/cipher.h.
Let's export them in a common header and update their users.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/arc4.c               |  5 +----
 drivers/crypto/bcm/cipher.h |  4 +---
 include/crypto/arc4.h       | 13 +++++++++++++
 3 files changed, 15 insertions(+), 7 deletions(-)
 create mode 100644 include/crypto/arc4.h

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 652d243..6c93342 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -13,14 +13,11 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/arc4.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
 #include <linux/module.h>
 
-#define ARC4_MIN_KEY_SIZE	1
-#define ARC4_MAX_KEY_SIZE	256
-#define ARC4_BLOCK_SIZE		1
-
 struct arc4_ctx {
 	u32 S[256];
 	u32 x, y;
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index 763c425..f6da497 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -23,6 +23,7 @@
 #include <crypto/aes.h>
 #include <crypto/internal/hash.h>
 #include <crypto/aead.h>
+#include <crypto/arc4.h>
 #include <crypto/gcm.h>
 #include <crypto/sha.h>
 #include <crypto/sha3.h>
@@ -34,9 +35,6 @@
 /* Driver supports up to MAX_SPUS SPU blocks */
 #define MAX_SPUS 16
 
-#define ARC4_MIN_KEY_SIZE   1
-#define ARC4_MAX_KEY_SIZE   256
-#define ARC4_BLOCK_SIZE     1
 #define ARC4_STATE_SIZE     4
 
 #define CCM_AES_IV_SIZE    16
diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
new file mode 100644
index 0000000..5b2c24a
--- /dev/null
+++ b/include/crypto/arc4.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Common values for ARC4 Cipher Algorithm
+ */
+
+#ifndef _CRYPTO_ARC4_H
+#define _CRYPTO_ARC4_H
+
+#define ARC4_MIN_KEY_SIZE	1
+#define ARC4_MAX_KEY_SIZE	256
+#define ARC4_BLOCK_SIZE		1
+
+#endif /* _CRYPTO_ARC4_H */
-- 
2.1.0

