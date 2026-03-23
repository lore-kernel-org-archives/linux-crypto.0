Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406F438424F
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257513; cv=none; b=X1vHAyMrc8Adu4efD3cHW31J92/hmoUsVCO+7SHPNMWjAuKRqhDtxBtOp1LcRTKNr3TT01zWfGxCi8dpksN+yAfidC9cmnSN8jsVkEcdhdM+od9p6Gbgq1awSU+ImwZFUMI0b0DwMDuMUj+Jtdzti4zrBiWrwZ/fzrjYd64fyWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257513; c=relaxed/simple;
	bh=GRasFOQDQnuoi6LdOvdCuvHUGo8tuUdcLZv2gGWTa7I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JwlBIUlYOTeAm/6Csr9mcpB2HlS8tbc7G5JcQVp1O2qw3g79UhZ5gmadqEfDBqpQAIZa9fb/fA9HT14ZbkGI707mf/jZioGrqyr8dYFbaS8nseBqj52EanQ/I3NOz9l8+fVDlcUnVgKVPh9ZP5E5XNdHntGwGlNECW0CKr/9sXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bmOMaHrS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SvYcnUn5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bmOMaHrS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SvYcnUn5"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7tboC1627188
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	K38ecOXWBMhUStpTWn+W7TDtJFk9bdxlpPeuhwPlVTc=; b=bmOMaHrSpkRUjCi4
	mxpsYzlaH/hvSwoLZc8KGvFWSK4KbTGcnBp52OI6GAv6O0eXNAzm3urSN2sbuEr/
	TN37j5/6zjOovos6vQ+82ktCIk8c5Pz484x/7pKb/L93wwyhObApJhHjFNG+D3SC
	eSvo16EEaN1yDZVGEWFnMqIRwf/RopzUYF2FJGxUWFueIslGd1VwLRJpUtVkCV4J
	wVfbbqq/zZ0ef1OAhSoBJgLCU4pqJRq0EjHvhQsg15HcTTnInBZB3Zl8xy4TEMAr
	4GfbwI97fq8j6WWCK15k2EW7pBHvO+geNFqAQM8S9+J4yQ3uf4A3tFHwBQcBH7W2
	q1oXUA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31jc0993-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:30 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3595485abbbso5411742a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257510; x=1774862310; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K38ecOXWBMhUStpTWn+W7TDtJFk9bdxlpPeuhwPlVTc=;
        b=SvYcnUn5MIW9czobkiH2neGDmBcVOH4miEhmNIMAgOMNsOdxC++KDGoQVqhIHZnLzU
         mxGqRGI0pYEW+sAN/alPME9Xl9ofLeACD2AebaaVmcrtNWz7nVOxFsajkRpHieXYAGDS
         XjbZ/ghKpVMgwCrdijoXDD/kdfJh+1bJh74ctcmsj/Qc3vViORkvB/tEfQT2ugXYmpMw
         UK0Wi0xNZH77j/3i4gy27dBBfPn7MnCfChM6GKtt8Q6AqZfyAjK5heXh2sIN4THgZcq9
         3MUqYIfduin/rdUd6mQ87SdJ23F0MxxAqdL2aYE1ZwNv29B8G9LvTe3C/8iWQuRRdrNo
         8JCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257510; x=1774862310;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K38ecOXWBMhUStpTWn+W7TDtJFk9bdxlpPeuhwPlVTc=;
        b=FiA3wuPcnVDw/G0rI8y+3yOQ4HTAWt0o/Wk3tPdd/9ycvkvk15DkAYhPCa1LgoYV6l
         viK3RsnW3Hh7Y7JjpoXsgfnVF1AafxYspQavFJsgAD0A+EBJyXW+GjmCAA8Fj+MhGVqQ
         hbuZ7U2Lse3GfQtxkF8CWre7T65VRpueH0ftjhKogAvIw1nrPooJUFqztKoRKRiVcTXS
         e8mkoOOvVyvnV9NeuD1p7vQb3KMfGlTscoNFdU7gLlOldq8nHd9PTNQopeL6Lwf+00TK
         yl72XhI1gysyW72Oyz1wfm/GmlvrdU4AKz4DhQA0/311ybzQ/P457s9ndXmjqDtNy5bd
         HGOw==
X-Forwarded-Encrypted: i=1; AJvYcCVXZTORi7rJyzTMh0DewtVSpF0gBXiVEhdLWy4KE2Ebb1E5YfH6qxFxjGsN25ZIHyP5XHZDSO1a+VEqISA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbmmozbNyPsdKXMKFYeTnoFgUB9ZnXdhg2h2UlhZ444iiSeqZN
	YUQ4ZlLUPIl2Fr6b4gSv6pIfeDVIHuj92ENBqVQEiBz4e6XLWlezCuHNkqoYsnhmB4n6VpWsF00
	9NukKnxTmU5MVKTvMtImVWtU/cI/FhQzMsO4EmcLRM+vaElCcmhw6teBiJWXyHNSO0rM=
X-Gm-Gg: ATEYQzzA31pDXw4mrUBGN6tLub9vBZDSXSJAmQeKK0x/yx07bgj2QO0p9LRvRlFpPeV
	FpLlt4KTwCwv113dybQRR9qW5xLMneA0tcmAQA3bYNaLoJ978ULpxI/yQtXHfqyBOgfzBCkhjtd
	V6lZWwyi6BPKqIaGjbEd+p//8Wf5NRtTxVcXllxFXBglgR01khdGqnJv0Agg+EleKi02e0zcWdW
	POi65AxWlpNDtfW/eX8x8zMa+i+1bEQcBYJccWC4fK3dXQTGDj7Z5iC2AkkE5rAzJXirnfU/lri
	a2fSWrKk4GX0w0DjeDhA/LaJk4czxLA0VUP1qhgaY6JCNg4nyxhtT44v+P8nINI3v9BDJUgNHW9
	ddO2BW32HE+jEvDjj6ixRgvOVP63BxjdT4AGj+GGGAvE1Qco=
X-Received: by 2002:a17:90b:28cf:b0:35b:e566:15a6 with SMTP id 98e67ed59e1d1-35be56625d6mr4506787a91.28.1774257509885;
        Mon, 23 Mar 2026 02:18:29 -0700 (PDT)
X-Received: by 2002:a17:90b:28cf:b0:35b:e566:15a6 with SMTP id 98e67ed59e1d1-35be56625d6mr4506758a91.28.1774257509385;
        Mon, 23 Mar 2026 02:18:29 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:18:29 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:47:55 +0530
Subject: [PATCH v4 02/11] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-2-e36044bbdfe9@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=2504;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=GRasFOQDQnuoi6LdOvdCuvHUGo8tuUdcLZv2gGWTa7I=;
 b=0AKNRl6KfF/JYgXrtGC4dExbf3Ox7uxMEZ6hQ/OzDCKpAt31J5XhaBXgEeDlTCqSJjJZuQYds
 bmivaZvOYjPDXR3cTODuxf7D9DSQNwkbi3lePlT0YgGyra7M2ElG3TS
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=fKc0HJae c=1 sm=1 tr=0 ts=69c10566 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=DGDWbsvPyNGGEFbMfx4A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: PgyKFn0FD6bDMV_at8eMDCxqvAXOx4Jq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX/mYPQfra1CBP
 LDI3uRyE2QP7yxgDOTC+HkOes25wjjiBLot5cLrPKFiSolTyR6j7UhQ30l23zjBzVv2xvShuaOT
 YNpZ/c0VlMco7isDK5y2OeEFMQ3jBg3fDGyBks6DbSMJ5P3ydc4M6LTaF3aapUF6KqncV3cCa/H
 yAJwF/wfB5oOzj2kk0N7H4NhSjteoTcW2aVEN9NdPxppep/qyCcanwktZKmxkKfywnh0Lc+9p6h
 de59gDi5oWQTfybrJgmpxIwYprhWeowv1LPuuCMCN2FrMDntSPwgMcG4kkRc9jYUMfLUiM+EYfL
 T4vQEvIcn96TteJjjinqgBGZ8coAqFJ+668pQ6ak80iGu6HsfTBr6IKzLQ3sIXUSo6RBKnHGbsQ
 ktpEyU+MsuRKM0Ozb7wSO0JaKXaol9T7uytmfqXY13OuazHL4zdK6vecW41xYbuYxhEI1zW6RTW
 jCyMWFzf8hmN0QLEw5Q==
X-Proofpoint-ORIG-GUID: PgyKFn0FD6bDMV_at8eMDCxqvAXOx4Jq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603230071

Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
de-coupled from the QCOM UFS driver, it explicitly votes for its required
clocks during probe. For scenarios where the 'clk_ignore_unused' flag is
not passed on the kernel command line, to avoid potential unclocked ICE
hardware register access during probe the ICE driver should additionally
vote on the 'iface' clock.
Also update the suspend and resume callbacks to handle un-voting and voting
on the 'iface' clock.

Fixes: 2afbf43a4aec6 ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
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

