Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794993031;
	b=ZaSRw46Xb9kDAmNtfeCaBpUle5dJ8GX6HFYQ8Zv/k+QwzDd/XA56hR3WOeJfh5pUqCNm
	 MPbUf5pv9KQXIzTHPXLIbewQk1WaBZ1sUeA6d4DHXKkMajP3CiNZn4z0gFkgSDJm6/9zx
	 aJETJNpn/W+6Xny/vvR9XzDjdn7BFKK5aWSTbQZiuiA4eYVVDfqlrfIXHivZbSAv6XVr3
	 GlEys64RpvFU7+DrKa8Ef4rQJH/CVvFO5aEYkp63senWH1OadrH1aFVgRCj/FOBj+bbVe
	 WgHuIGp1s3Yc9l/tVxvWEJXzfwLUIrd4ZOd7k8WuAO8rTSfkW2/l5sS8KjQxbBeMOGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794993031;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=;
	b=Htn26lgJrItCWbzFG7MVNJSaWVtRHQHoZCW/QIXhmxDBPwQ1QGbCaRRcKB1ToiJ64zfP
	 nivHKRg6E++w80Mt84KgHIpDIwED2qwNyV/yMTULz99A4CpIa0wWDeKfY1v3EvpQZKPxS
	 sT9Gr3ZtqYmTWGaRV6Jrkui8uCK1n7Lkjkw4/J0Ezz1+W3IHDKBRYw6tgM1zqNSfuRgYn
	 PW131OPxffA0wDIjwQBPLHDHRD5xgULTgsTj5LymG0RtanYYJqct44sOuLT5kA8Gy6qSo
	 mxQzdr7EeQtzhqjOgNORDBc+VI0Ix/JZuwWw/t+Tzmn1RMfmE3H5jJrfjtg1xGQsuFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bzWIkmGB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ReDZ5dlp;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DCF606A32C
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76DCF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bzWIkmGB;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ReDZ5dlp
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI7UjQc2648324
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=; b=bzWIkmGBQZ3kesgd
	ZClwoRb95eux2q92joKiuvvKI06WTv56ViGy1conYxZJzulzlSLDfGqeC7YmeZUw
	HQOUkP0RRLdXgMWgkh/HGXdbxaIua16fYOwNQg47e/YBaga+isP8mFF4s9Pe+gKR
	Upghm6atOlI9qQJXBhp3OmPuJp4PzNFyYvMZzrZqmtCkJ0gQBUqDTXRgHmqZnogH
	wO6l7iVkE3HyyoEw2IYmG1IFW5z1L+LRaHLYU2iG7fcqYXiNYmYCfCN1baCHVbko
	yCBsQ0FhDkBWLonlX6jRPpXiqzUZu1Rhz8LNRq6vo8miLc1HnqQbuUunsRMvqRmQ
	g7B2HQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv8j7j5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:29 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e9995cea88so6366985ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 01:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794993028; x=1795597828; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=;
        b=ReDZ5dlphZawMmWbeFJ1jjka1NkhGzxzuboSpDe9YYL4axNNTPycXnryVOyUOiTQXO
         Fg5Z/cM4tfy6qakSvloLJWowNWcTX5CSzaDmT5FPSSF90vF//Jy1ToA++UXr0N+fYVu4
         Vxju1bUiZmApLrQhDZExflhCNP3ePZiy/bLzCebD63COTgjRnJQRwu4kVLIYYAgyanbn
         sVe1TTyj4Jqdp/AXUBrbLtuIYSq5tv4qgcoYCpklgmCayrkp3BmFeiDumTktjXWR0iH+
         Z5fDq29lpKDNSCG+6S6C3P2tuiqyPwvTVNcLXmJ/gEsR3HNLlG50xl0rSdUDE769KHpX
         xAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794993028; x=1795597828;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=;
        b=eI7IrivZv7LEyR2yYaYZoChKYvrxAa4xpTfOnto8xIHuSvP8abQrpOLcBTwrnUYtZF
         E8abBbh9k0+2EfopD87akjO1QorP4vmkqOkEaLglbycaLdDJKSs0j3/nhkmWhO0WQJ0y
         gJkbtDqQqHax6R8ub4S/qJaCG0sZMDS30mn2NfrNJlqjjX1zT/AJQfEOrsqyLjWfEn01
         dAaTBRsWkVSaiS8xRRi1673OKHg98gcdBOfAwpVF54McgHIGB/B+ju0Foh5nrIHaDFhK
         XsalztvsdX9krjQsLAI4XmFFj12StQsBHDcG85BMH4afisnrgJtXX7aHE8z9uAOM3i98
         p3rQ==
X-Forwarded-Encrypted: i=1; AL+hErGrEUukzNZgx12AmDtkgxd1Fq9zsZ6g4YKOx+vAV3Jr8+Wg3qQyJeEeiWBF+08P5oL3XN5948pp6atkdnc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Sw2DyVZFKEOl69pKref4kHxTJHChubimsy+yI0IGfK8KsdJNw
	Ig9CcjH9lrpHnhwZX6smEPZQ5fsLrbUJIlB7M7EUhTqF9NYT1WpyTc7yHNQoNlXBrDYo2Z/DjPl
	WiUOOMQC7+0sRke8OqEQT8j5Q8mCc9HeEC6+ujQk22vZE3SIVb5La460EKa4JIvNJ9+w=
X-Gm-Gg: AZFdTZeKcEFcPleqYDkD2qYJpxl/T6EmBalboywXL0Hz5CtQAQOhPvyY6LFDiP5nxmO
	xs/DKfBzvlouThpZVOX0UBA361wg5GC8gwVy4w4kfGZfSnGCLys82AxZZR/tiT9i20futPofflN
	FBR7bXUMSm/gZx8M0sIoQWPp2MdJnbSIB9TdCc8CSKxrTibNfRFMfUKguKhjVE+oSFkaBR7GRag
	2pxKW8WAW4H0YHdfA/1iN24Fxslg9W8NwraXRde0faKEFbIZQyKRuroEtEskik6RdSZlIopHkvI
	rwxnibUQAb7Kx/ajPz1Gxapa/Cqx726v7tWucgNKaczoDH+K5EY2N4n0WomrkksBrl10RdiyKaN
	nEgGESpjQ4TV8kT9vwkKqwR18abrR84OodZZ3hQ+Cc5jjZk8OVfmNajzGQjyr7kHGkhJcUHn/BQ
	n/yJAOoEskvq6KDd7Sf4yWtHRSJThlRwu+yvXpKg6PbbQaww==
X-Received: by 2002:a17:902:f705:b0:2e9:5175:2eb with SMTP id d9443c01a7336-2eff72051dcmr17436235ad.1.1794993027856;
        Wed, 18 Nov 2026 01:10:27 -0800 (PST)
X-Received: by 2002:a17:902:f705:b0:2e9:5175:2eb with SMTP id d9443c01a7336-2eff72051dcmr17436105ad.1.1794993027428;
        Wed, 18 Nov 2026 01:10:27 -0800 (PST)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff62e1295sm10147735ad.71.2026.11.18.01.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 01:10:27 -0800 (PST)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Wed, 18 Nov 2026 17:08:54 +0800
Subject: [PATCH v2 2/2] arm64: dts: qcom: glymur: Add ICE node for UFS
 inline encryption
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-glymur_ufs_ice-v2-2-7ef4556eea15@oss.qualcomm.com>
References: <20261118-glymur_ufs_ice-v2-0-7ef4556eea15@oss.qualcomm.com>
In-Reply-To: <20261118-glymur_ufs_ice-v2-0-7ef4556eea15@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794993016; l=1345;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=KHd3LqwnyiG0pVhCXtBEcbPxB3BOCYgV9xgOZWJOkFs=;
 b=zqO89bLzqbljPJi3FQ4LuAp7tGhypuJUiKkSGjC+WeCfLQu/9XuIm9MyQ42caf+Ku785roD61
 1KpH3492qOsA+FJNtf4O7zYvC8MCQh2bY/kiIxuwlqMesE35rQmiHnD
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-GUID: XBWvlKzxYkiYOws6lMuQvBF_YnMNGzO8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzNiBTYWx0ZWRfX37PHbvEAF9V5
 jDp2Be1O0T8i+A/bTAlckKO+v1ljX4ET2bjqNb4Mo+vpZ6oA8eWnIDEzzChpATbW9xPut2OvigY
 SxSmaNWin5NVJNlcl8Tm3llraOpddo8=
X-Authority-Analysis: v=2.4 cv=c60+0h9l c=1 sm=1 tr=0 ts=6afd6b85 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=7g7wA4PAc6ioHu1SxIwA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzNiBTYWx0ZWRfX/NqlMb8tWVq8
 EPx7px2ZNoQc//CYFdAE5+NiEBIIi1lXpEBEtOfeV0MwCzMuwN9rVMma1A0k3INHm5/c6fvIIwj
 u5iwVTOlLtwndYk3dlYFciqK2s5Bx+QvjwBXrS48hezjxZBQF47eh3l7v52sjJC8dbJ/VMNl1gC
 U5vZPJL6KGxNQp++u0RYA36x6moEYWBH5JKTHtnlld0cPW0A7pFGP7TM7RrI+5NCcG2jEyCUHc7
 g2NEj08TOMNzN8zjYSefZZ2GcDa6a/PF2dXqOKyzVeBAc7aIA+Paal+4ofaTw0tzRSZ+Yj1VLsm
 bs3phW09TOTAEE9zKuepu4LHu12HaCpSeCx3QwnpNT7bw42cN2mW1I0TdYZjuBiuyewSB+/Ba/X
 q21rYZLe9E5wjWXo8ATvufN0G1NXGW2uMdTjtzwhDCe/aLvbBnItLBm9XKH+9k7H/h0W3D6Q5Kv
 hFIbrwqeK27HAaoU2dQ==
X-Proofpoint-ORIG-GUID: XBWvlKzxYkiYOws6lMuQvBF_YnMNGzO8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0
 adultscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180036

Add the Inline Crypto Engine (ICE) device node to describe the
hardware-accelerated inline encryption for UFS storage on the
Glymur QCB board.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 165dfa11f17f55478cfda09c3db2143a1e5b91b8..ba949704e3b4fe2aa497873be6fa0a5cd2f3a1b4 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -4156,6 +4156,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
 
+			qcom,ice = <&ice>;
+
 			#reset-cells = <1>;
 
 			status = "disabled";
@@ -4201,6 +4203,17 @@ opp-403000000 {
 			};
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,glymur-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x01d88000 0x0 0x18000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;

-- 
2.43.0

