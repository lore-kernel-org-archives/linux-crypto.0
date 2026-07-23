Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277D84766AA
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826608; cv=none; b=D92/yDzM59cKCCqKsAweOUTYWuIZvx8xMYd+iB6/ZMSQ5nJltA1E7ahtYCKREDhgF1pDZMcykU5F71PlR9MQ7a1YjqJ+1Rfn+VxITOH/WVeLdOd6MnSkn042XaWOWT8QI3nH4abTzVhDLSl3wzNKb2XLDS78f4WkbNDA60qSVJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826608; c=relaxed/simple;
	bh=PfWCetNllimOpOUBKWykny5pkd6KZBQfqTfxQ67v6/g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MfO0JX0/b8qJdkiOwEb+URX/JdU1wz7GRqqgRGRVORPrwaVPLbzqTY9YSgbP57ozsSGfxiXj+EIGUmOvkrY4LFV7lMDjjP+Pv73thAuqGY4OUOWT2bPL7fl2ACNSGdMSZOAUh9coiOIhIzsYt1eiCuyjVZr3USZTK4Ck2YWsbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bo/CTYdd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A1O9olbo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bo/CTYdd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A1O9olbo"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NF9N5X162109
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ejvRUKxPi/Wn/dhDhMVWcTvyATRa/Q77QtBmpujdjeI=; b=bo/CTYddYan2ADEk
	7R6sCDJb4sICpPe75EE0cr7PPOKHOggrObyM3KGTrjDB0NKK7eD5UmzOFJE4tIjm
	7Ef44Gbq0mqmgHUN8gC7qAUlO0JJHbnHnsf8fVK5O/0hjCmg7NIIYBkgk+tXVqHV
	6fUJRcqZzYW/P7G6JOSW+MlqsrD7//fN4pZxm6q713ySSE2Sxd6qGfctQMY1rV9b
	OUwNm6Y3E5mTROMlJ3iyHaVb8Jo4oaTnAPbNXqVfMg02ZZjseT5Y+FmRpz3UIqsy
	rbiqQ6uWcY1fyUh3Ui1zHCG/6/6B/QEcA+JZrOsPHmd7OO0SGUcW27YVbdxlhAVy
	ln1oyg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fknbmgnbb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:52 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c110a3b6aso13178211cf.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826592; x=1785431392; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ejvRUKxPi/Wn/dhDhMVWcTvyATRa/Q77QtBmpujdjeI=;
        b=A1O9olboyUfmKi5HIViy/ty5Av4nW6IM1xNDYP0J2Q4KRKA71dI/NTFgu2tYvMOkKm
         dlqmskamysy+IGP4RqtC4nMPga2D6qyHv2M/rwtuFL+dkYdXNLM4WKDF+JFn8fRlJVC2
         id6R7XdFnf4bs/Bsx/1Igwt3JexHr88gf/Uq4yuJ/MHHaOZrKxm4CehkoglEon3C1jYe
         QQ+bNCs/3ZVA+CTtZeZudImY1z1YHK3OTvOywGI9dcNXSp9lzLG8XSptHSy5VoKO/syY
         C21SEQENx6GG+fNaX+MnWOvWDo1sKc1JIUFwXzfN/b/RZ3wJQ4s1kcmLu1rPd/l/C7vh
         cAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826592; x=1785431392;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ejvRUKxPi/Wn/dhDhMVWcTvyATRa/Q77QtBmpujdjeI=;
        b=dS/qPBM3zf9Dy4LaX/ikSWXFbhDdVh7ynB9cpisjmsyDnsBquzUsUsqOhEqRg5hpgB
         5EI/bkKQLKykz4yBL+3EXEBD2HbMTocxOH6iV14Q7U7N2Kx3ouchQu8Z+LbISVWpMSUF
         2PkVWtfIkTV//Epy7yB1HmEsd73L6K3t8b3JsHkDJlGttjpxdBvTGeaw5RTq3POfKWDW
         i3MLtIBT5xE35ktwAo9D3csF2o2EIzLtifw4hv6YtIG3HTq4sW5K9H8ytItNLGQyZRwL
         CO0HHmPhRCUqucpuQh7JdKmglj9+GIdl4CmsnZE1OMnR9e6D6/weyLRz72Lfoqe9MWZ6
         L8qg==
X-Forwarded-Encrypted: i=1; AHgh+RojTHxpplsVg7QUFIllj3Gng7B9Ox6muxotLCO9tgFoqYFPowKSCgzXc31aItYXygDIhHms99YvCfUzQdk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf3FCRNM+08N7wONtbXLkD5sesDz2EhHYHVTaLJhegzG3KnTZH
	aXp5/Oj+kPwNIsApdxbdz3rldNHhF5tv737L9+7M8PJfUUwDB876xvrRL+tm1DgUi7VI6dRII+m
	zIz+ADkVlvT0RUpC/Db2vpUm8GGzg87QY9wXAez8xmsuNSBhJWz0zvHUNMvvCsINe2x8=
X-Gm-Gg: AR+sD13FBzyHyiJqZ7X2b5Voi030GGA13N6RjYTcZjjoCg4YiT3+uYEVcuQJGvhqQU8
	AGjfbeIuCBJ7Hn+uuZTX9UUj6++llUvwzkBtXkjNBFsxZIyQ2MuwwxxXRiiTSUoBv0r+sS/e4OK
	KkhydywUAQVoEu2Cjah+KM2HXW8FUnedvkek8fvfV0suGQOshMgjSnyu9T6Ph2Dyi0Kal0AUhl8
	Mxr5V/VAeJjer4V2SudTHdh+W8aBJObm6P/eJrpGw43VcqI7WnF5AeZKI4vV9LpxZ2e/+YS/3gW
	ytve9mMc3a+wxLW5UwKGhpsEgUoxZ9kJ5Plcc94gC+He8LjEbW0NYDPhEaO/Ox+2kHw0TyeAyvU
	lwTEgKhMxYZtw+6fhI9O/tRxQqhFl
X-Received: by 2002:a05:622a:997:b0:519:5680:1b5 with SMTP id d75a77b69052e-5283de4650emr40055171cf.21.1784826592166;
        Thu, 23 Jul 2026 10:09:52 -0700 (PDT)
X-Received: by 2002:a05:622a:997:b0:519:5680:1b5 with SMTP id d75a77b69052e-5283de4650emr40054461cf.21.1784826591671;
        Thu, 23 Jul 2026 10:09:51 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:09:50 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:12 +0200
Subject: [PATCH v24 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-6-4f87bb4d9938@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11494;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=PfWCetNllimOpOUBKWykny5pkd6KZBQfqTfxQ67v6/g=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrE1DwfOQgN7MQQ494QYqLhOLXnNwt+6mdBl
 YiD45w98kyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKxAAKCRAFnS7L/zaE
 w1QzD/4rQ6JNctSRIiKygQdFG5YQATE2b4dqnimtzlgoDbNEjTNLVg9MMjQgYag6o1i/t/lbW6q
 DzaZa4x4o4VnkI3PBJRnKG3irTsUYKXb7sAtgzhBPNm7q/xa6hyZoUdBBf2puECKwwWr4bBRlWh
 GAWci5oyDjFhV9MV1n6BjcihpHm1F0iQCVI2FkFJipjSuT9GQRdtXin5WLLmm3o9gXd9h+5ejWg
 Hp0T64nA85wvjtUH83YKKatAIE/BJ7vDOChypmJpZL7r9H+17/+CJ8sEKMPwMW9rSJl4o0XSP4t
 6GaprcBWX9VRST5/MmSoiW7C/MB42BNmEtzSGMbtGVII/UJUIMqDT/8o1anSGZsMOEkGhhyW6jQ
 iQlSvP+y8oQoRyU4+kyobRu4pdBz/hBwRd/guN6rL6ZqoelrO55C6hOTW0VMPJFZEcJGsGGBK1c
 d4O9Liab6VgiUzRr7uEyQRozxTwBPi6ouK3U57GD7MAiCNz00dM0FnmQcpVXCEmwtXJrXLS4Xi2
 iTDCOYozdbkgUWwTHz070hH8bmU99BuADe4ngynD7yMxigycJUr/6ttycCoLgwsFABeGzVwWF+J
 vxr+BU07mLilNxWq8au90+9P8wx5QfiH5MZZYV8MJOVHjRm9Zd+tgomdalS282olJwOyomqmWum
 sd2kcP6NONB6dXA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=e742j6p/ c=1 sm=1 tr=0 ts=6a624ae0 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=ajFzEv-yE-Ol-vb9n_4A:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: ala3yJG43LlFWzD3IV7Qyx2s3RB1pVH7
X-Proofpoint-GUID: ala3yJG43LlFWzD3IV7Qyx2s3RB1pVH7
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX8Goom3EPanup
 JrHo/8V/CGzhI7ZaJ4qIdYQZ41B5DJ3JHX/YRr/IPcnHmxZDP2YmmahsmQnzePYOk0VXFb9lQA7
 i12pxO2QXJ1NNmPsMJlmL5pntZoDdcU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX+20bQAd84tKe
 BXAY3lnwgRaLvHDo40WknYkhmxVHZ0B9AW9IPeicRkdG+bJZQELa4/J6buplDs+gjFz17Jm6kDs
 QwW3/fr6Saf0rBHJcmV1PzGm+zYkee/AaZ6b025Bn1s3xvMKEok33zg3aVjzDzl8AcKNx7oY2J/
 UbKhZZLTG+srkYcYSMc9j41A/I2b19eqY24RNlgNEs7P/21QAxkeTsk7e+VBpLQyClZZl4Ej0ei
 Yvx8gllvaUMVTWol1+fDaXlQ9P5sfTc2j9ublAq2WXGTtYF8H9npx2fAHN5LB++AUPr9YcArpki
 KQCvl2Xy9k7Ogd4cmRPRVoTxO5HEZgrrmHFvr7XHnMqMLI3svuxpQ/UwTWKEgWMcJ7ZIyGMq8X4
 HtWaW4zGDZlEsVx7yTTEDxKzAovkUd0IzMP3/5vjWHq98iIwNzDCLLHRFrlO2F92AzMRy5PT1pT
 FGlksevdNlow5qEiPLA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230167

Add support for BAM pipe locking. To that end: when starting DMA on a TX
channel (DMA_MEM_TO_DEV) - prepend the existing queue of issued
descriptors with an additional "dummy" command descriptor with the LOCK
bit set. Once the transaction is done (no more issued descriptors),
issue one more dummy descriptor with the UNLOCK bit.

We *must* wait until the transaction is signalled as done because we
must not perform any writes into config registers while the engine is
busy.

The dummy writes must be issued into a scratchpad register of the client
so provide a mechanism to communicate the right address via slave
config.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
[Stephan: came up with the solution to write lock/unlock descriptors
directly into the FIFO]
Co-developed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c       | 146 ++++++++++++++++++++++++++++++++++-----
 include/linux/dma/qcom_bam_dma.h |  13 ++++
 2 files changed, 142 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index f3e713a5259c2c7c24cfdcec094814eb1202971a..373569c36a94e149d54ef041974b11018e634669 100644
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
@@ -60,6 +62,10 @@ struct bam_desc_hw {
 #define DESC_FLAG_EOB BIT(13)
 #define DESC_FLAG_NWD BIT(12)
 #define DESC_FLAG_CMD BIT(11)
+#define DESC_FLAG_LOCK BIT(10)
+#define DESC_FLAG_UNLOCK BIT(9)
+
+#define DESC_FLAG_LOCK_MASK (DESC_FLAG_LOCK | DESC_FLAG_UNLOCK)
 
 struct bam_async_desc {
 	struct virt_dma_desc vd;
@@ -425,6 +431,12 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* BAM locking infrastructure */
+	struct bam_cmd_element *lock_ce;
+	dma_addr_t lock_ce_phys;
+	bool locking_enabled;
+	bool bam_locked;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -638,13 +650,22 @@ static void bam_free_chan(struct dma_chan *chan)
 		goto err;
 	}
 
-	scoped_guard(spinlock_irqsave, &bchan->vc.lock)
+	scoped_guard(spinlock_irqsave, &bchan->vc.lock) {
 		bam_reset_channel(bchan);
+		bchan->bam_locked = false;
+	}
 
 	dma_free_wc(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
 		    bchan->fifo_phys);
 	bchan->fifo_virt = NULL;
 
+	if (bchan->lock_ce) {
+		dma_unmap_single(bdev->dev, bchan->lock_ce_phys,
+				 sizeof(*bchan->lock_ce), DMA_TO_DEVICE);
+		kfree(bchan->lock_ce);
+		bchan->lock_ce = NULL;
+	}
+
 	/* mask irq for pipe/channel */
 	val = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
 	val &= ~BIT(bchan->id);
@@ -676,10 +697,51 @@ static void bam_free_chan(struct dma_chan *chan)
 static int bam_slave_config(struct dma_chan *chan,
 			    struct dma_slave_config *cfg)
 {
+	struct bam_config *peripheral_cfg = cfg->peripheral_config;
 	struct bam_chan *bchan = to_bam_chan(chan);
+	const struct bam_device_data *bdata = bchan->bdev->dev_data;
+
+	if (peripheral_cfg && cfg->peripheral_size != sizeof(*peripheral_cfg))
+		return -EINVAL;
 
 	guard(spinlock_irqsave)(&bchan->vc.lock);
 
+	/*
+	 * This is required to setup the pipe locking and must be done even
+	 * before the first call to bam_start_dma().
+	 */
+	if (bdata->pipe_lock_supported && peripheral_cfg) {
+		if (cfg->direction != DMA_MEM_TO_DEV)
+			return -EINVAL;
+
+		if (bchan->bam_locked)
+			return -EBUSY;
+
+		if (!bchan->lock_ce) {
+			bchan->lock_ce = kmalloc_obj(*bchan->lock_ce, GFP_ATOMIC);
+			if (!bchan->lock_ce)
+				return -ENOMEM;
+
+			bchan->lock_ce_phys = dma_map_single(bchan->bdev->dev, bchan->lock_ce,
+							     sizeof(*bchan->lock_ce),
+							     DMA_TO_DEVICE);
+			if (dma_mapping_error(bchan->bdev->dev, bchan->lock_ce_phys)) {
+				kfree(bchan->lock_ce);
+				bchan->lock_ce = NULL;
+				return -ENOMEM;
+			}
+		}
+
+		bam_prep_ce_le32(bchan->lock_ce, peripheral_cfg->lock_scratchpad_addr,
+				 BAM_WRITE_COMMAND, 0);
+		dma_sync_single_for_device(bchan->bdev->dev, bchan->lock_ce_phys,
+					   sizeof(*bchan->lock_ce), DMA_TO_DEVICE);
+		bchan->locking_enabled = true;
+	} else {
+		/* Don't touch lock_ce here, it might still be used by issued descriptors */
+		bchan->locking_enabled = false;
+	}
+
 	memcpy(&bchan->slave, cfg, sizeof(*cfg));
 	bchan->reconfigure = 1;
 
@@ -802,6 +864,7 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
 		}
 
 		vchan_get_all_descriptors(&bchan->vc, &head);
+		bchan->bam_locked = false;
 	}
 
 	vchan_dma_desc_free_list(&bchan->vc, &head);
@@ -869,7 +932,7 @@ static int bam_resume(struct dma_chan *chan)
 static u32 process_channel_irqs(struct bam_device *bdev)
 {
 	u32 i, srcs, pipe_stts, offset, avail;
-	struct bam_async_desc *async_desc, *tmp;
+	struct bam_async_desc *async_desc;
 
 	srcs = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_EE));
 
@@ -879,6 +942,8 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 
 	for (i = 0; i < bdev->num_channels; i++) {
 		struct bam_chan *bchan = &bdev->channels[i];
+		struct bam_desc_hw *fifo = PTR_ALIGN(bchan->fifo_virt,
+						sizeof(struct bam_desc_hw));
 
 		if (!(srcs & BIT(i)))
 			continue;
@@ -900,10 +965,17 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 		if (offset < bchan->head)
 			avail--;
 
-		list_for_each_entry_safe(async_desc, tmp,
-					 &bchan->desc_list, desc_node) {
-			/* Not enough data to read */
-			if (avail < async_desc->xfer_len)
+		for (;;) {
+			/* Skip over lock descriptors in the FIFO */
+			while (avail > 0 && (le16_to_cpu(fifo[bchan->head].flags) &
+					      DESC_FLAG_LOCK_MASK)) {
+				bchan->head = (bchan->head + 1) % MAX_DESCRIPTORS;
+				avail--;
+			}
+
+			async_desc = list_first_entry_or_null(&bchan->desc_list,
+							struct bam_async_desc, desc_node);
+			if (!async_desc || avail < async_desc->xfer_len)
 				break;
 
 			/* manage FIFO */
@@ -919,13 +991,12 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 			 * push back to front of desc_issued so that
 			 * it gets restarted by the work queue.
 			 */
-			if (!async_desc->num_desc) {
+			list_del(&async_desc->desc_node);
+			if (!async_desc->num_desc)
 				vchan_cookie_complete(&async_desc->vd);
-			} else {
+			else
 				list_add(&async_desc->vd.node,
 					 &bchan->vc.desc_issued);
-			}
-			list_del(&async_desc->desc_node);
 		}
 	}
 
@@ -1046,13 +1117,23 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	bchan->reconfigure = 0;
 }
 
+static void bam_fifo_write_lock(struct bam_chan *bchan, u16 flags)
+{
+	struct bam_desc_hw *fifo = PTR_ALIGN(bchan->fifo_virt, sizeof(struct bam_desc_hw));
+
+	fifo[bchan->tail].addr = cpu_to_le32(bchan->lock_ce_phys);
+	fifo[bchan->tail].size = cpu_to_le16(sizeof(struct bam_cmd_element));
+	fifo[bchan->tail].flags = cpu_to_le16(DESC_FLAG_CMD | flags);
+	bchan->tail = (bchan->tail + 1) % MAX_DESCRIPTORS;
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
@@ -1064,22 +1145,34 @@ static void bam_start_dma(struct bam_chan *bchan)
 
 	lockdep_assert_held(&bchan->vc.lock);
 
-	if (!vd)
+	vd = vchan_next_desc(&bchan->vc);
+	if (IS_BUSY(bchan) || (!vd && !bchan->bam_locked))
 		return;
 
 	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
+	if (!bchan->initialized)
+		bam_chan_init_hw(bchan, container_of(vd, struct bam_async_desc, vd)->dir);
+
+	if (bchan->locking_enabled && !bchan->bam_locked) {
+		/* Defer locking until we also have space for a data descriptor */
+		avail = CIRC_SPACE(bchan->tail, bchan->head, MAX_DESCRIPTORS + 1);
+		if (avail < 2) {
+			queue_work(system_bh_highpri_wq, &bdev->work);
+			goto out;
+		}
+
+		bam_fifo_write_lock(bchan, DESC_FLAG_LOCK);
+		bchan->bam_locked = true;
+	}
+
 	while (vd && !IS_BUSY(bchan)) {
 		list_del(&vd->node);
 
 		async_desc = container_of(vd, struct bam_async_desc, vd);
 
-		/* on first use, initialize the channel hardware */
-		if (!bchan->initialized)
-			bam_chan_init_hw(bchan, async_desc->dir);
-
 		/* apply new slave config changes, if necessary */
 		if (bchan->reconfigure)
 			bam_apply_new_config(bchan, async_desc->dir);
@@ -1135,11 +1228,24 @@ static void bam_start_dma(struct bam_chan *bchan)
 		list_add_tail(&async_desc->desc_node, &bchan->desc_list);
 	}
 
+	/*
+	 * Close the bracket once there is no more client work queued. The
+	 * UNLOCK is flagged for an interrupt so process_channel_irqs() is
+	 * guaranteed to observe its completion and retire it from the FIFO
+	 * promptly, instead of leaving bchan->head to lag until a later
+	 * bracket's skip-loop catches up with it.
+	 */
+	if (bchan->bam_locked && !vd && !IS_BUSY(bchan)) {
+		bam_fifo_write_lock(bchan, DESC_FLAG_UNLOCK | DESC_FLAG_INT);
+		bchan->bam_locked = false;
+	}
+
 	/* ensure descriptor writes and dma start not reordered */
 	wmb();
 	writel_relaxed(bchan->tail * sizeof(struct bam_desc_hw),
 			bam_addr(bdev, bchan->id, BAM_P_EVNT_REG));
 
+out:
 	pm_runtime_mark_last_busy(bdev->dev);
 	pm_runtime_put_autosuspend(bdev->dev);
 }
@@ -1162,7 +1268,13 @@ static void bam_dma_work(struct work_struct *work)
 
 		guard(spinlock_irqsave)(&bchan->vc.lock);
 
-		if (!list_empty(&bchan->vc.desc_issued) && !IS_BUSY(bchan))
+		/*
+		 * A channel also needs kicking if a bracket is still open
+		 * (bam_locked) with no further client work queued: closing
+		 * the UNLOCK requires a fresh call into bam_start_dma().
+		 */
+		if ((!list_empty(&bchan->vc.desc_issued) || bchan->bam_locked) &&
+		    !IS_BUSY(bchan))
 			bam_start_dma(bchan);
 	}
 }
diff --git a/include/linux/dma/qcom_bam_dma.h b/include/linux/dma/qcom_bam_dma.h
index 68fc0e643b1b97fe4520d5878daa322b81f4f559..d18fb59bb3bba9d67b439896aacefbcf0c64fba7 100644
--- a/include/linux/dma/qcom_bam_dma.h
+++ b/include/linux/dma/qcom_bam_dma.h
@@ -34,6 +34,19 @@ enum bam_command_type {
 	BAM_READ_COMMAND,
 };
 
+/**
+ * struct bam_config - BAM DMA peripheral config.
+ *
+ * @lock_scratchpad_addr: Peripheral-local register address to use for dummy
+ *                        write operations when queuing command descriptors
+ *                        with LOCK/UNLOCK bits set. This is not a system
+ *                        physical address: BAM command descriptors only
+ *                        encode a 24-bit address relative to the peripheral.
+ */
+struct bam_config {
+	u32 lock_scratchpad_addr;
+};
+
 /*
  * prep_bam_ce_le32 - Wrapper function to prepare a single BAM command
  * element with the data already in le32 format.

-- 
2.47.3

