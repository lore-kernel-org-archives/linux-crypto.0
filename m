Received: from cmccmta1.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B401176ADE;
	Wed, 11 Sep 2024 12:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726057113; cv=none; b=lSLVpZFoQHAEpvKKoZmYx5nHNbmmVIwchVpKSEhLH2iaH6y3DFQnhjJ+UM8Yt5sM4WRzMw2v9hsTKcelYwzYKTuZdzZcR6kTltxPQd9Bt0EJ4njKf1d/cUFt1imVcDhVVPjm+8xL0Xw5CnMp+6ghS1dvuMyesZkn8kKFV/mgAbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726057113; c=relaxed/simple;
	bh=ljw42LRKu+ZJIRB1/tfsHKyT2lWPm3ewsOyW3NThXnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aMBodalUAWocg1tDeF+zq/q79wNlRM7wweVgl7M7qUvxpPp3Ww79b8JHTPoGtrTbYO5mdVX3CXUs240fxwGErYvm7ofgAoENltwF29Xl2IH7h0FkbPK8WSR5FZ8kDYdHQq6fUkp/nNafUPFL4iSPRUUsDy/q/PDMhC/Utc0/FNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee466e18a8afc0-f08b6;
	Wed, 11 Sep 2024 20:18:20 +0800 (CST)
X-RM-TRANSID:2ee466e18a8afc0-f08b6
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee166e18a70e4f-cb9c7;
	Wed, 11 Sep 2024 20:18:19 +0800 (CST)
X-RM-TRANSID:2ee166e18a70e4f-cb9c7
From: Tang Bin <tangbin@cmss.chinamobile.com>
To: clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] crypto: amlogic - Remove redundant assignment and error messages
Date: Wed, 11 Sep 2024 20:17:51 +0800
Message-Id: <20240911121751.1900-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the function meson_crypto_probe, devm_platform_ioremap_resource()
have already contains error message, so remove the
redundant assignment and error messages.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index f54ab0d0b..6fe248620 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -240,11 +240,9 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, mc);
 
 	mc->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(mc->base)) {
-		err = PTR_ERR(mc->base);
-		dev_err(&pdev->dev, "Cannot request MMIO err=%d\n", err);
-		return err;
-	}
+	if (IS_ERR(mc->base))
+		return PTR_ERR(mc->base);
+
 	mc->busclk = devm_clk_get(&pdev->dev, "blkmv");
 	if (IS_ERR(mc->busclk)) {
 		err = PTR_ERR(mc->busclk);
-- 
2.33.0



