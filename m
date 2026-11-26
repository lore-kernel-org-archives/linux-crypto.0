Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721622;
	b=wU0+7wmJyILSr3t7L6fee+FKCz/AQx+aVYV+weLiccZB1gERxdYfmNeAp7R7Mpx1awis
	 /ntVTYmosfIBjT2NOSNCqc0tmjPm25YhpVKpm39gzYuB6nZk3Siu2Of8fXIDYR3Jnfpgt
	 Hm5JK7//oLtqj7omrANd3oNKKMVKu/96BrVP1PFZDdqzGuTbiWyrWg4uu4iEEQPT3t09O
	 3/up1xrpH/kLGTQJE3YGXW+iSNEqLedzm+/tuZ/fVRTAXTfQVnXhoKJ06SvREiQnhsMZw
	 uMUh2nbYP/F6Inc7djS1zWs5+S3oJcdXssTeAdMeaFQyhT1uv12qrdJkdUzy0UvdsJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Jf5GtpRuXRchR2ff5N5v4AswDiRdBOtYpnk/23HLdl0=;
	b=19AMrNDiBDW1Q7lz/PW+n2DCjZK39fb+cjQdQ+cAY/LmhRHX0tMcP1vtFAiF2lhSSyit
	 dP9F7Vh41fZNXYCW/VRmaCAfQUm3fsqHneeVIPFsThEfyjFJ6M+CUdlSh892Kjp0hUvSr
	 yM0+aluC1eW/Nh+AdEiaI8zs8e1Xx0qPb1VUxcf3rf0jLtTsMT7vUoqnIG2mDG3V2bXax
	 NpVHI7MHtvBfgHJ/Z3B9+gk3u7n6PAaGdg70UEVcm543Z9fIYCswN8aqAHH69udVEKQqN
	 JmqEy8uamRVtpWI2U+xUb5VEGmD84xRH9cqg8Ii3JLisaafdZaLHAW37TfN4nBGrfkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PXZjYF68;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA15606A326
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CA15606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PXZjYF68
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so61538135e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721620; x=1796326420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jf5GtpRuXRchR2ff5N5v4AswDiRdBOtYpnk/23HLdl0=;
        b=PXZjYF681Cys0iH8L+l1VkG6kxpmZ6t0xFDNGqmNd3kTah8MRTqPQwu87CDNYTNq8X
         Na+tfqFFGx/NQwh0dF6LWnFS1zRL3TBhIL7ob0x0kDqR3cN2C0hlpDDDgVT/oQQQb8rx
         tADfD5t+MzSfEko9WB060ZzGSMsgomJoKwRnx7zPAmtALai2ezo3a9ef62Sazg92o0VK
         oV0QWn8gDczPcSjskKSJNST9ch4nbURhKcBSAy5xWjqBJ4cHVN+r4UtSt30UejxTbg67
         y+pRkpxhrA3KnyYiyTKyulMtRNDXlJ95HSWsXEELmF6afYZsQ9ABIpY07N7FGH3Tz1XS
         57ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721620; x=1796326420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jf5GtpRuXRchR2ff5N5v4AswDiRdBOtYpnk/23HLdl0=;
        b=QAotuOgVFMT5eyU1qosZUEUrXaZwtIEo8I/vFScbQLGYsHshVRXMSqDEMGkPOTSxfY
         PdTXmsghljvmgMs+EwLTh9IPUYnvTuuWOWLdy7N9NLfX40ajI7csrKwgnIX6IQJqyfW3
         PhWgq8MONxAzH7s3immMWxxCk99/+u3lSp5y6VB+UzmtCToV4UDpopa0maOp7bR29iG5
         LixoDzYuRs94MX/CCX1pQmvKdGCf81sGWwaoJbb1Wrw4SunEVhDN7lmlCmtDO2lmRIQ9
         5PXiHbh15zmwoWNWE86KnUsNmGgojnZ9icU62+LTmn7AdQOKg3BP2/eheptXppaCFpnE
         Fh6Q==
X-Gm-Message-State: APuU4Z/8BETZaOYY/wbRhbeb0H9zavp2Pcyrlty+QzeCx8QzIDDFVEM6
	B+jNXpmb1XLMcB+gEk2l83j/cezdBauTw97RDHQyBDqPbcODw2id7puX
X-Gm-Gg: AZFdTZczSMYPziAY1k6md3oiQkrgUsM4kU95pggRxZt0BovB/VZz6V5g/jCMhqTLE8/
	EdEEvfEnRYcySeWsPkephYcjobH7CoyWTR288IX6ZuzNs+5hFRz79vd9pvEMHZIs0ZPfxpUoyIX
	0/ljUGN9YnrvA8xq1tGoaxUeE0qZRBMxLGbxqRI6AoSqBWHxW6v3qkr4FWNkYTDx0couoZvwOR8
	i1GZuWf7/AKljfcVyJHxMFP+tLbxBfbIAsJaPDFzPuX0iFzd6/BVDrecxh0b6vrnZzerAlRMTlP
	0DfJTLqX0hyFu5ad+EJjDpkxcAb1tG4bdxJaRuygxJqEPRoICCSLLfqqWKBBa1rcfHk7ZxiCxyJ
	GMljQolxTO9wyTUk+6JyEDhZSz7KLwagjWJeYEj4ukmPDjM/Qs0StgDtqSDtRBoPGKxu8TpwSFL
	GMcn4Zx8h//3w3xTca1HxX7wK4sZeo4tJQ55PwbyN6BzXZz610eKJ7rXyDSG3oNduB8DETW0dDF
	KJXK5OtU4yq2EDpivHAaMzEqT5wjqCMRBR04xvgaH08+/abnbRgHXKsVzXTfHFr7D87Arn+B6Fv
	StPIVh+KZhG9OvmDxTJNym5Ik/IGNV1TqUyHWo2jy/XbZ58=
X-Received: by 2002:a05:600c:1d86:b0:4bb:6a5a:7824 with SMTP id 5b1f17b1804b1-4bb8892099amr474464105e9.30.1795721619820;
        Thu, 26 Nov 2026 11:33:39 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:39 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v13 24/25] arm64: dts: amlogic: g12: add crypto node
Date: Thu, 26 Nov 2026 20:32:40 +0100
Message-ID: <20261126193241.1471372-25-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Romanov <romanov.alexey2000@gmail.com>

This patch adds a crypto node declaration for Amlogic G12-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 3135566df880..df1383f86366 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1742,6 +1742,13 @@ internal_ephy: ethernet-phy@8 {
 					};
 				};
 			};
+
+			crypto: crypto@3e000 {
+				compatible = "amlogic,g12a-crypto";
+				reg = <0x0 0x3e000 0x0 0x48>;
+				interrupts = <GIC_SPI 180 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clkc CLKID_CLK81>;
+			};
 		};
 
 		aobus: bus@ff800000 {
-- 
2.47.3

