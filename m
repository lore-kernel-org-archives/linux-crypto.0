Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55EA761FF0;
	Sun, 16 Jun 2024 22:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718575741; cv=none; b=DxfHyXnPrBSyX4BXCHrRkTwmk+aaw16Gdoi1h7FfR4eGeX1VxBPgOHQPKULiGlg5W5lEtaY7etzQC0M0vxmRBQwIWekxvxD12jNWsEtGgNRtLlyDy5vQfVEe/ej1lf37enXhC1QtWduR9+BDvYiwvShkTb/zUMaM2S7+x1gPqis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718575741; c=relaxed/simple;
	bh=i3nqmLT9aTw9DaPSVB5nW21/YLLYaayUA2fo89C4WFM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RXc+SJyHFlcEWq5HnUVqoWYlArSvnNWN+9VZPyc4gJDpAXbgF5e9pljJRe7t0V6di/WV/EZlXwAzMikCZFYlclCIrnISuZpBdHVdmbvfn1axn4124coirrG1UqSkuKYNtt7/7SuUAUIOtXrvuk7UI1+PT38Yw3C5wnKhtJZpZEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0AACFEC;
	Sun, 16 Jun 2024 15:09:18 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5620C3F73B;
	Sun, 16 Jun 2024 15:08:52 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: [PATCH 1/4] dt-bindings: crypto: sun8i-ce: Add compatible for H616
Date: Sun, 16 Jun 2024 23:07:16 +0100
Message-Id: <20240616220719.26641-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.39.4
In-Reply-To: <20240616220719.26641-1-andre.przywara@arm.com>
References: <20240616220719.26641-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Allwinner H616 has a crypto engine very similar to the one in the
H6, although all addresses in the DMA descriptors are shifted by 2 bits,
to accommodate for the larger physical address space. That makes it
incompatible to the H6 variant, and thus requires a new compatible
string. Clock wise it relies on the internal oscillator for the TRNG,
so needs all four possible clocks specified.

Add the compatible string to the list of recognised names, and add the
H616 to list of devices requiring all four clocks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../devicetree/bindings/crypto/allwinner,sun8i-ce.yaml          | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
index 4287678aa79f4..da47b601c165e 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -18,6 +18,7 @@ properties:
       - allwinner,sun50i-a64-crypto
       - allwinner,sun50i-h5-crypto
       - allwinner,sun50i-h6-crypto
+      - allwinner,sun50i-h616-crypto
 
   reg:
     maxItems: 1
@@ -49,6 +50,7 @@ if:
     compatible:
       enum:
         - allwinner,sun20i-d1-crypto
+        - allwinner,sun50i-h616-crypto
 then:
   properties:
     clocks:
-- 
2.39.4

