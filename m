Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB66411695
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947693; cv=none; b=WDhnucSB9RrBM0hFLKYAvkghFdRejXriw08gqD012dnQQ+1pieby5ohWMDqnm92LUhANBvvxIaS0fUtvJ0xVcRUcmcZo67mcZC4guKpYFWZpDoVfJgFPEnYpQhoe0/2y1Jqb+XIfBbASwyYAT93JkJnEVg6klS1k6k4on5rmmsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947693; c=relaxed/simple;
	bh=T0ZAEoPGlcD+MBsHOs7IR7iXvbxs2FRnDbpOdt9CWCM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NTTMaQ4l73pziCD4dchmsfkprTIKbhTYMs7Fa3DncowGKzbv/bww2HBM8VsVfJxa/xZnwXXQ6sWDeEynFK6xghmoFHb1+ujexuOCuNk15489RCndzJgZdOfrDQnT6CuoFsXHHP5nGxReGqjc3oKTkY1fuMP1UpzP7CfVGe6OXF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YJFK4Jks; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ElnqDfNO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YJFK4Jks";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ElnqDfNO"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCEQXT1333722
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ssHW8XScr3JWgrcOFJ5LiFi8t9CrlHFACuaOrI33AwM=; b=YJFK4JksueG3kSy8
	CsEOscJBC0OK7MMfArRUpRlNVdIMqiFLSsK8Rxk7/0TdNSPRnBCtCiG0+lhDxu28
	BfamHVNKBqy/hPtjgzzoA+09KlodvXoxi08WlHwwHwuh08qfKmmg4prKnYwRIy7Z
	+Po+aWQwWnfnO3w/IxNsmiY4m5NlC/GAid4Vz5OyPmmoWC8xTtKjFxuJdq0ivwc/
	InSTFrya04EUXnWu5IMjBH3kixlulKAAaIDFFNYFd3lBiGSN9ygLRbNgdzkti7/C
	m6xeANqK3lYQCtkgWlJzZxXOEUZ/brJdM/WHD05dylQ6s3zy824QgqdyWq9tDtRP
	6odF/g==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fctc8hkeu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:30 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e9fec69475so4468644a34.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947689; x=1784552489; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ssHW8XScr3JWgrcOFJ5LiFi8t9CrlHFACuaOrI33AwM=;
        b=ElnqDfNOn8dAenjbnxHlOiwrae1oUlbt6MQ1Eqeit7dzYxNu4IceZ9DXA69GYgZ+ow
         rot/UEFy1/dKC6oDOB4WvvGfyJCf+9stMvTLD8ixhLPQ3HDqMFPpYeDDLhB9VcA2XvaS
         XblHw6SBj4Y3hsbJxORlSN/LeJ1fJC0FGXH/aCNN3IANtKoUmwXQxvBhh6OiXU0O/Mj/
         OAlb2wovRySs208OXw9WWU8WtBxQ36mHj6IFUx4uKIgbnh12H1A4dEWnRem7rrWCokQ7
         l+UR0pTgJWfYk2QX/WC5EJmDHliBtS6JmZzq0Dyl94PobwNxuME+dRCLBleoKhM8oBSg
         XWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947689; x=1784552489;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ssHW8XScr3JWgrcOFJ5LiFi8t9CrlHFACuaOrI33AwM=;
        b=rhaO+28LZYwDwwO8yF3LFerp2+97k+R4nYZ/tIzGc4dAOErEY50hYdtGXhrTXAYIIE
         WbWTi5xocRT1Sx91lr8i0u2SrAXECxvu/BFggqfgt04VpNJ1VhVfXFvzi95fjdcMShEH
         W1mtYDBl5dUHnCGC4ISxMeA4GwiB0hl/XILJHLYUyKngXhpA6iBR4CPW98vJuuS50jYl
         mYZxovrXquRcMURgwktaXxuNdnZye+BNcHO4q8bGczuWjD9gJ+jlQWBV2Q1cPTVIRlUC
         6iS/C3NjoabMDM3V3vOmxmPDRZlrjSZtcF8+IIvaV25jnVFGBuPkx42n/S0Xl8SW+2ah
         sAAg==
X-Forwarded-Encrypted: i=1; AFNElJ/6B1H3vApIU/kJY6piqPHcBBg7cnb7iE93P0O0pMymvt9TfZkCCZG+idpxs3pTtrLpQ6qSSUwm/UVatO4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdy783KurZmApRN6HeeQWkOBqdjLdpu4eMRLo0FTymMQ7EYbHG
	NxfTp7pICXdj6iR+l7+hV59kOfeHdw6l3Pd33p5ZxGaVgvQhEOSKBruiKbYwJJeBobvH3Q7149m
	Ti4oMIFBJ0XeaBG9cAc6wp7Zz3/DzK46H0+xuCw17ePbZDMJbr+Ix1MQsnQ9IPgunK+U=
X-Gm-Gg: AfdE7ckl0IENRSSCFOI/XdCqBahMzDdaeQ8qDATVm3hU9g+/HDx3KB7kSgG8XHpu4v5
	JIGlXu7hjM0Wp+0XX1igJSDoLYHTSi0n7dcP3ktWVhdOuQEh/leARvS1Pgv7DHFTXPQOOJRIZ6T
	MpUNuveDD7qaAHfZlG8yetnfO8mojTQep5TSqM1s2Qqo0pJy0hZ6/JRPJQo2EgDcsSeSBKP9VZf
	TnoFsLfEY6tr44z1uRLdz0sr5BMfBL4XoekQSurxTPM6dQaZU6DTZESgXpW8BJQVjgz67OJO351
	arazvQdfrLGW/wKg4Qsw4XNEm4y2woPouSOniQ+miOhfFT5ccO2p8r9JUxf09hIn0mDv/7cz037
	hHLcEpfiaDn8KUAIBkgLs6k6+qW/wrI2+eVcaSefw
X-Received: by 2002:a05:6820:216:b0:69d:fcab:c640 with SMTP id 006d021491bc7-6a39a6cc376mr4848274eaf.42.1783947689361;
        Mon, 13 Jul 2026 06:01:29 -0700 (PDT)
X-Received: by 2002:a05:6820:216:b0:69d:fcab:c640 with SMTP id 006d021491bc7-6a39a6cc376mr4848226eaf.42.1783947688764;
        Mon, 13 Jul 2026 06:01:28 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:27 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:02 +0200
Subject: [PATCH v21 01/14] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-1-bc2583e18475@oss.qualcomm.com>
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
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2359;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=T0ZAEoPGlcD+MBsHOs7IR7iXvbxs2FRnDbpOdt9CWCM=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGVtk23j9WMdAK9vTBVzx3ggbDwbf+8TN6Cj
 XQXTvzeETaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThlQAKCRAFnS7L/zaE
 w6FeD/9JqF+LVP1epiNp5FsiCS3htRKz5PlF4mocU3VrUG0etSCHC1tK4PzMixQZj2Tl7N7Zok1
 j7/LP9ZI6/0xY7u7YuY9behpQ1mex/SKrXXzCId0DC1R40Gmifr67MXasXktEjiBwQNnHeouM3I
 KggDHXo4ccrCjBc9werjgP+GRdbBDWgE4lRaxZjjTOhkqAOgUrvIsv6KL/+nhZFSP4VAOtruUkr
 kJ/nzdGXfU6u1yCW3F0XbJaXqPdvE5rEi/RlO7ux6I7OXN4T7BPztA54Dc/Sv65u8TdxBn0d48q
 RevX3zqSTgmWUbfeb3PuW18MSNd7V/pU2Z2iJgHWX/1oYf0LDfwPIfcb7Pg+GWUD1WtcmVsWd7y
 DfCgRwzhPPnDaIwoeDGYK7OBE/RdtbRR25xC++dDTWSiCVlcIRvCvajQANHjzIO7NbKBNUI0uiX
 QFmbCPLc6SAwmhe1QojBH313wPgkjP9fYsCAoTwYGwW0tvaWaoWZPKrRNlDYJhNEqaSFhZJJs2h
 tesL4V5Kqv481xfqgE+XQdYFht2EAAFxyGQRRlHfzXyNPFesmC0bxRR/KG4FQjI4zOsKmphhDZl
 d6LFkMywLBDJO5nZzwXC4BIorLovMhXH+YyUuLEyqmUDehwLEBuDoPszp1uEOwmzRCUF86VVY+i
 eyex7CGHqOPsVWg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: UtlyB11dFBZTiv3628tBtdJ8CN8kjlMn
X-Proofpoint-ORIG-GUID: UtlyB11dFBZTiv3628tBtdJ8CN8kjlMn
X-Authority-Analysis: v=2.4 cv=UtRT8ewB c=1 sm=1 tr=0 ts=6a54e1aa cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=zd2uoN0lAAAA:8 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX1RyXF9/8wn4a
 XMzGlbE7YCjABqJQUC2+g+poOy2Ws/aiF7EK5R/Ddt72f87mQd/tBzNq9IFSm+oQUf/Bl425MH4
 sQDsozqSsxDcKLdw9DsxKMi79+se8EE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX/OtDZVyr8Fla
 3M/JeCqZYPgY3aYbQ1TqrIIJE0rpD9A5mGkPwJhzz93c3HRBlgWHsFTqEO2UMxqAxHZ6xLwrtQI
 VqX5S4EPiQPPpTiNw4AcfnYmricR9kdJv4GVbLOyVkRf3p947j7MwruFL3K++H/xK3E2iGO3zWj
 rFjmHI7uu+9nqD+aGQWt9v8mjwzkN1wq8DG+In9DEQxa9v2GeSDnv7JPLOop3nozSdY2fsNMGVC
 r5DKBZ3Bq/fyE9DVJIUlLGv4icyRzUiYnT2qmSJoT1C4ab+n+YV1h2VSu63UniznF/CQg9lu3+D
 XtpUn8F+HlsPcKC4l7TneKaaUBEzso4eAhwe1zJpz2DO7GMmPfKgfuH4FMlzZgLDet3QAftseSO
 Xo9WJORFO4L/TNYUjJC/RdjSBp2+O4TLIGTrPO4k5fjmtypi0xPt9T8x9c5lTTb3gB8yq2llZO4
 mOjZikGgM6aPxUASGbg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

There's no reason for the instances of this struct to be modifiable.
Constify the pointer in struct dma_async_tx_descriptor and all drivers
currently using it.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/ti/k3-udma.c        | 2 +-
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 include/linux/dmaengine.h       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 1cf158eb7bdb541c4e7f4f79f65ab70be4311fad..fb21e0df5ab7b20e4e16777b5ff7f61d2ae67b2b 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3408,7 +3408,7 @@ static int udma_set_metadata_len(struct dma_async_tx_descriptor *desc,
 	return 0;
 }
 
-static struct dma_descriptor_metadata_ops metadata_ops = {
+static const struct dma_descriptor_metadata_ops metadata_ops = {
 	.attach = udma_attach_metadata,
 	.get_ptr = udma_get_metadata_ptr,
 	.set_len = udma_set_metadata_len,
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 404235c1735384635597e88edc25c67c7d250647..165b11a7c776abc6a8d66d631e19da669644577d 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -653,7 +653,7 @@ static void *xilinx_dma_get_metadata_ptr(struct dma_async_tx_descriptor *tx,
 	return seg->hw.app;
 }
 
-static struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
+static const struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
 	.get_ptr = xilinx_dma_get_metadata_ptr,
 };
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b3d251c9734e95e1b75cf6763d4d2c3a1c6a9910..5244edb90e7e7510bf4460b6a74ee2a7f91c1ccc 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -623,7 +623,7 @@ struct dma_async_tx_descriptor {
 	void *callback_param;
 	struct dmaengine_unmap_data *unmap;
 	enum dma_desc_metadata_mode desc_metadata_mode;
-	struct dma_descriptor_metadata_ops *metadata_ops;
+	const struct dma_descriptor_metadata_ops *metadata_ops;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;

-- 
2.47.3

