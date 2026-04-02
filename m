Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1663EF0C9
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775141768; cv=none; b=dL+VO5b63MofOJEUI/XB4xNA3qgRGh2NhYlZf3QULIGqo5KV5ZRgxVsOOJO5uh2JV0Nyboimt5dqJswdl5FVwsWgavsNmw6y3ehBzjhLmSetDrcSNZ3oD2Z4iuPgmamdazNKs4DrQiaa7xjqIIZzf156iCLOV2NV1y+3rWnlPjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775141768; c=relaxed/simple;
	bh=wKwZxxjy27vlLx6KSC4wLUCtRQfRSr7Vcr0aJm2HW0c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cOP0TO8LNuAPGgQifm3tCODsnhi+nc8YQwlE/U0jP6kZjcHXuiISUFHN/zMhDx+Sy3R28IRMb0buu+bjlhFCLdjrqM89JhC0qhmCQ8IzTtdOAiYCVWzdzJEvF9Zhh8bGgBOAuoO6KlMyIhvU8QLpcesWVi9VPyZ0i5d8pA4jEBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FWzRf7J0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eVZUrqun; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FWzRf7J0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eVZUrqun"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632CfC2i3958492
	for <linux-crypto@vger.kernel.org>; Thu, 2 Apr 2026 14:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	a1m6afkSeaYLY+7Ncg1+riv3goTESL0u8rADY35Zlfc=; b=FWzRf7J0c9GGJe90
	70DtTyoUU1cfoUAc30LX2mQ417Hjui1au+rOSTEgECElK9ipk3ErdQMixEBXLJLF
	pxXgzPFWhDpK4OWrt2VvTG8HFvOEbPJgIGgjgC66+L20Se+J6f+amlCMcPscnYVF
	4gGwrbhLL/oJxdOqUXDJjUMEmdmJ+woiOvYscNaTeuIyYSwye45gPF4iCnju1cSp
	6lbJOV1MjhOSQWD+lAO+dkgAHi6JuGeNxXWPjgZKiD0anml/nQ5Z4mLgBltTdZOp
	koMOv/STBmY2naqVujhQtr5wPcw3QxzCl7stxLVdcLBrJhRI5QHkLsPeoM1nAyO+
	jt5sHA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d9aw5ks5g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 14:56:02 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50b323c43fdso20200031cf.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 07:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775141762; x=1775746562; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1m6afkSeaYLY+7Ncg1+riv3goTESL0u8rADY35Zlfc=;
        b=eVZUrqunF+OcbsOZX8gmeLuMSkRsbsQRL4xYbR/RpNjg9TmfcMIdCa3UH5gSxfSH0k
         BdjMZ+qExmaofGlUR8a+VJhK2L8xin6AZ13N0ts7v2hU/y8Teh/kb9Aw+0hiNyuUsGV5
         SR2gIQoKLYZCSXgBifyl4UW56wJlaFk2oqkL5cPTKOArCX/9/LdmlV460S3hcXBHoMvB
         qWxaGOpJyK3jKEAcpdlHo3ylD+0dyt1qpKFnzyKzIULcGQseyhdLRSxSN2wgICRtrA2g
         QwGJlPPaSHH2K1Vpmq/USjYP7AJPGoOb/lojw8600urynBOAj9BscvMSOfSOPnmcVLUZ
         KGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775141762; x=1775746562;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a1m6afkSeaYLY+7Ncg1+riv3goTESL0u8rADY35Zlfc=;
        b=TxITsiGCqPvF7S3n5iD3403egVogSvZFoUTMDf3lqJJbwxtYSOVvV1CnzjZzOQgkiD
         ymXmMOw39WGDa2j4n/xytMpLlRK0lrnM+VVt0kemScU8IdPz4Hy5BGgEgPeSff2mweGv
         Yhr5jLq99V/d5GegSzKJlzPD7CZVGP4TUGPCpxnHRDk+4Pq5odJDMBFlVkbKLEyikANo
         zsNxNB9FVb/PDtcq4GpaMTjijpAvfXi9x/tpbwbM1wUHyM0oZHfuPE23I3eZBZGk0BMW
         yWK9VhMcOzH5gbEpykhSI0yT84e3UWJHvuxGjkRH9QUVtUPHD9FifRhBZbHCMnt+ox1H
         mh3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVk0U9nR4xoLmDKDyq2US7MDjQ9uZJJpuyS+k9wZh0011Jd/+faNLrttk4egYuXGcLdk4nI3e7tGUSgeMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLgRgWk+x7/IzoSR5U+K1VgSAgqzvj4myPVlvN8vxKnfU4DPPb
	J4InCK89KBF94tzKb+GBE7pSLrYwvdVFduoOa3P49jbkVFP+PQeYT41UMr75wyrVHbccn0ThAGU
	fYe0rMrVDyatoCZr619iaqS8LiNcPdgWEyinVUEX0hUibejijHkPFvdXR6UzPAvR70Y0=
X-Gm-Gg: ATEYQzz9YbOwweEbONxdWb0YV62LjFLXnZlDgPKkTLuMWdQWSRVurGaIlBk9v/fRmYK
	BCz8OSwu/JfC0ZoOELRrrSsbKRuMrvLc4KmUaab5lb81iLiZXS0o+PYZmHznGc4lh+YGQbyV+Zz
	qNFRbFKNkl0BNFajRUpM01n4ldrKG40v3+20LC8jQyfhvxOV4JmXbyq0HHVJVMqy5VjsLpJi3Xh
	gAQOjuL4tIoy5RxkW7U7vWj7aZhICD+Uu9IeTlznQ2j7zd0dXrMp7q0vp2uJQC/ZuHTN4a+qQ4R
	ElPZYS/g5f2H8GlHsTchez4r3bDJSIZ0auK0JuE/FngOMW/t/UE48jbCIRMFuLzYjyLsR9JaBNE
	jpAujba+ivKsMxH/L8+fp9GusnGhyiWPxnUUSNH+sKyF1QS/d1yt8
X-Received: by 2002:a05:622a:4a10:b0:50b:4435:5df0 with SMTP id d75a77b69052e-50d4bbce536mr49635421cf.58.1775141761722;
        Thu, 02 Apr 2026 07:56:01 -0700 (PDT)
X-Received: by 2002:a05:622a:4a10:b0:50b:4435:5df0 with SMTP id d75a77b69052e-50d4bbce536mr49634831cf.58.1775141761173;
        Thu, 02 Apr 2026 07:56:01 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4ff1:3e57:22ec:dadc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f5294sm7234038f8f.35.2026.04.02.07.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 07:56:00 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 02 Apr 2026 16:55:16 +0200
Subject: [PATCH v15 05/12] dmaengine: qcom: bam_dma: add support for BAM
 locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260402-qcom-qce-cmd-descr-v15-5-98b5361f7ed7@oss.qualcomm.com>
References: <20260402-qcom-qce-cmd-descr-v15-0-98b5361f7ed7@oss.qualcomm.com>
In-Reply-To: <20260402-qcom-qce-cmd-descr-v15-0-98b5361f7ed7@oss.qualcomm.com>
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
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9596;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=wKwZxxjy27vlLx6KSC4wLUCtRQfRSr7Vcr0aJm2HW0c=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpzoNwpVyAN5iwSh/1dbiN6sr+7EZfRmB/v7Ybd
 aJIJHuRjoiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCac6DcAAKCRAFnS7L/zaE
 w5n/D/9IrWGPxnshCnee3DoeCuaE7nTlDLEbuQVhavvTHKGBQk0lBnaQTntkZsn2Pa4DgWD9o6u
 PoSq4ucXVnPKDugT7cT+xrs1aT/KtWU+AW+fvvWxhyPlfaM12NpOLeFKQfBAFhygrHBhHHckj/h
 gol0/O16tNUkm7BCq857hDDJuSnT4VnbWOci4iYxFKrzqT8FQkNYAOCJVTBYoqhztEPDjBabcwS
 hg6rLH3EtSOm4RcY6R19gcHC+yn9IcQ/8Q1vTzZl4evnSMNrcCiEiAHDoHqSBUK5wtm9hTJTqnc
 sU1HMdj6da53H3tKQqEEAnENoiYnk47FgJorlLGNUXCWdOwCoqoU9GXtd5VwqU49EDxG2+hdH6b
 rIeKU3JeiqWYChNOSXy7/7uD6p8A/0NJzSkZ7M1l7MdfGRbr8F2pQAeDVNrv2AoZJRo25aVBvoC
 0ftACF9y3GbIxXuG/Jfop6cOPu4ykp/qOQhjsg2sxeHYfFpDJHT1wzVX4oK8IJDKDumf0ybqYPZ
 PQw1QJjwQ2lTCkuMMzShwwJn1mcSgOyQHlUXzdwvnAyH3OxvCSE299epFC4JLNOFD9Lg4H/TAmF
 DvQKG7a/3FZOEJa8jbd/mCLpC9+R2Bwpi7edhEIo3qLHFCTGelvUI51L9CQ2mtvbQwCv4e/MbVw
 2KZpvVphZy3di1g==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Q9jfIo2a c=1 sm=1 tr=0 ts=69ce8382 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=qJbEDo8Lr3yLsC1F8HwA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: OdWAXL3-JitXprQNQUybmgolYgB24CTH
X-Proofpoint-ORIG-GUID: OdWAXL3-JitXprQNQUybmgolYgB24CTH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDEzNCBTYWx0ZWRfX54vX3bpewwLa
 p/JbOU1OASdZ6XQfyTFnjDxCO4nAXj8YQ1SAZHzEmpSiusuie98dHCJ6KEqrUiYLEK6LTAMtBJW
 SwkiqHZ6vKnuxSVU4yvxRilnwYRM68U8PuXLU2SEfu/6btWuSi4TY1GsOtlfjZNzakJFQz6f+yM
 5kpBdv++ogEH60nA2L6oMGgoCkYXCTnQhqohGyFNcYDLXlCwATElPm/ru7LQvxWgCMMU8HlWnVG
 DYz+FLRN2IbmCM42MHMOH6dpasASl0zN3uzw48K9KvS6c2MKj9sXtRmCtfITCOHAJQGYmcIQ8hR
 V6C2i6u0PR3h8/SNuoI8Bx72gCZ8ulRV3XV2o7cxhacVY8a9Ga+0zmlARkweIWTwIJndZL14Icf
 fel3qoimfoLEngAx0WfwGncEHr6BGjO8gJtcQOgpLLdBKhMVsNBK7e5migM/2VB+4qhGNOKfwXt
 W+Yu/g8bBHqiR0O7pAg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_02,2026-04-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604020134

Add support for BAM pipe locking. To that end: when starting DMA on an RX
channel - prepend the existing queue of issued descriptors with an
additional "dummy" command descriptor with the LOCK bit set. Once the
transaction is done (no more issued descriptors), issue one more dummy
descriptor with the UNLOCK bit.

We *must* wait until the transaction is signalled as done because we
must not perform any writes into config registers while the engine is
busy.

The dummy writes must be issued into a scratchpad register of the client
so provide a mechanism to communicate the right address via descriptor
metadata.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c       | 167 ++++++++++++++++++++++++++++++++++++++-
 include/linux/dma/qcom_bam_dma.h |  14 ++++
 2 files changed, 177 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 83491e7c2f17d8c9d12a1a055baea7e3a0a75a53..c3c1d39b6e7cce16cb4eaf450220c9e9a4dffe3f 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -28,11 +28,13 @@
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma/qcom_bam_dma.h>
 #include <linux/dmaengine.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/lockdep.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_dma.h>
@@ -60,6 +62,8 @@ struct bam_desc_hw {
 #define DESC_FLAG_EOB BIT(13)
 #define DESC_FLAG_NWD BIT(12)
 #define DESC_FLAG_CMD BIT(11)
+#define DESC_FLAG_LOCK BIT(10)
+#define DESC_FLAG_UNLOCK BIT(9)
 
 struct bam_async_desc {
 	struct virt_dma_desc vd;
@@ -391,6 +395,14 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* BAM locking infrastructure */
+	phys_addr_t scratchpad_addr;
+	enum dma_transfer_direction direction;
+	struct scatterlist lock_sg;
+	struct scatterlist unlock_sg;
+	struct bam_cmd_element lock_ce;
+	struct bam_cmd_element unlock_ce;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -652,6 +664,33 @@ static int bam_slave_config(struct dma_chan *chan,
 	return 0;
 }
 
+static int bam_metadata_attach(struct dma_async_tx_descriptor *desc, void *data, size_t len)
+{
+	struct bam_chan *bchan = to_bam_chan(desc->chan);
+	const struct bam_device_data *bdata = bchan->bdev->dev_data;
+	struct bam_desc_metadata *metadata = data;
+
+	if (!data)
+		return -EINVAL;
+
+	if (!bdata->pipe_lock_supported)
+		/*
+		 * The client wants to use locking but this BAM version doesn't
+		 * support it. Don't return an error here as this will stop the
+		 * client from using DMA at all for no reason.
+		 */
+		return 0;
+
+	bchan->scratchpad_addr = metadata->scratchpad_addr;
+	bchan->direction = metadata->direction;
+
+	return 0;
+}
+
+static const struct dma_descriptor_metadata_ops bam_metadata_ops = {
+	.attach = bam_metadata_attach,
+};
+
 /**
  * bam_prep_slave_sg - Prep slave sg transaction
  *
@@ -668,6 +707,7 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 	void *context)
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
+	struct dma_async_tx_descriptor *tx_desc;
 	struct bam_device *bdev = bchan->bdev;
 	struct bam_async_desc *async_desc;
 	struct scatterlist *sg;
@@ -723,7 +763,12 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 		} while (remainder > 0);
 	}
 
-	return vchan_tx_prep(&bchan->vc, &async_desc->vd, flags);
+	tx_desc = vchan_tx_prep(&bchan->vc, &async_desc->vd, flags);
+	if (!tx_desc)
+		return NULL;
+
+	tx_desc->metadata_ops = &bam_metadata_ops;
+	return tx_desc;
 }
 
 /**
@@ -1012,13 +1057,116 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	bchan->reconfigure = 0;
 }
 
+static struct bam_async_desc *
+bam_make_lock_desc(struct bam_chan *bchan, struct scatterlist *sg,
+		   struct bam_cmd_element *ce, unsigned long flag)
+{
+	struct dma_chan *chan = &bchan->vc.chan;
+	struct bam_async_desc *async_desc;
+	struct bam_desc_hw *desc;
+	struct virt_dma_desc *vd;
+	struct virt_dma_chan *vc;
+	unsigned int mapped;
+	dma_cookie_t cookie;
+	int ret;
+
+	sg_init_table(sg, 1);
+
+	async_desc = kzalloc_flex(*async_desc, desc, 1, GFP_NOWAIT);
+	if (!async_desc) {
+		dev_err(bchan->bdev->dev, "failed to allocate the BAM lock descriptor\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	async_desc->num_desc = 1;
+	async_desc->curr_desc = async_desc->desc;
+	async_desc->dir = DMA_MEM_TO_DEV;
+
+	desc = async_desc->desc;
+
+	bam_prep_ce_le32(ce, bchan->scratchpad_addr, BAM_WRITE_COMMAND, 0);
+	sg_set_buf(sg, ce, sizeof(*ce));
+
+	mapped = dma_map_sg_attrs(chan->slave, sg, 1, DMA_TO_DEVICE, DMA_PREP_CMD);
+	if (!mapped) {
+		kfree(async_desc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
+	desc->addr = sg_dma_address(sg);
+	desc->size = sizeof(struct bam_cmd_element);
+
+	vc = &bchan->vc;
+	vd = &async_desc->vd;
+
+	dma_async_tx_descriptor_init(&vd->tx, &vc->chan);
+	vd->tx.flags = DMA_PREP_CMD;
+	vd->tx.desc_free = vchan_tx_desc_free;
+	vd->tx_result.result = DMA_TRANS_NOERROR;
+	vd->tx_result.residue = 0;
+
+	cookie = dma_cookie_assign(&vd->tx);
+	ret = dma_submit_error(cookie);
+	if (ret) {
+		dma_unmap_sg(chan->slave, sg, 1, DMA_TO_DEVICE);
+		kfree(async_desc);
+		return ERR_PTR(ret);
+	}
+
+	return async_desc;
+}
+
+static int bam_do_setup_pipe_lock(struct bam_chan *bchan, bool lock)
+{
+	struct bam_device *bdev = bchan->bdev;
+	const struct bam_device_data *bdata = bdev->dev_data;
+	struct bam_async_desc *lock_desc;
+	struct bam_cmd_element *ce;
+	struct scatterlist *sgl;
+	unsigned long flag;
+
+	lockdep_assert_held(&bchan->vc.lock);
+
+	if (!bdata->pipe_lock_supported || !bchan->scratchpad_addr ||
+	    bchan->direction != DMA_MEM_TO_DEV)
+		return 0;
+
+	if (lock) {
+		sgl = &bchan->lock_sg;
+		ce = &bchan->lock_ce;
+		flag = DESC_FLAG_LOCK;
+	} else {
+		sgl = &bchan->unlock_sg;
+		ce = &bchan->unlock_ce;
+		flag = DESC_FLAG_UNLOCK;
+	}
+
+	lock_desc = bam_make_lock_desc(bchan, sgl, ce, flag);
+	if (IS_ERR(lock_desc))
+		return PTR_ERR(lock_desc);
+
+	if (lock)
+		list_add(&lock_desc->vd.node, &bchan->vc.desc_issued);
+	else
+		list_add_tail(&lock_desc->vd.node, &bchan->vc.desc_issued);
+
+	return 0;
+}
+
+static void bam_setup_pipe_lock(struct bam_chan *bchan)
+{
+	if (bam_do_setup_pipe_lock(bchan, true) || bam_do_setup_pipe_lock(bchan, false))
+		dev_err(bchan->vc.chan.slave, "Failed to setup BAM pipe lock descriptors");
+}
+
 /**
  * bam_start_dma - start next transaction
  * @bchan: bam dma channel
  */
 static void bam_start_dma(struct bam_chan *bchan)
 {
-	struct virt_dma_desc *vd = vchan_next_desc(&bchan->vc);
+	struct virt_dma_desc *vd;
 	struct bam_device *bdev = bchan->bdev;
 	struct bam_async_desc *async_desc = NULL;
 	struct bam_desc_hw *desc;
@@ -1030,6 +1178,9 @@ static void bam_start_dma(struct bam_chan *bchan)
 
 	lockdep_assert_held(&bchan->vc.lock);
 
+	bam_setup_pipe_lock(bchan);
+
+	vd = vchan_next_desc(&bchan->vc);
 	if (!vd)
 		return;
 
@@ -1157,8 +1308,15 @@ static void bam_issue_pending(struct dma_chan *chan)
  */
 static void bam_dma_free_desc(struct virt_dma_desc *vd)
 {
-	struct bam_async_desc *async_desc = container_of(vd,
-			struct bam_async_desc, vd);
+	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
+	struct bam_desc_hw *desc = async_desc->desc;
+	struct dma_chan *chan = vd->tx.chan;
+	struct bam_chan *bchan = to_bam_chan(chan);
+
+	if (le16_to_cpu(desc->flags) & DESC_FLAG_LOCK)
+		dma_unmap_sg(chan->slave, &bchan->lock_sg, 1, DMA_TO_DEVICE);
+	else if (le16_to_cpu(desc->flags) & DESC_FLAG_UNLOCK)
+		dma_unmap_sg(chan->slave, &bchan->unlock_sg, 1, DMA_TO_DEVICE);
 
 	kfree(async_desc);
 }
@@ -1350,6 +1508,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	bdev->common.device_terminate_all = bam_dma_terminate_all;
 	bdev->common.device_issue_pending = bam_issue_pending;
 	bdev->common.device_tx_status = bam_tx_status;
+	bdev->common.desc_metadata_modes = DESC_METADATA_CLIENT;
 	bdev->common.dev = bdev->dev;
 
 	ret = dma_async_device_register(&bdev->common);
diff --git a/include/linux/dma/qcom_bam_dma.h b/include/linux/dma/qcom_bam_dma.h
index 68fc0e643b1b97fe4520d5878daa322b81f4f559..a2594264b0f58c4b2b1c85e243cad0d5669c26dc 100644
--- a/include/linux/dma/qcom_bam_dma.h
+++ b/include/linux/dma/qcom_bam_dma.h
@@ -6,6 +6,8 @@
 #ifndef _QCOM_BAM_DMA_H
 #define _QCOM_BAM_DMA_H
 
+#include <linux/dmaengine.h>
+
 #include <asm/byteorder.h>
 
 /*
@@ -34,6 +36,18 @@ enum bam_command_type {
 	BAM_READ_COMMAND,
 };
 
+/**
+ * struct bam_desc_metadata - DMA descriptor metadata specific to the BAM driver.
+ *
+ * @scratchpad_addr: Physical address to use for dummy write operations when
+ *                   queuing command descriptors with LOCK/UNLOCK bits set.
+ * @direction: Transfer direction of this channel.
+ */
+struct bam_desc_metadata {
+	phys_addr_t scratchpad_addr;
+	enum dma_transfer_direction direction;
+};
+
 /*
  * prep_bam_ce_le32 - Wrapper function to prepare a single BAM command
  * element with the data already in le32 format.

-- 
2.47.3

