Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98472188CB1;
	Fri, 11 Oct 2024 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728661679; cv=none; b=NQ6J39uvJ6OuHnyOsJ5PUgZD2u3/vuBRlFJWRsKhbozu9PC7Tvm1HDe2GdmG7u7DZawoxZo6JYeoF8NtC29Rqsj+JpcrioOxy/2YVH7A9C9jixQvY+UJFwYTze/pR1J+G+YEo3ubI5ix7tgh1aY1hLrdivVZ8dD9AcE7C3HGqgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728661679; c=relaxed/simple;
	bh=ndRqdEUqlqoDLYoq/DyZovcBsgKifHrEueihar37Ea8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=LqzgHz1ve8NJZrNQqrbcCwQdsJaMiljM//+l5sQYFBPTPhtfozydQYvzLwGg3LfTfpVhp54ghNV2P2Luz81pYIENYSa/2L+WZVruDGFIsKqkr9iOZqMwf4yv0uGjbBPv90QmWMmCicZ8lKxRP3aFrplk0Z1gghhNgr735Gv+7Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=ERD1Z+nj; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="ERD1Z+nj"
Received: from pps.filterd (m0369458.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BCZZVH000599;
	Fri, 11 Oct 2024 17:47:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	kxjVQ5QlVpWbTNWs/BiZxzev2jarsoMh2Wv+B6YsV/0=; b=ERD1Z+njRiE1sYOu
	fPo44S39zhqYA0IW6NGtZw/mWje1L52ALGTm9FugHPn/EuQ1zosrFQRu/K71APm2
	tWX1bF0XJZwIhgq4UVwSEafKegtuSA0mnASIEvsL1LjJ0SU02kvxwvd4Ue4f5dUf
	NmfjGi4pVgDr8TEy25AcZSm3w3uskZ9NAr4R2I5sijB2rL5KcvXA8jVudFsr9/Dg
	bug4T4n3tWDUeaSazY8OPG/kljHyXR3eT4PJ9Ekel/sH8stJkaPoisvBOqPz7yRA
	KGUZutd6//hHFC49t1mHyR45RK5HRlKHEqrmzeAu25w5EVloA3gXkL3z2Yl5GTJ1
	qHs3cA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 423f11da79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 17:47:30 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id AC0554005F;
	Fri, 11 Oct 2024 17:46:15 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 5780129E02B;
	Fri, 11 Oct 2024 17:43:18 +0200 (CEST)
Received: from localhost (10.252.28.117) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Fri, 11 Oct
 2024 17:43:18 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Fri, 11 Oct 2024 17:41:44 +0200
Subject: [PATCH v2 4/4] arm64: dts: st: add RNG node on stm32mp251
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241011-rng-mp25-v2-v2-4-76fd6170280c@foss.st.com>
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
In-Reply-To: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
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
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Update the device-tree stm32mp251.dtsi by adding the Random Number
Generator(RNG) node.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---

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

