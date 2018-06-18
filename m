From: Vinod Koul <vinod.koul@linaro.org>
Subject: [PATCH 0/3]: hwrng: Add support for qcpm v2 hwrng
Date: Mon, 18 Jun 2018 19:42:56 +0530
Message-ID: <20180618141259.23141-1-vkoul@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series adds support for newer version of hwrng as found in
Qualcomm SoCs. To do that refactor the msm hwrng driver and add
support for v2 ops

Vinod Koul (3):
  hwrng: msm - Move hwrng to a table
  dt-bindings: rng: Add new compatible qcom,prng-v2
  hwrng: msm - Add support for prng v2

 .../devicetree/bindings/rng/qcom,prng.txt          |  3 +-
 drivers/char/hw_random/msm-rng.c                   | 36 +++++++++++++++-------
 2 files changed, 27 insertions(+), 12 deletions(-)

-- 
2.14.4
