Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88F3FC5DB
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801097; cv=none; b=OKYxo0XmebbUnKluvSp4tDP85kGLPRKhYXEQwa/+3HFolpG+IMxhfp9DW2ngaxRCtCgndcuM5wdFISBrE+X9Tukq/wWBC0umpPUQsm1pcxGy4JmsB9gmv+nwZVLwoRiLlVNHeCZ7NKRMt7OLiDl8MiALJphoiu7BPBC6yXmEerA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801097; c=relaxed/simple;
	bh=atD/C70BmAbtLpgtk/gvN3TNLFsQT9cfTHvoiJm5/zo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IyZN8C6R+2U2U2KBdWoMKU5iR7JgKMHkSEGxJA2ZO4X80Xz87qnRpHrqz/xp9BuzwaQyduH4qMjmChy1bcbDQ++zGdFrXbPNbLlPCmEHegaMyuVsA6XRrkC1hIBZ0Z2/8nV59taOP343Srsa2+IWuDEQHtrvfHieUghnrl+aTDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GimBwBjM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BPZlrBbA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GimBwBjM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BPZlrBbA"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsV4C2385467
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t1nmBooCYIL6gijj0RhLOpiyGlP850IpBxaJF2Uaxp4=; b=GimBwBjMGP2fclBL
	AKTWRMQn0pV40D2BED3S/IHANk4+2s3Hqm3BEfrhTZjsUVYVZEm3wQKL6zL/uCYa
	XsqNhUBT1IIhmJ9SD8zypKE50zX/Or6/rzM73vlVdIgZAUJzhIogcQ65ZIbUe+TZ
	bTG4SiNE8gZ07p4SYA7B2KP897aZiCwsMIhUiKQ0yXbM6hP/fT+CLvB+yJIOFjFr
	qnoB5Rtl+OFXdvpN9yM9Ji7/rmuXK+oJE+qDcDCNvh8eBLDeFbZHHT/gGald/1JD
	YuI5Al59xQFokwRrfbwZO+9D7XPwJvcz/USZlbRWIXyOii7UZCoC3QGnvQG4Xj7D
	QkJc+w==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecnhs4t5t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:33 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-95cc77982c5so12284142241.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801093; x=1780405893; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t1nmBooCYIL6gijj0RhLOpiyGlP850IpBxaJF2Uaxp4=;
        b=BPZlrBbAwj1O4QcFHZe1sGli54zbfAKoo9mbu3TMxcKs7oDlmLBuPW8wBhYgQIcDVA
         AuR7VmrjOnN5KEMss/5bmgU5oGFA3Kx4ai5TKo5YEYQetAk6Peg+Hh2c04IB+Xh2Snss
         as+3fCtA9/p+CW3KQYoGOJxlEgVusaMym4mnrQQz8l0iIk79zQgEY8IQEjWB8LMuu8/t
         NeyaedJkfE4X8CvXWcQQuESxo0jpCLTD/9MAtIS6zLc/2GVb6kRlxho5OIBB74t5mTU8
         xvQuj/istiB7cKJ9O0e6CX2Q5ixoJWnOZLYytPyWqpRkeEvzvOlFA/LA8cQm3mM+1FXv
         BRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801093; x=1780405893;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t1nmBooCYIL6gijj0RhLOpiyGlP850IpBxaJF2Uaxp4=;
        b=mpem0OdoBrpbLysds5oNWTFErBAhK5OUxshLAb9N+BEjklweHRj8X4EnyJw2+ZHcx9
         gm5pwXJhK9J9SJggg27GTEqQstaHNXvmBXzSUWjOJwYRvY5h9FLp9QnS2zBair4YyQrI
         Pz3z9MtUzFkukj00Ryz+ajxMMF+GYyszHXl4+k237oTUqRygANgHyaCg55s+5LaKv5Sq
         3hrR8h36Ol0Aa062n5aZjTIzpCL7Oine246G6rEH+9umfsMIhMWJl/fo/ISVnOkLrEyI
         PD4vADu1JvGIQ+nk6JmXTfzjgFQ0DEA+TL5IDdJd3DDD6NSkR+/y1IWhdzvS2kg5Un2K
         /IlA==
X-Forwarded-Encrypted: i=1; AFNElJ8MAeJP3ZKNmFZBrkZD81rtLJX/2KV+WNKsXqhB7CxSMz5h1sj+Anm7PvVXRDUHHnn7GvMrCov3BCJM8XE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL3iADsPsOGzo3QVLLXjFXkl2QfEJI4p5r5GMScmddL5hhgAZg
	SWLfpG/prtnGvZhvJGdUa/ePQvorjUH4MBV5Ok60wV4YEuVap/uPRnSjccW4ngFVLMlMaj+yhbV
	FIFWbjdH3Pk4Blwvg41Y8Xx+HIJmDf5fNRHTpS8+OXIZJG9TEtAFocrzYqhWBIVREJFg=
X-Gm-Gg: Acq92OE5SoCtlPYiJoE3zma98ccNeLRzFNQvLHjf93triLljdhj0BqDy8LPdrzyQ4L3
	uMiIi6zf5AqmsxMl5yPESalgrJTFkv8sWYGqH4ongBou6+afQRnRX3j+92rt4ncXGJpXxG08xID
	i+WTtoOG0etRehRXXRdol+MjWqS1w7BCCEsvB+LCToTZXq0Y8LDx3JrpOcKL4+PVm1TVR4Xd7qG
	lyXQNX6EGfS8ZcWvr+4qnFTJgnX78luiczA98grWWLDlXmbo3Xfo2203F7MEBFQB8YG3pb/mrWy
	6BAAC5jOHFQkRvjuU4HcwxI5U+zliWYtEuzjhsEROqx6LprJtqcGrdYsMzWAtwoJsh8snVW0XXM
	FvwkvBfPnsDaOJoHgHahUViqMQDmZkAsQ1a+4zmNG3bb0Is+NJ0WRE67Rj0TZKA==
X-Received: by 2002:a05:6102:1453:10b0:633:9ac8:6bfd with SMTP id ada2fe7eead31-673bf88569amr7323122137.4.1779801093244;
        Tue, 26 May 2026 06:11:33 -0700 (PDT)
X-Received: by 2002:a05:6102:1453:10b0:633:9ac8:6bfd with SMTP id ada2fe7eead31-673bf88569amr7323089137.4.1779801092792;
        Tue, 26 May 2026 06:11:32 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:32 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:10:55 +0200
Subject: [PATCH v19 07/14] crypto: qce - Cancel work on device detach
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-7-08472fdcbf4a@oss.qualcomm.com>
References: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
In-Reply-To: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephan Gerhold <stephan.gerhold@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2419;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=atD/C70BmAbtLpgtk/gvN3TNLFsQT9cfTHvoiJm5/zo=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvub4oPxpUvAbSVN4B/pj5xEWuzyl0SR2VFe
 rF8kbhuJYaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb7gAKCRAFnS7L/zaE
 wyeFD/46/l63yuSUdQlhfYT4OY/W+59STZtAewnx+aiAWACncqNoBszVXsTs7wsrckSz0VvVGaS
 29ESTPTJbrPNF7es3LUrk+dZ9e1clxUNaDDw1v1p2wk7Ppy2itCaDxO6TGOL8VNWUC5ppAv5e31
 gZprPnxh62JRjqFBqTEGLOGLLyVHy9jAVdPNvD793KQb+egpZrFw0MTMQZf+Rq2lQl4bmboXt6D
 +U16DuZPtw6KXxPUg7UQp/SSey+jiFr/zUd0Xb2juh9TsvXOK7V24UTJc1/ooLH4ossJwVJDpON
 lcrCUrOANF9NvsSDH74i/UYjXzr0NGMyy7fAXUwiJ45U7ofzg2/JMcBNY1i4VPSucL/504OEKDR
 vlaocEYX313WRsXI1Q4MLru3WQbJ73qX3JgPdEDE+Oitdi1hr9cXfXbrMXRlzq0bVv36LFXOsuF
 jFgZeOcS/W1qT5lDsj9XukBwleBmYfvray2BDzRftHqKmq3xGtTS4ThOhHPthm3NEFpO3IqjsG7
 C70BRz+oqcQGrXxSN6pdJ1fs6RGdcsy0rVf8GRIKe1PYyLX1XBE2SduPJNKPNfRR/mFWZzci0gm
 8wlPzyCSzk4I1SynlWAl5Zk0nVrkI7EzK+tCmLAqHdYYAPfLqepSXqqjC+JjeiwriryO+BRrG6+
 bA8kjd5gU5WehkA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Vd3H+lp9 c=1 sm=1 tr=0 ts=6a159c05 cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=SDQHpg0AWQOuS8LWovAA:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
 a=QEXdDO2ut3YA:10 a=o1xkdb1NAhiiM49bd1HK:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: fPpW1RwDqkguOKQPBDeXEYQoZmIc1tUq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfXxONdPU/GJP7P
 TL+BPm/QMnZc14A4Dn9kWuGhOSFm/SLlv2NFmpz1tWZ4KdSaJAd/ZddxY/97EAgrMYTmGkpB4g6
 aucPtAxIMmGwnJWgEAl0rmXmcyQ5e6ZHF7RwPBwQA0f5Jqx9hIRYLPL17tnY1HxSf+JywVdgQtm
 yHR7rvU80DbWc9QgC43ndRRS5EVKElrTd2WaGzE/Pb/k3qImrWf8dnLpiwSV5uj0l4+263XCmgM
 QwxxCNPRHXZL1dFGIdsKKAILZo+wccHPzlNoFR3+7ABzVt8u07XblIBgRzhi/ptTQ35c962MdR9
 zuyA/p7pacOeZ2s22AKqzc0fq/OZQQEnH88x1YDKlsguqh/g2B9w9aO+K3KN0p4TrWM2hCVQGw7
 7O48Nt4EJqX8/eS5+wJ9rdYgK0hXqtZwgqlLB/ou10kuClvAvCSTXu8psUDhVRt7DlKvWB7sy7Q
 A4E1MIBa4uIyCaw6y+g==
X-Proofpoint-ORIG-GUID: fPpW1RwDqkguOKQPBDeXEYQoZmIc1tUq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260114

The workqueue is setup in probe() but never cancelled on error or in
remove(). Set up a devres action to clean it up. We need to move the
initialization earlier as we don't want to cancel the work before any
outstanding DMA transfer is terminated. Make sure we do terminate all
transfers in qce_dma_release() devres action.

Fixes: eb7986e5e14d ("crypto: qce - convert tasklet to workqueue")
Closes: https://sashiko.dev/#/patchset/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc%40oss.qualcomm.com?part=7
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 13 ++++++++++++-
 drivers/crypto/qce/dma.c  |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index b966f3365b7de8d2a8f6707397a34aa4facdc4ac..f671946cf7351cd5f0c319909bafd87e3af701c7 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -186,6 +186,13 @@ static int qce_check_version(struct qce_device *qce)
 	return 0;
 }
 
+static void qce_cancel_work(void *data)
+{
+	struct work_struct *work = data;
+
+	cancel_work_sync(work);
+}
+
 static int qce_crypto_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -227,6 +234,11 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	INIT_WORK(&qce->done_work, qce_req_done_work);
+	ret = devm_add_action_or_reset(dev, qce_cancel_work, &qce->done_work);
+	if (ret)
+		return ret;
+
 	ret = devm_qce_dma_request(qce->dev, &qce->dma);
 	if (ret)
 		return ret;
@@ -239,7 +251,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	INIT_WORK(&qce->done_work, qce_req_done_work);
 	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
 
 	qce->async_req_enqueue = qce_async_request_enqueue;
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 68cafd4741ad3d91906d39e817fc7873b028d498..7ec9d72fd690fb17e03ade7efe3cc522fb47e1ac 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -13,6 +13,8 @@ static void qce_dma_release(void *data)
 {
 	struct qce_dma_data *dma = data;
 
+	dmaengine_terminate_sync(dma->txchan);
+	dmaengine_terminate_sync(dma->rxchan);
 	dma_release_channel(dma->txchan);
 	dma_release_channel(dma->rxchan);
 	kfree(dma->result_buf);

-- 
2.47.3

