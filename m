Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F4843CEEA
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457228; cv=none; b=DKOW5OLIgUHodd8wNtkMrRVyxotW5oKzYmxG0oYiUAJ5VtV/rvCyQb46g9EmMTt7u7Xylg4q1Hn71JjIZhg22CtW+PJ7pE18XLqgDm/zwwrODAun9UEYWxtoAcPPU+Sa3gmXQ5CxyJJ1PFGnklLenjoX/N4zn7XqUNeCn1MKN6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457228; c=relaxed/simple;
	bh=8kt/r9HrIy2XInrbgvfr96jusMTBkm3qidl31H1ffz8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=esLnHh2UduLzYD/1IWQi54Wyta4rahl+MEfyVENMszCWwr1ldVp//V1vP78hpNnFZzXwPENvJUf94pJZ+0h1qb8CgwCL8N2NRuntCxbCu9aIvu//ZtRlHfRHLfCf06a9Yrx3GN5JYmG5e3F9qb6bPRyqNUsQMc97Jq6dN4Xd41g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=No6M8Rjp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EsqWgxlE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="No6M8Rjp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EsqWgxlE"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M9CPoV3532263
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tEzaODDzYECg7HtqD+MDkUrvvRFJmjC1+RPt1k/O9MY=; b=No6M8RjpytrH+Ej8
	nPxPuBMdxzhYY6j3kJxMz9Qs6FkM1YzdFcOha7sPXPST+aN9pMfAxzn4XjhhKYtv
	tCf5WeivKclkFUQBlZepbztZ0otTM9+ZGcTgGzS0EOPRfPgDva4cUg5o//zTunfV
	2CADJzvneru1kpFX2jINryf+HPy3PvlSFYuQdOaFS3M/lE5uel88UmBoYsH6xo1H
	H68qlK+MkmWqpUGqDaTsRxOZQmA9wFs5Kc6pZ7uomo/I/0nuIcqLXyBiV7tFFqBh
	sAIsmGFSnI9OJOb5n8FTdaG7dN9NyAlP2yWWHT8oAKRHjmzHRWHw55tT3tTxJNxs
	xarMEw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea39gw8up-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:25 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-516d19f68acso26870651cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457225; x=1780062025; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tEzaODDzYECg7HtqD+MDkUrvvRFJmjC1+RPt1k/O9MY=;
        b=EsqWgxlE3sVKwpi+NuShfmH8VmFr4RExWdz0uUJ/bAoG4kkuzHWne7oiWcW7IGsjRu
         zcTs+EHJthbh2h8fUW0JUvv1sxPks41DnCF+5VndBlyhmdGxQBi2pOzU92FY+HX+qUuj
         IYPHeNcKiyro5jK7KsQHjnFqci592puHlAzFaJqBlFwMrW2IrP5ia9rBfMd5x7an7oJX
         zQZ80V9L1gJ5b3inZB6McJIIPQFbvnl/NPfY3Tajj3D6q7wwOzfLembujQsrdlhGSwiw
         Ksphci+wY00J40LHmfY1IqaiEnaqhqPEP7tgT0eQz7h408O/GLQcpJFOKXGj3FgYJvqi
         Vjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457225; x=1780062025;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tEzaODDzYECg7HtqD+MDkUrvvRFJmjC1+RPt1k/O9MY=;
        b=S3s+QIsjLNRl226xhOxKDLZdJ40PnlBxNQkkW2iNWtWmbJhJGGya/I98mgQJ5j1oFt
         WOJR5RpH7ggz12S8NfNpQI55Iza8P7rPOYJZhSA/nc8xVSd9L06Zwh2/NzDc0VyUvNcG
         q4W0E4YkqrWH4TEtKP30mLdHkNUQ7+u7BSWaknYX6sIbIoPW/6ikycXhDyYKOziOwSDl
         8rszmR2m62yma7w/SNX+Z5MnPjUzEDJ5Z7s6+EpAkd07hoank+vQNdSHtLpl4LA0oh6Q
         ECCT8bWPWvDLM/dcHMnZq9rskDyvkeujAu7sFJkmCBHzmdYPUuaV6XTasKcRh8X9VRdX
         gxaA==
X-Forwarded-Encrypted: i=1; AFNElJ9CSuT7/AvmaI5cgofvcqYnmb56DFXoZ5k02Um+YUUjoaNYEKDBhOlNdYocwd5yNF4ho93vTkvs1UddOmc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMBTOQ4sU0IrMpMCSS8Fg+pq6p/7SocgXRrLshXwQv7JZjY2z/
	w8lwGPgq6dy52/GZ6kEAzvD9PUq/QsjU8957Yh8TZkbvsFtkF4FeYa8jvX0UEJAizsPknk/7vCP
	Qqr27+QUOOXwct0Qe4cGzNJfelHe/dz17YMkC4RCtzkIplvBKBmYy9t1nbdjbQiCYnnPnODe+NU
	Y=
X-Gm-Gg: Acq92OFXll0lovL7lSUZzWDxNdhYC+6oXlsPPtI7v1/tUQCLmpe0aQZC5w9ABXqb8FU
	5o2XfA8yze7ya95nGLqHdQUPf8OoUPtINmf0dsciRSQDdcxm8Jn7usiL2F0awzlVP81KtyFFVqJ
	9+8tLbdQrrFBaPZVgl7yu4dTbvRezN4nzHb+TRSaGvkCtf2Xvhqb6GsLBH4s4CGi5SxF2VvfyMj
	7wWhE9if1r/hgHarTB9XvOrusu8+GPnDq8v3yZatYbj75gkqn+49umE2MBC/mm2yZExi8OqTP3q
	wDnCj6jo59h+PbPtkKQS16FEZWq3EkoAftHQmOzMcXHAOeVgMdOK37GoS1lvI/wZg2uinTJm2/4
	PIl8AKvr3VpqL6xpF27qz/N7jl/CqnEqLWeQ/cpgbhXHhdjJxPw==
X-Received: by 2002:ac8:59c8:0:b0:516:d1c9:8c63 with SMTP id d75a77b69052e-516d419a58dmr55277651cf.0.1779457224556;
        Fri, 22 May 2026 06:40:24 -0700 (PDT)
X-Received: by 2002:ac8:59c8:0:b0:516:d1c9:8c63 with SMTP id d75a77b69052e-516d419a58dmr55276951cf.0.1779457224043;
        Fri, 22 May 2026 06:40:24 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:22 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:39:56 +0200
Subject: [PATCH v18 03/14] dmaengine: qcom: bam_dma: convert tasklet to a
 BH workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-3-99103926bafc@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4421;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=8kt/r9HrIy2XInrbgvfr96jusMTBkm3qidl31H1ffz8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy0QgoalJd4nsv+KyNxeRwnVz7T7emmA0iAn
 w+bq7A/yZqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBctAAKCRAFnS7L/zaE
 w8mtEACcAKWhiKNBPOKaDaJWsMVeL5dSBaURqzzIgwKoPMxvuoftrlvuBf9efXzi/pqWbtaH27k
 zaZ2VYgftBIn3qooLBaL0NYAUIEL0rkJBjRJo8M+OrFTJMRa/zt4/8EMlssPdQ42Z6O9IuYvqXB
 ltpqe+k1ySWpH8rH/jqUymODykLOR+Vh42x0oxLXw0eKowTJCVaLgza1j1In+LZE1gisl3EuPeF
 kX0WWm99riJ5ldQGaKd7GF+DKVF15LNhbVMhQU/wJdzkajj28R7ZppWrDj9HE6UJRUUs1MiFJPG
 uHVZDNMB/GaQ4W0ZGae1S2Lv36kurmV0NGASA1lzZmw3/n9xnNywj/Xc7WqYQ0aAyyuBbIWFG8m
 z4A/vK2REBIoVkpStuaxEV0fV0omG+8va5zkFTPuOaZT/Q/g9SEs4Bo/atbQE6YvngQJx8P+0QY
 Mg7WaYS0gSIHxj7rlXGXWNG8mgA2w/taXG4P/bRXYcDXeWIgTurtwBY6UIq4Tb/YeRn7xxHqvCV
 v9ZBIadNbVG0A2yw+TTYB82HBOPlZKQOnDjG+g6Y76jg0l9df0lzUuDyLLoq2eBHz9+Z+KsKxcl
 B9+cO0gPpUZSV7V7fz83npdvNUp0ZCQo8BrNQiu3DMAhWI8ssB2KQ+SO/69U2QVphTM6bIGp3Ia
 ArAwsHajuC1N1YQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Yr8/gYYX c=1 sm=1 tr=0 ts=6a105cc9 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=u-biHsxzOdRIXVMzAPsA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: koY5K-dhdT9GJfFe9giCPspm4kT43EFN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfXzgGFWO+Nqg7t
 oavB/sZNSnSoNXDFv5Ptkq2cZ73lgfDTKoTsJzoxqlLJ+Y07gJ/BY5+q5qumhYugBEsYkimuJYc
 R6BDmx7n6Po1ktFO0hm9+BJ2m4YvOHWoVZNCOhT8t5YUlDO3qClg/FRC1mpwQUvQwzia73alZUA
 uuVAAdj9q5Cjuc5mqGMD840DO34KDDRmZxlu7BCUaMEx9nTs6SecXCiMRwl2f3zGMrInpP50dju
 JTUIKR0ndU8VdkbtawaUfI984R7qAAzSkYgH4/yp0SEBNANYPrLp07A/Co1ljKBIkib/TeSncDn
 j9+2SgUpBOVIJDHF6vH+fpNVTEfHj+sfMjTBP318rea0EXaK9r+fnpEWp0K2uKPLZNC/B3qSzHx
 Hos3/aokeINjXXSYssevG+PutwXKYa48OWSku/B1QNRjcD+4da8wtCo3UeJzshEvzWxizdR70oB
 J22UtAObQO9/d5QgkMQ==
X-Proofpoint-GUID: koY5K-dhdT9GJfFe9giCPspm4kT43EFN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220136

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

