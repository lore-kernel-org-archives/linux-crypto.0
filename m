Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E41438FE3
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457223; cv=none; b=HzVmKck4E9ibO7l7qvyR+FgvdeevWmM93OLHS5Phi9j86I0g+JvyO2r4EDdEOftpvZCQaVKl54ZeOWPfWUDzIk/E9zWtneBv54cTFPh2/tgaKnbquG8iLPdmbWfprQ+gS3UVRofc4sBeQJXJTKPdnbyXzAzuvgnmxwIB7r04ZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457223; c=relaxed/simple;
	bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C1XJVnCJbD3Eq96febdZlGTBUj2efxT1PnesFrpcvWkS85RsaKbYynqHyw+oZq1kPFjcH043bIJZY14vtArNaMH/qnEi0fqPvzXCMZZp/9qOij5VN4bSAmVBmEARtutbJ8x0PAcKnFiUCuHvK+4qN8c4qe+zgLXYAIgsZUSXxXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=loxzmJ+F; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d1ANo+R7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="loxzmJ+F";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d1ANo+R7"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MD3A3P779158
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=; b=loxzmJ+F8dCyrSYR
	7Dg7ljkvX446yu9V2U+pR0QIsWFMM3NileByF4whwhNT1IXjGpb9WU3pwtTkb+GA
	rkKm/xIV0ciryNqrrxAngAR0wQBI4EzYvhZ1fYd1NRLSBm7IrizJT7GAiGSfaWdH
	lVGzUe7wWJJOuJNitUDaMGcSAy6cmhV81nhUnXMt4B6ZQcRKsTo+ukFIRTuJ5Bek
	YfsVqyorPD576chs/2OVAvWePmakuvCj3tdpzPtCfDbkeym++CHxLDPmTDyp3Ph/
	esGTKBRC/1kSYhHKOFW47kN2PXuCWvzLzPiNKK6ybRrfndH/wbumbKcbfhIVDW5j
	p2jsdg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eac7atxww-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:21 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-516d4a9e852so30160231cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457220; x=1780062020; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=d1ANo+R7qbuBuS+LZqegVy/9leEcU+TtaAMnQLUpQmiJeg9kYDVeRfHnGKhk3BBjD+
         O32dZ3RUwQU4FjDIs0WgRVcJ9YoLdP8qRxekoA6IokSY0+lSY8YPuj/4hSJW7zMB0HEu
         KahMebV/z0jFHSSeOayfQI2Kh62LWsZPfE+ip11qiuZ89IPDaE69/FztGxoJKVUIP2TW
         /slJ9iFVryU1ieGFNAFmlxr3Ig/4s2Tt4HE5ELZFlukNFAsnqxJjnkSqrScb/ge+7q1O
         gAzYuSwHDPZO95kRrJAXBrOgtDrh/tkkd4vPIkexISEdTZKmzGyFYKKro9+ChLnVZKdf
         f95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457220; x=1780062020;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=aOfFPiOKhs203SN7uKejfnVwm1SX18ZfPUynIWrjxLQSmgYQXAGyeB1InAO4W/Hi+I
         pM0Vh9Bnw+tGgVQXTtvNOwxHG6ScLNUWISwXSQIUiomiKFaRFoCKpcUd89vM571Jh0H2
         m/BNUWN97VUWL1qmHFWCDDxZOp2kDErply1u5Lga9dsU1fh0OMGc4ps4c1tVTqLJawzi
         oueICvrxEQ94oXKuAtuztzqS6uoUPDzxpjvd3PpBT51xYSFV2qLXehmP2vQFjmuU/NfQ
         /+cyXgWLcSKMoV4likK6Xm+WCus9W3yIPRd+1K2zdrq2QhZupbngoGX9IyGlGlDLS3oR
         2A3g==
X-Forwarded-Encrypted: i=1; AFNElJ+XNOXXGqBz9uC9w2oaZPai6Fy1mfFiyGNwviMYvtIcA6Tla0I5Y2smTWjnQZYTiEbYCNI9cr+a3UJzxQA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/stHIb3JZZtHMdVn46MA+6/XvMmJ2vImdW7Ot8bLo3dBTGm0b
	MDTHP2jqnJd2ISetVZgqNi7RbxwIpxYl2ODzSncuqWjxHPI7ggJYTvhqysZ/WfE1eP+VXU3wmdT
	5lcI8M+DKYqcxxwbhQOUV2im+nZDpZv0ijEaoNewVpfzVmKHp3Nrr+rmOKTorw+SsjkXwUholNT
	o=
X-Gm-Gg: Acq92OFm7EA6Js1YC3tEiuEJC+MBXAoj4R9Jz8bZ5Z5HAXn0CHyJd5eGqoGAyy7Vwpi
	FXSRXh/VKO+bhcUX//AzSvpmsDqTw0+UqYapMgHB4ZdpCqjGI524EEGXhlJno/K39u4xXr3zgSh
	tLY3KeQuchz6kHHhmWgE5e7juuRISwekHr2l+Q4cwnVjO5XXPrvgEOdCCqabapHN2QcHNYTi4sB
	Njqlt8J9/Tx6GF5QbccChyxOR6pOrGEzm9Go+2rXBVTyCESU6+UQDDF0v3R+Ko4Yw3Zp/OxrLyM
	M7V1ndaUY1X5ZubcaUjCbHEYXgtWpIzMtUos2QBpa1A7vmdh6Nb+Lf8tBkw6vB9R5KYQF4BC52X
	gN+CXXmIjhCSwRFdKutg8j7rhjW5EVVb+Poq70jisPSc52RKv6JbdlTvg8MTY
X-Received: by 2002:ac8:5cd5:0:b0:509:2b02:c1bd with SMTP id d75a77b69052e-516d442805fmr56740461cf.12.1779457220190;
        Fri, 22 May 2026 06:40:20 -0700 (PDT)
X-Received: by 2002:ac8:5cd5:0:b0:509:2b02:c1bd with SMTP id d75a77b69052e-516d442805fmr56739721cf.12.1779457219446;
        Fri, 22 May 2026 06:40:19 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:18 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:39:54 +0200
Subject: [PATCH v18 01/14] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-1-99103926bafc@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFyyMyvLLfOOTHigPKtrLIkfFqjpy/Vy1HESB
 YKLV/xlDEGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBcsgAKCRAFnS7L/zaE
 w9XEEACBI+WYfAdsUiua0bePagUO7ktC4LRT4cbP1YIPs4CKHpbMR8GPY+M41nEEKYqHYoK2eVS
 kXUAk3LTJiWCPIoZzrtNEy2ney36HCmtBt7yuln5eTzdcrjqrf8C01YI0hCnniB4CQlu4GzkCC5
 ILveBVQ9B77lGzfz89+RS1tx5jtoBtcdVOO4pzNgG2aDmK+Efvsg84bRoEy92CYOZWDp/7eDeVU
 aYwRnFCyKeE8lIjYZt6pS/lZEPRt03Z/YELtvjDq2moubGDEb0BKU+AdoNoqm8IdwbtiCLybHz8
 13nKV+WcfefcCDjxFHa36y/xB7ikS+PTYQ1QcuDGeEywOwobW3ZvyV55XOfNXMXJrN5Gk6RwxGZ
 dimIHmQEp0/HUTc1HlnCZLhVRYZfjrx/RGcvyyYv862Uc0wT92ffexINzv3/WSbF7siR8smt/pZ
 DE7KuF/X74xOGRjs2URJep2zLHeWWbQohK70r0qD3aoQzkgIlDxr9RuAI8M8OPsY70D1PR09RhN
 sLIe38e854qqBne5Yl4k3pMiXQhaclJYTrBrMUVBxuMp09i2IOxXsifKHqeqqlbN3vsx3dA9Udh
 uvdxMg7bEOdCwssfe8gqSXTFZMestJCULF0Cse4mJ6K4+1Qt16N/FdbORA1DUWLmZhaTnYdCFFe
 5sCLfu5SfezeBPg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: 4I-XNK3IxNSyowvvbG1WzbnbJ6RBAq19
X-Authority-Analysis: v=2.4 cv=JrbBas4C c=1 sm=1 tr=0 ts=6a105cc5 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: 4I-XNK3IxNSyowvvbG1WzbnbJ6RBAq19
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfX1ayVk8zc7cAW
 bAc7iZBjaeaYxpcrPtAtXHsxCKebNHoF8tPoTeXK4cmQ2NDW9XftAHVGlL0GaOCbSsMAw5a3cFv
 bfxemdlyAFIZiEi7lxo8SA3Ed/Qv9iweSCEumDDAFpHUFsZy10YkWH3UHXIDgsmpQFW3+M/60Yi
 D8z+ZRis/IumDKcXv0wvX8gcQsRG9cXMzXoyB0nIhS/27ZvK09H5qCGcXJLBv6Boi36xOGmQ58e
 Wz7L3mgESoeUIGBeD1DsVUAertdHbWsxcTvSGbaOtOEQXaRkkAObYz0J49jECS7OGnuz41rBOcW
 v5cEEoAqPa1OYLKmUWIDCFFe5M3IwPL8UMgMIldQTTULhAZIyYz4yBp0zCaRi9H4A5GSYVUw7rp
 v3s636tbAGkRbuPUpfyYeWU9i9KD0l6J8x/7jCtDpjCdjOWOpjkLV1fNjB7cfWIxBlJguyfu+73
 K0LQYeu5pd1u/4KexRg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220136

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

