From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 08/13] crypto: caam/qi - remove unused header sg_sw_sec4.h
Date: Mon, 10 Jul 2017 08:40:34 +0300
Message-ID: <20170710054039.21555-9-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
 <20170710054039.21555-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0080.outbound.protection.outlook.com ([104.47.38.80]:5024
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751224AbdGJFlW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 01:41:22 -0400
In-Reply-To: <20170710054039.21555-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sg_sw_sec4.h header is not used by caam/qi, thus remove its inclusion.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 82e9f93f5071..2a6114572304 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -12,7 +12,6 @@
 #include "intern.h"
 #include "desc_constr.h"
 #include "error.h"
-#include "sg_sw_sec4.h"
 #include "sg_sw_qm.h"
 #include "key_gen.h"
 #include "qi.h"
-- 
2.12.0.264.gd6db3f216544
