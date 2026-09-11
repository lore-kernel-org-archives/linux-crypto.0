Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DD437FF60;
	Fri, 11 Sep 2026 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138042; cv=none; b=U+dKjQgNuwcmxWwnwnIw5OnDZTxBli4pGZUjZ1msTfh9PTF11NRogeHi2mguD/2m92j40SepH7s7iPJaXPAHvmnjpA3C8hE5KlgoQM+p0wlEPXJPAhbOxyDjYjM9YgmEHV2prns0CN/J43pPfGmo0dfUzl2oj6GOI3Ao3c3ckg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138042; c=relaxed/simple;
	bh=P3IOU6a17KAZYGEk9AJ/gWAl52i01uTn1V0fEemzht4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BVQ1d7oG+Zod3KYXvSLzwxuniAfcEdYM8yG189LxwiIp2+thaswd/NiBUfmpHt1D14qyIl0xIkBv6RkiOe6sVDJK64niOQziWBxiPY5eJaaYUQ3P5zTwcR+LlcPfv0+WYNvIGouj59rfeGk82AZ71SyBBKm3/yJORDc9kcaUi3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=UsoCNSve; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="UsoCNSve"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 8ABF51A01ED;
	Fri, 11 Sep 2026 14:47:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 60026601DE;
	Fri, 11 Sep 2026 14:47:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 415E911C7AFAD;
	Fri, 11 Sep 2026 16:47:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138037; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=XtIO13Iy4dZ0yEChy4kLQgZIMfs3njjlmL0xTtsIQS4=;
	b=UsoCNSve9xtbBdwlrO4UmwTsZzepAASDPvIE0qR+nEYFIsUjho1/pvCYbiLKqDyouHkA1f
	0tygUzMwX2S3j8BTv1Cn4Nrm03GlDeRtm71TNPBZ9s4kxGWLqSfCkwdzOSxppXHluQuv2+
	Huih5gaeil1t7gsPXwppbdjeAjcAc2KlmiCE+QadZalQWJavjIsdlCqMHhdVqpT8FbbHgE
	/zyCFHZWaHq/XMTL3cehrBnMUwPyyvzccm/hySqse6anzmcm/0HtSeEigCPwEtfU/8u+Ib
	Muz59RjaLVjULTzYdDDus4Y8rj9j1TdyEuzvxgRoGbVJYoUxlMawbytGObsDnw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:19 +0200
Subject: [PATCH v6 02/19] crypto: talitos - Move driver into dedicated
 directory
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-2-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=4825;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=P3IOU6a17KAZYGEk9AJ/gWAl52i01uTn1V0fEemzht4=;
 b=HKsTy4jD02m/MAWhsNYu3pd37K80dVVyC6cJM9dIgc2CkFcXhwRDLd66FZ1Bge/w8gHiWbEt2
 e7D9KGaHgpiDF0XdTiRAXC4yfecas6mW5jcJtTETkI3uatblx4qcAEi
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the talitos driver files from drivers/crypto/ into
drivers/crypto/talitos/ to accommodate upcoming code
reorganization.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/Kconfig                 | 38 +---------------------------------
 drivers/crypto/Makefile                |  2 +-
 drivers/crypto/talitos/Kconfig         | 36 ++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/Makefile        |  1 +
 drivers/crypto/{ => talitos}/talitos.c |  0
 drivers/crypto/{ => talitos}/talitos.h |  0
 6 files changed, 39 insertions(+), 38 deletions(-)

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
index 000000000000..fcc5db5e63c2
--- /dev/null
+++ b/drivers/crypto/talitos/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos/talitos.c
similarity index 100%
rename from drivers/crypto/talitos.c
rename to drivers/crypto/talitos/talitos.c
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos/talitos.h
similarity index 100%
rename from drivers/crypto/talitos.h
rename to drivers/crypto/talitos/talitos.h

-- 
2.55.0

