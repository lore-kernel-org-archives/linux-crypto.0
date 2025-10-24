Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F23426ED37
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 21:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761341713; cv=none; b=gjCfutTPFWYVlE+GQ4QPlBeehvCvt98vOnfFvjYLK+SOXMFsUpVcqMWGtnMGN9+ymQgmMVTfpkqCP70+SY+7RIhdpLEoDYtaEONl2PH58Rt0vaFCWNDWmDLIrJY/GXOdrW69fCcGw3afE351oKCC1ylVSq4A4HBAnqeKQs57ZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761341713; c=relaxed/simple;
	bh=WlbCj8/yFWNBZJSWw7I75oAu7ZGn1oMh3UBg4y5Eorc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nMPs18RAapdnQc0NYREZW4CU4DYthPP510AudiaWEYksIzG+Mi403z6wBZ3eFLs4fJMFTz343jvX5in1MobbaRju3mi9ygGne14V0LqU5VLdDPzZAyaDR/d2Ac9jkZMHdewm9cebjupRDZFV9IZVYsaBRZfEk2UOPOM4DUlhPH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TAmafXT5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TAmafXT5"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OI9hlY021391
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 21:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=iYwGj867iebYBlUQ6FRlDd
	eZUCqI3oxDReWWqzN70+w=; b=TAmafXT5S06jW0SDovRjdXjMQv9Bw44tGc7IMJ
	l77VUoE36a9/qz29COj1pk5dmPSjzbzM+1PgbGNEZW73GwFqngec9VG+zBkWGqiM
	1HC3F0hBoH/AWRMAjyWtUh/v9CSFP9zxlWgoMpUxfTnEOA/Z4RhNXXGZM//YQOZI
	ctWWZIE9uunjy7syccPbUGxLg+F6P2HXKBYZtsTOaJvG5z5fEqwWVB6lyM/i/CGS
	X9AN9M8dLfvkm1WcfzfkHtMnZJX7nDWQ2rEF4LYsY8NPe9qIpFW4IAFXRo6Z+c40
	girjMSydIOvxJRD0ayutuFdpjQ7+bKOQuvdDsR5qQ51TbvTg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49v08pwjk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 21:35:10 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso4494824a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 14:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761341709; x=1761946509;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYwGj867iebYBlUQ6FRlDdeZUCqI3oxDReWWqzN70+w=;
        b=LzRdWHPG2BoVRYqmCH9F2XouDTgr1pVgs3L6hkrB6icS1PcpmFzqoGFrnElhm9GYYi
         eX14ju5sRnERyZnjAt1+Ph8khL+xDqGOowMP7sq2IGReWA7OD+NVTiCqg4Tq5sxZbwX1
         793qkET3CAhV7SLLto2fAI/SKKSlcuplaYmV2kLppU5EwI+eYXALs2B4DqY+9fYQOkOp
         VANRC6VqpBpq3ZdeWCit9lOmRzq4k3LwT0jcaN0Up/Np6HESuSReElLEo7dcKSP2RBuQ
         vmTpMyQjS5BPNNHIDVvhFi8oL/haS1TVgFkh4u+35l0/UDDcCvTY4ATsmvlFkWTN732l
         zLKw==
X-Gm-Message-State: AOJu0YwDp2m93CdZEJwIRIS/pzi+FANCW/2CaJcMyJkHv5N9pW/GPYUh
	lg8jgHbchho8LkQXrg4SSo/+28qVxIasF7scbqzFl9vH0s9sbzDyGgwfdihO7yZdCAKQ5vQj+SX
	l0y07b+pl6QaTcNGaZtcvionPkV7XjrxJu0/YBxgMIINbnLoeJmoe0rnYp9yZqUT/jR4=
X-Gm-Gg: ASbGnctfKSrVyjzP3NJOPJmtV3XvYPwCVRgqXobUYORvO+d7HDmzhCkc6MsXLRP+J2y
	N4mGGenymUQqeJCi2PE5AcglyuUX+Q2LW8IG3fovwLw6IAWof+WU+nvkMx3VvR98yjS5hTPGFex
	VWB4K8ILdZkXq4GCPAKxBLXUE2EG3yxzuCfnOIkhnpTJ+5SvWNlQeJiRtiyruIQBrMLufiC86YL
	jCNl3prfRLYHFJGwfPLI6KLMk8ws0c5TpoWI/RLZXCNghNymqHFFkOOXb+A8gLxy1f4M1B21fVz
	zP/yJ5jzb3UX6+Bl1ziTtJ/2yWB9KrqBp35swDcCy+Lg0zPTpE4eC6XMbIDIHkXDnYQN3kYxcTn
	Jj8numbaDvL9hd+PABI1ZZSD0H+UJ1a6wkaYURTAqd/GWOxMAJTDM8bE3Jw==
X-Received: by 2002:a17:90b:3883:b0:33e:2d0f:478e with SMTP id 98e67ed59e1d1-33fd64bae12mr4044669a91.3.1761341708912;
        Fri, 24 Oct 2025 14:35:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWlQxqPCcIAOWXSzN5WR1fExwHDigmaUzlorQ8BuPJ5M6mU/xZjao9CQZDugQ5HMPoV6fhEw==
X-Received: by 2002:a17:90b:3883:b0:33e:2d0f:478e with SMTP id 98e67ed59e1d1-33fd64bae12mr4044651a91.3.1761341708473;
        Fri, 24 Oct 2025 14:35:08 -0700 (PDT)
Received: from hu-bjorande-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b712ce3a90bsm193546a12.25.2025.10.24.14.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 14:35:08 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Date: Fri, 24 Oct 2025 14:35:07 -0700
Subject: [PATCH] crypto: qce: Provide dev_err_probe() status on DMA failure
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-qce-dma-err-probe-v1-1-03de2477bb5c@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAArx+2gC/x3MPQqAMAxA4atIZgO1aEWvIg79iZrBqimIULy7x
 fEb3suQSJgSjFUGoZsTH7GgqSvwm40rIYdi0Ep3jdItXp4w7BZJBE85HKHtjRqC6Zz1Bkp3Ci3
 8/M9pft8PK4tbH2MAAAA=
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761341707; l=1372;
 i=bjorn.andersson@oss.qualcomm.com; s=20230915; h=from:subject:message-id;
 bh=WlbCj8/yFWNBZJSWw7I75oAu7ZGn1oMh3UBg4y5Eorc=;
 b=CkJ0xxxNyWQYABSEWTZR5o42pHfUizLhi2bwdWincG9fpab3WpXn+18HW9DsX0Ysscl74ABcY
 OEyeqMj0UX3AhV33NCrKzdQMNO2S7WeVF1mcZ/CRUyBPijfmCCTjxOk
X-Developer-Key: i=bjorn.andersson@oss.qualcomm.com; a=ed25519;
 pk=VkhObtljigy9k0ZUIE1Mvr0Y+E1dgBEH9WoLQnUtbIM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAwMCBTYWx0ZWRfX/tnFhfWUq1IL
 XavyxA/8va7pq1FLyxvGWrumF/IPB2M5gM8inKn7d4LLrCqoO3zhnGikx+1o8DfWxF9my9in3KH
 rUCx+FSd1HmzmIhXaRgxBQ56ZVsZQtZrdb93nDBR1sXvfkf2/2SsZY+gPu2ee6Ovwh18W+1OfXj
 nigz9oORaZF2lPaU73rJsuDd/YqUxknwpkOBmZ7sPRYdM0RTWz0fObffhjY8m4X6KC9dY1xKuqx
 Dl+ZfkNHR0/K8aNvbBRgtpegs6MNDvzh12wIoMtK9KAK9uWyuRJ19pY8TEA2Yxu0iESCz3NY1Un
 FbnC33lNJ4xdlj+mK8EaSsCi4HN8LnJnVUQRmDW7ahaJm7bO5rnqjseWHBjesVGXDnKs/tXizW4
 r3XUfr8DL+HXJTSgF9SlvrK9l7HFDQ==
X-Proofpoint-GUID: fa6y4zaIYoCCJYHuwg7cEQzai_uOw7fL
X-Authority-Analysis: v=2.4 cv=Up1u9uwB c=1 sm=1 tr=0 ts=68fbf10e cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=9nxSR7a-VyI66LGa1BwA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: fa6y4zaIYoCCJYHuwg7cEQzai_uOw7fL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180000

On multiple occasions the qce device have shown up in devices_deferred,
without the explanation that this came from the failure to acquire the
DMA channels from the associated BAM.

Use dev_err_probe() to associate this context with the failure to faster
pinpoint the culprit when this happens in the future.

Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 1dec7aea852d..68cafd4741ad 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -24,11 +24,13 @@ int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
 
 	dma->txchan = dma_request_chan(dev, "tx");
 	if (IS_ERR(dma->txchan))
-		return PTR_ERR(dma->txchan);
+		return dev_err_probe(dev, PTR_ERR(dma->txchan),
+				     "Failed to get TX DMA channel\n");
 
 	dma->rxchan = dma_request_chan(dev, "rx");
 	if (IS_ERR(dma->rxchan)) {
-		ret = PTR_ERR(dma->rxchan);
+		ret = dev_err_probe(dev, PTR_ERR(dma->rxchan),
+				    "Failed to get RX DMA channel\n");
 		goto error_rx;
 	}
 

---
base-commit: 72fb0170ef1f45addf726319c52a0562b6913707
change-id: 20251024-qce-dma-err-probe-a7609d65bac6

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

