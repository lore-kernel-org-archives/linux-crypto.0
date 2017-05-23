From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
Subject: [PATCH] drivers: staging: ccree: ISO C forbids casting to and from non-scalar
Date: Tue, 23 May 2017 20:53:14 +0200
Message-ID: <f83a37c8226318f8051ec2be5ba8172caf7ce573.1495565594.git.raphael.beamonte@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33504 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762718AbdEWSxa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 14:53:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes the following sparse warnings:
drivers/staging/ccree/ssi_hash.c:2447:24: warning: cast to non-scalar
drivers/staging/ccree/ssi_hash.c:2447:24: warning: cast from non-scalar
drivers/staging/ccree/ssi_hash.c:2448:28: warning: cast to non-scalar
drivers/staging/ccree/ssi_hash.c:2448:28: warning: cast from non-scalar

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/ccree/ssi_hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 162d17dee2cd..8585f73161b3 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2444,8 +2444,8 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 
 		/* register hmac version */
 
-		if ((((struct ssi_hash_template)driver_hash[alg]).hw_mode != DRV_CIPHER_XCBC_MAC) &&
-			(((struct ssi_hash_template)driver_hash[alg]).hw_mode != DRV_CIPHER_CMAC)) {
+		if ((((struct ssi_hash_template *)&driver_hash[alg])->hw_mode != DRV_CIPHER_XCBC_MAC) &&
+		    (((struct ssi_hash_template *)&driver_hash[alg])->hw_mode != DRV_CIPHER_CMAC)) {
 			t_alg = ssi_hash_create_alg(&driver_hash[alg], true);
 			if (IS_ERR(t_alg)) {
 				rc = PTR_ERR(t_alg);
-- 
2.11.0
