From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 12/14] staging: ccree: remove unused type CCFipsSyncStatus_t
Date: Tue, 27 Jun 2017 10:27:24 +0300
Message-ID: <1498548449-10803-13-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52524 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752550AbdF0H2n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 03:28:43 -0400
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCFipsSyncStatus_t type was not being used in the code.
Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_fips_local.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_local.h b/drivers/staging/ccree/ssi_fips_local.h
index 0fbb1e0..4bc7f37 100644
--- a/drivers/staging/ccree/ssi_fips_local.h
+++ b/drivers/staging/ccree/ssi_fips_local.h
@@ -23,16 +23,6 @@
 #include "ssi_fips.h"
 struct ssi_drvdata;
 
-// IG - how to make 1 file for TEE and REE
-typedef enum CC_FipsSyncStatus {
-	CC_FIPS_SYNC_MODULE_OK		= 0x0,
-	CC_FIPS_SYNC_MODULE_ERROR	= 0x1,
-	CC_FIPS_SYNC_REE_STATUS		= 0x4,
-	CC_FIPS_SYNC_TEE_STATUS		= 0x8,
-	CC_FIPS_SYNC_STATUS_RESERVE32B	= S32_MAX
-} CCFipsSyncStatus_t;
-
-
 #define CHECK_AND_RETURN_UPON_FIPS_ERROR() {\
 	if (ssi_fips_check_fips_error() != 0) {\
 		return -ENOEXEC;\
-- 
2.1.4
