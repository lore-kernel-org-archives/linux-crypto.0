Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3F5386C1C
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257567; cv=none; b=fusgqFYk1yD+repoDJoVC801+27N4wf31uRf+qVm+UOuD2cC+LsGHUnDid9TDZSu5yzeCq2ur3ZIT1iLgkxYwOQ69E/ufhF+w7pjAJ1DEOKObtFpJcJH+Xz6FgD0yTaxwH7R5Lscu6ks5AbmC+5d41cUbMW65nwXacU1SxiHq/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257567; c=relaxed/simple;
	bh=wxVSM1cYZTl6y1L3GXr9bkltA1OdyoyjM33HQ9eQ0kI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mYEG5bswSqjHMetaB6RppQ5Y2MmWTii8Q5cjjUOb2w6h2NbiFowT5SWLd1sb1d+iobtHxT7YuGkHtr8jK/YZ1KuTMc3Z5JegbZzaHS3JBHlCfZXnjCUZYf067ftYZ4pxIWMdC4TGBz5blkLlHLVRWkAL5eHc4u+bpW6n05jcR54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eBGH+7Dh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MnCWwb/j; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eBGH+7Dh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MnCWwb/j"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7H8lh1301211
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	exWlhEApYdywyNwd+GmQdD59+nL1iNRjBE2wEh2mEWk=; b=eBGH+7DhjUs8YHvm
	f57uM/Yp79YWNj1knWOWUkqnSysJs80rAZZF6QSxRBtMSOotTUzExE48LfnR9VTu
	e6ABvcvBL4OjWTL9Y6slP+Qy54MxeRSBz/JI9KOoaRonbGMI74cDPOo/vfVpcG6D
	b7zYRWZsVSnNhMofPeAop2ll662LBCoeY+ElUY4pgaQjUFmFmQi7WrfYsyA9/Vnp
	TpeMS7VxPzieIqvFz/kbe6BWnArI8MRIqBV8WNuYQaO4iX4N8QL2K4sMr3nyAPSh
	0lcWheAiJAhxUGY9xuX2QgSCepTnGldsv/o9encg1RdPLGv/z+UTcDfGLF7BuNIX
	9357KA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1mghcj6q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:25 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-358df8fbd1cso5348845a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257564; x=1774862364; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=exWlhEApYdywyNwd+GmQdD59+nL1iNRjBE2wEh2mEWk=;
        b=MnCWwb/jQdevjK7GuDd9F/yMybhi0LvSF9fx0sOJqmkm89DNrrWMKJaGcjKwFd1A6A
         PYxps9ELBPnLS8uNDpz9KQ30G0kBCnpk83agOoOnm0jDxH7+55C1GwZ/S/V3pBfNSeM/
         jbcIw3zYDOVhZpejmVJUz94kjiUG6+/kj42ADP5OrjXbJbedg2PyfuPhwEszjfo2tNBI
         +gK3NdbsP8h2LqHg4bHmif6d/gFvDdW8bTDUBQxkRC5B/jgKLwB0pdwcfA7yyyf7eWl9
         rZthJlNk4ukAhzycYyVgmYnpUybLWLyvsGgJM7EUqi21EZRs9UtUXPXJ7JZNnNNwVrub
         KY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257564; x=1774862364;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=exWlhEApYdywyNwd+GmQdD59+nL1iNRjBE2wEh2mEWk=;
        b=LqxRiUFPcl85PPK4xf2BNKpfFDWp7ZHQ4UKvo8ct3yNFznziR2lc7/UrQiE7vgzSDv
         v5onfmK2u7fBY4UPoai5M9v6POfUTiDnCD0Qc7/t6hjNWt/rCWHkfhT1++aLFkvyrZep
         JV5p/ouYN9bby7fC0tHBZONrruqkxLljPr5pq5cOsiU2S+qK5SuCSuvD0EBYUhdwvtTm
         jbU3yRBTivdLEGY5zy7L2SoHtMTS3G0oliT7jy96YorJV+Qy0HkhBGwbcaFy0QR2Bi4c
         kZmosLW8FKuHkyfhgOdy+VOZBkG3tp1tzky/5EVP44/cGHTyEELoiz3qY2K7j2rtYQvx
         eUsw==
X-Forwarded-Encrypted: i=1; AJvYcCWEVvDwBx4qr2YKvN7QKzrKtBJyN9t2ORX9nH+Vc2vmeNS53ajncnoLi652OBdtI7211LRHqr+sMd9oXr4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy++40TdMXyV5Jxt7kjw9Fpjtw/eFunfCjHSkG8OCmDwXf8tg2B
	oce6pxgGc2wNCiB0xo3hSN1yaJ+76ffOJCq01RPo36h4fcEirTvvsx1JeGulqAURGDqtCyzdqLD
	/fRA6Qq95ju0ISpzx7P3o14s9tpHa17tJQd7o2OatSD59jTmwpBeHe3VpC7M4WmLoEfQ=
X-Gm-Gg: ATEYQzyv+1vGj0o00J42jD9Ow9WxOD2ozE43n7zJJzWMlxwLb6fCvzH+e/+nIE1svJN
	P/i1UJMNV2yeCnjJAJWFeGHS/aiB/LlzJk8RHcrP/u42KFLPNOv41pfd51KP2eX0vxJlJaKexbc
	iCPi/OVGQ86/ZHAIRs32Qex8jYZR40K269k2oY43hkJn89XTcGqm/Mx1M0D5q56NSS+fAqGcGa2
	OIdY2QyujLP5LyqGBoAAIv4JmLRr3quTbSYysx0lDJHVdgMSi5qgn8Hw1DzgCK4O2tPeZ/8zFnd
	BSypkFxKFCiTeAsLT4Vc3GOeVI1wqDZsKKXnVI07dhxyqVT/iLBnrwskoFR+koFChxpiZ+hzapv
	+P/wXmjfp9JkbWKsl2SRys/V9KD1ZGHyqTopIYz1721wXgks=
X-Received: by 2002:a17:90b:2885:b0:359:8abc:b348 with SMTP id 98e67ed59e1d1-35bd2cb2af7mr9861363a91.18.1774257564507;
        Mon, 23 Mar 2026 02:19:24 -0700 (PDT)
X-Received: by 2002:a17:90b:2885:b0:359:8abc:b348 with SMTP id 98e67ed59e1d1-35bd2cb2af7mr9861319a91.18.1774257564026;
        Mon, 23 Mar 2026 02:19:24 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:19:23 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:48:01 +0530
Subject: [PATCH v4 08/11] arm64: dts: qcom: sm8450: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-8-e36044bbdfe9@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1507;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=wxVSM1cYZTl6y1L3GXr9bkltA1OdyoyjM33HQ9eQ0kI=;
 b=pUdOurWSPgpn1ni1io1/UnjF0vJ6gZka1Qw0Rmj42Wy2OqGRU01i9289L1PtNwdkUZDvqQEzm
 dTS+THhcD1SCjaGhNMrWXhI8cl6ELNkDJDNtmRwH8rdED+KFm28jL/O
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=HI7O14tv c=1 sm=1 tr=0 ts=69c1059d cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: hxK0E2bHGVm2kY4RK2fUFO0kQdDu63zr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX8+mjzTQonsGQ
 vHkGuTRkWTIC0hwOKUc97uaucjg45UUOC+vbhFxrCTBAOESHb+BrazNlW36AKeg92E8MxeD2dEg
 uCTKHCmnFGuvfpP5pZSvMQYbk1vU5vOH5XJtWCawoUMOTS7eEV78jXOFhLFj1pysMyeaPACuKMX
 IMffMHl2uNPZQneY9Ig0oCijoChZoPKrPPyWDQrnn3nU3EK0qI/v4BwBp10I4p4BEXxhOs1SuQE
 3F6SAFGcRez12EJERuBJN5QnR7ynQH60dpkDP9z8HQiffUfPWn4p64jOeUHrsqKu9kT2lUfRA4Q
 g5LfxXO2hRiHcREHtyt0kPjF49U6JKLODGudTJ8dwXiyvhwkSB9O7j/vA2xD3Hd4bJPBawUPPpj
 4Cico9eWCcmc9BfGW3Wmw0KyEW4yMWzxOIA9Nh1f8ewBm/1VgWgLaewNy1t8G3ygspHWDA8ztE0
 h0pPOlRcTw0CLLQlX6Q==
X-Proofpoint-GUID: hxK0E2bHGVm2kY4RK2fUFO0kQdDu63zr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8450.

Fixes: 86b0aef435851 ("arm64: dts: qcom: sm8450: Use standalone ICE node for UFS")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index fd2d5648b92a..0dba282d644d 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5374,7 +5374,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sm8450-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
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

