Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB153290D2
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323114; cv=none; b=XdhbbS7JqqcYGDv/oWsnPuiIGAnBEtmfDdrmkTyS2BG7BwBQZTxvEFm01K/yEr9/JwkliYJGZwsh6tsQ5K4wHmp6di9Nejzh72BWi6MMkQp9LKSWEYoOPdnWtS1FVv4m7qh7xLW+ahyi/VO95Tv8QHrZzm+2zkj9mL0pbpPZyzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323114; c=relaxed/simple;
	bh=DCYAuRCp7+nFFvsRBZG572UOAg8pxukDJF9q5ZWLlG4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hkSDjWK3fP2bW+2RdzfVrfWgG7zs+QejqqL54S/BVVWW1iMqvCrG/bVNsmrD+JqGmRrcCwg5Pz8M0n9ooy+/otRaBQ2FkcSB+J8VF30wWMdpvYSMSy8ls9k6sZv4u//tkCiFlOz7EqoY/isIL9LaxehZpF5ZS7KBbW2amyd+mwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZHCufFi1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VOZUmvWP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZHCufFi1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VOZUmvWP"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T8htjl1484320
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 11:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=NmgLYHzD9b2zNdVwSu933xgMmRm2WlC125I
	YHk8Hzy8=; b=ZHCufFi1BDre8ucimgwUnPhiJMW2FebPiasIpBWwHrgJqgnanc8
	y0xc5FNlkSId3Kb3EUD+EvtwdmENimSV7QbSnhjvVP8nJ1dz0KFxDrPTibjoDGLM
	bQfefK+cikMwD2jHhelle2h7cuIy9HJuWXs5TRPLKM5UWjwch4fd/opTjkBLKv2n
	KWy4GbjWDVL5u61XasLspyShM9OGZjMhIqpO9X2cDPxloQgzkSu98UeJCMqbqqmL
	aQIu4Dt4GCAIRq0t+PGA0Z5ZZhxx5u82GpuSfNc+G7Pk5QSLwF0jF3nJHaQkccVu
	vmPo5hoqJgb6e7xhw7Jk6TWpeAXRCFjZcHg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqe920md4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 11:05:11 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso1480521a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 04:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785323111; x=1785927911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NmgLYHzD9b2zNdVwSu933xgMmRm2WlC125IYHk8Hzy8=;
        b=VOZUmvWPiv4fPu3oAIO02e6n+BpzUg7E32Lbk/SKCygVA8bbwlYD1y3e2jogy6f4II
         l1EvGoA9Uc/WXViWOhki4/+CGFo9dd9INOjdshkAk3GiMh7PXUu8HYxeVOh4efifTecY
         6N6DmMrctygv/SCQ630PMiM/xE+5d2zaRUjv+1f66408Q1Bj4JyVtF3KkF0s/dP9lQUf
         /vGHPqM68DR3Gh4qqRgbMel799E7ufl1z7fwxuqk4iJrJb1UOBD2l8t2gWIyIfXKSsOU
         bLZ9x2vb19Y3VAvglkkJaeUSB6QNHl9qgAXuU3+89+AMik9KLPS8IGFOwrY+ir7JfCOa
         dxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785323111; x=1785927911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NmgLYHzD9b2zNdVwSu933xgMmRm2WlC125IYHk8Hzy8=;
        b=eiShigbA+6r+I23Sxkl0jqCdi7Gkn4z1hnxQRMOgjitZWwRkCETxIt5SBuVd+bGKH1
         pOCCUndCbR/1CTYhEhbpEgCc8ElfsCEEPuD0eXa9rZStWVYf6IhJMQCG4XV8AGkeNsug
         q1xGWWY4wz1eWOa2MHDQ0c3dAIMYyxPn5PEKD/zRqhMhRQ9bdtc5Jjtm/mrY+4zXK7A8
         wHD2+vqa5vUasoYFeZkCdH69H+nei1jzxl5b18xsvFyqmv2NcldFbSs5gdNS+c4SRzjv
         LgFglbOnILaPjpQJ2+fSDDOmXefc5c06F9/D8Mol0N//Bn6lqL+SLDHjTLm4zT97CxYD
         5bhQ==
X-Gm-Message-State: AOJu0YwvKjECrkN1e+SZ0nKqKP7lI7CKDOJGk3eXL8x5ujI8B7Oq7Ki1
	F8nx1UoztFHggKvFj7EjUxOegVxzZGo+2hBuItI8NrbqnaLlzttMc//kkqxuIu6hBgyAay5qX2X
	XdYWh+g52x9TZ45zER+O9Yk3zLKE3z+4i2QMNeAX2iO6WEqfSQBrofxn4zDGAdVzQ+Mc=
X-Gm-Gg: AR+sD12lfpVINqdZAiN8I3qPed8j8YwD5HaKdlzIYCB4z3kBxTQQRI5FS5b1oQragGq
	c0+BIQMfOhFDH6H74KOTh1LQmiEqYdDeJ+X/QeukZJxCt6iTqII8c47HnysVFEGkY1FGSoMuepX
	MVMzXH+AtrzIu/hJwtdZkos6jbonhU+QkgcCkXs2uieXGUVgbkFk+TLp7XYkozbzQ0GDFLTuWaH
	1d9FnYEN37joQi1GY8Pc9DD+Br7f25OaA2LfRloZDUU7DAmYC/friQ590QMoOTZe/mq8oRAi+7i
	kX3ej4LFIlaVznIjtawB4eP1ewJ1f/mEHsi1dQl+CBAe0G97LD8X5vPXg2N6gGvDT37m4ARJ+Lz
	FvSwP64gf0iAOiLKqrV964LDRjeyciqIJeQ==
X-Received: by 2002:a17:90b:3e4b:b0:38f:1dc:672f with SMTP id 98e67ed59e1d1-38f6a4597bamr5832824a91.18.1785323110849;
        Wed, 29 Jul 2026 04:05:10 -0700 (PDT)
X-Received: by 2002:a17:90b:3e4b:b0:38f:1dc:672f with SMTP id 98e67ed59e1d1-38f6a4597bamr5832792a91.18.1785323110332;
        Wed, 29 Jul 2026 04:05:10 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6412a92bsm2660968a91.5.2026.07.29.04.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 04:05:09 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Udit Tiwari <udit.tiwari@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [Patch v9] crypto: qce - Add runtime PM and interconnect bandwidth scaling support
Date: Wed, 29 Jul 2026 16:34:55 +0530
Message-Id: <20260729110455.641256-1-kuldeep.singh@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA5MSBTYWx0ZWRfX4N0g1S3djjZU
 iXP9AwazIniwhnpUT2I0mPXz55LI9s5Ihc2GiDmSCjW9rCZKiGirTX8yRl0N7e2/cPdtDjORU2S
 oxMKlsCsG0a+3O6vM8v7RYcj1tAmS0U=
X-Proofpoint-GUID: E9Dpqjbo_5iKCQnBC1yKfM83lvELXRMH
X-Proofpoint-ORIG-GUID: E9Dpqjbo_5iKCQnBC1yKfM83lvELXRMH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA5MSBTYWx0ZWRfX5Q40joAXziWM
 iFvQCG+Sa7mGaqLUvgjPzV5yXgP2eSpvlwPFQn71XV7cRqwyIoIvGxyFFounYimpU0hus4BR1DE
 5pLCBHzS3Aubw/S2EMaZlF6Rcbsg2Xl12uKlkDY0R41EgZT9yqD+PsLIzT6N1w4Gy26JeL9XC5j
 GFO/utrOBlikcJZm5x0s2tVy1+H+NNI+HeLjN/lSA+BRG/Szb1mp5mvz2SOc7/y3lofaERQVcZY
 dTyTvdMl+thJWFXtP7KvxIf9hNxVRgT5qSePO7YgUpwODZ5hfS6qJpOTSy4iyy4J6/ZeCFpIkFq
 IbsiMaiA4983j8o9YDeQsW314d5a+wh0KoVBJKaElLBO6bsbe/E5Y74nGhIuYPMFZ5zWdVMLdpZ
 kr4CYMdtngdqrorIETdzQsqDB2dFYrOfGLIZTvbyvMNFZPFtTFFjq4ZAca0lO+Lgj7aTpAE3WB4
 vquPcjg9vqvyu/srDdA==
X-Authority-Analysis: v=2.4 cv=JeiMa0KV c=1 sm=1 tr=0 ts=6a69de67 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=COk6AnOGAAAA:8 a=OR-uRB0iQuogYzU8RssA:9
 a=mQ_c8vxmzFEMiUWkPHU9:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290091

From: Udit Tiwari <udit.tiwari@oss.qualcomm.com>

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
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
I am taking care of follow-up of this patch from the original author,
with their consent, while preserving the original authorship.

Changes in v9:
- Rebase to latest linux-next/master(tag: next-20260728).
- Link to v8:
  https://lore.kernel.org/linux-arm-msm/20260517105233.807935-1-udit.tiwari@oss.qualcomm.com/

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
index ac74f69914d6..b6edca5f1663 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -11,6 +11,8 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
@@ -87,7 +89,12 @@ static int qce_handle_queue(struct qce_device *qce,
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
@@ -206,23 +213,33 @@ static int qce_crypto_probe(struct platform_device *pdev)
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
 
@@ -244,9 +261,76 @@ static int qce_crypto_probe(struct platform_device *pdev)
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
@@ -260,6 +344,7 @@ static struct platform_driver qce_crypto_driver = {
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.of_match_table = qce_crypto_of_match,
+		.pm = pm_ptr(&qce_crypto_pm_ops),
 	},
 };
 module_platform_driver(qce_crypto_driver);
-- 
2.34.1

