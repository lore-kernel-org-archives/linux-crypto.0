Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14E1D1F7B;
	Wed, 16 Oct 2024 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729066008; cv=none; b=Jw4CPiDcp1Xv6tv6fGzD2YuYUEneDgc1OUp8TWSYWtX1isYmZC/ha/9ILM3I9SSiPlDaw9F0CrGpu76G+i2jbnHJ+yzaWbzikix1+zBvXdBayiZaKO8IP17wzL6aNOTzcrnoLbVClyPWnEx5GVS+5fKNdm28p+eo/qZzR6o7n3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729066008; c=relaxed/simple;
	bh=OoWOGY/fJLZ3KKu0Dz/9OyTXJqtsYBG2qgsIrKosHHs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=pK5e41alYi9lkiIQjW6IKdoPRfDxlLYIlSEYN8qDJtFE+ygiUSW+IudRucqZhkhrIUNpIcVg9DLKjaCy14vQqXoB5W3vSdWjova/Nl/pgBO1G2Wx8YrsRYiUcAnSH/jJQcdI6YhEitk6fSmexPoMnDjRwLqyuLqHriP1lLdCUic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=khrtD/Mm; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="khrtD/Mm"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G3xQ9L011471;
	Wed, 16 Oct 2024 10:06:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	ujwJiGYrgOTn+uhgNNQmIEEtl3sMpGZHZQWu+RiZjSY=; b=khrtD/Mm7Y83qsgZ
	nO2AgP1P/1jvUN0Aig4IA70mJ8mKWH3sx9IHAR/ffZrB+cic9evP5DSRRYDInkt8
	8fOr9LlHT/etBg3atLTOI85tM0RjeFrAaFdiGKZFmOMecffj6qRY7dEujiQhJZti
	ws2q4C8jv5bmSsKQvT6dcHI6OPJi+tPJIqJGZiv0xFIruZ2RYstdgtaPOXPd81Uy
	69gK3dBMNgoYmui3LSSJE9I+L0vqmXRa7v1JhOEhIf9VrV/UGOS4w7dW0FmNPUNR
	HnwrX8cYhatCSd8amxvzXoEzXnQtTFU6qsUUqoKRazn7eCoyfardu/4vs7qdhWvU
	RPsMqg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 429qybc30v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:06:26 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 8113840056;
	Wed, 16 Oct 2024 10:05:21 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 29CF92347CF;
	Wed, 16 Oct 2024 10:04:35 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Wed, 16 Oct
 2024 10:04:34 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Wed, 16 Oct 2024 10:04:21 +0200
Subject: [PATCH v4 4/4] arm64: dts: st: add RNG node on stm32mp251
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241016-rng-mp25-v2-v4-4-5dca590cb092@foss.st.com>
References: <20241016-rng-mp25-v2-v4-0-5dca590cb092@foss.st.com>
In-Reply-To: <20241016-rng-mp25-v2-v4-0-5dca590cb092@foss.st.com>
To: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Rob Herring <robh@kernel.org>,
        Krzysztof
 Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime
 Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>, <marex@denx.de>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Gatien Chevallier <gatien.chevallier@foss.st.com>
X-Mailer: b4 0.14.2
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Update the device-tree stm32mp251.dtsi by adding the Random Number
Generator(RNG) node.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Reviewed-by: Marek Vasut <marex@denx.de>
---
Changes in V3
	-Applied Marek tag

Changes in V2
	-Renamed RNG clocks to "core" and "bus"
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 1167cf63d7e87aaa15c5c1ed70a9f6511fd818d4..273da5f62294422b587b13404b499b5ffe6c148e 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -493,6 +493,16 @@ uart8: serial@40380000 {
 				status = "disabled";
 			};
 
+			rng: rng@42020000 {
+				compatible = "st,stm32mp25-rng";
+				reg = <0x42020000 0x400>;
+				clocks = <&clk_rcbsec>, <&rcc CK_BUS_RNG>;
+				clock-names = "core", "bus";
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

