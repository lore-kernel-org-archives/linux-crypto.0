Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B3DC76195
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7F9B21849
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390494AbfGROtS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:49:18 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43098 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390345AbfGROtS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 10:49:18 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1744C2000AC;
        Thu, 18 Jul 2019 16:49:16 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0A22E200009;
        Thu, 18 Jul 2019 16:49:16 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B3F1F205C7;
        Thu, 18 Jul 2019 16:49:15 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - move shared symbols in a common location
Date:   Thu, 18 Jul 2019 17:49:09 +0300
Message-Id: <1563461349-24876-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Moved to a common location the symbols shared by all CAAM drivers (jr,
qi, qi2).

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
This patch depends on series:
https://patchwork.kernel.org/project/linux-crypto/list/?series=147479

 drivers/crypto/caam/common_if.c | 7 +++++++
 drivers/crypto/caam/common_if.h | 7 +++++++
 drivers/crypto/caam/error.c     | 6 ------
 drivers/crypto/caam/error.h     | 5 -----
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/common_if.c b/drivers/crypto/caam/common_if.c
index 1291d3d..071b08d 100644
--- a/drivers/crypto/caam/common_if.c
+++ b/drivers/crypto/caam/common_if.c
@@ -7,6 +7,13 @@
 
 #include "compat.h"
 #include "common_if.h"
+#include <linux/types.h>
+
+bool caam_little_end;
+EXPORT_SYMBOL(caam_little_end);
+
+bool caam_imx;
+EXPORT_SYMBOL(caam_imx);
 
 /*
  * validate key length for AES algorithms
diff --git a/drivers/crypto/caam/common_if.h b/drivers/crypto/caam/common_if.h
index 61d5516..5fb8840 100644
--- a/drivers/crypto/caam/common_if.h
+++ b/drivers/crypto/caam/common_if.h
@@ -8,6 +8,8 @@
 #ifndef CAAM_COMMON_LOCATION_H
 #define CAAM_COMMON_LOCATION_H
 
+#include "desc.h"
+
 int check_aes_keylen(unsigned int keylen);
 
 int check_gcm_authsize(unsigned int authsize);
@@ -16,4 +18,9 @@ int check_rfc4106_authsize(unsigned int authsize);
 
 int check_ipsec_assoclen(unsigned int assoclen);
 
+static inline bool is_mdha(u32 algtype)
+{
+	return (algtype & OP_ALG_ALGSEL_MASK & ~OP_ALG_ALGSEL_SUBMASK) ==
+	       OP_ALG_CHA_MDHA;
+}
 #endif /* CAAM_COMMON_LOCATION_H */
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index b7fbf1b..b901872 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -50,12 +50,6 @@ void caam_dump_sg(const char *prefix_str, int prefix_type,
 #endif /* DEBUG */
 EXPORT_SYMBOL(caam_dump_sg);
 
-bool caam_little_end;
-EXPORT_SYMBOL(caam_little_end);
-
-bool caam_imx;
-EXPORT_SYMBOL(caam_imx);
-
 static const struct {
 	u8 value;
 	const char *error_text;
diff --git a/drivers/crypto/caam/error.h b/drivers/crypto/caam/error.h
index 16809fa..e2f6ed8 100644
--- a/drivers/crypto/caam/error.h
+++ b/drivers/crypto/caam/error.h
@@ -21,9 +21,4 @@ void caam_dump_sg(const char *prefix_str, int prefix_type,
 		  int rowsize, int groupsize, struct scatterlist *sg,
 		  size_t tlen, bool ascii);
 
-static inline bool is_mdha(u32 algtype)
-{
-	return (algtype & OP_ALG_ALGSEL_MASK & ~OP_ALG_ALGSEL_SUBMASK) ==
-	       OP_ALG_CHA_MDHA;
-}
 #endif /* CAAM_ERROR_H */
-- 
2.1.0

