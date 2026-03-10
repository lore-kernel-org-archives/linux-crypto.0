Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02673ED5AB
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130100; cv=none; b=dPSj+MLO4tcRt9Pp28Ou9lC3di00ht1RfYHgs8ZJcRCCc33hZXASuIrjT/cZFEtjl2lo1/F1ZUK8QfbP3yPcuBiKfmBVvakQmuIVahd97ObMVgVicU3DGeIv17FL/AQ/i0rf/UlZWQkxmSSKJEkSEKCnt/KicwXEkV14rMCZXB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130100; c=relaxed/simple;
	bh=G9ixEOwpkM6AQ7Gv5+X9OI3maNywSVPU6yqttuFKDno=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RbMCO9V8aG2olP49o/ka6GMjnQjUXUvZAHybtci1D9wMabGDH9DN/0xq+BDdGNDd6E/tQ5XVKJDWxUu80px+nhJ8PTtNKZW399uClTF4pBn5dG8Xieto+vAui2mmZ7RWuSDxTDIRngMNtdjnnQzQ7NnTYVdmlY+Xj43SF8Q7D5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RDoUPGkX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IB5o7Ms4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RDoUPGkX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IB5o7Ms4"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EKuX2363185
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aLh+yiUZuoUGLqqiHdB7dyI7NuqsJNxkPrS+/r6wS+E=; b=RDoUPGkXvdLMsiJ6
	ZRKPC39R/Glo+E9wnvHk5LHn5O5sAkdEbk7W+uUtjKNJTLm3jrafvcsj91ZpNFuN
	ZkOPewREZuVNcE4V4d0Zd+D8Of8NU8Y4zmNOZzpttVr2+YhY6e6PUexwp4KOMhXc
	GE1Qr906r/8OkiPw8v0lU54yjcy3QwMcjhycrXyhmb42wwg0fENn4VN6p50MzkSo
	8pbWJXoVNpkvxmoSQU30d9aOVJBLIfaPra8Q1wP2oxNSqNSgAmqHCerL83MYKuUB
	UtXbObV3S+lwhvS8R1ac63QtdZrKMDHgAFa9mZ4UFfnsbRe3uuu8dAWfGSmD1P2U
	gnW7aw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct032b780-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:18 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35842aa350fso59637657a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130098; x=1773734898; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aLh+yiUZuoUGLqqiHdB7dyI7NuqsJNxkPrS+/r6wS+E=;
        b=IB5o7Ms4nqSNGjbcsIuQIS0umzyCBFffZoPqNYJSB8s4zUNP6MrWTbgedWYFSxaWPB
         QXXVNmGtoYMLIgsgBMjUgg66Xb1KMzJlf1NFAEoqLTRtrhINDEiBSgz9a25wOFQ1oLs/
         pUzlvT9SIBgEch/FNGuL+mytSywCO9s0PnaWj1uIkjMrVjTNvCJ9VFmuVM2gBfKamoxx
         O58i8zjCD5SF/w3o6wLs2fPhXJZE7GylAkOESR0a0qrF0I6k410VAApVkqG1vB0tX40W
         Qat5dU+VCfxhktEJ6g+vHIoFy+j1w7mJuthB2NkzPM8dajzmzG8BxHX28iIxanRSEWMi
         iAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130098; x=1773734898;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aLh+yiUZuoUGLqqiHdB7dyI7NuqsJNxkPrS+/r6wS+E=;
        b=ZFrOMh67IjS8hqjRD9p07TBp4wXandsidwrsPmogAzdU0dTvdbLqaHNC3Br3Cm7G1g
         mqG4iRq6AsNSwoMn77Kb+hVEJ9cy+iE8NlcXefjnc5r6B+ru5jfuWC7KTjKa9nSk7eus
         mQoC4qJRwBhXUDQD/HIv+5aYxa46zYzGk50ksxmXVr0JdlVVxK1Tb8Tdifh/qwiO5gf0
         egDdOuYN+mZ4KiFS0oqdpeRnKaCOWrdbanXCzgllbsyZFJ8SDCTdAdid51La7YAcWrkF
         Eb2mCSn1CQTL3sjoXkt68KnEVEjb33hw5UKx+ADv8CM48up4WM5QKdeIZIo3Dyk1+1JG
         +FjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhxibesCgz0169RO2PwxdFT7l3nozNjpm8ZyIbuoDxHt92cpLP18Q8KWbCz4+cHcbAeMGW8AXd2Q9u7Ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfwwHejGNgD10of1/TI/yb9LFKbvN31nZso13PouBcrclJ1j3+
	qig24EFOvI6zREy1YvWzj5qdkGf0CaIryMf+Ef9z2BBbxd6yFEXtfhOkyiJUVfAWC3PSzD8e5+e
	HmryXXEluS2icqcIVETRZ3cOkWJXQZYDcOmatN9ddtjrxftCsAXhZ3zbY1rYeRLDR4+4=
X-Gm-Gg: ATEYQzzdzK3yCCcsw7nsOEhXhvD2Vea/6Y9lQyJf9FH8fNidmiyNN9q043OpyNi9J4/
	TvhcssNS9oG1Pxy44XCoIaZrVO20Y38+JTqp49HYPyAE36P5UGvRQFPL9RKZ9SPZ0Gs9KNfpIY8
	Zx8/3N9uJKZR3322gXE0jliBegQXnBT/9h+620c4kGUApQMGfGrUo8vmUGvqJSDus9+VrH+OzeU
	sj2cpY5qt2nW+01dWRZNvBi5xM0oGUeRMvqRLPR+JrDdlEJrn3qjl2Q2IJN8DWFgQELVP6bci6V
	jKBgzPj2dnKGm0aF+npmIR24gpOgABGUr6ab+UApQ0tyWI4a1x8/TSODIHZjZ9jTxUX/XgQZYSy
	pEowXQE2udBpubDtsQRBXOte6ISh4jjNDowRpNszGaKy38T4=
X-Received: by 2002:a17:90b:4d86:b0:349:2154:eef4 with SMTP id 98e67ed59e1d1-359be2339a2mr13209844a91.5.1773130098295;
        Tue, 10 Mar 2026 01:08:18 -0700 (PDT)
X-Received: by 2002:a17:90b:4d86:b0:349:2154:eef4 with SMTP id 98e67ed59e1d1-359be2339a2mr13209823a91.5.1773130097821;
        Tue, 10 Mar 2026 01:08:17 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:08:17 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:37 +0530
Subject: [PATCH v2 11/11] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-11-b9c2a5471d9e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1945;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=G9ixEOwpkM6AQ7Gv5+X9OI3maNywSVPU6yqttuFKDno=;
 b=RlNpgKM72mbBIQq5XMGzBE6lqHa0BE2Fex6m97GZXlEgTgjQYsdPDVS9skum6BMu2Tl8ep9yG
 OCR2btGFZG/BMmTsZsGbDBpinmrel1g1YGy65NrX6qlxi+K2Z5fSTBk
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfX5HpeU6n0m9EJ
 JUKx/ArReCQHkuZT9ITjgDrlRMYzr3CW1nlti2ZFyAEm8BbYmDAjD0WbLDWU7AYgTf+bvoEeg30
 hAL5iNGyVqB/t70cSV8wjru9+lyQCRt0HrvV8cUBcBmfUxCU72jzqmnt6BjfIFAv812db3WaUZw
 NVdoSSLnsxtfIq+Alj8m8gQxKUrt9EQ0owt7NadNEthvkHk9loxHOR4UBIlEnHlZu8x/5mP4CPY
 YSzqRAyNkWhY5jFbblaNS4RMc0Ostcn57btmoFtv5UeH2Y8PgCv/0VfPttpogyrp8LN7C6KTrPW
 L+4vx/qNonKDBmAhiCkUO8uu+98t+wK1Esj+LgC+55VVakiKAtk0z706IMCzOPnSXY21ytifzjl
 W4zBKFf83mcdaGmb3ykIxGbn7YlseKsvzGoK3xvnD2ULfUQAEZ/WBW2XzWJjVPOMYZRbhkhmiWQ
 Fsz5wVkoGy/jHwKlQLA==
X-Proofpoint-ORIG-GUID: 6q57W0jUlT04S5LwVel9HmFFXKi_odjB
X-Proofpoint-GUID: 6q57W0jUlT04S5LwVel9HmFFXKi_odjB
X-Authority-Analysis: v=2.4 cv=WtEm8Nfv c=1 sm=1 tr=0 ts=69afd172 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=mORad39sGlqzgvJT29EA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100068

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
 drivers/soc/qcom/ice.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cad..e05dc7b274e0 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -108,6 +108,7 @@ struct qcom_ice {
 	void __iomem *base;
 
 	struct clk *core_clk;
+	struct clk *iface_clk;
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
@@ -316,6 +317,13 @@ int qcom_ice_resume(struct qcom_ice *ice)
 			err);
 		return err;
 	}
+
+	err = clk_prepare_enable(ice->iface_clk);
+	if (err) {
+		dev_err(dev, "failed to enable iface clock (%d)\n",
+			err);
+		return err;
+	}
 	qcom_ice_hwkm_init(ice);
 	return qcom_ice_wait_bist_status(ice);
 }
@@ -323,6 +331,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
 
 int qcom_ice_suspend(struct qcom_ice *ice)
 {
+	clk_disable_unprepare(ice->iface_clk);
 	clk_disable_unprepare(ice->core_clk);
 	ice->hwkm_init_complete = false;
 
@@ -584,6 +593,8 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	engine->iface_clk = devm_clk_get_optional_enabled(dev, "iface_clk");
+
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 

-- 
2.34.1

