Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F46D49B5C2
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078351; cv=none; b=Oy590Y+wXeoMvQZMiTFHxXWmvALsbBfUdeVSE6JQzjEgccCmIYQvpfKWhaVExVasTEOOQN0kuf30YRO6aQXm1j6KJ67gHBwnJohIzoxdL51qA0XZ2ozGus+Virp+DeN148olnIijztpMSqhsa9mZRCbFONZQM9r5yM1QA36BFts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078351; c=relaxed/simple;
	bh=BbAJHt9adMYyzBOCLH5rvGTbgi1xMnGL52q958OEAto=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ASHpSdxi0NMuYATzxBScrq2EAioYQIMBX8jwkArmIq2FDQHH/u9NDQMGMrNaw+5pIZJ1hfy5AGJycnXUz3IO3NG5uB3MFxr4PRZGdq9UAHgcwx63spSK7T+OOkTLCkMK41g9zXglFRtpw9Dv3BT8vHLrS9/Bp2r0kkBRb4sYR9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBDgkh1u; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBDgkh1u"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-855ce7e3990so18904b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789078349; x=1789683149; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jQaA/YsbwqnIY6MwaWj7Df5zJPQ8UAD3/8j58BDH8n4=;
        b=dBDgkh1u5p8y98/Yplqy01MMvH/QswR24/nXsiApjY+3Eq82RDUSzHipK4uGJMfl1T
         vGCTBOMofso1sGNaq+Sb3stiOj4YQ3keY6VUHNv5LfajyLfoLA8G8Lv2fSPzTmXaJpLD
         u/lRV7hycnsJRRnkq+d4vRm9FVqiTRgdTXxcESCuhjmd47b8V/RCVncusGEAnaNJOX+s
         yPAHDqGmEsmKBIway8rCXgjzSG+Q3RnvdWRq1evDlPerhw4zKYl8pFV8XzJq5MWIgedJ
         NV26E17tm7I8eXBrj6gU11XAximHvcKbG9BvPEZggy555r43miMISLMpg1C0NW/m4Opl
         o2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789078349; x=1789683149;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jQaA/YsbwqnIY6MwaWj7Df5zJPQ8UAD3/8j58BDH8n4=;
        b=gURxzOOHtai0A7SyXVvZDly7SOINi1sWQw0Eqcwj+CBk0zPm+pTLm7GlNKBFcl5MZt
         q7HE90NNQM7JPC8vt+vJE5Ue/ZkBTc9b5b5twFJhlwb2GP1ebm/DIkfliUHrVaZhE9UX
         O6d1He+bBIP5RCNCWx5npMOVMV5mlNF30jSIsd1A2bCEpnNzyPGfO7tYJbY/lbGCKF47
         nqlzZM+t12W436nmmbwnjVLmerAzjz4YfkKcY7MDBlThDDrGQk8VDe6gemf8bqLspJe/
         On2dgrEGaompkTGLQPBVjx1VpN+OaOSguWbGxo07DWpQAOVN5m0TwQRppO8wgtm3eD5/
         fuzw==
X-Forwarded-Encrypted: i=1; AKwUvBzkuYXfGkuzwRiqwXHkdewRlq7VJL+i/CM+Tc5IIB3oJqXJ7aUrFqVyY7X/Umw0RzycD3agUBzW4FbU+i4=@vger.kernel.org
X-Gm-Message-State: AFuF++kNDGiB/ZuRJw9TMUZHyDoRvfesEfQhfZV6ZeDANom9WLWIJIOJ
	zwmuuNka33+xtRhadm9GU9uzuqxGr5fMKgO1g32LqJB00R0IW0ZNhLoU87dy9w==
X-Gm-Gg: AYBFou1Xx9+YBIj3F0+SErRTktE/uqpbTUDUYLM0VV/LK5BuF0ks6sw7He1ezyDfkaq
	Ct8LxYefQoBdo6rjBl9IwVyEWt2jMDY/zJB+O2EH1ISi2p9S5eFs0NOkzeptkw/Qr5H9vn1QZLZ
	Ccnbrpvc3PKeO33o7nPOXyMowyL9UQus8JKRwTpejqNjnV/WscgiBYKF0fkgUvYsh3NOtNm6K7R
	w23umuxO0vLcbVezM2yALVdeLjSrRawxTAvNNgIKdQBA9/bBoetOSrGOE7Ayhf4Pv+tF7DJKg3B
	7Yyc0morVxCuJKfYlhGelcG+6laTwc0HxgFnE2aPTeoKxUiePGisW14pOT30cGDH78meLTmoxIH
	6T+6+F53kVDpTDUMmGQ7N9VRaeKRh3IHnNDb/f0dUQeV17STLbfELpPKIOQ2OD52cUcHsox19mH
	8pm5fd5zJ2CIlU37JSAie7+qN1XSUp1cPrSIrjGJqOOcifEaVBbT40dbx2BYxSL+2Lrf8qRtGEs
	FjGR/pNesFC
X-Received: by 2002:a05:6a00:4891:b0:85f:2315:4efd with SMTP id d2e1a72fcca58-86b2f0f01f0mr781561b3a.1.1789078349465;
        Thu, 10 Sep 2026 15:12:29 -0700 (PDT)
Received: from [172.29.212.252] ([2409:40c2:5426:e355:af9c:7683:e7ab:273b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b291bf622sm171875b3a.27.2026.09.10.15.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 15:12:29 -0700 (PDT)
From: Bhargav Joshi <j.bhargav.u@gmail.com>
Date: Fri, 11 Sep 2026 03:41:57 +0530
Subject: [PATCH 1/2] ARM: dts: ti: omap: dra7: Remove clocks from crypto
 nodes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-ti-dra7-omap-sham-fix-v1-1-c430f01b4e13@gmail.com>
References: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
In-Reply-To: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>, 
 Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
 Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Animesh Agarwal <animeshagarwal28@gmail.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 j.bhargav.u@gmail.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789078323; l=1722;
 i=j.bhargav.u@gmail.com; h=from:subject:message-id;
 bh=BbAJHt9adMYyzBOCLH5rvGTbgi1xMnGL52q958OEAto=;
 b=s2lsYvRL+iaAkkoY+sP2q/EZlVEKggnNXoz5w98GQwNOuT4KUIGfJoMx5eXFubB4Q8a/GAnEO
 FeHAazX9I2rAtuRZ2FVTHyxgN6rB/7YIZdyR+0K2oS3EGCP0xj2DFC0
X-Developer-Key: i=j.bhargav.u@gmail.com; a=ed25519;
 pk=IqNDwUZKECEA+n8wXctFLBbYL9NhFstZNbOznm/nX1k=

The omap-sham and omap-aes crypto drivers do not use "clocks" and
"clock-names" properties. Clock management is handled by the ti-sysc
interconnect parent wrapper. The dt-bindings for ti,omap-sham and
ti,omap-aes don't define these clock properties. Having them in the
child nodes causes dtbs_check warnings.

Remove the "clocks" and "clock-names" properties from the sham and aes
nodes.

Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
---
 arch/arm/boot/dts/ti/omap/dra7.dtsi | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/dra7.dtsi b/arch/arm/boot/dts/ti/omap/dra7.dtsi
index 711ce4c31bb1..0784c6d9cbe4 100644
--- a/arch/arm/boot/dts/ti/omap/dra7.dtsi
+++ b/arch/arm/boot/dts/ti/omap/dra7.dtsi
@@ -1012,8 +1012,6 @@ aes1: aes@0 {
 				interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
 				dmas = <&edma_xbar 111 0>, <&edma_xbar 110 0>;
 				dma-names = "tx", "rx";
-				clocks = <&l3_iclk_div>;
-				clock-names = "fck";
 			};
 		};
 
@@ -1043,8 +1041,6 @@ aes2: aes@0 {
 				interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
 				dmas = <&edma_xbar 114 0>, <&edma_xbar 113 0>;
 				dma-names = "tx", "rx";
-				clocks = <&l3_iclk_div>;
-				clock-names = "fck";
 			};
 		};
 
@@ -1073,8 +1069,6 @@ sham1: sham@0 {
 				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 				dmas = <&edma_xbar 119 0>;
 				dma-names = "rx";
-				clocks = <&l3_iclk_div>;
-				clock-names = "fck";
 			};
 		};
 
@@ -1103,8 +1097,6 @@ sham2: sham@0 {
 				interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 				dmas = <&edma_xbar 165 0>;
 				dma-names = "rx";
-				clocks = <&l3_iclk_div>;
-				clock-names = "fck";
 			};
 		};
 

-- 
2.55.0

