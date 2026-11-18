Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794993027;
	b=23caL6PnyvoK6g15/EYl0JJbh87xGCITVCnq55c7hkDurE08/byF2dqJZunCp0w69s1m
	 FNXK73HRAqVfmBtwrkOLaz9jeot62ELiSEkHVSS0+rMC/KmD75ijP2+GbJ8OdxpoBXLK9
	 rUxYNzdq4EQVhoeF6AJTnrSEYV8cYEvJ0x/xRlybsJhSMMOctvv/xtU6VA+Mx9Oq4zqx9
	 OR1AWOU6lc07aDhW2oZbDsIIUH/ji2NC1YEh7t7SB5Ik0bObNDUJznSSVTvDDytYi7h8B
	 b0hp5oGYnuu7cS7ZIBQ5T3iaZq0lQOZDh8IxvE1XOu0xXAhvKzYB/N/Sx6XGYuYrLdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794993027;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=;
	b=HKezRyJE94dop8w+xt61/Q0ZbqCO1bdzLcvPPv6SLkGeiAftFIo8KUMh3eQKDWBHNJkM
	 a1LGj3WhNKMxxV61M7qioHXOmM2leaAJQI3ZmLhf8o72FiUiYbzAuRVoCIekk8Sq3LDq/
	 gX2RB9LFpdyVxRuzLEBtNCN7n6EJNic+8JHxqHWkUCQ+gd3PaFQlTtEOGcjEcQnwVt9up
	 9sTTZKT2MsbbCKkR2X+JBWTtbr4Aw264S2pfuJqhtvGkZf7CqwRL59ujcd3c9O87bsT2x
	 ArPY+XTdDl/hZOa7upfqUj6XD07pi71kS07NYDi+etjuboybi1TsXZg3dL/PYQYI9Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oMtxz6KY;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=P5HqC+ou;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1A8606A32F
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD1A8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oMtxz6KY;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=P5HqC+ou
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI8njDf2453598
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=; b=oMtxz6KYWcja31xR
	n1D0Ify7bz6aTMRbYaWu6axyjbD49U8VQDW2KrP5Lz2J+wQXcYlYIk3xtco9gBPH
	d5dcSCS2pdBpAIbpdC1osf2XKPfyADntsSABk0ADS8eDWpuyaNcrJs/cX2rpl+Qr
	gDiGHaW9JvS2bLpml3Lt0IANBI4cGQjal57utEblcSq0OtLkseybe3uSAD3AwnMy
	m1kfsitbs+yCdMszewbqRnujw/JrpD+jVdL6Et1VB62UpCDaxmVlZ802dhEyLXSW
	grB3BxJ9FqCuL7pZnSLWpacVZUOFWLvfG5JnOl/X+J3qLhZLQS9qUcGyPysV9FLI
	LuvCzQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv9a6rj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:25 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2efe8f2bdc0so7362375ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 01:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794993024; x=1795597824; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=;
        b=P5HqC+ouW9IZ9TZDdNmPCn2lutoHXW6vtKk1qLVC2pX/mBNDKJcj4bbUUogptBTAvP
         NWCU5QTVMxOVlhaQB+ffl0hOQESn145ye4DuRzfR9YpciDB6rg+5mtsSb87Gd5zFJBus
         a4lQs406sJiDeMsuGBVhr3IZL8ShcMOioiJ4b8awhQfhYCHZMoR68HyuzOiO4OwHYvVi
         9efPs+fhrng86hcavulKVbDrBw052kOYKu7IqibQERoAvcaj+ErJ/rEZxMbt2zELH99A
         L4Tg1Yz8TemB3HMyyUfjcFxLfMm2nIfbvhIt72urRMhEQlBuXvhGoeVT1oFIxkAWu/2P
         7Ozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794993024; x=1795597824;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=;
        b=inFQG8/5vXh1crpZEBp/rl8wsQuPnfr6dzTvNOt58w23lM4NbM4Q8D3/qUj6ZL8b4N
         9u9l06nkFyYS2Yr9fi1xEe6p5TXWX51UCFmJLxsfjpwLGi7UmZuHIS82JpHcmfr1fx3X
         Vcg8YkWX6duKpR00szipMbewF4osS+D2QATo2R9F9iVcof35kj8lSgn1MW7QkBSlLRNU
         dLTX2VeUiiUGxM/UDkzKq+1CVkR59CuXsvCaUK0EI6qz/J+P3Vx8PfkUcqnSCaVHfDJ6
         +MVYvo1BnAHFCLaJkTGRW6YqZm09g8kETH8yc6B5co8drudzzAQ7WcyDRrUjajNt7X5X
         gmsg==
X-Forwarded-Encrypted: i=1; AL+hErE8//+d+FYcBoxGPWmGcRib/5lbVAc4s2I1WhsAgPAZdNIvZX9Fsdr2VDcFWPDWjhhR6Nijl2xyxyZBZJM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9pnrhjKdoM1nek4qV0fUtbS8yB3e9SsXihNwz+YkyYI2/ZIj74
	vP9ARlKORgDdnDJfEEl1HAeYBh9j7l7fgI7wUGuvB2f5e5AoK+Q2f9fUq6NvwDEKzSZk/Xa83X9
	aZ1qBY98u7c9kKQYOQBmARmRk/Rh+ml0PaHCKjkPbsnSCPZJUtPb7rPts8ZPIGQfawEg=
X-Gm-Gg: AZFdTZck6Gvu/Hdo+7s1osVJduQ52BMZjCKxtTCDLHnK01eT2nskoNFqsLBI8OS100g
	4eMahiMRVgb1KrLO6h9v17eCL6fbNCNHsu9eZ1cHWfT5lHcLqThn8ksArq+KPHNGiGDxtFIHUhc
	JskwwgXMvGiGkL4xpNQyrjxneod0zU1SyJrVg9vWiXZ5M0snutZO+Gfu4yp4G5n/g25hApcVr9X
	wXYKvmH06wcS/bGdXyR3Rc3vbnUYSzB1JuxzLUuizGulBDujyfLnQMEeVTcvXW8fG25LU4DSQfR
	A7XImZk/rSJ4MnqxD4kNn7JLqUWZ920f6J2HnwtTkHw654g1m8UcGl6dWOqY1SECBMCG6NfQHfF
	I5wSUIS+U4XywHHufdrKAIiVy446oeA8PhnSc1wGd2jDWyio16/BNOcTZXmk/ZlLBW1f7prXe5m
	s8a2d2jOFlsUtoGZAEhoY5z5y1InVzGshXyKTwd1nmxnR15A==
X-Received: by 2002:a17:902:e84c:b0:2e5:4604:c375 with SMTP id d9443c01a7336-2eff75368e5mr20617745ad.48.1794993024394;
        Wed, 18 Nov 2026 01:10:24 -0800 (PST)
X-Received: by 2002:a17:902:e84c:b0:2e5:4604:c375 with SMTP id d9443c01a7336-2eff75368e5mr20617485ad.48.1794993023963;
        Wed, 18 Nov 2026 01:10:23 -0800 (PST)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff62e1295sm10147735ad.71.2026.11.18.01.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 01:10:23 -0800 (PST)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Wed, 18 Nov 2026 17:08:53 +0800
Subject: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 Glymur support
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
Message-Id: <20261118-glymur_ufs_ice-v2-1-7ef4556eea15@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794993016; l=1009;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=d1zDDePFJIPVs+rwiQvZLUWqDZvC4Pb/+gxCqJ3DmHU=;
 b=buaRCjhuEH1IwE/xt2SlTyKymGdd968htbzKbSweircy8bDUw6FMW0PrEjd0nKHgnqg7E8zv8
 pqSE9Nhyg8gAyFGeyA1By5aZ4fHHOhOIiI/ZRlhJWgq324l7pnDp5qG
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzNiBTYWx0ZWRfX9ANoXqqsptPQ
 HXuPqInUYlepuvxaEIZfgDbc/s5crtxSkNAuRZf75fw5hnSuWwr/VoHVMhwpZVbkUWP/1hLwjff
 X8/a5UnIZbJcFZxjqMoNZdMdPpzP/Jw=
X-Authority-Analysis: v=2.4 cv=acT0Dhot c=1 sm=1 tr=0 ts=6afd6b81 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=B4SCuiGsYTXXqFn_0MoA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzNiBTYWx0ZWRfX4ui6NHGB2toF
 CCf+DSt65jhspCq6z90hEJRaKEbHS+tkoJKLkSk4mqO7sfxUgEdNauW+wBN1m1nCN8ohxvEh/7a
 u3yhVqQMY0/RR9jQiT2Kissg/gHwSsN6VbTKGZT+ExsdJQHQwbDUYlyBW0MKCky4HItN/rmBR1S
 1WOCXSp1d/FszRb5LV3mPh78bReP3Zie9y8YIvbQBNXb5e3mLv8gY29Pe3Hrph5cJ5wbIFqRqfe
 eKMUPYnWCyNrYFZvbr73S/vgZYbtOiJ333ZfEkNmVxl6wOLyfgokcePdjttLMmmdQogMgbrFEwy
 e1o5SLjE9Z+BDSXV4UddnGgJ+a6rb8hOf7nDSiAWwNVpObAZobZbJO8XJW7KEkli5w8SADdXALb
 zKq9vZSphMLEt5rPVz/Z8Q99QR4RB8haX/F44bsSLI5C4XGXm8MyqU28Fcs9oeBo83uVJ504+5D
 SmX0nWYBgZJnFy7to2A==
X-Proofpoint-ORIG-GUID: sgm0LV_s-g5LgC7CzFnptkbSZXXxSJPH
X-Proofpoint-GUID: sgm0LV_s-g5LgC7CzFnptkbSZXXxSJPH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180036

Document the compatible string for the Inline Crypto Engine (ICE)
found on the Qualcomm Glymur SoC.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index b98c4c6b77f05a4295b7225007187a7b05387338..01a1a36652d759610e36d5ac3ad56f4b2d45b96b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-inline-crypto-engine
+          - qcom,glymur-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
           - qcom,ipq5210-inline-crypto-engine
           - qcom,ipq5424-inline-crypto-engine

-- 
2.43.0

