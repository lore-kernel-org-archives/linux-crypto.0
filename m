Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67A537755A
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152428; cv=none; b=bAxQ/LkAiPwQ/5nNFHxYzZ2S8xMd6KZbB8L2C2tPpdZHQaD6eHjjhe/ngkmZWcXuwFEsBX5DWbYHlS9qAEK4Q1YrkCRB0mmYsF/E1Q5AAIfEEFaFMwaXQGrkPv2koyq1+uYBEOCpMtC3LXccafeoKZGuLvzL1p2A7GmItfElAQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152428; c=relaxed/simple;
	bh=FAydTEuSpolIPbgdCzPABbxgas2Q93+RqfmxMnmHLg0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JAUfRPcUhjLQWcahc2j3nEbXHhjWEJBpy9da9XMsPp1sJ5ngCkd5N+ddjLi0fY3m+uhlqd/BtdXl8pluBuxBzIXyggH/XdAw9hw0wVOgqV5kuFtLA3Cw97H4VPJi1HrlllazP9voZiBGjU+ZNGymo3OotuLuCYTwXMtJbIYmmbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V256o5J4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GUsxnhOl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V256o5J4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GUsxnhOl"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N4eoTI3677889
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dFEJqMm3Lu8V6b4IeyfhRQweFSAUcJ6M7eJtDdl84KU=; b=V256o5J4rtn3+PgF
	c8cDmbUnmJnTGKIkqWNS7om+1oR7fMTOOJBGAnUFt+bFn+k1AzFAkALmqr5QME6d
	OOwiYgLFSagAAaWzP1vauMETQOHz2LfbPvr5vQa/tTxUJ+aeRYGpINmggiqRK1bs
	HbEon9Up/Ej8h+p9dTcaYhdYEVWWn6tfPVY/DEqXwS4ENfYsOAyn8s+XNMt1y0+o
	xmE0P/jhI4/oKnNcnYtzDKTWPyi9JdI1H9G/cTyNB0wC/OxkDZh3wdjqUahPjxo+
	0Mw4vD5GPCAlZZ6LdfNTMkQYeRzRvqRefVx7Q1RvhK8bJl1QmZdtA6MucssKhsBy
	p378ow==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buqyp2esp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:33 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a7701b6353so18694535ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152412; x=1769757212; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dFEJqMm3Lu8V6b4IeyfhRQweFSAUcJ6M7eJtDdl84KU=;
        b=GUsxnhOl2aQEM3EDMyQVAy9/MbkjYyYt6QQMd8F0/ram4Nb+sWclmmUlL8kcJZAR2w
         5BHBy1OtPwzQHEiUZteEYb9Z/yeiY3nfZR5P4/EEtPCYKXcKZ/IB+3jlY3HChQ6Q1ArG
         r3ZulT66pHmf5BRzZu8asJKXRmE5vIWskgpUOjPfCrvSGHmEYZig8fXzBYK7gCqytznO
         UrBC8W9FacbpBFbVqxSJaZlA275Lm4EKbnIY22R5632wB3PR3sN1CtrT8Dgif10zUM/o
         mTAjjhPQoqtSxBKxUP0uIu41OuvTK/17YA68RJkGVpHbpu6gFYODlNtcCV1tVq5gGMAQ
         lgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152412; x=1769757212;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dFEJqMm3Lu8V6b4IeyfhRQweFSAUcJ6M7eJtDdl84KU=;
        b=oYd0IBZJRSI3DQ5juScJNQ7+4c2CbDmf9IJXpSNhrueDORVkWMty+SiSjNMvru5HL9
         dQ7Vn3lq7nhx8x87gnxwPcDkcQgb/bkBjdDwPCH86bb2aSrqz19kvR6Ubhc7N4Uq56JH
         7FutIpmihoWX422BFqz1bYxYGrTQ0ZLvXI2Fn4YOS0vMnOa0QAXgZ9qF874JiQuBLvyB
         sW0EqWPZyp84LozYocxtewNRsT89ntlMYqvoq3A8da754mWyKSUKhUXvGBCjTh90QBuh
         WS+rsKm8ZbJmu7ZQSnwWbZ16cQp6cyX+zHMLIeYOyKrLPfeLUke5zO5gdiy7BY4wVUh2
         9+qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiMue5ZNZJtpH6YE9nQbx2iCSYcRBE5AOrCL/S9YtMqXtqtvllvNX5lVOnol7hQH+mo3G6NalzT0Z7diQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxFDlKqXem53DIWWZFG0zPONdeIL0pWI/uJjkIOgciHkWW1QQF
	mvfObIPW05F8dodmNgitMV4zSEsEa2wXWc2dEyWRK+5bbbGPw205mz89IWEzrzQn/ZkkJTDYOxk
	uC80BcEbAwXzDvNA+g9ozcetiHTI612rcvpBW7JtUqgr5BUuoobAN08idBx/u2qzldDo=
X-Gm-Gg: AZuq6aJRUygZMazOfjNVFiSh89fxCyX7rs0cs6qG23ZJG11GIRDtMcrBHS9NaKW3a/g
	5aPV689l9Whmaxzm7m2g+llr31tKHEzZyERdnuQJ/GfCftlKgRYi8AEJ3kyJM5D2wmNJ3DzTJfp
	b2ixEEyFe+0dNm1G1ALXJKQooG1aqOOuGqfY5+jIm8vlOqRY334A4EDkZpUVWXi5QqgAobbHcyj
	q8Kaji6AOiNMxvGU34xpFHza/9Lw/dynanvQKtzLzNfliPlN5fGoEzbXcmpvQUKm4UwJa/nKTE8
	5bDLgalMSuoAk3dH2GxspaMeWs0GEuAqgPVQTRVIX+Kgg2apn+GLPNqAkObkWFa4JLOAyJmB93A
	GouJ/s1JCc6XuQ2Qq0Q0IetuaIymlM1Cz2rs=
X-Received: by 2002:a17:903:1c8:b0:2a0:cb8d:2edc with SMTP id d9443c01a7336-2a7fe55a646mr17345505ad.13.1769152412400;
        Thu, 22 Jan 2026 23:13:32 -0800 (PST)
X-Received: by 2002:a17:903:1c8:b0:2a0:cb8d:2edc with SMTP id d9443c01a7336-2a7fe55a646mr17345215ad.13.1769152411877;
        Thu, 22 Jan 2026 23:13:31 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:13:31 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:35 +0530
Subject: [PATCH 11/11] soc: qcom: ice: Add explicit power-domain and clock
 voting calls for ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
In-Reply-To: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=2522;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=FAydTEuSpolIPbgdCzPABbxgas2Q93+RqfmxMnmHLg0=;
 b=ad08EUFi/SNxt8P3OUY3DK1VxPif88I6qLpdUMVODH5gqLymjIDhedZVOx9bmmaCmvtGXDYkN
 2h/SiV1SNPUDITiIf7UlCQUEfkG+pYBOVK+g9uzGvyBSHXpzRRVaoNp
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=RMy+3oi+ c=1 sm=1 tr=0 ts=69731f9d cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=DGDWbsvPyNGGEFbMfx4A:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: 4naWBszgDwj6rVE_Jnqzwa3indESntdQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfXy8oSok3YnidS
 HzvyYB4OYDsLc8l+dXmOXElLYHy8qX80KjwZtVjpqOVOxGhAtDl/JrCu0rxDz9wh757ALm1Y2/x
 vwdJ5zV3Rz62Lxn6uK81uvg41+DZyzxCu0Kqed/kZuYnpZ99Cvbs8tOJZOB52tf1d56M6D2NhWQ
 4GsazbYi5WHTXGh3HEHM4TRYMgAf8pmP6UPqsSv9fNpFHv2RB3x84kiAIxtD0xrOB1ZqpSmofpP
 ycv0Hya+fkkzxCBFV1vKBfK+6QD6UnzQx3WugrrVYiUNBDHQMuUD0oMihWVdsHb95V3vjgSKhhA
 ja01LgnVI52XDPaYGAiAeaPsDiWOXED205BmazED4xnYEQGTQTvzIlMs+WiAcu6ST2qCpXzCCR1
 A92Ql1WiRfiieII8AJmkWk89CskCze3s8tJyiSbm0X3Hrmz+5n69uoEd6Xd+71f4VI+n2HegILy
 Jt0dCjJT397xQrEm/yg==
X-Proofpoint-GUID: 4naWBszgDwj6rVE_Jnqzwa3indESntdQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601230054

Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
de-coupled from the QCOM UFS driver, it should explicitly vote for it's
needed resources during probe, specifically the UFS_PHY_GDSC power-domain
and the 'core' and 'iface' clocks.
Also updated the suspend and resume callbacks to handle votes on these
resources.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cad..4b50d05ca02a 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,8 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -108,6 +110,7 @@ struct qcom_ice {
 	void __iomem *base;
 
 	struct clk *core_clk;
+	struct clk *iface_clk;
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
@@ -310,12 +313,20 @@ int qcom_ice_resume(struct qcom_ice *ice)
 	struct device *dev = ice->dev;
 	int err;
 
+	pm_runtime_get_sync(dev);
 	err = clk_prepare_enable(ice->core_clk);
 	if (err) {
 		dev_err(dev, "failed to enable core clock (%d)\n",
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
@@ -323,7 +334,9 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
 
 int qcom_ice_suspend(struct qcom_ice *ice)
 {
+	clk_disable_unprepare(ice->iface_clk);
 	clk_disable_unprepare(ice->core_clk);
+	pm_runtime_put_sync(ice->dev);
 	ice->hwkm_init_complete = false;
 
 	return 0;
@@ -584,6 +597,10 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	engine->iface_clk = devm_clk_get_enabled(dev, "iface_clk");
+	if (IS_ERR(engine->iface_clk))
+		return ERR_CAST(engine->iface_clk);
+
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -725,6 +742,9 @@ static int qcom_ice_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 	}
 
+	devm_pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	engine = qcom_ice_create(&pdev->dev, base);
 	if (IS_ERR(engine))
 		return PTR_ERR(engine);

-- 
2.34.1

