Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7176A2C08BB
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 03:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778557081; cv=none; b=IlqgV+COTJzJCzV/pojsg3q/mBx9r6AR7egxDeLOZtC5ubVmj6PkljVtQH69sXxvjWZZsBY/UbBwrEzwLwg6Uf7iuZIeDCC2kEKI115EkaZrzV4EwsaOvZN2GTDWbUxNdqqv2lV+to120ca1VSCSKtUJm8x3S4dmLFv6fau7w7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778557081; c=relaxed/simple;
	bh=k+d951Qvi+Dcbct+bPdWAZBcVUO5zA4xMaJyBHeyrMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y3A3wSBdBo37AhLoAllOWJnlTPh1rhA74gRxqQlKnjA2mY/BEk8hAILMRFijL78pRdjh9vkxbYzU+tvmxBFqkA4V/CWC3W8clT5uL5k8s8GxOij+OLbSRBjXWrJIU251RshNC5LZxvGZIlSl3nHbtkTHzftxwhTUG/Ou0yB2lhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UcILo+2j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RmvlkuAk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UcILo+2j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RmvlkuAk"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BK6i3K866468
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 03:37:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=f6Lh5X695h3
	Y6NxGVDMp4XhoibCMZmokmWWM3MAxEng=; b=UcILo+2jc+3KmjBTxKd068qfIbH
	KBGjSXiKo3UPXDkBewH0e0Wza+R8yO2WSUvcijjciKy+UhG/MJtwPPnJJtuWyoPz
	f9SLDKJ1ZiiUfBkMyNumsdjTuTfGSc6ltVeUXO+3/xEGfnQK3outRRMKQjww6Jw4
	Rljl24l+5Wx+Ol5LjjY5wr30saI6pXCHeR2Y0e6ZtOATd9M6HyOqjvYsU0BtcQyt
	+TY8x6lzOP38ZMNJrOlTgOzpYNAjADTpPlMkJ0WjzZcqTHp9EJ7zQC1d9RzQ29jU
	yOaxyio7+inqqEpc0kquLJFuW2AgOK2j8UmOuzGtA17ds5x/VJai3j7WLbw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e3nv292w7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 03:37:58 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2c16233ee11so6780664eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 20:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778557077; x=1779161877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6Lh5X695h3Y6NxGVDMp4XhoibCMZmokmWWM3MAxEng=;
        b=RmvlkuAkmlyH1r5XIzf/OapV3JDFOk03GKwkzzzTvG4y5HOLIusVrMwPjS4GNszX90
         NTSK5NB87sTt7/T38XNcdwavghRuEgXwH8AybT2/e/Z/xyPMz9cSKwNWOJnxfDTbZDK8
         4Bic12bSaxxwBnNSv9tFLx21jHzgcCig1t23p0SRIuM1iRa3LlYOAZSNsWbQoxo7lZpO
         i02hz8ijaasxSuJZkG/TzmBOD5VGOLdW2ayhxy9XkAgXUcLwRl5syuUHxha6O/8PAtGM
         NWTLeJ39/WK4Hnw1Rp7DF0GV9Mj4w1cQQ6u1IWRX4VJ+lMihsJGkveTHiUeD8ujvH3nP
         E6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778557077; x=1779161877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f6Lh5X695h3Y6NxGVDMp4XhoibCMZmokmWWM3MAxEng=;
        b=Ar1mRCPdy1FVTsxj65H+ecWe0s/zKzn19XyWgOvDea33kaW62C5H7u0D35SLviW+mV
         cgEVZyjEvun8q6NEHbwEhK9z3W/9caaHj+y7seLmgRPq8TIbbaLF1BqeIQ2ee8TkP1Bi
         s7eGYMMQySv+YiNw9OBbRIaDOPepypo+01XgJKh+AaoPQCn7WSEa9rF/uf+LVhRO96BZ
         6gZrQiQrw4dgVckmf8KGvxorZqM4xdOplrWdaxajLqTnV84QLumBIKjmMGKceGTAUz8o
         P0u1uaQ5s1qY82Dl3M55jDi0CJzBBxzjeD1rMpPQu0hlQg8ykDD0T+Ok6jiT7sOP2HGm
         ICZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9TRyUt+vAPuEAHGXvs/sbqOxpclaSUjOyhkcviu5ZhGD7XOVRr9R2kY2HKCebmg2VheuQFp/mq5U3VGKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbdsIWP9h1t+TpmtaBOTRwdG0lIbaGdV9xrL2jLd6NwrtTL9LK
	Bq1VJT0GLLNNKaG7WWoVWCUSgB+W8V7pwzh6WlaguWdsinY7AcIgV2gf6Bx6YrDus91YY6uzVWp
	3R/kWa8rZbSbP/3jwWiX9ZT7KVFtcOzIXlYCWsKgLA8DFQ85RLuMPuuOhyHlFd8xXxAY=
X-Gm-Gg: Acq92OEEWR965ZvMpifI5oebnTsnYxxWE3nF1nWbzMPbL1ZLc1KAsJDcEeIfxaAKap8
	UYHNMDBQErNUB5c6A4k52B5CbloZLeaWG1CJAcNsDqJCRy8N5HkQFwWqngnQVTRqxP0JBUKqwVk
	2GKs3HJivt3g7VlxZNLtVw+EeOiN9ql50Al4I44Vnyp7Sx+6pUOSsknTbxT3KbaYLLpyv0Vbmwj
	7tSmLpkbtAGlIFggyfdg7zQtdDyTg/dfGSjidggrxNi46b1Wg1ZHf00KEJexIVuXxackmrCQOGA
	jxbYz8OZiGm8/VXbfV8+B4eVWa9ZMYjZm0ml1LYzblOiBgtjNBZgBy88k5FDmR17uDagsSv/4FF
	BMUb2LiYBJ7LLMEFNATMS+M/+ESo4cgkEwPryClHJHPKcZ1mOihvXlveLbh0+5UGVioYn9UuCq9
	vC2Jhk
X-Received: by 2002:a05:7301:6589:b0:2ea:edc0:4fbe with SMTP id 5a478bee46e88-2fb4bff7bdfmr5950466eec.14.1778557077398;
        Mon, 11 May 2026 20:37:57 -0700 (PDT)
X-Received: by 2002:a05:7301:6589:b0:2ea:edc0:4fbe with SMTP id 5a478bee46e88-2fb4bff7bdfmr5950442eec.14.1778557076836;
        Mon, 11 May 2026 20:37:56 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eb4b7sm16730109eec.2.2026.05.11.20.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 20:37:56 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
Subject: [PATCH v2 2/3] soc: qcom: ice: Enable PM runtime for ICE driver
Date: Mon, 11 May 2026 20:37:49 -0700
Message-Id: <20260512033750.3393050-3-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: JZVP4UEAy9vR3_65lud7Fv4k_Jz2PyBG
X-Authority-Analysis: v=2.4 cv=Mv9iLWae c=1 sm=1 tr=0 ts=6a02a096 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=7JBRkwD79zxFga_vYKgA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: JZVP4UEAy9vR3_65lud7Fv4k_Jz2PyBG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDAzMCBTYWx0ZWRfXwUhZ0Pv1oTPP
 R/XAjlo1Y8kslMZZg4lBnDGk7oH5TLeYeuXK98SjuPltMffYU84P5tcfbvyqvwUYhTEK+GycWkX
 ZSnrdnQFSiTdqBQEYrPyIeBsFvaj8umjJ1C6ibjPiPvGfXxHzbnW4Zxe0l1moYjg+AiGdlJJLVb
 VaiqOq0m+HRZ2hJfrXth+ZZn+RwOPBYCOO0ZGAgLj1K3R5VDolNDoOpwnYVsRPDbJw3rgF2eAJI
 YUXSkaJR5Z8iqmvJl141Ewoc5kM4+uThgvujnnWxTTaQF3EpnNDpknN/DhcA8JKVhRFBJDingaU
 8aiuJv3khuSfqt3Y2rVqb0klb3N2dmBo9KXUX8TonJIP6lU3MmnkFhaL1ITJ26YgtSV6hQT2fi4
 Jz6qFJtTGNHRh6DJBjv7aKkepGUExFyk12PZmKvTVcog4vPZPve65V3Bb/c2r3Y6S/9JMBLX5/1
 MloFlgqQpeld4wabLMA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605120030

The QCOM ICE driver manages the ICE core clock through direct calls to
clk_prepare_enable() and clk_disable_unprepare(), which limits integration
with platforms that rely on firmware-managed resources or platform-specific
power management mechanisms.

Replace direct clock management with runtime PM support by moving clock
enable and disable into runtime PM callbacks. Use
pm_runtime_resume_and_get() and pm_runtime_put_sync() in qcom_ice_resume()
and qcom_ice_suspend() to drive power state transitions, and enable runtime
PM in qcom_ice_probe().

Reviewed-by: Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Reviewed-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 58 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cad..6f9d679b530c 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -310,8 +311,8 @@ int qcom_ice_resume(struct qcom_ice *ice)
 	struct device *dev = ice->dev;
 	int err;
 
-	err = clk_prepare_enable(ice->core_clk);
-	if (err) {
+	err = pm_runtime_resume_and_get(dev);
+	if (err < 0) {
 		dev_err(dev, "failed to enable core clock (%d)\n",
 			err);
 		return err;
@@ -323,7 +324,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
 
 int qcom_ice_suspend(struct qcom_ice *ice)
 {
-	clk_disable_unprepare(ice->core_clk);
+	pm_runtime_put_sync(ice->dev);
 	ice->hwkm_init_complete = false;
 
 	return 0;
@@ -716,24 +717,69 @@ EXPORT_SYMBOL_GPL(devm_of_qcom_ice_get);
 
 static int qcom_ice_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct qcom_ice *engine;
 	void __iomem *base;
+	int ret;
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base)) {
-		dev_warn(&pdev->dev, "ICE registers not found\n");
+		dev_warn(dev, "ICE registers not found\n");
 		return PTR_ERR(base);
 	}
 
-	engine = qcom_ice_create(&pdev->dev, base);
+	engine = qcom_ice_create(dev, base);
 	if (IS_ERR(engine))
 		return PTR_ERR(engine);
 
 	platform_set_drvdata(pdev, engine);
 
+	ret = devm_pm_runtime_enable(dev);
+	if (ret) {
+		dev_warn(dev, "Enable runtime PM failed, ret: %d\n", ret);
+		return ret;
+	}
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0) {
+		dev_warn(dev, "Runtime PM fails to resume, ret: %d\n", ret);
+		return ret;
+	}
+
 	return 0;
 }
 
+static void qcom_ice_remove(struct platform_device *pdev)
+{
+	pm_runtime_put_sync(&pdev->dev);
+}
+
+static int ice_runtime_resume(struct device *dev)
+{
+	struct qcom_ice *ice = dev_get_drvdata(dev);
+	int err = 0;
+
+	err = clk_prepare_enable(ice->core_clk);
+	if (err) {
+		dev_err(dev, "failed to enable core clock (%d)\n",
+			err);
+	}
+
+	return err;
+}
+
+static int ice_runtime_suspend(struct device *dev)
+{
+	struct qcom_ice *ice = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(ice->core_clk);
+	return 0;
+}
+
+static const struct dev_pm_ops ice_pm_ops = {
+	SET_RUNTIME_PM_OPS(ice_runtime_suspend, ice_runtime_resume, NULL)
+};
+
 static const struct of_device_id qcom_ice_of_match_table[] = {
 	{ .compatible = "qcom,inline-crypto-engine" },
 	{ },
@@ -742,8 +788,10 @@ MODULE_DEVICE_TABLE(of, qcom_ice_of_match_table);
 
 static struct platform_driver qcom_ice_driver = {
 	.probe	= qcom_ice_probe,
+	.remove = qcom_ice_remove,
 	.driver = {
 		.name = "qcom-ice",
+		.pm = &ice_pm_ops,
 		.of_match_table = qcom_ice_of_match_table,
 	},
 };
-- 
2.34.1

