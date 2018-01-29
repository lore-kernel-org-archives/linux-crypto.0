From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 2/5] dt-bindings: rng: add reset node for stm32
Date: Mon, 29 Jan 2018 18:05:18 +0100
Message-ID: <20180129170521.1862-3-lionel.debieve@st.com>
References: <20180129170521.1862-1-lionel.debieve@st.com>
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
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129170521.1862-1-lionel.debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adding optional resets property for rng.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 Documentation/devicetree/bindings/rng/st,stm32-rng.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
index 47f04176f93b..cb7ca78135ff 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
@@ -11,6 +11,9 @@ Required properties:
 - interrupts : The designated IRQ line for the RNG
 - clocks : The clock needed to enable the RNG
 
+Optional properties:
+- resets : The reset to properly start RNG
+
 Example:
 
 	rng: rng@50060800 {
-- 
2.15.1
