From: Elad Wexler <elad.wexler@gmail.com>
Subject: [PATCH] staging: ccree: ssi_hash: remove unnecessary parentheses
Date: Thu, 28 Dec 2017 12:24:17 +0200
Message-ID: <20171228102417.GA10407@ewexler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44421 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753337AbdL1KYW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Dec 2017 05:24:22 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed a coding style issue

Signed-off-by: Elad Wexler <elad.wexler@gmail.com>
---
 drivers/staging/ccree/ssi_hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 2035835..8d56fa7 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2280,8 +2280,8 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 				      &hash_handle->hash_list);
 		}
 
-		if ((hw_mode == DRV_CIPHER_XCBC_MAC) ||
-		    (hw_mode == DRV_CIPHER_CMAC))
+		if (hw_mode == DRV_CIPHER_XCBC_MAC ||
+		    hw_mode == DRV_CIPHER_CMAC)
 			continue;
 
 		/* register hash version */
-- 
2.7.4
