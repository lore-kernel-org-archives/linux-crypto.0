Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E94D2BE112;
	Tue, 13 May 2025 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161647; cv=none; b=TScRiRMzUWys0tA9PR+XMSvCw62ubeJukfLaZgFuwNPuwbEy13/OICJwggyjw/eWy/C/cgXRIFnzybcDCnhql9UkCctxiukO+MxqUrG+Aa1h1Gu0/FyVVBNikqY2SIAfxliF0mMvzOPswNchOGppbIcECW21yIkkW5ShGWpDeeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161647; c=relaxed/simple;
	bh=LUdo1YTEXYomgG1nU4pnAGqyr93S6Fk8DNsW3FmP8to=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k2ndPoA8b2W0HwxTFKAOKW//ZhjoAxKXk3e46yYX2/PpwAoA7h/S8z0JL0+EMgfIqTWZtu4pwvZd+Y9Ff4JrOkqKk4s5l48VwX4U58cfNQKUbIshrdyE8Hch2phTCkErLwylmiHHuKN9puKGmITBlAu3UB081rFvi4eNT2g4fJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCoDPiMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCoDPiMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53B7C4CEEB;
	Tue, 13 May 2025 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161646;
	bh=LUdo1YTEXYomgG1nU4pnAGqyr93S6Fk8DNsW3FmP8to=;
	h=From:To:Cc:Subject:Date:From;
	b=mCoDPiMF+FsTw3FrWVSQ7Dn7ACIFgX0KW5Q/Qjj/p6xlz5pMKAKi9eYNfUKeExU0K
	 MFAC0OIF/O5ixf8ZZaoIjY4bwps5DqkikLbLLuSAIEFNY/coxjmuxj+QK8ihYwDSpM
	 GiKkbMXjetIaqI9LeSCOwwxNHCmLN55ug1m539fgDLL/oMFMZljTpyUyg2KcPb1AAk
	 b8RYSev2PInn5GIXKP9ZIonSAhxm7LkdIa0GIuN2PTeHsjLxhQXFFX+A2x0mF/VFzI
	 8X/ubDDanjqZkocE+alGHSsvdb4tc5qfOFZpWO0LCrzvzCVxLGBf138CeHk2jtgluF
	 TXjSKpv5p4QhA==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] dt-bindings: crypto: Drop obsolete mediatek,eip97-crypto
Date: Tue, 13 May 2025 13:40:41 -0500
Message-ID: <20250513184042.3051424-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mediatek,eip97-crypto binding is half abandoned. The driver was
dropped in 2020 as the Mediatek platforms use InsideSecure block and
the driver for it. All the platforms except MT7623 were updated. A
patch to update it was submitted, but never addressed the review
comments.

Link: https://lore.kernel.org/all/20210303080923.16761-1-vic.wu@mediatek.com/
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/mediatek-crypto.txt       | 25 -------------------
 1 file changed, 25 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
deleted file mode 100644
index 450da3661cad..000000000000
--- a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-MediaTek cryptographic accelerators
-
-Required properties:
-- compatible: Should be "mediatek,eip97-crypto"
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the five crypto engines interrupts in numeric
-	order. These are global system and four descriptor rings.
-- clocks: the clock used by the core
-- clock-names: Must contain "cryp".
-- power-domains: Must contain a reference to the PM domain.
-
-
-Example:
-	crypto: crypto@1b240000 {
-		compatible = "mediatek,eip97-crypto";
-		reg = <0 0x1b240000 0 0x20000>;
-		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 83 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
-		clocks = <&ethsys CLK_ETHSYS_CRYPTO>;
-		clock-names = "cryp";
-		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
-	};
-- 
2.47.2

