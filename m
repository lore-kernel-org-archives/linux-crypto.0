Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812453FBEA7
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727360; cv=none; b=rTGPM5tmGMA+aay29jhVsdsH7/ASVssW3D4hxd+vsHjkqFv4dGBlLxBJpUcTNYDUgXFzF7xLwfc1XxhkSAByBYA3S6VCSoqk0mU7EA3N1pnb1keqfDbBjOxF5HqZxAqGo6p0tX5/VKYBpukYcizCjNzPLOtPLhZ3NfujsqUh1/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727360; c=relaxed/simple;
	bh=wCpLSEqzl6yoBDde9p+VABZfQUJK0dP0DnJmF5kRzKI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sYZ0Aa+Zg3REAuY6jeOpgeosrQLZ4gUZi8Jo2nDRkbHX5JySh1fIh0iTuKrqn2hHBrIpZVrizRka26SNpJ8v2euK8p+UOxG6EOyss/aP64exynIKFrLDh9heFsuC+UA7mkqtWOnrZdrK2b3G1FNhPNjGfjaOC7ryooztL5CSZzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lxd+YGM+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h6mNWU7V; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lxd+YGM+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h6mNWU7V"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T8O7qC2348330
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=; b=lxd+YGM+KoQxlNeH
	8pH+churOwNbEFL+qWr4HRWHCEr3Uop3Ij5kQnsEWZiTrq9LCMnfYAQFuAJXC0G1
	RvJm3Vvj0mwZVTYEMRq4OZm6aKl1pvMuMPt8/tI70W0Fav+WLUP6sCDOAMeTIkg7
	sYyokkHnxy90WWTH02di6CAtw73PBmkuY5DdzpQAYDz1Ho/8Cjw33prc7DWH2Ug9
	9iTA4r2rLsp5dPiCD0dcd1FegZy6kiCBK+ZT/QxbE9QPgeZgy6KYlu4Lwv38bFFL
	sOzWe7ftUFoAM2HFW7I8TYNAJblflt5TAX9D9nUoBCH1xNJbW3oTSsDo1NbKf21J
	lYtM2A==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3n5s0e78-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:02:38 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5bd6e81f792so3084688e0c.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727357; x=1783332157; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=;
        b=h6mNWU7VJd3vFtlLghpDkzUyNtDC64sP3PHDRSl75vRq+v4ef9yl07P9ppgUpJioDd
         Yk1OVnSE2BC+ePCOUCOyxzHSGL1nZXk5g81aQONBaCmK3ltHI1H0gMwFPlyFdGqsdd/B
         1N+NPHuVrH/jbxBL0EJ80/ut3DSIFx7Ep9hr/sNVSMHnJyV4gjQLnz7PusJ5Y63HKbJw
         XSI7thIHEi4Atm4e6Llkp9S2jOjG2mD1xfBxJokgcxNqQXdx+/avV58MssezPJnDb3K0
         h4QUi6qOVfRM+GRGxUrZTAjqQzlL6968PG2i6ily9WSRgpo4ACxgia9vQGmHUQmbwnIA
         bA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727357; x=1783332157;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=;
        b=lZ4S9QeH5EG0zJK0XtGNNQfiP9XH+gB1yrSLpoFCry+cyIATZARCnoJ3BEvIOJlQB2
         9EFLV7Kx8IGeoRm+vWHYk5Y8BgtYhyvxjGbC+ZEm+HAHGl2zRDJJmH4tm1Vg1P7kZeQX
         V/YgbvdSBSt3Jw2Plw+byaZg0ptDmBDKfYZyaxDgWheidhp7x8geugIy3u7z/Ny0CEw2
         5kKg2SfXwQraYZJoBnuQXrOoCvsQrpCMRV9yjeAVZ4v7nB8K9JRBnxtMUetuPa4l0GCi
         mBFQFhEz6D1Dw5efElqBbj4xydt4OSFEcpNGjt0BH5aOjmG3honAyDN82mknpjs033x+
         usew==
X-Forwarded-Encrypted: i=1; AHgh+RpoZjS2edH3ATqIiSuCRTH5ikV2sIaMj/10WcMwmsy1F+KmCVlusNZv9uhPZw7VxlMoOF1oEnj3lOZJXU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPZClsjRS2wcG1waVo2FRdqaQB6ngZoatGnXCu4MrMkGZNELeJ
	vcFH0uoc84IEyZDZzUcBDJBTEhyfTUqypJWDWSvqV88YdW/W2SVIYg2KojPw/KpMfoecgkDqZK4
	S3eyspzEDa/owBTNtJm+7sPMIN/9JuzeLcebT4xEe88O2Y8R9DXejG2WmW4oc+rBKQFo=
X-Gm-Gg: AfdE7cnymXLON7bOYzDXG16xFVRN8QOcIaAzItz153RkjszlZOg0U87qNxmi34b4XZY
	2TNSPrayvPPC11BHODo/Z/Buw62HVZBiC5TRHr0bPFKBUsMLHm2Z7pQ/F6NqomLOifkuRYQK51x
	4hmsRGSTIkTVUoIfotXfJMglq2EA3E4v0G0IHHF7u80Xq3bcB/aZ4yOJoPkWZfcOxRywo6FT9+D
	1tRjB9NJVVPyGLAm1NeLRizcdT0JI52FLL0uEcJPqRtaeZI68WjZF5BYng32wicLcCsUudQYuVz
	B9zhYSCH4S9kjulFKPHaVOwnciO0HUOHQyqUURmYZVM+z5ZXzYewr7+4v43G/nRIdE5jA4CTMdv
	mXaYbP8U2FH0phbm+BglDKJETs4BbBE/39CetJadS
X-Received: by 2002:a05:6122:7d0:b0:5a5:3eea:4513 with SMTP id 71dfb90a1353d-5bd69dc3af5mr7021718e0c.12.1782727305873;
        Mon, 29 Jun 2026 03:01:45 -0700 (PDT)
X-Received: by 2002:a05:6122:7d0:b0:5a5:3eea:4513 with SMTP id 71dfb90a1353d-5bd69dc3af5mr7019570e0c.12.1782727294041;
        Mon, 29 Jun 2026 03:01:34 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:33 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:05 +0200
Subject: [PATCH v20 03/14] dmaengine: qcom: bam_dma: convert tasklet to a
 BH workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-3-56f67da84c05@oss.qualcomm.com>
References: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
In-Reply-To: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJqJG4NZNDsu3JpoCMiZp9XSSPn3ihDbswpT
 eRQcXp5nSqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCagAKCRAFnS7L/zaE
 w0O7D/9JyrQzzkB6Wv5aFDilYPXHCfO21IAugUnx/jhdZge7cS0uKPqSl3fpxRpgvSXj+RRR5kg
 9H9jHZKnRdNXuz4SUrASw4kQ5c8ljBRgjMchfuTJ+LdIo25IcgjzLivdnrB1BpfNe43LwQtKL+x
 neMud/IXvYTf2wCDQ/C3AZRNjxVzSel7XqEw31QvO9+R7bqQ+fJ1CJA/MSBM4HRyaYk5BkALVuo
 MDh4fw99EflxoUkbyXJNgHKNfdch3FC9Wgt8qpy/JrjauwCgv/rxtne/IRWQ6eGx06YVSk5jvk7
 G7MDd26+G5V5DCznpnGLerUympvDBJaaKsqhb+szgyEfHcyN7KJ6Q5nJHkyPLnlG/jus12CAMLJ
 2V/bE7YPzzhNZQUO3U7u8F6Xo21Tw11UDlx5ZcSqYWgXO2KxAl9CUMff30s0O/dXCUOeffsScI7
 gk9hnmJAjWw2ROgbnw4WZO1Zi+1DfN+N0fOubDPkHsmR86sJelDk3yUxDS4lJaywRdRjOH9sh1u
 HF8ImB/FFfAZEucm2WvC8Wr1qaUs7PhhNfogsTbBCNvwi10Ty/z+vv9Y0yzR5MCmGx3e00fwDMx
 kQQj/Amm+hntJH42xAxr1RgzK0jaMHrM2SqvygNewU5I8u8+i70S1W1IltItgX9QhPe1SAbRzDl
 dvjlUNdtwr/vbuQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX1w3mvlsW86ia
 a8vaGj0p9ZROwkdDau/j7QdKMFYEzBbDs/ZMd25/Do/2080sdcuZW9SZga4n0PrEBoufvLpbjzC
 fOTIGvImIr++3ldGGff7Fovex0bNfq4=
X-Proofpoint-ORIG-GUID: iMzo6B10R5uCoVS0-_DIVGbQpqhWVuoJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX1b+/YesYlk3F
 I5vzlw0B9/svAgjQmsSLNoO64hEjATqu2oqFrDdpDbAjvzCbWZPek0ZERjF/hoKjsk91adjG0ME
 9rlA6l19aJU88cgGrBzYgVaPmQz5zVfJC6DgCkr+aiuboBJ96xti3ySMY11SA4rsf2ZxzEt927q
 afCRCWX8jGprcuRQx0D4NJnKT2ubcacQE2jCVylDN/uj0/Cdw6LBk1wthRwyAxrVUFJYbb4hQ/1
 ETHTykDW4TBvxddiHW6fwaGJtEtO56+KFOdGW4HMWGObshC0h0YHKnWMMbjhv0vWku3UE58uElC
 k5fNXJNhFOa7mKxF4N3JVGISFDoLa5xGJwyux/kRUsm2XcJ/BC21CYXxRhl3KwO2Il+gwzavFO6
 GpH8OFzjvupULaHZiUB/HFQWGCYReg4dvcbiv2MnMGcUQOrwYihflU/5rk2OAq2NRaePh4nGaYj
 fILDU1p/agqZXW2F/Aw==
X-Authority-Analysis: v=2.4 cv=NZzWEWD4 c=1 sm=1 tr=0 ts=6a4242be cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=u-biHsxzOdRIXVMzAPsA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: iMzo6B10R5uCoVS0-_DIVGbQpqhWVuoJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606290080

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

