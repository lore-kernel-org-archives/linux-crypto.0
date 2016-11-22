From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 10/10] MAINTAINERS: add maintainers for caam crypto driver
Date: Tue, 22 Nov 2016 15:44:12 +0200
Message-ID: <1479822252-23833-11-git-send-email-horia.geanta@nxp.com>
References: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0073.outbound.protection.outlook.com ([104.47.34.73]:47840
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933252AbcKVOAW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 09:00:22 -0500
In-Reply-To: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add myself and Dan as maintainers of the caam crypto driver.

Cc: Dan Douglass <dan.douglass@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1cd38a7e0064..e28aab4d525a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4972,6 +4972,14 @@ F:	include/linux/fb.h
 F:	include/uapi/video/
 F:	include/uapi/linux/fb.h
 
+FREESCALE CAAM (Cryptographic Acceleration and Assurance Module) DRIVER
+M:	Horia Geantă <horia.geanta@nxp.com>
+M:	Dan Douglass <dan.douglass@nxp.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/caam/
+F:	Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+
 FREESCALE DIU FRAMEBUFFER DRIVER
 M:	Timur Tabi <timur@tabi.org>
 L:	linux-fbdev@vger.kernel.org
-- 
2.4.4
