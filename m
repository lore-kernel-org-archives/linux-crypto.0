Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF00F250BF3
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 12:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742387511; cv=none; b=aPpa/jrmVm7ZE/MwKHgNSQf5oPSAUYffFlk81V9UMmaQW1kcz188GbWGIQlyPXH5HunDoqmNYZXPSr2EZ6ldvuroF+uoP/+dAHZct2jSBWR3ClLuFZ/s3sl91GwiFMxkrQS6seaNwp8hAKR4RyUrNV1YBdUhopsZ6i+akQpBfaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742387511; c=relaxed/simple;
	bh=MV48cB5YjFGKl8kYoMa/0IgxQuXGAZEKDDRndTCfuDc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=hktJ2jBqEstgxge7BcK/INMDgtfP5PXZm9ito1LVASGRNDGo6/TIc9vfKwfUe9w7QOimfwj/6tuMBDXkRpe8Q32dY+Qk6feFFiqwTcvSRtOgh/7tTwESO7JdPggFHliPu6NPXBG7euuXA8pTWnroMBW6CwMJLTDdsPfx3MeqmoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LLDKwTqT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LLDKwTqT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6YO+hXcD18yklrlq64Yr48L9RIc9Z+yyoYuzs0oI5kY=; b=LLDKwTqTXfmXfLrh8m+4uOG1QX
	zVbabAFsG+Oy8vsXJKgACdLu+O4PrM84poXDqChS2/q1DrJFdzObPt4v+83tCP50eKXY51rI33ZgP
	OAyMLWFa2/yOahtKOWH+n/kDb9bAz7FOZuOlfRH2fhkBZz+VjhTh0EGIJX5f7JuD6hceYeFe8Fy6/
	Ne5lWNA9lpdovOma2kauUW07w0fTl3NZBabBBXi20iAVNXi8ifx6oUprENfuiUSvLGySnrHANu0wD
	Or7qBtUIrb2CljTIoncfdWuFbDX1f8mqnbPfx73HlJgs6rI9tf4KebMQMdSDSwwElGlJyBJTV+Lmn
	YVPmY80g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tusaG-008Q0f-2W;
	Wed, 19 Mar 2025 20:31:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 20:31:44 +0800
Date: Wed, 19 Mar 2025 20:31:44 +0800
Message-Id: <44f07fa446b50fd8960a4e873625960ac0c4a0b0.1742387288.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742387288.git.herbert@gondor.apana.org.au>
References: <cover.1742387288.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: cavium - Move cpt and nitrox rules into cavium
 Makefile
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Move the cpt and nitrox rules into the cavium Makefile.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/Makefile        | 4 +---
 drivers/crypto/cavium/Makefile | 2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index c97f0ebc55ec..22eadcc8f4a2 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -8,12 +8,9 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_I2C) += atmel-i2c.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA204A) += atmel-sha204a.o
-obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_CCREE) += ccree/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
-obj-$(CONFIG_CRYPTO_DEV_CPT) += cavium/cpt/
-obj-$(CONFIG_CRYPTO_DEV_NITROX) += cavium/nitrox/
 obj-$(CONFIG_CRYPTO_DEV_EXYNOS_RNG) += exynos-rng.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON) += caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
@@ -50,3 +47,4 @@ obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
 obj-y += starfive/
+obj-y += cavium/
diff --git a/drivers/crypto/cavium/Makefile b/drivers/crypto/cavium/Makefile
index 4679c06b611f..6c1297426376 100644
--- a/drivers/crypto/cavium/Makefile
+++ b/drivers/crypto/cavium/Makefile
@@ -2,4 +2,6 @@
 #
 # Makefile for Cavium crypto device drivers
 #
+obj-$(CONFIG_CRYPTO_DEV_CPT) += cpt/
+obj-$(CONFIG_CRYPTO_DEV_NITROX) += nitrox/
 obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += zip/
-- 
2.39.5

