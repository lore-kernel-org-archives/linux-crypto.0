From: Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 3/3] crypto: ux500: Fix module autoload for OF platform
 drivers
Date: Fri, 28 Aug 2015 18:44:49 +0200
Message-ID: <20150828164449.GA5134@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wolfram Sang <wsa@the-dreams.de>,
	Vinod Koul <vinod.koul@intel.com>,
	Asaf Vertz <asaf.vertz@tandemg.com>,
	Cristian Stoica <cristian.stoica@freescale.com>,
	Kees Cook <keescook@chromium.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	linux-crypto@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36769 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbH1Qov (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 12:44:51 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These platform drivers have a OF device ID table but the OF module
alias information is not created so module autoloading won't work.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 1 +
 drivers/crypto/ux500/hash/hash_core.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index fded0a5..00f97d9 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1777,6 +1777,7 @@ static const struct of_device_id ux500_cryp_match[] = {
 	{ .compatible = "stericsson,ux500-cryp" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ux500_cryp_match);
 
 static struct platform_driver cryp_driver = {
 	.probe  = ux500_cryp_probe,
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 5f5f360..e02bd00 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1958,6 +1958,7 @@ static const struct of_device_id ux500_hash_match[] = {
 	{ .compatible = "stericsson,ux500-hash" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ux500_hash_match);
 
 static struct platform_driver hash_driver = {
 	.probe  = ux500_hash_probe,
-- 
2.4.6
