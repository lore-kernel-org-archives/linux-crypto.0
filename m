Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80FB2E7378
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727293; cv=none; b=aeD3eTNIP5uWtDQ5dOprJfjvPh9uBW6yaeSdQBC0+MO89ezI8sR+hC7Uvym+wMpL4DseNjkJdgXM2WeHlT/L7URolV3J9WEqrnrwHyy/riNAwlW4Gqr98OgQousU3QHRL3WdazU1/OWMBDDIFrtxOrysOBp9cEWeMQChbSypEwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727293; c=relaxed/simple;
	bh=wwQQXRM0gaMVWX/Dzgfr4bRQXhzRu9ojnjIrabYrXjE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lnxG8HRbaOMcA2a+O+k04suSj2cN2qtpSdRiFH60W1UUBNIipE0IQZNXU/io/3NwFRwOB/byIv8j0TwbVntLIiAcMHUpNUVmnHpEs4rqMbnLvRuhLcGZhtBHY3xBFm3BY8/9HhGCjgnoB8JVwrjQif+1lDoE9XOFxWWf5sli8oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZUmlEoEG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JqnEV8Gi; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZUmlEoEG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JqnEV8Gi"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T91N912400847
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bgcnvEi7Ugd3Hv4P87KEsVYA0DlID2yHzdzIugzgP4s=; b=ZUmlEoEG5NwU9itX
	YK1eHEQZHppVWzXbOKbDgG3nJIjOrHO/RGzGzW4n3sGtg14SKkR+Dawqkfgb5E9F
	d5mcERF0UZpL+7ODPMO4UWMpdboCQuJ2Sl0dMDy2DYh8d/Jc5l7TpskKV3O1DTbx
	VD5yRnjBJt2DR0+Q5hfKSVbmVavRRW/Tv86mn9MkPnWRAAccnL5QzBHoVLyq/sTu
	YwpvXeIfCtj2IWEiNLGbYNn0N/HBuNaD7j0+AhQGTvtDRn60HvlWuok9Qg2NqMoK
	Sm0maLwXWM2t5CKRukdGQ0CrpGuQ4icEB302l77b15AT2DAGQcZcMs7c/ngR8IyI
	lZ1apQ==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3nq888am-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:31 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4959c49e054so1298776b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727291; x=1783332091; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bgcnvEi7Ugd3Hv4P87KEsVYA0DlID2yHzdzIugzgP4s=;
        b=JqnEV8GiEc3sQuX4GE4BF1hdO8GHoZdjq8VrqSu/jdAt6qdDg5Pqj6JeAf38KAP5TW
         kXsx9oyUSftMXfd0C+ozmzTL2PSGKBaWPinweo1OnNCBjt6nOKKcXfqgx1UeabyoZUOB
         8sCyiDumwfZFOn95j5Krjl5TU4SpRq8CBUJbHHXVGGmarMEoRNZV8lOWs4ikTq/fLXtM
         KBAaT5T6NJPbXUPRTZImK5sLHxDMTvB/vBab7H6JW7itS2jg8BMdC27lugydyyga/YUP
         PEullvc2vguA8eXC0tNpRQkj3jHKLclzkC0CzIN0sYRL2bH6dVa2sgT+nhFUVf/6TEwO
         Dudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727291; x=1783332091;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bgcnvEi7Ugd3Hv4P87KEsVYA0DlID2yHzdzIugzgP4s=;
        b=RFzs1l6cggkB9S5IouE7a78VGAeDp3AI1RAeZMEDPdTbHxdEd+gpK68IqUJKXTOGHo
         AdiR6FFpnwMymP68vfQ33C1dx6O4H7UFAOYT0s1Bu+1OSo3wO75MEs7D3l3KhgMjchzs
         BFcVg/rDnFqy4I/VkCtrBWKQtL4a4wzDev0RoSJZSwyh16YUWn/LirMKCl0r6I9A4mT/
         alRBIMn6nUS6/XJ3BVAd7WeJ7PfKU2BpUZTS0vujc1E9IFTZNphX/yN+lafrmdGLlSX8
         ZS4PuRQ2YgQUeQ0R/U+i/lkdMFRPL6TkbfSjRpkgBrfnEZTGf7Oquu/pco22Xm6BiLgF
         JdIg==
X-Forwarded-Encrypted: i=1; AFNElJ94zSWXAsAlo5YrBPZDL/cU9UMg5XR8uuh7e9DIdwqfa6L1FYHcNITMnxLfST0gu2ZV3OB0aQHMY+4YmmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Pp7iCg6qucKMf+8vjf0PL4Ioizzz7CNM+7BPd2Lply+WBoPw
	NQOiO30x4+SUzwwHDOJOEm+MOUZm9LKnA1YYV15TpTBoYtd0Lfj1UUp7F9V25Nw0ibJkx8yjPnl
	2MRD6Ba0idETUDuNPrmiu1nb7sa7m2E3z36OUiTnkrbKHXcEA/M/A5++RSiX+6VcL9XU=
X-Gm-Gg: AfdE7cm6k9huyi0H4txxXdfuf0ALAB3TSx8L7wjEK6tk38YAu2pqDbTu5919XRHvIOg
	TYQp6C9Di1W7D6z6lWz1Lcmj3reDJri5kgnC/kJPLl4WhU//nheKw9AscT3doEb7YfR27+hCCyg
	uSzJZ8P3tDfjFiBezqEzCjesWi6kFVPsfu9S5h11fpE3fgpj4zlrwi/WH1weQnnhsL8nEc2/gr6
	NZliiy+P8D4jeyowFyf8V+xWwOZmfTAE001FHewgANNoj1W0wfoSlZ8CaRhRTa6aqSftDbZLy+Z
	npyyXIlNaFl9ho5Yr4xDYh4qp2K3XtnKCj4WpnXCxpOKmIGCck0U/t8CARYelQeBkoMBu/yOzdR
	WaUFjbPjBY174JxCs0UqI7BdyvI29VCAfuQNrzY18
X-Received: by 2002:a05:6808:c189:b0:490:a1df:b17e with SMTP id 5614622812f47-49218112e37mr15351327b6e.31.1782727291120;
        Mon, 29 Jun 2026 03:01:31 -0700 (PDT)
X-Received: by 2002:a05:6808:c189:b0:490:a1df:b17e with SMTP id 5614622812f47-49218112e37mr15351293b6e.31.1782727290728;
        Mon, 29 Jun 2026 03:01:30 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:29 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:03 +0200
Subject: [PATCH v20 01/14] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-1-56f67da84c05@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=wwQQXRM0gaMVWX/Dzgfr4bRQXhzRu9ojnjIrabYrXjE=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJnL7OegSYxwesjK+cEVKpb3XLBwJVycyYXi
 aaBmx5iG3WJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCZwAKCRAFnS7L/zaE
 wzb8D/9vPQevfch3WxayUq7v0SUu5cwPXdZY019Aq7isOzzbiGYG5zcvmLNnQwXq+j9yGzqn3VG
 lTKhy70aktK6FeTk1a9GM3HDYDJ9DaFobSLCGrxBuP1ZHCz5je7yQFcz0L7H7WDFNoOYYX67cjg
 hqx+f9ZIBiTaFeDQU6Mqhc/cft47IwZxBpAhNvLSWatgmr3nzqH4SQM1x1pYLChA5Y0e/6zPo+4
 p7luhmuiuKxD9ogwGt9Bja7D8S+yesMRbF9aBivwp4Z0hTSHI0g1lKM04ROdHLyrKGAhl7i8HEN
 ZVqLq1RAOOwtm4rmjb9njODYRK+bWaIJhO+PR2rrGlV41tIo7FbjWaww9J2QOKYVK1XrLFUAT2K
 5Uzc9NBaNq7tA2LbDS9e/ViHPAGv96R2LGHgZ4DV2U6E5tPXSTknzPxHLpPdVZnWdjKK+YxDxAs
 s4KLJvKKmXzzO9mGv2ziFc7Z1SA8pObdfvIpiTS3IrglxBNF/wQrnMgn828W9l7niu1rgvZJf/Y
 PQwhKDDv+DPYCcX8CAwfNGnXdcDTWmYgrxwYxJ4W8fEL+CeQWaToNfoCH2Rp2zViVcUW0Zo4Ja5
 EhFCbcuPIhV06E6J78FR4OcHsm9XcvLdo3F83DrgaP3r4C0w8XiuZxzBhjlnofarvc5FWw6bI78
 qemDa0OHWgvYE1g==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 75n_hDXr1TiByOQasEKIh5ZznFZTpdER
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfXxKKVqRo5Ickj
 GDlEKhA4UI7BahHX7VDY18uEcFRcMEDtEY3jqUsGNL6Ymro0ifbYMHuPgfJYI0dwnSCcuHO8pq8
 kvKUJ7Gkeb+WizYUu0PluCbGHaI+n30=
X-Proofpoint-ORIG-GUID: 75n_hDXr1TiByOQasEKIh5ZznFZTpdER
X-Authority-Analysis: v=2.4 cv=PqSjqQM3 c=1 sm=1 tr=0 ts=6a42427b cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX2z3dc2C4wN53
 B36YKRCQbQ4PIUxlpDf3mZDz/3DbmZb8mVPhw9IqRIULkYNj843Dz4xqhLdc9Ex7zvo3aGECaRt
 R90Pf9Kd/gKS0eEhABRw2YvfW/+pxT/aRZAtK+4hkvPSufT5e3hTNtSz+xcqV3pJ/J0YD1mBOyi
 88axycHH3McehfZvjZRkrQgZvEoeEoPffqKsy9FPUyo+bdxWvOdYdXWeOoPWMYIHZ1zttLv5KoY
 p5EzAhvitrDa03LYxWU2AzAUOFEVccRkRszrVRQUh5PnTN9KOPH5202vQXL5iM/u0GA5pjy+cB5
 XuomQI7CDPc/tgkpx2JWhZu98aJxMkQUBRmoE11T4KzDtfPHo4shDv5XJ0/U5Z+fkWHM3ymNFfw
 VISJvKI83M55OE0ZIZ9bEzpbl+cYSDm8R1i97oN//Wxa7PDR6qyOVneEP33y4bKXzedxGLG7yOj
 DZRS7UtYaGUWK6DljCg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606290080

There's no reason for the instances of this struct to be modifiable.
Constify the pointer in struct dma_async_tx_descriptor and all drivers
currently using it.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
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

