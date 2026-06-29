Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02C7401A26
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727318; cv=none; b=KDp8XmQ8YtdzZofMhkIPKEGuRq8sjlRqt1Rxk8H6Oyt+VIr67nm19GPa96zzOXP7J7d2+Nf71O3GJuy6oWB5s7El4D4DIOrCF7F4TNEKiNr6bm0Ng4C4tHUOVwjlL15pwZhCo3mF0ig2iYrsLiML9QGZxU3mmpCMPqPtclsdvh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727318; c=relaxed/simple;
	bh=xewtmBe7Tjse/Oov1uLM7I+VZpNX0SB8ljw+4HhCUeA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UbwoRzqYPuYOsCT/A1YXjc7Gu9A7o5cMlTUtQsSgjBHNjC8j50c5jzCzDMp2NDv81mXFxHwQMglHklfr3KDFHIG/mv0pov4za+7JGw8ZkvJ+PAnOYH4yrR8uNBikPb+J6Jti32PfapQovLANdU9H2UnUs6WlDbcQASSKY2tu4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f1LnJ0Ml; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cESdO7PG; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f1LnJ0Ml";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cESdO7PG"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T7DoDW2188712
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MsWDKH/w5P6MtO/VNux/FoMTI22L7P5oBEgCNW8qbYk=; b=f1LnJ0MluvQzqb/A
	8FGWGtZDObgYrOjIacLNIcJMDS0cd8gYOUSBrqtDae6dAJXxTAZfyDoQhE83wygQ
	4hHRphUM3dLyM+PcEMscjg0TJolFwvtYLq/6ll5RvIRkLG2HxZpPYtemCazgDl9b
	5wK38mef8N1C78X6AEa4qSBhqHl2vauAOxVW5HnmhZWaeZSfO3YEEYAY4cPIQ+SO
	miy7XOu+URqXcLu4jLutc8zmZ+aXLty67WqOPgHW6M8mqeREhuMwqwWQvYo3NNBa
	3XkWEJ+Wu1d4uD5RNaY2lwHBGpdxf3hWS/EHLkpnBPJFIFu+rQzq6AGnUJMe7611
	fOpxLw==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3m4trq85-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:56 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-737f1f1e1bbso587206137.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727315; x=1783332115; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MsWDKH/w5P6MtO/VNux/FoMTI22L7P5oBEgCNW8qbYk=;
        b=cESdO7PG2t/YZnq66+eqcsvjf0Kwa3NEtDL8YjJ347X2xD2up1RFSGGwbLGRXniOrb
         /fe06ueijplvcS1wJhCa+yqIWZ+LZ7ZpWxoQgYo9N5zryy7cw9W8RROuyTJicKhfpFQ7
         tmJS7twHUA06kr7tR/ggOIwKakIUkLWmUQtjYKju1WWARq0stDlP/4QFl+4xIJK4CikD
         MbGOLrijmMiLQrGLFhRHYARvBmRmMWPzBqSaSWkVTW15wE0A1YHgHyOYGVKttKV0WTkv
         UKTT6BjlUkPe3YIp2+IYXlGW1u9ExGo5fjweyMW/zQfwPkZ5xaNx9mOo36K75yyN480L
         zI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727315; x=1783332115;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MsWDKH/w5P6MtO/VNux/FoMTI22L7P5oBEgCNW8qbYk=;
        b=H08IgNRrO6mBJsufn28RjHUR5qhkfw+RUJdTRylMRUDEGczMoLxs5D20yKgLqKJP8Y
         g4clSroffTqZJ3b4cpEup3Sa+qXLg58X+wQyUv2pMyzKmMyC293aVUin0kw1FbsQzwPZ
         KimG/rWBnsU6MLR6yLOIs2zQWIv9dJKO9QS7VL/hOgAZiriDwZz4m05I1az/5TWvnwPc
         A66/uI9x4LKbRYvVu2qMRVzuTsHTAdx/ZDYXdbXLNoZFX/g32z2+AyUNz7+5lhoWraHx
         5EZlEiIKTXe+HEVOu5yO9RgaEZ6aSRBAjfyVLtTfDud5a2LGU1IvzniKiTOCamxWMIwh
         gUiw==
X-Forwarded-Encrypted: i=1; AHgh+RpWf6M/BQzOYRHfudTWPpttW9d62w0qasoTqtlQKWGAKVZEyhFcSPjhw5v3qFnb3Wjm1S3AUuC5YtksvE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKAR8tgD+PQeCBh2cdAYEmikUvX4K10BCyLLJnJIXNOgFe8Msy
	3spllY0WZBpQ7PwVtpIXNPn5a3ddscNUKIAg9AorVbCRN2NyCnLIxapzQxwYlbXeHzeOlKhvzc5
	odVNiICbTwnHqnAyngN2d694R5woy+wLzAExm7NcKk9tMflWNJpwOPE+v2ESs9EJgWos=
X-Gm-Gg: AfdE7ckOKnxVlp9VSM6eSePAg1/WTn6olFG6HxOlsmpYmL9fGFExT1aNGH6quG/LHNh
	Nf1f+LdvgQ0OgQGOnzMsHt72TQK+xLj47WfnWcREE6F4NC+2b9W3NIRj0G/RDDpYCOL5hFy8zdj
	+qfv72sa5ddPJ36DwKo9XsUKNYeBE65Aoh4fL9Oe5LcRnJ8Av4oOM3L7TibHDC3908AmOKG0hEg
	jmJnYLbmTO3lA8+cADGp1tV5LFBvrArd3Q34h8usWuWD7cspWLWNJ0ztRbAVFAMsk1c8hQIM6dn
	qwaOW9ik+rPzAhoXJVrXadUomcKUye3PamQPQYsA+3B2KaIdftSaiJtLbm3JPBWclaNeBVyq899
	1PFMmJB446y1hRO8vOKHbhzdMQ8ElazJOt+h0Dcvq
X-Received: by 2002:a05:6102:2927:b0:738:9c30:2bab with SMTP id ada2fe7eead31-7389c30333emr1034257137.24.1782727315231;
        Mon, 29 Jun 2026 03:01:55 -0700 (PDT)
X-Received: by 2002:a05:6102:2927:b0:738:9c30:2bab with SMTP id ada2fe7eead31-7389c30333emr1034174137.24.1782727314682;
        Mon, 29 Jun 2026 03:01:54 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:53 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:16 +0200
Subject: [PATCH v20 14/14] crypto: qce - Communicate the base physical
 address to the dmaengine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-14-56f67da84c05@oss.qualcomm.com>
References: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
In-Reply-To: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1859;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=xewtmBe7Tjse/Oov1uLM7I+VZpNX0SB8ljw+4HhCUeA=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJztJW4956nVEX9MjvwMkNGVeY7bWyWSsjEL
 JlDk0vhZGaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCcwAKCRAFnS7L/zaE
 w8LID/92VK6MtF4PX0Ay8O+iWvgPKwVfNgK9jA1tCP8Qd+Gh9YKfJjpq6CAhVvDnvbe18q/azgf
 hJHbJlhuPzXqYSETS56gA2/l/9+abNM9jLQKvK61ZTwUm9TXdVrWtuByl9244yf1NyP74p4C31t
 k0wv8ve08/Y1PgmWrFamnfYLHCZUgWjsB49qpNOqaM2c7kKZlpSW+K7jItm9dcdbEcGWrmF3+UA
 PABxkswczFoV5tXRN3uxgW28AEuplE8AMc8qKubRbTdYE+4SSoMdmKDkhiwOmYVTWplzJPErnuv
 9Kfl0khAZDvs+R6M4mh2Cm+PxxrbwJGxxbbvV4zqBqNo+tqE00kH4nvuMi5DUZCs3oqkXCqsDUt
 35FFBaQzYVCD9ArHQP3hIF18Pqg//htVnMFk44+/uPWoi7zLmtjzdP8qZ6F4LcuKoaVqs+iXbVS
 VsI4jCP9BSJ2yLG6O7Qwg1k6BbXv0DdrzdwCDkKmJw4Qp/8uA0QhSndqnbTl3P370E0QtvC9j1V
 MMmqD5LAZqlXgfDYnHgRmtr6Ipcq0eBPmmNPOMoJ6bgZxLCO/O0bT/TqYucw57zhs5UPUSoSiUa
 cGNQAkja49h+5Bziwx+6nJHCetoNg+WLfJospblWNsZlnZWkwPmPEzwJAVV+e5YFpI/ZyQVvqh8
 39N0QNMbtzQFong==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX1vNb2dwO9qNY
 emHf9wH2kf0yrRrKPw8H5c12DsiEkhmMNraYLxdyOfj6YJh+DcEpckILIWxfMLz7+qmVR6nymxv
 +F/SwmFXwc7LDlTuT8q8Fy0I/V8Kt3mNwbZX4doinprS6qpbwLjIKC0X7sGfOyWcS2M/jvS3Eaf
 kGQQVdc8NdIiI1ACjHKNPDEwf/iUNv8s+JxjHIbzqV7zIX/ITOsIO8G01LiS5HYZQIrflGtRsbT
 J3HFhl21auEmJQfGqjgfgxQUbht4D6cAlhtw2+b9xC3mJHmOOTcjEmMthLIXrE2EL3z4FsQsTIQ
 eFy2y96t8xZmz0Xdh2y5xIDDC7Jpe3kB7cHIbCJKEcq1ZHhwJASjgx6B6+aOqikcwywGpuLYkeo
 y0MlYq7l3IE9u0PnB7p9GumCVrQGZAUNvTmSRRKzNegjvHw3t9fz3awjHG8MumBqTB7Dutmhc/U
 ZzHyfvgN00leibW+EYA==
X-Authority-Analysis: v=2.4 cv=R58z39RX c=1 sm=1 tr=0 ts=6a424294 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=TFgmKHP77OfOvYwKDSoA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfXzED38/XNDinP
 KfozecyeHsbsDhQ3w0VM1Y4l9d8My7EUdD2cZPCFuQnzLu6PQvo5MIGoghWvMVaM7v26yxz57uR
 JOTYiiOsw5MCQzV/tiltRq5m+JuRTpo=
X-Proofpoint-ORIG-GUID: HH9OoDa8-d50uxPmtj0klwP0VNNhsymW
X-Proofpoint-GUID: HH9OoDa8-d50uxPmtj0klwP0VNNhsymW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290080

In order to communicate to the BAM DMA engine which address should be
used as a scratchpad for dummy writes related to BAM pipe locking,
fill out and attach the provided metadata struct to the descriptor.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 1b43c56503334154be4b8000e5a9330b2005cb64..6410f8dc5bcf517223c768a3e8f87af245076c84 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -11,6 +11,7 @@
 
 #include "core.h"
 #include "dma.h"
+#include "regs-v5.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
 #define QCE_BAM_CMD_SGL_SIZE		128
@@ -41,6 +42,10 @@ void qce_clear_bam_transaction(struct qce_device *qce)
 
 int qce_submit_cmd_desc(struct qce_device *qce)
 {
+	struct bam_desc_metadata meta = {
+		.scratchpad_addr = qce->base_phys + REG_VERSION,
+		.direction = DMA_MEM_TO_DEV,
+	};
 	struct qce_desc_info *qce_desc = qce->dma.bam_txn->desc;
 	struct qce_bam_transaction *bam_txn = qce->dma.bam_txn;
 	struct dma_async_tx_descriptor *dma_desc;
@@ -60,15 +65,21 @@ int qce_submit_cmd_desc(struct qce_device *qce)
 		goto err_unmap_sg;
 	}
 
+	ret = dmaengine_desc_attach_metadata(dma_desc, &meta, sizeof(meta));
+	if (ret)
+		goto err_free_desc;
+
 	qce_desc->dma_desc = dma_desc;
 	cookie = dmaengine_submit(qce_desc->dma_desc);
 
 	ret = dma_submit_error(cookie);
 	if (ret)
-		goto err_unmap_sg;
+		goto err_free_desc;
 
 	return 0;
 
+err_free_desc:
+	dmaengine_desc_free(dma_desc);
 err_unmap_sg:
 	dma_unmap_sg(qce->dev, bam_txn->wr_sgl, bam_txn->wr_sgl_cnt, DMA_TO_DEVICE);
 	return ret;

-- 
2.47.3

