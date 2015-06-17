From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: crypto: drivers - Fix Kconfig selects
Date: Wed, 17 Jun 2015 14:58:24 +0800
Message-ID: <20150617065824.GA9679@gondor.apana.org.au>
References: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434448748-10828-5-git-send-email-boris.brezillon@free-electrons.com>
 <20150617055824.GA9155@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
	Imre Kaloz <kaloz-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150617055824.GA9155-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes a number of problems in crypto driver Kconfig
entries:

1. Select BLKCIPHER instead of BLKCIPHER2.  The latter is internal
and should not be used outside of the crypto API itself.
2. Do not select ALGAPI unless you use a legacy type like
CRYPTO_ALG_TYPE_CIPHER.
3. Select the algorithm type that you are implementing, e.g., AEAD.
4. Do not select generic C code such as CBC/ECB unless you use them
as a fallback.
5. Remove default n since that is the default default.

Signed-off-by: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
---

 drivers/crypto/Kconfig       |   41 +++++++++++++----------------------------
 drivers/crypto/caam/Kconfig  |    5 ++---
 drivers/crypto/ccp/Kconfig   |    1 -
 drivers/crypto/nx/Kconfig    |    8 --------
 drivers/crypto/qat/Kconfig   |    6 ++----
 drivers/crypto/ux500/Kconfig |    4 ++--
 6 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 92c899f..7a72797 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -162,9 +162,8 @@ config CRYPTO_GHASH_S390
 config CRYPTO_DEV_MV_CESA
 	tristate "Marvell's Cryptographic Engine"
 	depends on PLAT_ORION
-	select CRYPTO_ALGAPI
 	select CRYPTO_AES
-	select CRYPTO_BLKCIPHER2
+	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
@@ -176,7 +175,8 @@ config CRYPTO_DEV_MV_CESA
 config CRYPTO_DEV_NIAGARA2
        tristate "Niagara2 Stream Processing Unit driver"
        select CRYPTO_DES
-       select CRYPTO_ALGAPI
+       select CRYPTO_BLKCIPHER
+       select CRYPTO_HASH
        depends on SPARC64
        help
 	  Each core of a Niagara2 processor contains a Stream
@@ -189,7 +189,6 @@ config CRYPTO_DEV_NIAGARA2
 config CRYPTO_DEV_HIFN_795X
 	tristate "Driver HIFN 795x crypto accelerator chips"
 	select CRYPTO_DES
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	select HW_RANDOM if CRYPTO_DEV_HIFN_795X_RNG
 	depends on PCI
@@ -208,8 +207,10 @@ source drivers/crypto/caam/Kconfig
 
 config CRYPTO_DEV_TALITOS
 	tristate "Talitos Freescale Security Engine (SEC)"
-	select CRYPTO_ALGAPI
+	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_HASH
 	select HW_RANDOM
 	depends on FSL_SOC
 	help
@@ -244,7 +245,7 @@ config CRYPTO_DEV_IXP4XX
 	tristate "Driver for IXP4xx crypto hardware acceleration"
 	depends on ARCH_IXP4XX && IXP4XX_QMGR && IXP4XX_NPE
 	select CRYPTO_DES
-	select CRYPTO_ALGAPI
+	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	help
@@ -254,7 +255,6 @@ config CRYPTO_DEV_PPC4XX
 	tristate "Driver AMCC PPC4xx crypto accelerator"
 	depends on PPC && 4xx
 	select CRYPTO_HASH
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
@@ -275,7 +275,7 @@ config CRYPTO_DEV_OMAP_AES
 	tristate "Support for OMAP AES hw engine"
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || ARCH_OMAP2PLUS
 	select CRYPTO_AES
-	select CRYPTO_BLKCIPHER2
+	select CRYPTO_BLKCIPHER
 	help
 	  OMAP processors have AES module accelerator. Select this if you
 	  want to use the OMAP module for AES algorithms.
@@ -284,7 +284,7 @@ config CRYPTO_DEV_OMAP_DES
 	tristate "Support for OMAP DES3DES hw engine"
 	depends on ARCH_OMAP2PLUS
 	select CRYPTO_DES
-	select CRYPTO_BLKCIPHER2
+	select CRYPTO_BLKCIPHER
 	help
 	  OMAP processors have DES/3DES module accelerator. Select this if you
 	  want to use the OMAP module for DES and 3DES algorithms. Currently
@@ -294,9 +294,10 @@ config CRYPTO_DEV_OMAP_DES
 config CRYPTO_DEV_PICOXCELL
 	tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
 	depends on ARCH_PICOXCELL && HAVE_CLK
+	select CRYPTO_AEAD
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
-	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
 	select CRYPTO_CBC
 	select CRYPTO_ECB
@@ -322,7 +323,6 @@ config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS
 	select CRYPTO_AES
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
@@ -345,7 +345,6 @@ endif
 config CRYPTO_DEV_UX500
 	tristate "Driver for ST-Ericsson UX500 crypto hardware acceleration"
 	depends on ARCH_U8500
-	select CRYPTO_ALGAPI
 	help
 	  Driver for ST-Ericsson UX500 crypto engine.
 
@@ -363,10 +362,7 @@ config CRYPTO_DEV_BFIN_CRC
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
 	depends on ARCH_AT91
-	select CRYPTO_CBC
-	select CRYPTO_ECB
 	select CRYPTO_AES
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	select AT_HDMAC
 	help
@@ -381,9 +377,6 @@ config CRYPTO_DEV_ATMEL_TDES
 	tristate "Support for Atmel DES/TDES hw accelerator"
 	depends on ARCH_AT91
 	select CRYPTO_DES
-	select CRYPTO_CBC
-	select CRYPTO_ECB
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  Some Atmel processors have DES/TDES hw accelerator.
@@ -396,10 +389,7 @@ config CRYPTO_DEV_ATMEL_TDES
 config CRYPTO_DEV_ATMEL_SHA
 	tristate "Support for Atmel SHA hw accelerator"
 	depends on ARCH_AT91
-	select CRYPTO_SHA1
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
-	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
 	help
 	  Some Atmel processors have SHA1/SHA224/SHA256/SHA384/SHA512
 	  hw accelerator.
@@ -412,7 +402,6 @@ config CRYPTO_DEV_ATMEL_SHA
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
 	depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && HAS_IOMEM
-	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
 	  for encryption, hashing and related operations.
@@ -424,13 +413,11 @@ endif
 config CRYPTO_DEV_MXS_DCP
 	tristate "Support for Freescale MXS DCP"
 	depends on ARCH_MXS
-	select CRYPTO_SHA1
-	select CRYPTO_SHA256
 	select CRYPTO_CBC
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
 	help
 	  The Freescale i.MX23/i.MX28 has SHA1/SHA256 and AES128 CBC/ECB
 	  co-processor on the die.
@@ -449,7 +436,6 @@ config CRYPTO_DEV_QCE
 	select CRYPTO_CBC
 	select CRYPTO_XTS
 	select CRYPTO_CTR
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This driver supports Qualcomm crypto engine accelerator
@@ -468,7 +454,6 @@ config CRYPTO_DEV_IMGTEC_HASH
 	tristate "Imagination Technologies hardware hash accelerator"
 	depends on MIPS || COMPILE_TEST
 	depends on HAS_DMA
-	select CRYPTO_ALGAPI
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index e7555ff..e286e28 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -45,7 +45,6 @@ config CRYPTO_DEV_FSL_CAAM_RINGSIZE
 config CRYPTO_DEV_FSL_CAAM_INTC
 	bool "Job Ring interrupt coalescing"
 	depends on CRYPTO_DEV_FSL_CAAM_JR
-	default n
 	help
 	  Enable the Job Ring's interrupt coalescing feature.
 
@@ -77,8 +76,9 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 	tristate "Register algorithm implementations with the Crypto API"
 	depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
 	default y
-	select CRYPTO_ALGAPI
+	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
+	select CRYPTO_BLKCIPHER
 	help
 	  Selecting this will offload crypto for users of the
 	  scatterlist crypto API (such as the linux native IPSec
@@ -115,7 +115,6 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
 config CRYPTO_DEV_FSL_CAAM_DEBUG
 	bool "Enable debug output in CAAM driver"
 	depends on CRYPTO_DEV_FSL_CAAM
-	default n
 	help
 	  Selecting this will enable printing of various debug
 	  information in the CAAM driver.
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 7639ffc..ae38f6b 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -13,7 +13,6 @@ config CRYPTO_DEV_CCP_CRYPTO
 	tristate "Encryption and hashing acceleration support"
 	depends on CRYPTO_DEV_CCP_DD
 	default m
-	select CRYPTO_ALGAPI
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AUTHENC
diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
index 3e621ad..b1addf6 100644
--- a/drivers/crypto/nx/Kconfig
+++ b/drivers/crypto/nx/Kconfig
@@ -3,16 +3,8 @@ config CRYPTO_DEV_NX_ENCRYPT
 	tristate "Encryption acceleration support on pSeries platform"
 	depends on PPC_PSERIES && IBMVIO && !CPU_LITTLE_ENDIAN
 	default y
-	select CRYPTO_ALGAPI
 	select CRYPTO_AES
-	select CRYPTO_CBC
-	select CRYPTO_ECB
 	select CRYPTO_CCM
-	select CRYPTO_GCM
-	select CRYPTO_AUTHENC
-	select CRYPTO_XCBC
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
 	help
 	  Support for PowerPC Nest (NX) encryption acceleration. This
 	  module supports acceleration for AES and SHA2 algorithms on
diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 49bede2..6fdb9e8 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -2,9 +2,8 @@ config CRYPTO_DEV_QAT
 	tristate
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
-	select CRYPTO_ALGAPI
-	select CRYPTO_AES
-	select CRYPTO_CBC
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
@@ -13,7 +12,6 @@ config CRYPTO_DEV_QAT
 config CRYPTO_DEV_QAT_DH895xCC
 	tristate "Support for Intel(R) DH895xCC"
 	depends on X86 && PCI
-	default n
 	select CRYPTO_DEV_QAT
 	help
 	  Support for Intel(R) DH895xcc with Intel(R) QuickAssist Technology
diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
index b35e5c4..3079644 100644
--- a/drivers/crypto/ux500/Kconfig
+++ b/drivers/crypto/ux500/Kconfig
@@ -7,6 +7,8 @@
 config CRYPTO_DEV_UX500_CRYP
 	tristate "UX500 crypto driver for CRYP block"
 	depends on CRYPTO_DEV_UX500
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
 	help
         This selects the crypto driver for the UX500_CRYP hardware. It supports
@@ -16,7 +18,6 @@ config CRYPTO_DEV_UX500_HASH
         tristate "UX500 crypto driver for HASH block"
         depends on CRYPTO_DEV_UX500
         select CRYPTO_HASH
-        select CRYPTO_HMAC
         help
           This selects the hash driver for the UX500_HASH hardware.
           Depends on UX500/STM DMA if running in DMA mode.
@@ -24,7 +25,6 @@ config CRYPTO_DEV_UX500_HASH
 config CRYPTO_DEV_UX500_DEBUG
 	bool "Activate ux500 platform debug-mode for crypto and hash block"
 	depends on CRYPTO_DEV_UX500_CRYP || CRYPTO_DEV_UX500_HASH
-	default n
 	help
 	  Say Y if you want to add debug prints to ux500_hash and
 	  ux500_cryp devices.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
