Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020EB46AEC6
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457259; cv=none; b=Zq+3QSIqDCENCWTJ1nzY8s6Vf7dQMPh9+jPDWg+dSVetcquW3Q80nmqeGHXDrKyrVFhOF0ju1Tgns5+QRelCIWqUOQetCeaP1hf/0ku+mb5FwoCGXGJSfjlty+mQo04RpLUaLS8y5vdSH1Nc2oyoMbEjEm8k2CJYXnWle9bmAsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457259; c=relaxed/simple;
	bh=itwan/+JcxMJcmRkoZRAIh//GowjNEJ5Pa8ZGTWCN4E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WTJTJ6cucEA1rzdb2dPewpDb7ZLUt8xGrY+ZGnGC8FHXr5HO3iJp/fuTrNjqnUxDgMNHXWKHC6MEOTVIYzaEVVEtyHVYIBgOPKZtEyKNwzX9JO22tY5UsVST/IPtuxbyWNw6DzJUDRqAqFlKVAw9mdu/RcFgDJ6l48X401iFgxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q7a7As0i; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Uys/B9Jz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q7a7As0i";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Uys/B9Jz"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MBDOsd777027
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	okZRx7JveDxwd/GUmOqQGeY1v3DjRixvo9jJJu0R/N8=; b=Q7a7As0iUCihXzSA
	8DGEcg1wkTEXjLgkvMc/oQTcpocWg2Y6iCWPvnVPcQmYL+Vzmd3Lka7M067AfUNY
	3klcagQsEd46KlTw5tGan/RrtdMgZbtOayMXBw5oEJOJbZ+Lb4odNzBf6yRq5TVS
	Xw2x7BmMgVqOlh/xcp4ICszPH0OabjiLTIjaEoq3DAWnkKRgd4yDFW8nJIIjG2Ol
	SJKYoxcuw2MbSHO74FKtkCUDT7cI51p1eiKmxWtE1mNAlGxFRKQKA9xYLFSz7e+j
	Qh1GWrqqkbiUp7VhMo1LwakZfur/gJhHvzOKxOuwBj8PyNstpM8UfiRxyvvsgf0T
	5/F8rg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea94h3pu9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:48 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-516d4a9e852so30173031cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457248; x=1780062048; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=okZRx7JveDxwd/GUmOqQGeY1v3DjRixvo9jJJu0R/N8=;
        b=Uys/B9JzJNDQMyYbeqPSEf/yLwYzK27Ts2/yPBW4sOt384FpBgPdTJAa2Kn1vyyC10
         lVk5WF/WHq38ivIEDq80ISPo1pO4bbVk6sTn6CKnQGFrcdMkF9r7L9nbV7qJIEDDfXm3
         KgBg/FKQ/mdZ8y5kYZIw/DjtfK7Gt27HKbD0LCBGVWTAQpHO+dkpuyqABG9FFabpokOt
         mGqcO+GUSSg5PxAFDfuNqvORvC1SvS5tuBojVOkQ3fSQDNMn+ZafNdH/+EuFCPgiS6uj
         JwUFYqBqNnkbD1mAT8PmiET96WMrRBN4m38RLJ1oKrJd2Lg5Et5I4ic3Tz8VKIDcOgMA
         TP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457248; x=1780062048;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=okZRx7JveDxwd/GUmOqQGeY1v3DjRixvo9jJJu0R/N8=;
        b=RQfHzQGC+q//3reyyDNRezsnZEtbW2dmAi5fnof71S8yuvHiGeWDqJqt573bHYFoT3
         MG4jLn5GG0sIPoXCRv54mIH0WH1jI7W9yERQ7UNgDpSNAb39M/nslyyW5snKksM2uktl
         gv6OzM1Qg/RsYI9Ovh7yo5vnwfdKYp17xy6KcRoGJZJ9/oYsQ/4z/8lnJAhTTMIh6S26
         uifWA3trLwlNeG9vyLRFnCUSMt7ZjcgwvBuc/pmS41u3A8OMa0ysSMe8+kaEAN20bDbJ
         XFi+0GwdNitvHoVZB6rAla4WFnzufCJHQfZp70hx6dUx/A+zhvx04TDfE3Ywmcx2wiVR
         T7vQ==
X-Forwarded-Encrypted: i=1; AFNElJ9WJfo3Be+lSpzDGyyvkqMuQLAYlj3WOmD0wXhD9gNXAezKSJ0uJ6QtNLQk8TIgYXcktT0djX4807RydVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFc2uIdT6g/c8uOKuaccFOmtqUZRwrvAiIwcZGYl63V4ll0u6/
	612J8BPUzvrlE4PDJK8VIdPyJxyZrDX6GLsn5zBmgSryoRwTiBn5MOD7n/gmDdD4Wii9zSke7Ls
	bgiqz+r6O0u8CSHuH8bl7u9FYD/gu1moLXgRuMou2wgQ7eXLBJhtF7/gEb6gkFgTgATsevuU1bw
	8=
X-Gm-Gg: Acq92OGiCEFAnFUuOThuGLAST2LE/2QautsW0e8ssBE8+uMFUOTC11/AH700KzT6lg7
	AO+tN/FraDYPTQW8hJsYUI9jISygfnTtKxHtZWpAswr/dJIxwPMZqOx7VFZuocB7qEcqOXFq/QR
	+8ai1rYeEJ1rN5lNDIByTs3VrKHuFgc/ebuAsgvW8DbolUL8GR3uJRm1k2nBWrixTRuV+sWjk6h
	HkFLZHsFZ1AYNCxUhrYXKqwHabbct1Z4rFzsWqdd9fQmaroqqSBnmhPj1uQYNpDIr03nw6eXcyq
	4OcCWvN+EPnvU41mF2SOWibC1mGAG0kXZuLbjhgDXRMJFXkO5/BB7sRucZH2MeQlG86EweGM/DQ
	eMpwn16/GVS3XxlG3TUwQHF0OlPe3Xrq6fL3/U2qw0gIYKQhuuA==
X-Received: by 2002:a05:622a:244e:b0:516:d66e:7b1c with SMTP id d75a77b69052e-516d66ec02fmr41104561cf.34.1779457247618;
        Fri, 22 May 2026 06:40:47 -0700 (PDT)
X-Received: by 2002:a05:622a:244e:b0:516:d66e:7b1c with SMTP id d75a77b69052e-516d66ec02fmr41103961cf.34.1779457247161;
        Fri, 22 May 2026 06:40:47 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:46 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:40:07 +0200
Subject: [PATCH v18 14/14] crypto: qce - Communicate the base physical
 address to the dmaengine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-14-99103926bafc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1561;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=itwan/+JcxMJcmRkoZRAIh//GowjNEJ5Pa8ZGTWCN4E=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy+1JVvwHaZ9qMXejO19SIcCtwjcWfi4iqrs
 Snxz+YI1+SJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBcvgAKCRAFnS7L/zaE
 w55lD/9VdqXY5+AwSFtZGtFpvgU3LLl/oCf44IozAmHB4mPzRC4szaMIC2z5hyHEGRz8pCNIr2M
 Mbg2KnLvgf4gOx0zV09lH0jpN/l3xD6O3KPrk0KKG1bSHejWM7BbQpU/2itE7chaZCpq/q8CqTK
 nZV5GzNfZJogVF8S8LiBXONsIvsilt37tvmtaljNrc6YLvkYDmY2h4pzeAzte1PpOV4uV693uHo
 yGYsy65NYMgUvk2/adSg80xBGO4YGkAjpk1QF40eiGNlIs3rgCkpe8TA6ymm7j/AVmmjk79s4SR
 8aI+N0zDj4+SLkPE3xdCqca7eu7pP6Jp5PA9lF+/CpHSo+2QdGxJdNEh/N93w4zwY7La09+9xLK
 o5PL4egztSZFRjx3kPlda9M4PoQRTRlunJNgPFOW1ffQi2kHm18aERxpWHVPCSOOlgHX+XIAHL9
 gHgQGB/HpShlJHLvKbTjI5o1fm42K2KHeqDf88Son/Y8GCnpm2geSa39HiB5m6MsGiTd7txCqyz
 OnoFKiWEd/Ojmrf/dJjXGpRhcaSWRsCOyQzaNGxgnetfP4ORDpp9Vbp+HB3flEhm7LdBd3YMv9/
 pwZc/5MWcs5cnysXSUZ1vc6vf7mD1ZrevQPcs5ayprFaJ3vHg/b+1zUQQlAziNSsky/vBK10bUu
 EE7+gbmtqVy/41A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: tsy4FV3MdF2TA66R-cUG4axB7QjoMvdi
X-Authority-Analysis: v=2.4 cv=QblWeMbv c=1 sm=1 tr=0 ts=6a105ce0 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=TFgmKHP77OfOvYwKDSoA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: tsy4FV3MdF2TA66R-cUG4axB7QjoMvdi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfX0Q8Vp0yAeFP/
 b8Osj+OSfGbIONEtdl8ve2iDQI0fe36t3IzxQkW/xnZATNYsWkVF7wiX7BUN8t+Euj8jz4bVZv/
 PE0h9m0lpLu8GEk3xrbsY8JcTuaHQD1F6P5+m4WYipKy8O9abwUKJv5+FcasZjMZ6IlhXKcFZ5C
 hUTuIEqsqH6PO6vpndk4JkCvvRoZrBVYH/J7WE2+Lgg3kYPibxeuFSa8IZdfRDqCjMLmZoNkwk5
 Gz0CQQFTmOGz+EYAOrXh7q56vqlpezfqkCtmeUy8racgCAKi7zwUdxtrnrWvZhPQAP8azRgU74d
 XdRrL6v/0oYVCIt1kVVko/hj7E6QUDXV0CHnOp2VLIGdgMvkSryEU2RwzFuB2mPZfW2TOfkZtsT
 3RJsHqGUgZf2fUFWObeak+AIjMBJLDzqsFwSvITVnE7gURVzgz+/XVc4VWpQq9JEm9YuZN8BNMO
 erQXM6PnudpOLJdXukg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220136

In order to communicate to the BAM DMA engine which address should be
used as a scratchpad for dummy writes related to BAM pipe locking,
fill out and attach the provided metadata struct to the descriptor.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 437314f2aa94feee765f750304a28ed7beca90b0..f7a7b98d843f03b7a2722df0376a7be6b4a09114 100644
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
@@ -60,6 +65,10 @@ int qce_submit_cmd_desc(struct qce_device *qce)
 		goto err_unmap_sg;
 	}
 
+	ret = dmaengine_desc_attach_metadata(dma_desc, &meta, sizeof(meta));
+	if (ret)
+		goto err_unmap_sg;
+
 	qce_desc->dma_desc = dma_desc;
 	cookie = dmaengine_submit(qce_desc->dma_desc);
 

-- 
2.47.3

