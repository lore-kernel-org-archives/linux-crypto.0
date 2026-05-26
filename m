Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D93DEAF9
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801089; cv=none; b=RcwU02CDypW10VX5sgwjfsIE3kmcTIX1CjkbHM6FJFsZPJRJBdqG4l5079GgVB2WHcYTiDaRwhSWHIgwZBQkkIwe2znHA3Q98FTmo/cxgt9ry5BgRfkJLUtmhBra2ZRCxJh5Qo6GOlTKrqiE8g3Ijs6lZPYqN3kb6r9LvJDgl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801089; c=relaxed/simple;
	bh=8kt/r9HrIy2XInrbgvfr96jusMTBkm3qidl31H1ffz8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HhwjpeUqhwHuZCMr13vfM0t0tEjO0ZUrkBaiU/FO91CqQDHV+9tR1TJ4GQIgpHIEsbMFmiaXugd3jmkIBXhoqPOHWQiDNt0rZQhxOcC9Kyl96wnffiN48m6K9+ZSCfZU5LbqZHMEX/PUPsC9hlDLArDNcaApYmu5fhBblDUzz9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RIGObwRv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XwYSJKk3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RIGObwRv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XwYSJKk3"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsVro2385457
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tEzaODDzYECg7HtqD+MDkUrvvRFJmjC1+RPt1k/O9MY=; b=RIGObwRvQEsIuu83
	TIxVHDCq+f3ZVlf6oD4onWTVPk2xx6xqVLaLMWqTXdxrB+C1v0e0Okp8CYssmaMP
	e/LHB1CkaLP+kLn2q7WHFiYWwf6yZhbgHBQiPH97zS4dfiQdSPwQvjxA989qWPKT
	nC9FtJXPuQ+RnoDPcKgiRjMub+pmYPDRZr31yt/pzCKIeZEhnfXoCbEDf9UT8TPD
	Sd29FPdXAWqa0lKn1smUNPcinw3aDFXJIHNUGkfkcdVLXm5EBu7UExZORHu/XttT
	RD04vUyWanphDh8aF+dZI8rtjnNDGAft+GhmcKnD+sh6V8ap5QyfV8uzT0vGzZVO
	wLdK+g==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecnhs4t4u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:26 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4854350bfd2so4613815b6e.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801086; x=1780405886; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tEzaODDzYECg7HtqD+MDkUrvvRFJmjC1+RPt1k/O9MY=;
        b=XwYSJKk39B0oviUzDbOcZwBGoxC45Rwb2liiVOIc9r8OIWwT45dygNQBAIiSyaHxyr
         4QH16noZpEJdayMqgDEDJm9pfafXkXVsM2H79aVf8kzhePVBE9ikSpUc4uWiH336+w7+
         LrdzEUbUmj0Ee9dIcn1CDRBwShvzXq1Q/YoXor5C+GKzwCkphmMoot33jK5mOFY8M4Ih
         a2KCqbaZVZBbuCsDczwlweOWWZvb7tf889kbAXWkXVxmcloyc5+Cq60ZhCSg727pGqMD
         Md+84k6ZzHI+sZyDVemo2UqEWKt2GjTuSRoCyIJKLpYIerZspk6bXiLcjAK9RIMEdqrn
         69gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801086; x=1780405886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tEzaODDzYECg7HtqD+MDkUrvvRFJmjC1+RPt1k/O9MY=;
        b=LcwWRjDCdr01NcH0/JoO9nOSK5EP/umoNadapUBIIZfrZkbywb1JJLNWUbezSF08dr
         7IUex03xlp4ohTeyC/RlCvmYMHNGZ6JFRaNH5I5JgdU/dApVJKb4N47uVzeBavU5OLvD
         o0KHWOiQkbNNqG8/pIn+xYC2O4sNVYL2bkhTtHefCianMyr/3cMnUlG739SCH8Dpi9jr
         WaALcenyTcMh/KpGK7/XPUK7ouwqIMSs02nx1QqxhNmOCY6ujzXtzSzrybJSW8dvfcJx
         IOS8+fGvK6q/dRw0KyJjKk/H6lqsuPlB2jkt90m9LMGtVbHDh9sCX+FjiMmRTrZ4Leo3
         bXwg==
X-Forwarded-Encrypted: i=1; AFNElJ+YkjMUYTte2dFnuCw2W9Gxvwaed3OnAcQR6MCX130xruLqy27RLRsPgPvRZrZOosYydjqUPjvUyIfkQtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIoisJQqdsIrTY/MlI7wD2S5Aws95fExELMAAMmarxK4cph4FS
	QHGwiq0UfodsLvzNRvt1cnWp9NeQpmBGtlr9rIJbB2mb8rIEtg8oo2vAcSqbT2BKsPJ0rMHyKQj
	VSCqD+3kdcrsbdslJEsNOadEXPCQzmcxpm6zS6qlclV+HZ/OwCDlbFA9bYoE0rwT4DCg=
X-Gm-Gg: Acq92OHaSF68aKrskr1Fktyx48Le+Va2pN5dzZv8axEIOtG+oDJGp2eoWf8/XxzSe4I
	wuYWHC6mPBmJfYy1V4hdCt2njQjyYM16UpDpiYJfwErP3eW59SE9JiWHYGVXjDLRJeWzWf+0Fuj
	nbPljAqOiBC7P3xbZJaxlVTE9U9LBVa4JlE1qcbRCB6feN3kL/nOvvf2NvtvVy4U3q7lASy1b+v
	1SLnueE54z88qNNv9LYFx3xj2vVud6rGcJxAz0a1XZvrdmKe6pH5f6FvP14GPJ6b9NIWHBrGxBb
	uOe0WO2x9eClnvsVSvF+tkGPnwSxgnuHpeyBW3Wot1Ypyg4O01OjSiFHBtavDCVXV5DHy4qGKWh
	neMyZzXUkj0hvdyRJ6aEXhInUQa+Oye+xltSryQay8MC2Zc2TO0k=
X-Received: by 2002:a05:6808:1a0d:b0:482:4dbd:4fe2 with SMTP id 5614622812f47-48549edd3d3mr10664325b6e.15.1779801085503;
        Tue, 26 May 2026 06:11:25 -0700 (PDT)
X-Received: by 2002:a05:6808:1a0d:b0:482:4dbd:4fe2 with SMTP id 5614622812f47-48549edd3d3mr10664275b6e.15.1779801084959;
        Tue, 26 May 2026 06:11:24 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:24 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:10:51 +0200
Subject: [PATCH v19 03/14] dmaengine: qcom: bam_dma: convert tasklet to a
 BH workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-3-08472fdcbf4a@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4421;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=8kt/r9HrIy2XInrbgvfr96jusMTBkm3qidl31H1ffz8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvqAr/c+zOJnBlNFR6ajuIeqQEySV5XeIfMv
 uCGrvzCJgmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb6gAKCRAFnS7L/zaE
 w7mQEACvAXElwu/GR7rmlovyB3QgxwBOCO6PIzDULjvU9h+onJCDdyJP9XK4gBgRgLoDKQ30ktU
 ewZlA+VfBMfD5wN7K5C6ogMpdw0PvFuBoYPL+vMkL/fy/L7fI7upSqy+W0TdMwFbr229q3u6C6P
 PBuuUGlkCOXhy9EGGx0p/TwOc6eNnYKbyIUHtJebx/Z1c/JDMoNUYaFqPVUxIr/Qb8YjYzP4bwb
 CAjf6MZf/8GYrmj61MRYVaqM/u5Cb3/VR1NNYLxzEhgVLTwz9sfm4kgIusmrxfhKxYjPbcsRO1Y
 /hQcZ4rpJZkPiA3noFslaF8NPJGkH+6pZyFgjpKOtjwFgT0/MZ3snJt9VX74ca1QfJRObgezzuL
 Kts7U/NauCGTBhNKJbTAazHYuzoPpFKXuN4Rl+nCR9dUDTo3c6YaCq2Po3+c2u1CdUmlBvo2Wzj
 6+MneWI6OxTwlBdz65ssOha/7lSNyrfUot78zsVGHDViCGRx4YS1twZlcCiWVvFRxxpqzvYwE9U
 0TzGQMjhcjxSRtdSm2hTUVOF8G6KkDPn3zznJ/B0RWWEtUndeAL+qhrUEcQCGwCN3NxeGLPDZL5
 RQhL7c38eXnTKKDY4ktYEcvSCPX91lrxf/UIo8qO3QH4RObfmFmKQMUYA+g73bEU4XFKBU+6zIa
 mL86zae3L8y7ozQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Vd3H+lp9 c=1 sm=1 tr=0 ts=6a159bfe cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=u-biHsxzOdRIXVMzAPsA:9 a=QEXdDO2ut3YA:10
 a=efpaJB4zofY2dbm2aIRb:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 7h3ZkmFnHT3OJc-UmMF5wEyNdxOCdaQx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfX5uuM9m+TlrKC
 41lIVhX5r+eZCN3gPscEk++9iXU/sdvAnHloYBzV06MDORpJI37Uxmf71bjJYeHiAQEs4thUYa5
 q0lUHaVI+FXiXFlB3f3t+D3ihezlwJ55m56m/tDS7Z3pBUDhN0sqGDQ8YrM6/UglyeRm0iYL0h7
 9oUNuOxV4jheovg9t9sBtdNk2UEZk6aSP5Ds0DOQBYPGy/ij9nxLzNSWAwDXolMyhXcQOcutO9x
 QZGum7eoPvK//n4G9QHvmmK/bwaaxI9XcTFCtqcSTMvBcERySmwm81bI3zDPjuAPIwH9iiQzu5G
 GPEd202AbhlkIu4Y8cIj3RSENQI+bclOOAdJ+8erP3AnKX5H8W0wc+zcd58KYWu3ahPG+3wmk+f
 Ct6kTx5fyJFPDzdZ5hNtxaiASAaL2PUNfJn1qnlNCOsVa7WXCW59Cow8YV/MJ9Qy/Y8ApLxj0/A
 lcrpD5IZTK9rszWp4oA==
X-Proofpoint-ORIG-GUID: 7h3ZkmFnHT3OJc-UmMF5wEyNdxOCdaQx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260114

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
index b3d36ea79984385fe0d05ce56042d3e6e3030c5a..1c62f845ac0b956e311857b93f5b504086662f45 100644
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
@@ -1359,8 +1359,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
-err_tasklet_kill:
-	tasklet_kill(&bdev->task);
+err_workqueue_cancel:
+	cancel_work_sync(&bdev->work);
 err_disable_clk:
 	clk_disable_unprepare(bdev->bamclk);
 
@@ -1394,7 +1394,7 @@ static void bam_dma_remove(struct platform_device *pdev)
 			    bdev->channels[i].fifo_phys);
 	}
 
-	tasklet_kill(&bdev->task);
+	cancel_work_sync(&bdev->work);
 
 	clk_disable_unprepare(bdev->bamclk);
 }

-- 
2.47.3

