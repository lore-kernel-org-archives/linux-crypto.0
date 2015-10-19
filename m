From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/3] ARM: dts: Enable Exynos RNG module
Date: Mon, 19 Oct 2015 14:00:31 +0900
Message-ID: <1445230834-32689-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Heiner Kallweit <hkallweit1@gmail.com>
To: Kukjin Kim <kgene@kernel.org>,
 Krzysztof Kozlowski <k.kozlowski@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Tomasz Figa <tomasz.figa@gmail.com>,
 Michael Turquette <mturquette@baylibre.com>,
 Stephen Boyd <sboyd@codeaurora.org>, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi,


The patchset adds necessary clock from Security SubSystem (SSS)
and enables the PRNG module of Exynos for Trats2 board.

The first patch (clock) is required for other ones so please
take everything in one step.

The actual Device Tree support (and compatible) was sent in separate
patch:
 - https://patchwork.kernel.org/patch/7432891/
 - http://marc.info/?l=linux-crypto-vger&m=144522952725052&w=2

The device can be tested (after applying both patchsets) with:
$ echo exynos > /sys/class/misc/hw_random/rng_current
$ dd if=/dev/hwrng of=/dev/null bs=1 count=16


Best regards,
Krzysztof

Krzysztof Kozlowski (3):
  clk: samsung: exynos4: Add SSS gate clock
  ARM: dts: Add PRNG module for exynos4
  ARM: dts: Enable PRNG module on exynos4412-trats2

 arch/arm/boot/dts/exynos4.dtsi          | 8 ++++++++
 arch/arm/boot/dts/exynos4412-trats2.dts | 4 ++++
 drivers/clk/samsung/clk-exynos4.c       | 1 +
 include/dt-bindings/clock/exynos4.h     | 1 +
 4 files changed, 14 insertions(+)

-- 
1.9.1
