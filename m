Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCA932AACB
	for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 19:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786909332; cv=none; b=hkDN77W4wGO61uRCzx/sSxOCryPyW1oagyWjaUUnRrJ8iL9fmU//2lXn/MdEMkf+P59cBoM6OkDFaXPVtZq1HdDxefkPi1Uz1tlWM/Dy9v2QxdZBg9iPHbZuBjmKJElaLAuYCyrH6kZhCK4BsHjVdKhNOP3mEUNLUgj91tBYn4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786909332; c=relaxed/simple;
	bh=JI/qso1JxH/FQGLNUw5zW6NiLHYbjT03vJnGl9qr+Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvbhLYj9q5R9Y/MC45DQkNrCd6AY3casEg8R5yd92U4P+rbz5g0Ff6Bvpw8UxJ59OxLI1zIHi5KaITjv/DLqS3X2bMGOScB1IM/uyVsLMIPRWjTTmZe3WoKxA/REyHy9D6kqz88z7a3n/VPlLJkqmehuYT8dvycc92r5Be+sVds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/jAnhxg; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/jAnhxg"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4956242332dso28420765e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 12:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786909329; x=1787514129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p8nmwxeGtmUEsI+0IQq59S0kaD/GAoU83KLqHgNb9Mo=;
        b=k/jAnhxgxDbfttSgx/06pRLduPoqMfG5ShwFhsfqMN4CaRyS44+eWDSCa06e4fTmwD
         2jvOuvpWj6CIhc42PPboj0WvsHL9aeSHTVvIT0TADuLa/wKYofm/3Fes4DHm8euou9PI
         Gl78cSarTosJhISvPuGFyn2lhtJWH3jgIzxzmYyBA9rLcUFuur4vY/2XEeHcKoQg294i
         0IqePBbPKa+qnE/jT4R6tUa+L83nqwQhF0PxjaKG/1PB3h9T6oV6fZ6/yLRAv/rdqCbn
         QQL4TzMHMSI7BIUFkZA9Ys6kXyRf6fVsqcbtDHM2DoufCvdPiMseJCk9C/OnwhNsygCU
         1wzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786909329; x=1787514129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p8nmwxeGtmUEsI+0IQq59S0kaD/GAoU83KLqHgNb9Mo=;
        b=jXuru0wyRggalOnrgR2unvXz9PyT1A+fcbTYJRbD3s56LrbOj7QerlMi2PyrQElyw/
         PIEO5vLo+koShPgChxPWRESsJxEmS+LIDRL+PvgruceAleUeCKKq4CsMhnmvH7WOmRqG
         34D8B7jgUDcf+++ybDBfqN7H6CCmdgpk8n4OsW1+4wgRQ6pt3/E0cmsNXhzU3FJfl3bb
         ezmLUqnYln7HfS8x73I4JVTcTO/FFPldwDwOlj4V65NFUEWJfpbzxFAlBtYqx2/FPNeS
         BLzfGGsp4gRZmjeBedGlVZx74wArBzoR77B70KxP2bshYpD9iF2hd5CRYpHCKriSiIr7
         yvfQ==
X-Forwarded-Encrypted: i=1; AHgh+RrqIQiHhQpOSpoZxL/6x8dqGcLo9kfhMgKXzKT3nEFdpMGBjY3XVimeKoa3qf+o4P+iFoNM9vDlFe1usVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXiN/qQm2QKYk+YDfVXkg0uJuf3ZJzaRxE146reAZgOZLz+J6T
	ogbn1XJm0FWzoLgqGwoEtWRdIsEbSM283PwQrovFk9WLkC+P+mrmMFq1
X-Gm-Gg: AR+sD11MF7/6tOxNVtUzs2cRsHUmPXjoClvBivuvHLLTJHqAYzM0U4qXOHOhsUp9M+D
	dj4BQ2gnnX8Aj1KweBuAdQvvtrnURwrk6H3vVQb5gHaZDoSgYp49QmKgIQAABmQVQKGMcidOl0J
	AciQhgGYHukUm7FEzKYuWXp1ukzARPj/exBvKPlguha4cWFTramkipzZxfHuyp0eMKxTflMKN+u
	5p7qeXa9Q7EuPpGHmbIIFuZoZJ5e+LMs5zjBhIOYFW7fTTpajxeHOZFyyQ2En7l15f1o65L8dvR
	nN0WjYIGslxfkDQ5lZl9Tl5J6HTuOg6sQwUPNZVLT8u+7xHKtkeUxHmUB1B0azN0Jrwh86zpwSi
	31dkKp2jCgTO6ejwftLueUvl5zTuYzy9Drx9aXz9Dm+6XxkM8/rQgAmryVa47iG9mHXwf9gFRgj
	68lcXHMTh9DfF7sCX/xYKlzkEH3G9jUMsws1b75//ejOPiUSssVHU8TQ==
X-Received: by 2002:a05:600c:3596:b0:499:8ed2:8234 with SMTP id 5b1f17b1804b1-4998ed286c1mr202943995e9.0.1786909328685;
        Sun, 16 Aug 2026 12:42:08 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:f1b:d401:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996106c6esm100527875e9.5.2026.08.16.12.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 12:42:08 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH v3 3/4] arm64: dts: rockchip: Add crypto node to rk356x-base
Date: Sun, 16 Aug 2026 20:39:46 +0100
Message-ID: <20260816194112.552100-4-dawidro@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260816194112.552100-1-dawidro@gmail.com>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260816194112.552100-1-dawidro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the device tree node for the V2 cryptographic hardware accelerator
on RK356x SoCs (RK3566, RK3568).

The IP block sits in the non-secure peripheral domain. Its three clocks
(core, aclk, hclk) and reset line are accessible directly through the
main non-secure CRU, so no firmware intermediary is required.

The node is disabled by default; board files that wish to use hardware
crypto offload must enable it.

Co-developed-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # Quartz64-B,
NanoPi R5S, NanoPC-T6 LTS
---
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
index 64bdd8b7754b..8b88d6de18c2 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
@@ -1111,6 +1111,17 @@ sdhci: mmc@fe310000 {
 		status = "disabled";
 	};
 
+	crypto: crypto@fe380000 {
+		compatible = "rockchip,rk3568-crypto";
+		reg = <0x0 0xfe380000 0x0 0x2000>;
+		interrupts = <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru CLK_CRYPTO_NS_CORE>, <&cru ACLK_CRYPTO_NS>,
+			 <&cru HCLK_CRYPTO_NS>;
+		clock-names = "core", "aclk", "hclk";
+		resets = <&cru SRST_CRYPTO_NS_CORE>;
+		reset-names = "core";
+	};
+
 	/*
 	 * Testing showed that the HWRNG found in RK3566 produces unacceptably
 	 * low quality of random data, so the HWRNG isn't enabled for all RK356x
-- 
2.47.3

