Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D676135DA77
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 10:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779014088; cv=none; b=fidp3zMKeQF87UZUOk/mGoLm8AciF+nDGOcYeB+y2zORCp5w1U/TiwLgsMM9/6LZqwszPOf3IaK3EMlCMjM4uRm6yTXgXyEjtjHtc+g45XwoUapulyrTsPkK05092Ck7p+uHMlUVaAfzsOiLzjnSy9WVETPCxVnIIOo//aHiR6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779014088; c=relaxed/simple;
	bh=1CQJATp04Q4lWZlO39TsHoiOlzSL6fU/lReo5/XLKYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dH/Wc3KCE4ZEgX9GJu90WDf4ObHUGVCJ+l2oAp3jG6UhQuHihcBwUSNCMEBPrRmFaIDIPuPvmdK7b1jhuMQ4A5+ohvXh3Q1E5w/1Ntlh1nMvRtRYaSBL4N4SfJm4ptkTel7B416JqtHPZwnG7oEBjTy1shuiNGHH8JgndL5SxXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nTWPlt6C; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nTWPlt6C"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779014074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rNotXEKNeCxpp1TMfj1zvIDq71Q5LRxNXB2EkHY39Fk=;
	b=nTWPlt6CHa9m5IhN0pHIFKJuS82yVEM5vho4psZcRuwmYyUrKDcptO6BkSuCZs1l6Zabel
	MxtwLrNpnThKkiUbXYrthpIcVa8lvKYyhnhwRVGJb8hPAQrZ/Wrd/37swVLQyhsyVjR4ri
	I1abASAVbZyKzO+lZiHvh0LaPA5dTv8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: omap-des - add COMPILE_TEST and fix CONFIG_OF=n build
Date: Sun, 17 May 2026 12:34:14 +0200
Message-ID: <20260517103414.1135537-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2578; i=thorsten.blum@linux.dev; h=from:subject; bh=1CQJATp04Q4lWZlO39TsHoiOlzSL6fU/lReo5/XLKYU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmcM5dN1PBTW/jG3f7Fw03HThc23jjI+Mri9o1556fPu K2vdO27bkcpC4MYF4OsmCLLg1k/ZviW1lRuMonYCTOHlQlkCAMXpwBMhCODkaHh4MTZF4PM+w0D NMsFl8z+fXH29S215TXWrbPfNc7ji9FiZLipL1UgziX/n6O4ea3kpev5nELOLAb96yuyLPiY/Na 38wMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

CRYPTO_DEV_OMAP_DES only depends on ARCH_OMAP2PLUS, which is ARM-only
and selects OF via ARM's USE_OF, making any non-OF code unreachable.

Add COMPILE_TEST so the driver can be built with CONFIG_OF=n, making the
non-OF code reachable.

Fix the resulting non-OF build failures:

- omap_des_irq() was defined inside a CONFIG_OF block, but is referenced
  unconditionally from omap_des_probe(). Move the CONFIG_OF guard so it
  only covers omap_des_get_of().

- The non-OF omap_des_get_of() stub took a struct device *, while
  omap_des_probe() passes a struct platform_device *. Make the stub
  prototype match the OF implementation and the caller.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/Kconfig    | 4 ++--
 drivers/crypto/omap-des.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d23b58b81ca3..3449b3c9c6ad 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -316,7 +316,7 @@ config HW_RANDOM_PPC4XX
 
 config CRYPTO_DEV_OMAP
 	tristate "Support for OMAP crypto HW accelerators"
-	depends on ARCH_OMAP2PLUS
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  OMAP processors have various crypto HW accelerators. Select this if
 	  you want to use the OMAP modules for any of the crypto algorithms.
@@ -352,7 +352,7 @@ config CRYPTO_DEV_OMAP_AES
 
 config CRYPTO_DEV_OMAP_DES
 	tristate "Support for OMAP DES/3DES hw engine"
-	depends on ARCH_OMAP2PLUS
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	select CRYPTO_LIB_DES
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 149ebd77710b..4eb45b2988c3 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -800,7 +800,6 @@ static struct omap_des_algs_info omap_des_algs_info_ecb_cbc[] = {
 	},
 };
 
-#ifdef CONFIG_OF
 static const struct omap_des_pdata omap_des_pdata_omap4 = {
 	.algs_info	= omap_des_algs_info_ecb_cbc,
 	.algs_info_size	= ARRAY_SIZE(omap_des_algs_info_ecb_cbc),
@@ -909,6 +908,7 @@ static const struct of_device_id omap_des_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, omap_des_of_match);
 
+#ifdef CONFIG_OF
 static int omap_des_get_of(struct omap_des_dev *dd,
 		struct platform_device *pdev)
 {
@@ -923,7 +923,7 @@ static int omap_des_get_of(struct omap_des_dev *dd,
 }
 #else
 static int omap_des_get_of(struct omap_des_dev *dd,
-		struct device *dev)
+		struct platform_device *pdev)
 {
 	return -EINVAL;
 }
