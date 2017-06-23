From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH][crypto-next] crypto: cavium/nitrox - Change in firmware path.
Date: Fri, 23 Jun 2017 16:03:51 +0530
Message-ID: <20170623103351.7153-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sreerama.Gadam@cavium.com,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0066.outbound.protection.outlook.com ([104.47.42.66]:39618
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754510AbdFWKed (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 06:34:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Moved the firmware to "cavium" subdirectory as suggested by
Kyle McMartin.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index ae44a46..9ccefb9 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -18,8 +18,9 @@
 #define SE_GROUP 0
 
 #define DRIVER_VERSION "1.0"
+#define FW_DIR "cavium/"
 /* SE microcode */
-#define SE_FW	"cnn55xx_se.fw"
+#define SE_FW	FW_DIR "cnn55xx_se.fw"
 
 static const char nitrox_driver_name[] = "CNN55XX";
 
-- 
2.9.4
