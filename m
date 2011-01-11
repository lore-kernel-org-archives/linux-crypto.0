From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH 02/16] crypto: omap-sham: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:39 +0000
Message-ID: <1294749833-32019-3-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/omap-sham.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a081c7c..1acfcd2 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1150,9 +1150,9 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 
 	/* Initializing the clock */
 	dd->iclk = clk_get(dev, "ick");
-	if (!dd->iclk) {
+	if (IS_ERR(dd->iclk)) {
 		dev_err(dev, "clock intialization failed.\n");
-		err = -ENODEV;
+		err = PTR_ERR(dd->iclk);
 		goto clk_err;
 	}
 
-- 
1.7.3.4
