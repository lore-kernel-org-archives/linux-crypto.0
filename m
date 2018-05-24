From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/5] crypto: ccree: cleanup, fixes and R-Car enabling
Date: Thu, 24 May 2018 15:19:05 +0100
Message-ID: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
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

The patch set enables the use of CryptoCell found in some Renesas R-Car
Salvator-X boards and fixes some driver issues uncovered that prevented
to work properly.

Changes from v1:
- Properly fix the bug that caused us to read a bad signature register
  rather than dropping the check
- Proper DT fields as indicated by Geert Uytterhoeven.
- Better clock enabling as suggested by Geert Uytterhoeven.

Note! the last two patches in the set depend on the
"clk: renesas: r8a7795: Add CR clock" patch from Geert Uytterhoeven.

Gilad Ben-Yossef (5):
  crypto: ccree: correct host regs offset
  crypto: ccree: better clock handling
  crypto: ccree: silence debug prints
  clk: renesas: r8a7795: add ccree clock bindings
  arm64: dts: renesas: r8a7795: add ccree binding

 arch/arm64/boot/dts/renesas/r8a7795.dtsi |  9 +++++++++
 drivers/clk/renesas/r8a7795-cpg-mssr.c   |  1 +
 drivers/crypto/ccree/cc_debugfs.c        |  7 +++++--
 drivers/crypto/ccree/cc_driver.c         | 34 ++++++++++++++++++++++++++------
 drivers/crypto/ccree/cc_driver.h         |  2 ++
 drivers/crypto/ccree/cc_host_regs.h      |  6 ++++--
 6 files changed, 49 insertions(+), 10 deletions(-)

-- 
2.7.4
