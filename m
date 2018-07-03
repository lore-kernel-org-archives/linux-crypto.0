From: Vinod Koul <vkoul@kernel.org>
Subject: [PATCH v3 0/6] crypto: Add Qcom PRNG support
Date: Tue,  3 Jul 2018 11:34:28 +0530
Message-ID: <20180703060434.19293-1-vkoul@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series removes the hwrng qcom driver and replaces it with crypto qcom
driver and then adds support for Execution Environment (EE) found in v2
version of the hardware and ACPI support for these

Timur Tabi (1):
  crypto: qcom: Add ACPI support

Vinod Koul (5):
  hwrng: remove msm hw_random driver
  dt-bindings: crypto: Move prng binding to crypto
  crypto: Add Qcom prng driver
  dt-bindings: crypto: Add new compatible qcom,prng-ee
  crypto: qcom: Add support for prng-ee

 .../bindings/{rng => crypto}/qcom,prng.txt         |   4 +-
 drivers/char/hw_random/Kconfig                     |  13 --
 drivers/char/hw_random/Makefile                    |   1 -
 drivers/char/hw_random/msm-rng.c                   | 183 ----------------
 drivers/crypto/Kconfig                             |  11 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/qcom-rng.c                          | 244 +++++++++++++++++++++
 7 files changed, 259 insertions(+), 198 deletions(-)
 rename Documentation/devicetree/bindings/{rng => crypto}/qcom,prng.txt (73%)
 delete mode 100644 drivers/char/hw_random/msm-rng.c
 create mode 100644 drivers/crypto/qcom-rng.c

-- 
2.14.4
