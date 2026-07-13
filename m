Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B48D414DD4
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947710; cv=none; b=AG+ZMp3ibGKhA20HVl4ylGSjmeGgNN86Fk1+vCkDo5nhQ3k9dxwDPBYUVej0Bi5I7An37tBay9ukFfULHRb7kzQPIp8xNBwvO3uMK+8fLUNWm7vqZd4UH++4oeViSkDv6k6b9ioJx6pzUYziz2Kz7T4a4W7ZmSDc3978AGxIhQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947710; c=relaxed/simple;
	bh=GeKEhMv4HL+sNdc1B6hwmj0prbP4JmlWYAcirsdO9/I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NG0/6CYazQtBpMp6ffi3E/9deMblBpGaMMZws7hjGLY3MyoZDzTCsRnbiVRDZ0GjGNHWddwONO7W+pUKwh0V8xvcJQYNirDhN5Ma8KWaUnXoRjf/Vg68vpkx9ARsJPhtthH6WgE8zgdvfhuTZBFng4EftUFEkecA5hTehyu6tmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pars959n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BMFPnxmT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pars959n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BMFPnxmT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCE3HY1428838
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0TR9jzsb9FbctHJwwXbKkfyIam9oK9f3rZGLCUp0+E8=; b=Pars959nsXhoMm0h
	e8jdCTAMW5r5DuF3q0T3+pNl6gcPmMO7pOzjiH/H/FE+6EoljdNKLbcSwsZ8jgln
	3Qhn6kibjQxC2L8cUaQEEIpGhTX6VEfPD9A8nRxj2EkdkPjrY/pRxHVZhtb375Kp
	BXPOZ+JD7qHJpRb/8CscQKIuucbfH8jNJDVvoOvE0pRfGQzDlYnr1kiPQ4npNEEO
	HTTqkqlKl4lLBWUJdl06urUN/F6flP3afeqhaurx4X27wNaGSHIG2QVp7udVluOf
	YstEZs5bcCtKI3sdNPRmpqukgAXFoXjer/SWUdFQfE/bXn5LQszxTYLcE+VgyfdY
	np/c5Q==
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcurn15kx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:47 +0000 (GMT)
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-44aeefa1a30so6620697fac.3
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947706; x=1784552506; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0TR9jzsb9FbctHJwwXbKkfyIam9oK9f3rZGLCUp0+E8=;
        b=BMFPnxmT0hlpJRAbd9Y1e/lVicLEejNIe4xMYb+AvvJpiCU4M/ZCD8/vYusELbbV8O
         37a0jpC4zHPc8E1NCykH4GU/ppuQY94gVPswyVWZwPsnTzqt5De8QIcZ6XVoQjYiEIWn
         pQyvkY9ea5kVtkFeTfJ7dld/c0mrIsQPTF8Y9dW2hXy26Ofk42QWxRPNZfaM86QFcZM1
         tXj26Rad1Rnk1v8jGfcX6UJwHG1uIMPnmZ+qMcaOTy5vBRpv2GIDTlwri9h3/dIno6mQ
         8o1duR9kfo4SyGPHPq+uZrF2V6ZhTjzCHY8uFt7IS3Co2noFv2QjjNZVHx+7vLLKajQW
         0TuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947706; x=1784552506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0TR9jzsb9FbctHJwwXbKkfyIam9oK9f3rZGLCUp0+E8=;
        b=MXj/fsd1zC4OpvZ1W3TFEEBYPx1KJl+lZuhWWr1JUNwFChlRNYZwmtoPYOtSRMbvWI
         Vval1t0iSxhE4Q36ws8OMhNAGFcCtvmPxoLpOKBzG3w573g64nzEweO14T83Czk/2YzI
         IshImWuT295+0eUK9QZVlGh7+gTFYosKH2+cfnUaTVsgC7etGUmf86ZWJ4eciLl8/5T3
         0wZEzgvoE63D6FWTWe5+y1+vEXvgFL9x9G+iH6OmVr2PnTondozAlzJUnR8wtRatbgZS
         YNAiK7IQJMzMs+IkIXi/964ieFVe7pMxp5jw/6bk5dzQiZFLtfoXGT98EY0ueKYQZxUU
         Rh6g==
X-Forwarded-Encrypted: i=1; AFNElJ+O9cS83ME9qr467Mi5wkr9cvGTvFyEujHtD+5NVr/ozeGYG7P9TKjR10WT3y8n0SZT1/+jZHWsFReY08g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxIyPiqKrBYERHdQcVpcIFkM2wbegHXDZWajzH5ZXeDWgYOgPO
	HAB1FoMghg6PC/ImTxvlC/N9aeHV3ezM4E4J1mk12hrCYF7qw+g42clLzZAPi7RZBemvu6g2I1d
	Oqe2w9Po9NmxQquA/lnpoi2L5z2DDnNI/IZRrtzAKrIXRqh7neiehKHwRrneatObj7Bc=
X-Gm-Gg: AfdE7cm/I4fOQ+F8ijvGJrlEHXgouDKnzqQ6CGxriJ77l98RBE1xXpxbfr3qGR16Fax
	XonnjoEJ8fnVx0M3aeZfnjombUee4ul/DA8dE9K8vULLO9GMIQe2Tt33xHBC++2X+POXUt9YFR9
	Y7Wtbktk8MyXRmOwI3vIybqRvStyBW4aFLiolSWHYe5x8P+LatvJZuA5qXXyQ23t/Q63MzZLlZ8
	GtYbZzbNNJ+JL/d3DJc2xB0sa/E3YyjUfa2Xdtde7i7qxaeM620C3imbMiEo6y1k/CqTJmyUBv5
	Ne57Ljj/J/JyFyMtMkv/zq7AL6k9AaBYEjn3wcjIHYfEyjwNGnnwUx+thlnaR3rUdn9mEms6P4h
	YYPCB93arwIjJFOWltKT4/eeIcgAkKyBGvSAGULYf
X-Received: by 2002:a05:6820:829:b0:6a3:740f:bb4 with SMTP id 006d021491bc7-6a39a561da4mr5459440eaf.5.1783947706356;
        Mon, 13 Jul 2026 06:01:46 -0700 (PDT)
X-Received: by 2002:a05:6820:829:b0:6a3:740f:bb4 with SMTP id 006d021491bc7-6a39a561da4mr5459387eaf.5.1783947705708;
        Mon, 13 Jul 2026 06:01:45 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:43 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:07 +0200
Subject: [PATCH v21 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-6-bc2583e18475@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=12707;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=GeKEhMv4HL+sNdc1B6hwmj0prbP4JmlWYAcirsdO9/I=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGbcUz/kvNU2CxvvdHFHWZU9lY1B7BhUlSf0
 BC/U7RjJw2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThmwAKCRAFnS7L/zaE
 w7qeEACPtd6YgSMh0URGLnSv+kDUY0fAMUDwC6YnBP02pzdM9FqttSCnHT5TdG3qEO0LhZDPof4
 z9j33utghPaQzjOnvYWqZTg5WYlGL0KN7ZuvXGUJX3ioC4qqgc8lvkU5GiWwllobjDgpvJOX/hM
 HBd69tdVc2xM9GMLE9vJL8HxYjz21cH4VPTHjRSXL1oSY0fC9pvc9JF8F6yrSRKmtJF6KedsSyU
 emq4rM51ExgUG3OM/hQg99KSi1omJ6o5DQArdbjoJKwmz2daxuDs3UiLCR1rEOWoa+R5vrIn2/6
 yKOalIUmSQk7lK91jk6ykXuUhkCGe9d89PQi0XT9BOdNB2Tjhjx5ztGc/SwGD2tZ2xkmJmtnBUm
 Vak4BYeTUd54XnNOXUCgrFBXELUu/37edRrN2vLU5LdU+hsLpHMr0CULvkE3FJcPgAzLmjz+rhX
 bm1Vyw4FIJ08EaI+i0/BK+zTB8ebFDcK2e/Q95F2K/DXQtrXLn3O00tj0JErJWfFmr5DP+77LXh
 POUKBZweCMPlFYVFvmBYVN3DsvMt5HPr7riy6Mekhppz7eV/72Rn/qF542H9PRbMjFCkhZa3qpX
 UqSogL24VFsUPojW+FMInFS17keBgcJeKuslf3dk7qtRZJ5hSYFfvPArf+ifzjSpsQHJcVaEkg5
 vVPwXTgjUS3PWFg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: EnFZqJGXZpwi3oqiDtw_mrvEUENgWRAU
X-Authority-Analysis: v=2.4 cv=IcK3n2qa c=1 sm=1 tr=0 ts=6a54e1bb cx=c_pps
 a=nSjmGuzVYOmhOUYzIAhsAg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=oytoXMUlALCG7T_FErYA:9 a=QEXdDO2ut3YA:10
 a=1zu1i0D7hVQfj8NKfPKu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX6owtQdcH9j60
 4xcAIyM5cJvV+pzJjeAoO5SwApJ2TkETNtwNtE+fVEBl3SBxxWMkjE4YTSq7g4Ez0AFhI0RhYiW
 PcZLCPOT64v0T9jTK5Rp5J5Evtsio9g=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX4OnCEkPkZ++w
 /ZPZMQmL6wQ7GdU+T2o3mz7IO3/B2bBSumKr0MmHIgovmTMckQ7u0HnqNBKQ4xizMMlsy04Aob8
 1L1lbYmAOB8hJ/VUMZzKsfhmyNln+PDtm10z/PTHukVonGmZv1CenmkQaXUBAaysEROuVKid1op
 ZJgGwAtBWyLm8yWm4sXXnJa0EdwjsRKtsoQ6lsjauVKff+Yt4UfYC666iHNJtt9mlaPpmv0L9Xh
 4d1tM2PJo+PDO/Zq8YK6KBj93ZoTM4lWV7MUQRkIPHC+1D7ghsWeqGRgi//9USIhfm4MMzowK0S
 J/1i5NthChXjGqWgDkjXKD1WH5QPNMw7nByRubNNQmOyUzEqFubyZrIVcQECp/f3agqa3ECeg/X
 jYX//bvmaoOaxuUmQqg6fX6VVP1ulA8CAaViUVqBfIDiD9I8aenHKSBAgP9days0f24CZfmiY6Y
 ffVlod+HPk3TT5N4Glg==
X-Proofpoint-GUID: EnFZqJGXZpwi3oqiDtw_mrvEUENgWRAU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

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
 drivers/dma/qcom/bam_dma.c       | 191 +++++++++++++++++++++++++++++++++++++--
 include/linux/dma/qcom_bam_dma.h |  14 +++
 2 files changed, 198 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index f3e713a5259c2c7c24cfdcec094814eb1202971a..f08549ee3872eece85884606d6ee9e540ee688ca 100644
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
@@ -425,6 +434,11 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* BAM locking infrastructure */
+	phys_addr_t scratchpad_addr;
+	enum dma_transfer_direction direction;
+	bool bam_locked;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -638,8 +652,10 @@ static void bam_free_chan(struct dma_chan *chan)
 		goto err;
 	}
 
-	scoped_guard(spinlock_irqsave, &bchan->vc.lock)
+	scoped_guard(spinlock_irqsave, &bchan->vc.lock) {
 		bam_reset_channel(bchan);
+		bchan->bam_locked = false;
+	}
 
 	dma_free_wc(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
 		    bchan->fifo_phys);
@@ -686,6 +702,35 @@ static int bam_slave_config(struct dma_chan *chan,
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
+	guard(spinlock_irqsave)(&bchan->vc.lock);
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
@@ -702,6 +747,7 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 	void *context)
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
+	struct dma_async_tx_descriptor *tx_desc;
 	struct bam_device *bdev = bchan->bdev;
 	struct bam_async_desc *async_desc;
 	struct scatterlist *sg;
@@ -757,7 +803,10 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 		} while (remainder > 0);
 	}
 
-	return vchan_tx_prep(&bchan->vc, &async_desc->vd, flags);
+	tx_desc = vchan_tx_prep(&bchan->vc, &async_desc->vd, flags);
+	tx_desc->metadata_ops = &bam_metadata_ops;
+
+	return tx_desc;
 }
 
 /**
@@ -802,6 +851,7 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
 		}
 
 		vchan_get_all_descriptors(&bchan->vc, &head);
+		bchan->bam_locked = false;
 	}
 
 	vchan_dma_desc_free_list(&bchan->vc, &head);
@@ -859,6 +909,15 @@ static int bam_resume(struct dma_chan *chan)
 	return 0;
 }
 
+static void bam_dma_free_lock_desc(struct virt_dma_desc *vd)
+{
+	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
+	struct dma_chan *chan = vd->tx.chan;
+
+	dma_unmap_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
+	kfree(async_desc);
+}
+
 /**
  * process_channel_irqs - processes the channel interrupts
  * @bdev: bam controller
@@ -870,6 +929,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 {
 	u32 i, srcs, pipe_stts, offset, avail;
 	struct bam_async_desc *async_desc, *tmp;
+	struct bam_desc_hw *hdesc;
 
 	srcs = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_EE));
 
@@ -919,13 +979,20 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 			 * push back to front of desc_issued so that
 			 * it gets restarted by the work queue.
 			 */
+
+			list_del(&async_desc->desc_node);
 			if (!async_desc->num_desc) {
-				vchan_cookie_complete(&async_desc->vd);
+				hdesc = async_desc->desc;
+				u16 flags = le16_to_cpu(hdesc->flags);
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
 
@@ -1046,13 +1113,102 @@ static void bam_apply_new_config(struct bam_chan *bchan,
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
+	bam_prep_ce_le32(&async_desc->lock_ce, bchan->scratchpad_addr, BAM_WRITE_COMMAND, 0);
+	sg_set_buf(&async_desc->lock_sg, &async_desc->lock_ce, sizeof(async_desc->lock_ce));
+
+	mapped = dma_map_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
+	if (!mapped) {
+		kfree(async_desc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
+	desc->addr = sg_dma_address(&async_desc->lock_sg);
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
+	if (!bdata->pipe_lock_supported || !bchan->scratchpad_addr ||
+	    bchan->direction != DMA_MEM_TO_DEV)
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
@@ -1064,6 +1220,7 @@ static void bam_start_dma(struct bam_chan *bchan)
 
 	lockdep_assert_held(&bchan->vc.lock);
 
+	vd = vchan_next_desc(&bchan->vc);
 	if (!vd)
 		return;
 
@@ -1072,6 +1229,18 @@ static void bam_start_dma(struct bam_chan *bchan)
 		return;
 
 	while (vd && !IS_BUSY(bchan)) {
+		/*
+		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
+		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
+		 * already have bam_locked set and must not trigger a second pair.
+		 */
+		if (!bchan->bam_locked &&
+		    !container_of(vd, struct bam_async_desc, vd)->is_lock_desc) {
+			ret = bam_setup_pipe_lock(bchan);
+			if (ret == 0 && bchan->bam_locked)
+				vd = vchan_next_desc(&bchan->vc);
+		}
+
 		list_del(&vd->node);
 
 		async_desc = container_of(vd, struct bam_async_desc, vd);
@@ -1133,6 +1302,10 @@ static void bam_start_dma(struct bam_chan *bchan)
 		bchan->tail += async_desc->xfer_len;
 		bchan->tail %= MAX_DESCRIPTORS;
 		list_add_tail(&async_desc->desc_node, &bchan->desc_list);
+
+		if (async_desc->is_lock_desc &&
+		    (le16_to_cpu(async_desc->desc->flags) & DESC_FLAG_UNLOCK))
+			bchan->bam_locked = false;
 	}
 
 	/* ensure descriptor writes and dma start not reordered */
@@ -1191,8 +1364,11 @@ static void bam_issue_pending(struct dma_chan *chan)
  */
 static void bam_dma_free_desc(struct virt_dma_desc *vd)
 {
-	struct bam_async_desc *async_desc = container_of(vd,
-			struct bam_async_desc, vd);
+	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
+	struct dma_chan *chan = vd->tx.chan;
+
+	if (async_desc->is_lock_desc)
+		dma_unmap_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
 
 	kfree(async_desc);
 }
@@ -1384,6 +1560,7 @@ static int bam_dma_probe(struct platform_device *pdev)
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

