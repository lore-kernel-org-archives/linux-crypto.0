Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C90114AD17;
	Mon,  7 Oct 2024 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728307971; cv=none; b=pnT2NZcTLFESsfxD/XQo806ku1Kwwap0pRHYIrupI6FODfTa2yQiYgrQlDKLsw8yLU9LJbGvW4h/paxlafdc2YGBZzAXvGm8ci15Hc1ow6aXI5ODfeI3U0/xQbNjWqMZ7/ihWrbumgyPHMYgFLarXM8puO6c2JK7x0/K0OR9ZXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728307971; c=relaxed/simple;
	bh=PFx9f1Tnm7BVK8PDs+lrbmOWcpFk+mbvlLZOtY/CyQI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UrRRIpgbeCFFiwEN6nfAkHN2690SpF3ryeX3VjzwbT5gI173SOazHkZf7f5twbHGkCS/QfpdUv1XaG+dNZ8nJQ49LWTuaA5WWTNrURhOCGlPoSpWXiLy7bYM6lGE9PcbixEwufe6OafIhKTbZrLEuZf36JK25jt6NWUKANvdQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=zUfwjcCQ; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="zUfwjcCQ"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497Agrgm006897;
	Mon, 7 Oct 2024 15:32:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	xKQ8+KejSv5zCIILbnJcVY8vIedW2kPb2Uj4ri0BLZw=; b=zUfwjcCQPqf3zzuR
	MCzRCe5YqHcqJx4NgSCSNpHDULO/w5wPZqhHAkuGJOV1zIgjA0PKdqlW6+nIM/XT
	Fb4ECgIP9HSU/NHWOHS8ZzQp5SvoTQpH9vmiIaxbbIlbNQYR7RlpMVhhFLieR+aF
	d7oPYeqzJV8/Rmo2DX6HMN2Ra1O7G2NQWXYtndS7x8ABbseJnWtAeLfmOLTcL29e
	Ena9I5Lsz6z1wncncHelgc59dXQiiRRrEEegAXxD/mVyeEElCvkv+5HcXfczJ3N8
	vp6hYV8otfTyr43sGZSEjbX+I1eAt5ROh0HVoqGIFGiX8uoXJD4IKbCKgKALjvKK
	fRKV1g==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 422xv714xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 15:32:15 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 7D9E24004F;
	Mon,  7 Oct 2024 15:30:40 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 78F7527E2A2;
	Mon,  7 Oct 2024 15:28:58 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 7 Oct
 2024 15:28:58 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
To: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof
 Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre
 Torgue <alexandre.torgue@foss.st.com>,
        Marek Vasut <marex@denx.de>
CC: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yang
 Yingliang <yangyingliang@huawei.com>,
        Gatien Chevallier
	<gatien.chevallier@foss.st.com>
Subject: [PATCH 4/4] arm64: dts: st: add RNG node on stm32mp251
Date: Mon, 7 Oct 2024 15:27:21 +0200
Message-ID: <20241007132721.168428-5-gatien.chevallier@foss.st.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Update the device-tree stm32mp251.dtsi by adding the Random Number
Generator(RNG) node.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 1167cf63d7e8..40b96353a803 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -493,6 +493,16 @@ uart8: serial@40380000 {
 				status = "disabled";
 			};
 
+			rng: rng@42020000 {
+				compatible = "st,stm32mp25-rng";
+				reg = <0x42020000 0x400>;
+				clocks = <&clk_rcbsec>, <&rcc CK_BUS_RNG>;
+				clock-names = "rng_clk", "rng_hclk";
+				resets = <&rcc RNG_R>;
+				access-controllers = <&rifsc 92>;
+				status = "disabled";
+			};
+
 			spi8: spi@46020000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-- 
2.25.1

