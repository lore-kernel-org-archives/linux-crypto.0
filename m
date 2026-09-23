Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF295304C8
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176762; cv=none; b=Ys3vgeOIul1acOwb2BKbH0L2ZD9P6i6n9SDxoQ1NVf1HXgZC/xKnk7Y1I824qaEvpk1Huykt2OSKK+nPZhQFA855i34oRQg31NxN2xRmNF3qU1vvdlFCTZU0SCo0wmDjtCNJSIDuc29Yc3r5yRusuC/aHGNc/M7ofeiNy+fm2XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176762; c=relaxed/simple;
	bh=V2njShitigGLUuZBEVexmM3QyTjSvcUFwuqSqwbW5vw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JYizPhRaEV8gtZRomLHRLLe2Q3w9jsXVnEdIyvlTUdVHS4xIyvS0gKEgjr27u/mwf+7VEzLEiO8uGiWLF8k/b/lkMB6imxseI/ny3TA7x+rJuqJI8U6p+W27xq5aaKQ3OxNyeGwVKNQw63o1O3y4eqie1TQz7P5TxbKvGfLZuZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=zrc3/9Gw; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="zrc3/9Gw"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 5D2C51A0FE8
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 15:19:19 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2A4A860580;
	Wed, 23 Sep 2026 15:19:19 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 64BD5103293D7;
	Wed, 23 Sep 2026 17:19:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790176757; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=L3miw9rDYFcpZUL3Fj8+pV42jq0wLlqwfAjnEEVvAO8=;
	b=zrc3/9GwB8v2uE8NF6RECdyPKzFkpzP7C5bGkz22wongYJ0J6kaa5d36J4QJeYkFNxhZND
	/Z6vLZs/lNWDIlCKDG+q8Tc4NKBonp2OJUfCiZfjtg5mqhy2CqORL75HcU8oYYcxtyXLFs
	Or86hfFwMzjjch7Mio0egryxwLGUmkHhQ1rcNhPgm00MC6fWVcKU6pZfzok5P4MPGwE9Le
	RtKTzAqp/6WLp1Vu6+G3OIHMoaHI0n4Yvyfn5LWgLTDsxV8A1c6ZCxhEDow2uCCll4b/U+
	ySMG558hKbeJcY0r2smRuDM46KWljAOlOsR7fdNO29rAxhyF8j2JTwm8eHyLCQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 23 Sep 2026 17:18:38 +0200
Subject: [PATCH v7 02/20] crypto: talitos - Move driver into dedicated
 directory
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-7-3-rc2_talitos_cleanup-v7-2-9a45261fc097@bootlin.com>
References: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
In-Reply-To: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790176746; l=4919;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=V2njShitigGLUuZBEVexmM3QyTjSvcUFwuqSqwbW5vw=;
 b=rhLzS9Cef3OP4d3+wmoV+zP6Jwl3wq19nYVy/3L1ZMA/OxUr/EsJBKt1lqMmTpGgg1wNlmtL4
 8RiJyHOUz20Bph6aJAHwGcMly92bSugmY/oT1VJFJtJF8SMV6tHzgBM
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the talitos driver files from drivers/crypto/ into
drivers/crypto/talitos/ to accommodate upcoming code
reorganization.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/Kconfig                             | 38 +---------------------
 drivers/crypto/Makefile                            |  2 +-
 drivers/crypto/talitos/Kconfig                     | 36 ++++++++++++++++++++
 drivers/crypto/talitos/Makefile                    |  3 ++
 .../crypto/{talitos.c => talitos/talitos-core.c}   |  0
 drivers/crypto/{ => talitos}/talitos.h             |  0
 6 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0189dfdcbbe1..13f09805851c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -253,43 +253,7 @@ config CRYPTO_DEV_HIFN_795X_RNG
 	  on the HIFN 795x crypto adapters.
 
 source "drivers/crypto/caam/Kconfig"
-
-config CRYPTO_DEV_TALITOS
-	tristate "Talitos Freescale Security Engine (SEC)"
-	select CRYPTO_AEAD
-	select CRYPTO_AUTHENC
-	select CRYPTO_SKCIPHER
-	select CRYPTO_HASH
-	select CRYPTO_LIB_DES
-	select HW_RANDOM
-	depends on FSL_SOC
-	help
-	  Say 'Y' here to use the Freescale Security Engine (SEC)
-	  to offload cryptographic algorithm computation.
-
-	  The Freescale SEC is present on PowerQUICC 'E' processors, such
-	  as the MPC8349E and MPC8548E.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called talitos.
-
-config CRYPTO_DEV_TALITOS1
-	bool "SEC1 (SEC 1.0 and SEC Lite 1.2)"
-	depends on CRYPTO_DEV_TALITOS
-	depends on PPC_8xx || PPC_82xx
-	default y
-	help
-	  Say 'Y' here to use the Freescale Security Engine (SEC) version 1.0
-	  found on MPC82xx or the Freescale Security Engine (SEC Lite)
-	  version 1.2 found on MPC8xx
-
-config CRYPTO_DEV_TALITOS2
-	bool "SEC2+ (SEC version 2.0 or upper)"
-	depends on CRYPTO_DEV_TALITOS
-	default y if !PPC_8xx
-	help
-	  Say 'Y' here to use the Freescale Security Engine (SEC)
-	  version 2 and following as found on MPC83xx, MPC85xx, etc ...
+source "drivers/crypto/talitos/Kconfig"
 
 config CRYPTO_DEV_PPC4XX
 	tristate "Driver AMCC PPC4xx crypto accelerator"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 2c33b83f3cfa..e9522e94c20d 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_CRYPTO_DEV_SA2UL) += sa2ul.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_SL3516) += gemini/
 obj-y += stm32/
-obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
+obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos/
 obj-$(CONFIG_CRYPTO_DEV_TEGRA) += tegra/
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
diff --git a/drivers/crypto/talitos/Kconfig b/drivers/crypto/talitos/Kconfig
new file mode 100644
index 000000000000..c3470553a966
--- /dev/null
+++ b/drivers/crypto/talitos/Kconfig
@@ -0,0 +1,36 @@
+config CRYPTO_DEV_TALITOS
+	tristate "Talitos Freescale Security Engine (SEC)"
+	select CRYPTO_AEAD
+	select CRYPTO_AUTHENC
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_LIB_DES
+	select HW_RANDOM
+	depends on FSL_SOC
+	help
+	  Say 'Y' here to use the Freescale Security Engine (SEC)
+	  to offload cryptographic algorithm computation.
+
+	  The Freescale SEC is present on PowerQUICC 'E' processors, such
+	  as the MPC8349E and MPC8548E.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called talitos.
+
+config CRYPTO_DEV_TALITOS1
+	bool "SEC1 (SEC 1.0 and SEC Lite 1.2)"
+	depends on CRYPTO_DEV_TALITOS
+	depends on PPC_8xx || PPC_82xx
+	default y
+	help
+	  Say 'Y' here to use the Freescale Security Engine (SEC) version 1.0
+	  found on MPC82xx or the Freescale Security Engine (SEC Lite)
+	  version 1.2 found on MPC8xx
+
+config CRYPTO_DEV_TALITOS2
+	bool "SEC2+ (SEC version 2.0 or upper)"
+	depends on CRYPTO_DEV_TALITOS
+	default y if !PPC_8xx
+	help
+	  Say 'Y' here to use the Freescale Security Engine (SEC)
+	  version 2 and following as found on MPC83xx, MPC85xx, etc ...
diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
new file mode 100644
index 000000000000..98456167fe73
--- /dev/null
+++ b/drivers/crypto/talitos/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
+
+talitos-y += talitos-core.o
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos/talitos-core.c
similarity index 100%
rename from drivers/crypto/talitos.c
rename to drivers/crypto/talitos/talitos-core.c
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos/talitos.h
similarity index 100%
rename from drivers/crypto/talitos.h
rename to drivers/crypto/talitos/talitos.h

-- 
2.55.0

