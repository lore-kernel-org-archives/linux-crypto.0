Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A6FC432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 03:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B06120B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 03:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574306460;
	bh=zUywFnJCQodUArh350d7rTnxwf/fRS9fF+rpssAclRs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Yb0JcqqvVD9teRCKP3a+7jI8umYGGeTQP3moYKYI20oOPUNebE0fVd+Lc5q9NmpOb
	 Qidt83ADc5ZXtG0lZq0ryxcoycXpVrLaPzCj5CBQUk2YDD75qL065dUev8w7kKEdyk
	 witFhQ51YIAFiFCT4kHEXcgJPjS7U7il33mA6Zb0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfKUDUy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 22:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbfKUDUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 22:20:54 -0500
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E56208A3;
        Thu, 21 Nov 2019 03:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574306453;
        bh=zUywFnJCQodUArh350d7rTnxwf/fRS9fF+rpssAclRs=;
        h=From:To:Cc:Subject:Date:From;
        b=hffyNBXZEouEob19K6kTnV6YzQmnyEFBGSAOx3uxZ87bjhYFTt7MY69yOiamNZVCH
         2Cmbr5PezJJ+cqxxItpjJbQEIjeV+ccG2O331ApyrQ3g2/4UjnlWq8cp8+2RYR8+Ve
         LIAN3EtsjUSp/muyGHo/spzGMo7nE/KNnb8rHTU4=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] crypto: Fix Kconfig indentation
Date:   Thu, 21 Nov 2019 04:20:48 +0100
Message-Id: <1574306448-31868-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

---

Changes since v1:
1. Fix also 7-space and tab+1 space indentation issues.
---
 drivers/crypto/Kconfig         | 22 +++++++++++-----------
 drivers/crypto/caam/Kconfig    | 14 +++++++-------
 drivers/crypto/chelsio/Kconfig | 30 +++++++++++++++---------------
 drivers/crypto/stm32/Kconfig   |  6 +++---
 drivers/crypto/ux500/Kconfig   | 16 ++++++++--------
 5 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 581021fab462..1a3f0779862c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -248,15 +248,15 @@ config CRYPTO_DEV_MARVELL_CESA
 	  This driver supports CPU offload through DMA transfers.
 
 config CRYPTO_DEV_NIAGARA2
-       tristate "Niagara2 Stream Processing Unit driver"
-       select CRYPTO_LIB_DES
-       select CRYPTO_SKCIPHER
-       select CRYPTO_HASH
-       select CRYPTO_MD5
-       select CRYPTO_SHA1
-       select CRYPTO_SHA256
-       depends on SPARC64
-       help
+	tristate "Niagara2 Stream Processing Unit driver"
+	select CRYPTO_LIB_DES
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	depends on SPARC64
+	help
 	  Each core of a Niagara2 processor contains a Stream
 	  Processing Unit, which itself contains several cryptographic
 	  sub-units.  One set provides the Modular Arithmetic Unit,
@@ -356,7 +356,7 @@ config CRYPTO_DEV_OMAP
 	depends on ARCH_OMAP2PLUS
 	help
 	  OMAP processors have various crypto HW accelerators. Select this if
-          you want to use the OMAP modules for any of the crypto algorithms.
+	  you want to use the OMAP modules for any of the crypto algorithms.
 
 if CRYPTO_DEV_OMAP
 
@@ -638,7 +638,7 @@ config CRYPTO_DEV_QCOM_RNG
 	  Generator hardware found on Qualcomm SoCs.
 
 	  To compile this driver as a module, choose M here. The
-          module will be called qcom-rng. If unsure, say N.
+	  module will be called qcom-rng. If unsure, say N.
 
 config CRYPTO_DEV_VMX
 	bool "Support for VMX cryptographic acceleration instructions"
diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 87053e46c788..fac5b2e26610 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -130,13 +130,13 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API
 	  scatterlist crypto API to the SEC4 via job ring.
 
 config CRYPTO_DEV_FSL_CAAM_PKC_API
-        bool "Register public key cryptography implementations with Crypto API"
-        default y
-        select CRYPTO_RSA
-        help
-          Selecting this will allow SEC Public key support for RSA.
-          Supported cryptographic primitives: encryption, decryption,
-          signature and verification.
+	bool "Register public key cryptography implementations with Crypto API"
+	default y
+	select CRYPTO_RSA
+	help
+	  Selecting this will allow SEC Public key support for RSA.
+	  Supported cryptographic primitives: encryption, decryption,
+	  signature and verification.
 
 config CRYPTO_DEV_FSL_CAAM_RNG_API
 	bool "Register caam device for hwrng API"
diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 91e424378217..f078b2686418 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -23,22 +23,22 @@ config CRYPTO_DEV_CHELSIO
 	  will be called chcr.
 
 config CHELSIO_IPSEC_INLINE
-        bool "Chelsio IPSec XFRM Tx crypto offload"
-        depends on CHELSIO_T4
+	bool "Chelsio IPSec XFRM Tx crypto offload"
+	depends on CHELSIO_T4
 	depends on CRYPTO_DEV_CHELSIO
-        depends on XFRM_OFFLOAD
-        depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
-        default n
-        ---help---
-          Enable support for IPSec Tx Inline.
+	depends on XFRM_OFFLOAD
+	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
+	default n
+	---help---
+	  Enable support for IPSec Tx Inline.
 
 config CRYPTO_DEV_CHELSIO_TLS
-        tristate "Chelsio Crypto Inline TLS Driver"
-        depends on CHELSIO_T4
-        depends on TLS_TOE
-        select CRYPTO_DEV_CHELSIO
-        ---help---
-          Support Chelsio Inline TLS with Chelsio crypto accelerator.
+	tristate "Chelsio Crypto Inline TLS Driver"
+	depends on CHELSIO_T4
+	depends on TLS_TOE
+	select CRYPTO_DEV_CHELSIO
+	---help---
+	  Support Chelsio Inline TLS with Chelsio crypto accelerator.
 
-          To compile this driver as a module, choose M here: the module
-          will be called chtls.
+	  To compile this driver as a module, choose M here: the module
+	  will be called chtls.
diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 1aba9372cd23..4ef3eb11361c 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -4,7 +4,7 @@ config CRYPTO_DEV_STM32_CRC
 	depends on ARCH_STM32
 	select CRYPTO_HASH
 	help
-          This enables support for the CRC32 hw accelerator which can be found
+	  This enables support for the CRC32 hw accelerator which can be found
 	  on STMicroelectronics STM32 SOC.
 
 config CRYPTO_DEV_STM32_HASH
@@ -17,7 +17,7 @@ config CRYPTO_DEV_STM32_HASH
 	select CRYPTO_SHA256
 	select CRYPTO_ENGINE
 	help
-          This enables support for the HASH hw accelerator which can be found
+	  This enables support for the HASH hw accelerator which can be found
 	  on STMicroelectronics STM32 SOC.
 
 config CRYPTO_DEV_STM32_CRYP
@@ -27,5 +27,5 @@ config CRYPTO_DEV_STM32_CRYP
 	select CRYPTO_ENGINE
 	select CRYPTO_LIB_DES
 	help
-          This enables support for the CRYP (AES/DES/TDES) hw accelerator which
+	  This enables support for the CRYP (AES/DES/TDES) hw accelerator which
 	  can be found on STMicroelectronics STM32 SOC.
diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
index b731895aa241..f56d65c56ccf 100644
--- a/drivers/crypto/ux500/Kconfig
+++ b/drivers/crypto/ux500/Kconfig
@@ -11,18 +11,18 @@ config CRYPTO_DEV_UX500_CRYP
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	help
-        This selects the crypto driver for the UX500_CRYP hardware. It supports
-        AES-ECB, CBC and CTR with keys sizes of 128, 192 and 256 bit sizes.
+	This selects the crypto driver for the UX500_CRYP hardware. It supports
+	AES-ECB, CBC and CTR with keys sizes of 128, 192 and 256 bit sizes.
 
 config CRYPTO_DEV_UX500_HASH
-        tristate "UX500 crypto driver for HASH block"
-        depends on CRYPTO_DEV_UX500
-        select CRYPTO_HASH
+	tristate "UX500 crypto driver for HASH block"
+	depends on CRYPTO_DEV_UX500
+	select CRYPTO_HASH
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
-        help
-          This selects the hash driver for the UX500_HASH hardware.
-          Depends on UX500/STM DMA if running in DMA mode.
+	help
+	  This selects the hash driver for the UX500_HASH hardware.
+	  Depends on UX500/STM DMA if running in DMA mode.
 
 config CRYPTO_DEV_UX500_DEBUG
 	bool "Activate ux500 platform debug-mode for crypto and hash block"
-- 
2.7.4

