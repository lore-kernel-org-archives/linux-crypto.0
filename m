From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH Resend 4/5] dt-bindings: rng: add clock detection error for stm32
Date: Thu, 15 Feb 2018 14:03:11 +0100
Message-ID: <20180215130312.23612-5-lionel.debieve@st.com>
References: <20180215130312.23612-1-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <rob.herring@linaro.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180215130312.23612-1-lionel.debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add optional property to enable the clock detection error
on rng block. It is used to allow slow clock source which
give correct entropy for rng.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 Documentation/devicetree/bindings/rng/st,stm32-rng.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
index cb7ca78135ff..1dfa7d51e006 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
@@ -13,6 +13,7 @@ Required properties:
 
 Optional properties:
 - resets : The reset to properly start RNG
+- clock-error-detect : Enable the clock detection management
 
 Example:
 
-- 
2.15.1
