Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C4D41226F
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947701; cv=none; b=AHHHSbYIOqsOEMs7Lt/iTBjiW/7wIjkQRQEjB3YAfGcowTP/LUTkPYc54c/s07rrI2rKwYGl/o80Hwc87pOn5zyg6OHsKLx7+aEeKSpG/7vWo+muq2MT8mLO6+0jDv/5JuIvt5xcLu/JSjqthP4UvTHJ8S1N3wG9qucCEmUL3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947701; c=relaxed/simple;
	bh=wCpLSEqzl6yoBDde9p+VABZfQUJK0dP0DnJmF5kRzKI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oDkFcd4hilFGovNDkPaDdtrMTLldKysuDaJ27PZRyipoc2s+yu0IuOSiAOaOkS7K9cqiJffZ2rO6nl6Xpg54aMZnykrrKGh+tfAWEkSIkBB9GmIu0H8CgoBxOuGt2eGuIhXS2mcph0t/cLLmgh3X96MUNBbsDXqi/kXaxFwPQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=As319bkH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c5XKoZET; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="As319bkH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c5XKoZET"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCEQQU1333710
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=; b=As319bkHmB2MPCD2
	hVjsqzb/0oNnhssWoqFyIUeaZrYkdhwxn+OQ85KeMoE/K+8tSovvuYCrh/Jrrjo7
	aQpJUhvTmDJsFFFCG+CL80mbt0+G0F+3OY0Ulf3Bq0izs/3L8GU/s1kIVGWjVkU/
	xsOxCeLDTwyUqE8E5fEdEuVyb/6kWLeayDVkudLc1axFCx+dhXQnU9Nwfq0/HEcl
	Y8bUd9y0cXKCli1rBJbsIjdkA98Djd+R9eTNHFY9E2/hUFvlxzrvwp+FTFtQj2Rj
	T2Iv6tueOC/iAwkRoBLfrEa2VmYzy33vVuricBtYNx2GKBVUpfe8Xh4ugw6SROnm
	KwkwXA==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fctc8hkg2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:38 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7ebfcb4c999so4360145a34.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947697; x=1784552497; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=;
        b=c5XKoZETkUYUNY2SbBJ8uQR2f29JdDZn27FeJSZj9Cy1efzO8ctUUq8U9gBjWm35Qj
         UcDc3HWCHVMI1YgvKls0pn86YdbioYuiyg+g4naMowspEULfnQFcJJvKFhzmQtOfWM/g
         2ezHfEI6dPcT+x4Nv8E8NWfDkqh0RZ8j9IGY7bDqJymv6WnfpViG0XKPskkehWI54X8J
         X+7DI+PN63Q3GSqivLZxq5qpKwfaJ58JiL7rXHk+URMz6SF7MIuKNJaroNIziZlM38nR
         rYyAt7H9TevtcjDQc5MHQ69nukMm34m1camYmEU1MoDTZR8eghlwBu5hSUL4gbOgSymn
         UaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947697; x=1784552497;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=;
        b=UzVH0kz2Fdrx1JLAaUH7C3Q5fdpa0/UieVMSNem0dLv0DHP5TjziMbYCLVv7aOeKOV
         01FvWmAeDBHCwV7l8AOpWBr7c0FG6ou3nJhjX2Zh5Y1TZYp8KdA3hDkHouERxLq33A10
         DZolF/13ZfUVCWRZygCfCPs4rZviUlxuWYPY/4PN3uvq7eZt1KWZg1eBnFWBcElv/fEJ
         tQ5QJx9FDB2Y0mPn9LVvN31jzlb67NbEj+DPBLMu6nQEIZWYhtwee0hm2P9kPifAW17b
         5Gh/IqoVR4OwoNx8LdyqShBKUSGv1ez5dV9k9dtV32Y8wRZundsZB1guFRJrz1/4DEPc
         R8PA==
X-Forwarded-Encrypted: i=1; AFNElJ8QxBkGYXFDhEeQB2HX0QPknjT3QT2YBwBYDaRp0cVPdGnejg6JBt6Odxg3h7ipgyr31har1RRcNJUa1YU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR03/NQfeAqE492bfWgGlnQMNnEVa8bZtyJgdQhXVSvTKPpM6v
	DhmkpTFO2jqvOofrLHpodVNJrNbB77TAPvPaQUwScmdBQT9qoeFBZsWGm77GlLcng6PCVbhMM7Y
	bFsEXOJTwo9ed25vhbR+TPdXGZ5PYPMWqHAEDVLmS5Zz0BCpCQgkr3QHAg5E7cVvooA4=
X-Gm-Gg: AfdE7cmrSzRQoE0p1/hExv0pMBM/LrUIYMxbjkYlBnQmqiJjZ13/9Lc8O1yfYOTvs7B
	tLujoLu3gBt8DLZaOeYSZUXa2tS6RLzZzNIzL6xawqxYh3bM6WkP+Rwf54rZdSxjkwywKPnbTG4
	gAMoya5TPJ/DrTHjs1LlHeA/q3WZ72OsjCy3Uf5htKl6SPo+h2dGWTZMUj3p8BTYoknarjrrWly
	M7fJGCZ+G2pJrlc8GuTmYW7VuoDZtC+OO7N96gyfQEFv5lvnmVG48W+fe9XXL1WV+9+FdzIiH4z
	k1m6J+yq3Dic86xvoek8rC2+gmJixeBfA6rOTyafQ4GoqJPhV2S5mPjqTMZsOn72jaKhMKqBe5R
	gG4XrDYFXf+9fq6T0ymjfbiYCxrGEA3y8P+/Ug6W3
X-Received: by 2002:a05:6820:2081:b0:6a3:955b:846e with SMTP id 006d021491bc7-6a39a6e469dmr5625876eaf.34.1783947696041;
        Mon, 13 Jul 2026 06:01:36 -0700 (PDT)
X-Received: by 2002:a05:6820:2081:b0:6a3:955b:846e with SMTP id 006d021491bc7-6a39a6e469dmr5625784eaf.34.1783947695041;
        Mon, 13 Jul 2026 06:01:35 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:33 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:04 +0200
Subject: [PATCH v21 03/14] dmaengine: qcom: bam_dma: convert tasklet to a
 BH workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-3-bc2583e18475@oss.qualcomm.com>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
In-Reply-To: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
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
 bh=wCpLSEqzl6yoBDde9p+VABZfQUJK0dP0DnJmF5kRzKI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGX/Y8gCg+vNlb9b8QC+y2NfOdxPRPOTVCmq
 xAw/gdxeH6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThlwAKCRAFnS7L/zaE
 wxhED/4n1veWAxQWpeJS2JF4WMRXE7Qvtg/6vxq21gYhDGmSsHSQgS2lLYK0DMGm3oqm2Ft3zsf
 sZQtzaxhO1DLE79xiBvNcVoZ7R61pPwrxOisq7pviB95rRCoxwmUXppCWgpQTTnAdMQ3ubwLAKZ
 uGHGu0lUlsSPutnLVQEqCrF4Y3/j0wm9Bc4WCw3+YU5tYXUr8LYkxzF4lGwOqK1igDU9xGxC2vT
 nh5+aKVbKrDN7kOLGFRXwf5TnvqK7JsecA3krD/0SOuKTrV1sHI2tnDhm2/VEc/JeYBokhT3U9h
 Uph0Nh6JK6419lTFFTBt65ASG77FNh1NfPs8gIeCi4VGAZVtkJHOyGsafxbFWz5EJ6sZhGjmQWM
 A0ijR2UslRW8F8q65YwAggdfUKLCPnZBMmMBi9FgxpJvzccZvK7bwnbI/tEcGQOxu0xXOsny/o/
 62SJZxyiSKAJmZ0ki3ku+nmOKed2WhouprsvaIYUslRMsUj+BiD/JQ6lczGOyw/1PRYwqXFomlF
 gWxQnJMPfFwtGRssFRfGtlcopFYECP2rHBuYi9eqohJ6xvDzFD+h/M61zMmqIUdoLijMLLmFaeS
 XcNPtsA148e2Ij3mjmX/uC0Xf/wqcEjBdAzRs8VkI9Fgs6QXrOGA3JadnwSaX4B/r/ts3Xq/PMc
 Wz2+SMMC9BOM69Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: dFeHWbo9GVDK6QGsQRkOTGC4LotTGgyM
X-Proofpoint-ORIG-GUID: dFeHWbo9GVDK6QGsQRkOTGC4LotTGgyM
X-Authority-Analysis: v=2.4 cv=UtRT8ewB c=1 sm=1 tr=0 ts=6a54e1b2 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=u-biHsxzOdRIXVMzAPsA:9 a=QEXdDO2ut3YA:10
 a=eYe2g0i6gJ5uXG_o6N4q:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfXwCR5OhMZjG+Q
 7qB1hJj8vsoNv0OWWVICxNmhVkWSD2z+LTCB2bsv8Ogimo7v4d6vM+DE2xuNLO+6Jq/qHiw5SUg
 aNa2uZTG2cLmQVZM7ViX5X7ty43dSDg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfXxWsGbOKUiZ3l
 lgjTc1w8UCcWUdMAk+zQGm3A6f87SYWlDxU4HhN1sw+sa8IG0P8PT67YDb3Ygz5QqZ0Y/i8HgEt
 VGOC8qlStv681Tlfm1sUCHdQoD90zdh8dSHa54pGyfh/GbXNWNgqFf5beSJZvhgljC4/sUYHnj/
 8xH6nQbkJHPkgxINLQKTMFhUaGh6Am+JlqwEsTfxUZEHuo4jKyhQgEGdFrTzHSsF4y9ajTTmfxL
 TBtxdz1bgLZMkFp9myQZGdeEXs8XzucgcgQAWdY3O6Gwaq8vb4ZBKvBc+u6DpRCYcXulI/NlOgA
 kp3hWmwnEHj40srRgt6bMF/LIJ+SqVlcGdjKB+qaX3f3JKUnUCpbYMgrFT6bkdnX0ah5gGhHdGe
 isQ22iCzTCRyhH6LrH3wLyAii555agtKLY4WAV5Yu0mEVWHQDhtUbX742+cyF8GnngdGcI3+t6P
 f0QdL43ESM7aBi+dUMQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

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
index fc155e0d1870cbb7e099a2c4280f9f8fbdf6cf15..ea3df28e777f99c0532761b6aee6807ab23ab4ca 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -42,6 +42,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 #include "../dmaengine.h"
 #include "../virt-dma.h"
@@ -426,8 +427,8 @@ struct bam_device {
 	struct clk *bamclk;
 	int irq;
 
-	/* dma start transaction tasklet */
-	struct tasklet_struct task;
+	/* dma start transaction workqueue */
+	struct work_struct work;
 };
 
 /**
@@ -892,7 +893,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 			/*
 			 * if complete, process cookie. Otherwise
 			 * push back to front of desc_issued so that
-			 * it gets restarted by the tasklet
+			 * it gets restarted by the work queue.
 			 */
 			if (!async_desc->num_desc) {
 				vchan_cookie_complete(&async_desc->vd);
@@ -922,9 +923,9 @@ static irqreturn_t bam_dma_irq(int irq, void *data)
 
 	srcs |= process_channel_irqs(bdev);
 
-	/* kick off tasklet to start next dma transfer */
+	/* kick off the work queue to start next dma transfer */
 	if (srcs & P_IRQ)
-		tasklet_schedule(&bdev->task);
+		queue_work(system_bh_highpri_wq, &bdev->work);
 
 	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
@@ -1120,14 +1121,14 @@ static void bam_start_dma(struct bam_chan *bchan)
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
 
@@ -1140,14 +1141,13 @@ static void dma_tasklet(struct tasklet_struct *t)
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
@@ -1316,14 +1316,14 @@ static int bam_dma_probe(struct platform_device *pdev)
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
@@ -1389,8 +1389,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
-err_tasklet_kill:
-	tasklet_kill(&bdev->task);
+err_workqueue_cancel:
+	cancel_work_sync(&bdev->work);
 err_disable_clk:
 	clk_disable_unprepare(bdev->bamclk);
 
@@ -1424,7 +1424,7 @@ static void bam_dma_remove(struct platform_device *pdev)
 			    bdev->channels[i].fifo_phys);
 	}
 
-	tasklet_kill(&bdev->task);
+	cancel_work_sync(&bdev->work);
 
 	clk_disable_unprepare(bdev->bamclk);
 }

-- 
2.47.3

