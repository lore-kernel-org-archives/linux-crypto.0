Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AFC44A72C
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457239; cv=none; b=oJQ//9xBLQKf7JG7xj76Xxi4v8nbde8RAvDTWx+LT8g42enNK/ljE/D9wDOTFySLgLbpX32di5HtaTXiZlAcaBOsNDM0gwhfnNIYsQNb1u9WSI8NlUDHIILjVYEdNx4kjC1KHdU+GBB1zO6jaBzoaL96/pF3ZGaKnvwNVrHoEwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457239; c=relaxed/simple;
	bh=3gGtptRmzqmCc/s80la+iOH6ohsBGrbmA4x74A9e/WQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OK8DDPPFzxGOgfr8FgclZxwDbKuCitUUHP6GFMgPWEWN0iYTzgFD8WxOFg137l9wmQKzfZwzLBdT6disl1FogAllI5DAJlvDe5ub4FiWf3vmH6aPnZfDwghQUJhfBUxmWqzGklcJxModU1vvNJ0ZKuj9j2uYCoVIyCG10nlTV0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fswkFDvc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=St9LFKV2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fswkFDvc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="St9LFKV2"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MBGvp61960034
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fXdt7SVf/FZ6AuLTLKVeyM4jn/YfPr8JdQLw7VC/8Ig=; b=fswkFDvcWcNggqXy
	PqIZBlmngvWd3q/Q0AcKl0BPzXocRb9cU0+6VA/C5dibb6gdgLwHTPCK4z3Te+ij
	nQ0S+yLEK5nMzbPI3469k0Kb0B39ObjlrUicds3fAwLRYDLarGdIMLNLW83HD51j
	V+AQXsylq3DTny8+gR4rFzEbgVxrKEHNP3+N7peHd4aMmhLJt0rxt1vDl7Ft7wQp
	xVL+hWj3pk9GQQx2m5Yta2qhgRHK/sWJkIpNGUrZgeqtncRecB3XVUdRko37g9XX
	FmL1mxwNc7uYXy9p3jgZY6y6Wt42s1L9u3UZjSDMWTCfpX1OLVO2UM4ey3R4Mykp
	dbtmsA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eahxesqd2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:33 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50ea1a7a5d0so200480581cf.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457233; x=1780062033; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXdt7SVf/FZ6AuLTLKVeyM4jn/YfPr8JdQLw7VC/8Ig=;
        b=St9LFKV2cUMGDv1jA+Kbkc08H/WRf/rZjxk8/Npjd82dbDIY7lG0BEr/2hYKJ39aeb
         MU0wvNU7CXEJRPqJ3XO1vBXogcfnnp5YCL6DnoVyYsPqmGYb42E4KWAtOvrFonrouQVF
         xD3vLU9jzR7TST8X1+fgdcX4jK/w4wJNTJzQAFd/VsdeABLpgK4AIZ2Jy16neCTTm9Ti
         I0c4E3kUi7fAYbPAzRhRSSTjAxt7Z/gd5Y0iNHcWufNsK4t/Z4KykMhK/5v6RsbG+q7j
         9qdRjZv/AN+7uCZ6GefM2D2AYFqi1GlEak/FwyuBI1FvvdfktGI6Qhp3ilJVFWzsl8kG
         FQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457233; x=1780062033;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fXdt7SVf/FZ6AuLTLKVeyM4jn/YfPr8JdQLw7VC/8Ig=;
        b=m9hBFkQpfgmwvAKS+41YeF0td7i70W5q4xWMI9lkLm+aiYSQllCgiX8tUf2Eais/l1
         +byPAJ/6z+iHiNp6DBN/2f0lpEjn6NENXkaxCYHuHpKPZRXxrznupr84JqYRivI2TmAC
         vqDYStnyWy5tnTjgF8J3PUigzWTUvQd2+JUywd3lxXXi4gVy3XyfTaf3AWktFLcyWKVX
         jhi9UANAlBuG4H1V6MVVJX69CzBA46jwGNbvNEqxmfqWEeI27WSDowG6UsUKV2lpz0h7
         7oH8rlTgcLytnmznwNEdAuCl/gw/zCTkM/V3QNQL6gsfUR5WfWFEXNpnsAiy4vmP2ElB
         RpQw==
X-Forwarded-Encrypted: i=1; AFNElJ8tBk0Ki7PGV9aBPK8BbJ5jIRC/p6DsVEAO2ootYQ/CIx7Iz8fxJ1ufXSAM4nqCTwyEcG/Sixw01HiDZBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4hhgu4HO5KAqyWmrWaMnErmmRd+QfXzz0PuHdP2cDPxXKjlO8
	xf/FbL5coKdxmTAPaSoF5hdprO6Z+enLJLcwi8hQC1wrh8MJHRa+PpGSOynj35b2yBcKB80lANC
	PgBhjBO45R649A2nQ3DOETTaGzDrfKpO/NASJxOuyQVU4u+9mghnaDyOw5Ggey5Js3yhy95iPuA
	I=
X-Gm-Gg: Acq92OGaT2PBhClQwtt5Iv5tHZy7T41pdmiU2CmzjzFG37QSF1L9L7u71JsRJqKI08F
	dw9D7bqJgsASqzq1v0tpILABvrXOqH2kDFDrTxPxlgg8i3/xUB0Sy1BFXb8r4MMCRAP4sPCtQQ3
	8e7h14Z4TVw3XPoOGMwPMVi6ANZ9MA/1CfNs32WUKhXvxg5LxDuT3UP75o74ESc+2P7X2bEYTFy
	ClhGZhFnYCvFR/mXTKhx8PD2lNlKBM2hK4hbgnr9nvScF6Gbk2su2BrJ5rEXqX7r5IePSoQ5Xtt
	tXhtYCcNnD6u+6ttHT4n80W11TsccVUnpKOzHc0Eh8lrwUWKCQm3XR0pQJfkNh4EMPmVdWA45ps
	DhEBNA+dIdqMns72RclPWCGhgHYuORnBzA9m5acMa59fmyZLXwQ==
X-Received: by 2002:a05:622a:5984:b0:50e:5819:d7e7 with SMTP id d75a77b69052e-516d43dc0dbmr47748971cf.3.1779457233305;
        Fri, 22 May 2026 06:40:33 -0700 (PDT)
X-Received: by 2002:a05:622a:5984:b0:50e:5819:d7e7 with SMTP id d75a77b69052e-516d43dc0dbmr47748331cf.3.1779457232774;
        Fri, 22 May 2026 06:40:32 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:31 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:40:00 +0200
Subject: [PATCH v18 07/14] crypto: qce - Cancel work on device detach
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-7-99103926bafc@oss.qualcomm.com>
References: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
In-Reply-To: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1791;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=3gGtptRmzqmCc/s80la+iOH6ohsBGrbmA4x74A9e/WQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy5mkKClz2fgik+N1QTc+VutSiwBTRy+E7IJ
 MSlUN86WayJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBcuQAKCRAFnS7L/zaE
 wxMwEAC11uWJsM+dHhtr9jLXScbswvOXkSzN4sO+6uRizeQwBY0QOxHsKrAtgQO4ZYJIP9pzLbv
 Yy6li0Stg/PaIitZnP67l5Vlga3V4ElVg3Ih1N4l6p9QlL9Vm1ZrSh/1bqAhlyfURBPCw56FrV5
 x0A9LZXfBn41Xj8jlBjQ52ZiHHAOzd8LpWdXaDevoqUlyzAr5PBaYWSyJGkRhGYGnj9CVCCYVlc
 b0MmGbM1UFWfFknLVZtNpf3k9Q+2aeY3Zz1z35NDLKuVkvORlDJrGR18t8ZN3oDnG1PKyuuFj/7
 HsNotGFhzhgPLQo3f28zpInfBh1ValihEOQoIBO/wd561cbr/etjVUOGuawbUy0gouBh9j2mnxf
 E31qjFRxK1mTEYypb1C1mXRik3P03+9y8kZSF4Ji1x6y3Y9WlO/pxh9lx35D2XSeOHqXpCubh9Q
 nO03kCbiTcDnQDQ3QZVNF5eWsOmed9rlQg1h3Vr1XwCc3SOnOSAv1e4yibbHvLwU1KqHchSDDZ2
 0KRoIdO9L6mAdYoK5ln7hhMznc/rXCbZewKujkiSZ7arbFEz5TfTZc/PE5gTtY5EOE8C55/e88q
 h2d5F24x968paTCS69AUg/XsUcKA7LvcQPVFig/Q1ROKK8JAJeBindm49qV6iJbHNggXXkEuED0
 sw+x0xgVA6rOcXg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfX9vJs6fL7QSph
 jW8QIziFN1P7H97tSelCMxfbloDsE8WcYsb0Cx6D0lnOFp2j6cfW4U8phbjS+yEv7/2lquiVh2H
 T/7LDNAIZcT9Ra/BFeVaLf9WGWUIF+abmu97OFJR4wpB2Ew+YSzMgzhuLFuGcScqnAsC1fRYUfm
 KZS0YpLkGgPy7KRXODBT4j6sT6NLxZzw6u4E7Qohtjcf26FTJKi6n1KVN3ALA7sJXzKQagh5kJL
 Clu5oO5YM7Ew5elIh6VfsbzCoCqy4u6inC6r1rRQCsw5uzTZA/qRhIv7BcMYp5xgS3nOMRVqrA5
 x0ldm8d97lH962T6lMoiECPNdP3tOsJpHQTRzgnLBe6pP90Kb06kPTHfw3lKNSgsIC+VvsJE0nk
 Vx2TMuUcdFUc4dS1LKSGc9LUk+S7RPny66lS/I4aum6ae/BHQScPsJ5Q/rDOXJkde7D5bY7BLAv
 AGamvmiofKoXgym8jnw==
X-Proofpoint-GUID: L2_zACVfxiNW3xk7M1gZo-74pVJqqmO7
X-Proofpoint-ORIG-GUID: L2_zACVfxiNW3xk7M1gZo-74pVJqqmO7
X-Authority-Analysis: v=2.4 cv=ar2CzyZV c=1 sm=1 tr=0 ts=6a105cd1 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=ETIHtu0_8y4auhP-DQsA:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220136

The workqueue is setup in probe() but never cancelled on error or in
remove(). Set up a devres action to clean it up. We need to move the
initialization earlier as we don't want to cancel the work before any
outstanding DMA transfer is terminated.

Fixes: eb7986e5e14d ("crypto: qce - convert tasklet to workqueue")
Closes: https://sashiko.dev/#/patchset/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc%40oss.qualcomm.com?part=7
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

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

-- 
2.47.3

