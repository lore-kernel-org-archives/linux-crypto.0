Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381774766BA
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826630; cv=none; b=foh0OUf6XSGodpv84Vk26Gb3w0Jb5LLgDO7Z+NOPUNMaZ03ExY0pp0ViXcddSn/42l+sExypQjzcLMr0QcRU37DjxxhgRluC3LH7Dn4N8FCGRRz6l0UbRYcVV8BYC8sBIluolCeklvXv0dpFgEKatb9xRLS79B1wz7bzcduv6gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826630; c=relaxed/simple;
	bh=KeA2nSTNl2mDaJCzIxdtrLUkRk83eDvjYrA1TIhvlbk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Oxe4ti2hMmtU6yFS9h6smrRkOFBN8qZjzJwkGExFuYSXmJoN+qgsQymC9C268s55vvwH+o0Dn43k1AX06aaw4tvRLklSwrtxlmMuiBkuxGzcFBvH+IfElmd5DfkBaOalfDV/xUdRWPKgd/+IVbpHxnonORRMnTTXGt7NmCgKxAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WInOlkdy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gLxBtEw2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WInOlkdy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gLxBtEw2"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NCvqvR011937
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tWAPezfKekMTeUaXy15klHPr2QCAL4plvMCAq141yTg=; b=WInOlkdyW0bqceuJ
	XP5J+K4waTI2PIMPHCKf6xQGma6zeMfIoQA5N6dRnlpGJcjd6cO1e821jPzmKhrd
	acDTzvEg6dbppefZiCOEl3MGEBS/9TWYEUnnneb/RtSHnoyHKOHZT2Ui2YbQL1qH
	Uj6YP8j7BEutk5SNBJmg2YN2leGIEuJ164IA1nau/BEu+kfeq/kxJVmJYbTAuK37
	F7O+ECK2HxFIfLeJP7qZSd4MyDsoqjDwZw9/8MdT1wxgV26CGW6IzJfwvJHrCs2N
	htKmrc3dCg1MGt7R68FqyuCwwQv/f3cNbh+Sst4Yo7cpQwySmzmp4YwZNzVnol/e
	kcK8Ew==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkayhbcvk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:12 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1b4d961dso10208201cf.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826611; x=1785431411; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tWAPezfKekMTeUaXy15klHPr2QCAL4plvMCAq141yTg=;
        b=gLxBtEw2qLd8Pq72f+g8JYUG4ci+wb3AIG/fzgP2geRWdrrKrZDIIIGUsG42z6jDQn
         P2VyjNRKpyP1Rchj5pfPqkiCiApDYuag7VVrwQ0H3LohysU/zf+29QiJpJufoczS/0GS
         dQENsyLJkGHkK518Ec1YrauhTUjg5w3vg5Hqe1WGQpPt6rBcnGkdWCiJk4RjBWXTetfz
         0OEsFPfrFy3Mu5oE+Fr1R1qHxsElhQlYD/X8V25zS61OTubvz69Z9yctE2uf+jjbxdUt
         KHecpXcX6nTY7aFEocqb3lgQkf1rgLoIgxveMLHbTzASvfrxt0ytgkXHrn7ZSSjWgYiG
         uhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826611; x=1785431411;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tWAPezfKekMTeUaXy15klHPr2QCAL4plvMCAq141yTg=;
        b=a9qW7goHvOHmxXiLV5fvMPkeSDD6TXIKhm6nG7YSULmUBprf4+r/mZ2TOLebiOkXet
         muGN/Zc6UWjIGBq/eFPnivFNdbacRqS4LV5nLKxex+ASf7Z2tHKoxFGj78HInKxstgxo
         kHjUEmGFnymKwFv2co+7LQvZvH28vU2K1IuM0fnKP5o2+boOIHG4isNYgx3UA678M8CY
         jspvHK4v9p4X1xSDOMXxVKK/HaxTEDvYRq/OUt03DXr63h/cBBzXwphHuCmd0pVe6e1A
         knUGJ7lzTMFeMxb4Eg0FtFKktQVnMs6VM1Xn7XutRHm04fw9HJGrnBazBZFvYkNuyI/g
         bviA==
X-Forwarded-Encrypted: i=1; AHgh+RoUcfhcj2eV/7DQ+azyCiMNLyjDye7exenttg7JuCpyeYic86Za9zdVl205ZyBjxkdLXfZ5IMc0FyqWrWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS5m4QexqCRBHaFhelOJdsobBHfq1yO3GfdDDj++ulfXfQTPtu
	SLWwUuchnuyeyVAx/GD5s53yEwQyvSUwsq/ZLLGJ7RdOrWFlQwD1UNmudKLsozx1VMYg8i9cJVc
	X1vbQF/mfww+GWHJhBvxuYVwrRG0196Nb25BeGVkUIVzlySWOVBWbA1IxMTZPF9voO8k=
X-Gm-Gg: AR+sD1269bX3Zi46j/3XkI6tzNk9Y5QONI9Vw/DsTTWKza/Nd7KLJSXhyDpZD5cCn9O
	pWcTiOchnT6CbkOKdrRENupa5uU/eMK3DdDlTtRO/vNWIRBxFy8Jdd2bRA5Y3ZYZ2qpSPsXDq+o
	hZLhQosNmHh//5w0W8vLlbXxTz4yH/23gl/bXCOZGqKBx/aQHzXAEFRSE5TPVdYVKBqZlDHMeGa
	54CbAegWSJf969EmFb8+eP4Yrd5pERPtOqkwKmhb4B7ib6YQUQFL2TewMSLesov6AO9CRVYvQy4
	Fk6/2VZE60GlTg+VseFJSRfvIqI2Ol5gpwjBEbsRd6y/+scSswJDYvROeaiZI9IlzVk9WihZHfl
	pbCYZnwtRvIwbZ9OmlIUeQdlpykvi
X-Received: by 2002:a05:622a:4d44:b0:528:1bad:a2a4 with SMTP id d75a77b69052e-5283ed28baemr34689651cf.15.1784826611455;
        Thu, 23 Jul 2026 10:10:11 -0700 (PDT)
X-Received: by 2002:a05:622a:4d44:b0:528:1bad:a2a4 with SMTP id d75a77b69052e-5283ed28baemr34689351cf.15.1784826610957;
        Thu, 23 Jul 2026 10:10:10 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:10:09 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:20 +0200
Subject: [PATCH v24 14/14] crypto: qce - Communicate the base physical
 address to the dmaengine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-14-4f87bb4d9938@oss.qualcomm.com>
References: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
In-Reply-To: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
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
        Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2903;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=KeA2nSTNl2mDaJCzIxdtrLUkRk83eDvjYrA1TIhvlbk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrKe6UqD+TDnHwjbOTrmC7yHfh6DFtjTuZM2
 qORlKVkrc6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKygAKCRAFnS7L/zaE
 w3soD/9tkyrjFGKxSib9ygzwLxNvhuL6MH/F4spX6VXKXz/JZ1DgRRetA1dhStrhWjwcWHyQbPs
 tG8dPKx+MV8/Wyrz+ELdMYHkGiTLa7zVFbJx4F9uRDQ+o2s6G0JBCYfEMUHfgjiZQ9wuwfRPK4B
 SYj4r2oSVTilPS8LT723DNYTJUi7mN6wQTq6aFt3TwubwU8hb2+jmvhVgZrpQ6Arc14ahAEKHyg
 6CgjZ+Vj1yHCJcJsKEWZyLck0fW+kg76xuz4GmAKHBOQIfNffjjvWITGqXb2amPXayfWrCnQwE9
 wt1/H9sp9Nge/zdE6JgRe8m+cuxxFYDcSw9N+5Q8272vcTo9bP2SbuilMsVrYNwCvtP8AUt4F/1
 TMjlEPkDLCw8clfqx8SH9ZhfdKmZGHzT1r4WRpEoQrdoDV45W3qPLpJIhCUWCtqZo1tqF9Tnrnj
 YRIzwMCK/qUh4xJf1Z44Yc7zcsUppmBlUaVWM9O484FMXD9xeojk+JoTAlTHAJY0DcooY2O/CjE
 6CWKFoDV6R0kK78xhygNqKVYlggk7c/YSlQLQbFZkhIu3ylWETzXMLdZ6APFaP4nqHzsx296H4l
 2VT8T+Whq13rgpAZi5E+7w1zrkQbk8Sx1DoPxHtL4ctvR9a6gY+8inx4kiHahJPtO4IO5Xocdt3
 c8Vaimv34oc6Y3g==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=HZgkiCE8 c=1 sm=1 tr=0 ts=6a624af4 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=6g4OycmRf1yXlxMorl0A:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-ORIG-GUID: UYoMQ_Zkmg-JPUxuZf3sSAIYZt7lEJ95
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX73whq12KalVe
 BdYcOiBWtJ5lJUOq8sL48RzgDTaGHxyvfliBqw5QPcNtrUoZhxejCHyvrgVWbiqrYLpaE9Cp+Ja
 WPY1wVt3fpkl5WYAtptQOQxUlM/6uUJAr0rMswfmd56vVdYvuHVIjxQGLhviu5e0Gs+OpV8tCQT
 yoI5slEsMp0yGg+s9kVE0O6ZhD/yie9qWMzm7kF3sCZRSUQDKXG8T+z18G3tF7J+0341QAR/9zV
 o7pB16rECtmOBlj1E+25cNiQZe8dS3V8XUbepHMF5VTEMUX/MwNBbMn7RPrU/1dOMncrBz3mhEh
 iL7bTtmbMeWDfOIIcBAfX80j3/FiovifScIVlyPy+lAEqWf/dgg/hmeqac4MXCG/X1PRV06xJTh
 rcfJFDKe+2dgqzNvxzv+wG7VFQN7qzkKrjBAvBij/f74oojuymMQm3C91g1FtLBxIDFNV4NPEBw
 F/SmH3q2qS9h5b9WZUA==
X-Proofpoint-GUID: UYoMQ_Zkmg-JPUxuZf3sSAIYZt7lEJ95
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX6+hRH7AKPbKp
 XXnKUDB9WViDKu1OaBhHZeTWbyVOBaaybnrbpwSdBuk5r8PCd2z2My8rDnlXoiz522ZILmGWNaG
 cUse2mdDRgiSIil9ghcmlkofVJcZ1u4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607230167

In order to communicate to the BAM DMA engine which address should be
used as a scratchpad for dummy writes related to BAM pipe locking,
fill out the dedicated BAM peripheral config structure and pass it to
the DMA driver using dmaengine_slave_config().

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c |  6 ++++--
 drivers/crypto/qce/dma.c  | 14 ++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 4031b4516d6519fc5024bbbcc439500a7b3314b2..50fdc8d808d0fe1d9d430ec601ab2ccf2ddf6e91 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -246,6 +246,9 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	qce->base_phys = res->start;
+	qce->dma_size = resource_size(res);
+
 	ret = devm_qce_dma_request(qce);
 	if (ret)
 		return ret;
@@ -263,10 +266,9 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
-	qce->dma_size = resource_size(res);
 	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
 					 DMA_BIDIRECTIONAL, 0);
-	qce->base_phys = res->start;
+
 	ret = dma_mapping_error(dev, qce->base_dma);
 	if (ret)
 		return ret;
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 88d253d9147cfc9ed275653f7fd248538378194a..ad951a8821a480ebfe4e025eb6a7417f97d7331e 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -11,6 +11,7 @@
 
 #include "core.h"
 #include "dma.h"
+#include "regs-v5.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
 #define QCE_BAM_CMD_SGL_SIZE		128
@@ -116,8 +117,17 @@ static void qce_dma_terminate(void *data)
 
 int devm_qce_dma_request(struct qce_device *qce)
 {
+	struct bam_config peripheral_cfg = {
+		.lock_scratchpad_addr = (u32)qce->base_phys + REG_VERSION,
+	};
+	struct dma_slave_config cfg = {
+		.direction = DMA_MEM_TO_DEV,
+		.peripheral_config = &peripheral_cfg,
+		.peripheral_size = sizeof(peripheral_cfg),
+	};
 	struct qce_dma_data *dma = &qce->dma;
 	struct device *dev = qce->dev;
+	int ret;
 
 	dma->result_buf = devm_kmalloc(dev, QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ, GFP_KERNEL);
 	if (!dma->result_buf)
@@ -133,6 +143,10 @@ int devm_qce_dma_request(struct qce_device *qce)
 		return dev_err_probe(dev, PTR_ERR(dma->rxchan),
 				     "Failed to get RX DMA channel\n");
 
+	ret = dmaengine_slave_config(dma->rxchan, &cfg);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to configure the RX DMA channel\n");
+
 	dma->bam_txn = devm_kzalloc(dev, sizeof(*dma->bam_txn), GFP_KERNEL);
 	if (!dma->bam_txn)
 		return -ENOMEM;

-- 
2.47.3

