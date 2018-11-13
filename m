Return-Path: <SRS0=KYvO=NY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50282 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731399AbeKMTij (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Nov 2018 14:38:39 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yael Chemla <yael.chemla@foss.arm.com>
Cc: Ofir Drang <Ofir.Drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dt-bindings: crypto: ccree: add dt bindings for ccree 703
Date: Tue, 13 Nov 2018 09:40:36 +0000
Message-Id: <1542102039-22256-3-git-send-email-gilad@benyossef.com>
In-Reply-To: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add device tree bindings associating Arm TrustZone CryptoCell 703 with the
ccree driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
index 0ac06ec..6130e6e 100644
--- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
+++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
@@ -3,6 +3,7 @@ Arm TrustZone CryptoCell cryptographic engine
 Required properties:
 - compatible: Should be one of -
    "arm,cryptocell-713-ree"
+   "arm,cryptocell-703-ree"
    "arm,cryptocell-712-ree"
    "arm,cryptocell-710-ree"
    "arm,cryptocell-630p-ree"
-- 
2.7.4
