Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEA9330D23
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519308; cv=none; b=b4mbGOUXNQeNB9uV+EkP1nc+qxL3Txw+zU8Cn6fnWKFWsNtRjVFhJXnAySCzRIQfwAqMWDCxZgx9dYUxb3XIcK0fZ3JDTd0h/H9w9ikfqrIfntVi/23a9u8q5hnnAdL1Gx/wc7wP5Kb3gwvhT0gchYUMUyd2WvF5r9kHQMvpLLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519308; c=relaxed/simple;
	bh=NFa6T1OlpES6l8VtfHxFeXgujLOXbuuENS2CTFHA2J0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RRXNKGEQpauXwhNpfN7WG+2dq4T8eCB/9N1xKP6uWk9wBR16R0RYhjB2LGgdHprs5rbvSae9jYJcEE988K3opzVUg3e/IMT3JU/0Y+s9+fHYUZHh7U+RSQ3Ron3/Lpa4f02KOA05wKvJWQ+ruJwmL7JwhHloP2AXd2gvFgE1tKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R1WdfeL0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JZ2VfCOA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R1WdfeL0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JZ2VfCOA"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63TKbQNu1809354
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=UL3C3PYs7qb
	8LJc+zdz+SzMOIXkiCyeUwN4vYWoaCaE=; b=R1WdfeL0vO2GfQxQ7TfSHjgaGJ3
	3iNCB/RwGkYn/U3Wk2+hg0x5KKMXlNpWxSLlxxcpjsZrzK3Nxx5Mmmh+HZNpNtRu
	gbgHvMmsAkNgmpbKOfklDAR2zNUVsoN7vvnFkT2Dgz6j5N4/U1Pf3QDv6SuRgYtb
	0pnAsleIJj0+XHIfqRK1cMFVQg5gn35yR9B//nSSMTLUHxIz/iZRJC1GreF8AAWw
	NvP9LWhlxHjbgJUHPQAkRowevUh3I6/oegXSdfe2noi7ZlfuYCjOjt0ew5G1Hmbt
	MSmo6ui2lSNGS08Ir4USukk3K1/8WFU25vhLK8++PA1CmmZrhjhqUGjvTtg==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4duj6tavxu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:45 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-12c8ccc7593so741380c88.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 20:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777519304; x=1778124104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UL3C3PYs7qb8LJc+zdz+SzMOIXkiCyeUwN4vYWoaCaE=;
        b=JZ2VfCOAPSaOFJK5qTCwJvaJMzF/HqmmwH4gWFA0TW+LHaMzi1mHaX+9VyEoQJOtE2
         M0dRk4phuh+FHefVpy8vMJF7kKZ+TASedXfalG6An5uPkWzRCrtAyL4ZQZMcdQImxiST
         pXrNVHk4pgjWW42zCtaeHcSTMt4alQtIJk4cCawjcbs/pXZm/lrpJ70VcnbW5afP/rKd
         a3wBaJsciow5qzIOr2sarG8Fq/qIeQPdW09G9/THoCQjEYEIN9gZvPF1HolXGLPDoynH
         jnQGkkcIJ2yXtNStvrxZRUMp5XefQYRAJP+S088tO4QakBt1LYI1FL2gf50HcrvzV1xM
         z5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777519304; x=1778124104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UL3C3PYs7qb8LJc+zdz+SzMOIXkiCyeUwN4vYWoaCaE=;
        b=fO4rNcZlhh+h5aT2y+w7lxq4YB+WGTnWI/GToxVz6vvAW1xq/+QuuAVDEepZqxNDx7
         qoNc47//ZY+ibVQnuLvphzn31zJWa4mJUJEgMGQqjXiRHGvDmCAROqDN+xVSA1XZBGq1
         9gAGt5Ck4r46nmrl8YVgSe5Ya7id8zJoiLzUN+lyaMUTKrUn0gqXbQG8A5alHFFa8bNx
         nK/wvUC1l+3lLrC5gifeartUHavLXxc1VTsVaOwOfdgHWXtD5VWdYHxM/8C2LVWsS/wG
         cc4+hm+kEQkCqqMMoW3fDaz/0LI5yTdkT+r9f7tG9LnSgWPtqNpQ9Cz2goGb2KYLX4Yl
         4WAA==
X-Forwarded-Encrypted: i=1; AFNElJ8UP7Haq7HNh6e4u6gpo0ehsJa2ehNBQqH66orlyis1eXWh1Qy7b9p/wYqkiQS/Ie+Le8qONG1cK1U7BWU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhMZ/GtScj1Qf+bTDBDAWsh9MBnbpbUkyBNHpW9b4cJkGuk/Qk
	6iJ7ZAqi8TIhtJLYAeyPE0xup6L+J2nSiTRFQXgGTXQZGwIshBUkwHnJu4rWika6eyxkOL2zSyb
	wRti4r2tNFlPsgBhkPgFpRn4aQsV76mjD+w2nNIzGgM0r2nCytGiu4pYGv+ADoxKvkH4=
X-Gm-Gg: AeBDieshSC94SeheXpCLMvP6KizbH6i48HFonmmWCe6NX8h5IvzlxM3hvg1aa25IKgE
	empR3DoEAsNinP0M1CWMca8Vbt81gSK5D2dkTTWLQCCad6iyJ1swyuKjvH3Sb3hCy4Ec1QGCclt
	q1uF5kYiTtYwdG5bCGSqOV7NCaPZdangfkvm6etc/MulHemSBNiHU4G00aF4QOrmpAIyYgwkFcW
	PMRKjiw0cUQwbw/7aq/52a2UpNAb2AtfU69LLfiNVDPmA3YBGUvj8mUXnxb4+5wAMreHlDhzVJk
	Q0NmqqjvbXEdccjhoUe9A0zLyv+JIZxtpDrcCWSdsdZkeQJ0Uq4GWSIV54/gDLw3bw/jpT/QtPO
	KZUxcKPNKDkTLQ/lk76HSGmwowl4/F3pQV2fohoeBSFIxX23/dQlWl+zM0/xHz30vOFHRlxEjkq
	W4Rayfpl5cUwHeoDA=
X-Received: by 2002:a05:701b:290e:b0:12d:ed19:e6cb with SMTP id a92af1059eb24-12ded19e73emr172639c88.29.1777519304281;
        Wed, 29 Apr 2026 20:21:44 -0700 (PDT)
X-Received: by 2002:a05:701b:290e:b0:12d:ed19:e6cb with SMTP id a92af1059eb24-12ded19e73emr172633c88.29.1777519303738;
        Wed, 29 Apr 2026 20:21:43 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de321df36sm7572644c88.7.2026.04.29.20.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 20:21:43 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiggers@google.com
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        deepti.jaggi@oss.qualcomm.com, bjorn.andersson@oss.qualcomm.com,
        quic_shazhuss@quicinc.com, trilok.soni@oss.qualcomm.com,
        konrad.dybcio@oss.qualcomm.com, Deepti Jaggi <quic_djaggi@quicinc.com>
Subject: [PATCH v6 3/3] soc: qcom: ice: Add SCMI support for sa8255p based targets
Date: Wed, 29 Apr 2026 20:21:35 -0700
Message-Id: <20260430032136.3058773-4-linlin.zhang@oss.qualcomm.com>
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
X-Proofpoint-GUID: aQ5KfH09cjLTX7oHK7FDl3wvferOMr30
X-Authority-Analysis: v=2.4 cv=KcHidwYD c=1 sm=1 tr=0 ts=69f2cac9 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=COk6AnOGAAAA:8 a=SaV-z_UyVCyeOftNReQA:9 a=vBUdepa8ALXHeOFLBtFW:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: aQ5KfH09cjLTX7oHK7FDl3wvferOMr30
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDAzMSBTYWx0ZWRfX6Yb4bG0jrDYN
 hxOrd9EI5vDYPxqX3e68wvSpt0qCJLmNYD4jowlGQOpik/QRLvxja5ij7U2MtpRlN7WQ+dUeEvk
 FbqK1yVW2at8r0GT8aKsLsHEIp0e+uq7VpQAd8ijyGJt5fwhc5jRmDtypuiWXTH4hdr2GjAUTDy
 EA/BOaigMNJi1c2g+Chq6Cq35VKB60/D87mNtEdn3egOsw8ZlKN/x1QI0uyHQcpnWYXuDxssZw4
 8bdhF/SP6v6MqeWdzm1T+k3X03UZ8bAlDtvno6OsijUVDEWeYAflvf+xpWPDTbIAf0tJkCzbu07
 NMZEaRNyDmant1KfQ3VhDWw0TVbSSgQLKyyjNhuPXLktCdaDsaYygJOyayKt65p8hM1o0TgmNv+
 kRVMdvxTU9Yw7l0+hf3TeI7yFlhipzxzuyIkCaZukMpXb/Ag97vMmpviIBovEAmvqNsyF5eCeBK
 0AfgE8O3r+tOFamACIA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_01,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604300031

The Qualcomm automotive SA8255p SoC relies on firmware to configure
platform resources, including clocks, interconnects and TLMM.
The driver requests resources operations over SCMI using power
and performance protocols.

The SCMI power protocol enables or disables resources like clocks,
interconnect paths, and TLMM (GPIOs) using runtime PM framework APIs,
such as resume/suspend, to control power states(on/off).

The SCMI performance protocol manages ICE clock, with a power domain
set for ICE clock. The driver uses runtime PM framework APIs to
request power on/off status of the clock.

Reviewed-by: Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Reviewed-by: Deepti Jaggi <quic_djaggi@quicinc.com>
Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 64 ++++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 6f9d679b530c..cf185a6e1973 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -68,6 +68,10 @@ union crypto_cfg {
 	};
 };
 
+struct engine_desc {
+	bool fw_managed;
+};
+
 /* QCOM ICE HWKM (Hardware Key Manager) registers */
 
 #define HWKM_OFFSET				0x8000
@@ -554,6 +558,7 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
 	struct qcom_ice *engine;
+	const struct engine_desc *engine_cfg = NULL;
 
 	if (!qcom_scm_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
@@ -570,20 +575,23 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	engine->dev = dev;
 	engine->base = base;
 
-	/*
-	 * Legacy DT binding uses different clk names for each consumer,
-	 * so lets try those first. If none of those are a match, it means
-	 * the we only have one clock and it is part of the dedicated DT node.
-	 * Also, enable the clock before we check what HW version the driver
-	 * supports.
-	 */
-	engine->core_clk = devm_clk_get_optional_enabled(dev, "ice_core_clk");
-	if (!engine->core_clk)
-		engine->core_clk = devm_clk_get_optional_enabled(dev, "ice");
-	if (!engine->core_clk)
-		engine->core_clk = devm_clk_get_enabled(dev, NULL);
-	if (IS_ERR(engine->core_clk))
-		return ERR_CAST(engine->core_clk);
+	engine_cfg = device_get_match_data(dev);
+	if (!engine_cfg || !engine_cfg->fw_managed) {
+		/*
+		 * Legacy DT binding uses different clk names for each consumer,
+		 * so lets try those first. If none of those are a match, it means
+		 * the we only have one clock and it is part of the dedicated DT node.
+		 * Also, enable the clock before we check what HW version the driver
+		 * supports.
+		 */
+		engine->core_clk = devm_clk_get_optional_enabled(dev, "ice_core_clk");
+		if (!engine->core_clk)
+			engine->core_clk = devm_clk_get_optional_enabled(dev, "ice");
+		if (!engine->core_clk)
+			engine->core_clk = devm_clk_get_enabled(dev, NULL);
+		if (IS_ERR(engine->core_clk))
+			return ERR_CAST(engine->core_clk);
+	}
 
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
@@ -756,13 +764,17 @@ static void qcom_ice_remove(struct platform_device *pdev)
 
 static int ice_runtime_resume(struct device *dev)
 {
-	struct qcom_ice *ice = dev_get_drvdata(dev);
+	struct engine_desc *engine_cfg = device_get_match_data(dev);
 	int err = 0;
 
-	err = clk_prepare_enable(ice->core_clk);
-	if (err) {
-		dev_err(dev, "failed to enable core clock (%d)\n",
-			err);
+	if (!engine_cfg || !engine_cfg->fw_managed) {
+		struct qcom_ice *ice = dev_get_drvdata(dev);
+
+		err = clk_prepare_enable(ice->core_clk);
+		if (err) {
+			dev_err(dev, "failed to enable core clock (%d)\n",
+				err);
+		}
 	}
 
 	return err;
@@ -770,9 +782,14 @@ static int ice_runtime_resume(struct device *dev)
 
 static int ice_runtime_suspend(struct device *dev)
 {
-	struct qcom_ice *ice = dev_get_drvdata(dev);
+	const struct engine_desc *engine_cfg = device_get_match_data(dev);
+
+	if (!engine_cfg || !engine_cfg->fw_managed) {
+		struct qcom_ice *ice = dev_get_drvdata(dev);
+
+		clk_disable_unprepare(ice->core_clk);
+	}
 
-	clk_disable_unprepare(ice->core_clk);
 	return 0;
 }
 
@@ -780,8 +797,13 @@ static const struct dev_pm_ops ice_pm_ops = {
 	SET_RUNTIME_PM_OPS(ice_runtime_suspend, ice_runtime_resume, NULL)
 };
 
+static const struct engine_desc cfg_fw_managed = {
+	.fw_managed = true,
+};
+
 static const struct of_device_id qcom_ice_of_match_table[] = {
 	{ .compatible = "qcom,inline-crypto-engine" },
+	{ .compatible = "qcom,sa8255p-inline-crypto-engine", .data = &cfg_fw_managed },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, qcom_ice_of_match_table);
-- 
2.34.1

