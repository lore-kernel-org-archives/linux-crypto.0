From: Vinod Koul <vkoul@kernel.org>
Subject: [PATCH v5 2/6] dt-bindings: crypto: Move prng binding to crypto
Date: Mon,  9 Jul 2018 11:49:21 +0530
Message-ID: <20180709061925.20276-3-vkoul@kernel.org>
References: <20180709061925.20276-1-vkoul@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709061925.20276-1-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that we are adding new driver for prng in crypto, move the
binding as well.

Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 Documentation/devicetree/bindings/{rng => crypto}/qcom,prng.txt | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/{rng => crypto}/qcom,prng.txt (100%)

diff --git a/Documentation/devicetree/bindings/rng/qcom,prng.txt b/Documentation/devicetree/bindings/crypto/qcom,prng.txt
similarity index 100%
rename from Documentation/devicetree/bindings/rng/qcom,prng.txt
rename to Documentation/devicetree/bindings/crypto/qcom,prng.txt
-- 
2.14.4
