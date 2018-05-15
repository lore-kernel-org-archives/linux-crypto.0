From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/3] enable ccree on Renesas R-Car platform
Date: Tue, 15 May 2018 13:29:26 +0100
Message-ID: <1526387370-17142-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The following patch set enables CryptoCell present in the Renesas
R-Car SoC.

Gilad Ben-Yossef (3):
  crypto: ccree: drop signature register check
  clk: renesas: r8a7795: Add ccree clock
  arm64: dts: renesas: r8a7795: add ccree binding

 arch/arm64/boot/dts/renesas/r8a7795.dtsi |  8 ++++++++
 drivers/clk/renesas/r8a7795-cpg-mssr.c   |  1 +
 drivers/crypto/ccree/cc_driver.c         | 18 +++---------------
 3 files changed, 12 insertions(+), 15 deletions(-)

-- 
2.7.4
