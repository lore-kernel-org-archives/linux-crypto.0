From: Vinod Koul <vkoul@kernel.org>
Subject: [PATCH v4 4/6] dt-bindings: crypto: Add new compatible qcom,prng-ee
Date: Wed,  4 Jul 2018 17:14:25 +0530
Message-ID: <20180704114427.29953-5-vkoul@kernel.org>
References: <20180704114427.29953-1-vkoul@kernel.org>
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
In-Reply-To: <20180704114427.29953-1-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Later qcom chips support v2 of the prng, which exposes an EE
(Execution Environment) for OS to use so add new compatible
qcom,prng-ee for this.

Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.txt b/Documentation/devicetree/bindings/crypto/qcom,prng.txt
index 8e5853c2879b..7ee0e9eac973 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.txt
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.txt
@@ -2,7 +2,9 @@ Qualcomm MSM pseudo random number generator.
 
 Required properties:
 
-- compatible  : should be "qcom,prng"
+- compatible  : should be "qcom,prng" for 8916 etc
+              : should be "qcom,prng-ee" for 8996 and later using EE
+		(Execution Environment) slice of prng
 - reg         : specifies base physical address and size of the registers map
 - clocks      : phandle to clock-controller plus clock-specifier pair
 - clock-names : "core" clocks all registers, FIFO and circuits in PRNG IP block
-- 
2.14.4
