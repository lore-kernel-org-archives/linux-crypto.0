From: Neil Armstrong <narmstrong@baylibre.com>
Subject: [RESEND PATCH 0/2] hw_random: Add Amlogic Meson SoCs Random Generator driver
Date: Wed, 15 Jun 2016 12:01:44 +0200
Message-ID: <1465984906-17840-1-git-send-email-narmstrong@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

NOTE: This is a resent of the DT Bindings and DTSI patches based on the Amlogic DT 64bit
GIT pull request from Kevin Hilman at [1].

Changes since v2 at http://lkml.kernel.org/r/1465546915-24229-1-git-send-email-narmstrong@baylibre.com :
- Move rng peripheral node into periphs simple-bus node

Add support for the Amlogic Meson SoCs Hardware Random generator as a hw_random char driver.
The generator is a single 32bit wide register.
Also adds the Meson GXBB SoC DTSI node and corresponding DT bindings.

Changes since v1 at http://lkml.kernel.org/r/1464943621-18278-1-git-send-email-narmstrong@baylibre.com :
- change to depend on ARCH_MESON || COMPILE_TEST
- check buffer max size in read

[1] [GIT PULL] Amlogic DT 64-bit changes for v4.8 : http://lkml.kernel.org/r/7hshwfbiit.fsf@baylibre.com

Neil Armstrong (2):
  dt-bindings: hwrng: Add Amlogic Meson Hardware Random Generator
    bindings
  ARM64: dts: meson-gxbb: Add Hardware Random Generator node

 .../devicetree/bindings/rng/amlogic,meson-rng.txt          | 14 ++++++++++++++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi                |  5 +++++
 2 files changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt

-- 
2.7.0
