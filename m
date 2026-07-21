Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6CD37107F
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640837; cv=none; b=L8E6sOzEGPkMBXTZ0iV28PCrqI545vlQqgzzpz7EJuy+qOdv5bcHXCFZ+n9Ozjy2goU0w+ms2/9Rq23fyA/r0mYRDqCdv5Lm+8G0raXPo4i4RzN5yhbkigqnG0afvom35J71hfMvDwLrpERy/eSKBCHegT0iw9CvZrxS3cij7a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640837; c=relaxed/simple;
	bh=YiW3qmc2mOtsaItbp0NiyBvoZYe/pqkuxa7R7znwr1Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Vb5gT4aX8QUPhpC9gUUaZgrpbIT1Rd2esGS7WXXqfcGJIlNRmj7/jr+K4zzwkW3tMzz0H4eRR7lF+Ys7Za1ncy/Wbur45X+8a90guuCT3fNx+Ql5CjEaLonaU22rYvQ19+p4o68efp0Oxzyz2ZcGdMDPwhtQpCf3+FoiDx4Hs+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y8bxfLNv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VFcb3Vac; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y8bxfLNv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VFcb3Vac"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDMC9d1910306
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P0284kFkgULwQK3uLI/K7mHkOyXRENvIYssbFUalZ/Y=; b=Y8bxfLNvlXqpbcRb
	e/Zt52eHfD2PTW6j3x6+O9lQarWLnI+6ueiwjg6TU4Xeb67bhgW1/cJfQPGPFCoI
	dOYAoJ8QU8Z1dCGlJ67L8pcHy4WRWav5ADWqgip+q+Sje9qmSql7NiyfjYVWxwob
	bTuh0GuOOuXTki/GAvXuYk2/CKrz0GBlkWmacelPnJChKEirvOABFKhszypHqOU/
	HRd+hjzGInuriXe9eKRrsFAsxUFSQ62H4sWb5mTZ7WPHByezEmka2UPzs6Zb+k1i
	GDP3uECSpD06V72BkbwLTyr9Wfj5Q+YKS0UqG//TA7Kg8FcGHk++PMrGADC/UOO8
	bI4XWA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj1bvtm2k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:33:54 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-520a00c7a03so132432791cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784640834; x=1785245634; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P0284kFkgULwQK3uLI/K7mHkOyXRENvIYssbFUalZ/Y=;
        b=VFcb3Vac6Vv/xd7T8ypJg9az4+/hmlEsoZuChEqYDj0E68RcvyqATQg6LyO9pqOj29
         o9aemJ/1m45nVNr6y/GlaHsMEkll3VnBw5lke9z4YKuzqMja2TrKmpj51IHry2LC+Dho
         kCd7SQrfVjl4MgqT7cn8UMCM4EG7SM6UPIKPrqP5wMqIen1pGNZ3KyuIZ8TvnEaTQv6y
         bVosYf8mPm9Ob8fFa15ss/082eVaVUtzUL+nQRvK7lAWywgEdNnohXAo2svs1K+yx08N
         PMrdXNo8q33GPMq+Px2ox/s4j1vsJKKZRVTlZgL0Jbx+lEi/bXkPTuEPRg+8GBTnUy5v
         lP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784640834; x=1785245634;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P0284kFkgULwQK3uLI/K7mHkOyXRENvIYssbFUalZ/Y=;
        b=OBol5ouIq4jfXRW9Vvc9Jyil3BQCEB7IC4UGM2QKHSbiKfbKpa3qnHilsGgFkxc8O1
         H+Dum9lMfLOXccKNq5RB4BY+/ZpwhDHUi6nwRfVg3kOBiMvurAxEPrqXNYxyxGCFOVjZ
         7BnC2Dm15ni5coTFnN1Jw3cZwNKuXeUchIkkDg1fPwLHehJpe98hT+s61iyJobP/F61h
         lhdBcj4LisECtbTOhjoxiUQXybgY1sw8my0wI0HpAGHK0JnD2o4NZQ8icOxfKBuDb3sn
         HnZe1vezKaaJohWsHdZd5Ko2E580n6wbgPnUXQ+BOpOmr3wuwOFeWZWMaUSeLFbVYlq9
         7aIQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp/E1hsuMX/h0MBlpTmc31eBo8+zOeMTRoTkTlDcwgP8RVJPLwBknvtakywssXXQAj7i15i5GDvPGoBEZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNnoLSxmCXZFOt25VPfdabX1zYj+qyfoehj1L7E6WRizRfhle5
	XIvw8GwMGkmM7Pvkb6xYLsuEfy7EtoGv1CaWtealHdNnSdxd6ULAlFgq+eqvTXhyua/ec4i+Jsl
	8f37MRnPE8Lu9vTDFjHWK0HxRZtSR4nKji+fkZBIvZ6nA+lKiLYFZQ2YBNYr/enVYZMg=
X-Gm-Gg: AfdE7cmP9xqAF/oKLOWLK5ZSmiBKnPTS/K9sbaBibEmaSxrlDQla+vxgykGlAiLFNlR
	x9qcnVtcz6Upc2YG3NHwSMBLyXuAB/L2FH+5ykmZzUSADWlD/iNiZQgTYg/sx/JYDKJIIpgl9LQ
	3F6+IM+DM01cVuOy1Og5Ch8iixV7d+yB8DG0KbEiOZaDKw0949VaJ5/SvDydtMGZYA2VXmQ0uQV
	oScBFWhvjoNnz58SV46xj+4A6CHWdm87w6gHZqd9eX/eZRTUT7PDCT3KRyGzwReXutD7fOED6Ss
	aSV1XBIyHEuFME7e52LVhtUCQbMDnpj9KjTsC5gNAYOpAbzErIILOLqsv8kf+WaPymfgjgK5cqf
	o8FjzfdzIYsD+CZRym5di05I16ZtENA==
X-Received: by 2002:a05:622a:5d1:b0:51c:7b11:41a1 with SMTP id d75a77b69052e-5213f46e365mr172088841cf.78.1784640833677;
        Tue, 21 Jul 2026 06:33:53 -0700 (PDT)
X-Received: by 2002:a05:622a:5d1:b0:51c:7b11:41a1 with SMTP id d75a77b69052e-5213f46e365mr172087981cf.78.1784640832717;
        Tue, 21 Jul 2026 06:33:52 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:9dcf:9ab8:bffb:ec35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495499d1d4asm237901185e9.2.2026.07.21.06.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 06:33:51 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 15:33:11 +0200
Subject: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-qcom-qce-cmd-descr-v23-6-1be02deffda9@oss.qualcomm.com>
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
In-Reply-To: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12048;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=YiW3qmc2mOtsaItbp0NiyBvoZYe/pqkuxa7R7znwr1Y=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqX3UjLElhWTC6g3ku9JMXGJpRfNs7QUoQcmiGA
 bDqUdmlo2eJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCal91IwAKCRAFnS7L/zaE
 wxHgEACkKwGsmgWPjnKHfj6w44/GG8+vN5jMiPCmG6rdf9pkNvmwoSFToGZ3BkxRv332n/N8iOm
 S2RzN1GvNEqn84uFd+nRL5cuk43IYKiIEFI+Rv8mjH5/776BQNLuPzaO/bp3Ic9pqQ4TO9DIt8d
 hnibt2z5XNj1BNUi4hVmsO8jhj9FD1vDv8iOpfzPYfzM+sc2OzuFN9HETm7gCio575pgpbfGw0M
 6NvDGX1KzooySpXB8Uztn5mgOIWkfFM59ij7GLWVcb6rzToWuLVzGTVyPihJXIPbEgHmysigPg1
 2d/vqrxDUqnCefh5QAYMalWs9rgpA4jM2NPg4X5aTP0Zi8pywwqf14TL0svgraZGmXozzxHL5I/
 v5fjjFRwrZDERt1egTBfifx4zGtgjqudUddTb0KrzdHTcwBsVto1RaGjmaJeZLLZXqwR1Kng0XJ
 pmIIMlNvikhj0P0Ce32Jd5xpStddlLpREEjKfMH2oR5mz+iL0t0SL888jerIowSVCar963QmNkq
 j40t6wJPKuG5E4/t0+6nCksCN62Zb6oyUFfC7fKxswoBcIna9psT1aDHXzI2pzqvSgOhIhmOAgh
 35eI9DSeWYNxSFihlXpek99rsjbq/xhYDog3srwcy/25hdDnKA6xs8UKY+NTaUK/LgtMN1iAYDj
 w4GS/Ee4I9t3YbQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: KoWUP4JeO6ibr7HQPhqK5cx6MmVD-TvK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfX5NMjBMicmdaY
 C3zv/eaBqSNdwHyDy7+ZvYLcDZQ1m652WpKqq7iTFtgHHeXXZdsiqVpoUmscuqPK39VQkBwX31u
 PPmDU+urAMa8hvjpp4xElP88V1LWXRQ=
X-Proofpoint-GUID: KoWUP4JeO6ibr7HQPhqK5cx6MmVD-TvK
X-Authority-Analysis: v=2.4 cv=Sb7HsPRu c=1 sm=1 tr=0 ts=6a5f7542 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=-0mtKZB-VTZit_Rp23UA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfX/ZP9Bvag6P5+
 feoT1FT6Dtk3z8sZIyLUSlRBIQMa8RPU8j4mNcz0aRw+w1r/VdOZBivkVV0vSyu4bXBBeZ9BLxr
 BKD5DU36AveNke9MOP0FadDWvjZ/IF8W7Yreffc1iJSYGBPbmt65ra7Znn9e1iadSu0/73Wn1iz
 irky5Fi8QHxnfL1CjnLCL/57UCafZwSjXnFoWweVOLjqwFraZhW2vI/Nh4CZQ8D3ZmX0NSdzhC9
 vnX/wMrVB29/8XBa8jelV/GfZEUvQ5AqayA+xCMGp5LqtrdEhZbj0mYzquiOlllU4hzdgqR5LfR
 w30uHYcXONBGZTPaIlWgzlWotENH8WTVlEi96S3t1QpTfIqoYt5l1L5kFe9d7FwVAWCVZRDxsk0
 HRW2rIwvFc+ciJ0qDlQaWFyH3Mv3dJHnlLq7Fxo+Vda1fcOMSs6vMQP+9tFgQnEwhpfxvz1YthA
 Z4B7uZXg5FBzp9/i5Hg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_02,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210144

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
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c       | 173 +++++++++++++++++++++++++++++++++++++--
 include/linux/dma/qcom_bam_dma.h |  15 ++++
 2 files changed, 182 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index f3e713a5259c2c7c24cfdcec094814eb1202971a..411c60c4433e21e202847aa9182163a56df2d97f 100644
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
@@ -72,6 +76,11 @@ struct bam_async_desc {
 
 	struct bam_desc_hw *curr_desc;
 
+	/* BAM locking infrastructure */
+	bool is_lock_desc;
+	struct scatterlist lock_sg;
+	struct bam_cmd_element lock_ce;
+
 	/* list node for the desc in the bam_chan list of descriptors */
 	struct list_head desc_node;
 	enum dma_transfer_direction dir;
@@ -425,6 +434,10 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* BAM locking infrastructure */
+	u32 lock_scratchpad_addr;
+	bool bam_locked;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -638,8 +651,10 @@ static void bam_free_chan(struct dma_chan *chan)
 		goto err;
 	}
 
-	scoped_guard(spinlock_irqsave, &bchan->vc.lock)
+	scoped_guard(spinlock_irqsave, &bchan->vc.lock) {
 		bam_reset_channel(bchan);
+		bchan->bam_locked = false;
+	}
 
 	dma_free_wc(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
 		    bchan->fifo_phys);
@@ -676,13 +691,26 @@ static void bam_free_chan(struct dma_chan *chan)
 static int bam_slave_config(struct dma_chan *chan,
 			    struct dma_slave_config *cfg)
 {
+	struct bam_config *peripheral_cfg = cfg->peripheral_config;
 	struct bam_chan *bchan = to_bam_chan(chan);
+	const struct bam_device_data *bdata = bchan->bdev->dev_data;
 
 	guard(spinlock_irqsave)(&bchan->vc.lock);
 
 	memcpy(&bchan->slave, cfg, sizeof(*cfg));
 	bchan->reconfigure = 1;
 
+	/*
+	 * This is required to setup the pipe locking and must be done even
+	 * before the first call to bam_start_dma().
+	 */
+	if (bdata->pipe_lock_supported && peripheral_cfg) {
+		if (cfg->direction != DMA_MEM_TO_DEV)
+			return -EINVAL;
+
+		bchan->lock_scratchpad_addr = peripheral_cfg->lock_scratchpad_addr;
+	}
+
 	return 0;
 }
 
@@ -802,6 +830,7 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
 		}
 
 		vchan_get_all_descriptors(&bchan->vc, &head);
+		bchan->bam_locked = false;
 	}
 
 	vchan_dma_desc_free_list(&bchan->vc, &head);
@@ -859,6 +888,16 @@ static int bam_resume(struct dma_chan *chan)
 	return 0;
 }
 
+static void bam_dma_free_lock_desc(struct virt_dma_desc *vd)
+{
+	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
+	struct dma_chan *chan = vd->tx.chan;
+	struct bam_chan *bchan = to_bam_chan(chan);
+
+	dma_unmap_sg(bchan->bdev->dev, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
+	kfree(async_desc);
+}
+
 /**
  * process_channel_irqs - processes the channel interrupts
  * @bdev: bam controller
@@ -870,6 +909,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 {
 	u32 i, srcs, pipe_stts, offset, avail;
 	struct bam_async_desc *async_desc, *tmp;
+	struct bam_desc_hw *hdesc;
 
 	srcs = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_EE));
 
@@ -919,13 +959,19 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 			 * push back to front of desc_issued so that
 			 * it gets restarted by the work queue.
 			 */
+
+			list_del(&async_desc->desc_node);
 			if (!async_desc->num_desc) {
-				vchan_cookie_complete(&async_desc->vd);
+				hdesc = async_desc->desc;
+
+				if (async_desc->is_lock_desc)
+					bam_dma_free_lock_desc(&async_desc->vd);
+				else
+					vchan_cookie_complete(&async_desc->vd);
 			} else {
 				list_add(&async_desc->vd.node,
 					 &bchan->vc.desc_issued);
 			}
-			list_del(&async_desc->desc_node);
 		}
 	}
 
@@ -1046,13 +1092,100 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	bchan->reconfigure = 0;
 }
 
+static struct bam_async_desc *
+bam_make_lock_desc(struct bam_chan *bchan, unsigned long flag)
+{
+	struct bam_async_desc *async_desc;
+	struct bam_desc_hw *desc;
+	struct virt_dma_desc *vd;
+	struct virt_dma_chan *vc;
+	unsigned int mapped;
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
+	async_desc->is_lock_desc = true;
+
+	desc = async_desc->desc;
+
+	bam_prep_ce_le32(&async_desc->lock_ce, bchan->lock_scratchpad_addr, BAM_WRITE_COMMAND, 0);
+	sg_set_buf(&async_desc->lock_sg, &async_desc->lock_ce, sizeof(async_desc->lock_ce));
+
+	mapped = dma_map_sg(bchan->bdev->dev, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
+	if (!mapped) {
+		kfree(async_desc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
+	desc->addr = cpu_to_le32(sg_dma_address(&async_desc->lock_sg));
+	desc->size = cpu_to_le16(sizeof(struct bam_cmd_element));
+
+	vc = &bchan->vc;
+	vd = &async_desc->vd;
+
+	dma_async_tx_descriptor_init(&vd->tx, &vc->chan);
+	vd->tx.flags = DMA_PREP_CMD;
+	vd->tx_result.result = DMA_TRANS_NOERROR;
+	vd->tx_result.residue = 0;
+
+	return async_desc;
+}
+
+static int bam_setup_pipe_lock(struct bam_chan *bchan)
+{
+	const struct bam_device_data *bdata = bchan->bdev->dev_data;
+	struct bam_async_desc *lock_desc, *unlock_desc;
+
+	lockdep_assert_held(&bchan->vc.lock);
+
+	if (!bdata->pipe_lock_supported || !bchan->lock_scratchpad_addr)
+		return 0;
+
+	/*
+	 * Allocate both the LOCK and the UNLOCK descriptors up-front so the
+	 * operation is all-or-nothing: if either allocation fails we free both
+	 * and run the sequence unlocked rather than leave the pipe locked with
+	 * no matching UNLOCK.
+	 *
+	 * Both are queued in-band around the currently issued work: the LOCK is
+	 * prepended so it enters the FIFO first, the UNLOCK is appended so it is
+	 * the last descriptor of the sequence. They are loaded together with the
+	 * payload in a single operation so the engine executes LOCK, the work
+	 * and UNLOCK as one ordered batch.
+	 */
+	lock_desc = bam_make_lock_desc(bchan, DESC_FLAG_LOCK);
+	if (IS_ERR(lock_desc))
+		return PTR_ERR(lock_desc);
+
+	unlock_desc = bam_make_lock_desc(bchan, DESC_FLAG_UNLOCK);
+	if (IS_ERR(unlock_desc)) {
+		bam_dma_free_lock_desc(&lock_desc->vd);
+		return PTR_ERR(unlock_desc);
+	}
+
+	list_add(&lock_desc->vd.node, &bchan->vc.desc_issued);
+	list_add_tail(&unlock_desc->vd.node, &bchan->vc.desc_issued);
+	bchan->bam_locked = true;
+
+	return 0;
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
@@ -1064,6 +1197,7 @@ static void bam_start_dma(struct bam_chan *bchan)
 
 	lockdep_assert_held(&bchan->vc.lock);
 
+	vd = vchan_next_desc(&bchan->vc);
 	if (!vd)
 		return;
 
@@ -1072,6 +1206,24 @@ static void bam_start_dma(struct bam_chan *bchan)
 		return;
 
 	while (vd && !IS_BUSY(bchan)) {
+		/*
+		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
+		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
+		 * already have bam_locked set and must not trigger a second pair.
+		 */
+		if (!bchan->bam_locked) {
+			ret = bam_setup_pipe_lock(bchan);
+			if (ret) {
+				dev_err_ratelimited(bdev->dev,
+					"failed to setup the pipe lock, deferring transfer: %d\n",
+					ret);
+				queue_work(system_bh_highpri_wq, &bdev->work);
+				break;
+			}
+			if (bchan->bam_locked)
+				vd = vchan_next_desc(&bchan->vc);
+		}
+
 		list_del(&vd->node);
 
 		async_desc = container_of(vd, struct bam_async_desc, vd);
@@ -1133,6 +1285,10 @@ static void bam_start_dma(struct bam_chan *bchan)
 		bchan->tail += async_desc->xfer_len;
 		bchan->tail %= MAX_DESCRIPTORS;
 		list_add_tail(&async_desc->desc_node, &bchan->desc_list);
+
+		if (async_desc->is_lock_desc &&
+		    (le16_to_cpu(async_desc->desc->flags) & DESC_FLAG_UNLOCK))
+			bchan->bam_locked = false;
 	}
 
 	/* ensure descriptor writes and dma start not reordered */
@@ -1191,8 +1347,12 @@ static void bam_issue_pending(struct dma_chan *chan)
  */
 static void bam_dma_free_desc(struct virt_dma_desc *vd)
 {
-	struct bam_async_desc *async_desc = container_of(vd,
-			struct bam_async_desc, vd);
+	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
+	struct dma_chan *chan = vd->tx.chan;
+	struct bam_chan *bchan = to_bam_chan(chan);
+
+	if (async_desc->is_lock_desc)
+		dma_unmap_sg(bchan->bdev->dev, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
 
 	kfree(async_desc);
 }
@@ -1384,6 +1544,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	bdev->common.device_terminate_all = bam_dma_terminate_all;
 	bdev->common.device_issue_pending = bam_issue_pending;
 	bdev->common.device_tx_status = bam_tx_status;
+	bdev->common.desc_metadata_modes = DESC_METADATA_CLIENT;
 	bdev->common.dev = bdev->dev;
 
 	ret = dma_async_device_register(&bdev->common);
diff --git a/include/linux/dma/qcom_bam_dma.h b/include/linux/dma/qcom_bam_dma.h
index 68fc0e643b1b97fe4520d5878daa322b81f4f559..188f667cad9935b338489e41e6dd03e58166ef9d 100644
--- a/include/linux/dma/qcom_bam_dma.h
+++ b/include/linux/dma/qcom_bam_dma.h
@@ -6,6 +6,8 @@
 #ifndef _QCOM_BAM_DMA_H
 #define _QCOM_BAM_DMA_H
 
+#include <linux/dmaengine.h>
+
 #include <asm/byteorder.h>
 
 /*
@@ -34,6 +36,19 @@ enum bam_command_type {
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

