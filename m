Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04EB386C08
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257548; cv=none; b=esW5nedkSMqqhLVNAVMS42bcY85SpbBa9r4/jzxPCg8vIw5MrCOsEKSsALIK4KQjiUkPiKzmbyBPCYZgkf1RwPSEp/8MfN2qPp0tQJ4Z8HuRaTB5I3KFFuhUfl1tTONBnOjRR8FYxtV2DAgHO2ENIuk7ypLiFzhGZp8aE7WT6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257548; c=relaxed/simple;
	bh=EwhmDrGZNvqtgUBvADKeZk3zEc+b1+NVILPNP1cvda4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tTIafJdlgV9XtI83YUh50CApZcPcyVsTLZu+oDaoQVa86ldW3JjR7mq6sBLTusuTRDFoxKV1YFTaFxrH5Jb7KpkIqsY03P+tZHKYPkTogjCQUdApvQMt665wXFd9HA8D9dkN890jBrP3vRx5+wq64/lCGNN2PUV6p2PhHmB5sXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V4KqKWT6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q/4bxm29; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V4KqKWT6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q/4bxm29"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N73NVP3531601
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	o3Bop3RZU7UVuQL/J9eof3yYKpMt9O43PmyrVI9D8cM=; b=V4KqKWT62WjO81B6
	xG6aE7zIzb6QzafsgDa6PaOTLYH7KwAJUb9fAlL89r83lmnqM8LgXqRfFq40eqew
	7OQOF9ukcTPgjkaDucxQauTCjkQzWzHvHf/dZ1rzje7Unpns3pJ6BzTl3lE/TaxP
	ae8Z0tPRayUHpUKiQpXhkWok2i8LTGgUfL+hla/zg5iNTgTW2OaZG+fO/cbhze25
	8ALxip4erGdaDr6SvENZYy3RL+TzmpRRPcxF9p9zHUTcAOMdmeEhWLyj2311P5nr
	Tb+n3uuCljmS0ZWRsdKLn8au1EsA3d6mPWHTc/nTuUtZxgUkiSeF5Om58oFLmXDO
	C4ttaQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d2ca8jmbw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:06 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-359812e4fefso4029427a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257546; x=1774862346; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o3Bop3RZU7UVuQL/J9eof3yYKpMt9O43PmyrVI9D8cM=;
        b=Q/4bxm297IpKukc68kSSmewZ+MHpQ34nKuATDvDqjIw2tm6AvOqQ6DUYRmX4eIUZ9Y
         lujbr/VX2ajQzRZQvmHySmxtHes51OxRvEnf8DZTrCORVB9Ni5Ubm3rZOY8L1TgMLKwp
         RmtzogORV+1qwHasjwBbb8mb73GjZmdfCBQnVRQlKa1yZ+BzXwKVWLy62CKglJhTx3Kq
         w5it9EKQhuUUyqYyG+qauffcnhQJOLpbyiO+UZfsMSPHQHqc6H9IozhBBitkGdfYOp15
         /GbXw6RWVExAgbyo3JeOWq/fGwvkr09oR2zbsaiFbdJjQ2YaH5DI4IyJBmTu+5oIn+9r
         AJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257546; x=1774862346;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o3Bop3RZU7UVuQL/J9eof3yYKpMt9O43PmyrVI9D8cM=;
        b=kH+LeahUcHtmQEnOM22dfx2/8zomZBOLyprJ/7lDCoK4sqkwefconmRhLPjU1+NypN
         e4mh7CHaea1FQP7JT1w1qhBbkWS6W9HaAgQTzlWIalEus3qqn/wirWPuw6Cr5K44IeaX
         Oo1xESyO+sMWn/DCKwgnANfrx9S44cxaK2uOm2DuVpZo/rbjhHrjWQVAurnltmo0XmJy
         AXvyvr2eIOPM272owhMsE6JblbTdSM+QfYNNmFusdsU2yH/9ZmaxLNDauMhc27MwDnxX
         WaKoQYVkhvD/ILa1Dacg23TF/htxWSSCWlWAjMFH8nkhWSvekdBQOJsdIdKrU5GCGTIM
         /p7A==
X-Forwarded-Encrypted: i=1; AJvYcCWTq86ZKbPrNEqTkzf7WDqw9dpIm1vCrEKNxw1IDPGH/rGo51qXyneClMXQCtQxb/CBiu47ZWXG3SIuHoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxihPu7VDNkYwXLRoKiGqYt/NWGKpTZdzbyxL0uMZYj2gSvpcCs
	HGM4jc6RFniNA62krJydK1yw2aA7FEZGkTBamGeTDgBPM5lpFR98I3zqRjBs3GKtfoTnbvauhEj
	cT/HkSyDNVuiZQ79uJsSKAR5WO85sRhmkYrH1QKDfYMYdqHAxQT3IfpltrdfrQnObnPo=
X-Gm-Gg: ATEYQzwjGAJOrcC2fdIye+BsCGyC6M58FBuyjhvHDBpOjX658PvjfC7h5iTqYd1d7az
	QuxDSR49eaPtVhrWWc/Sa1OlvHrGCOWy02E0vpAI1yKjX2DE4oQ4J9N0p7b7QRUbrPewT8Yc7lp
	XhlVlOr1hefSMZgir/eNffv+wn23z6eAXfCaAOmPiVBC2dv2NTzgQB8hr1V82pwK9lO1UonUbRl
	T0FXG/HfaSNN0nkL9FrKXOSbwD7sNAm3uhEAaUNTkEDwrKRH4cEm2S3ri9axeeXCPUwPwvB77xa
	2DIzbyNRTMkAch1h4LzMKP+ji5KZ21NgfjoqN8pHxMQENPPN5QVKRfOANp8WIQweGGZTApus97C
	toXJY0wR7AcxaLFzDiHM/fIvqmTt0+/ycEB1M6L4bDUl5o0c=
X-Received: by 2002:a17:90b:2e07:b0:35b:a0f0:8327 with SMTP id 98e67ed59e1d1-35bd2719d1emr8246526a91.2.1774257546300;
        Mon, 23 Mar 2026 02:19:06 -0700 (PDT)
X-Received: by 2002:a17:90b:2e07:b0:35b:a0f0:8327 with SMTP id 98e67ed59e1d1-35bd2719d1emr8246504a91.2.1774257545762;
        Mon, 23 Mar 2026 02:19:05 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:19:05 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:47:59 +0530
Subject: [PATCH v4 06/11] arm64: dts: qcom: sc7180: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-6-e36044bbdfe9@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
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
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1472;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=EwhmDrGZNvqtgUBvADKeZk3zEc+b1+NVILPNP1cvda4=;
 b=vT2/ftKHtEaH7CUVN4lWEQEvuEdYuuSb85FTBKC/vZ/b9t9mf1oHpDvFgKk0blZK/KoN8A6oW
 a+0dbhGyUiCCkCL31W+BaHE6h1JgfLujox9nBV7lg+XBhItpQx4z9Wf
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX+h8naN0nHatq
 Ju39tejn+bRTBXqxpQ7Ia64H3uXAjEqILIaGAcf5Xl5jzS9ikS9xvD+km50z2Nns906PQusHlIp
 rZNsh07G2+PHhgAy/K3R56NUPT/50ZHR18hGLnpoCEj0iTSA0+n8pfKId3Ib2dK+/ekcQfXv0sC
 hiDvcnNVe3qdddjPVE/CK6TUMRDMpkv/f520HSwIWMXrsQlwgwVHtqVl9Q8YXUZAZSk9xsH1gpg
 2Vl4zma1QHCh35AR8AhjEAOItufRm5WrDK5tQRKESXKkX4+2NBFXuOWRrPrMw0DnfzXWTh1vWyb
 7/rFQDsmg/rJpzbF3+OMSSt1giTZOItlcCEouQA/DtWxJxb0LvX8tGeFyiZTfLlHwyzMRMwKnC7
 PZLK8N08NBm3j0x9gT6bRPY74AhuBEHHmWz/GMXpt7vpIi/O2hzsr5hefa40dxJ/yqWIqiIOfEQ
 2FSABEHn5Edzb4p0rnw==
X-Authority-Analysis: v=2.4 cv=cf3fb3DM c=1 sm=1 tr=0 ts=69c1058a cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 81LqAdJCbkIVBtguGnUY8egSpquZmTod
X-Proofpoint-GUID: 81LqAdJCbkIVBtguGnUY8egSpquZmTod
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sc7180.

Fixes: 858536d9dc946 ("arm64: dts: qcom: sc7180: Add UFS nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 8d69225a4271..9eaee5dc824c 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1605,7 +1605,11 @@ ice: crypto@1d90000 {
 			compatible = "qcom,sc7180-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d90000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		ipa: ipa@1e40000 {

-- 
2.34.1

