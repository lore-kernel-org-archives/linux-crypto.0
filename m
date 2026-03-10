Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219103EDABA
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130093; cv=none; b=I4h8UAvF4Du71QdZeCmjGYlBTNtVtMKSaspUxwxPeQoFcZIj/mDVZfNnm+Mo2fQ/Gk0slrtNbEdRA6xKEI0e6cMqV6rvBKM6d78sQUvovmO30cPed09cMBI8klXi8PuG1VBdqKuP/fG7Huh8nMvqfrGps5fAar6Wp72LLh7HpBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130093; c=relaxed/simple;
	bh=i/zN6630ICSGfAnaDut73crn2lpipTOIb+yAdkPL8Zk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PjoO/nX4k6xKpSTWkHdqoASsGF8O47S2/rJxxbfZ16+T3I5BNwxUAr2yCG/qblk60omkl/djkxZSpngepee5BidW281N//k5K8SBTXpAPQ8mS5TGBgVjDBCUbBwByUuHBGcnpzZQe6MUvDEngeO5g0L/SBAOz9t+qr5fah9o2Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AUTEvVme; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LKYBmPJO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AUTEvVme";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LKYBmPJO"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EJAJ3754663
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FJtaIZqWtg5VuflBFduFh+NdHGHumImiPr+NGa6fjWQ=; b=AUTEvVmenNC9y4PX
	w3lyNv0NYDtIW55yEj5xXiWeOt1Mlwf6DgykMgzTOo9Pxe1VzG3uhWOFyupsnvad
	DUAcdSTCOS1cLNAkH+QZiwLFJ7e86xymep8dShFXd+ky/MvLVnnIyZFFEEdGU7w6
	1au0EvCXifeilZw5Qakh9SH27uaKjNiNc2Rt7bbnEf+kUMmEGZs8xHjNWaTbR27z
	qsVFtZzWGai8IRCQjENyuMuoM2hbccldjsXOpUN5iJ7L1Paz6DIAcfHcFR7HRdlX
	dOWxRk0hCbNDuWwFPRy1r/x79o0ebpwgOA61oh/Yp9p9qgNOrr93Q1Mdml6WRps3
	yjzQbA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct477j56g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:11 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3568090851aso72761280a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130090; x=1773734890; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FJtaIZqWtg5VuflBFduFh+NdHGHumImiPr+NGa6fjWQ=;
        b=LKYBmPJObZ9Jw6lq+N8WsyPJfc5zqhri270LcDVLPisdFxaaV6OBI8uj5sCMk29G29
         AoTGo4orfUjdIjsjZnlDCGj3YEqYdSLB6K2pRRPjjVzoVTRWjTIrofY8wxJOn4bcbdxG
         35+LJYwPfugOpR40jD2NrMr23pTi4dkJTE88/expKsU8F8KvSHndgOIKN8l/4ImBuE0e
         rERUTFiR7dgLnnjn4yjg2ymG/8aU6Dpno4XN/ZLUFkO44wFbVp1c7Z5MRRvVgRVp0RF1
         WBj0VGyuk+3WJm/CSPjike5SCbNGu9gqYDbfhVtm8n9EKfUZ7NrDa3yJCopoDlREalka
         /2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130090; x=1773734890;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FJtaIZqWtg5VuflBFduFh+NdHGHumImiPr+NGa6fjWQ=;
        b=pDQFRU479/Ov0wtsu0/aUN76+pFsHMPt/L9pCkGhEhxuEyb5TbjpuGhCezr6Guoq2Y
         0BPKkrtrjTy8xxzl2ZiJivSxreWsyh5DyOZWr54gOlcdj8zy2MlKKyf/f3VCLE5RyV7Y
         UC0itvYvFtBep7SGqJIkqPFtyozRLVjI8dA3QDaECVqtOahp6KGkeJrFEiCSwgDcyy4n
         9aT2OMH5AtwU0hkpnU/IQp0UK5k9xCH2slxDytlL+jBNt6QDXgTHlgmCXuqllO5xE5vl
         BBd2NyqikdN2wNmu2BEjF5ElajDMgbqQlKzq3/L2oYHRNJJu1xPFYPzhcmQnbZzEkOKN
         VIMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwYaBO6veqUJaWn7uXBUGvGZ9ykSWnkQpiso4dsICROEvW+q2svjNiSTKBME1q3oQLG0UiuquJNIirBjs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1hh2hmO0h/fKdEAfhqlQFP8+dg3ciVky4NxHQYrruuloujuWH
	mlaDeYwysL1tv9g9ZUchDHGtTLD0qU5NCVo6zkGyNqERUaWX/AbCxJMv8Zko2phvmciemBIGbPP
	ujWPc+fMcFeqqIvch6e/CubZdrgpsE3O2XzL/jGtmAdtGmn+eBQT3zUEQE4gk+s6BQvE=
X-Gm-Gg: ATEYQzxdS/H7og4MRSVNmkAC57LhSxDJT3+Lqd8gnKMT6OL80CMFHYVM0k/mFx0Q5nu
	EKt3ktx/lbi3DZydNndt7A9/UHf7zMYExLhpk15VOim4GT9ZlmoHIkSb1Ez3pW0w3m0JLz3QZjH
	iKg9KA0MNT6XPvzom6H2TKERzxZLarzsSMeYfvL1ocChEiM6V4jYt3qKrcdOUKVG3v3l4IaVUM7
	/vACeE7kNvQZveQxZ/OlSjuxO2v/MNUCugWkdrX9+m6Xu/z0zRkQUvZMNerPEiT/K4MaL/6lv0L
	H4v1oJAqrxF6JCVP4wVnO9kbiSBoZPGE1kMwonPflIExPbx2Bup6Ds1JEyZm9lj1Ek3ROkDabzj
	BtLKQypEjJLKY40DdrVzkqq4iC9cCIN/MfEhuO43vRoGC33U=
X-Received: by 2002:a17:90b:278c:b0:359:9a25:d758 with SMTP id 98e67ed59e1d1-359be2ecc6bmr13879963a91.16.1773130090164;
        Tue, 10 Mar 2026 01:08:10 -0700 (PDT)
X-Received: by 2002:a17:90b:278c:b0:359:9a25:d758 with SMTP id 98e67ed59e1d1-359be2ecc6bmr13879920a91.16.1773130089412;
        Tue, 10 Mar 2026 01:08:09 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:08:09 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:36 +0530
Subject: [PATCH v2 10/11] arm64: dts: qcom: sm8750: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-10-b9c2a5471d9e@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1407;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=i/zN6630ICSGfAnaDut73crn2lpipTOIb+yAdkPL8Zk=;
 b=0odt1h0ELIBKQcJkrBiiKSIBIUtJ3/NO7QdVLhQ4nmNGVv1/zfaHVj3ZywxB9jPzUeQSJ5TLm
 3n+oMm2Yk/aBR+pjmKnFUnWSYzU0f10Zt+Sf0uiyyfbmLLTE0ObAA6I
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfXxaIdLRBLG2+c
 jJ3SNyAzWQ5HplXgmFX2lDqVIesgVU3+sqWJuIooqEEpaQgqCgLlGl2J2tcrhTVyw9ZDB3p2dRK
 6MGPgN3U/3HShSP/U401CFS3Bv6gRAhtxvQkD8SL5bG1//l4Q8xLtxf3axTNqvIH5+ERj9f2e49
 E9t7tROJTS57jBrWg7TGBzIANjKUPrnPmpQpQbjAQrds/o5f675UgkyBipPvVzxjUvmfrlT8wDD
 +ZumJeF0SpKN4CbmUx7I2CUCDCvxuAZJFwn8gTEhwFjMzx7ejIz2P0Hi/JHnUI21gn5YyepWu+D
 7ir+/7V9svhC8JkHjcukrJz6SMKMQ7SkOq/idD2n53BzWkrpg//AxZjKuHpps1MNcw2TdX0v0p/
 kgQbydzZDAVCrEh5pCfXE0Gii28QIeYKjyTbx0KlPbFOj+1W8RLVfvAVX8MAOx1wXDkpECo4c7V
 r9CzlmeEIFHFspEgUqg==
X-Proofpoint-GUID: E4Xg5v5MiAXolBwuO2YSG39InZ4zfRV2
X-Authority-Analysis: v=2.4 cv=KLxXzVFo c=1 sm=1 tr=0 ts=69afd16b cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: E4Xg5v5MiAXolBwuO2YSG39InZ4zfRV2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100068

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
sm8750.

Fixes: b1dac789c650a ("arm64: dts: qcom: sm8750: Add ICE nodes")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index a76bf5193a70..11352cb16baa 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -2074,7 +2074,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

