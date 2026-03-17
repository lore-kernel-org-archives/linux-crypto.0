Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063593E1D0E
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756170; cv=none; b=nyLzGzl5Na+6jqO2WafA2IS2SULEHpp3VRNNxIdbDxV1zjOaQTzxPRQyvjYEGNCrLR8hKhuFn6GfVvnhrU+Vfe5IqBnCGvP+Cj2dngMa3LG1rtTY55lhdUwsSSSQr/gq8EM14Q0MLb0N+Qcrjj3ejd2/S95n/hbxLwUjALsBaew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756170; c=relaxed/simple;
	bh=qoz55FlU0wzlioVR5y4kqwZWHtjnuJw0AgLGnvGjRME=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JPm4aRsjUgY6qOtHSCdZDCFPequYI3Cr4KCsrjH8PVtAQtw6lknjL9d+ROgR34NXbYnTfH8tNaA9Tk58oCvkS+oMVetHBumV+Pz889hiRsY7Feu4Vv04Jar+RxpLkKgq3GU+m8CqgN565flX2d7Pxq/T1pZGq0Dx7scgPBQG1yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U8aURp3L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y6qM/29v; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U8aURp3L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y6qM/29v"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H8Z0um1533923
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	byBhms6klEiQKAIzzwk/0xHdksfuhIUeiAfPpFlaRio=; b=U8aURp3L83W9hIQU
	YeimIZTZKiTV7Ab+ZFEGRnCz0QTgNKbhmJ3fG8Aj/EBBPWbGomEj8KTLMKo8/wd7
	B1L/2qEmbDBLbxkaDgI4oPof151d7poQGXRPeSW9NWvZAedd3OXhl6FGoOWxAiB4
	XOYVhUacYPMWJSabS5x0LFeH5TvLF81zaUqKymqZlAzM/H5impkgtq7pz792K7Ix
	cuBwDQFo6rpfWtRG/J0NXyEz5BbUtmVtJLNZ9qVN92tNLYPp6VEgx8KusvqVPw9D
	53VkNfZ+blDdGM+ojiOLSO8P+7Xrmcgph/1rsSB1Y+vLh7HsZMaQGAgwtshAAico
	WUlKZw==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxm5k4bkm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:47 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-950ca63a1e2so35104726241.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756166; x=1774360966; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=byBhms6klEiQKAIzzwk/0xHdksfuhIUeiAfPpFlaRio=;
        b=Y6qM/29vDP3zvXbUxjmDX683M1hBXPLo96SXxA0vSFuIsFxc7zk6XPVO4wvBTM9x8D
         OYa4NOnF+euIsv6Pghxhr/MRFpn/Gcj2tHr8VGT53CR9VpGjN8yhjRADnNfb7z5VmF2t
         dsnTD4LoCb5ZO0P0ufGkHxH/0c4KELnSY/LwomR/LmrsV1VDeObq8S4BP0bs3rFtIX0I
         Rl+sF8rGHjhnhnE4ko+QPN82NUMGbhC7iKpsIzW3OYxdAU/sQFTlP2vvCK+ydkh7FfiU
         +u6QURchci93ko0NBgs/AS+3z12VBVOeS2MFoudZ8De09SvtaIeXMIPBwpb4QVm0plZ3
         TbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756166; x=1774360966;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=byBhms6klEiQKAIzzwk/0xHdksfuhIUeiAfPpFlaRio=;
        b=Kd6VLhHOpmPS8jMmYetBV0Nw2x6CGfTAgp7rpuqD4XnTsRo2PT0IfEPY8N8t52xjzV
         EtDHy+NhnJ0BQeJHSOlEbhQyfuXhRUBw3GupbsQ6opLfn/RsBaJIGZsXZCa4SEpo+eBY
         p8gYj/3B0/jlsPrT8kiRtV6OVJWEPEIbv+hEUwvMSpTe9XcwkyWsoCum6hNNCvyXCvcc
         RBdZIsPx+Ch7B4HEoj2CMy8fjXgGQuDBJzkXiGqCuC+NJvHUAgnkTCbYb9M6JRWFw08Y
         aSr9TGuZTB3pB14zee8fSw6e+7TlRQhw4X+LDOJG/8BSMVNYCyYzlFvSqIuNCXmUjkMt
         Tm5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXr3B6uwOqE+1oTLiSTrGWqh5BaIEjOqLYEusouvQH8e+lc5ofiin6Ek6yODYTnV/GpQFxb01270jQceAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLl+3mYMgdEZQzkB3xTUGit2o8tMUV2HNIcFTpsbzcpO3Y/KDw
	9LLcPS2wuIDOAhqU4Sg0baNWm+Nk81Q0l64+/4uquZyscJNnK3DMDVeUBDCgRsqxEA+upAr9VJD
	r1omlGzlPr6EqYKCa1oXymOn7IamLoqp5bfustDOcRHRLdXBHC1az0w5iz1X+WY4+3bI=
X-Gm-Gg: ATEYQzx3Y505n1ILGCDfqrSp3pFPg4haostHrJ9uWKwGmoAT5wTazFG+iZW1Vretepm
	IdwRrR0k08ImVTwno2EdFFsIvENlUY1blSSl7+25Uo/AdRrBRb5rUykNbKvGNm7KPaJWVpyEE+G
	D9Wxt6yL811LqcPKamA7FcVu/6/3+Cd34dX1ArsitE+bfsUsJW7wXn8OkOk7JVkNKITt8QHw4cs
	LFR85fPJw8PGdx8JA90Y+ypwZPm2b8MHH2PxoZWtwYbhTw6oPhY/fB6UyJ6xABljDleVGgeE6tu
	mMxIOcnaWVy/W5+ffDbtXreES1u/mUZ0x0I1S2vvrmsXosYvZBDzd6WKJRmQRumwXTMwcP9fPmC
	H0AN9LTZbYkJiE8wkTgYcT5gAsK78AYrjwggMCtgdjO94oxDEk+mX
X-Received: by 2002:a05:6102:b13:b0:5fd:ef38:920e with SMTP id ada2fe7eead31-6020e8ff56amr7643383137.29.1773756166092;
        Tue, 17 Mar 2026 07:02:46 -0700 (PDT)
X-Received: by 2002:a05:6102:b13:b0:5fd:ef38:920e with SMTP id ada2fe7eead31-6020e8ff56amr7643322137.29.1773756165543;
        Tue, 17 Mar 2026 07:02:45 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:44 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:10 +0100
Subject: [PATCH v13 03/12] dmaengine: qcom: bam_dma: Extend the driver's
 device match data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-3-0968eb4f8c40@oss.qualcomm.com>
References: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
In-Reply-To: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3778;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=RN7fpsHiCZHYCJzNDBLJB3M5MgjeycllWN+nZFNR5GU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV7y9ZYaNC+PjAwISHvYpwr3lKaHdvpbstczB
 Tdo0FYPbvSJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable8gAKCRAFnS7L/zaE
 w1q8D/0VjMXWHsWGlmxP/k+KCCyjLkVQe9MseoDppXf/VlBtxYqbYrf1DyZOibBBL7Z0kJmvHpS
 iKQ0SoXGoNoXTs+mbAjgpVR0aphVL8nlINjN4sE8H6AyROUWE8PgpuJz63Yd3g9TLgApLg870Fu
 1qWSdlfGh1EoAFL/UWakZBtG8v+8/kS2tC4ToxlXkCQ0VVxYAZVHRPFAoeZM/M/1ZYHlkB0aHeD
 Oyf7bC/rNfHAZD3gmVFHKKOlghBeB0mqjgnX7rfyC4w1Pa0Zjf8b38J5Sz7mIGQkWv++bkcvKpP
 5PwASinwl7+D+9BGwTEA9vKMf1hziTVgqsAkZibB41PpZHnfN4RoRRS/n/A+AukGa3aq9CnJXcq
 K799w9uy9o9NzcjAnXpXa9uOre5XC9koxZK/+KfGjSn+zGR812mVjCn7oKXv5yD1RGoLEMoWMQy
 8gCEIBI1ZwIE0Xa3nWyCGM/EINHD75ppZ04hlKgnqQxIgv8zsysZ4rJTR2fNVhahzPVWd0oykjZ
 UMVP9Jf6VFm4hNzsXmIEffVgYVCkni+1oJ0w7yBaCoK8nkc0x2jbAEniVfzk7CXyyiW20Lw8is0
 UP8urIwUX/nXJ5qA2CZrFhvya0M+cgJgDXKWFP6U7hdTDiilLU3i60wU4pR9ThkuPyI3Miwk9IQ
 BE9VQTT3amshYFg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=fJ00HJae c=1 sm=1 tr=0 ts=69b95f07 cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Fb6uNmSZeVr-t7npd3wA:9 a=QEXdDO2ut3YA:10
 a=1WsBpfsz9X-RYQiigVTh:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfX6f04mp7ejNb/
 MW1egnfTgNWNyPlgK0EQnpulo64BphwbT16084J6OIkMCyGjgfmejfsO/r89yAqS50r7+Xey3Ge
 YqhRNm3x0m/LtwvGw5ayqfL2uDKhnMlpAOnuimdzOVvJYUY0xnCTeATgqLetAB429We150pTVUp
 08OSPcqaoLpK29PpbknyLp7/F4fzuGLCscex57oXE1Ew4jMh2eqRoHR04aoOWJJdREsh6E5Qe8N
 PVL7n8A5Tipn/iz7Jq9JCD6aWoUVY/5LM6rZKH4TxHYqp168mtsnOJ96aOz5jsn/QZGTgPgMyyM
 kb7Xa1TTL0n1OwATV5RL+eouiLRWRPtrUScoqwtyPvUvfuCK0plF+sL98xmcWiuX6mdg9KsmTZf
 qoHskPMiQh71Jex29aDmeswfRi2akDbab+X5rk0UwWUWzPRF+sSrYJ4lPON0I8RyRLjG9XtapUV
 7qqn0arf5oJ8M81Dc2A==
X-Proofpoint-GUID: ZT7lQQV5lhwfwBMvhemYJPVGZpt1TcB_
X-Proofpoint-ORIG-GUID: ZT7lQQV5lhwfwBMvhemYJPVGZpt1TcB_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170124

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

In preparation for supporting the pipe locking feature flag, extend the
amount of information we can carry in device match data: create a
separate structure and make the register information one of its fields.
This way, in subsequent patches, it will be just a matter of adding a
new field to the device data.

Reviewed-by: Dmitry Baryshkov <lumag@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index c8601bac555edf1bb4384fd39cb3449ec6e86334..8f6d03f6c673b57ed13aeca6c8331c71596d077b 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -113,6 +113,10 @@ struct reg_offset_data {
 	unsigned int pipe_mult, evnt_mult, ee_mult;
 };
 
+struct bam_device_data {
+	const struct reg_offset_data *reg_info;
+};
+
 static const struct reg_offset_data bam_v1_3_reg_info[] = {
 	[BAM_CTRL]		= { 0x0F80, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x0F84, 0x00, 0x00, 0x00 },
@@ -142,6 +146,10 @@ static const struct reg_offset_data bam_v1_3_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0x1020, 0x00, 0x40, 0x00 },
 };
 
+static const struct bam_device_data bam_v1_3_data = {
+	.reg_info = bam_v1_3_reg_info,
+};
+
 static const struct reg_offset_data bam_v1_4_reg_info[] = {
 	[BAM_CTRL]		= { 0x0000, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x0004, 0x00, 0x00, 0x00 },
@@ -171,6 +179,10 @@ static const struct reg_offset_data bam_v1_4_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0x1820, 0x00, 0x1000, 0x00 },
 };
 
+static const struct bam_device_data bam_v1_4_data = {
+	.reg_info = bam_v1_4_reg_info,
+};
+
 static const struct reg_offset_data bam_v1_7_reg_info[] = {
 	[BAM_CTRL]		= { 0x00000, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x01000, 0x00, 0x00, 0x00 },
@@ -200,6 +212,10 @@ static const struct reg_offset_data bam_v1_7_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0x13820, 0x00, 0x1000, 0x00 },
 };
 
+static const struct bam_device_data bam_v1_7_data = {
+	.reg_info = bam_v1_7_reg_info,
+};
+
 /* BAM CTRL */
 #define BAM_SW_RST			BIT(0)
 #define BAM_EN				BIT(1)
@@ -393,7 +409,7 @@ struct bam_device {
 	bool powered_remotely;
 	u32 active_channels;
 
-	const struct reg_offset_data *layout;
+	const struct bam_device_data *dev_data;
 
 	struct clk *bamclk;
 	int irq;
@@ -411,7 +427,7 @@ struct bam_device {
 static inline void __iomem *bam_addr(struct bam_device *bdev, u32 pipe,
 		enum bam_reg reg)
 {
-	const struct reg_offset_data r = bdev->layout[reg];
+	const struct reg_offset_data r = bdev->dev_data->reg_info[reg];
 
 	return bdev->regs + r.base_offset +
 		r.pipe_mult * pipe +
@@ -1205,9 +1221,9 @@ static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
 }
 
 static const struct of_device_id bam_of_match[] = {
-	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_reg_info },
-	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_reg_info },
-	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_reg_info },
+	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_data },
+	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_data },
+	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_data },
 	{}
 };
 
@@ -1231,7 +1247,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bdev->layout = match->data;
+	bdev->dev_data = match->data;
 
 	bdev->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(bdev->regs))

-- 
2.47.3

