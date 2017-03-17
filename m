From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 5/7] crypto: caam - avoid double inclusion in desc_constr.h
Date: Fri, 17 Mar 2017 12:06:00 +0200
Message-ID: <20170317100602.2837-6-horia.geanta@nxp.com>
References: <20170317100602.2837-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0040.outbound.protection.outlook.com ([104.47.32.40]:22796
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbdCQKGo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 06:06:44 -0400
In-Reply-To: <20170317100602.2837-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/desc_constr.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index b9c8d98ef826..d8e83ca104e0 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -4,6 +4,9 @@
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
  */
 
+#ifndef DESC_CONSTR_H
+#define DESC_CONSTR_H
+
 #include "desc.h"
 #include "regs.h"
 
@@ -491,3 +494,5 @@ static inline int desc_inline_query(unsigned int sd_base_len,
 
 	return (rem_bytes >= 0) ? 0 : -1;
 }
+
+#endif /* DESC_CONSTR_H */
-- 
2.12.0.264.gd6db3f216544
