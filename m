Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D03F3B27C7
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281365; cv=none; b=TrM7gSIYv08xtu8GjoPHslr5GIht/o4Bzrx5non5NN5tABypUa0pCfKoRru4P/DtRGGYI+A1lUO8iL+560p7B5TP8DDgjpsKPau8BucKjrJZVRqpWskJoWV7ZBpllPsX5NVJUHKoZRQbmRTKmABNSuUeXiYh6VLKenlk8V1vPFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281365; c=relaxed/simple;
	bh=qoz55FlU0wzlioVR5y4kqwZWHtjnuJw0AgLGnvGjRME=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZJyDgepNMRJBw6HQrBuQjaDCwtCDjloy2YTU7A/YjAl4g2n+OtD7F7mcqWP03EQuV9CAq2vshn5gcZOxeb++XOjzuMyOgUriJGtWi+HeAmAoXzXlmiA96kSxD9Y1D1tQFgGP9kmKykuOHDYNhKSwt5Z1exCQiRu15OAgLDBt5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MXiCAtXY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J5+UzuFW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MXiCAtXY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J5+UzuFW"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R8T9ps1762101
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	byBhms6klEiQKAIzzwk/0xHdksfuhIUeiAfPpFlaRio=; b=MXiCAtXYIh25F8oq
	fLYcQ9uqAr1YddX4F9BsHVa5lqv6FMBcn3mGhtm37bVAKnRE7ZHI3a3Rp5NhIP7m
	ker7XrzEDOYu+Zq4OwYUzceyG3uLhN83POnqhFb/rroGYM3/+iIBV79NcgyPQGe3
	BuZF9f/Cpoa2QJF6NkAMB5YlD9CR6KHpMLVKDIzMIv/g6b0hPXjLRt7MQLhAl1L0
	cwoc1kopn8QyGOZvJo74vqnBzph4P5Ni/OxVvIP/5BhJFHF5Bmbcw7j5gc9bFcZx
	C2Lp2Rg2w/UwJNv0p+WNQxbOg3w6isVkBa8fo9LH0BtYMK6+rwOv0m+bJsdkpNNf
	pGMNyw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drpw9d9ys-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:03 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50f817c3240so95918211cf.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777281362; x=1777886162; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=byBhms6klEiQKAIzzwk/0xHdksfuhIUeiAfPpFlaRio=;
        b=J5+UzuFWgGt4qTEt8Chu5Nyj+bIvDhW2U29mPwiVvZdCgHM+ylXCvl64b17+csa/mK
         YQAclGEW1lwVwGIi8rWUUkk/J6hbNzOglwOCgxDDm2xh0/RGyXRRDrhZuA6I8aSrl0K9
         hIOJP6QBUW6OHWID4/Wo4NHHQb7+0gZuew1STzjtzHTp86DyrAj5PI5Nva+LmhAslMq/
         Ez3zkoLP8EGs9q2sNSdloYxntifcSiiZGEoJQPByYkHKNSvyj/5ZRQGvxr2zgk2Ye8C/
         kdioBvX4aS/hZxcOIarfqLXL/YEShjDCL/pQVXUMnx6hXCwp/OciUrds+L7d+uwAt3yf
         hXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777281362; x=1777886162;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=byBhms6klEiQKAIzzwk/0xHdksfuhIUeiAfPpFlaRio=;
        b=dJOpIAAu+nhxO48GMv+Bfz0deBS/YxRbLeq9PwyAu5TbTGO7ypyUfr8lJBfiQ2zoeD
         FNnyxcYVZxSo2Y75+SqBrB/Y9HzdSOcCiSB1cqzrqUEr4X/h0vu7BPkiD0a1vsPIMFbW
         opgEEVs0BTVR9YejNV7slgwFtNrvjkVZce58ZPBWHnpACZbq6bkRxJ11ze0RlXmcbjOD
         vIfOjo91mLJF7ui3ZttSeuF30hqADWIuQr1VkbGww5v1w6tbsp2LfQ71m3+lRVhoIutI
         hTRde0naP/PoADC6P3D4cxtDWSwzW+Ih2M3CZGuK1f2cSmOYwz/h2uqDPVshtZS7IbNi
         7EzQ==
X-Forwarded-Encrypted: i=1; AFNElJ9vH1ifSZXwkp9V1KMwwz+pSEXcxpy/S3SkzcipitHiAy9eP5WVfrxvM50sn9yew/dCTYR1czmTrc9LdYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkKCO1/pCOMBSaISB75U9/Jcvkr84F8RZM0IvhkYjqtPgIT69K
	p2/QlHM5KYm41ZhaHKJdQwsUC8iEjF2EWwtkAWmsI/ZUFiwox1FOpG5Ar7JbOnscclSxkXYuOgu
	ofvuqe5ZL+nubupJju1x6nxZAz0EJvy8EMRP3XFUkY58gW7i/MKJIQXV/TZmQrxovCTo=
X-Gm-Gg: AeBDiescfEPzneL+96I7mDpb50GwBYCppqfAOizyg+gj8j09nysKbP3ZOIGGPulRhAc
	zcQHGcGLw4MdQDtCvrIoP5BDWI6svikeHSD58/qJhursDJ7kv0a0Q5cGqFmF3RwKc1D5+yJ7C0X
	m22XTPAvDZDoV6CDzw2HEifguWjAAsrcQt+QVAY88dh/xK2ppCPpeWgOgMugMhwic0764iWpwAX
	Bnp30mokN/PGWNkaC0SI1jVze/9ebq6R2XxcQ5br+3ZcUdk4lB4RKg5pO6qQQGpPaCoadC0Bhbh
	wew5xb69SMwVMRGL1ol8WM37gsVwCyKWo4yz0EOcaGlne9ZiOIgwcn0luj3C3cf2EFk5eKzBmcA
	+DALCPFROaz2TtdfFJePw8xn4iLRQkRLnmP0QFYANsxEUPup4NQUGQ8t0JlPpRA==
X-Received: by 2002:a05:622a:59cf:b0:50d:a8f5:1bf8 with SMTP id d75a77b69052e-50e36bd6471mr637069581cf.37.1777281362526;
        Mon, 27 Apr 2026 02:16:02 -0700 (PDT)
X-Received: by 2002:a05:622a:59cf:b0:50d:a8f5:1bf8 with SMTP id d75a77b69052e-50e36bd6471mr637069111cf.37.1777281362085;
        Mon, 27 Apr 2026 02:16:02 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5062:ae86:23aa:702c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a6dbfd4b5sm40559365e9.28.2026.04.27.02.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:16:00 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 11:15:36 +0200
Subject: [PATCH v16 03/12] dmaengine: qcom: bam_dma: Extend the driver's
 device match data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-qcom-qce-cmd-descr-v16-3-945fd1cafbbc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3778;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=RN7fpsHiCZHYCJzNDBLJB3M5MgjeycllWN+nZFNR5GU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBp7yk/qdP472cAnD1YdG6nh/mfOZWhEURamNMSd
 ohy99DpbUCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCae8pPwAKCRAFnS7L/zaE
 w60ZD/0aQM2Z7oeH6HyvFKh+qma6g45ChXODJ9GLQ6AbSmbXYsTzNb+FHtmvDbKIwv628ykuvuw
 iyOipbZgjQCsKOXpUaFXugtqHkElVvEAKXP5XZVjaRx3ndOzzGHBGnzM7I1jiQKPcaQ2hWPa96V
 Zgu9hQoge59ZvTMXOLqalfnHXlLJKb8R9GzfgPjTF978BaWW6zWqrqsyncKSbuix27/5AyMPEBL
 nEns9MATzLag+JLyq9D0K7Gvv12teu+KaQfp6L2hVY3leuWsskMHCQWhh2crIrf9QfvSo0dZ+WY
 pY9kge4GzvbPDW9rbcSNBVrvLNN+AQTXToK7yMUBlNp5yPoe1dTNRYZZx+h8z4VUGvVTr7puki+
 VQu1k00rK3Sm1HNcLvHN510KnRNBJFP7pE7PoSZDZm/5BSIK8ZjIConBLi2z4uW/2UIQLD0XJ/I
 vpIymXU0XCrPuoBlF/t9o0uUzgBDO/9eDpFZbw30XUO5vukDlRP7n8lZWoK8s+HxFuh4RUmjdxA
 VOymMqR2SBzV0E1aRVnWXaKkuGjvZbzHp09PSuRTXDUrmOFlthtRVdpekZrdVdv26cyazXPAZZg
 naR3OpL8WbLlNJZkXfYXJ4FjVx6VA2+87axPS0Ax20txyY5mYrjnxy+fbfnPip3hxkOjHtl964P
 PA7bhbhP9hZ0L2A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: bcSeNDFBWHB-QGBcLWW7i5L_M82yr9E4
X-Authority-Analysis: v=2.4 cv=H67rBeYi c=1 sm=1 tr=0 ts=69ef2953 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Fb6uNmSZeVr-t7npd3wA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5OCBTYWx0ZWRfX8+r8O3fxcdc5
 IPiqlQ4diROAThVkhsK4WH1ing/wf9PFS7h2jpwJM99NNfIbLNz7vMDsY7NRSPdJTA1MYD0sZzR
 iu5URTXpiJKvGY/mRolnymZair65kA4vo4UEvJ6JQ+gNdDm6y17kTud5LzU9aP0g7ogRyINfbRj
 OsXbcSwDQeAzCUASlJa3kGXtJAiL2KV++lKkqDsjen6+5xpsWe97UWGV0LPpJ3oCmDFdIyEFYmB
 Y6dLFjaR02WmdbfKvhyMwY0GB98U5rpQkrR7hcxorv8qDZ4AsIP5zpkmjfkkkeYFsRtzhfqNZQ+
 9GPTsWafUB+Sj6sGoLeVelKrrXf11ttWhoKufAeSYSqcgeZ5Z3FIERDdN1t0EzyLy19HvMJsAGf
 aC3Wl5ErUDVDYbGcedOA743rc8s4bmULXshHijdvTHgBTYxrCVJgYFVGbFgGDshQntO25I+meX4
 5wedGyDKPCQar20tvbg==
X-Proofpoint-ORIG-GUID: bcSeNDFBWHB-QGBcLWW7i5L_M82yr9E4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270098

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

