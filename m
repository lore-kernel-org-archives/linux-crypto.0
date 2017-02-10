From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 01/12] crypto: caam - don't include unneeded headers
Date: Fri, 10 Feb 2017 14:07:14 +0200
Message-ID: <1486728445-13047-2-git-send-email-horia.geanta@nxp.com>
References: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "Cristian Stoica" <cristian.stoica@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0080.outbound.protection.outlook.com ([104.47.34.80]:27311
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752700AbdBJMHs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:07:48 -0500
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

intern.h, jr.h are not needed in error.c
error.h is not needed in ctrl.c

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c  | 1 -
 drivers/crypto/caam/error.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 755109841cfd..8957ec952212 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -13,7 +13,6 @@
 #include "intern.h"
 #include "jr.h"
 #include "desc_constr.h"
-#include "error.h"
 #include "ctrl.h"
 
 bool caam_little_end;
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 79a0cc70717f..6f44ccb55c63 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -6,9 +6,7 @@
 
 #include "compat.h"
 #include "regs.h"
-#include "intern.h"
 #include "desc.h"
-#include "jr.h"
 #include "error.h"
 
 static const struct {
-- 
2.4.4
