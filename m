Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8E73E1225
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756167; cv=none; b=c3aaVNkmXNqQHhxRjdRaSaPyqNQDj6n6wU0VVUGCGTf+UkjYOKYfokGSx51iZKit5n8vxzS8Az0kf2NuZ3Y94RO0vf+bJkAT1ASEM1Fq7Qc2V4i/4cX/0mTrEga69kxSBHbuKMmdTIOwWya0Xdqy+ik9MIY4Ui+usJm76e5Sp3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756167; c=relaxed/simple;
	bh=YERqA6ytYIBXeEnEVHuNkc6pRniKdplpfqUBYqgG5Qg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mqaBuXKIde1nQ9IPYqHvRl8qtxPWNAc/OZ0+kPZ9Gqzce/4vpE6HahJwRZrZ26MTm1vJvmCOq6KBafy9SUUjPFyHjuUquA0J9ua3g4NMybO0k5D+Y9DzVvsAbgFpO+XGCL5mABwK/itM6+uvu8enJ541kZqZDw39Wffwi4Bh3IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GGg4yN0e; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Hym464lM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GGg4yN0e";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Hym464lM"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H8GcOx1534110
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YJhp9RjB1CYlks4dixIKSaB1cc2NAImnrh4QNBeenlY=; b=GGg4yN0eygj/0biO
	29VrrpLUm9gihxxqKae7wIMSDGOT/MEq2dTDuGVnQIMilviGHZEY/Xhulqfg+dgX
	jEIqLHZ1FJnKW2QaL8YU422KzoowJWGxcdPsJzu52gG4S7icPxyeVnR3jw3U9ejJ
	dZ12dHOI1oL7GexNZ++Y36G22c6/ruOsBDwhB6NLBZ+MxVtkiP8u4dbcFr6SlhOg
	ZXkZfOi+F1j4PJg63Nb7IFufzFqr1VJwUFBM8jtykFiQiWW9GeK6Cr7KGXHu8cp0
	UxjxEnsYDmpaV177P5cXpNO64RePlH5fZMApIMBGKcvGwtTelb84y+VVDHhFkeOr
	sVgB6w==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxm5k4bkb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:44 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5ffd5dd4c75so1774962137.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756164; x=1774360964; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YJhp9RjB1CYlks4dixIKSaB1cc2NAImnrh4QNBeenlY=;
        b=Hym464lMALiVzGdqSI+/0ze7IcklLl6GRFQzTHIM0S8ZQwmRuunRozAHEZ/6hWM/38
         z87IxNaxFP8lYAMagwd926NPFKYC6ViC6VvzbgPBCz2UWnJaoWEiExjQxIGNL85nzA5o
         k9bLCdOFpb2mcRQnRRyd5/mBzD6DHZkIVrHiT+5tVVR1/Oow1E79fVN2RWpvr/U+vvyU
         HENGUQjkXiDG/2653xO1tHJeZTfs7TgXlPhpbaNTbUACp/UXKO6X3Rvv2pk4Xe5aasd8
         34cBPZshdW9U2oxDUEJZcwXlp5BPgcWBoZPMk6mgwKCIh/eDBQu18gVxC3BDbzNHmZ7z
         PZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756164; x=1774360964;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YJhp9RjB1CYlks4dixIKSaB1cc2NAImnrh4QNBeenlY=;
        b=iXq8Uw2wjn7ZxbKmAEjfNT0Hl44b/JN5eD4Vudx3xWCwPN8i3YMfrqFP5Sw+goRk0l
         S46r937eXSyXHuoXga460jlaa5Cr/rUDyfZzsHy/rnul5vVfpqm2ud41lnF7pETLdlzt
         gTypdRVkU832G9yVjhQi+FChVYInRY4W5xa8e0vvGCeJ4hnwLDngI8WdbB0ngaqiIfYQ
         bnptk7qTYMwdfEddM+N6Eq55iYSiDQlrFzqZGe4d8IecFttONOiXV8g91w/zHYin5oDW
         gThJSnvUGjbuZUjtYZhAZOC/UpPEgVIC7HJHYJYQRX7L9JDGIIIKDDFOKZnZyMclCRuy
         EM3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKhxEOCvBsb82VTJZ9GhlKR24JThTmtHBnHSXRLDU8YI0z6eMAA1m7MxLpynjC9SlnA85BuHLlzyKQAP0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/iGW/wBfh1FOPawHN/csJRI3jb4ryZ1m+zQAOg72eaMQEut9/
	1UeyCWeCt8kf+0glJMasi8ndviPx0vIjpLDFXtO4GF5zfa4D1NSLmkkhzGgYzXErdDG5v8hNubc
	f5UBN/Uq7whtY7kD5ot27hNpDzxcoBXnsE4148FKmp+RbsaJRqKCiN0ASSkO+rAMPBgk=
X-Gm-Gg: ATEYQzx2QjDoIGoHmP/ivb/WYEnioVfmxME7224Ic8ORDXbzpCCV7so0ktmY66wAlpq
	F+y8mZEWj6cG/mKrfwYAYRFSSdzEPXmHkgSAt7uyOh7lATkWgQVYL+8xb7i8gEkuRYvhzzrX0Mx
	m5mvFVFWGGoBdwfVI5/ElczytFSjsOvf+k9PbuDdgsVdp9g5WMwHVnG0neOgn5pSzGkyKP/kda7
	xnFJWplBJXVz2hM02fvpQEH5+v4IVht74cEaUSZ6YdtohCpIPVZnwqP/tjwqwLmLWgxdVnykpKS
	g2dlgoLWBG2FwkoGvJCOdEttwoZl/TW7YtYHjXKh9/GPFptF6PGMbWnBsLC576FqRL5EsO7rI+j
	iLM+PcMe/GNiV5DttCRcWfr9xesKSO5JiYBkirOddlukw/og92SKX
X-Received: by 2002:a05:6102:c53:b0:5f8:e2c7:a3f2 with SMTP id ada2fe7eead31-6020ddf66c5mr6210965137.0.1773756163817;
        Tue, 17 Mar 2026 07:02:43 -0700 (PDT)
X-Received: by 2002:a05:6102:c53:b0:5f8:e2c7:a3f2 with SMTP id ada2fe7eead31-6020ddf66c5mr6210873137.0.1773756163124;
        Tue, 17 Mar 2026 07:02:43 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:42 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:09 +0100
Subject: [PATCH v13 02/12] dmaengine: qcom: bam_dma: convert tasklet to a
 BH workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-2-0968eb4f8c40@oss.qualcomm.com>
References: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
In-Reply-To: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4421;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=YERqA6ytYIBXeEnEVHuNkc6pRniKdplpfqUBYqgG5Qg=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV7xt+LlRYHrokXeVDSyCM0tjcBQD8bv6/GOd
 olQFJHXG9uJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable8QAKCRAFnS7L/zaE
 w8MpEACPTAhsCkekQZHg1QpPSF0Hp6XgqVqtwzWYMjkwMgysyX43m7vp/u6PrcV9OFyBo6txlgi
 4/jak2/RK0SPZpwkXbToZyeeMtV7RdlVXCTjbkJRG2coAdboA5DakhVJcZd5j5/06b+FfemLa8u
 vZzbzfGYbAxI1ULsMjDUG5BJ97hajXklbtiC2G4llLEHYJCZcfZ0ytbV0RcRW5fZtTCAmb8Jd3e
 ONOqzTmaquqFo3EwHAxqnh/AXKjMDpLxvB5VOUnL+++Z2VXX1PHJWHwomMnPms/Cpuoz+gCcWcq
 FbwlSzeJaHlrzkofIM+56/gKjJV6zmxS2oLvodUfKctU2SAThffXQ774wopaEG/K7MoPh78G3Ox
 /C89Ic+WLXBg0Vtw+E7KINkmagpERTuVAumxjyS0tz0ZJbRhTWX7x1WJGmmpiRlAcHARQlQfR1U
 uPSI1yrHAS8U4tSqO1+3X/dkddeS51EXN/QxwjDBdaxpwKZUjn8KzRB3ERdW/xJRToUgkAe7k8B
 8kQveXFx248wHSauR4R/2+8erguPWup5Qbk2/61GghdQrjI2LvMIN6rsm1w5oYxHb02rQynKInI
 O65uZni/ha25rrWUV8Xau5ibECKPoepozLIYWXxFZrFBELW+yg8mKfIlA86eGpN/Oct7p6AyvXK
 lzhBXUmnnNyJ75A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=fJ00HJae c=1 sm=1 tr=0 ts=69b95f04 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=u-biHsxzOdRIXVMzAPsA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfX8cckhdoKXBCx
 tLXxUDlnhQipxajxmsvUjKtJilnHVztY1sArWaZcm7EGeIe3I7v/UxWd2o67V4uzJBBjZHRduB3
 jq9+y7RhL28Hca2ZI7eVQ1K47Lz+fz5DyHXb3ZffKFzxXApjzFeeUdGtOky03iL4WZnDNU4+Y5j
 jqkR00OmVDGTYEuFeV5OMqR7jO3Z+47wDPmnsmU650HWpc52ZG2Oktv1BPPlHjnSi5xU6HwfGpu
 t+VY5Hdv+XmW/A8KAabI4d7XoKeCkgWptWhWc0phowb7HrSB3VWMXqXr5YoQiCABW9YLWIFxHBC
 gJN/N4aLdaV98Va4oJI04P3l25EPjocEg6nSmAnaKp5cNcoCr/Xkdfo0E8fFgfOv4bqOD5jXxWV
 hGpaJLh6ppTcWgI71VmasEdyhCK2/yYOLxPB6FWRVTVdopifiad1xMjAl2MykBaHBavsGW196i2
 X+SxY5NZcAKz9TnJzcw==
X-Proofpoint-GUID: w32yK8Um72yDGa2RklsCDtzpfvDjvW_J
X-Proofpoint-ORIG-GUID: w32yK8Um72yDGa2RklsCDtzpfvDjvW_J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170124

BH workqueues are a modern mechanism, aiming to replace legacy tasklets.
Let's convert the BAM DMA driver to using the high-priority variant of
the BH workqueue.

[Vinod: suggested using the BG workqueue instead of the regular one
running in process context]

Suggested-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 19116295f8325767a0d97a7848077885b118241c..c8601bac555edf1bb4384fd39cb3449ec6e86334 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -42,6 +42,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 #include "../dmaengine.h"
 #include "../virt-dma.h"
@@ -397,8 +398,8 @@ struct bam_device {
 	struct clk *bamclk;
 	int irq;
 
-	/* dma start transaction tasklet */
-	struct tasklet_struct task;
+	/* dma start transaction workqueue */
+	struct work_struct work;
 };
 
 /**
@@ -863,7 +864,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 			/*
 			 * if complete, process cookie. Otherwise
 			 * push back to front of desc_issued so that
-			 * it gets restarted by the tasklet
+			 * it gets restarted by the work queue.
 			 */
 			if (!async_desc->num_desc) {
 				vchan_cookie_complete(&async_desc->vd);
@@ -893,9 +894,9 @@ static irqreturn_t bam_dma_irq(int irq, void *data)
 
 	srcs |= process_channel_irqs(bdev);
 
-	/* kick off tasklet to start next dma transfer */
+	/* kick off the work queue to start next dma transfer */
 	if (srcs & P_IRQ)
-		tasklet_schedule(&bdev->task);
+		queue_work(system_bh_highpri_wq, &bdev->work);
 
 	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
@@ -1091,14 +1092,14 @@ static void bam_start_dma(struct bam_chan *bchan)
 }
 
 /**
- * dma_tasklet - DMA IRQ tasklet
- * @t: tasklet argument (bam controller structure)
+ * bam_dma_work() - DMA interrupt work queue callback
+ * @work: work queue struct embedded in the BAM controller device struct
  *
  * Sets up next DMA operation and then processes all completed transactions
  */
-static void dma_tasklet(struct tasklet_struct *t)
+static void bam_dma_work(struct work_struct *work)
 {
-	struct bam_device *bdev = from_tasklet(bdev, t, task);
+	struct bam_device *bdev = from_work(bdev, work, work);
 	struct bam_chan *bchan;
 	unsigned int i;
 
@@ -1111,14 +1112,13 @@ static void dma_tasklet(struct tasklet_struct *t)
 		if (!list_empty(&bchan->vc.desc_issued) && !IS_BUSY(bchan))
 			bam_start_dma(bchan);
 	}
-
 }
 
 /**
  * bam_issue_pending - starts pending transactions
  * @chan: dma channel
  *
- * Calls tasklet directly which in turn starts any pending transactions
+ * Calls work queue directly which in turn starts any pending transactions
  */
 static void bam_issue_pending(struct dma_chan *chan)
 {
@@ -1286,14 +1286,14 @@ static int bam_dma_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_disable_clk;
 
-	tasklet_setup(&bdev->task, dma_tasklet);
+	INIT_WORK(&bdev->work, bam_dma_work);
 
 	bdev->channels = devm_kcalloc(bdev->dev, bdev->num_channels,
 				sizeof(*bdev->channels), GFP_KERNEL);
 
 	if (!bdev->channels) {
 		ret = -ENOMEM;
-		goto err_tasklet_kill;
+		goto err_workqueue_cancel;
 	}
 
 	/* allocate and initialize channels */
@@ -1358,8 +1358,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
-err_tasklet_kill:
-	tasklet_kill(&bdev->task);
+err_workqueue_cancel:
+	cancel_work_sync(&bdev->work);
 err_disable_clk:
 	clk_disable_unprepare(bdev->bamclk);
 
@@ -1393,7 +1393,7 @@ static void bam_dma_remove(struct platform_device *pdev)
 			    bdev->channels[i].fifo_phys);
 	}
 
-	tasklet_kill(&bdev->task);
+	cancel_work_sync(&bdev->work);
 
 	clk_disable_unprepare(bdev->bamclk);
 }

-- 
2.47.3

