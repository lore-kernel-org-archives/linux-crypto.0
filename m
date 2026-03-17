Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB2135C18E
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739361; cv=none; b=U3P4nmJnpYO+o2gdsfuJvlTNDc/7BCEIHBKMgR1Bm7gCB1wsq5LgFGxIrAtEwnC8o8J4gp21F6lVLOodD8BRNjwIbPiurENXKzAS61CD9kwVifniJsXuINDQ01VodrqT5O5gTdmfrg9kHzqgdcnIP8O//H0dr3qMkVvOu+wYkGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739361; c=relaxed/simple;
	bh=vXjE20g2L0ZJQyzxZj8qyvW/3Cs1H+TeODfjjpRRFrg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qNcx7MeJE7QBr4kGQ3Jek4uj3k1+/lWIefkFzffSNzBPYsJIr3QPqAqKRYpalUUYHj5dPKRzvQ0QT6FhS2AIEa4lXhhcKh/bKf7v2yv1qpTV3hDBYmds5j1G4bnQBOTfuhAoQ/gFodyg935OJwp5WJBDfmNaao+Y8/h7hoMSu68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RHCG+Odg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PDlf0H3y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RHCG+Odg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PDlf0H3y"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H2AcEt3102089
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sYytFxuD86mKrnrbni0xkdSR0IRHqvzld2dCJ36Tg+I=; b=RHCG+Odg97U9OZ2+
	9OvlCF+J1KrgAGWBp2ISSrqEtLSjgaQUocrVMyXHPgjdeh+wYmhLK289DtWTiIOn
	olrdQPK/d7tjRbbmDO+nI1NiM3lPU+W+tcQXjfy9KoK4rZ/1qySHkuph8BjG01IM
	ZoVDn1wK3jxO90gCzf7ueo6EZ8wSeORe9BcIhZ4h2hUbummDOylA6fqsI1uAkk7p
	Wz59dSSoOpz7turO1qh7Q8CZYao2zdu353OHunCaMxJE1Q5KPKu2TW0JsRljMlI9
	ey6QYvoJvDbUPW4dBC8F34ZRB08bJDpklwlBzsA3wCVYSh+c3RmSLD6av1lkCl0K
	ibWAJQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxnb7b4m4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:39 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-358f058973fso7172211a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739359; x=1774344159; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sYytFxuD86mKrnrbni0xkdSR0IRHqvzld2dCJ36Tg+I=;
        b=PDlf0H3yay62D3yesj3nUnK5fQhhv6Ao1qO5v4gCTcDXPpzf+44gutNN9H0rMBIQRh
         tVmK+0PVGz1AjwnBuek/0fwuaSxPfY1AMs/LMyyKYhs3FesWGlNUKdOS5fvrZkLsS/+P
         /ATFPMoJSkQaJyT1a//I9OGIaGqJhnOTwBXcpN4luwgNYx8Us9+hAVXrYIRx8Stejt4I
         ZtVO8ZmC7ZLvJTT5NfvHUVHXfqIAnkcxdb3iGomUykFWwoM/XwBGizvxJf8XE90gqjw5
         Qb6Ft98h5TX8YzaFAeJWB2u/xfIEAfVR5HCqFiD/TC1y5VdjXFmaxMDVKGMRJt5uiNZb
         e+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739359; x=1774344159;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sYytFxuD86mKrnrbni0xkdSR0IRHqvzld2dCJ36Tg+I=;
        b=jpZWamTIdvm134hhBAOArqwhTKtRS9BM/9bwcim5qiuKUvjZgD1tXpDTEcuIiw7aNx
         SCs5droW1EabDJkr9AZQIs7xGWLif3DldSyRYXm5xywtoyNZvvzBwEHjd5XOi9yGlVtZ
         mRJZcf4Qvt/gWEe8EZX8LHEqgGt306tQ4DUkDmHMabw7b95nbLobJxSEnV9c5N4UJult
         66vsMwDsGZtZAahCrfjUyLX2Z39QwtSldDiq9qYArEx7njwNIobvXgtybyF8PN55SQHF
         YUqXq8ujQ9a9idpJvd3rFDnd7DhHRVNHIJEzHwyE6PRjMVT9gV//lELMWdrHNj6w1DSu
         Op0g==
X-Forwarded-Encrypted: i=1; AJvYcCV41+/5TN0GGm/ReahJtTzJ0h4WSwQZpC8DsoPp+EwHi7w8Y3ccvX/iLHnCdJe6s5/4Igj+5pb/qQ4bcIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7Nh6a7aaJ9ruNpQylNYHIJsDTKMeskzzjE66bd+ZV+lTpteJ7
	CNsNTTZsZVY0HHSH8us/wNKPk/lS9B3NEgZ+HtQ8mx4sEvEpPfjtkA14aHVegUhWBDxk1cFEt3X
	whMlS/Pyv0nggFwmO56jPLihf9BeMcJXqBlolbrwfjlWrvhD8maJ9n8k4OenS3Ee/J3s=
X-Gm-Gg: ATEYQzxVDPez6kEpfNjtrpQRQmGCG9o+L4WNXYNHSKbsWyxm3MkUW0Wt+D6DJbD2eO5
	vyw+7Ch7QMjdoNw7iwM1/XmhSkET6X/qjCKnifrusqChCR0t4/snA81GC+rYvkz24pD6Ycnp1qw
	ARhQv2bRoOtnAxRE02x1hRE2Y0P9JT5haHFngAUQx/oHxL+Ri2YhyQQ9rzNYsbL9mdDRTnlxiK/
	sXEp4zJsg3Iiha5kQAoKf93Oz9Hl62r/13tOPZemmRLrc+OY9ckgjNCSkjS8yiBknr1bFqm7nvz
	voORVq/o7p8WHolpx/DNhC0juGuwWlGhP1l3gM7/Aq5nqxqNrh7vJyg8sU9lvz7EjsLfprNRDI0
	8WYMoXYaUi7mqcrDVGJkzPN3u8J9wu5qrEiS/ETtd5k2olRg=
X-Received: by 2002:a17:90b:3fcb:b0:35b:982a:28d9 with SMTP id 98e67ed59e1d1-35b982a2addmr7810940a91.4.1773739358979;
        Tue, 17 Mar 2026 02:22:38 -0700 (PDT)
X-Received: by 2002:a17:90b:3fcb:b0:35b:982a:28d9 with SMTP id 98e67ed59e1d1-35b982a2addmr7810921a91.4.1773739358504;
        Tue, 17 Mar 2026 02:22:38 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:22:38 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:49 +0530
Subject: [PATCH v3 10/12] arm64: dts: qcom: sm8650: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-10-53371dbabd6a@oss.qualcomm.com>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
In-Reply-To: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
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
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=1404;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=vXjE20g2L0ZJQyzxZj8qyvW/3Cs1H+TeODfjjpRRFrg=;
 b=1vG0VQdenz/MfPd/Mx+daP0cUk/cs2FwW+9Kfgk0RGQx22WSSBVux5ZrABbBvP8E/bUCNxJDP
 esdkSYWTFsnAttv+c+2/voZzjJx+emnZOlKjs/F1iuC77rjCEdVDzbQ
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfX8lIj6fK/ErDN
 +kifKwFKUueHIihz8sEHqcEA9MPS7YhqVLztv7PiHPwu5cd0+ACnc/LevLamsyX4Jo9WJ2Gyku3
 szs88KIS3fd7lBEL9eli9M4zsoYxZpESd064bL7OEt4nNvs196TnDVtS4UmiAFoT3k+RKsd0VW+
 jzARpOf8INQeWkcAU5yll1B/gWRsQVj3famZo/Q6IsAWaxYm99a+uWnjU1/sB+uDvy9c3395OyH
 KEqNmhDzS+tH50VyqntkLNPFq0Qi1iCp7kAEkHoFS3Co/K71Tp5Uf38MDoMg7HuBXD7z68TbZ7R
 O9V74R73cTScZiPVQg2Vke/w/+FSaGayLBLLSFbkWNM6iiLUPtr/tIztknADE0ewHs0WC+RX1bj
 pun/7PhXp0kkZPqgh+wBygp0Q2YWMAVTPMrFOp5CU03GiS0eDlkxeg0D1q3La8E2Nz6gnWV7Z1U
 OnklG7E72HXTgAvFZsw==
X-Authority-Analysis: v=2.4 cv=D7pK6/Rj c=1 sm=1 tr=0 ts=69b91d5f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: QTYfQBC03KyJQNYhKYoj1g8dROfxc-kQ
X-Proofpoint-GUID: QTYfQBC03KyJQNYhKYoj1g8dROfxc-kQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170082

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8650.

Fixes: 10e0246712951 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 357e43b90740..d211bd94fb41 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -4081,7 +4081,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

