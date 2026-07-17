Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0E93E169E
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277423; cv=none; b=W4B9RZ00HAnTqT/ZVo5QUSQwRI8quFrI6n+q5b2HoCtQeioqKCaPUPRTMDqEpwEhIbtrCRUGgfqnrBDdrv75+i6gfAbG62JyPT9oySxOUz5OVi0G0CTaPhAzKEiyFkcuhTTt0G/Qde+9OGDnuzonCBCg4GG+fPjuriGwrMq31mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277423; c=relaxed/simple;
	bh=wCpLSEqzl6yoBDde9p+VABZfQUJK0dP0DnJmF5kRzKI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gCQqytyWsLp/arsIj5nw3z1HWNQvFz5aJwzWgUizYOy5en3zC3hGbYdZouotdXZxaX7WUBb1HaBTvGb5gGfAYUe/2CqZwIUxsptdCvCla9iLQOgtIf1Qq3Y2+y3fZj/sIX8SHEYwbDM2JQz8pbKDvvk1nj761lCieuX+BqkYUdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gg2fIu34; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jDSGykyt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gg2fIu34";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jDSGykyt"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H6cP4Y1018919
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=; b=Gg2fIu34xbbfj8OA
	dt19v0TaKmCyNsqs1YXGX7b6eNdZXjJpyQTH3J+wxRO0uaqueezvw2w+9RN66Hv6
	W0l5WJiq4/+Fc/Gw0EeECDxVVZgNAfn9qlvmITGH1WSo1zC/V8KGQZePH7QP+Euc
	PoQDNM+uejTuTxKAutrzpDyZv6hp5x+3VipDRd+ZtPDOa3GFHhTGE2OHu8jNSBcz
	JqqY9Q4b/HSpOXmyilpPDlLW/H1jKCMSPKi3hOjhBoYcJTFISAqnXQYKCzpR1apb
	pc23HN9Z0je2WjjX8uoaCCthsOwq2yUPfD70OOcnE188xLMx2j9bhgIUTNbjHo9w
	7x4KhQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fff810f99-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:58 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c12e43b98so148838091cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 01:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784277418; x=1784882218; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=;
        b=jDSGykytLuGsQOWbcfKmiAqj6/98uZJixcJTQQ4+iECwUfxvDL72Zjpli9wb6P6m20
         XI0j9PtcNK7XyigxmtCMr2jWQkk3SVHCxH3+9dMCS66MLkmm8IL2YG01jK4wDGg2Nqm1
         85OdDAPdgQBTkA/a1n2mOoOz/UDgrpiv84iQv/Mn4Dhn/eJT9KcfAIb3nRPBtJV8raMp
         PpAAyxFDBYhctpbinWrNbEgygohUyszTDF7nSMPYqcjflZgvcsg/5YcgRbT/28Z/zftA
         cmZO8na94nq9T7S27waBo8JLs73h7AJJwhMlCwAJEGZlthBkWw7suPIstwrqWWwh0mEo
         k5fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277418; x=1784882218;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EisVJTTfRpbffhmQLHO5RqC6wDH0dg02BTw4k+UhwPA=;
        b=NDhJfy9OHDHl2E887jU9WwPZvlTC6OUYWolHuwPGy6KtbU1+2dBsL2OI+NCyah034W
         Z0SIQtKarjGnXfT6YvFeV0OmXQNGdJSkSn9C2lDqma0jRACoicdIVZbLa9svJ84K7ynL
         cn+nWIw9J7GCsVzqv9EwhXCAbgYqhYoXFDMOfk5dREUrZgCc0KMXiITS/vse3Dyz8kfv
         T8PAGSJyd196ntUdzMgdsG9zy8VBxPf0u7NKtTXP9aqRfxW5UqvZ5wEn4GDJaF3rmEhz
         cbZKIPHolYf/OH59OrlNxGx3cjCe/OQKj8rSWQHomM92rba/QX9YIo4vUYpDsJ+d32ua
         lhCA==
X-Forwarded-Encrypted: i=1; AHgh+Rq5N6APPvhUVOKYWunhlJZt6jmCI/SfBavzo8+Et56LmGEEHmezo890kdgAEtmVypvPqVgvqYYzPxcsrpw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzucf1FWJHNgxNn5aiSQGz7AcObuF9DDdMTAYAoPIi2amv7mVrK
	s0uRDv9DNdKllkldkHtQwTiFyZR289uIl/fI0A4Chk6LvP3r7oe3HkU2dwNpMrr3yoXQRLOFl86
	3u4KzUEjFdy2se57+jdHHA8ee/7pei3hDA1qf76FUXWmVULbijlBJAlUJHZGAknCrjmM=
X-Gm-Gg: AfdE7clDlEtI9mjAklCTFaW+opGiHlFG/GXU0LKYfAEK0+ZmsOjVQ9EawGlidUKDEto
	ikcRiGT8GJY0ymGn0KKy1a8yt8IVz5tAKOL9goXudTz6Gst8fWhiTF8c9sS7HiPY08vd7vNWcnl
	Yv/G1t3EvzszzrsPM+gjOGXdTxG7AkYku9kX9TRDZyUjEgvfjQY16fSB3PgVJu//jszlBPEZTJp
	D6BimQ/lzFBVGe/nONKqXOGZgwGIlL7j5CFwGe9EkqLMd9KIXhycd/4brDdWgOUIU/PPiFcZW7W
	52KNK8JYjKNQ4uFdybcsosAdqMGt0FuhUMe3+npSxboE3I2OjmzTfq3UfIM8EaMOSunsYjnkEYh
	jha2/cKNk7hHe33vn+6gRPcL/pwACdQ==
X-Received: by 2002:ac8:5895:0:b0:51c:7b13:62ff with SMTP id d75a77b69052e-5213f07a839mr12223871cf.85.1784277418445;
        Fri, 17 Jul 2026 01:36:58 -0700 (PDT)
X-Received: by 2002:ac8:5895:0:b0:51c:7b13:62ff with SMTP id d75a77b69052e-5213f07a839mr12223541cf.85.1784277418071;
        Fri, 17 Jul 2026 01:36:58 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2b893dsm31268205e9.8.2026.07.17.01.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:36:57 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:36:29 +0200
Subject: [PATCH v22 03/14] dmaengine: qcom: bam_dma: convert tasklet to a
 BH workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qcom-qce-cmd-descr-v22-3-ff0d18b27246@oss.qualcomm.com>
References: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
In-Reply-To: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4421;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=wCpLSEqzl6yoBDde9p+VABZfQUJK0dP0DnJmF5kRzKI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWemXqINjgp7q9Ps4aTCpU63x396zfX76ER0nL
 PEUXHbq54yJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalnplwAKCRAFnS7L/zaE
 w4BYEACodtihodcjAOmf4SQNdnKJj1MDtzmr8CduDo0LVP5xpzBN4cW+Iryn04rrnH/7NLN7Dnc
 THDrA9/smhqXo3ox4l7Sp3oqC4KiMfPnwM/SkUsLtAmc4l96ePvFCy9VecYiEUjDIvcJ41wNSPV
 e56uyXLkW1JFg9xhYlmjehYbNr2eIYdC3VE9IlbCaqAjL7QkFiJQEmMQwCzQ3SlaN3l/k/s4t4K
 xAhwMLFuZUyF8Xljr7e/f2PUzgVeW0iY6mfvSB2w76fAzAsIS+L5pqfg7uTM4N3wV5DaOAXldVY
 ch9TkWQEau4Enf/FhO8Y+ZDA88mCgKa84UPTwPhtYDruA9jyEcOLJyrf0z1xWPSKSDvhyxq6q1P
 tdBbDWh/zNVJ1ug7/WdopaVLyYI8dihiP5SQpXLwRcaNVonJPPB+QP/INL6Ov+yXqTyZ3iVOclX
 a4fSVoqeUgShbEWjqTLIZMD3V+YpQJ7b9gkXjV9izBrjaXkpVljZzC174JGiAszUqWPMST7fT5A
 1CXdtM2l+1MiOBlMUFjYLXm2f2Jse3/jFpQ/deP+gji2eqJsqlSYJopJFGmX9B9KrS692ZTs4gi
 mv1HBdmH+Fl1lV8BZhUbxZJ3gwyDuoA4CkNIY9zbtOABg4YD3XSP0JVCGB5/v7VesiSU+ph/tzR
 x5FsRWwlnTOMvBQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=RbqgzVtv c=1 sm=1 tr=0 ts=6a59e9ab cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=u-biHsxzOdRIXVMzAPsA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 6UkPJXBDAaGXpZ2AlXshXOeQZ9RICRoB
X-Proofpoint-ORIG-GUID: 6UkPJXBDAaGXpZ2AlXshXOeQZ9RICRoB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX62tcYdHJygoX
 F2zaVQ2IB3mJCuOWBbv0TjqfXqSpSrY0LxdVP7yYS1aXkqJIBKMElSW7M27LhwIi7NTM3liP6sb
 eV+iDU1UgGEMmUqAEXGf8SMYrKdTkST6rbHJvMBsDPRuTe4e/zc9B0qs3dd6DuM13DOiJt1z4xj
 3jXL2V/1CSBQup220Oa81ZFdMt4Qm6RwCL3H1C+1QDODXWaqAnNSpmHX5wXmLeuR5ZLq5+rrD6f
 dkDrS39pVv55DQDywJ8sVrNK5OGaep/ccRtS7ai+RovFA62v3nlb9vSE1KcZFToLs/5UFiP27DH
 iBt2XRBooH8HJrP+WWXwVCsMIcvNPJouJQPesJjIOOrTVwkbJI97880zzjIagpPHSYdIa3xFK7G
 SsvgZeNMuz22LxE0SEN+D8mk/vafnmFH38Mu85TuakKVgWcWDnNfsir1hHSlc7NT5g2lwAiDWQi
 iPo4KTG1smKTXtBC7kg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfXz5V+ccZuyuBL
 KxpF4lL6PjNrECaQUOEc2jIOc05GFiJ/MK04oEv7UOLNbioYU4l4eYSO/tV6Nf5hwxNPhaFsgGS
 Y0vi+PeEiA4zaQzJopDHn3F0rYS6ims=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170084

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

