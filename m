Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E00343DA56
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457232; cv=none; b=cGlLz94M2FOyG6A9wCiLuH3d153+wnNb2Xh+3IRuikrPZcaOG5pOU8zPYG6B5gvrAno6DA6qvtaKLGMrU6Nka4HPRsuMPgpQHVTEvFYXdf6LAsO2aMQvhcjY68Yyty2BBpo9Nelemsg2xhe0VruOBfy9Qdxy4dd3bZlt8eM5ODI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457232; c=relaxed/simple;
	bh=W1SOKd2RIQ9nozxC+fLn2sIL5/s1so7KiyQzTPwT+38=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kJ6DAHhkl3gMhKE4CcuCTYF0P5xQOtXJ4D3CEp74XyBcmUXZnNGeF94hl/cTbk5MChHdRaQjTBQxtSS8ZXwxgHBc76nepWiTP27noLXxWMisxkhaRWSwNdjjM3Lb6zJHl5m+uMPfsR3lHRWE3DJWonQVaXubfmDdfpxlWkGqoQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q3BeDV7b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kSmZ1cmA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q3BeDV7b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kSmZ1cmA"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MAIoma1800948
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4MzlzgFENj0SGuc5BtzYXGLVYZCfinPwBm1XxV5rC6I=; b=Q3BeDV7bYs6Iisvy
	rVyqZ8B9BBRjnkLdFbF4k99xPuPt1P0Crd9bzejmb1Qm0a6EvrUvFGZK/aKhsia8
	sPlJBJhNbL/zwmmfAW01mgIDDzHHHncCcSzXDrrQZcXUoRzq0P7rtRHrKi8iOHqW
	odNss916PK6JBOr57rzFIKRDOyOFPqB460GgX1CIxUnThwQObJ5x0hj5oLWjSuBX
	z1OUdiok0JKRHmzezdMk01Bb8EC3ywqUMhD7c1j3XpF9NWTHqoE+BqblLLSWBe1m
	3LlF84PepGhwQDdTpJiwy1a7H9CrlDBnqk3Cc30PeDRphnEWeDugJsGoI+T9wmat
	4y0frA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ean9g0ns8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:29 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50ea1a7a5d0so200479401cf.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457229; x=1780062029; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4MzlzgFENj0SGuc5BtzYXGLVYZCfinPwBm1XxV5rC6I=;
        b=kSmZ1cmASR6yXlmWkTEfH4uMmxgauXECq2motigdF50fh28tUJqQH+uxD6rZl/z/7k
         5RW6TaNreqQpy1MQ8herHbPjv2ojEFi2yDaK6UDjf/n9JPNLyGoX4BymiXuzjKASORIh
         73choLmXHxu31EkG068i6NlLKzRsFMNqzBMSbx9VeA+jl0R2nyzFP8MJA9XRdUiRuF+h
         GdqXWG01lCyCqZYFwk88eopdVEKeq2qnrM9s0qMOp3qhFfwdnoy69TXdCg+1Wk3pPS6P
         MJTw14xFUFMzGR+R8QFgBRcr7qSnwRcNi7yN6GuoQRkJLLq1mDNfGQ9LtOfNcZ2HhzPp
         l79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457229; x=1780062029;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4MzlzgFENj0SGuc5BtzYXGLVYZCfinPwBm1XxV5rC6I=;
        b=n9PmZ73VjnRCRitnt6sDufTFQCCI+tARrQvvgtOQvD/r6erwvBCIu8YfWcwDncz928
         iaL7zNUzNkvaB/BeAl5c7m+6MuHWod6TZJX4ceSe2e8UccW5co2gS1lj4ntrYGF75fH9
         gUGnv7IIsCb58YMKFyQHs6XZJxyLl9/FQ9da+IDuWegwN5MFbVblA1v5iKgXZxj0G8Eq
         0engidJBACoHPq/glGyhqdlDQ5b0DfX9OBX9ThOyljPh/GQDo+2P/3brtvM7sEj2A3UR
         lJAMvuJbuNptJMgDx83NCZz9PmBvoh8yaw/RMGoqtvsd79o+cC9FxM+GoPH1sgFMiMAF
         q8jQ==
X-Forwarded-Encrypted: i=1; AFNElJ8tSyINnFu9iiX3PAX+MG2WSYdtjqk3MRIMYPqcyvXNME3n2UihGAD9Se4Y2aeRtnDiO/69eBDm5GxeAa8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5W4FCSaParfZmqhkDhzfktuTdkk9YUZsB98B/Ct8zQjzxtnBf
	5mnl/OLJ/JH91UbSE6pdyQAr/YP/Gz9FPkP344Hat+vps9mgppvVh1emjeSNHom26WSWzdH2NkB
	yWNiIwjczCwExmXoVUmyJ3ENVaEuyVnC8Xalf7gtarug1G81lNmjyM7aOn3M6aIL07VJRUULDwe
	g=
X-Gm-Gg: Acq92OHgNWZOgiu7F30kY8MWl51yYLaY79Tjy/bmHQ0KfjJ3AnGB/1x/E/vNMxZixDA
	TiSQwH0ncN53yt7ufQObfd9EKMvyD5xCGArIE9ecZ4hIqdu82nNde9ThxBPLq13Ege7pMU0C45F
	L8S0Ybp8OniUPeT+SZ+NPmU8OXlj2qbzEHxl1vAQ44vlK3Qk6UzYu2OSZXsPDiwgif6KfV1eIp7
	WMY7KRut4sNEt9hYpNzYSc4Ne/GSwF3fuoDjsyTwE/IyJCnM3+lhTTOqZaXgmg27GWaMlXFzEI7
	YSHSpAXPD4wTBfqsV7ClvaZqdQsaNXd7vf3Lv7clYSbiy4sjCBzRIhjuMvZQwTkpBYQ2W744ncl
	TG/4g0PTUVGipT+XzjXJFqYjbqrjKdKvnx3w+SQwELOzoh5F/jQ==
X-Received: by 2002:ac8:58d4:0:b0:516:d2cc:5160 with SMTP id d75a77b69052e-516d459212fmr49798721cf.32.1779457228721;
        Fri, 22 May 2026 06:40:28 -0700 (PDT)
X-Received: by 2002:ac8:58d4:0:b0:516:d2cc:5160 with SMTP id d75a77b69052e-516d459212fmr49798201cf.32.1779457228286;
        Fri, 22 May 2026 06:40:28 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:27 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:39:58 +0200
Subject: [PATCH v18 05/14] dmaengine: qcom: bam_dma: Add
 pipe_lock_supported flag support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-5-99103926bafc@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1530;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=XWQU2M8GNJi1hTXicUIAjauPbHJI4z5KvicdSabu0NQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy3+8CwAWUYGtz5ChFcSpJ0iDTEYSKzMHbak
 OKb8pYpuFSJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBctwAKCRAFnS7L/zaE
 wzgID/9fxcVgxjsMMtcsIfMmsrA6TLSsgpemAxxT/40RvT0jg5qrmvtvuKjU7DBA3LruRgkIUBl
 cH6PqVB/NxyAEgQJ2taTQUiIJdGgcFZxckR0jq7LBCgH3vlQX980piQjxK4JXi3CR7PI8k0eC7Y
 2LLbZvn2hM8DLjnY/ZqShrSvILBra1sJZt8aREI7frl1ZN9qeoqNTT1txH43L/8+ovfKoIMWK9O
 4ZCQ31MvqIOgpOAKDIvZGMk653f4HpcH5y9dmO/j3+MEsPcE/dM94QBMj1zYPSKpUliX+3Gjs99
 s6fOret4uXBcgSec9BfQv8vOhoG7dB7KsUHwHhyWi3hkkCcCi1LDYUXV1Km2Fe+dNZJFLkF93vy
 f6b0O1bwcSWyUZU1Cbso+mETogeowV93qnfGDOs9wUpgctZF9Q/5B0hjOu9omJ8+bcpSIWdfQrz
 OdLdKNTuEWawDE/ih2ASVNoe8auSHcbM1QReW7zW05PTL+ZQN/Ls5k8jZr9K0Bd5ResQIG0uC6+
 qlmekYdXlM4XIgA3DNVoTRyLeaKW9ligxe8c1bGvfBWNar3qokt/mCDyZCgEW9CB+e062+k6BIG
 EYmdGM8dWBzvjH8aNsMaEbToKdMrWYaLaHi+LEUpkSBd5repkGloyVsaCnbzzwiE/3z0TuOGS8Q
 ZFkWIwO2J7wZuww==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: Y1SBTHbKIoI1KXIwxCY1QdOejN_pNk13
X-Authority-Analysis: v=2.4 cv=B/qJFutM c=1 sm=1 tr=0 ts=6a105ccd cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=ZSnkYuKn9ZpO9KHknGoA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: Y1SBTHbKIoI1KXIwxCY1QdOejN_pNk13
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfXxEJMuaPw+aM+
 kHD+2SbaZwyUPqbSBfiGBPwVWL8UK5FDcmY5ocTAvLJG1DAoDYzGEmPa284robXLD0z4KH2qi9n
 g4ZJDlux92mv+E7t6wg17Kbx3V5mWqsZ5QxrQmsg6zVT13H2a1OrKC6Xfk0SK+wEjahAwNWdAk0
 XYOWJKvBiXRH+1Rc3dC38dr+amOtyz4NoZ/uzMBs60dp/cXwJHXneIhy6pBR6A4/qQN4IZL6TSv
 zlv6FpwNzFKkzPsUcRfaXrLrAtYXNwla3BXeu5dnCZ7MUakSkU5TZnck4CuqdX8BvmWWs9PDmjr
 0UXuEAf5HOhUD2GMrmfKDFFwd7H1hd7kIa+MhYx3fLiAW5enFVkOqhTtrVYFvSlvhlhdO5oe4u3
 lbTHS0lVcvGnHai8xOS9FEz2ZhPLoFI/JRxlrUynyKu6thlGuS+Ahkqc6jKYmUzbSTylHULnEiW
 vWt8QnkvuHejdPz8b8g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220136

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the device match data with a flag indicating whether the IP
supports the BAM lock/unlock feature. Set it to true on BAM IP versions
1.4.0 and above.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 2129ff5261571581a2c086c13dd657dc63e16f90..04fe1d546be73f074c66c4a5712ad65717e10929 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -115,6 +115,7 @@ struct reg_offset_data {
 
 struct bam_device_data {
 	const struct reg_offset_data *reg_info;
+	bool pipe_lock_supported;
 };
 
 static const struct reg_offset_data bam_v1_3_reg_info[] = {
@@ -181,6 +182,7 @@ static const struct reg_offset_data bam_v1_4_reg_info[] = {
 
 static const struct bam_device_data bam_v1_4_data = {
 	.reg_info = bam_v1_4_reg_info,
+	.pipe_lock_supported = true,
 };
 
 static const struct reg_offset_data bam_v1_7_reg_info[] = {
@@ -214,6 +216,7 @@ static const struct reg_offset_data bam_v1_7_reg_info[] = {
 
 static const struct bam_device_data bam_v1_7_data = {
 	.reg_info = bam_v1_7_reg_info,
+	.pipe_lock_supported = true,
 };
 
 /* BAM CTRL */

-- 
2.47.3

