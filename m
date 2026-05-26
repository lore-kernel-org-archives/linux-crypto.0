Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274DC3FFAB3
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801110; cv=none; b=rtKT5tRx8WqjcBZNtmmg/Kg4x8cX8hMN8XJr5s+16x4gdtwnEcxdrpIX+V9vhpt08UPJs0rcSHRSYkEzY8SuQa0NNEzF+2NLWzX/h/LJnt8GNPU0oY0VOnFUTu2nU6NKGJPyydiSWAYGcIvQLobjaS6ifukqzuU1VIpUpNX68Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801110; c=relaxed/simple;
	bh=wYb8hULMzww90PvO6ikCdSc5niQ+bjPp5Yt9PZ3KUhY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=alOu9FkjOFcYGJ888XQ9/v8LCdHEGbAb+6a/dms+MOby6Gxu9G9ERk4DdJ+RMBZRWo9BRjpOxs9dkxYh6JdyHu3XmVReYAzbmwsyMMnsWlm5Cfv8NANyOA0LB7jL6z+w7siRS320Nxj/+XkbtZCPpkksGmsbsHhDGfYvknLbFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LVQAAu3r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ASKVkKTt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LVQAAu3r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ASKVkKTt"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsXqb2496610
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	heR+Rq57taQJntO27O6cewlt6NKto0RiHGK1KQcUICw=; b=LVQAAu3r4aDq6EIQ
	7bR/wma6Rra4RG5Yhk+pjblvuattCKxBpprJ/R9sku3jK0CMH5qP8Y2j+YlnWWmp
	E5WWGqXyM/G0tbrYFxQWkDrLMwOTACv0NCFDA6xEARmf0ba/Px6nSY+BjU5jZ73o
	h3FRnAnBsaMxpiFaXcywmGtnXDymY6wayor66LjQhEFZxTofhZrII04G7spZfvfH
	Wl14zwh8c3fISM21okivh5RHUzZOeH3ADHS08Tg6729xt9w7ipgWoMaqckON7+/L
	YDwQnnDvwSKhwNmhkg0sflb3sSpSbQvDYYdNQ3mZ9CaP772w+OVPCoM6EbTPbP88
	WLu2dA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecpyqmdbq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:48 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-639389de134so4264043137.2
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801107; x=1780405907; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=heR+Rq57taQJntO27O6cewlt6NKto0RiHGK1KQcUICw=;
        b=ASKVkKTtzyGz9Yzq0i9+ymCNWhXovR4l9Z1BBiA5pRJON5yBFmIVX0Uxo0a0Ief1sP
         tUmHpMRRH59Nk/QPNrbx6PdgHhlm4q9QWlP9diizZQpFRt+XP4MiRnoktl4I1m1+wTeT
         HrEyZVLR2EOdAQWwUqE+gE3DpNX7jBeKiPukvIGCRZOFPp7bGa5FgcfkqvRrfKbLS3iH
         h2hmWV7ui71S21D45rM8MpMJz/Upf92H6QU0GXapBhI3oZGTQQV/eSJmzYnEDvp+7oX+
         Wrz9CSl/Nh4c1bImDbPeqRaS+ISgnPCkJQ5xW+khKjuy3lfIB4Lxf8QBxPlQSyrb2heM
         umFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801107; x=1780405907;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=heR+Rq57taQJntO27O6cewlt6NKto0RiHGK1KQcUICw=;
        b=hc8IJqUvwxLVV/6OFziYkyZg07qlKObjG6YZyHv+gHTQmJOYpTFIqumBE5gMcYDRbH
         nREqTdVMn3E/EvO8wk0SLUNnYAiGlVDLCe1lt2hM0z5VyQc66RT/J1ohDJj9utQ5/akn
         Dhfvw4x6NXGE2JrkeEoAmhm28FmhgH2+QBHv9KWGvxPgxiDW17N78rZtNaP36PK+pU0N
         jn5DptLv2dC5HDmnM5TEBs4sAAjokOBbJmWoYU/EFBWH6IVzzjgk+30rQqY7q5bVFXPv
         IpCwiZQ0ceidOdZe+FwuvaZ0ktj+ygcNjRBuTS6PksaE3CzoQNU8DPbhAkudmFm6EqsR
         I6kA==
X-Forwarded-Encrypted: i=1; AFNElJ/+kGUwAEe6VY1PLQ458iAz0MQLAcVQ7PocWpsxaLILuwpHNQFBAjMJxuWs5pKweN+QcPH9B8EvPl4kVoU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp7zbQGYzHqBtinMJ/e7IE6s4zvWMO5cuXPa15KeN7zHS1Ulss
	4CI7qQWDrjsL4RtGQmoRJNuXAGzbqJ3WmaiHPuHP3Civt6a+o6YH34avOaUq16FVM86kjA7ImAl
	GjK9INUnUvK5aoUuhd7S/sPKTQYMsmgMPv90sgYbScZ2SSqixNIo0UaERQhijQUq1Si8=
X-Gm-Gg: Acq92OHyMK/RrajNZGykJSR7AxmzwnJ+SJQQB0dpDVurqdMZ/lDDC4zcqr+HMSpNoTx
	SlQwCJtdFqMMDsVp/2/2tPuo1MSX3TwThGFDf5RHU7IuBsTu6FFpTUjyK+v6/qKmHvvFHddcmCg
	ApVURT6CayZZxh6jiC4wfsIlvnM+TX2r8JfYXsB1ESK+OM3OQY6ZFTL/WtpaJOdygWHor42LiRZ
	VQ11yCZDw03WxExplbAR6bdn64IkCk7iOfjBax2RBUqpJtApv4mDErMm6nUqX4cV/g3tFXTkGOB
	2qbic5+IlpcWGv2Ih4nnzBiQ6BK709duWD9JeZ9kZvfnfR0eSnwOHJqGBKc42hV3VKf4az8fLfF
	FPLZPWNUuD6NRrmbURCH8MXZm4qV5JSzsVkqolTrdlyF3HCozseg=
X-Received: by 2002:a67:e7c9:0:b0:631:2dc6:2f5c with SMTP id ada2fe7eead31-67c646469c3mr7519338137.0.1779801107495;
        Tue, 26 May 2026 06:11:47 -0700 (PDT)
X-Received: by 2002:a67:e7c9:0:b0:631:2dc6:2f5c with SMTP id ada2fe7eead31-67c646469c3mr7519273137.0.1779801106934;
        Tue, 26 May 2026 06:11:46 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:46 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:11:02 +0200
Subject: [PATCH v19 14/14] crypto: qce - Communicate the base physical
 address to the dmaengine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-14-08472fdcbf4a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1561;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=wYb8hULMzww90PvO6ikCdSc5niQ+bjPp5Yt9PZ3KUhY=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvzxsEoOkXKERoBmJ+YvCvy9mO2/ZVwzzxGW
 SkD5+eOhNGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb8wAKCRAFnS7L/zaE
 w01UD/9Qd52H3q5VW0VL6E7KzqRa+d8K+Y+jYtcVKzVY5jLZ4SyZVi3tVBOS1l4w573XttjwpQ9
 bLmG5wgI9YwBOYEKor4l2B4NV5r1RTzWWYY8kkHZbY2pR5ot3GRBk41IHrFkKqJtLCUihkZyTM7
 BRvxv0cDH07RHmyCDeInlnwULWxqvKJtnval/yE78/Rv4z7XOflmK5RLA/3E8agAXFd2qK+EBSI
 HCHt+oBWXtmabclRSm1us0rmipHIsMJu/GXiKVd+Pwl/WF5N/cfq3SxN38ttYfXKzBv3RfSMB/v
 OTK+WGPkOU5rs3mWfHtvQfbArbPnV786v5NWONXLKaohikx5KNatccGpQ5aeQ/WuaNLreW5d0CX
 d+sKayWGvRazJP5WhH7iaw2NE3Ik5X3/AbDFd019x5fs8E0IeQX8CqZvFFQgx9GwYVKh7m8++xj
 eCxrHcDnnjwKXMqmRLUqLEDmxt96FpTmSrvubr3rO8WmtR2K1Rr0+il194IajYmFaXto42h10+P
 J99xrA80QX3GCp6IAOIQa528bkuLn//rMcbinl9x/FWfJN8PNWeyJLTgC+FViy52icXv9KcIaIR
 739qnqXKU4sjQtDrC9EjPhGwzEJJIkxAReeSaJ/bI50Kiy9PgYV3iUz+9wgtb1/+x6A5iHcgS97
 3TG2vGnfRcU3DHg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=dtfrzVg4 c=1 sm=1 tr=0 ts=6a159c14 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=TFgmKHP77OfOvYwKDSoA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-GUID: qigJxi0-KdepYXDIsulwO6pStpSNJRVw
X-Proofpoint-ORIG-GUID: qigJxi0-KdepYXDIsulwO6pStpSNJRVw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfX1CCW0gT8zT8k
 bAOORjDeFoAd7uX+ToeZQ71q2RTCceUipxFwucpI0cZr8YkKpWz94SN3rR+wRcG5YrbMWuZ+zOU
 /LQLT7y9JJeAtbLDGtSfddKL0vAPsRuc1JsLb2goF8r4mrQFj4DOofUMZx6kZa8bUT8rP0Gq6nE
 vnDvE4V6J9CLB5KpAew2vSsbQ2wIh/XIPMPsO4ierh3/HVVVfsP5O07H7YDFutic7VC/nnrezac
 4DE+VcpeUlCESp8Gf/6KKsypeanbV3KeOXiBnzL0c+aqop7fv1oKd9MJaXPFBqauDcRAtuElKgl
 N9GOt7/ZDUJOGM0GOZPONgDanf8MqN7VOuCaV6+JJYyJsGB5wXBGqnyXjHI+zGwZNhSDpBP/1tj
 Uiwj2lKRO4kHe6tKRDGSPWSVQIpKfCOOoifAA5EiUwV6E6teZqEGurkfHwHeqZGlVmDht2kk2oe
 UcXDCDjf+sxrlEIqCrg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260114

In order to communicate to the BAM DMA engine which address should be
used as a scratchpad for dummy writes related to BAM pipe locking,
fill out and attach the provided metadata struct to the descriptor.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 769cc71da90076be446cbdf7ec7db27f628fa2ac..349c1d9ce9a2f4628087aa4ed5f8dda2bd9eaedb 100644
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

