Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2822D2FE591
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775141757; cv=none; b=eqNkJnwKxeyuAOIE2AitACjhI/4oY2+MUASJsHSlLPJismYSTMRrKOwcYCtbmg+bNFXFL1f6KnSXWl8KuiQia0OnOv0KTVfdBF66aubs2poEBKDjWqYNOLB6rjsR6dtTZY8ti/q9I0GqNCDt7w/k39X/RJ6AViiApXZl6gjjJKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775141757; c=relaxed/simple;
	bh=l/BZlQy4Cse/CAATeumcy5CjMrSkTNNSb0kuuSiKbFs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uJwUEK8atUWZYbTs/R/x67YH8Z/qD09uFS5jkAudndd5Ao8yg6iGNmDGcLM4umP1YjhwoH+EONvlcEo0h5gewqn/rb/hg4OrlNpMsuQk0H4uobmfb9xJyC2mJ+63/mW0QP1EPFgzavmKJNl7K/b9nrAzZVdpRrqol4w6jj4caKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e5tPmix3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NF+nKrdx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e5tPmix3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NF+nKrdx"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632BtTq93238848
	for <linux-crypto@vger.kernel.org>; Thu, 2 Apr 2026 14:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XzcFHoFYJEGJdcVPyt4hoTK+0T/yEzF5fWKBSk8BPvQ=; b=e5tPmix3FsF4gawK
	YvRx0n/e9N89XCioJsMplsZQ6zMRfS/l6bca0YXzhHws7mk/hgslE48tjc9Vn0/V
	fkacY4Q1JM8I8dkFG2usPuo/igJqp8wF0HnvZBTva5xrhG2l/4/xHrDPODW92z89
	beh5isSoGZaQHxgIHJAfNK1Vp5qj8UNb2QLxvNbaEOir4suP4I0+4FHLAMbLFJfs
	QTAu6w0+5dwD860HoAskwoh0NcgcqU9uwkjTree80E2kjwL4bco1sH9mU/zFIppo
	eaO31FQURhXPGqbedYuGDYf2gd4YeMAtOkXC9B3TvDtxyu2e5z7mohDL1aGySBu7
	Q+nh8Q==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d9r0u0r3n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 14:55:54 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5093787e2fdso37678001cf.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 07:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775141754; x=1775746554; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XzcFHoFYJEGJdcVPyt4hoTK+0T/yEzF5fWKBSk8BPvQ=;
        b=NF+nKrdxdsV0Zg+PG9orNsV9Ebo5TCg7tVOoDzw6U54WfWOm4i0jgb6Jm1ANBuFv7+
         HKTyEEZUjx903OVZkjJxTmZXFdSgg4Gd5Dtq5ASXnLw3IhxdCW0qjTocZJv8tVrt9diM
         Oewc3o1xOIXyBtaqK2QgbHNRjGO7541xzKess6sLxr0PzF3Do/S5wLmMd8mra02z9Bjv
         UbzyczeXuJ8i5ZAkBpQN4Mt9HZg79uYsznRJvVUGmeBe8xlFBdOTZwnpiwZzIZqg5J8z
         BEzzPVDKLfFET0UNbWylUqColofQdxLdNtMarL4WXtxoElsvSTNDJod9detw8fjkz8LM
         l99Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775141754; x=1775746554;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XzcFHoFYJEGJdcVPyt4hoTK+0T/yEzF5fWKBSk8BPvQ=;
        b=GIeEKwVSZ5h7Y2YOYsakPzjdeh0uWNmKkvn1J6/7toccIQlOv9+waM7GDe/CTwSpBf
         0jYk2Xm0m5rm7t9pPyUgqQvERMrihtAMSHOV33zpkxFzNtzgptwcMGp2aH/UTg8Kh2ZV
         JgUAGiaZlPKRWbV66YOJuOJ78lriUkKj8AJnd6Lt2HA8+61+iH5zT9SWGqDqrFxjwvHQ
         JDOQdBxmuA2kvIVg96EYsq+InoeLLTuNa+8rux9nyyGXy+ZvU1PnEOKNUb90Y4RacDgW
         877NK9gXnCAjxTvosg4KsVVs6xhcw5jBURCFd3Pw9GeMZuScxUbY3VsOk++a9dPOXz8O
         y6EA==
X-Forwarded-Encrypted: i=1; AJvYcCX1JAXKXl//r7BR7uB7Zz6qi4aZ7zSoBzjIEIYuPPbal2hLLMcV+UK5moIBIAYcuoa26ToSEwbgaLASn3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEq7Xav0AmyzA+NbYzbaSdwvR53BOpMElcitorcpkrD9KWA7EJ
	SZK+wFVVQGrH79RUqGFUcPWSgOtvSQr/W7zTORLvgjNP+q5gRl5dHnWMZinpVnfTIOnxrey+0im
	m0tEzpYVp+f4567u83LVEWQwoyT3Q1Kl19uX0Yv8k4kc1Pcrm3V4VL5Uz6PyfiVS9HdU=
X-Gm-Gg: ATEYQzwJK5i8mPhG6n75GfxejqENYlkEXy6NkgrwiIRtS1JoqD1jf3MOon7dmQW2F3V
	JldjUv0p8eLU6PUBymEb2tindykwHtTocdPg7PegavSkXPlwifNQOlCr92ff4WE5stu6RqAvC1g
	lHOj6yv7l9ICw9Hg3rpwbcdUeUS73J2INpXrNWXc1XCBhawDGZ/kbFcJYoXP/9AQnse3SSzzf98
	qw/Sb6hhBP6BJH1MNJjFqMBxNibTo6sZ7iFdDihN94hKdKqMfvvs9E+i0Xaxce02vu7BR8XleCx
	XOju397tsKpgue7xN/cXJRPR6kJ8xrRSNh97bO6nlUkgf/4NT+iT+tnnQTtq/iiAWELzPILzyLt
	x0RW0Bro5Xxn6Zyr9tuup6Df67WJD2fDemmFKOMZNPyz/iHNymNsj
X-Received: by 2002:a05:622a:98f:b0:509:2b02:c1bd with SMTP id d75a77b69052e-50d3bb5d0a1mr126371201cf.12.1775141754242;
        Thu, 02 Apr 2026 07:55:54 -0700 (PDT)
X-Received: by 2002:a05:622a:98f:b0:509:2b02:c1bd with SMTP id d75a77b69052e-50d3bb5d0a1mr126370611cf.12.1775141753707;
        Thu, 02 Apr 2026 07:55:53 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4ff1:3e57:22ec:dadc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f5294sm7234038f8f.35.2026.04.02.07.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 07:55:52 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 02 Apr 2026 16:55:12 +0200
Subject: [PATCH v15 01/12] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260402-qcom-qce-cmd-descr-v15-1-98b5361f7ed7@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=l/BZlQy4Cse/CAATeumcy5CjMrSkTNNSb0kuuSiKbFs=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpzoNreZvKxHX2ktLtp9xgKe1u0M7uAOAZb9Hmk
 dvbJnr8s8iJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCac6DawAKCRAFnS7L/zaE
 wxJCD/0TEJo3Um1xN48bpRtM/BxOfyO8dsvr/AGw51z0xocaNg+6z15D8WcFcdI/6sdKxsxAyJq
 EYh5mFKuxJmjvhqr8gBNubTk+O5d8F+KReUI6kP2q+aaHkG38IEfnhi/RZuw55nQ/6kmZPqm0bD
 Wg+uJew51CjkL8PgOgjfiddGdiByC1+IHixZrhTUcfwz9oDS55PQIzACUTPL29zxVAEKCX2LetQ
 3HMDOHEo1nu2idyv7ezsiajyNbHvT98/mF4zNFgL/nbsTOkonJPS49iy6760g9FzM0+Q8KflP7o
 pHy6AMy7foJPjum6TAPUr+j8dfp9BCckMQXNzt5loUnynLg8nlh7CQnqRpVnwhSmmbC/eG2A6RL
 3Qv+7c8Uii7DJLCuSjlo7CisoiB2CNTE44wAunf2uhN0rL+zQr0QN5D8gQoH1tlIHxGwL79BATO
 PYE0KEFbQ2VOHdRwcbd9Lg1tVMOes2UBusq5eFLpegpf7Azmu+utN7Bzzqh0TzSTe9sNWirApRT
 LE2toexWRSr+jRTKnnp3oD8YnZ7YNzof9du0S0U+d7IDOuJnVtCyQCNvVOg/j0cci4MgT8R83px
 tbdhAw5MzcDb7mpAzBV0eVl2nMZw8VAHA3a8HuWlesL6zB2hbiXP7p/xQpUawUEAs+c/pPDGMA0
 zkEpPtKl1I+Uy7A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDEzNCBTYWx0ZWRfX9eltF0r4a9iy
 tyyzeI6Y6kHOudGP1WA80yLcqepoe5dI8D54zdiBSWWbNvtwC75YCvQgNuga/X5mmn7yskg/IHy
 YdkHO7i2+3OLMLDqvwyvo4llAMuWdc2yIXQTC2Gj/PIjnCIGE8yQnrWgvA909Acm1mROj7hIesc
 Sf4pzeXQBHOaPpUbEIMoHf8g8soCaIZHVI9lWQ8EHkfCzeRmgjjuPGwszT+t0w7DSTvy9IR5Rim
 nS4f8eQZweahKtRqz4mrHtFtMrZaZHTEMB6gWuKyAyHGz8q63PeXLAX7zCKr5HN1OwkNLn3g3gF
 FnDF5k4DIUzX4C6n0QGp5XvyIOKGwodKChisU/diDI4683Nr5RwL4JRDV30/Rl7Z+CzYaoHOIHv
 HaWKc0Were8PLih3mTP6H/MD3RBwr72UEySuNs0IDClKtK1ZfrpJfpdLPCzAT1FhqJlQR3OXqgu
 kJDL9mkd8q5c/BbZTxQ==
X-Authority-Analysis: v=2.4 cv=D5xK6/Rj c=1 sm=1 tr=0 ts=69ce837a cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: m-y_aWAI2yn6lo5-O9ejGz12f94N6TIr
X-Proofpoint-ORIG-GUID: m-y_aWAI2yn6lo5-O9ejGz12f94N6TIr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_02,2026-04-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020134

There's no reason for the instances of this struct to be modifiable.
Constify the pointer in struct dma_async_tx_descriptor and all drivers
currently using it.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/ti/k3-udma.c        | 2 +-
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 include/linux/dmaengine.h       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index c964ebfcf3b68d86e4bbc9b62bad2212f0ce3ee9..8a2f235b669aaf084a6f7b3e6b23d06b04768608 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3408,7 +3408,7 @@ static int udma_set_metadata_len(struct dma_async_tx_descriptor *desc,
 	return 0;
 }
 
-static struct dma_descriptor_metadata_ops metadata_ops = {
+static const struct dma_descriptor_metadata_ops metadata_ops = {
 	.attach = udma_attach_metadata,
 	.get_ptr = udma_get_metadata_ptr,
 	.set_len = udma_set_metadata_len,
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index e3a18ee42aa22f4a749416307b396a6191ce4bfc..d0d55156cd42eab1ed797bd64e8272edf00e1cad 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -653,7 +653,7 @@ static void *xilinx_dma_get_metadata_ptr(struct dma_async_tx_descriptor *tx,
 	return seg->hw.app;
 }
 
-static struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
+static const struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
 	.get_ptr = xilinx_dma_get_metadata_ptr,
 };
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 99efe2b9b4ea9844ca6161208362ef18ef111d96..92566c4c100e98f48750de21249ae3b5de06c763 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -623,7 +623,7 @@ struct dma_async_tx_descriptor {
 	void *callback_param;
 	struct dmaengine_unmap_data *unmap;
 	enum dma_desc_metadata_mode desc_metadata_mode;
-	struct dma_descriptor_metadata_ops *metadata_ops;
+	const struct dma_descriptor_metadata_ops *metadata_ops;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;

-- 
2.47.3

