From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Date: Fri, 13 Oct 2017 15:01:23 +0300
Message-ID: <20171013120123.13028-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dan steps down as caam maintainer, being replaced by Aymen.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 92df4e80a170..bb3016c2c342 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5457,7 +5457,7 @@ F:	include/uapi/linux/fb.h
 
 FREESCALE CAAM (Cryptographic Acceleration and Assurance Module) DRIVER
 M:	Horia Geantă <horia.geanta@nxp.com>
-M:	Dan Douglass <dan.douglass@nxp.com>
+M:	Aymen Sghaier <aymen.sghaier@nxp.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/caam/
-- 
2.12.0.264.gd6db3f216544
