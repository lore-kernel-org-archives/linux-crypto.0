From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 11/11] arm64: defconfig: enable CAAM crypto engine on QorIQ DPAA2 SoCs
Date: Mon, 10 Sep 2018 20:15:50 +0300
Message-ID: <20180910171550.5659-12-horia.geanta@nxp.com>
References: <20180910171550.5659-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910171550.5659-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Enable CAAM (Cryptographic Accelerator and Assurance Module) driver
for QorIQ Data Path Acceleration Architecture (DPAA) v2.
It handles DPSECI (Data Path SEC Interface) DPAA2 objects that sit
on the Management Complex (MC) fsl-mc bus.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 6815db53674e..3d165b4cdd2a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -698,6 +698,7 @@ CONFIG_MEMTEST=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_ANSI_CPRNG=y
+CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=y
 CONFIG_ARM64_CRYPTO=y
 CONFIG_CRYPTO_SHA1_ARM64_CE=y
 CONFIG_CRYPTO_SHA2_ARM64_CE=y
-- 
2.16.2
