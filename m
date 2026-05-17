Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AA13C465
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779015175; cv=none; b=t5LDnd06NbzWA/MHPOKv5cywYwHs9FF3HyW3FIhR7fg88b21DDIOnXk+2hVyHriLaigbZkqsNQERjhfzJFDoGwCQ/krDj8x+CKOhurc8L4pC61qInDQAADcZgkT0j30E50u16mPBctHB8UUUMnVnCvl7a+o52GMHoDhZ8BzbBIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779015175; c=relaxed/simple;
	bh=bofMkKfwN9ctze6xbOqcsYnI0AaUdoGqwrGoKBuSq/g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q3G/LbgOazOdlg83IwfSC+wHaY+nNHxakBt5ny2/MK7Xq+61nDei+BAl99CfwfHgx9rfXNddIz7Qc5kSnox1FWAqrKbVmHzU7GMV5S4AvKJSMJ8Mj0WrWxVJfLi5rr5teQExvB+3QpdYN4nIfkZfs9D+3iEHAG4XRchxaxZ3ScM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wa3RZAoK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ewkaeFkd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wa3RZAoK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ewkaeFkd"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64GN6HXF2219041
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 10:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=tiQ4yxGc+whFXtBAFCGDzzpYFaMe+Q6vzwS
	7kB/GqaU=; b=Wa3RZAoKljYyUdzrRjTOtNfE0793v5AUsXZ1RdaJuq/t2ew6vbo
	A+dtgLXy305l8Yg9IxGbqBZWOGW45Jzd3Gcu1vF6bwwqXPWUYflcijncCLMW5amv
	Qzj9WEHTshcPHUoKtzVdwJHKnFlgWd+LqMGYkRP5dfyl7GrBEnmBffuR65+cZcMI
	LACEdou/NQWSnlMBGo/VT0dSgVevF7ZxkLJWst7hRPWQkLacETLrYlkaBzBUwINv
	bRABvS01PyOL0ChZ4o/02jrJSClplEA0J1uAMuLBM5tvmG4gzkCvIyvVC2WDPV1r
	wOnf72zBC2Nb5JugdbmXl9C3xIXylqntRUg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e6tvchj7g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 10:52:52 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-365e70c39d0so1218771a91.0
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 03:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779015172; x=1779619972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tiQ4yxGc+whFXtBAFCGDzzpYFaMe+Q6vzwS7kB/GqaU=;
        b=ewkaeFkdLjdChzZFb6jZjxM8ZEaaHfW5HTKKYY9JYv6irxYo67WBX1FiiPg/Z/PWxZ
         HusTvUbHtuEUASEz402xmJ5njz0mnWkvlnYRiBwlYgSSf6UDCETm3s1qX/WfFGZbb8b3
         FxwwVQvDhDe+37xkSq5tqDogSEFh4LqsTRXMHbq2jNqEZciHVFa7AMLnrKlAtf3x5iJf
         z1H+fr2fyy3VaRPzrER99jeYJ4qqKQXZK3AORjhT/HU6AJBxuy7SKZYht2Fo0ZdhBE7A
         JtMSMGziARaAdeaTsvDtK53fw2kt6glbBl1DUL4KiI35GEEjQS6rPKHsgELfAJ2cMGlT
         VT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779015172; x=1779619972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiQ4yxGc+whFXtBAFCGDzzpYFaMe+Q6vzwS7kB/GqaU=;
        b=B62y4pUFEIdXF1CJ55VQi2UM0aNiU+8pi60/gGch66RyIO3szN34G4iKiV9vt1Ke6n
         7YSgi4uyWJCgD+a5GlYd20yEBt9yJ+feOA4tF55oO9U1eVoRruXkmNuyLfYrbV0wFKE2
         dP3dFBrifSJiKSe08pILitCwTIQSJ7wXNc+og8Su3F7Wi3OtraIy8sJfJ3sULpAHbCxa
         yl1KnBm/4eKj8VKDR9nMiRztEK/GyGco2tUctR0lxzFlXM0avkLCPKWwpgxBOJJOcVHH
         NThitH7VZOCRy347IFikMsyIn8ext8LBe/WZXSTN1d1T7ql0Nq7hX3hLM2GK3s+EGAi2
         7SsQ==
X-Gm-Message-State: AOJu0Yy84MuLRVgA7hQ2sMe24Of0GVDYPbwm3lH11YdxBBCElDQ/0pvf
	F+AZcc5Kn3M0/GtKFfmssHnCYuEWDoA2SeUvZRJon5r6LfUDy9QurtrTYSKF9jBJryxxad05Rui
	S4DG9GlGleSNomIwxTfQ3aAoOPdUeP3zGV06YnqY3dPLKOG++c8ibiIjW3bUzbjurp9o=
X-Gm-Gg: Acq92OF+xzlTM8nOxg66UNV5cCCEw8Gc6TgG2O03o+8ICuVzE6cut4XbPJ9+FDGhG8I
	wH0b/aEj5e5B0TPTxJSXGA7V/4Luxy78/0lll0ik1eOEUgVZzy+sm8YeVSofgseHcKaI+/lVgfY
	Wi8kA7AG+Wgy4Fx6hf0gs73Z+X4NQW34CjbVf9lKuwqvBfB5IersSDciZltN8uW3znD+5Yirrz7
	H5SSn5LbPS2XdMvQKT2nZ1L6mhFrwndzbNuEXoBYkCq7z2yIxtS8kjjSrec6yOM1ny6JO8JTUpq
	+lOCDrewGaqGO0nB03sVgeJBd+wN7G+2Q2uEjcqXYPtd4BfXDYOJShH6pRfb/CeZItmY+QbtGgF
	0IUi4gNpaXXpH6PErYaUhFS67m9ET1nz347ft8+uvralOmTWA36GCarVt+d05Vw==
X-Received: by 2002:a17:90b:35c8:b0:356:22ef:57ba with SMTP id 98e67ed59e1d1-369518b669amr11146037a91.7.1779015171572;
        Sun, 17 May 2026 03:52:51 -0700 (PDT)
X-Received: by 2002:a17:90b:35c8:b0:356:22ef:57ba with SMTP id 98e67ed59e1d1-369518b669amr11146021a91.7.1779015170989;
        Sun, 17 May 2026 03:52:50 -0700 (PDT)
Received: from hu-utiwari-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-369512424a6sm10132405a91.1.2026.05.17.03.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 03:52:50 -0700 (PDT)
From: Udit Tiwari <udit.tiwari@oss.qualcomm.com>
To: konrad.dybcio@oss.qualcomm.com, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com,
        udit.tiwari@oss.qualcomm.com
Subject: [PATCH v8] crypto: qce - Add runtime PM and interconnect bandwidth scaling support
Date: Sun, 17 May 2026 16:22:33 +0530
Message-Id: <20260517105233.807935-1-udit.tiwari@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: BFPfekZ5a_Q1I8QeTlF7CzJLPExJs12O
X-Authority-Analysis: v=2.4 cv=UIDt2ify c=1 sm=1 tr=0 ts=6a099e04 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=OR-uRB0iQuogYzU8RssA:9
 a=mQ_c8vxmzFEMiUWkPHU9:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: BFPfekZ5a_Q1I8QeTlF7CzJLPExJs12O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE3MDExNiBTYWx0ZWRfXzhcQx/XXUcJ7
 yjcLLEmXMg5nR+MszKu8PHBuPRJEsX0Qm7xnyaaS0G001rzWmBPcMxWCMnqWTIPecx11SEh3NFf
 UEdTnJUZvuSAphNsJIx1XKGI+GMTsjYmYOLJrcczisZrXY0GBaVXp8LFxeJ7GiXONERUBmSdunX
 rUTBHkTYTeqNw23+vQHirrmwErI1JeFwzJZO1maTc8D6KT3/xbTyY5CAVsy4MPzfkcDKrwju+p2
 SBTLBycuuFwTf03rZw41dXSks+N4GC6+vyl40Cfy408TQJiPE6pj/h1gGBRlCgZLdOxOWu3/RPo
 z+tkoN9YTHru8dnk1Duj68Z/MFMzFEIDJtRhmM0uWfaQlNon4TENvdLv8UiRFxKddkJPr8T7dKk
 wVOhBCHfRQyMuhqWvHkbBmo6xmDWTTcGI+7al0MJdcumeKVWgCbFt2FMtpDKF9cp77v9dej5WQG
 6EUfJ+vU5R7pSutRi+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-17_02,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1011
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605170116

The Qualcomm Crypto Engine (QCE) driver currently lacks support for
runtime power management (PM) and interconnect bandwidth control.
As a result, the hardware remains fully powered and clocks stay
enabled even when the device is idle. Additionally, static
interconnect bandwidth votes are held indefinitely, preventing the
system from reclaiming unused bandwidth.

Address this by enabling runtime PM and dynamic interconnect
bandwidth scaling to allow the system to suspend the device when idle
and scale interconnect usage based on actual demand. Improve overall
system efficiency by reducing power usage and optimizing interconnect
resource allocation.

Signed-off-by: Udit Tiwari <udit.tiwari@oss.qualcomm.com>
---
Tested:

- Verify that ICC votes drop to zero after probe and upon request
  completion.
- Confirm that runtime PM usage count increments during active
  requests and decrements afterward.
- Observe that the device correctly enters the suspended state when
  idle.

Changes in v8:
- Drop pm_clk framework (devm_pm_clk_create/pm_clk_add/pm_clk_suspend/
  pm_clk_resume); use devm_clk_get_optional() and direct
  clk_prepare_enable()/clk_disable_unprepare() in runtime PM callbacks.
  This removes the CONFIG_PM_CLK dependency and the build error reported
  by the kernel test robot.
- Replace icc_disable() with icc_set_bw(path, 0, 0) in runtime suspend
  to avoid corrupting the internal 'enabled' flag, which would cause
  subsequent icc_set_bw() calls in resume to be silently skipped during
  aggregation.
- Fix ICC vote ordering: cast bandwidth vote before enabling clocks in
  resume; disable clocks before dropping ICC vote in suspend.
- Use PM_RUNTIME_ACQUIRE_AUTOSUSPEND()/PM_RUNTIME_ACQUIRE_ERR() wrapper
  macros instead of raw ACQUIRE() in both qce_handle_queue() and probe.
- Drop __maybe_unused from runtime PM callbacks; use RUNTIME_PM_OPS /
  SYSTEM_SLEEP_PM_OPS (non-SET_ prefix) and pm_ptr(&qce_crypto_pm_ops).
- Drop unnecessary ret = 0 initializations in qce_handle_queue() and
  qce_runtime_resume().
- Extend probe comment to explain ICC + clock ordering rationale.
- Link to v7:
  https://lore.kernel.org/lkml/20260220072818.2921517-1-quic_utiwari@quicinc.com/

Changes in v7:
- Use ACQUIRE guard in probe to simplify runtime PM management and error
  paths.
- Drop redundant icc_enable() call in runtime resume path.
- Explicitly call pm_clk_suspend(dev) and pm_clk_resume(dev) within the
  custom runtime PM callbacks. Since custom callbacks are provided to
  handle interconnect scaling, the standard PM clock helpers must be
  invoked manually to ensure clocks are gated/ungated.
- Link to v6:
 https://lore.kernel.org/lkml/20260210061437.2293654-1-quic_utiwari@quicinc.com/

Changes in v6:
- Adopt ACQUIRE(pm_runtime_active_try, ...) for scoped runtime PM
  management in qce_handle_queue(). This removes the need for manual
  put calls and goto labels in the error paths, as suggested by Konrad.
- Link to v5:
  https://lore.kernel.org/lkml/20251120062443.2016084-1-quic_utiwari@quicinc.com/

Changes in v5:
- Drop Reported-by and Closes tags for kernel test robot W=1 warnings,
  as the issue was fixed within the same patch series.
- Fix a minor comment indentation/style issue.
- Link to v4:
  https://lore.kernel.org/lkml/20251117062737.3946074-1-quic_utiwari@quicinc.com/

Changes in v4:
- Annotate runtime PM callbacks with __maybe_unused to silence W=1
  warnings.
- Add Reported-by and Closes tags for kernel test robot warning.
- Link to v3:
  https://lore.kernel.org/lkml/20251115084851.2750446-1-quic_utiwari@quicinc.com/

Changes in v3:
- Switch from manual clock management to PM clock helpers
  (devm_pm_clk_create() + pm_clk_add()); no direct clk_* enable/disable
  in runtime callbacks.
- Replace pm_runtime_get_sync() with pm_runtime_resume_and_get(); remove
  pm_runtime_put_noidle() on error.
- Define PM ops using helper macros and reuse runtime callbacks for
  system sleep via pm_runtime_force_suspend()/pm_runtime_force_resume().
- Link to v2:
  https://lore.kernel.org/lkml/20250826110917.3383061-1-quic_utiwari@quicinc.com/

Changes in v2:
- Extend suspend/resume support to include runtime PM and ICC scaling.
- Register dev_pm_ops and implement runtime_suspend/resume callbacks.
- Link to v1:
  https://lore.kernel.org/lkml/20250606105808.2119280-1-quic_utiwari@quicinc.com/
---
 drivers/crypto/qce/core.c | 99 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 92 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index b966f3365b7d..c43a0e5f56f5 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -12,6 +12,8 @@
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
@@ -88,7 +90,12 @@ static int qce_handle_queue(struct qce_device *qce,
 			    struct crypto_async_request *req)
 {
 	struct crypto_async_request *async_req, *backlog;
-	int ret = 0, err;
+	int ret, err;
+
+	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(qce->dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
+	if (ret)
+		return ret;
 
 	scoped_guard(mutex, &qce->lock) {
 		if (req)
@@ -207,23 +214,33 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	qce->core = devm_clk_get_optional_enabled(qce->dev, "core");
+	qce->core = devm_clk_get_optional(qce->dev, "core");
 	if (IS_ERR(qce->core))
 		return PTR_ERR(qce->core);
 
-	qce->iface = devm_clk_get_optional_enabled(qce->dev, "iface");
+	qce->iface = devm_clk_get_optional(qce->dev, "iface");
 	if (IS_ERR(qce->iface))
 		return PTR_ERR(qce->iface);
 
-	qce->bus = devm_clk_get_optional_enabled(qce->dev, "bus");
+	qce->bus = devm_clk_get_optional(qce->dev, "bus");
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-	qce->mem_path = devm_of_icc_get(qce->dev, "memory");
+	qce->mem_path = devm_of_icc_get(dev, "memory");
 	if (IS_ERR(qce->mem_path))
 		return PTR_ERR(qce->mem_path);
 
-	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH, QCE_DEFAULT_MEM_BANDWIDTH);
+	/*
+	 * Enable runtime PM after clocks and ICC path are acquired so that
+	 * the resume callback can enable clocks and apply the ICC bandwidth
+	 * vote before any hardware access takes place.
+	 */
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
+
+	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
 	if (ret)
 		return ret;
 
@@ -245,9 +262,76 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
-	return devm_qce_register_algs(qce);
+	ret = devm_qce_register_algs(qce);
+	if (ret)
+		return ret;
+
+	/* Configure autosuspend after successful init */
+	pm_runtime_set_autosuspend_delay(dev, 100);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_mark_last_busy(dev);
+
+	return 0;
+}
+
+static int qce_runtime_suspend(struct device *dev)
+{
+	struct qce_device *qce = dev_get_drvdata(dev);
+	int ret;
+
+	clk_disable_unprepare(qce->core);
+	clk_disable_unprepare(qce->iface);
+	clk_disable_unprepare(qce->bus);
+
+	ret = icc_set_bw(qce->mem_path, 0, 0);
+	if (ret) {
+		clk_prepare_enable(qce->bus);
+		clk_prepare_enable(qce->iface);
+		clk_prepare_enable(qce->core);
+		return ret;
+	}
+
+	return 0;
 }
 
+static int qce_runtime_resume(struct device *dev)
+{
+	struct qce_device *qce = dev_get_drvdata(dev);
+	int ret;
+
+	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH,
+			 QCE_DEFAULT_MEM_BANDWIDTH);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(qce->core);
+	if (ret)
+		goto err_core;
+
+	ret = clk_prepare_enable(qce->iface);
+	if (ret)
+		goto err_iface;
+
+	ret = clk_prepare_enable(qce->bus);
+	if (ret)
+		goto err_bus;
+
+	return 0;
+
+err_bus:
+	clk_disable_unprepare(qce->iface);
+err_iface:
+	clk_disable_unprepare(qce->core);
+err_core:
+	icc_set_bw(qce->mem_path, 0, 0);
+	return ret;
+}
+
+static const struct dev_pm_ops qce_crypto_pm_ops = {
+	RUNTIME_PM_OPS(qce_runtime_suspend, qce_runtime_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
+};
+
 static const struct of_device_id qce_crypto_of_match[] = {
 	{ .compatible = "qcom,crypto-v5.1", },
 	{ .compatible = "qcom,crypto-v5.4", },
@@ -261,6 +345,7 @@ static struct platform_driver qce_crypto_driver = {
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.of_match_table = qce_crypto_of_match,
+		.pm = pm_ptr(&qce_crypto_pm_ops),
 	},
 };
 module_platform_driver(qce_crypto_driver);
-- 
2.34.1
