From: Vinod Koul <vinod.koul@linaro.org>
Subject: [PATCH v2 1/2] dt-bindings: rng: Add new compatible qcom,prng-v2
Date: Tue, 19 Jun 2018 15:24:29 +0530
Message-ID: <20180619095430.26358-2-vkoul@kernel.org>
References: <20180619095430.26358-1-vkoul@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        vinod.koul@linaro.org, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619095430.26358-1-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Later qcom chips support v2 of the prng, so add new compatible
qcom,prng-v2 for this.

Signed-off-by: Vinod Koul <vkoul@kernel.org>
---

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
 Documentation/devicetree/bindings/rng/qcom,prng.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/qcom,prng.txt b/Documentation/devicetree/bindings/rng/qcom,prng.txt
index 8e5853c2879b..03fd218bd21a 100644
--- a/Documentation/devicetree/bindings/rng/qcom,prng.txt
+++ b/Documentation/devicetree/bindings/rng/qcom,prng.txt
@@ -2,7 +2,8 @@ Qualcomm MSM pseudo random number generator.
 
 Required properties:
 
-- compatible  : should be "qcom,prng"
+- compatible  : should be "qcom,prng" for 8916 etc
+              : should be "qcom,prng-v2" for 8996 and later
 - reg         : specifies base physical address and size of the registers map
 - clocks      : phandle to clock-controller plus clock-specifier pair
 - clock-names : "core" clocks all registers, FIFO and circuits in PRNG IP block
-- 
2.14.4
