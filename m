From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/4] hwrng: exynos - Add Device Tree support
Date: Mon, 19 Oct 2015 13:37:38 +0900
Message-ID: <1445229462-32395-1-git-send-email-k.kozlowski@samsung.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
To: Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

The patchset fixes known issues in Exynos hardware random number
generator and adds Device Tree support for it.

The device was tested on Trats2 board (Exynos4412). It should work
on other Exynos4 and Exynos5 as well... altough it seems that
on some of Exynos542x boards the SSS module is secured.

Best regards,
Krzysztof

Krzysztof Kozlowski (4):
  dt-bindings: rng: Describe Exynos4 PRNG bindings
  hwrng: exynos - Add timeout for waiting on init done
  hwrng: exynos - Fix missing configuration after suspend to RAM
  hwrng: exynos - Add Device Tree support

 .../bindings/rng/samsung,exynos-rng4.txt           | 17 +++++++
 drivers/char/hw_random/exynos-rng.c                | 56 ++++++++++++++++++----
 2 files changed, 65 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt

-- 
1.9.1
