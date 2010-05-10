From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 1/1] omap-sham: OMAP macros corrected
Date: Mon, 10 May 2010 15:07:55 +0300
Message-ID: <948fcc79dd3d31f4930d4b62bb7ca7a19949fd9a.1273493232.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 arch/arm/mach-omap2/devices.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index beac46c..79dbf04 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -456,7 +456,7 @@ static inline void omap_init_mcspi(void) {}
 
 #if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
 
-#ifdef CONFIG_ARCH_OMAP24XX
+#ifdef CONFIG_ARCH_OMAP2
 static struct resource omap2_sham_resources[] = {
 	{
 		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
@@ -474,7 +474,7 @@ static int omap2_sham_resources_sz = ARRAY_SIZE(omap2_sham_resources);
 #define omap2_sham_resources_sz		0
 #endif
 
-#ifdef CONFIG_ARCH_OMAP34XX
+#ifdef CONFIG_ARCH_OMAP3
 static struct resource omap3_sham_resources[] = {
 	{
 		.start	= OMAP34XX_SEC_SHA1MD5_BASE,
-- 
1.7.0.4

