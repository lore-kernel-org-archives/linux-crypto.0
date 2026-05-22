Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECF243DA56
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457235; cv=none; b=WuSSzxjRXQgQ6hVV1dAeZbQNlPIRc4oGX1D301C8fshMQsSSUdOcn3vat/B0Y4Q1MggJHLuYUcoaEsVP/94pinK0hnXTj7+OkTx5IqD3Mkv9r6bKKVB6iSCyML4HdTVy9QZUlblOoujMta0sFrA9+A+tcFhFIauZQa5CNsXKbsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457235; c=relaxed/simple;
	bh=HhoEcDWExL2Ap0vs1A4rGhTAiEUByXGzsAANKLnC7Qs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kb1a49DbnxhH1YzKbzjRJ6w7NionKt/uZg0fxn7U/FRBqh7SDjRmDNrmRQkGodYVfCFAbgC52nmPcTpRIDCZx7iMgnW1oAmmtOevS7S49+5v49ebba5zlSUWhp93KnO4buCQaieKpWZaqxKniCOdNtmtLCpOsyI/EkqdT0Po7b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LEDael/o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LPeUO4kL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LEDael/o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LPeUO4kL"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MC3xPs1959419
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qArNrMH5KTqvCZasC6lyOsOGhEUcokzkTX+X16pKOIM=; b=LEDael/ogt2NK5bY
	i755JfBzIv7UC3I9pvSefqiGTSYxNnt8jD+GcSpAKMh0TM7LhUkeXzQ4TQ4pUZO/
	3ujDF9SkMosGyQIBz2/HOIgJ0CtVwx5XeRQs/HjqXgozPDbeZcSBBI4pwunT7T6/
	nJz+c2MJq2BhoqE5boqvWC3avJiNpef7uRF8wxKumc+B9Bri42wj5Qv20ABDVm5l
	YDyELfxjREqgqNvjRawenuOmpkxGErwUVw0tVO6KpCYCIHHPBOP1PWNzEmXXfTq8
	E3g4gGOl5PfP7MfnppJAeDWjNGwpOxS2/8ejRvfeOER04L69KD+l/O15XUXbFueE
	4zxROQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eahxesqcu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:32 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50edf01172bso67230581cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457231; x=1780062031; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qArNrMH5KTqvCZasC6lyOsOGhEUcokzkTX+X16pKOIM=;
        b=LPeUO4kL5R1UQPZ8K8m/ote0lV/cuo7qnRl+GLJVAZJDJJqCkG1e8JAV4iMcogvClt
         24dqpIUwWWxlvoTdMwKALOGyN1a/YoqMtQ0kj6/y4/n7xyKrva6DnXrg7Wg29ofLHnHx
         qYJrf98CrvgMogU1wlSgWY84wd6kGMtfaFpQZUnm9b2GvTwzXU7BByckQCQ+CuA9QRF0
         zj+5mviV5X0AkW72OWA07NxtHDjJVJ5JWNThVYikEVNC7XH2pwaojZJzjVYviFoxH5LY
         G02QPfWsVxNScUCXoPW8PUFxh0/fpdjaaG8/+E7IlFnCRZ5NQAwuta27jI9Lfk7uFLfC
         x0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457231; x=1780062031;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qArNrMH5KTqvCZasC6lyOsOGhEUcokzkTX+X16pKOIM=;
        b=XDCQpwAgvbL5kDv2jJFCmAEoyw2W8Cy3xV6wyIgNLFF9SNfm8FieV2++U/DQIKOAdU
         +srISPS8Y7nReUYYRHoe/hJzkSzYziQgqLdxZkBxI42vcoRVoAFlCvrzsjxWcK6G18y+
         ILcOh4RAQ96tbUc9ramevJ/DV40pezK9RfK83I8AzhkENDBU8D3h2+Wtc3LmxbbXY6nN
         TI1cQLGj/7toAla5T8TLvsGRVHaTxgBduJ1Hj3jUDfPAPMJSeD/qQCVwVc5pNfetmKL/
         5Zn6fpHHLx4gPeycpD9BZ4zWwMPFbMAvia3o4y6edlI9BeXCIzBJY7UFMNNyi3qjFbyf
         +5oA==
X-Forwarded-Encrypted: i=1; AFNElJ9GZpeEXuxC6asLJegMoiUpnydEEvs3mHi2nWX5ieoTh+VVLDgyp83T4yXQkdko0jVbti7mTnISfh/0iWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfD80xAdFDopWQgZxZsdLAv2FdhHmdytjiktlzcJG2bchdkJaQ
	yucjHLS3rUCGrp36Ls62IMmHnk2cDTSCxjKJYRQJcztv0EKIkTys6tv31hKpUI6TR4OmHWsiqqy
	t+gESHxgf4+Cf7Tfk59d3GevR2fW6gTWL15QRm9Y4i3WL8zz1cJXkRt+y7VqAuw06B/0ctI/3jB
	o=
X-Gm-Gg: Acq92OHn3A7TClnlLkUw5+9EWHQYyFjsMKSXtChkhmcZEyfFXHybzptjRrsfKGJVuLU
	uVn5r6eMn8pK1KTl2LyKOskM00cbQIlFCOaVw9Ed5aDEr8dgzz4UgDmsdTe6H+vLsIG7QDkvhfv
	ICvKrEARj0CBCROChVVu20vbTbw3YiFYvXHlM3Oa6sBdI9TevF0Hx5niBc38oeflydjgfjVA9XU
	PTcYA33OqJfu/opnZXaQFxGSQ4DqLrhGr0I6V1ojkiC+yfbEWUnEujGUnFvHIGkHejShgyAnQjt
	YLCOXot1N9k1rax6CrUl2EbnlHPQ2lGvwM6t/MPYSFp2gP1ISoOsZ9L/qnLw4Fpw7aLRVsH+hfN
	dTz5F13sJv8VT1ZTiV+5Y5IunU+gn/KWWtmo/skpDNnLBMHnR+w==
X-Received: by 2002:a05:622a:134d:b0:50d:8350:9a15 with SMTP id d75a77b69052e-516d41a06c6mr53499791cf.0.1779457231057;
        Fri, 22 May 2026 06:40:31 -0700 (PDT)
X-Received: by 2002:a05:622a:134d:b0:50d:8350:9a15 with SMTP id d75a77b69052e-516d41a06c6mr53499101cf.0.1779457230342;
        Fri, 22 May 2026 06:40:30 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:29 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:39:59 +0200
Subject: [PATCH v18 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-6-99103926bafc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9548;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=HhoEcDWExL2Ap0vs1A4rGhTAiEUByXGzsAANKLnC7Qs=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy4qFoUlg/XIQWAFrfjt19rwHpYv2M+FeMMB
 +WyNZodHTWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBcuAAKCRAFnS7L/zaE
 w4baD/401bs1vEaN5setpJ7gA0m1M07tUgQz5VObJDQJkGFsZ7vsZ03/kgAvRh7sv8Cb+BwY0I2
 pmwkbtKZPilM3DLfkccr7HI0EW/UuSpqyVsV2GugGpW22i3JDpVP8OO1VdMNuf0kr4UYhfn7z1Y
 KJHrwVQoJ0h/him0v7R2Q1mdB3GguwiHu84JB1zE7qFJqmfkrrnu4FoSLTdrKhzfXEqPKgC+DmY
 BQNk0eLuJVevixZRGRuQmMWqyph0cPGYpTeSttDWQIpHL3rEWu5yjjwtaOMLalsO9gAaRgedmKb
 WxIyhrZVeIbNBFZuCEVaDUdh4fP9E9PhA2rc1qWhb0NkkQ7p1gkOEDzq/AOee0P4560ElEg0iAh
 /lehPIdyfI300CPwtyfjTD/V+fc+RRWl8KORiAf1pYDzYPrXFpe8E6zOJSWahknVob1mTiU4T/y
 ZepgUfrRI2oys6IzLxNNw03gQ65AQSjY+AJG+qKLA+/ytLFU/1OEwdHhh8H8k6M464LKKXxv9w2
 DAAyXyia8Gbtr7MTVqkZ1eqhLEtDG7aOhuVvevlvi5xU6p34C+1IKZIjZdvs9SxrvtN4dwVxN1Q
 lZaQzVqrKa+kiP71YXHMlw55JIbqyrffelovjPS9P3VOJGAr3eAtz8OtUVo3i6NW58JAvZak4Vk
 3JBaL10pFjp+gHQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfX9zpsjMpLqf9I
 gSkrZwyWhUpuAHatkkpjqXxKmFrt6IFGmIRcauYh+XpTT7RXfwYaJyMmLRDTZ7q46C01PjV/+kB
 GxI6AaT856jZNHymCrZMnyHojSyfoD9TduiocN6OyPrbQ4foh/Nu/d11f7QTFe+IgH3NplzNEn3
 +3ZZuBJm87HA3SOw2J9JKlKh2IPWEggon52JmrChhy5da5BNmqARnu63znkZuPkfVMve72Rd10Q
 oq9yB1sJk1SQXHPo82T0XOSs3lLsNHNI3v8bzUKrhw/+z1DJuxYBNwiUH4ZkH2R5u+UxHqkpuM+
 beiz0TC7hGoObPe4Tj5dMF142Tmuc7+r6UbYJY0HS3wU/FCTlhpNTuEBnAlsAPwdlZ0Je6xvXRO
 RZp7FdJza2oWA+om1TDFTosee3N5tEXwMoNiU7nhwdDdLKZVMgPAkvEf19WjjZpuqCSPUg4VhKB
 aJ4WUa3bNJG3vWm5dEA==
X-Proofpoint-GUID: LHHktN1tssG0zbC5pKi_b67Yw4DAd4Eg
X-Proofpoint-ORIG-GUID: LHHktN1tssG0zbC5pKi_b67Yw4DAd4Eg
X-Authority-Analysis: v=2.4 cv=ar2CzyZV c=1 sm=1 tr=0 ts=6a105cd0 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=j-cXwOq41x9PnjJ4jooA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220136

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
 drivers/dma/qcom/bam_dma.c       | 155 ++++++++++++++++++++++++++++++++++++++-
 include/linux/dma/qcom_bam_dma.h |  14 ++++
 2 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 04fe1d546be73f074c66c4a5712ad65717e10929..40b5d5c24067af562e9776416e126128e29a368f 100644
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
@@ -72,6 +76,10 @@ struct bam_async_desc {
 
 	struct bam_desc_hw *curr_desc;
 
+	/* BAM locking infrastructure */
+	struct scatterlist lock_sg;
+	struct bam_cmd_element lock_ce;
+
 	/* list node for the desc in the bam_chan list of descriptors */
 	struct list_head desc_node;
 	enum dma_transfer_direction dir;
@@ -391,6 +399,10 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* BAM locking infrastructure */
+	phys_addr_t scratchpad_addr;
+	enum dma_transfer_direction direction;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -652,6 +664,35 @@ static int bam_slave_config(struct dma_chan *chan,
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
+	guard(spinlock_irqsave)(&bchan->vc.lock);
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
@@ -668,6 +709,7 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 	void *context)
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
+	struct dma_async_tx_descriptor *tx_desc;
 	struct bam_device *bdev = bchan->bdev;
 	struct bam_async_desc *async_desc;
 	struct scatterlist *sg;
@@ -723,7 +765,12 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
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
@@ -1012,13 +1059,105 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	bchan->reconfigure = 0;
 }
 
+static struct bam_async_desc *
+bam_make_lock_desc(struct bam_chan *bchan, unsigned long flag)
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
+	async_desc = kzalloc_flex(*async_desc, desc, 1, GFP_NOWAIT);
+	if (!async_desc) {
+		dev_err(bchan->bdev->dev, "failed to allocate the BAM lock descriptor\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sg_init_table(&async_desc->lock_sg, 1);
+
+	async_desc->num_desc = 1;
+	async_desc->curr_desc = async_desc->desc;
+	async_desc->dir = DMA_MEM_TO_DEV;
+
+	desc = async_desc->desc;
+
+	bam_prep_ce_le32(&async_desc->lock_ce, bchan->scratchpad_addr, BAM_WRITE_COMMAND, 0);
+	sg_set_buf(&async_desc->lock_sg, &async_desc->lock_ce, sizeof(async_desc->lock_ce));
+
+	mapped = dma_map_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
+	if (!mapped) {
+		kfree(async_desc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
+	desc->addr = sg_dma_address(&async_desc->lock_sg);
+	desc->size = cpu_to_le16(sizeof(struct bam_cmd_element));
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
+		dma_unmap_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
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
+	unsigned long flag;
+
+	lockdep_assert_held(&bchan->vc.lock);
+
+	if (!bdata->pipe_lock_supported || !bchan->scratchpad_addr ||
+	    bchan->direction != DMA_MEM_TO_DEV)
+		return 0;
+
+	flag = lock ? DESC_FLAG_LOCK : DESC_FLAG_UNLOCK;
+
+	lock_desc = bam_make_lock_desc(bchan, flag);
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
@@ -1030,6 +1169,9 @@ static void bam_start_dma(struct bam_chan *bchan)
 
 	lockdep_assert_held(&bchan->vc.lock);
 
+	bam_setup_pipe_lock(bchan);
+
+	vd = vchan_next_desc(&bchan->vc);
 	if (!vd)
 		return;
 
@@ -1157,8 +1299,12 @@ static void bam_issue_pending(struct dma_chan *chan)
  */
 static void bam_dma_free_desc(struct virt_dma_desc *vd)
 {
-	struct bam_async_desc *async_desc = container_of(vd,
-			struct bam_async_desc, vd);
+	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
+	struct bam_desc_hw *desc = async_desc->desc;
+	struct dma_chan *chan = vd->tx.chan;
+
+	if (le16_to_cpu(desc->flags) & (DESC_FLAG_LOCK | DESC_FLAG_UNLOCK))
+		dma_unmap_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
 
 	kfree(async_desc);
 }
@@ -1349,6 +1495,7 @@ static int bam_dma_probe(struct platform_device *pdev)
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

