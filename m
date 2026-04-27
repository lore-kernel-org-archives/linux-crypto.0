Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254273B27EA
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281371; cv=none; b=oHgdCGNneNu73DhhJwoslhZkk3kii8A5lpsyU2s6JPHKdolYbTejrm9Nuuw1ucV2YGaAs0GolRJa5Mip0k1GPfhXzm2FXbAwmgjrSBf5xlImxFU+V5Pl0VEWo8Z1VHcWNpmvA/3xnRkT1HxOKh1eAAC7/B9071oYmUL+P5WLxkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281371; c=relaxed/simple;
	bh=zej38AY1HURQQPXixRl2Mg7k2dmudX8XuCBnlPTpkvw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=euOJXAHnXppjFS7mPnMCsFKssReABokG/hlqc2349ug5hVAy9bprrIgQu4DbFbSsQYc7iX/RHMz2CLHnLmTbPQXXAr1L2cOhGx9lmf6YrIPnyyBgwHYcP+qGvmkTA82aFnZcLeh6DXnfVXsAZG5V4JrC2fejbwgZ1rOMISX8x8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dq8ZplD6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cXL8SRNl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dq8ZplD6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cXL8SRNl"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R8TBSj665666
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ws3wC5jqIqaO13gZQcJaOHssTZuGV6QPS0RLw3JFDoI=; b=dq8ZplD63uYrfyIO
	RCdlHMplQni9IK3tp0yROxWNC7aOD7UNes1hy5ErG67emLIdRFWu9fyZZFqtg0Z/
	jogqYXZouMu2AfrrkUcqVZ5pK7FIKs9UV9CRD5m7/Ah3ss70GDno8h4PPOEI9QwK
	wZV9OEkhsQqO5IMSJ3g26Q/C1GjP/mp4RUlSnmAkcGuPrOh7q+mkdzvuPqGoh24A
	c4T3PXmLvTxRrgDUdYm605C8OpRu5SyRiCjOlKdSFW0OUjTNDUwkhwq2dt2qEAG7
	B25gjvqwFHh5IpTQ6d+xzxXuYY38CJ8dP7IQp0jDvE4F2RK5fzo2nEt8wwqL60Sm
	hFGcWQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dt30n0kw1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:08 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50ff0bef198so35827811cf.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777281367; x=1777886167; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ws3wC5jqIqaO13gZQcJaOHssTZuGV6QPS0RLw3JFDoI=;
        b=cXL8SRNllWiv0qEqZDsy24mb1p/wlppEREncwC/pkttFHNubWzQL8J1kbittswOmqb
         dAIvu7uvkGKJw6lcsC7xiIlTo8B3kXGT3ZMetBMog27XoxZsz6fomiHUDkaarkSLXrZG
         Yx2XFWi9siXfcotQGpxHSpAV9OBr6fUC/GSXiHGBJUohI0M6vQGxygNvMcPlvfLgTw3h
         uS69Wg1vA4sIh6D1Wj46eNsFZYe+H0mQZNj3hl5njfiB2PUSw8wcP5TszlDVFiK+1Jvh
         f756emj3VT8CCmbvY8g/O/n/PgwCFey/7EutOG0lNhITez8jDM6Gqe6MHBOgBoMaSToI
         FXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777281367; x=1777886167;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ws3wC5jqIqaO13gZQcJaOHssTZuGV6QPS0RLw3JFDoI=;
        b=NEYCJAUx3Ug12Fxgz9KV1blCV8Z4Ef5BtGzYNMk+jpCr7Kh4j2CpCmqIp7rC/U2MO6
         93hlDBbMqoeDMdBVeq3j9g3VMpv4FVQSkbM79C8UvXN38g4exq3adb44azduNMeTcwuz
         lSQde3JYz93yjaicp872qOrvweEV+sJLpksJl3V0VOsUa4fihqIAFPTSMQivmyK1yLl1
         XWIaSbCMUd2TyTMU4/CHxWacfOpZSu1/hh/SSpKzpLDntREl9tANRHk8q0Cba9J/km/y
         +pw/Z9iwICp2o4UjEM6Qew0Vcg78KvAkrbeidQRi3dPmqmuIwULkL/Y5GK6djspssi7+
         iBoA==
X-Forwarded-Encrypted: i=1; AFNElJ9pH/0i6Y/eQd7Nf3i8JtJi8pW65wdip1ji47cSDHiYhxbnm7j2JlC7XfFNv1j6GAk+ccTZNQXzR3UMh40=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjqu7Tbrck/WH3b/g3HSEFeEC3U/DwoqBPFU3LtxO4UEbEqoWk
	DKV69QjPTt8NKImaeLsuaDyAXMnuJIEO+Ks6s/03ZOrh+loUEhQcPFVOmK+KNRrQq8gIo7ceX+6
	hEmHEVUE+2ZrDgoEJzai5Q44IGlAMham//709VsBVt5x009L3wd+iMgg38i5JNoRKFqCkKryu6Y
	8=
X-Gm-Gg: AeBDiesVE/m4rPIQ/sys45eu6uNK29OG+5gFMz5Lb+ZG15/r1GcD1GCN/eC2eMUTUXZ
	INqZGzt1H4qWuuGy7wXElCUcUeSafgcrZHYdMedfz36AFxi8qHqflVjUpPfq7C9NyqOTA1v9yg/
	dgMiEZX+n62e5l/5N19+z+fc8ieluXDZ3MrkuJpXCXLoDwPefw0FZCuQ2KQhhd8J+DuUMcboedw
	LPA5FnIjv+TlZlvdDvh/D3MXLPIfbWrk5g6G0/wB7K0NsTTQvdc/cg0xzsz95j6KSq38mFF6Oqz
	GcangAI366CL61IugtFQE88DvweQ4/C8VcEhaLtD7ZePgewwL+mLezt2EEQxowB/lmb/JTs9DY9
	7EFGvZxyRwIK77xCperdF8jqvZvbQTHOLs7unQ3MxKJywuPEObzJUfoJgge1fZw==
X-Received: by 2002:a05:622a:1dcb:b0:50d:74e4:56b7 with SMTP id d75a77b69052e-50e36837466mr618717761cf.4.1777281367280;
        Mon, 27 Apr 2026 02:16:07 -0700 (PDT)
X-Received: by 2002:a05:622a:1dcb:b0:50d:74e4:56b7 with SMTP id d75a77b69052e-50e36837466mr618717171cf.4.1777281366797;
        Mon, 27 Apr 2026 02:16:06 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5062:ae86:23aa:702c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a6dbfd4b5sm40559365e9.28.2026.04.27.02.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:16:06 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 11:15:38 +0200
Subject: [PATCH v16 05/12] dmaengine: qcom: bam_dma: add support for BAM
 locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-qcom-qce-cmd-descr-v16-5-945fd1cafbbc@oss.qualcomm.com>
References: <20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc@oss.qualcomm.com>
In-Reply-To: <20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9515;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=zej38AY1HURQQPXixRl2Mg7k2dmudX8XuCBnlPTpkvw=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBp7ylBc+D0D78uvZgn/UxumwtcRmuQ50D1VE07h
 C3Qz9NU4sCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCae8pQQAKCRAFnS7L/zaE
 wz5NEACSdLgrHVkQPS1+qmro7GbDrjKp2sOIB38bdhxIBd9fNoSBt9yCbpLviZOq3V/asSYQiUN
 AlEXJpWXBzTOFNlElDgkV8pVeEMNVV5DSFrPp3Qa2Js+vN1hx9OIR8ryD2LhGvljeHCX/6MwLYI
 B7FruU8D9UHlux68h7DlVftp4hewQCTAYriSa0gKx38hrmbi0quvALPw1aBK1h2GF5rUP3Z9iy4
 9VcaL2bj1UT890Nk/eo+g7LDTmGmr8VT5BEmXrViKDu1tYCTQhX9HjAgVUXRXAEvkGJ/GcMCfwk
 9m/BKBvmuDHHduDtIj4LowyZQ8wjxDXYnoXtptPKaz10ST1E0sXhgtGaZqCWydMqNvunDSDGzUH
 Xhsd5v4+o+1WLnB9F+65sAmOKot/wRXJ4i7f6Ij2ugxyhqKh3yHT4Z4zlw8sFFEVj4zB7yNZSqu
 n64dokU0WJjHQusAJ3ZgKXCUPzXhtI6ONuiT3nmjh8EER8DswKifW6fsJ8vusSjaSf6cNSomTBR
 +/pNRtgJAO8Wqvk7xdO9ftVjB89v/7cwDkQle/N4euNB7+RB2hbH8zUWebck2zIR5l8K5glhye/
 dEXoDeHX4ajmIsTAcqLGm3AP6wU6D3GV1yObhbhSkBAekz9NALLUfVnRLwWTf1xthHPlU9bCg/u
 /C/kueO9iilYJRQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5OCBTYWx0ZWRfXwnQqQVuHEUt0
 So4gLgDSAbVLt5fZl7G9uLJiJ0zqekviAA1we+TrmAXL8EibkWGsGbviclchKBZTpbAeli+8a88
 8WPTU9vFNfITgCSBVhPjj+YQjoQ75szLY+GEFhGUSnbhtbhiPY3lDqKq+zDjc6ag6ffphmBHXrn
 0RTC9N7Zy3ibAyQhDWuVjweXoHEulgW+HQaWFYgVD0Vs87hDfiLVU6nGaaW8j7bTqvKSzfzfpS3
 tcbwGM9/RZp5+tLM1QdAUPGWTvjh68tWSTrjCWoYul/0CLDDLDr3PmLgKyvbfbGbH2OofQDpxyw
 jRmwlvE9TG1QL3pwnwXMNxU8qk956hh9VOXqtqGMX1GdUcPfbOOQdix30y8uFajbjwa5V6A7yC/
 6oOEOiX/rxOukippUIC5vPJUKz6H3AYzoc4NEBiu6uc7k/wwUcaDIXm5qx/pJ9/mAuXj4TUoG6Y
 asRGkRHD3io3sGUwgig==
X-Proofpoint-GUID: uVrVEr21gqiMZ1XCadDp_UdlOWiNotlG
X-Authority-Analysis: v=2.4 cv=efANubEH c=1 sm=1 tr=0 ts=69ef2958 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=j-cXwOq41x9PnjJ4jooA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: uVrVEr21gqiMZ1XCadDp_UdlOWiNotlG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604270098

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
 drivers/dma/qcom/bam_dma.c       | 154 ++++++++++++++++++++++++++++++++++++++-
 include/linux/dma/qcom_bam_dma.h |  14 ++++
 2 files changed, 164 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 83491e7c2f17d8c9d12a1a055baea7e3a0a75a53..85d8ace8e11e3f78a0a7b13d8fe44afcfa75d98b 100644
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
@@ -652,6 +664,33 @@ static int bam_slave_config(struct dma_chan *chan,
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
@@ -668,6 +707,7 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 	void *context)
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
+	struct dma_async_tx_descriptor *tx_desc;
 	struct bam_device *bdev = bchan->bdev;
 	struct bam_async_desc *async_desc;
 	struct scatterlist *sg;
@@ -723,7 +763,12 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
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
@@ -1012,13 +1057,106 @@ static void bam_apply_new_config(struct bam_chan *bchan,
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
+	mapped = dma_map_sg_attrs(chan->slave, &async_desc->lock_sg,
+				  1, DMA_TO_DEVICE, DMA_PREP_CMD);
+	if (!mapped) {
+		kfree(async_desc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
+	desc->addr = sg_dma_address(&async_desc->lock_sg);
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
@@ -1030,6 +1168,9 @@ static void bam_start_dma(struct bam_chan *bchan)
 
 	lockdep_assert_held(&bchan->vc.lock);
 
+	bam_setup_pipe_lock(bchan);
+
+	vd = vchan_next_desc(&bchan->vc);
 	if (!vd)
 		return;
 
@@ -1157,8 +1298,12 @@ static void bam_issue_pending(struct dma_chan *chan)
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
@@ -1350,6 +1495,7 @@ static int bam_dma_probe(struct platform_device *pdev)
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

