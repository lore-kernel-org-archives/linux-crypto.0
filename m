Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAD054857A
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081899; cv=none; b=t0dyHISm8Sf03qS+Ol2aH8fY27Ds7s8pwV3PxkEqRdkXKUopiKZSZG6JTPiCfxRH6z5AbpbDaJSlxqO3WXQG1BhX77/ev0eesX7HTAQHHo5D8jsSYEO8Ad2BTbteTx5IqSIE4UBCOrTWoQdeFOzFpex9KPHSW99etyDHuNLY7zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081899; c=relaxed/simple;
	bh=bqQnj1sRd5YIguxyvb1woihF/gxO2qBMbQ6gsb6aEnM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HWi0iajwvLDzcvtnMzG5GJP2qJA+D8Xm26ZoDFO9xYruEkTjOYvMktILuZx+ykOQMoO23mjwWkVNaSJQ3MVbikZT4JK33PEDp0pYkjJCZqs+xfwYIZV2UNZFlP48/7zcDJF6uohU6Levr6tz/6Dv+faIcTrDM2fGtihkWv8nJK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YDTUGAMy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jvqj1fn7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YDTUGAMy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jvqj1fn7"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPVvW3516070
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tr6/L9XspX0mVolAtvJBefpD4SzsUnEqKEXPG9e6Y54=; b=YDTUGAMyvP6j2GnG
	ZTRVYD04MFTmXcGQ+bXSJLNYJPAhYQGUN0i10rBQ9N55c0wPs5bm99g/Tr7B4gAN
	1ldJU8oMOLi2t1n/NAlNeWHw+1PS1gzv9IG8jR3/xPr0GhGK2MMexNQL7XCcGIq8
	CjMuECfqWoxuFdUi3dgk8rJlSnK1OtxXfRC9bUian+hMp69VEjytoxTVnSfco4hE
	+pk0lrbQop1WVfHEY1yM4kjX2/qmZBVZjKmWty0fhVt7McM+7BYkD8klyMjuLHxh
	ERKlKtHm2UMOvH5DvJx0EfSDJZZWUi9VniNWqyA+fW4uXRvLmCv/XurS61yyXEe/
	tXs3tA==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gufsqagx8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:14 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5c96449cbb2so1263645e0c.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081894; x=1790686694; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tr6/L9XspX0mVolAtvJBefpD4SzsUnEqKEXPG9e6Y54=;
        b=Jvqj1fn7Ah8KJZ4fCl/PNtYrNytOwcn4fGczGvwJlfkVPQprPTPE6NSblRd0BHqHAj
         4Ad9DwSoWBXD0Z138x4iQECiJusi4JlFHp/9BRCyXkybOvz5YDuT9d310pS0xIycD7pj
         7OGNwBfHwqOFLDpMPulFW7aL8aK4iEXoQrJV4qUZKELLaThYDTbchBTvNTn1S2NwSNr5
         Ck1g9bu11ujBSb2C1yrdgHKqGo7NG/nHZJhqFh9Oc5H5zUDvCcDbP3+3TLiaY5SWVb5Q
         qfKd4jlU2C1tx1pJMY/gakMoJUa7S7DsRAqF/iSJQkJWLkwBHFPMZV/A00aYGJ473BPu
         znyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081894; x=1790686694;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tr6/L9XspX0mVolAtvJBefpD4SzsUnEqKEXPG9e6Y54=;
        b=KIB1YVdY7rIfcvXtR7L4+AusRMeX/ObP1CDhmFY7lkhKntpOgsyAOHDoJjoUZdloln
         ZOVRmjS76q3kq+cDKW2Yja5kuA+zxuf5u8ifZyx4Sz1MWAE+i/X3tkBAw84Hw/V/YEfZ
         aEWmnrUzO7b/R1S3aC7cHdmscyKomXJjf75tvtawfZ4oY+pQTziGzfDKoR9tcXt0ywtR
         FGjBh9irM6+sza2cePxyEuPdin6SnwqBO7mj4MLXL8prHVJEIFmLHY+tUpA4UmKqyINZ
         0FFPpmHt828CJtFl5PAA+XnEV1tPBG5CQ3ZT8YsJRcTyRrd4Vv0AJa0nrm4+gb7HXev0
         lgGw==
X-Gm-Message-State: AFuF++l2Q4IyTi8Nm395MOx2VzCuevIZX14g3UnQDDK//Z6h5HN03sB9
	awpGwBnZjWr2assndb05snE+Fh3WMb0Jy4+KUQEWJ7Cd+J13i5GNk0c4wY9x8C7XV/3sh7Qa14w
	qyzSrZ07BiNPFaA0wsFbf6q2Pg6XjGW6EQ942oK5Hj1ZngEIlb8tmrv7hLree/MslKo4=
X-Gm-Gg: AYBFou305yrqi8OLC0EC/wucQUQzd6OaC3uTzxNxDzNs8lF+T4kA3i1sY9HD/dxvjmv
	gXrysa/WOSLEYE+qhpRb4PIXeI6cMjUiT8i0gQt0ELkTXpFqrhZH5oBwQNbWJ+cB4SjMiA4WqeQ
	aqVEv9/hc0PvEJBhDg3eKqMQyYHuLDwn6Ycsun8Sr4rdf2opTUlt1l2y3yXGT3vKR76ilwds1Ow
	kN9gtEy6Fne88Lv4qGGmIJxO/VQ1WhtRHrLVOoFgtXJojYHAfRKE43sbwVIORbaoc448tR3UGue
	IYrsQrkU1azR4N0s6JDYzV10dzKT1P/gIQ2Q/+hRljH5v76z+xac1dfxLJbBgnTrw+Fk9Aad4Wu
	DgHMMYflBu/txgqMzZGOGfHwAaNY=
X-Received: by 2002:a05:6122:8c8a:b0:5c9:a60b:e5cf with SMTP id 71dfb90a1353d-5c9b59413bbmr7504807e0c.9.1790081894158;
        Tue, 22 Sep 2026 05:58:14 -0700 (PDT)
X-Received: by 2002:a05:6122:8c8a:b0:5c9:a60b:e5cf with SMTP id 71dfb90a1353d-5c9b59413bbmr7504775e0c.9.1790081893542;
        Tue, 22 Sep 2026 05:58:13 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:58:11 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:57:26 +0200
Subject: [PATCH v9 11/14] crypto: qce - convert to auxiliary bus
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qce-fix-self-tests-v9-11-b1aa742e79af@oss.qualcomm.com>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=14659;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=bqQnj1sRd5YIguxyvb1woihF/gxO2qBMbQ6gsb6aEnM=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsns/fmtMudlJlPuDfybMh5FEY5t72gLHhBK1U
 hBwfv2oTOSJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarJ7PwAKCRAFnS7L/zaE
 w6IrD/9bM+Q8ghrImd49o8Z2DyY+PZEJk2Et03myE8G1kYPLrLlbYPhShQsBqqrMLcNhJBxDRGn
 0wQnXCZetayq0IuInO75OLF2vsa2Z3iR08hbHxzCmamW1u9KJ1JcK7q2Pj52U4Htg8yRXQKxcuS
 Xztw1AVJrkpqmZWUxR66rwitkzWI5MqwQSIV+MIJMKMCWe2Iy+bYe9I5Lespzp0EVaxxCMGq5G2
 yulUQiJ4GSqiZpLm5vqmHIlis7GBQ+e3yCJEr5eui3gE3TQD0APxVbzIU5Xs5NW6K0nE939IbGR
 QUAKHsJsl8LrqTcWu0OLd7sO29ROBIIlOnBVb14q9sMlt20daO1YwXQeuotfOIjSIGNvSpvFo87
 f4LB/kmDZTeXVLH429IOVGTdI0yDR/EU01Uf7dyWEVUouE+WAr60BOWf65fp9piPhTVv+juJD/8
 /5yHo5G+3MIuVUbTJ/6q0f8kQDgsy1XDsFEw7A2z12dwGWjO/VpIdXmKha2oUV8LFoEjAQBZo6/
 woRY9BAKqVZJYWGxi8cjJ3LpPKFpcwGOaWAhf4d9+Rz8erT05PrXzMHCP4kg0vDp3vPiGhV1lQR
 uq2jus4Ok6BqWZEGKmcZn0NFRS/7K5tWuUjVpc/SAme4+XbOOh1+pWsDnvpDBZf05BRDmc9dVxd
 vwDfmJlS8+t9LRw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: zX1LetaJlb2INlkp6ZyxRXN_b7Ld-e21
X-Proofpoint-GUID: zX1LetaJlb2INlkp6ZyxRXN_b7Ld-e21
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX2xU5vKQ/U17H
 WXa5lCrH3J4INm6vS/I84hGINLrVDF5poatEoJ5VFPM4QfxpekL4dYvwFr/TEx3ZTdkdpbIIit+
 MOoektWjUrb6y7K3PaNkFqsJcjkhwTg=
X-Authority-Analysis: v=2.4 cv=NKBAaE6g c=1 sm=1 tr=0 ts=6ab27b67 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=WPyFHUJR_z9Wl-EIX7EA:9 a=QEXdDO2ut3YA:10 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfXyWBWo8kZGVAI
 wZwP1vAX9KPMNbXEWt7Jcp8LuhjXIGpPYFb4+Xn215n6b0fPC8fRxIbJK8TBedotBKyGk9vhhJd
 Cfnwzlfh463Jp5+x1DD9om+To/ICX3A3ZmCBz+HH2wsIPuumoULDfKILWi1MsJXMeB/X/gfz+LV
 E1+f1dTPF2K86EZNeHdwjLSoY2me6BuNGN7l/IRBJq2+OBA58WuJe7hd/RaQgnhlysd8LbyAS6f
 CwGoqrEmDwUOerQtPMXSInGqjptUyk+MYuzf+c2bBIiLK1Gme1YBoIP3OlFq6hq8Y+esj/yRPoO
 UJx1Z/I8ngFPvRZ9Y0Y8yQ60pzA1y8BR1Yb8jTATPkyMo64RJOvmOHGMJPoUqljDiffnAioxMJM
 F201fOM7Nb4Mat2yzzZcJZxe/xvo/EtymlswzhcEuyFGbwhcqFxczQoHHS/f4pUYe+pHPGUuJRQ
 himOeDhUKIxPfZGs2KA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

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
index adcbe15851899917fb3039efe89a77c8fe712bf1..b3fa1f6135bce345cc58387aac7ba803a82aff69 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -530,6 +530,8 @@ config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine offloader"
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on HAS_IOMEM
+	depends on PM
+	select AUXILIARY_BUS
 	help
 	  This driver supports Qualcomm crypto engine offloader hardware. To
 	  compile this driver as a module, choose M here. The module will be
diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 37199cb50744fa3932e3404448689451b0004b77..a7bb2b7b2139d43911a72dd0d0f089f2704047b5 100644
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
index 5b1bf7a50f88c890da1f0820fb9e070b3d3f4708..31f1ad8938ab3bbe76b2ae4799eb2797efe704ed 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -3,15 +3,16 @@
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
 #include <linux/moduleparam.h>
-#include <linux/platform_device.h>
+#include <linux/of_address.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
@@ -28,8 +29,6 @@ module_param(do_register_algos, bool, 0444);
 
 #define QCE_QUEUE_LENGTH	1
 
-#define QCE_DEFAULT_MEM_BANDWIDTH	393600
-
 static const struct qce_algo_ops *qce_ops[] = {
 #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 	&skcipher_ops,
@@ -93,11 +92,6 @@ static int qce_handle_queue(struct qce_device *qce,
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
@@ -120,8 +114,21 @@ static int qce_handle_queue(struct qce_device *qce,
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
@@ -154,6 +161,7 @@ static int qce_async_request_enqueue(struct qce_device *qce,
 
 static void qce_async_request_done(struct qce_device *qce, int ret)
 {
+	pm_runtime_put_autosuspend(qce->dev);
 	qce->result = ret;
 	schedule_work(&qce->done_work);
 }
@@ -194,10 +202,12 @@ static int qce_check_version(struct qce_device *qce)
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
@@ -205,13 +215,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
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
 
@@ -227,10 +242,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-	qce->mem_path = devm_of_icc_get(dev, "memory");
-	if (IS_ERR(qce->mem_path))
-		return PTR_ERR(qce->mem_path);
-
 	/*
 	 * Enable runtime PM after clocks and ICC path are acquired so that
 	 * the resume callback can enable clocks and apply the ICC bandwidth
@@ -240,7 +251,10 @@ static int qce_crypto_probe(struct platform_device *pdev)
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
@@ -269,31 +283,17 @@ static int qce_crypto_probe(struct platform_device *pdev)
 			return ret;
 	}
 
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
 
@@ -302,14 +302,9 @@ static int qce_runtime_resume(struct device *dev)
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
@@ -325,8 +320,7 @@ static int qce_runtime_resume(struct device *dev)
 	clk_disable_unprepare(qce->iface);
 err_iface:
 	clk_disable_unprepare(qce->core);
-err_core:
-	icc_set_bw(qce->mem_path, 0, 0);
+
 	return ret;
 }
 
@@ -335,25 +329,22 @@ static const struct dev_pm_ops qce_crypto_pm_ops = {
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
index 8c12c072f4a9da2d97a51f29cf8ca22a6411063e..58114d06e60cd5925d8445ec0e58d56433a8a67d 100644
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
index 7abc1d7b1cf0403c456f3b3ce1f28820839a5473..37c16fbfe245c66aa12fb17fdd5d06d7aee2abba 100644
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

