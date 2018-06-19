From: Vinod Koul <vinod.koul@linaro.org>
Subject: [PATCH v2 0/2] hwrng: Add support for qcpm v2 hwrng
Date: Tue, 19 Jun 2018 15:24:28 +0530
Message-ID: <20180619095430.26358-1-vkoul@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        vinod.koul@linaro.org, Vinod Koul <vkoul@kernel.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series adds support for newer version of hwrng as found in
Qualcomm SoCs. To do that add new v2 compatible string and driver_data
values for v2.

Changes in v2:
 - remove table based approach and set the init/cleanup routine based on
   driver data value

Vinod Koul (2):
  dt-bindings: rng: Add new compatible qcom,prng-v2
  hwrng: msm - Add support for prng v2

 Documentation/devicetree/bindings/rng/qcom,prng.txt |  3 ++-
 drivers/char/hw_random/msm-rng.c                    | 14 ++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.14.4
