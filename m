Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E5F3A7D6F
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959366; cv=none; b=TCzqqDENeGJlMB7aVXzdSrUT6MWUdvzvuz01EdLMSqH7L1+WLTp6+PK4P5ER9SOUsl1jqE17y62k/0Ocu/Xma2AbyyiCNZWCbOwdmYZeTE0QIMDv+Ji4+lGgYEY3vmVmR7XupI19m7sLfkXOOgGRBl5HUzO9JEh3IUf4PtT6hy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959366; c=relaxed/simple;
	bh=AbMNTsWT4ICFxe5P1QMFr0o1DAujs2qHoBfkOxpDHAw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ey8p+i/72tI2JpfQIOu8ksYpBwCNgLkTXV9gc8xtAl/20we6JqVark9S9QMX3N2ZXcv6pHmMMhEyzzvUV82QsHCujEVZRPqI1lSt0QedtaODayuXicQBJXe2MZWZlKWITZynU12jUWPOpGTdwcn05SeaCdj7u6VuMHAnr7R4qog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=npRCGhuC; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="npRCGhuC"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 49B6FC62448;
	Thu, 28 May 2026 09:09:21 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2368660495;
	Thu, 28 May 2026 09:09:21 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B21521088877F;
	Thu, 28 May 2026 11:09:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959360; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=8K8qqwYMLYf2wBsVGqxOFMAz9CzVbdicwsuOzEDro/E=;
	b=npRCGhuCDyEMcgRikxQFW23kIBgPuQmo87BgbexiItD80wyUCCHGstL1BkK2xMWjYcjHUp
	650XL1+tgeUrbtiC1dy4+nMW9hLiTBRUS3BSrIK7pNg6p6R5xHOAkIgh/iEbSicIsTeb5C
	CB6Jc7tVuieGUk8UMzjKN7wce+ET/xpvK/Ku/PJRAWwOdrL6se+LIPWQ1pQ8hn5+8gxzfJ
	1+zMgqqbI7PmphepSONXfqdnhlPV8Yi67QLa3EhQMN8KuTj2O/f5bBWJR9uGA59Cpsc69A
	l4qWn0xHJl5dVdchpkGaItey0LqLYpei7vxj1OS6m6nkB9rHyBbS7TYWFVYZnA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:15 +0200
Subject: [PATCH 02/29] crypto: talitos - Move driver into dedicated
 directory
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-2-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=4762;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=AbMNTsWT4ICFxe5P1QMFr0o1DAujs2qHoBfkOxpDHAw=;
 b=nDgIywDweM6iyeGKWYCAPMxXezcxDuWNTnyYz4iX8GNew1XoACIhwUw/3zyff2jLjK8kzCzUT
 x+gRwxhAbLiDzbUzLU1RXFDb13EILTYQGsx1sCyUT7G0h7ywdHLghjB
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the talitos driver files from drivers/crypto/ into
drivers/crypto/talitos/ to accommodate upcoming code
reorganization.

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
index d23b58b81ca3..783b5dc42a42 100644
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
index 283bbc650b5b..a059139d4a75 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -35,7 +35,7 @@ obj-$(CONFIG_CRYPTO_DEV_SA2UL) += sa2ul.o
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
2.54.0

