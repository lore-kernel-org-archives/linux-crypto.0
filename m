Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC544A2E1E
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779196693; cv=none; b=IaEsoiVABG3IHhSC45VXX0vJGsVIQxLuXYrpGb2Tsb1601x+/8Roo4UUb/YX49wVgTuJ40kpZ/h5Fl248Cqu+3fczq0weWIezpLHXW5zcpQdZXEY+6EE6lx1F0ZcCjYy3hrjAIshFJ3vz7h/JxOlMTCqj/cwKlYFD0+vFIXls0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779196693; c=relaxed/simple;
	bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kHvp5iyPGX0r0epaoSlZIY2NFWjt9YyQRCWpeQeZ35I98fTJsinfaAHznPCvRLLqUnVunOSuwmievRgUMnsYfPC9S9m4qs7P2zKCrYlOZYRPqPMfmy3nl3eTff/7ynN4XyfgPTJVKmZsqp6yHjBbY8dnZudIvyVtBeq7ZSyTF5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IlKGjKmB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h9WAH7DY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IlKGjKmB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h9WAH7DY"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J89Zix1146343
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=; b=IlKGjKmBMfHoP/Uw
	ODUVVhGKU8n0Y+jF74Y+NLjzOjTKiI/MJxOvBY5Y6DMJqO0LPbZnMuE6j1pggWqP
	dO8fxuBHTG80xAhKkM9ntHM0thlEng/7t75TacaEmg089ySAhp+TpxFd+G5qDIdB
	eCToyJWc7BMOIxqkQ+kyIfJ/He77N9yn6nuEGg7+cugB/4Cu7scTpUjgSI+h2sN0
	7oDBHU6dN/Z6+yW5OSwti+qVFwLe2mzDU0NXAKuHcrZOSK8OpoCMcSFc1X3Pytov
	YU0+TwEYY+ExDV39uyYUHNo1/sluJeBm+BaToNP4EFoSBg5pINvvf5RBFf8iyaXR
	MGyqbg==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e8e7ejmx3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:11 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5758156cc93so4132166e0c.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 06:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779196690; x=1779801490; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=h9WAH7DYAS+hxGWp9vNSgB+QPUUIJDutoc60gdjDqL9mzQKXSy7uuJAdZH+/PPgXOQ
         zRqpPloWevITDVb17xykMenw8xb5Qj0iVQUrmlRVyYHnzLwEfJ/doBYIhXTLegioZz9B
         ws9GHOadx3vtJhwRzt3BcoAE0+2QkDJ/gu6pkB3uaY1oe/A3WW4t5nMWlJKeGrEuG3eA
         jnTqTPwMoqfyz5Nx3Nj6nNOrrCFdUUu+s5erldKClWPUMK1DsjJ7IRqaof9cyAVbKzKn
         WWTdqu7y4H67FN7IHL4Z/hik5TNOiacbW+90ryM5GrO04TmD5jVnpKwEA4twZTT/x5KJ
         kCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779196690; x=1779801490;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=YPiJIkXx4UlXvH+ARFmPtHAha3kUsdyo9jYBw4oF07b6w7Dq83amPOAjYhWRQ19JLl
         H+VMjC6x6PfJ6ch2/q234X9FMeAMUpTiTP3k+p95n4buOfQxZqL/B+fHYDOe7kM+yjKs
         /ZwjeNO1Z/473hHb7BkIPtXqfWUFfIzgu0BhlXRhVowx+hhIYPiGOMFy3XjFrIvtjdlC
         1sLZOAkMeguJI8S0jD7NqftGg0Shzv7owlPPCwRkdVNcrcmfVZrFPttk1D3dtDO4Hb3e
         fZBW8nL1YXuoC6UIhtyMfq8Wnd3NZP3WmIvabDGROM22QiISsDjmVwg3+fOSGV6wLY6G
         H/6A==
X-Forwarded-Encrypted: i=1; AFNElJ9Wux6smrsIRQCVteKhJLhZ3SHNAvNry2DcdcUiX4wnuyPSkLM7tZtEdi7sxeOd5R1Y+E2oOmDSOLqMSD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkxKwnoJ8yM5zmVC1uPx9BILhdc/CEAEZZKjFOatnxhqXN/zli
	CSc/V0vZeefpkr8ABcS1+hfqB36trywGe1xgGdrbSUCDFw5MAY1jEdmCMo3+tGYc5ymN0HUU/sn
	9pR6vFJpq6h57plLz+nMN3TDP4Tc3KKVduUslLtyqNvO0TVMEaMhpUnsUEg5epDklgOk=
X-Gm-Gg: Acq92OF56Ecybj3G1GXQ5AafRhy0JwDooe3MeeD2K0coQeFC5HQW1npcZOHz4E6UgxL
	/EXw5oiI57Pz3ftdurduiTuZEGsN6hGTUg4pjsSp3NTUuIR/Hc46Vh3awPuP4+lqEcAJrHygK15
	erOmcG8raMJLCFZtpYNFyfVOdmETc5a3owz8LG5lBDpgierdPCHcQiqXKl7CQ8XIUwIvP4Ta4VQ
	ZHC+/Ee+/IQUBF02HvZbyto0jB3sBhuplO+vi3Qgy1tpb8YsoqfkZsZZ/KfXYmUH9jXNKvcvljG
	g29KgYYJkwvVKXoKqu/lz5ub7AXSp31miewUuyCUcsub+ulo0e9n6K5UesNm6icjKphbhvBRsMf
	3qwEHFVkioxo+OU+YNT7RtGeAb+nz7Txo8YymIb8Wh/0JjaN+Huc=
X-Received: by 2002:a05:6122:32cc:b0:575:22f2:a1f with SMTP id 71dfb90a1353d-5760be7221fmr11587025e0c.4.1779196690535;
        Tue, 19 May 2026 06:18:10 -0700 (PDT)
X-Received: by 2002:a05:6122:32cc:b0:575:22f2:a1f with SMTP id 71dfb90a1353d-5760be7221fmr11586982e0c.4.1779196690128;
        Tue, 19 May 2026 06:18:10 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:3fb6:74e3:3c25:ba2f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe7dd22sm143969195e9.7.2026.05.19.06.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:18:09 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 19 May 2026 15:17:43 +0200
Subject: [PATCH v17 01/14] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-qcom-qce-cmd-descr-v17-1-53a595414b79@oss.qualcomm.com>
References: <20260519-qcom-qce-cmd-descr-v17-0-53a595414b79@oss.qualcomm.com>
In-Reply-To: <20260519-qcom-qce-cmd-descr-v17-0-53a595414b79@oss.qualcomm.com>
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
 bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqDGMBpRPcmMP8RCpXvdvvCjt8GuMRMYumkun8t
 rBFMDYop+iJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCagxjAQAKCRAFnS7L/zaE
 w08wD/9JUWnI4khSPNi63kU4tLcUcH8kzPNM/MzRtKHS25Z//x35eZUftdirhcdA6BixIB31+UQ
 0QvUons1PUJBz3EV9NzbR9pl/z0opC+qk7fzX9Dtr4jSgZlbj3/EZtGYeZO+SyHezEqkaGQmKKh
 P8qfJUtTAwPjbWyebjRQ9lLcRO9UL98Sev1cO66qbRdYFFuyeJQq3D1ldpmJhpRqSj35BO3DsZf
 Bbw4cXm9zKOdaJbnpsEWQ2H2VQs0nRyH9T71zwlrScypudaEs/qQZQBn2oyM64DHIvcfO9NzlnH
 r3kcVM7s/CiMg+Yr1YUMRALxKMG2yjChxOEM/lQ28bZQYf8dP5l2Lasv5DDdBqDgTOgYBftB2Dz
 NqhUkNTZlu31dqmnNRxr5/L+LDHkIJfR/03ChlXl8ZdPxcjRaOmk1AU0ksHm2APNkALgt9ATTO1
 7Q/cY+TnJIFmrEjh6GJ+NgAhrgpri00zxMlnG3oSEPm3WCVSJaNcQ3fvutRPTQZdSySsdln+rl6
 djDpLxUCLRG1ejkyvefNrTvkWx2cAE3SVla35UDZrAx7VLO1HjGjdqNz4bVCHI7fxnh5GZBKXrz
 dtkf6Rtgk2D34ZZatbq3bPp/HOOUeRs/mTi90WLaRsHu60dhi+HvcrrWLB3t0fTHi/aY6/Ay7ju
 LSjtVkiFUANsmmQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Rt316imK c=1 sm=1 tr=0 ts=6a0c6313 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-ORIG-GUID: wR3oIEQyOG8zBO2E-ExOq9Dylsmlbdr4
X-Proofpoint-GUID: wR3oIEQyOG8zBO2E-ExOq9Dylsmlbdr4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEzMSBTYWx0ZWRfX7nv1rxAOk25Z
 py26i3kd8mqYmSI3Va0Ld0veUJ0VrJS663LWYMGtSiZQ16+Wj+8IdT+wab5weRPxHe7YCU5Jae+
 FEG53yDeTkAwf1ccRh3ohFJw4Bvf8usja+5I6R5p0sIEg/jtdh9X7of8PZCitui0YRodM/Kovfw
 TSV2dospfit6jPMNJme/dDUBxCR2pferOag/woaOn/HH/RYeTrVv1tlpn0B5B/G2tqPy7YmqqrH
 qCTW88PMXeobuq44qnRMzfD9B18TDH9sOQoz0qRO6pC7buO3UvC81PZ7GVtYya7o0qf+LZ+D/M+
 lmZjGbgkUrGG57uKUSpcryDnRHq6QXzB1gyWYnX3jd4cOP2yB78bRXZzW5ONrp3/aP4lWFRIKRp
 9AW/JhhTN8h4FxKgwwENfThS8lMOMRiRQrCO8apmIBY6+yphhdcFbhwoHsExicswJxIkR9bFTu4
 MlwBKkj0O9GRDE5i2TQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190131

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
index c964ebfcf3b68d86e4bbc9b62bad2212f0ce3ee9..8a2f235b669aaf084a6f7b3e6b23d06b04768608 100644
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

