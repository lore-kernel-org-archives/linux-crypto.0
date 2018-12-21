Return-Path: <SRS0=edWn=O6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva020.nxp.com ([92.121.34.13]:48704 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390384AbeLUMn0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Dec 2018 07:43:26 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH] crypto: caam - fix SHA support detection
Date: Fri, 21 Dec 2018 14:43:16 +0200
Message-Id: <20181221124316.23572-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The addition of Chacha20 + Poly1305 authenc support inadvertently broke
detection of algorithms supported by MDHA (Message Digest Hardware
Accelerator), fix it.

Cc: <stable@vger.kernel.org>
Fixes: d6bbd4eea243 ("crypto: caam/jr - add support for Chacha20 + Poly1305")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 2 +-
 drivers/crypto/caam/desc.h    | 1 +
 drivers/crypto/caam/error.h   | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 92e593e2069a..80ae69f906fb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3476,7 +3476,7 @@ static int __init caam_algapi_init(void)
 		 * Skip algorithms requiring message digests
 		 * if MD or MD size is not supported by device.
 		 */
-		if ((c2_alg_sel & ~OP_ALG_ALGSEL_SUBMASK) == 0x40 &&
+		if (is_mdha(c2_alg_sel) &&
 		    (!md_inst || t_alg->aead.maxauthsize > md_limit))
 			continue;
 
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index ec10230178c5..4b6854bf896a 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1155,6 +1155,7 @@
 #define OP_ALG_ALGSEL_DES	(0x20 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_3DES	(0x21 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_ARC4	(0x30 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_CHA_MDHA		(0x40 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_MD5	(0x40 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_SHA1	(0x41 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_SHA224	(0x42 << OP_ALG_ALGSEL_SHIFT)
diff --git a/drivers/crypto/caam/error.h b/drivers/crypto/caam/error.h
index 67ea94079837..a3ff448822d0 100644
--- a/drivers/crypto/caam/error.h
+++ b/drivers/crypto/caam/error.h
@@ -5,6 +5,8 @@
  * Copyright 2009-2011 Freescale Semiconductor, Inc.
  */
 
+#include "desc.h"
+
 #ifndef CAAM_ERROR_H
 #define CAAM_ERROR_H
 #define CAAM_ERROR_STR_MAX 302
@@ -17,4 +19,10 @@ void caam_strstatus(struct device *dev, u32 status, bool qi_v2);
 void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
 		  int rowsize, int groupsize, struct scatterlist *sg,
 		  size_t tlen, bool ascii);
+
+static inline bool is_mdha(u32 algtype)
+{
+	return (algtype & OP_ALG_ALGSEL_MASK & ~OP_ALG_ALGSEL_SUBMASK) ==
+	       OP_ALG_CHA_MDHA;
+}
 #endif /* CAAM_ERROR_H */
-- 
2.16.2
