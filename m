Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E46E38424F
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257521; cv=none; b=jRtm4L8kqD2IIhCRERsheGxCGWZ0L3hgulNdSN+eptTzrNY3Ts8WKvvidVYaswU8xJ5NZIZ7gNXN2fJvcz0QPal+p8oH++99ISLjfAvi1LGtwVF93IFrIz301jo6eXBHeISh0cIJLL2gfLTM3d706CQZmGUM9VXf5x7gAZ0/bc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257521; c=relaxed/simple;
	bh=Ua9PTxyD06FOiJfwJksvZzTwKT5wpUwMmmC6XVvXSlw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LdLqonGFA3lM27oZ4s0p/Hc17KJBKl5Bhryxp9DePaESSc06TXT13c+XeGcliyDme3NY3Jh27W7uqjyKZpbQ1+iu+Bw3lPMARGPgoYC3DXs9vPIeaez77FgrqWSRS40D/thQKPci9p5Y2T7Fbn/4qJtIdMIDuJZA23IeZKeRAuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M7LREpL7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XrYEiMoW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M7LREpL7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XrYEiMoW"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N4PTxJ2754488
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pPxK0Zd5FBsVZsqHeJ+/TpVgmVWSK2RRQcl+tl0GiZg=; b=M7LREpL78c21oNC0
	trOQJJa2IF+2bqRDglgFkpi/t+gfGaGmJSBsfV4LIAtazVQ+NtzaKCg+JtDxX3Qd
	sCPMupgEtqTiOlxqoZZiDtk4lLLRsVB+DdoPHbdYZ8dvghGvxCNu8072bLFJh5JK
	PZJiU1zbP2nl4ijdctpCn10NuvikZnUAqT+k/od4l5PM+W8f8M/LpUkKBChSiBlU
	Sp/TgW0rV7FIaC0JwJraMqWnqZukX/cMS7qf2Fra8qDBE/AxukaTogwxh6cjGpTi
	g1KZTsLREfEXx8SwgyTwbfHFD3R69bJGPNW0+b+Xw5zvsBiOYD6C/7Sf0sZTA5gk
	EZSUdw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1h1e4t6c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:39 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso2975870a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257519; x=1774862319; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pPxK0Zd5FBsVZsqHeJ+/TpVgmVWSK2RRQcl+tl0GiZg=;
        b=XrYEiMoWVxBm3poc0f3q8vvQUffnRxd/OOhyuje3LDdGqXf3zfCR8Eulg9jT3KOt+T
         VCSlDVnDOYNLbVzi4wL1XzR9CQnD2ZZuHjGIYo/fIM2b2+diIcRJpJtMeHL6cBz2L+aM
         vzOqlPWk6KSSaCftvUjmyL6sxEmyuNQ1AlNgGerw6RcLCSgUh7W5uwoUc+S/6ZhXOeT7
         MrKCSv+2vauQdRrLzsp3AsYTPehD55rNar+RGe7KZ2dxCVn/kGnaZ/APZACanWU2zubP
         lFePW26/YONH4FoRH86t8m3Fd8AvKTdB5SpBOOpDLDWKSwqHM/l3uevwDecx0XTryYTa
         we5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257519; x=1774862319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pPxK0Zd5FBsVZsqHeJ+/TpVgmVWSK2RRQcl+tl0GiZg=;
        b=baXKMmQXqXrc5q6V16jpVU+QL9c+A4cIhbPgN0of5dHK0fEq9txZY56X9ET53vi+eY
         wYcZtvMElPXJp3aUMOdDUVreIGUp7tNjGBrf8DA6ByNYzVG1pTa8HXKu3lY1DQGix0hN
         m7vklo73nTsw+W92UZtJuxZ8BIDw6Bwhx9OpC1QSn9rX8gF7DlFSD+i6fcbBfdn7j3a3
         0Z6SStoSg5pvo4BAiW+xBC1ult/v3Zf/XT8KuSpoT0VObv/rixL+Uyllef8DQzX4Yz4q
         ZWJ+jCG+UwZf9YAsL+Ktx4DLi3Vje9kUrKfMP8Adq4w/chqz45LG50Km/+yxOvHKi6Z4
         O4xg==
X-Forwarded-Encrypted: i=1; AJvYcCUUd2CuMV15waeeaMF1845beKuiqBNjdLGPisQsP8jB8ITExw1S4kujZO0ACDHWIUVQXHScyfr5Uo4C73g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSUpib+PzgqLle1enhBL9KoQC1daUt6DUSl3mMrC4AccixJPa5
	jY7tDfOE/LSQW1x7HVjLFu1vGP7GyoiLDQN1wGY6dZhsheCj0cBrlpLqLJ4zeTShRwfH3kdL2Qd
	gC/n4JPYLz++Wu4JI7khO3bpEkyaG1EhLW84hSQxk3L9N2srXWqBZfeWEOwo3ek+nE74=
X-Gm-Gg: ATEYQzyTcrstaz5ZMocPsjjUvNFmozY/p0bcGgLudN1d0yeDxsTvYgOCZ+b8C8Be3NP
	wbQpuusDd35uGzVfk2ciK+8+TTUUdp9KTY/JkM60Hbxk5lZlulijL6tc/fMwQmfLlDOSmO8Y1T2
	DgC1A4yFI3QUTb55kmg0GL/gvaajTurU+yhSX8BJzfHFQCfmo0YnO/du86nMOyiNYzX9vK7O27Q
	dZ6176CBQOO6qt6EwqwYLJuQII3CyOpsuo3SpCqLAJmow0V53hEFkEdgcEftX3fHGy7dSf090ie
	TCdIBPd+hMoGxT68KpKl6wKogVQQ5kJ5Gfytdi68FW9HlJXcSDoCUv+Rr7saS8FgwkvMeqB1d08
	6nNrUHGZq36Pa6k6Sbw/JqAHLuQvpzkrXMqh8Cb1Db8CmO1k=
X-Received: by 2002:a17:90b:1848:b0:35b:90e7:c44f with SMTP id 98e67ed59e1d1-35bd2b9e110mr9337041a91.7.1774257518929;
        Mon, 23 Mar 2026 02:18:38 -0700 (PDT)
X-Received: by 2002:a17:90b:1848:b0:35b:90e7:c44f with SMTP id 98e67ed59e1d1-35bd2b9e110mr9337005a91.7.1774257518409;
        Mon, 23 Mar 2026 02:18:38 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:18:38 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:47:56 +0530
Subject: [PATCH v4 03/11] arm64: dts: qcom: kaanapali: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-3-e36044bbdfe9@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1467;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=Ua9PTxyD06FOiJfwJksvZzTwKT5wpUwMmmC6XVvXSlw=;
 b=Zt9Vok8cFWr43GPyTQ8eChP8X0EScM2ktgYLjs7L77NOj4EDJ0QpFsKI2OJFEqVj+TI0E3jXR
 ZMnVc6/JUiQALlY7cNnYd1huMnhW/ScGFFJu+/wZX7z9U4Hi7xMEFDF
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: gquD8NOiHkp-ftJcdpi3I22U-8zUESVj
X-Authority-Analysis: v=2.4 cv=epXSD4pX c=1 sm=1 tr=0 ts=69c1056f cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX/8NJjMzxarlp
 xCGLi/Pmnyn6tqeafPVWR/Z4lk7VmCojMp6KmRRq4jdNmvhSAPIaLUuqdV7aU8LE4EPSa78ynHo
 tB8LLM6JPwiBEWvNQ4upfpDilHXhKd5i0F+nEbmhilxxZmW2hyxFje+rUG9jHCle5D01Wlzd1c2
 /eOpCHujuUhEadQjoSokU3zLYIaob2U68iTn3F2N0JOzTDCkHw1n3NEPqUbfykhkuufmRtC200s
 4DLrjFNZUQOPLfPoqz5Bv+0RwkEVgJBXULejae+H+nKJet7AT9YScNq4b8J91PGuvPTA04pRwOA
 js019bD9rWJNYEzP19Pr1uT72cvsr86dcQ8KkzU/h2f0dBAR1ZBvJUYDpxW8XKnG6KMzeeBg6ms
 7dX2p5aXvoQyQcUPCYjY0nk9m33sBDiDv2SzVzVdW3eLVlkaJLv2aBMZzp4JxmePCJ+4/wn6LKQ
 3Jq60U8DrDTQ1k8K8Ag==
X-Proofpoint-GUID: gquD8NOiHkp-ftJcdpi3I22U-8zUESVj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
kaanapali.

Fixes: 2eeb5767d53f4 ("arm64: dts: qcom: Introduce Kaanapali SoC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kaanapali.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
index 9ef57ad0ca71..52af56e09168 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
+++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
@@ -868,7 +868,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

