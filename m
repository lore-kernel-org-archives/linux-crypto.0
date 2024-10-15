Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004501F7065;
	Tue, 15 Oct 2024 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011087; cv=none; b=RKtQKERJftPF4OYFAMYIFjfywlWUnvToO27Jc+m+puYC4YVMvCF0ivSwCP9aOBSRHoyMbwV+VjAwDs4ihHvWujXM8E9Jkmwwlm9v3nK116uuyXqi3k0gyW2RS+vN51t3zGpm4pwqXiQKBuJ71irUfxe8Jm++1igTCTEHhgIl6Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011087; c=relaxed/simple;
	bh=OoWOGY/fJLZ3KKu0Dz/9OyTXJqtsYBG2qgsIrKosHHs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=oG34/aCWGhzsQyNPqjtc1PW04flK6qTeHJ84UYAJUtWi4p5WQXKWCCf5iOZ/rmL0zjC9yYbY3WJncfRCbWgsJQjo8IqHExn/j9cnR4vgQ1kUqKcPMEGzRxYm8KEBSu5TylG3tNtDyu0a5jLfZnFYdFzXoR8b4bs9lSbtyK2v6EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=Sh1pQUUI; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="Sh1pQUUI"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FBua5E011443;
	Tue, 15 Oct 2024 18:51:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	ujwJiGYrgOTn+uhgNNQmIEEtl3sMpGZHZQWu+RiZjSY=; b=Sh1pQUUIkndlIRu8
	lnK3QJWW2JYveDv0Kh7cdjpZCSCXjxlSePLEayPb3PNGnT/ug6w4YAeO5U425j7H
	5yQAOC7Jekp1TwxpdmGDQHU49NurOUL9XxJeYnLNR5XFSxHcLzUBn8a12dp94Yky
	9kzU+5+Er/NxoLdX6NaCzDY9MJAKhWSH7PTf0ARMP7qCn+yojagABP/uIj42x4ti
	7JtZsDlA2PBpdmlA6/N1ex6O6ieIB9ASgsgKUU1KKBYe4UIQfBj48XI7uNNzQ7iN
	CclkkIpkhaO95QIta7/Z2hKu23a4osZrX9OMcnSo5cLo1bfze8oaFreix2wFz1cG
	0Vn4KA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 429qyb98bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 18:51:01 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 5D70C40057;
	Tue, 15 Oct 2024 18:49:49 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id A671922196B;
	Tue, 15 Oct 2024 18:49:00 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Tue, 15 Oct
 2024 18:49:00 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Tue, 15 Oct 2024 18:48:57 +0200
Subject: [PATCH v3 4/4] arm64: dts: st: add RNG node on stm32mp251
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241015-rng-mp25-v2-v3-4-87630d73e5eb@foss.st.com>
References: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
In-Reply-To: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
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

