Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED7E2253EB
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519306; cv=none; b=h/6bHg7txD/x+2kBWRhWKI1lgi/5jMhUTuWNKEqaMVnP45FiUMdwXHyEDyHoTo4EeuBonZZ3XHNSnK2ga0AMbtsvicI3ROBkEgjTM+IyLM4VYnOF/iIh75+OoTLjMt+q3WVFGQSS6uTOROnvpp03Lf7YmHBsCCNsyGjx4o0xn1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519306; c=relaxed/simple;
	bh=k+d951Qvi+Dcbct+bPdWAZBcVUO5zA4xMaJyBHeyrMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CP+MCSpoRJXuZs7fd1k0eghTlU7dA23W/BBYyjPiD+s2O9x3ygOj42+veuG5vM4R+qo3b1EzokhBlaHN2fbjv3MYeb8TBTFggAs+1toTJ6yJyfdCC2cFQH/XqfbTYq0oRj6gFJiQPgO+mEG701bQIeJ3rbK+d1j81iV8WReMhV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BFrCAxCL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R1z5c4ol; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BFrCAxCL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R1z5c4ol"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63TKbm5W256282
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=f6Lh5X695h3
	Y6NxGVDMp4XhoibCMZmokmWWM3MAxEng=; b=BFrCAxCLqiXdEyuXTHziAjQN3bl
	bnzRIce/n1/6ahja6WUfK+wgwyK3zAvLAU5L4EVwgfRVAU5lEZ9n+g4OLVdyoO4w
	6NB4mzOELXnNie0JxGj2dMzFrLj2kUvoDNvXY7X/ka/DANO/FKvC2bMGB4vtp4Sp
	fINacM/xFZdABUmy6UB7R4YnwIBwy60cnYY30kVLjQ2y8y9xdz29mrG3WOtcDJvy
	rcGlPt4wkIzyq7egtSvso0OKpL20vWA6M0na4ie8wmJqy9AhGvKfOE1UavsHOybE
	J+e+6JjJ4CRJOvCrvUPnPjkjy2HN3GTT5WXLQmdHwxvbE6eQOTWNQathm4A==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dun71j2m5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:44 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-12c726f4019so618108c88.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 20:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777519303; x=1778124103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6Lh5X695h3Y6NxGVDMp4XhoibCMZmokmWWM3MAxEng=;
        b=R1z5c4olriJuwLJ10mYo7rUHtYUTmStg6k4AcvISey7VZB06XbTKmpdUZHCBaBTAN1
         eZREaPAry/X6RiKfoQbtXGT6O+YwrJzRF4tiTlujhSCQg6wTx18Vf5YtmSUpklLJwUcI
         owmlHm48IIGIB5Bmfr1G//qWyAlA0OF5NWwqV2xi7hudGd5cEdSmb7+sq0R+MirsACfp
         jzk9gJeqWpEa3ElECuJ/CB3vN0HTTk1Xp6XFdv/Vr1ehlZ0L9RCQNllsEu0JK8kibWp6
         7VPAxioR6IHsT1V+OKFezS5eTJdo4QcFqr+PfxInyh1uHV+wlxE3rRmzPo3BN70/tbzC
         OLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777519303; x=1778124103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f6Lh5X695h3Y6NxGVDMp4XhoibCMZmokmWWM3MAxEng=;
        b=aQj0GsVrAw1DzXME9876NKs1BmxGQIPFNqxIlxjHZCfcPme9Z/knu5Vaw7JV+ZcO0n
         ts3Fml6qHywO984YHe1wt3gB/nrUO8jdZXpHaOJa8vztQEOS3Mj5uGYWLZGPrjsqyILm
         4ND2g36kvc/TzdVw1rK8kkjVnhak6F5ENu/mrfC11jmbUxp05EPfoKtTMsTQf/H9591E
         idWvfR0ie5s0PFeSQ33hjKOHZMUn57kf8PP+Ve9HkOovlS2V04XJ6ezN6Y+zduBsISdM
         mwsBdONvJZ5S1Gu6K9u/4M9NtwQHFsqlQbdKttivO+6JoKlpSGtnI+z1N291i99+QHgt
         QbEA==
X-Forwarded-Encrypted: i=1; AFNElJ+pQ5s/GAgqAIUM4pRstBYutswwrOL12Qe8LJtBEadA0NoNcpw8L8tiQeH4C5b88oRd9Sdwlmk4P2at1TE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqpBrRmOII9lStRZwTtbpKctqpl65RVa3zRKwiu67mPNnIqMoJ
	ShO0qhVC6oYLIuZR0i9T8bWyyMd74L3Mhj348w4kDDtq+m7tHDz0e5uq202A+2lID3jZXCHdH9Y
	zsC3W3VWUkRdXtWrqqEWL41IXqC5iRY+UUFhJEnj+MQ2QJuuMbz7HGVL/wMw2q/kZ/+g=
X-Gm-Gg: AeBDievnqXTEX/8gDPClzW9DUUC0LTLTVeLH6SlVuNQfXulsaXN93vQTer3RVjTNoxI
	vUWQB/TSUONsiR+FiBzRlkWCWiME3GxEpbb6usV3ivUVgtuSvdH9OjFGf5yk79k0jAWYl7Zpqfr
	yO+9zJ7ySwZGoMXlsw/AUdgJDVKim1RdRRYJB8j/blV3+QOBpIphXXisieBfcsBq0dZG8z5b4Hs
	ephTaBYILtlwvmDZc9sEKpxiqx5/wtpizvpL/o5aQAqkad86BG1AI2wpsg19bepb3LZx5SGmUcn
	BBMg+lpmYMDzhmix87btHfT/60RpSHOJEkL4VVUq+FsdTJKkUr3y9OAWZmazq5I0INNQETHGdsh
	nq7ae7s/XGHkwUsLIRHeawCIIwub53wxx87gjBZu4wcEQLkXqVJniGDdvjxqC6ZwTF+MtnYG6t7
	iH4jqCFk0FlcvbQx0=
X-Received: by 2002:a05:7022:1281:b0:12d:b175:2573 with SMTP id a92af1059eb24-12deac4f473mr617849c88.7.1777519303430;
        Wed, 29 Apr 2026 20:21:43 -0700 (PDT)
X-Received: by 2002:a05:7022:1281:b0:12d:b175:2573 with SMTP id a92af1059eb24-12deac4f473mr617831c88.7.1777519302926;
        Wed, 29 Apr 2026 20:21:42 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de321df36sm7572644c88.7.2026.04.29.20.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 20:21:42 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiggers@google.com
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        deepti.jaggi@oss.qualcomm.com, bjorn.andersson@oss.qualcomm.com,
        quic_shazhuss@quicinc.com, trilok.soni@oss.qualcomm.com,
        konrad.dybcio@oss.qualcomm.com
Subject: [PATCH v6 2/3] soc: qcom: ice: Enable PM runtime for ICE driver
Date: Wed, 29 Apr 2026 20:21:34 -0700
Message-Id: <20260430032136.3058773-3-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com>
References: <20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: maC8SKNJvAFeHQnoqTicC2WaNCI7S0sZ
X-Proofpoint-ORIG-GUID: maC8SKNJvAFeHQnoqTicC2WaNCI7S0sZ
X-Authority-Analysis: v=2.4 cv=TvHWQjXh c=1 sm=1 tr=0 ts=69f2cac8 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=7JBRkwD79zxFga_vYKgA:9 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDAzMCBTYWx0ZWRfXw1U2oKgunNOh
 n+Pxj426lAtQ7F95vRU10SWBCK3MBJuU4bHUmIntdQqKpgOxRQ47MD4byjhoBUawnOB2yxq866i
 2uH2y6bOsICkxukvnKDv6G9Ffdh/FdI5kSi4WPygp08rjyJ3cARVQGytLK7a3isvCf1PSsO7OvT
 t8iUL1VgxsRl6SciKpmG0FaojGG9yLYRZmVVgnWcHOr50U6mIp5WpwfVPGd7FqnKsX7cjRc262G
 ZJcOKEELpgSFPtN3RHifVcKEUEkznHzgfxUTfoZr9+bp2PLNl48rtkHoPJUIvV2Oo7Ga1gwjo4f
 u+ZittLAy+swmt75pcIzDEzM9dLTmPvm4GOiJwkatXo2PrpwWIHChUWjAG8/RYz7jM3w+oMOj3v
 Pu3g/Pj3nRneNUoIsPYm/znChmCGXsyazVAEaFh1B0iHTU37IPHYBEK8egIAcxZLIun9sSmv1vf
 HtF+GxXoDOW2t3BkIvw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_01,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300030

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

