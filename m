Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4DB363C5A
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130050; cv=none; b=DCZy1HiBmS6k5xaKWTRN2aHdwcJwfYLb8MNrPAc5TDcMg5V9TOFW8q3cPoh+VgPayUO0jjogzkmZezJgViSxq13MF6djt0RxeFZoRmuZgQs7MP5BKjrXbkXJS2Lqb8hpQ/TnBVUBHjKBXlSylGTN6xj6LJtnO/UaqHSM/UQA7mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130050; c=relaxed/simple;
	bh=HOoqM0stJCW2c4G9tttLgaEou8MsibFmsrt2EZEKvo8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=io+Z/2tzsucR7kPZtd3+cOvBrE2Cqde65o+1oXl0xj6azNOjTqiIyP3VWsMwdkCV8HG4soGcnapFq2zrlkymsEergnOS6gTlY4fNtte4FE2OCo//IibNR+nK0T2xd+ZGDQZAB4fvduSsC+i4JbXKjmIjXy3V4v3zEQo1k1Qk1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OuakfDXB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R4YB+LT4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OuakfDXB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R4YB+LT4"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EhqY3087381
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S5L/dcs6o/BZsBRbs0bi8Fp4smn6ZIz0rRdMGZ/M0Vs=; b=OuakfDXB4K2QYoXb
	h1qESqHBJkEpnmLCLjPBYnSHZcbZqip2vEF0De9ctw1RnG2bGi7IRpDHQlgbGsc0
	CUubPk+S3YNMXl83GQPD97VR++TT3pfj3H86XXoFth2sc36lYTTJtaEVGMEZlzNm
	xtlTKzDtfIm3yIkcztgfy4jfWNvhzzWoKEZ+XFUyL40T4zb2VH2cfUuPFKW2X5X8
	//xcx0nqMZxKbJDrwJvaTP4/2ZBt8/DY12CI5rtYkacxdiBShCeYlR5MbJauGCbO
	qxdJqMYoKJuYQzygUopV56AcGXf2Uc0cx9cjk0C5OP6ZR6kEbR3azvxlOoOMRrQS
	dOuBfQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4csxy83e7m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:28 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c737b6686ddso3591438a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130048; x=1773734848; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5L/dcs6o/BZsBRbs0bi8Fp4smn6ZIz0rRdMGZ/M0Vs=;
        b=R4YB+LT42Krol125x5F8alf+NwuXBfn/xhsJiJxW97sVMoWCQMjyIeITqgQOLXyA9N
         W4uDMeHeJROEstJOnH2fQfbyYQGRiL7uNkDXGfXYFTuHbQ+pKB5BmQl+9ksjLvosI2nT
         st/xYyV/mB7wY3hws512Y4+6qANkL/dWTzbviCfGMB6gLuFVGeCcTaVjDa1I9LAxYY7b
         tMLgddkQjqz3GULGNLQfoevvZu0SQKNQbxw7DJ76Syh4F3SyNlSW0ddMh8zKTOlHPyf8
         MaM3G+xL/wkaEamQn4gq92Th0HauRwPs4EqIjRwafxm/jyL8IM9MATA5oa+u1sZxIjWx
         bi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130048; x=1773734848;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S5L/dcs6o/BZsBRbs0bi8Fp4smn6ZIz0rRdMGZ/M0Vs=;
        b=hzL4Ytmxm+gaTfI5X/RZvYuscwb5o8+/1p6qn3EsoTy+eSIwdO7lal7C2bi+db+jsF
         8N3/nl6P9AGrHgWs5k8CLvkpJUTdzyYV2877iGM1EgAZpAiwXwfmMmUTIe9MEXSXn9OS
         UrrKdIu8roHX+HpgtLZ9ruIPJrUfhssSQMDpxwqFH50xSPexW9YeoRT7BqZA01WpZclB
         DDVo2Ou8aD3XJ+kEUKA12M3/UspDcuDUcaa6JKOAYb/nZjczN0wcXatjSwVyf+vok0gR
         5XosmKxNfWap4oWF3ydECZpIw8s0m2LHujNkW7YH3ypg5XdOC/hCKiuzblKDSKAs1pvq
         KGrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX0gd9p/m2HWNDrlqYxzjE2803dNxRWJav4CKEMIRrJpdVzCpnqx4MTZoJTamNAMeNmQrr8sTm6IvAvKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtbWp3FI6UCbOuMypiyR6OSf23YW7VZ+8Wj8Xshj0tML64ACVd
	eXqBDb8nHyoubh/Ia2jVJ+2RWowaYG9DdXCbdBvYftnUDg2s+4miO4dc6D0LBOCaXWAZmGU+sak
	OTw7DDtUJxoHGDfKCXr2fEAQls39kIOEVQ9GCIqOZfg8rE+cYulnRV58v2v6QbEoT8sY=
X-Gm-Gg: ATEYQzzlnsbQN9GJ6tziWPojSvvQXL2N+HvzmRdcAYs3dflTctVtx9xT7V6fswCJQAn
	PlyFMOW+v+wqZcONjO0fsnIflOK/YK1gWETzSIsrCQ/sxZOghZXnU136PixF1vx+maPqZRU7nLw
	zH1NoLMG/kG1zieJHZ6DOF8mzrZstJVoNaPBZqSPjp3oxv0XYuWpkLlPyGmrBujj3L0BYH5Y+mC
	4pUv/0R+ZIar3aYDga/YKJw7XguSpLltup3Uv4HMv6/2TMwglQqR3e73mCHnfxJ6AhpRJKNUnaZ
	Q0czyAwc/DWFZwJHMonP2hW8MduLwGnIUi1HUY0MS6v4PvhllKFnKsv4Sf9w30QAm1nnyvhUt1o
	OVswkQS9ie8TnHxH55aeXd3f7j9UfJCXZaFxOKujTTl7R0GQ=
X-Received: by 2002:a05:6a20:6a1f:b0:398:b178:a55b with SMTP id adf61e73a8af0-398b178cd8fmr1271929637.34.1773130048125;
        Tue, 10 Mar 2026 01:07:28 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a1f:b0:398:b178:a55b with SMTP id adf61e73a8af0-398b178cd8fmr1271891637.34.1773130047653;
        Tue, 10 Mar 2026 01:07:27 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:07:27 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:31 +0530
Subject: [PATCH v2 05/11] arm64: dts: qcom: sc7180: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-5-b9c2a5471d9e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1423;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=HOoqM0stJCW2c4G9tttLgaEou8MsibFmsrt2EZEKvo8=;
 b=irjZgmKQZSGJjEU3BAvw8UlyZU5zYomb9cZuB+B/kjpG2h2tcCOoIVJKuDxPFwl45po6b6LwJ
 I+e19T7obZNBxfBF03T3R1QpUyiMhI4+EGWHEP/Zft6R/kOmBVlexcU
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=SvmdKfO0 c=1 sm=1 tr=0 ts=69afd140 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: QD_nubp9hlvUIcN8ZkAALbjOpSDJxdwT
X-Proofpoint-ORIG-GUID: QD_nubp9hlvUIcN8ZkAALbjOpSDJxdwT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfX7e/prKZr/yjN
 ynbC7CFkV7NX3DSdeUl3DPdy3f79YEc1n0N3KpQZpYoZTSfHLMsxL40tNrz4zzNP32wI+Qn/Qvf
 LrRZbWENVKyYxQ5l+ZQkVE4gI1GwlWpVmJkz5c35AbJMmXVEPCEBhe6DdUM1L1Z029qswfO4xwE
 xK8VHmJFTPgr/hiAGo+poV+F4HUVqK/gWvZ7FdocgIzW5su6sdiT1V5Ly1u3YMrXWvHU6RkqlBp
 iN/sZ+1GWUToUxEiDUHeZa+VCeecw384iMwy49ExdZkowFFiKkths5Ixui4MZwTVnpriOw1svs6
 lv9FBGlL/COlgi1lNUVNM8UwayCxuSFecfPG9bHHUrRuw9UNAcQm6LC/5h44cFtmlWGhdmmqMyP
 3ChgrUaW3HWPrtQIhuRtWOb9CRPw0OaPOtbFau8yNg3GXtUFrLTUtotL3ecehc09Z2x9A2+UVO4
 VVTU2ZWr8KUm7lrGKKg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100068

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sc7180.

Fixes: 858536d9dc946 ("arm64: dts: qcom: sc7180: Add UFS nodes")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 45b9864e3304..74eb895cf4da 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1605,7 +1605,11 @@ ice: crypto@1d90000 {
 			compatible = "qcom,sc7180-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d90000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		ipa: ipa@1e40000 {

-- 
2.34.1

