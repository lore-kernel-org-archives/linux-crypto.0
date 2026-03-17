Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28A39E6CB
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739379; cv=none; b=uvacCb25YnrbHypY3sbv51UX0amJNRf/8Gw+Q7Nsj7QDnQywqEfKidhlmMvsHkLUDq7lExYWNL8mj43SRlXz7lnnfcEJGzik0PRrzgLXEr4ksa95LbBsKzjPBNJpRbsGXQc4WognPPSkhQCqYxNITPjaJw0FS7Ndd5s8nTjG0og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739379; c=relaxed/simple;
	bh=GRasFOQDQnuoi6LdOvdCuvHUGo8tuUdcLZv2gGWTa7I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ShSSV/FVyOFfMdTn8A3U+upmV4YDn8zPqDLV8V6VFtn8Anh8Zra3tItip9VEpssqJBEdFap9CKKfhYiN6cmRXhrvM7Ag4DqIcAiL5IygJ+tK6RWxSydUX74wEi++bSKLeTzw2Ap+Uf/+acR7XdYjbXDdVdhY38HH34X/nlJ6sk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RCW2JEum; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZXZrlg/X; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RCW2JEum";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZXZrlg/X"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H8IPQX2314805
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	K38ecOXWBMhUStpTWn+W7TDtJFk9bdxlpPeuhwPlVTc=; b=RCW2JEumTDgqfoZc
	h6J5QYGwLFJCRzNTGS8QA6cY2Pa0um3aSQmDaA+H/tzB0O+NUG4Ifjfn5psRtT1a
	BHfmtiVIvtmoBujayF+6OOyDXU5NPn8y60G14qjH/BcTGvKACI180g2EEI+j5FKm
	d7z+6Ei2su9wFFlmtLXV2yQ2IWs7698l26nieZJ46/x+T0VU6kJmqbwbcKUjrmnr
	AfX3jCiRG+0y/irlef+LTLUC2HhHUoSDKXVvzClJzaM89EvKHlhwOsK1AMImbUaz
	kk440VHILJenuS+tgLIyge99dqH4p3zzpWhMtOxt8Rjo1CXdDBzpr3Un3MDGs60D
	ZRryWw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxmf2b6wv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:57 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3595485abbbso6868564a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739376; x=1774344176; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K38ecOXWBMhUStpTWn+W7TDtJFk9bdxlpPeuhwPlVTc=;
        b=ZXZrlg/XVTSDL27z0anP2RFz4JVT+vRygYLJ9nJXVfx/oFOy5VCFBe2+e5NQwgS1kU
         ooapcT8SlukhP+wttpl3Js70a0oFWVZuts+8VUCZyir+oPSXmektdhw86kPppNtpWGgw
         uCWr7GLpjDZ6ucZgW1RdqHdtmnHlS1mZzxaieL38dFCUJMCKxaeZpDxyHp8wsX07HQIE
         blUY2OARK0YEYxi9b3nvZr55OZa5jwGPXuIfHWsTANncGf2g1rX+3fMrz2MKus6AB5cm
         rDssMF6lZ3+TNJ8Bi5IZ06yc/uhSkJUC5S4f/SMIZIzxuLvKPa7pwlCss9FVTmzMXj0b
         0k/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739376; x=1774344176;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K38ecOXWBMhUStpTWn+W7TDtJFk9bdxlpPeuhwPlVTc=;
        b=SIT/hRcu7gEUZ8LEHeCU88KpCnYXppo+P0sT2Q++H9/d/DsDWCvh2J4jDvQNWZlH3r
         4UTqKD2wHgYvjKv9ma0fMF5Ehz/HQ1TxiL+wjMNJ97B495rWl+0gx8l3RActiD1+XnLP
         TGHVFAR/aegowphuTEZHYoCugw4ZngqatETtUm/O9HWOvjIrQih6VHulJSRmkt3L0uXv
         YCCqArC/VrrD3T89Ci31sc0brPk0l+CqNwUhqFQm44FEvw3aE75klquQZMWfrmelVoen
         HFX9UoWrhDULh1ZU+e3q9lsITAbZ9RAkEtB1qUKioV0fuhm3gv23S7xsr3+TnsIojnoC
         ddNg==
X-Forwarded-Encrypted: i=1; AJvYcCWLyx8sN17C8yhfJxFyTIawdhSZSM+ej1fN4nhgl/fLx8lcR7JIhmol17ZDJVDP350mCOUQqUhVIXjwUaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYF/3nZpsjY0b6uc8DhKbqbHrBuQiT6lXaGHWt7FdxMRTdF+88
	hb7q94MyHT0ldROrdZAgqdOxYO09dSXDWxbCpWx3LRk33vaVykKa4eKzl1lHKAiMfmtEf4ZcY6i
	Fg5k47ThgWIWAWXSQrr2iPm+vqLiwpAwDvKgE9UPXVT66L7h7b+TIqZhGBu/vEmUMIr4=
X-Gm-Gg: ATEYQzwY4OUvjn1NyXZtJZ53YvPaLrijrP0QfYKrFi9bI9U5/6U73R9ZEk9XA6aA3OW
	dhf3/dh2EFKJ2+DdQkNHrkcdle7iIZGShWM+Ue42pPbum+zCwY+wvBNGrTYMP5AsvtuIcEHgew9
	DTnX22uT2JWAO2MeuSQC2MLsDMABXJhSN8jl+QRdgN7sJIBCkKYJTJsPM6kTPC75nExxGOkdos0
	JkZFlrBwit33wuxGt0RoUkix2X8/kv2YuRg6BYhO2ak9vUOgxdnB380o7ktB0RYnayNTnizGEfc
	I+oG/tmPbL2rZbM7HH13Odb20PDj9es1+TGI8UfQDAFytg5ZL7faJ5QgVJXdOP9YRumlUAsp2bW
	EEXgjfIdcjPm3088dg67bXOYm9hXySWFWP6KTArNwDcmVk1k=
X-Received: by 2002:a17:90b:1648:b0:35b:9ab6:1d4a with SMTP id 98e67ed59e1d1-35b9ab61ef4mr6008218a91.18.1773739375983;
        Tue, 17 Mar 2026 02:22:55 -0700 (PDT)
X-Received: by 2002:a17:90b:1648:b0:35b:9ab6:1d4a with SMTP id 98e67ed59e1d1-35b9ab61ef4mr6008185a91.18.1773739375465;
        Tue, 17 Mar 2026 02:22:55 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:22:55 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:51 +0530
Subject: [PATCH v3 12/12] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-12-53371dbabd6a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=2504;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=GRasFOQDQnuoi6LdOvdCuvHUGo8tuUdcLZv2gGWTa7I=;
 b=a4n3IxWFcsTR5Gbl0Rca2o6ovz6cpNADv2ocVDC7UUJtQvbi+2qJEobHHXL8L+yvjwzB892io
 BrQuwGTC+WCCgJGFyq1XVTOKaBQCPihkhHfoNHlB3CPl9hv0iCXY4Nk
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: kYAxV0O3NA3OJBIp5maO-fwgRyxosXTX
X-Proofpoint-GUID: kYAxV0O3NA3OJBIp5maO-fwgRyxosXTX
X-Authority-Analysis: v=2.4 cv=FvcIPmrq c=1 sm=1 tr=0 ts=69b91d71 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=DGDWbsvPyNGGEFbMfx4A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfX4kuijudIAnFx
 LlAsvfzE1OOc/NCRlyu9X+37LfSLDkb7XJ0sRsJpBTQI6PhHS+8XHzXh5kd/PLdDLqKlPxYQWeA
 9d1mVfC2X8Fp6aj41PlMVvWxeeC9H1ybbyDDuUHnB3bw7/J+r+yBJdVwdBdTbrx+7vwDwQMnY2l
 bevRbWcEtPVx8Dk7S6GmjhTD3gU9IeCvtDvye4va1juQbABSUG59fk2SB3CSLqvBMGDVYQJe5hP
 d5qClSFU2TL8FNdcceVIrdiZE1FbPwu7nfO2kcsB44J231UhDQJDsa6BdPQ3/2o+O/fRL1CBjpJ
 fN8c/Gojs83OPdz8Uu0aPYu89SXoBreENXQ6rxUSk8iIJ5h7nxH8bLsYsq3qkU8lW7XgySRLZKX
 9RQaVHTw5+VspbfSBRpXIz7HJYasSCxhaNuIPaCmzrf1e3sy02o1DNzo4sfMH9Ti/EB4vw4tGPZ
 OBwIDTlT2fi5QK6e1nQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170082

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

