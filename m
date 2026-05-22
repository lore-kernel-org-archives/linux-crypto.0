Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD51A43D51D
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457231; cv=none; b=KQz1DSkU7cTb2dsRYK2fWHEBnQShAtGY8GDoguuLvci2GK7p082X84o0xpR9IKrspFsUm9HLsAX5NErWoc7y8INMVbgu0ttenSh3TtBwongtAjzCNz41GBXlx4r5R6pDFUhUlteGO4Zed4Xi8BJIm7J+AmWaNU+KASnoCdCUJps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457231; c=relaxed/simple;
	bh=szNr7XYlP/RmxhFwkiXdqgSbJMTs5djSMoKrGxWxQpw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hxusky6s0CbFb4o8/wrGKmRSZtFPCSevjz9+0xW7oKxBOYf+r5XSF6JgJXwULG5AsMHJmrBitOa4y9sRQ5sCQgscngiE9xQlXPRk7gi1/q+adkbgJCOC8LTJiaFwf64gnPEu8jz/WAt0c5V8p8yd7vSAC8pVDm9XatN33/nONhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XP5ZBn20; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KGwSCWCd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XP5ZBn20";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KGwSCWCd"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MCIWsn778825
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vBHLofPVeYPfx1ZGHrhJ7CLmG7Qg01nr7l3iawgtmCw=; b=XP5ZBn20ASOiH0ME
	BjwJ6Td9XM9NGXPdlbLJqZmUz10jT+cxRJ/Gvb/h5g8hKlPAmQoiYVegIGVsEcee
	49HSSa6QDqjWQUX6GhoryHGfxx3werjTtSxAByMfN7xRmyQHJwuI7qbJFwCOqQZQ
	yxOiBgYXqDPeISz5VdEqCM49zAF5umnG8F5JdffOJpaNU7zUKbcdK2DRb0RBwI/V
	nVnO+kPFgaIWXweK9n4YUR5xXA+wMYOvwvAntuk4QdFHx/i3HkKEB8DQkGAUtWra
	eRS6kRjvRDU6pgnX0P275FQSSLYa4t7rC93FvFQ8AuvCSfAUUdHEycIHOiZdZ0HJ
	mbz07Q==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eac7atxxf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:27 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-514551d5f2aso272371211cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457227; x=1780062027; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBHLofPVeYPfx1ZGHrhJ7CLmG7Qg01nr7l3iawgtmCw=;
        b=KGwSCWCd/xDO0XzlO8/JFP5G9aMkEVDLzoUQKAJHneceW/JI938KlbY+yVQdIlZyVM
         JjubiWikHb9MD4FyCe/W2E/NEmz+8kH0blUVnQo453dTBHM5TJUdh/cY6JUYUDxxLyg4
         zfmLs8FpHOaLySyy4cfakvltEf+CzcoTDgKEy8eqNSFI4tzu9CzuqyFhqJJ15uwq1YG+
         PJr9YBUCUXkeRZEmTBDZB9W5cU8skg6uTVb9BFDl3OWuSWDci93JbPQFYENYe374VqlD
         yYggt7TqYfM0zwneZHb3QZ/WUvdQ+5+Zfftz34NFDUVzcyNOYgvALyWvFqJDyUmIJLfZ
         KuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457227; x=1780062027;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vBHLofPVeYPfx1ZGHrhJ7CLmG7Qg01nr7l3iawgtmCw=;
        b=dI7GF5bu0S3OD2YNu+/dLmLcl82UWS6yOqultd3oX8CNmRL15EnvVO5yhdK1pCqOpg
         EzHcuERu09gtGyY2baMRRho1vBDwrRNvcxAXhamBuoxwFhwvW11IvsRdnfhYel+h4OJD
         LvGTKWxL5OTYr00CyjKT+E2DeKcauEJvZRX40TELGrl8YVDlpIMlCagw3frpPaCnadGc
         deknjVjKQvy5TdMqE2IjKIRH4ZKIGSExvlyc+n8JHoUYTVcFjaBkvqnW5M6DXJF4ukQl
         ijnFpZuhXkPmGEgVaBho9FKdOKWPmKQ4FOa2qUuix0tsK5c8A80foUctoX023UvMOkYK
         suhg==
X-Forwarded-Encrypted: i=1; AFNElJ+fPf3Ac8ZCcL7wyTCa49dtc7IAneGsZkIaSsn6PQKQic12Kg7Qlz1EhMdaVOVgWe4GDD7XFBS3h8+6uvw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcBMzm+cisZjnvmo6Sf7h/8xXZr6r1rbGzMOp1WxRBMH6/nPb6
	F7vCtqGdENrZPSSyeSFv7njXA24MzEGsUSz7+hq1aUxWiK/dCqP2SI+04j3lgoDR+twtkKDHQoj
	LdvgqZGKbLnxVatMRJxPCusSlQXF9N1vTxY9y3VCxMUkCL+5P67UppBF/wJt5GBiooKLhDkTx2Y
	w=
X-Gm-Gg: Acq92OFdrEoTdmWn3qblWxgW2TeJ4PXYGXnVTYf3EkElw75WUzfPRdQKfn9/hxdhls1
	fOYSNptHKo6M7GG4Q778LtzzwkGDwxGePsmsA6GS0f8KL/svbXU00e/EIw812VRdAWN7+urijwa
	e7kKusBy203h3addIPh3WfA9Lyj8L1vpJIcteh+Vrm9eMKehh56+vffGX64V5OUEXR4QK1ionH2
	0F+emm8qGe/SDWBzDMVbwFr+Dsj+5zYNznYOImUqTRCqU8+fhzcl0ajn6iN7xAf0lDlKkscbFCP
	YHImaj5P2Fa0T4pX1D9hwYK6cuvG8CfN7/cP/TqrcH2yFAXRNFwOYI7RjfgtK3u1DxM9trua7Gf
	wgXsgb8sjPSubKjC/mA52fHyKVyDydzok8BH95gMTSUo9VmmRIg==
X-Received: by 2002:a05:622a:4892:b0:50b:6b21:2bf7 with SMTP id d75a77b69052e-516d419e624mr52230851cf.0.1779457226661;
        Fri, 22 May 2026 06:40:26 -0700 (PDT)
X-Received: by 2002:a05:622a:4892:b0:50b:6b21:2bf7 with SMTP id d75a77b69052e-516d419e624mr52230111cf.0.1779457226126;
        Fri, 22 May 2026 06:40:26 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:25 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:39:57 +0200
Subject: [PATCH v18 04/14] dmaengine: qcom: bam_dma: Extend the driver's
 device match data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-4-99103926bafc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3778;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=uxRjFVxEhrXgn9P1PbRyStGi6yK9KFcQvfp9JiG64Wo=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy1F3/f2c2itAh9Qaq8Q6W2ocaop66yQq4N5
 rk20Afw3+6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBctQAKCRAFnS7L/zaE
 w0NvD/9g1BWT4Z86O5Ed0CczEU9qQkYOEi0OeK8LwPNkKRZ1jkeHLQQ/NJX5vmz29RA7xzAHJ80
 RBMCF3OtHxg+mn2UiH2QjgmvTdHLG/KtxJ85gFJeYO9ZPn2AL3lNpkl4nYoO1xPHsRyvWr60KNf
 cnJF4diDlxPjNEKj5WovaQz+hIrttw99F3iNUOg0FbQxNskhP5mDSkcLvGGOx0KflMtkjXWVh3I
 jv0QiC6bjn9DIIMk4bdbjOCYyDxnsrrBnHVNFeHPGSYAotWOOS1a8DJqUAi5NSYf68CLn2JNOoX
 /Tq1qh1vdiCTlqQCGWB0nnINUPdNelgQGHhEdRSMBTGQph3Eqqkgk5GQfuvPjLKkmHuKzjmHMJF
 WPmTZzehASqp2/ME9sP10t7LvhmVRqECK0EX9EHCsoNFZ9E5jpcgwSujHoMBjmCsfNS12L06eEX
 hhSdMt9fo0Tj36FjfaupkLVE/kZMZQesr7Jqb8x0hVFgM3BHg8OZfVRZC7kZDwIL7mxvwtMlGW8
 1BSzBJlqTzkmLaEFxD3DSLWFXwdczo8/KcxB/5jB0wouOI/uVDVtTknys4axBWTsn6LWqUXRWI3
 Y9rb6wb3jkmpKiq2YuGphX95fFfI5FhBwX44u2Y3gOrrxQdKchF/uDkUInMtaKyKjr5GU8uVuKQ
 9/g4sFC6zEBYIVQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: WvThluZRprVHLgoMyf140ZNSRv4gYDTI
X-Authority-Analysis: v=2.4 cv=JrbBas4C c=1 sm=1 tr=0 ts=6a105ccb cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Fb6uNmSZeVr-t7npd3wA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: WvThluZRprVHLgoMyf140ZNSRv4gYDTI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfX3nwiOt2kJwko
 fXRAJeAkjr9XWFLRHv67fbzEd1oK4NsktpZSLUGuBRRQFrybm71QHI7iaupEIa1MCef7sBzbQbJ
 a2dwxb1oF535jexZamp8950YP13mlxENDHuJzgQXTg33wrEBiyOeTkI/1o+3h+r9+pf47tWt6AN
 VmkWV8qc+Oq+ZiEw0XWn7eIqNoboSOWNC1CrgegQJ9zzAMR5/bM/WjNCtoBgM5DH/6p3LcxIMDA
 JuYMn646yvbrYtzyt4B0VpMp/s90eRiDwMImhhok94x3lhlhHXas6S+Zf7cBDQGUSX4cC1yZOF9
 dCvs0z1MJCymsDA3NwuvFeYlKrVlBP7hAFlvII3WZZIV7mcRNQc8367M7d5Lht73pi8RTrOd6BQ
 Vbh4P1/FUyDLghHmdNi2uJAwg7EHggC+jLRv3WyABS4jSHQl4Wmg6OqeBbkuAQjYXGAHYcruKb2
 nZ6oGJtUkUN3gJB+84A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220136

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
index 1c62f845ac0b956e311857b93f5b504086662f45..2129ff5261571581a2c086c13dd657dc63e16f90 100644
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

