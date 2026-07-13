Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A7C4252C6
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947733; cv=none; b=Z/G/vqQNHprSQedhD81UzbA1fkdyGvxinKzWEqbKGtmJ3i0RnDuXjF+hi6fL0g7AfD0ZFfT7JA+wJi7G2tw0NaZTOq7T1NHF6QxNIxtQuCnSfpzhHSnQiQ1cJ8rKz1tYC4YPp6amXhRcvBnf3BDaQzyJOYq1vL8NaGg5+LksE20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947733; c=relaxed/simple;
	bh=I6qozPBGCCC+qW2tSIhDtPr1pqACnLdSRJYO6Q/jVhw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WCnO/aoWhngkYY0FJetkMyK1/F5Og07z7N4sg7i7Bx8N1WF87mn2nJMyL+JiVDyPrc3sS6Cd/MXUTBrgkAiTZa3Ej6KSt2RVK+rRkF83q6dzimVWA85tT3fMWGbFH2POiH2v3V7o0F1uiNMI8LFS6enPVcCrI7dvRu2fapg7F6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Apz6KNtL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z8DHo/ol; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Apz6KNtL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z8DHo/ol"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCE4ke1561473
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=; b=Apz6KNtLUUkpqBFy
	wbJooXmdHavqxiRK9SRzxQjoh8jddyAeXVAfsJpAzPeqX3uQsj9GYNrCY0Jgz2XL
	lkeLmgJ5TxKKIRVU+Y9MuMV0wpz5qK7WK52jor38TezZRpjWvWK7Ot3S8JUrGbNg
	bFUzJ4gSEwNEexhEqdPYcTz3Gj13GmvNFLz+It/VmXb1a5E/6u/yldFoH11GIdpl
	PMXmVU6TOcLz85SJrmdIGwxrD8mzI0nEnXU7v4vzRpPjOnbPjXxuXfmQkdFE3Jos
	R3tpBnCXyHgOL8rnbhx1WQ40Gozgg94BPS+fDJygUHKIprItcm4bSqJ7dTY4z3lw
	+MCO6Q==
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcjn3akkc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:08 +0000 (GMT)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a37aa2b6deso1793801eaf.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947728; x=1784552528; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=;
        b=Z8DHo/ol0Iagd7pmZQw3RFwST3uMgoTC30QuHK00pT6O1490yQSwCWSXspAKc5NDGO
         ZjkxelpYSyhPNoxrTKnB6tUv4GQ4GcLugSuucJ9i/EskITXoMdX1/8DfbqzpMmzd969X
         f9jkX4ufQPsvR8tCEmsxMEbX7k4ubdl/YuIScy6f3vPLjCz28DVX0sad2vAIkLYURRE+
         BBl/z5+Mqjq4ujDHYM9PDA5NNoDtyR9alVMy21Vu0vooKVlEs0AB9Kx0lcT62wQ5bWFq
         x90TC78CYSDHiNc8vAsaIGsUdaNjmxMWKBY59n0novkcXNFHFCTv44d7Hg1GRTIq0XA3
         3XEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947728; x=1784552528;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=;
        b=WTOrWmOnOMkIZErN9zD7Pri/E7WdFbUNZp2lgj212iI/gL01m7nQkeXu99qj/wNaBN
         ObdOODArrgHqgc/fRHEes9V4dk3DcM4ooLVK0qdXDXyvB2h/Z6ZlW93+GWV0LWz8puej
         YOWze45ynuMGUkTYVyQt8u2n/Gfa7fdkbEunNKsUAXdOVHaWzjFx4hi/cfhELyWEVvw1
         30fhQNkW/CqXGJ5fjgqNKNraD+kVdr61ClcIYphE5I/FOX3eAM5q9LAKAAaDIdDcJpfN
         Y2paJm2VSQZ5y6KFHCiMpq6FDtlpXZ3SXVA6g3LjDgE21msCPzbUEQG3FFetOTDPJslj
         sW7w==
X-Forwarded-Encrypted: i=1; AFNElJ+n37cgcU10DDGbDbYkke0KmOPAAwzs3jwkQ30geaJLVN/ZybQtQWjuCTuCWfjkOS8BQFvUgPhwQ/rf7p4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0Ojul7dmXYlLQ8p/YctCMuYkUQlpPvMvWHT2hUMaL3he3YdB3
	mtVFxQ//b938r/y+vU5osDxHrdb+i8HOpW2FIMcghseKJRE6tgBsADCVJDX3rNXsBPp3/GqvF4S
	XY4sRoq+biHy4H+QWSmM1NbQr48Knlvi1HvKEQv4opUL8hiUBT4FurwZK/rOejHZrfrw=
X-Gm-Gg: AfdE7cmHrYdIP3ZemkPdk5/nELHB1EGR9XkkmW4epwoMW+HUpI9d2Xp6ryy0aA0FENr
	LkdUiY2+2Y5ucdXxOlSOHqIiJ+OhvQh+DUANn/mafayBhXy1YYTXUVA0Ao3BFUbvXVFYQfcZIEI
	kjBp+01pixCXYbyejq5UmjXmuaALGT4Qs840IogNH0i1rvnlmHMDCJ+QZ54EeqJoBSXCwlttLSg
	2xfAj5fNzbKlXFNyZW4EnONldGbVGMNZ5g98t3idHXn4OA31mSb3OVQHjzI/PbTEc5MI3lOuUKz
	TyzHhVb0Txp9CWc/FlaHb3+wB4q2YxGyTQqc2kaVaq8jAkUGk7aX3caYygutwCS323lzA0D7kzY
	06RzDpTUX1HRV+I26aPzYpXf8a4x1ZeT6t+0TO/L7
X-Received: by 2002:a4a:e90a:0:b0:69e:3c9e:5e82 with SMTP id 006d021491bc7-6a39a6e0605mr5301032eaf.42.1783947727358;
        Mon, 13 Jul 2026 06:02:07 -0700 (PDT)
X-Received: by 2002:a4a:e90a:0:b0:69e:3c9e:5e82 with SMTP id 006d021491bc7-6a39a6e0605mr5300958eaf.42.1783947726554;
        Mon, 13 Jul 2026 06:02:06 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:02:04 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:13 +0200
Subject: [PATCH v21 12/14] crypto: qce - Map crypto memory for DMA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-12-bc2583e18475@oss.qualcomm.com>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
In-Reply-To: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3111;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=zV1OR5DiqlcnDzl6TeLEQ0wLAWkLclKWK2ow4Gd4Hb0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGg2k4Aqdj6ExXfrGYi33qNB2cF3TtdSmBxG
 ZEWkJ3G2I6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThoAAKCRAFnS7L/zaE
 w83CD/9adnWfXDogBIuVxqsFAK0DlbB+A8nFLQfV7/YceIQyAioQNgoRNTzD9KdUS6Belq9lDMB
 JiHASqWZlwv1Vq8vH1IIPhN4y9XkIHPJlQ2bm3wpIQYURD8QnlWRS4DWPWy8+J/nMJzHrd8xjW3
 rdoT9t8ATGSYLtYUCS2rJb9S5NTihi/e3AFGH2uCWgI/2VvHspDZEP6MwNeqrAt1It1AvNP4hyR
 e1lhSUNlAviaKAzRFOgtXZfd/TTsuDkAS5CZIuSTF1RKMP80YA6Z6Z9TMVJ+eti37tJg9p1YGyt
 4cXWOfxgVQz3wVaTaQQAd2mbR35B5jlt9wYR+g8hdH7CkOCj9+dSFYYftu6bmoH+kAhoGx3d9fV
 1BjqKYPJyp+ysTK3HlmGWhLddnAw1rpipDBfD6+rcs1tjSTKU7U43Hn9Gw3uBpISSd9lvwbIAp8
 bHrmffTHYd51PVA+50Amcmd4VbFhfSsf0jKvACSdewmtmg1r/Aub3HZ7fWkDniExLIh1u4I2uqO
 8iT4g0LSaZMgPBw87KUt/kymxHHjembekUq8KVN/FJgniWx+qUvEyQNLlm4XW97RSlRkxC+jhBK
 4SE7efnWclviV9PmijiUX3dkn/mXjyX0MJfAhr5V+oGpJ3FcjXlv0AJFWBvshQzPxIlZIcYiWsm
 /Y6B4Il3X+fkQ3Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfXyDjpg68a7B1n
 gBCq+EfQs37gQDTJQUTl84Ee8ypDlo87d3ZGd91Eqb0VqIa0Hq0K4fdP6hPIjTMiuGmKckDLQb0
 SBoC9wRnLx7MsrP7JgLq74CbQzP3+RcX/qidPXq5ZfeCPVFO6Ixl74PRNQWtdXWx5gnp920y1i0
 YZEjx9AS9WvEQrhsMo7MKDQGdXCn0A+81ycZD/zA8ccklr6/8DC+TIFNKC9OmijYmH1U9vty90h
 T8bXiog8RoY2G9gGvd1lUI5NIVRGbDcgwWVnCc2YhrqifPpviDIsPJNwRGuWvZFM1wn56yWqsfo
 tcZ0I6D5xND8+b3Hn5LdB5eW8EwW843eRUos0S1pIwilIPp7XuwfLyit99Oj4BxgFOTfzg6/oTx
 KSCEHmOaeZQoJt63FT9vcfgCCQOO4PoFRohn9etpOBiWvPR8BYUNwTCSVnn/8AVE0Uc3/iGQFWz
 7NVpa0LkLODWX9uupfQ==
X-Proofpoint-ORIG-GUID: Wrk98NuZeCA2pSfCL202ClcIvfCjKHwE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX0oePe6qbdcZc
 iUBOm9o3HYAbKwHzPiktyCj0AUvVDt0RIDmVTGc+UOYvv53r93NwW2lbj6z0cln6rGlWd2dkHPN
 D7GWk/7U/8cZbjLBF6K2rE4p4NdNOk0=
X-Proofpoint-GUID: Wrk98NuZeCA2pSfCL202ClcIvfCjKHwE
X-Authority-Analysis: v=2.4 cv=aaJRWxot c=1 sm=1 tr=0 ts=6a54e1d0 cx=c_pps
 a=wURt19dY5n+H4uQbQt9s7g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=9tNk7rGwWxUH_P3zroIA:9 a=QEXdDO2ut3YA:10
 a=-UhsvdU3ccFDOXFxFb4l:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

As the first step in converting the driver to using DMA for register
I/O, let's map the crypto memory range.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 23 ++++++++++++++++++++++-
 drivers/crypto/qce/core.h |  6 ++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index aa4a0b17749081f1ad653424bc265ee81e348e15..4031b4516d6519fc5024bbbcc439500a7b3314b2 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -191,10 +191,19 @@ static void qce_cancel_work(void *data)
 	cancel_work_sync(work);
 }
 
+static void qce_crypto_unmap_dma(void *data)
+{
+	struct qce_device *qce = data;
+
+	dma_unmap_resource(qce->dev, qce->base_dma, qce->dma_size,
+			   DMA_BIDIRECTIONAL, 0);
+}
+
 static int qce_crypto_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct qce_device *qce;
+	struct resource *res;
 	int ret;
 
 	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
@@ -204,7 +213,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->dev = dev;
 	platform_set_drvdata(pdev, qce);
 
-	qce->base = devm_platform_ioremap_resource(pdev, 0);
+	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(qce->base))
 		return PTR_ERR(qce->base);
 
@@ -254,6 +263,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
+	qce->dma_size = resource_size(res);
+	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
+					 DMA_BIDIRECTIONAL, 0);
+	qce->base_phys = res->start;
+	ret = dma_mapping_error(dev, qce->base_dma);
+	if (ret)
+		return ret;
+
+	ret = devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
+	if (ret)
+		return ret;
+
 	return devm_qce_register_algs(qce);
 }
 
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index f092ce2d3b04a936a37805c20ac5ba78d8fdd2df..a80e12eac6c87e5321cce16c56a4bf5003474ef0 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -27,6 +27,9 @@
  * @dma: pointer to dma data
  * @burst_size: the crypto burst size
  * @pipe_pair_id: which pipe pair id the device using
+ * @base_dma: base DMA address
+ * @base_phys: base physical address
+ * @dma_size: size of memory mapped for DMA
  * @async_req_enqueue: invoked by every algorithm to enqueue a request
  * @async_req_done: invoked by every algorithm to finish its request
  */
@@ -43,6 +46,9 @@ struct qce_device {
 	struct qce_dma_data dma;
 	int burst_size;
 	unsigned int pipe_pair_id;
+	dma_addr_t base_dma;
+	phys_addr_t base_phys;
+	size_t dma_size;
 	int (*async_req_enqueue)(struct qce_device *qce,
 				 struct crypto_async_request *req);
 	void (*async_req_done)(struct qce_device *qce, int ret);

-- 
2.47.3

