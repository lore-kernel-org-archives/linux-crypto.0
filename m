From: Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 1/2] char: hw_random: Fix module autoload for OF platform
 drivers
Date: Tue, 15 Sep 2015 18:41:33 +0200
Message-ID: <20150915164133.GA5642@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Olof Johansson <olof@lixom.net>, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Wolfram Sang <wsa@the-dreams.de>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36973 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbbIOQlg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 12:41:36 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This platform drivers have a OF device ID table but the OF module
alias information is not created so module autoloading won't work.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 drivers/char/hw_random/pasemi-rng.c | 1 +
 drivers/char/hw_random/ppc4xx-rng.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index 3eb7bdd..20d6564 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -138,6 +138,7 @@ static struct of_device_id rng_match[] = {
 	{ .compatible      = "pasemi,pwrficient-rng", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, rng_match);
 
 static struct platform_driver rng_driver = {
 	.driver = {
diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
index c85d31a..145e273 100644
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ b/drivers/char/hw_random/ppc4xx-rng.c
@@ -129,6 +129,7 @@ static struct of_device_id ppc4xx_rng_match[] = {
 	{ .compatible = "amcc,ppc440epx-rng", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ppc4xx_rng_match);
 
 static struct platform_driver ppc4xx_rng_driver = {
 	.driver = {
-- 
2.4.6
