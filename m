Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207138BF87
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340806; cv=none; b=bBGAddo0aMKXBjR6z+YBjKi/b1gWj5ODibRIFV5wp3wPvRDbzUyFGwgII6bwkW+Lxw2atgETFIcK5ChDTxBpR4Z8F3iRAcAdE9/VHSDKTcQ5gyVeZaaJVuPTrrHFcUlv6ofu09WK8fXmSwfAP54gONsjlyb2pIqWSZdGA74YfVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340806; c=relaxed/simple;
	bh=k98Sd+IuX8Zn4GRN74V93GHVqiBr7BdRALamjqjLJpY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WB6MqFGx0hbCUMueYvTcEnfNY0ONWgw/SlWXs0SrAj8CoPA7gIT14G8aFupmb+z5DbIJHkzk0/95GlzFhhVMav1IU2xy9ZX++L/1tI2GzAIuvBM2xZgJXGx67GyMLbJmyHex+eELwNZlvqSSzjFKxcrZUqyHcQjiRZ/pJP43d5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FUdq2MpR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=H09TE/Ne; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FUdq2MpR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="H09TE/Ne"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G9X0IX1553088
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t4D3kKEXk5KVz/5AiBoL0eMglz9Da/HUz+0qxKgAV6E=; b=FUdq2MpRUYWfcoXg
	pFy8xh4XH/w3CiG/5L58x0mjDfCzAixVD0a4reKeqSSMmPfxF4MkS9+7PDZrWD3Y
	v0S7+mnkgThC1pmzNjX8iyTY8I+hb/wv7F68C6e8j36fSMdrx7QAs1ONpEIV8eWz
	+OBNVO0CjnzhM3arm5adaeinkhV2Ixtf5FG0Qrp1sP2jujA74j9kNxE4GkPLd4q+
	VVssIlrot9BrioU49VrrVvJTvo2h/9hL85CPPirNYcubJqDNyPF3DRGOBwwzsBjY
	TmhKKnsq5NiHyLQRnAGhZzw7DJtrtn9vT/0n3dtWqMtSkBsRhkvihDhsO5Nnc30O
	dZ931w==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djrsn9hv6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:04 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82f85179263so22787b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340804; x=1776945604; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t4D3kKEXk5KVz/5AiBoL0eMglz9Da/HUz+0qxKgAV6E=;
        b=H09TE/NekCzEhf+GW1SR8OBe3jaG95qf8q37g3enBQEH9/1feV6Qe8Jk3ph3YKtp+k
         thfwza43OZn58j7jHtKVTUZ5z70Q/wgm6yE227QjF2VWRzrpxWpWGMPI/ZwZAnY3RcK7
         AnYHFi4rd9649i0RTyij+CZsoOShNIJh0x5KNnSFXRCXJBipFtkaEmVyT2caGPTCr41O
         kAhj64zacPZmq33jnFXfBfWx3B2ROUD9cDKAnfbttYcVLRhNO3ZM75HJzSaDAIgbJTWS
         Epke3TXjM06vcgdJmpgRPcqWuaX4zt5oV9z3QAwBhydB9PS7oUEtCU9uohXCI9XNvHhC
         CbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340804; x=1776945604;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t4D3kKEXk5KVz/5AiBoL0eMglz9Da/HUz+0qxKgAV6E=;
        b=hH1lUuNWQ84KJIE63gilCmHRe+6v2cT21shzv+8+GdieYgBjxwE0GXlVIlIvtA3sWI
         zlqsgh+qSupiMmiJH6dZfiky0PAAumOIp49xGN6ElXwup8GkneFDIsC/e41DWedOLmYJ
         uTCPFPwdwYWEkIt/m7IwWomLu665IFcnYqso6AY+Xgeu8vHQ+s2ERu/OrGFgSQ5RWO/j
         gucUdSP42MD0lXkeZlWlaBTUp6dbf80pcDFj3fdv3fVk3pZSEPvldR5pSQ0HUnV2MUi7
         4tfk1CdLloK+pyAE5geBUYvtPdEVVCtoUTIk8FdLj1n7WkxUl0qLB2CbVyL0W7Y16osk
         WXnA==
X-Forwarded-Encrypted: i=1; AFNElJ8XkkmjA8kCIMtxMVpP9rOomzJ3l2bYdJYGENpEFvoVCJBg12smvQKCPQL0wglLnBO8KRjK/iyER1Zxeyg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu/Su+La4B8Ho57DxsbQ1dZOPSqSqyIzfLxRxO0/4x8PioM8ml
	reJV5dLHzTSOMkreBhwJ/gYa6wPw5jfuRrPV0V2QM1Q3YM5s1ZWrryR5xExrbMbEzMvC6B9rlhl
	LIuKW+hayr9Fw1t2k0KmTxDT8Wvmm+hYWUbLZ9Zd2096z3uIDI6BicWisgE3PXq07KjA=
X-Gm-Gg: AeBDiesZG2omV0rXjp+ia6iwmHEv32yLFvvNmgWuH9z0+ptMD5z9ZT29+vfZWVYUqDi
	h93C7qgyBB03hUpQYToWta82Ub5xis9zgouPDPXPiV5+YiCDgpPsghl4lN1Pqd2k9bIxQAAkRO6
	GEIVpi7+BD/OIugPq4D9sZ/qb7W3riLzJhHk2EOeSQDLQErjiOOSa3u57OING/iKyvFTnBcph8t
	ozBl5Kv6ys3xNU2DfSZ6Wh08CwTAdjzmKnFra/5aFRwhsdyGE/HP51tMRx45KcR3zXpOzPVSQkm
	BC4oQq6yuG43qAxekFIf6EI0ph/9FujC5/UvJ31vfpHDd4wYkTP5TBKMvS1wU8aOF2xb2YUvFfZ
	g6yEMse9slD9SZstg7IHwJWx1pAaAz8HKlg4d2IIYM0LWxQ2ornTgGNkVYA==
X-Received: by 2002:a05:6a00:400b:b0:82c:6b46:271d with SMTP id d2e1a72fcca58-82f0c2efb17mr27197908b3a.48.1776340803738;
        Thu, 16 Apr 2026 05:00:03 -0700 (PDT)
X-Received: by 2002:a05:6a00:400b:b0:82c:6b46:271d with SMTP id d2e1a72fcca58-82f0c2efb17mr27197857b3a.48.1776340803124;
        Thu, 16 Apr 2026 05:00:03 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.04.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:00:02 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:19 +0530
Subject: [PATCH v5 02/13] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-2-5ccf5d7e2846@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
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
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=2680;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=k98Sd+IuX8Zn4GRN74V93GHVqiBr7BdRALamjqjLJpY=;
 b=oe/UGWbm2S1UOJmEZXb7xFis/im2RDqGaiAutBClGq+FEU5aI480XpHFOMuqVF1yWN8lLG2SI
 bZ1qVSG4I6DDC/RvkWQyFhOWLOVI3rpzkJH6M8PO/F1jeBmMyfU6ihW
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: OzfybL8Zau1JsAht08XsdrbMHAMyX_JP
X-Proofpoint-GUID: OzfybL8Zau1JsAht08XsdrbMHAMyX_JP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExMyBTYWx0ZWRfX07Kj5kknxgzG
 NRWhhUFWiH4/OwDjt5FlngUyC/w2BdWQGXbqbGnmuKJZdGuMUgF0HUZf0EzfQm+cTtrT8zmf3Iy
 DnYuJOgDxILAnFzdtQt/k7ba6bq/khcakOlr7VCAM/HayHNQAp8U2Z+2NwBLLcXnJI3oXms/peq
 PuT5zO1Hfw/EOMtI7G1GernimZsVd5/FgemNB6BgDiE9JzHqffO4Nl87d0qOX6edD3+LxAOdBdo
 +TuAOfQk5K+tg9bi0bntTJGbGHnFHTmF7oX7ktycOT1L9/gEQD8UCGcBmi8aO2Pem3jh8cd+5ce
 JewymSt11ySuw3TLrRWzID3Yl8mTbZmAe6yhGgeJw5zpuSvLM0ctKoPE1TN41uFqQcpGmqQiaRb
 DE74LeL3zu0RaZfoC4xVf3JsRX3aViUHPvqdbYrInW6P/uKDdAlzPHY0M5POwVi+NyxicxKAD9E
 ChrrE7v2G+hqpU51FlQ==
X-Authority-Analysis: v=2.4 cv=EojiaycA c=1 sm=1 tr=0 ts=69e0cf44 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=DGDWbsvPyNGGEFbMfx4A:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160113

Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
de-coupled from the QCOM UFS driver, it explicitly votes for its required
clocks during probe. For scenarios where the 'clk_ignore_unused' flag is
not passed on the kernel command line, to avoid potential unclocked ICE
hardware register access during probe the ICE driver should additionally
vote on the 'iface' clock.
Also update the suspend and resume callbacks to handle un-voting and voting
on the 'iface' clock.

Fixes: 2afbf43a4aec6 ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cad..bf4ab2d9e5c0 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -108,6 +108,7 @@ struct qcom_ice {
 	void __iomem *base;
 
 	struct clk *core_clk;
+	struct clk *iface_clk;
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
@@ -312,8 +313,13 @@ int qcom_ice_resume(struct qcom_ice *ice)
 
 	err = clk_prepare_enable(ice->core_clk);
 	if (err) {
-		dev_err(dev, "failed to enable core clock (%d)\n",
-			err);
+		dev_err(dev, "Failed to enable core clock: %d\n", err);
+		return err;
+	}
+
+	err = clk_prepare_enable(ice->iface_clk);
+	if (err) {
+		dev_err(dev, "Failed to enable iface clock: %d\n", err);
 		return err;
 	}
 	qcom_ice_hwkm_init(ice);
@@ -323,6 +329,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
 
 int qcom_ice_suspend(struct qcom_ice *ice)
 {
+	clk_disable_unprepare(ice->iface_clk);
 	clk_disable_unprepare(ice->core_clk);
 	ice->hwkm_init_complete = false;
 
@@ -579,11 +586,17 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	engine->core_clk = devm_clk_get_optional_enabled(dev, "ice_core_clk");
 	if (!engine->core_clk)
 		engine->core_clk = devm_clk_get_optional_enabled(dev, "ice");
+	if (!engine->core_clk)
+		engine->core_clk = devm_clk_get_optional_enabled(dev, "core");
 	if (!engine->core_clk)
 		engine->core_clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	engine->iface_clk = devm_clk_get_optional_enabled(dev, "iface");
+	if (IS_ERR(engine->iface_clk))
+		return ERR_CAST(engine->iface_clk);
+
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 

-- 
2.34.1

