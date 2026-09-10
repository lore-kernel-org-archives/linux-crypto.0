Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31DE4908C0
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045308; cv=none; b=MVSCth1oT5gJBVkaSFkxOmQVx87dS6+GqYJTTjPlhdGJyoOz+UcxWsqiIMNZ9QPinV/LL/8KeZmmIYwU1ik5vUZSY6piM8iwz3HaPhBc6Qr4ugiB6syU1Yxbue9s2Of2XOibyM+IhNuMWUHIyio1vUryXNxWleN8IrddrVAY9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045308; c=relaxed/simple;
	bh=E2wHQtiVoEOtyeV2kwwXesDs3cSE2G8p1gcny20/03c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nXx2c3hMUQ6rs7a+jzHwtDwJnOF4GxMaEVxvpZOUDeHka5yOsDiewXHNTNNmCI8wzD6yIVvmcLBgIYRF++lMM5VjdbkbV9lERWKY1EJhf7jwf6WDBBf2Kr+otOKczWX00Fiva0BZ7nMCOk5PlS0LU4OCSb/7igcq8Prohfqlpgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jl3rFYzq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QceP3+Qr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jl3rFYzq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QceP3+Qr"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC8MvK870274
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wL5jD6SlU+kaOcmF6Rqp6+yBGT41rSIopo7Vn0N+o3U=; b=jl3rFYzq78m2U9uN
	v3oq/6S1qWqW2PePqkIpyR+9QSTgqVQdAuopwSx7tbECRvnk4+crgq0q9Ya6NTsW
	iPKKUlHWOWhpiaN8DhQAbVZUPa1Hdov/KBtM3LVitGw8TWY2VLC5kwW5OnVnKb9Q
	9Avi74hVEKth1aiWlb8tnX9MhCKXfaobtg0fYamU0O8VZKh0J2feOxd8BF/Jcgwj
	/+5k611R6yR1WY+1NlfjonhdGXUL9iUAEIQPCzoABjOHeS1TzpO19won+wK4vBix
	mxMwESADP0Iqsu1HmMUN8dODyVwZ5g3xQvhGa9grEdNdZHrQZMq0MqiE7RocidCS
	WBjaaQ==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyd3vnn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:44 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-785b66a7017so1727614137.2
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045303; x=1789650103; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wL5jD6SlU+kaOcmF6Rqp6+yBGT41rSIopo7Vn0N+o3U=;
        b=QceP3+Qre/qldy+FyRY8jW5SRHA0gOYblYt0tjDhA3/fXn4eg6PTI3ujTv87jC2IpT
         S8wjv8WIVQrpIoVL5y1AVADKaSzP24S4ygjWOinslO+5UtHhyaKRT/frn/eoaBLSU/h5
         ywUyJidI1YC+cX021Q6gLlSaaLhHNCeZZDtE+TT+Jqm7luzjaMg+SMGy3UKYyB+HscST
         oVpIug+CaMKgSCKglMVaYyZOPCOAM2mv5F1lBNs0Nu6TWWvEZVKmxNSiGbGddDyw82xZ
         nNVBIdCSAMBk2dN/r4V0vei4h+ma4d7CThMpO9ToT5A9/tBD0CqjFgmTSROQrZsHDvmz
         SEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045303; x=1789650103;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wL5jD6SlU+kaOcmF6Rqp6+yBGT41rSIopo7Vn0N+o3U=;
        b=Fmuk+CukGMrrjCulNrhU9i5xaZ6ro8fvipse4vzIiN8xAW3FTeh+5yQ8to+6bQmtX1
         pZ2tGkXksrBXJKc5mnIzTakH9fXfs+v64ZtwilDAquOMDGEiZF2ChB4fBuaYg626vEez
         GxVVi2v31XJRz9yydWbidrvBpl/GFfpK16shtChtzApdnOZwRZNsHxiTmvXxImbxyZJS
         HfZ6Q6jHv5uxGNHKVaQm0PRTLVOTbVAXv4mgQ7jg/f61zpu9QSXLv62eeu0+XFCcUDIV
         DptpWkjPhQZQWuWgh5Gn76JwEnmx8qxPWGbncGjEfgsCACHzdhTZQGwN/9rTA/91hxAL
         0mYA==
X-Gm-Message-State: AFuF++mXX32sFSsWt2VdCiFBk2eRGqKMXfdQRhHKW91ldaLSLjf0s2ef
	+Ln0bkJCJkIrqYNq4IoMMN8ybLnYXfXHtflJ4tFGDgsfFOCXw2ooLtp1qx/8oYhk7VjIhlniLef
	6kQiCvnB1IDnXZAvKWJJNYJ0vtJ171TX7Wa6df1DgDWyXlF8OIwA+1rVLyZxPjsZGFNQ=
X-Gm-Gg: AYBFou1EksHB6Rz049xpuuxV/GIUa3s7zJTHfv1CThKtIMCctN5D8xIxAqy4tIUfpdH
	eizpkN/MOnscL3e+tMHKzME3K/KgtNdqDbbMp6PuRwt3/V5R3d3aiKVE4J6mcbgUueDsNZj0PT8
	iViYFdtRGX6b2JENpebeyFfNmfH06RAZ7fJ/PMPxgffUiTYVojm7qMLw+V+Fk+EmdgZJ7UPnKbh
	4974RFZ5/MgpBP0PtV0TFTMllHD4hvEvkYmtRfK/Gstnu1stVrOQmrTIzYOcAK2PgRMqCRKd5UH
	V3Nz6Ao2qvsLuj2DPlFfqZlYoNsFWndrB4L1ilGMQr+qwmOr0bvMoRAyuYWVFa0mHz0+3Q0nB3f
	eRRWjBdV/UJTkkFleWWZayukVKNRg
X-Received: by 2002:a05:6102:e0d:b0:785:d308:cc0a with SMTP id ada2fe7eead31-78a4a91077bmr18010119137.9.1789045302822;
        Thu, 10 Sep 2026 06:01:42 -0700 (PDT)
X-Received: by 2002:a05:6102:e0d:b0:785:d308:cc0a with SMTP id ada2fe7eead31-78a4a91077bmr18008362137.9.1789045297116;
        Thu, 10 Sep 2026 06:01:37 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:36 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:51 +0200
Subject: [PATCH v7 10/12] crypto: qce - convert to auxiliary bus
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-10-cdbd2718af14@oss.qualcomm.com>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=14576;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=E2wHQtiVoEOtyeV2kwwXesDs3cSE2G8p1gcny20/03c=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoS4es40Iak/7RWcdhKa4lhYyEp2kMOlzn82
 IQz8sds8dWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqEgAKCRAFnS7L/zaE
 w2CzD/97AEgsNO/Cg6mjKLvHjq5lozEZZY+mwSkDaQVTX+HoYQHVhWQpjXYxWBJ/YGdMt5nlPtZ
 4L8MCWR0ga8q6GSijeycVy6QB5GIEbcmxQ/ufVhyyKPrXFN6RGefNnDm3L0PTdjEwPqFucdeRd0
 Sq7xeUAid4r2XvXQnoHRLbRnJD3uYfYo83xx0wpVt7T1BvvtsmuuSBCfYDNUwObqeM9WKvYBrEG
 1cZj33MCH8BwzjfBViBeHfQr+8Z0vktwTU6HUC4ezt6Z05s8JQvUeCQdp7AFhomkBlWyUv5d7Yq
 MjNSmm+NlWBKmVW4g2KJJks+jca2vR5V879pa0J5UiGGPpafSiumI+S/WhAFTK5IFoZYC3T/sel
 p3wlyzNqtseSd7zjYVgLmuxi3lM/lwR/E/U0OYwWSE2Fh6Qhlc+mcCW6MDp22ptoBZ7WR2jzY7E
 czptpVH5QlLIuien2Vg+bKIAdOlMCiNL7NISasGBYzfrSxw2PtedUbppzMLPkOgEXjagp/qON/i
 GvCdNxejBCMXNq1elQ/d6dfuNpYK7JGcP1b5+vE6P5WouYryuff23qRMfMB2S4HuNaZOTutQKs0
 m06t5kFBUt2PRjP6ynBuqT2WErZLKZ2oCUrgdViR7oPh70//UN+RreYm80aG9tb7iu7EtAPWvSG
 nPbN4Za2Q6kUeWA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: PCTQFCq8K0pcnJV3Rn_1438-jfOKvYuL
X-Authority-Analysis: v=2.4 cv=ef+o7LEH c=1 sm=1 tr=0 ts=6aa2aa38 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=WPyFHUJR_z9Wl-EIX7EA:9 a=QEXdDO2ut3YA:10 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-ORIG-GUID: PCTQFCq8K0pcnJV3Rn_1438-jfOKvYuL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX9NiyQPmLiJ0l
 h1STGvQo3KIRnF/uU4k34FpZcGR+u1Pcr++OlCsyAmqq3s9wOWU8K+b5OUgotARkuHf8+m7flFs
 JV/qdEE0KASfM39EDIBgmX3RDFPKRYM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfXxA8CSk7i1qp1
 7BzLlQy2+3soCPkxo2dUeILKU3Yn2uiXCQHns9xNhGVBubX4aqe0oXvsABoAoC6Ow9EM+UTMt+h
 KTzl88bQyBJtJgLXEUKfAtbRvAiID93UumiGHVgXq7sbgDz6MmTi4MbJ+0CJ/qfzvZW7HgSqSC4
 ee+oywrtuPZJt3DZUCaq/wgz8dkGCaNJs+e0rRhCEVdsyGC7dz2/UXA+QYmetqZ0GYr2U06H+Zj
 82hrTjSM2E6vkRW4Z+aqY2c1pKOrNQ3bZMKYBtjZi5R3a30Z3Qckaq1ci0zrOOPZNh/RGzzi8az
 sdw4BLYdZ18JZb0LMVZmC5r+hHydgFnEmpaC3E+eTrwfFa7SOkrPY0bVDHivPDR5onpYE4scseF
 JVXh12wsHPlRz0F1D99GIhic92eOrYnfFVDc87HVx4x4FafuuJyEv8MiGFt4hHuUbLczYjc3I7P
 fGCj//pZgqEDlWv4Zrw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100156

This driver is disabled in arm64 defconfig but one of its
functionalities - scaling down the interconnect votes to 0 when unused -
will be moved to an always-enabled core qce driver. This upcoming core
driver will also be in charge of registering the qcrypto device on the
auxiliary bus so that it may be enabled if desired.

As the first step: convert the driver to using the auxiliary bus and
remove the interconnect management from the code. Update the power
management as required and make sure to use the parent struct device
for DMA.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/Kconfig        |  2 +
 drivers/crypto/qce/aead.c     | 12 +++---
 drivers/crypto/qce/core.c     | 93 +++++++++++++++++++------------------------
 drivers/crypto/qce/core.h     |  5 ++-
 drivers/crypto/qce/sha.c      | 12 +++---
 drivers/crypto/qce/skcipher.c | 12 +++---
 6 files changed, 66 insertions(+), 70 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 9f6aa82301a5101d57b3651c9b2ba33213e41d3c..1f44648880be59ef5461834773b14a9a0084acd4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -530,6 +530,8 @@ config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on HAS_IOMEM
+	depends on PM
+	select AUXILIARY_BUS
 	help
 	  This driver supports Qualcomm crypto engine accelerator
 	  hardware. To compile this driver as a module, choose M here. The
diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index bcd505579556c4d54b793d280a6a7f819ba573c9..833866b947eb6d14808d49e0f8e3a2a5fcda432d 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -44,9 +44,9 @@ static void qce_aead_done(void *data)
 		dev_dbg(qce->dev, "aead dma termination error (%d)\n",
 			error);
 	if (diff_dst)
-		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
+		dma_unmap_sg(qce->dma_dev, rctx->src_sg, rctx->src_nents, dir_src);
 
-	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	dma_unmap_sg(qce->dma_dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 
 	if (IS_CCM(rctx->flags)) {
 		if (req->assoclen) {
@@ -442,14 +442,14 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 
 	if (ret)
 		return ret;
-	dst_nents = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	dst_nents = dma_map_sg(qce->dma_dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 	if (!dst_nents) {
 		ret = -EIO;
 		goto error_free;
 	}
 
 	if (diff_dst) {
-		src_nents = dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
+		src_nents = dma_map_sg(qce->dma_dev, rctx->src_sg, rctx->src_nents, dir_src);
 		if (src_nents < 0) {
 			ret = src_nents;
 			goto error_unmap_dst;
@@ -478,9 +478,9 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 	qce_dma_terminate_all(&qce->dma);
 error_unmap_src:
 	if (diff_dst)
-		dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+		dma_unmap_sg(qce->dma_dev, req->src, rctx->src_nents, dir_src);
 error_unmap_dst:
-	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	dma_unmap_sg(qce->dma_dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 error_free:
 	if (IS_CCM(rctx->flags) && rctx->assoclen) {
 		sg_free_table(&rctx->src_tbl);
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index bf3c1bc3ba7bde5e5d08e06071c67ba77af95695..b76ed136802d1ce1200a413ede8eb0f792d7bb78 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -3,14 +3,15 @@
  * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/auxiliary_bus.h>
 #include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/device-id/auxiliary.h>
 #include <linux/dma-mapping.h>
-#include <linux/interconnect.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
+#include <linux/of_address.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
@@ -24,8 +25,6 @@
 
 #define QCE_QUEUE_LENGTH	1
 
-#define QCE_DEFAULT_MEM_BANDWIDTH	393600
-
 static const struct qce_algo_ops *qce_ops[] = {
 #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 	&skcipher_ops,
@@ -89,11 +88,6 @@ static int qce_handle_queue(struct qce_device *qce,
 	struct crypto_async_request *async_req, *backlog;
 	int ret, err;
 
-	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(qce->dev, pm);
-	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
-	if (ret)
-		return ret;
-
 	scoped_guard(mutex, &qce->lock) {
 		if (req)
 			ret = crypto_enqueue_request(&qce->queue, req);
@@ -116,8 +110,21 @@ static int qce_handle_queue(struct qce_device *qce,
 			crypto_request_complete(backlog, -EINPROGRESS);
 	}
 
+	/*
+	 * Hold the device resumed across that whole window instead of just
+	 * across this function, or autosuspend could gate the engine clocks
+	 * while the DMA is still in flight.
+	 */
+	err = pm_runtime_resume_and_get(qce->dev);
+	if (err) {
+		qce->result = err;
+		schedule_work(&qce->done_work);
+		return ret;
+	}
+
 	err = qce_handle_request(async_req);
 	if (err) {
+		pm_runtime_put_autosuspend(qce->dev);
 		qce->result = err;
 		schedule_work(&qce->done_work);
 	}
@@ -150,6 +157,7 @@ static int qce_async_request_enqueue(struct qce_device *qce,
 
 static void qce_async_request_done(struct qce_device *qce, int ret)
 {
+	pm_runtime_put_autosuspend(qce->dev);
 	qce->result = ret;
 	schedule_work(&qce->done_work);
 }
@@ -190,10 +198,12 @@ static int qce_check_version(struct qce_device *qce)
 	return 0;
 }
 
-static int qce_crypto_probe(struct platform_device *pdev)
+static int qce_crypto_probe(struct auxiliary_device *auxdev,
+			    const struct auxiliary_device_id *id)
 {
-	struct device *dev = &pdev->dev;
+	struct device *dev = &auxdev->dev;
 	struct qce_device *qce;
+	struct resource res;
 	int ret;
 
 	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
@@ -201,13 +211,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	qce->dev = dev;
-	platform_set_drvdata(pdev, qce);
+	qce->dma_dev = dev->parent;
+	auxiliary_set_drvdata(auxdev, qce);
+
+	ret = of_address_to_resource(dev->of_node, 0, &res);
+	if (ret)
+		return ret;
 
-	qce->base = devm_platform_ioremap_resource(pdev, 0);
+	qce->base = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(qce->base))
 		return PTR_ERR(qce->base);
 
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	ret = dma_set_mask_and_coherent(qce->dma_dev, DMA_BIT_MASK(32));
 	if (ret < 0)
 		return ret;
 
@@ -223,10 +238,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-	qce->mem_path = devm_of_icc_get(dev, "memory");
-	if (IS_ERR(qce->mem_path))
-		return PTR_ERR(qce->mem_path);
-
 	/*
 	 * Enable runtime PM after clocks and ICC path are acquired so that
 	 * the resume callback can enable clocks and apply the ICC bandwidth
@@ -236,7 +247,10 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(dev, pm);
+	pm_runtime_set_autosuspend_delay(dev, 100);
+	pm_runtime_use_autosuspend(dev);
+
+	PM_RUNTIME_ACQUIRE_IF_ENABLED_AUTOSUSPEND(dev, pm);
 	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
 	if (ret)
 		return ret;
@@ -263,31 +277,17 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	/* Configure autosuspend after successful init */
-	pm_runtime_set_autosuspend_delay(dev, 100);
-	pm_runtime_use_autosuspend(dev);
-	pm_runtime_mark_last_busy(dev);
-
 	return 0;
 }
 
 static int qce_runtime_suspend(struct device *dev)
 {
 	struct qce_device *qce = dev_get_drvdata(dev);
-	int ret;
 
 	clk_disable_unprepare(qce->core);
 	clk_disable_unprepare(qce->iface);
 	clk_disable_unprepare(qce->bus);
 
-	ret = icc_set_bw(qce->mem_path, 0, 0);
-	if (ret) {
-		clk_prepare_enable(qce->bus);
-		clk_prepare_enable(qce->iface);
-		clk_prepare_enable(qce->core);
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -296,14 +296,9 @@ static int qce_runtime_resume(struct device *dev)
 	struct qce_device *qce = dev_get_drvdata(dev);
 	int ret;
 
-	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH,
-			 QCE_DEFAULT_MEM_BANDWIDTH);
-	if (ret)
-		return ret;
-
 	ret = clk_prepare_enable(qce->core);
 	if (ret)
-		goto err_core;
+		return ret;
 
 	ret = clk_prepare_enable(qce->iface);
 	if (ret)
@@ -319,8 +314,7 @@ static int qce_runtime_resume(struct device *dev)
 	clk_disable_unprepare(qce->iface);
 err_iface:
 	clk_disable_unprepare(qce->core);
-err_core:
-	icc_set_bw(qce->mem_path, 0, 0);
+
 	return ret;
 }
 
@@ -329,25 +323,22 @@ static const struct dev_pm_ops qce_crypto_pm_ops = {
 	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
-static const struct of_device_id qce_crypto_of_match[] = {
-	{ .compatible = "qcom,crypto-v5.1", },
-	{ .compatible = "qcom,crypto-v5.4", },
-	{ .compatible = "qcom,qce", },
+static const struct auxiliary_device_id qce_crypto_ids[] = {
+	{ .name = "qce.crypto", },
 	{}
 };
-MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
+MODULE_DEVICE_TABLE(auxiliary, qce_crypto_ids);
 
-static struct platform_driver qce_crypto_driver = {
+static struct auxiliary_driver qce_crypto_driver = {
 	.probe = qce_crypto_probe,
+	.id_table = qce_crypto_ids,
 	.driver = {
-		.name = KBUILD_MODNAME,
-		.of_match_table = qce_crypto_of_match,
+		.name = "qce-crypto",
 		.pm = pm_ptr(&qce_crypto_pm_ops),
 	},
 };
-module_platform_driver(qce_crypto_driver);
+module_auxiliary_driver(qce_crypto_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Qualcomm crypto engine driver");
-MODULE_ALIAS("platform:" KBUILD_MODNAME);
 MODULE_AUTHOR("The Linux Foundation");
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index eb6fa7a8b64a81daf9ad5304a3ae4e5e597a70b8..6eda6e617b811420c0c3cc53988cb15a23abafe2 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -20,6 +20,9 @@
  * @result: result of current transform
  * @base: virtual IO base
  * @dev: pointer to device structure
+ * @dma_dev: pointer to the device to use for DMA mapping calls; this is the
+ *           auxiliary bus device's parent, which is the one that actually
+ *           went through DMA/IOMMU configuration
  * @core: core device clock
  * @iface: interface clock
  * @bus: bus clock
@@ -37,8 +40,8 @@ struct qce_device {
 	int result;
 	void __iomem *base;
 	struct device *dev;
+	struct device *dma_dev;
 	struct clk *core, *iface, *bus;
-	struct icc_path *mem_path;
 	struct qce_dma_data dma;
 	int burst_size;
 	unsigned int pipe_pair_id;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index a9a55bc5bc310d82a52b5637655007990da5b7a8..a5b55f5a861d072ac7a82e178f9ab223f892418b 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -47,8 +47,8 @@ static void qce_ahash_done(void *data)
 	if (error)
 		dev_dbg(qce->dev, "ahash dma termination error (%d)\n", error);
 
-	dma_unmap_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
-	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(qce->dma_dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
+	dma_unmap_sg(qce->dma_dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 
 	memcpy(rctx->digest, result->auth_iv, digestsize);
 	if (req->result && rctx->last_blk)
@@ -93,13 +93,13 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		return rctx->src_nents;
 	}
 
-	ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
+	ret = dma_map_sg(qce->dma_dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
 	if (!ret)
 		return -EIO;
 
 	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
 
-	ret = dma_map_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
+	ret = dma_map_sg(qce->dma_dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 	if (!ret) {
 		ret = -EIO;
 		goto error_unmap_src;
@@ -121,9 +121,9 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 error_terminate:
 	qce_dma_terminate_all(&qce->dma);
 error_unmap_dst:
-	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(qce->dma_dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 error_unmap_src:
-	dma_unmap_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
+	dma_unmap_sg(qce->dma_dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
 	return ret;
 }
 
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 35bd59656931c5f12614405490f1e254849b9eb5..c77d96e7a7506153bed1447331dec0aba7d56828 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -49,8 +49,8 @@ static void qce_skcipher_done(void *data)
 			error);
 
 	if (diff_dst)
-		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
-	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+		dma_unmap_sg(qce->dma_dev, rctx->src_sg, rctx->src_nents, dir_src);
+	dma_unmap_sg(qce->dma_dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 
 	sg_free_table(&rctx->dst_tbl);
 
@@ -139,14 +139,14 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	sg_mark_end(sg);
 	rctx->dst_sg = rctx->dst_tbl.sgl;
 
-	dst_nents = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	dst_nents = dma_map_sg(qce->dma_dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 	if (!dst_nents) {
 		ret = -EIO;
 		goto error_free;
 	}
 
 	if (diff_dst) {
-		src_nents = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+		src_nents = dma_map_sg(qce->dma_dev, req->src, rctx->src_nents, dir_src);
 		if (!src_nents) {
 			ret = -EIO;
 			goto error_unmap_dst;
@@ -175,9 +175,9 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	qce_dma_terminate_all(&qce->dma);
 error_unmap_src:
 	if (diff_dst)
-		dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+		dma_unmap_sg(qce->dma_dev, req->src, rctx->src_nents, dir_src);
 error_unmap_dst:
-	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	dma_unmap_sg(qce->dma_dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 error_free:
 	sg_free_table(&rctx->dst_tbl);
 	return ret;

-- 
2.47.3

