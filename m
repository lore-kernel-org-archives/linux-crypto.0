Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744323A168A
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157501; cv=none; b=PBuUvZ6p+wn+POKMW04mbh5BeOxh+yQuQkgNt4PjJzY73VVTjEjxTvjKScWXWNNf+T4aGdvtyHfSSQsu0cLLXjKDpN1poLVS7foAePaNe01jxgoDr/NdWDF420RBgQzDWDSUr0jEm8RzG4g9aQgBpPzuPKfnW9WO4mYbImIzFbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157501; c=relaxed/simple;
	bh=elhTKwJOdnH8ShS2ww0C9I/XZ+2m164JUZdN202a2VI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dn1oxeSLI+bZ532p0TmE7QY7efLFYNFrs8t09N9LwF5liA2/m+6EjXYb06HvyROQIVFgyEpy0LI93hluQOa0NImc1suy4fxCiMJfAXGKvhFHHnqhT10MCwVsKwC6PeAIxEXwxlPFBiX/BK6A66PRljWhcFOvy1NIkrsMUCygo0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gVAbF12O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DUSQ+90K; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gVAbF12O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DUSQ+90K"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaWhR2861986
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KN20Si9oKhQSEQiwsnBiXWUeYCUJsC5pN0vFqnC/K4I=; b=gVAbF12OUhHS7c/R
	uqCr7/dhqU2UW+QqLngu0W0ZTlEYZJ7ES5xJffCjn3OrGpcz7lkb0gOAj0Ie/NV+
	QdlcmojHhxXMOna2d3Nxeh847KAe1v1QE9XK5YDFVxrmtiPXpIruds2zAczlIZVc
	uido0z4zoV7XeiQ0BAIlWC4eTy7uFcjVUMF5KVxcClJQG9Q3lhe2Skt046LYH/Nv
	ctj508B4nIAjReoPdTeTRlyFPgM4s9ZEEuSkSsjEwQ4Abs27T/TXEyUVCMpIF+g6
	V5PYE/dml0eJMlEJEhWXXT8Ec7UqNy87rZ9Wr32s79vcKxPiO1XLb5Z+qk1BhsxR
	ECOUJg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cte3wa2gu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:58 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cd84943c76so5764685a.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773157498; x=1773762298; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KN20Si9oKhQSEQiwsnBiXWUeYCUJsC5pN0vFqnC/K4I=;
        b=DUSQ+90KNUcx8wZe+k0jqcyZjisMq3KKBOesaAMNgC0C+Ke3Vhv/xv1abaL6kWIDJJ
         oEB3ZxAtmsWyvb4mRt4wawuY3z77xc5Ya+MHhSAGou7KQjGmPH82TnOFnm9lhisxPrIc
         5qzz9mc93R+hJ8DwGQMkQT7NNyC9eipgtbO7XpEqdPW00tSKw4B+DpUSz5/H/XVxFC75
         SeRS74UGei/Zqg8w7LNjGlg6dYXvzSLahrDkm/5BxZfN+7jcnS4LdoSSKHu1qOtbKZHt
         682yfj/HdNU/+5WHpJq4hXj/faOOjN+NCrcGKSpReZ8XaBC03/8kDwK729FNND1xmT7V
         EV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773157498; x=1773762298;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KN20Si9oKhQSEQiwsnBiXWUeYCUJsC5pN0vFqnC/K4I=;
        b=uwHoiYfHq6EB5bqUsbYeWB4EQb7+CEN4R+D0wojOmDx63o+bAMRknZuLNPRy3kdwfk
         eVUdm5QHR1R+24aXSa/e94Z8HQr8BCKSdklMnQUas+RCGcBJHPUhbVNXzxoC5c+HE9C4
         fexygdw5qFpRTvT0f0AUtfQ6NsOokq0sqH3e/Gbh+OLxAnpdHZmnQGBbV71nt6k0qMoq
         ZnLYUZWCk4eLk5wQ+BcAYfJuggduHh5wwvpEAx8Meks8UZlkgTyXasr8joxb5x1s6Y4g
         jUeE98O22nq/IcbHu8n9YNjhyq5mbOXFTT1BnraCpdf5iwE7miiMaCpzDDG5sVa5UQID
         9vgw==
X-Forwarded-Encrypted: i=1; AJvYcCVBStzyfcAlDEew5E34bdA3xzkEWjNgLUapnMCBVQeiXs5E4WVaAhSufdjal2CnxKKNK9ulCqTYjpvK0Ew=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUze07knvek8qOt5bUCXdTAPGAexr/JVcU3KMdyQdoUo7c4o9v
	k1GKZFGyXfKIn4woKTRx+4/UD9+IvghoLPv/lAqwwZnZB44rJ9EuNVUoosuLlEK9nOQepZOTutD
	gGxxzaTmhjnIestValmrVecND9V38fFABe+TDJb7c/J1U8y5BZbEwiPS3lSCsIJ/TNtQ=
X-Gm-Gg: ATEYQzwJvGQRzCUHNk7CKXjZF34o9iB1he6o0mSuUA4VP1+3qKNqHNdJgEgtqepJFDn
	RTENavj7Bn3oWN5LpgcuCOZeyT5Fhhm/oL7zTAj6PvYCi0Zl+yellcWCOBwDjsgNJCTt5CdA2+k
	M+nmGWpiZAtM2Mxq4ikUXeOEyJb0Sc7TwnIjPM7Ew95ef6u0PSxJupecuzFvXXlzIu0I9DS/rqi
	jypDHpmpi2DRJZo+NflWOVphepuc/1e55R3j2NmgWlf3H0bD0TLDoazv3FtOX/02WgugKevXwZM
	H8RRxMaOJGM2xzr2mk2tC/PYPCve7f41R17nPwPxGgHR8lktXcPj1XHPxBP4UEWgCVX/CSkxyA3
	rLTLIsSx5DYLMX/EuGVMzliL/EJpNHljMZA7Tu5Yxn2j8ZN0pucMw
X-Received: by 2002:a05:620a:890b:b0:8cd:9584:6340 with SMTP id af79cd13be357-8cd95847345mr17426985a.43.1773157496080;
        Tue, 10 Mar 2026 08:44:56 -0700 (PDT)
X-Received: by 2002:a05:620a:890b:b0:8cd:9584:6340 with SMTP id af79cd13be357-8cd95847345mr17419585a.43.1773157494902;
        Tue, 10 Mar 2026 08:44:54 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:47e6:5a62:7ef7:9a28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8d968sm35991600f8f.6.2026.03.10.08.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:44:54 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 16:44:19 +0100
Subject: [PATCH v12 05/12] dmaengine: qcom: bam_dma: add support for BAM
 locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom-qce-cmd-descr-v12-5-398f37f26ef0@oss.qualcomm.com>
References: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
In-Reply-To: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9496;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=elhTKwJOdnH8ShS2ww0C9I/XZ+2m164JUZdN202a2VI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpsDxk9TY6tPxiPsXw43Ve+PSIj4tq2H5V4JJJb
 yw1r7r9dzWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCabA8ZAAKCRAFnS7L/zaE
 w4x0EACxKbLwWH0BU1Begt8G28jzTGiJxEdXChvYM2Vr4aOS+ELPeSH22pJI6xxN46I8AvnwT9e
 xkONLqCR3ucI/p3eI6zeAbogxfPibrQKr2wlfGSOz6U6ILPwz4A+1KHOFlSQZBwSr+yxIehYeJL
 RNgWeQWMNMl/sbDf3QPr7sfyzAU8N1csgNyQLY3OeceiuJJvIqcrtqa15I9RXRg3j2fE7t0Qhn4
 8DtbpfMnAS1/uIyNKGSV2Vy4I81xyJQ+G03K8OsSe7cb6blFiupG/eX7I8iVmkvFIDQPtcalYPV
 WAww8lwySoQThKBHS7xChrEfqnTIuGtdUPYWtogcH/VSn+CI7OIT0ntZHC4OazxBctlh0aDt8wU
 tx7vFhWXCbefEFUeUtUlC9+vDkD34YvqPcnODKsDPn2B5akFGemLqVoqpZ6IzsUPlVO59Rqc61w
 O9VBSCXHVJmyAaNIsO2+/QO/cxHdGwEBkqrb4nyUKGKaoy2VUwlxHFAtS+rs/5s0WP/JnyXdYQh
 WgyNnW+UkJiAuVBJp9EpfTkhb3Jwa9JQoRMlxpnvepO2GLf5R5Esx6UAMWoeqz0EQFD8MREMMVL
 eD9bZWyqkS97qe+1SHhhfczOHegXdXi7uMIa1m4PPQzZ4GLD099CqVo7qLwT7kpHVDvtibkN4ZK
 7gaNLWok5bCpXJQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzNyBTYWx0ZWRfX60rqlDq9O6k4
 7jnHS/2kPwqGAmO+eI5NEYEUukQKoQHgu2KJW7EEUV+E57GX4beAo7MX6wNTRVcfYVGrbOHchh2
 z7gfwsqNK1VMapHfvo2fIWxGDUpPVpvqL+Cm1i1M6V/yP8g2aBYdM5sHa7wiJeindFvn4MZS+Jq
 tnpScc3yYObBB7qs7BkgY1fLbE3DDn7RJBAgquSDIDySPBfczr47qUjJAlwGdGttcyU7QHqaMfO
 j6kSUIDDpeYTJkqXqXkVVYqn8dXRuGZHcfZxwGgPqiJejzRtO7E34vTwd2dG5naPmOaCldnP50k
 VnJRSEhcKEE72WJmijWXyOELarN2vBWswMRgquiT5Zfkeg6wx57gzqpm49YBiDc+EQcLpx8FwGA
 WtHF2l7H2TR0KyR7ZV6knyHhXRe8qi+RqZomjNRAMh+RbswpehxYl6N8Nf2g0FuwZnifI32F3po
 SpM//4kxyE+40v8KZBw==
X-Authority-Analysis: v=2.4 cv=GtFPO01C c=1 sm=1 tr=0 ts=69b03c7a cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=qJbEDo8Lr3yLsC1F8HwA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: 23hhyI9JX7zxHWLhRAFCB-Nadh671Bwk
X-Proofpoint-GUID: 23hhyI9JX7zxHWLhRAFCB-Nadh671Bwk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100137

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

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c       | 175 ++++++++++++++++++++++++++++++++++++++-
 include/linux/dma/qcom_bam_dma.h |   4 +
 2 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 83491e7c2f17d8c9d12a1a055baea7e3a0a75a53..627c85a2df4dcdbac247d831a4aef047c2189456 100644
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
@@ -391,6 +395,14 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* BAM locking infrastructure */
+	bool locked;
+	phys_addr_t scratchpad_addr;
+	struct scatterlist lock_sg;
+	struct scatterlist unlock_sg;
+	struct bam_cmd_element lock_ce;
+	struct bam_cmd_element unlock_ce;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -652,6 +664,27 @@ static int bam_slave_config(struct dma_chan *chan,
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
+		return -EOPNOTSUPP;
+
+	bchan->scratchpad_addr = metadata->scratchpad_addr;
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
@@ -668,6 +701,7 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 	void *context)
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
+	struct dma_async_tx_descriptor *tx_desc;
 	struct bam_device *bdev = bchan->bdev;
 	struct bam_async_desc *async_desc;
 	struct scatterlist *sg;
@@ -723,7 +757,12 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
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
@@ -1012,6 +1051,112 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	bchan->reconfigure = 0;
 }
 
+static struct bam_async_desc *
+bam_make_lock_desc(struct bam_chan *bchan, struct scatterlist *sg,
+		   struct bam_cmd_element *ce, unsigned long flag)
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
+	sg_init_table(sg, 1);
+
+	async_desc = kzalloc_flex(*async_desc, desc, 1, GFP_NOWAIT);
+	if (!async_desc) {
+		dev_err(bchan->bdev->dev, "failed to allocate the BAM lock descriptor\n");
+		return NULL;
+	}
+
+	async_desc->num_desc = 1;
+	async_desc->curr_desc = async_desc->desc;
+	async_desc->dir = DMA_MEM_TO_DEV;
+
+	desc = async_desc->desc;
+
+	bam_prep_ce_le32(ce, bchan->scratchpad_addr, BAM_WRITE_COMMAND, 0);
+	sg_set_buf(sg, ce, sizeof(*ce));
+
+	mapped = dma_map_sg_attrs(chan->slave, sg, 1, DMA_TO_DEVICE, DMA_PREP_CMD);
+	if (!mapped) {
+		kfree(async_desc);
+		return NULL;
+	}
+
+	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
+	desc->addr = sg_dma_address(sg);
+	desc->size = sizeof(struct bam_cmd_element);
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
+	if (ret)
+		return NULL;
+
+	return async_desc;
+}
+
+static int bam_do_setup_pipe_lock(struct bam_chan *bchan, bool lock)
+{
+	struct bam_device *bdev = bchan->bdev;
+	const struct bam_device_data *bdata = bdev->dev_data;
+	struct bam_async_desc *lock_desc;
+	struct bam_cmd_element *ce;
+	struct scatterlist *sgl;
+	unsigned long flag;
+
+	lockdep_assert_held(&bchan->vc.lock);
+
+	if (!bdata->pipe_lock_supported || !bchan->scratchpad_addr ||
+	    bchan->slave.direction != DMA_MEM_TO_DEV)
+		return 0;
+
+	if (lock) {
+		sgl = &bchan->lock_sg;
+		ce = &bchan->lock_ce;
+		flag = DESC_FLAG_LOCK;
+	} else {
+		sgl = &bchan->unlock_sg;
+		ce = &bchan->unlock_ce;
+		flag = DESC_FLAG_UNLOCK;
+	}
+
+	lock_desc = bam_make_lock_desc(bchan, sgl, ce, flag);
+	if (!lock_desc)
+		return -ENOMEM;
+
+	if (lock)
+		list_add(&lock_desc->vd.node, &bchan->vc.desc_issued);
+	else
+		list_add_tail(&lock_desc->vd.node, &bchan->vc.desc_issued);
+
+	bchan->locked = lock;
+
+	return 0;
+}
+
+static int bam_setup_pipe_lock(struct bam_chan *bchan)
+{
+	return bam_do_setup_pipe_lock(bchan, true);
+}
+
+static int bam_setup_pipe_unlock(struct bam_chan *bchan)
+{
+	return bam_do_setup_pipe_lock(bchan, false);
+}
+
 /**
  * bam_start_dma - start next transaction
  * @bchan: bam dma channel
@@ -1121,6 +1266,7 @@ static void bam_dma_work(struct work_struct *work)
 	struct bam_device *bdev = from_work(bdev, work, work);
 	struct bam_chan *bchan;
 	unsigned int i;
+	int ret;
 
 	/* go through the channels and kick off transactions */
 	for (i = 0; i < bdev->num_channels; i++) {
@@ -1128,6 +1274,13 @@ static void bam_dma_work(struct work_struct *work)
 
 		guard(spinlock_irqsave)(&bchan->vc.lock);
 
+		if (list_empty(&bchan->vc.desc_issued) && bchan->locked) {
+			ret = bam_setup_pipe_unlock(bchan);
+			if (ret)
+				dev_err(bchan->vc.chan.slave,
+					"Failed to set up the pipe unlock descriptor\n");
+		}
+
 		if (!list_empty(&bchan->vc.desc_issued) && !IS_BUSY(bchan))
 			bam_start_dma(bchan);
 	}
@@ -1142,9 +1295,17 @@ static void bam_dma_work(struct work_struct *work)
 static void bam_issue_pending(struct dma_chan *chan)
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
+	int ret;
 
 	guard(spinlock_irqsave)(&bchan->vc.lock);
 
+	if (!bchan->locked) {
+		ret = bam_setup_pipe_lock(bchan);
+		if (ret)
+			dev_err(bchan->vc.chan.slave,
+				"Failed to set up the pipe lock descriptor\n");
+	}
+
 	/* if work pending and idle, start a transaction */
 	if (vchan_issue_pending(&bchan->vc) && !IS_BUSY(bchan))
 		bam_start_dma(bchan);
@@ -1157,8 +1318,15 @@ static void bam_issue_pending(struct dma_chan *chan)
  */
 static void bam_dma_free_desc(struct virt_dma_desc *vd)
 {
-	struct bam_async_desc *async_desc = container_of(vd,
-			struct bam_async_desc, vd);
+	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
+	struct bam_desc_hw *desc = async_desc->desc;
+	struct dma_chan *chan = vd->tx.chan;
+	struct bam_chan *bchan = to_bam_chan(chan);
+
+	if (le16_to_cpu(desc->flags) & DESC_FLAG_LOCK)
+		dma_unmap_sg(chan->slave, &bchan->lock_sg, 1, DMA_TO_DEVICE);
+	else if (le16_to_cpu(desc->flags) & DESC_FLAG_UNLOCK)
+		dma_unmap_sg(chan->slave, &bchan->unlock_sg, 1, DMA_TO_DEVICE);
 
 	kfree(async_desc);
 }
@@ -1350,6 +1518,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	bdev->common.device_terminate_all = bam_dma_terminate_all;
 	bdev->common.device_issue_pending = bam_issue_pending;
 	bdev->common.device_tx_status = bam_tx_status;
+	bdev->common.desc_metadata_modes = DESC_METADATA_CLIENT;
 	bdev->common.dev = bdev->dev;
 
 	ret = dma_async_device_register(&bdev->common);
diff --git a/include/linux/dma/qcom_bam_dma.h b/include/linux/dma/qcom_bam_dma.h
index 68fc0e643b1b97fe4520d5878daa322b81f4f559..f85e0c72407b5e1a733750ac87bbaba6af6e8c78 100644
--- a/include/linux/dma/qcom_bam_dma.h
+++ b/include/linux/dma/qcom_bam_dma.h
@@ -34,6 +34,10 @@ enum bam_command_type {
 	BAM_READ_COMMAND,
 };
 
+struct bam_desc_metadata {
+	phys_addr_t scratchpad_addr;
+};
+
 /*
  * prep_bam_ce_le32 - Wrapper function to prepare a single BAM command
  * element with the data already in le32 format.

-- 
2.47.3

