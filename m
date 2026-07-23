Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF232476681
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826598; cv=none; b=l3FhvijyXF+w0zagNB4ncDk/ct3kkYXwTURhMFaLzA6M/otVHggd5qi3iqRUwcQsY6azsCrdsuSxzCbAaBFWqbSk/ef7t7PbCtXO/k8p7PKS/yFFzulWOwfiByGXs1YKtHljR2wCgGdn5QHR0cjmHBRkNxAcLbGDA0Lo4B9GXGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826598; c=relaxed/simple;
	bh=1Q+aPsoEc8W4PfEahFbzsFEdkzT9tiwxUCi1Nvr+Dts=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O1tjGWgGa2h1fPrWdCzwCHvSFpljdUhm5tC5hMiw8ZVPGd35+1oFdf9tAfV/+ZrgUaFdEdLfsIAoPmry92tV1MG0y2XJwJmlP3OAlW2cgUk0+x3RCGK5rTwvMaBEnb81zWc+3ya5t7Ai2TVRnc/UmjP0WL9AJj/0baoZzPhdSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M3Cyl69c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iNqBJ5Cy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M3Cyl69c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iNqBJ5Cy"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NF55LD1325333
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=; b=M3Cyl69cXgWU+3dl
	7bZAy7BvT8ATtm3EmclgD+SEr2bQw8cSOVLhtaJhn7ZSSkX73hw1dOnFW1crM8v6
	HSzMrM0ZOVdDwOA1cewEqzMubBtGJ5VRXHFeQ4XWK9udOO+vobgj1+UwA0d8zRX8
	1XpLlV4R0vPns/pv2z0LPcGynJHMdUfXSvbkET7ky71A0qo517tubAsyBzPKsx9P
	Sb0EnIocFF2dkj/BeCWNvyqWaTm+zMzBtff/RLNuFwF0f1KY5mU30UwfLLKcHR0g
	mdoIqiKel7XyGsl0UJ49GBj+W8wcvMICOwvW3jHmjT4DP3DrrRZlv9zsUUsMUZeE
	3rRtLA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkn9a0mx0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:46 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5283df62d68so17270061cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826586; x=1785431386; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=;
        b=iNqBJ5CywxaTX5mY4NanqqB7TIT/0OY2hCsYoCOkkuToprTMoBrl8a3lZ5lo3cIEwx
         TBx3HWG8MKQEC7BoFBj1ltW8NPPCAg0eJq4gH89+WwORGID4fOiQXZybXvgJDjPHfFxd
         s7+MCo0G0hdUZ6DwP3WPUzAN3wU2oe/6uEESv/US3lIjS4B2ieb7r3Jk8BHMxRfwcsnM
         Nvb2STTtJo7TWiMSEvaxAbh81S3gF8mB2d9rTPx2Ac4TEVXyYlNX7yyxz0mOQATXHq71
         RGgWP3ItNhgawwkOUX6UGmYu9dEjwsXlckq59EMJ7GdXryVSpLaP8298pMSTG3I+nlPA
         MGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826586; x=1785431386;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=;
        b=csfJMDUp8PGB2H/yd5O3HSsb0AKyh429brigAVwSstcsd6LHzfwXTA0CaJyQRiCV7D
         OQqL/Aq2fs/wPHbMIv+KzxonqoDG9RJ22Qfa0VmrmDXw4iVL3Yq48RVvghxi1TQqZkxx
         BO6c1lZaTvveGwAkiUcV8mBRJs737NLxgkdH4zbFvmbNShYJX1frsrKaqY7Sod9op0f/
         aRRRZAHI3SeT78BTnj0zx4Q1EBJHsan32vwRULkjZNQPrsl0bl8l9tR0s+S9HSw+IRv9
         NnEgS1ldlD+1Ly+kK+fQwIkjkMmqmQcqZoiydz3oUUwKPTEM21fO3gWkvpf/gURtu2cs
         FItw==
X-Forwarded-Encrypted: i=1; AHgh+RoHJUOhxynKMaj8cWyE9Kf4sBTWdLLR9LJGcM8VBGgG3UmnXb2ZOD6PdnNFzc7qHJFUdlPJaFJNfJGkLoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgHuAdMd7LyS1EghTYIhEY7zo6MLgNUmQZMIXsv0EJQUpIYxt4
	RzAHVEcb9yGSLI/ggbbzwvEuiKQvq7QKn8NbroJCEJqyQSyzbayKVA55cMxmWbINCNbM+fLjIrl
	Vz/VTBxipL6Kj7xv7Ry+cMyq/bzCQPQqCN5snQaO40SneT+pg8LgIsUVs3+rwTa9QeK4=
X-Gm-Gg: AR+sD133b+PuLr97ZtigMiogmk8lsS0OdKEWsvgzZ1H9tSVXYfcemFTXLpsjkORBbSK
	OGRo9iedXeRdpDnsZPgIb8EDRbctOuSOuc+hPhmMxaLJVK95TvQVo3Zc+lsewBUa6ffD5SHGJGd
	OjM1x0L6Ucd2mOSsaLEJ1flx4yXQzVphhi9j07WwiulNugPatQUkhMoHTMrgDgChymjSVZRJy4E
	+aX14rjXrnnHuCuQNmYbFCj0+CbqovVS966SJ9Thcn6Na/sdy69P9l6CioS0N889E3SaqFCha1/
	ZTVAklFxs6NWlnfk2iLV/YC/1DOHGFdfWdMhwKyq6m7iWgCNlPo40n6dIErY2aNOYQtMsg+0I4D
	YrTME+Ous4tj+rjAA5xjeBS5GYkKL
X-Received: by 2002:ac8:580d:0:b0:51a:f94e:ce51 with SMTP id d75a77b69052e-5283ded5b72mr32348521cf.50.1784826585673;
        Thu, 23 Jul 2026 10:09:45 -0700 (PDT)
X-Received: by 2002:ac8:580d:0:b0:51a:f94e:ce51 with SMTP id d75a77b69052e-5283ded5b72mr32348161cf.50.1784826584952;
        Thu, 23 Jul 2026 10:09:44 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:09:43 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:10 +0200
Subject: [PATCH v24 04/14] dmaengine: qcom: bam_dma: Extend the driver's
 device match data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-4-4f87bb4d9938@oss.qualcomm.com>
References: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
In-Reply-To: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
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
        Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4322;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=HGeQqzQf8+DrUa/4bzOvLohFWS/bDVC1MPHUwVaBFAE=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrCvDnscYF5kUf6Mp/2eDen/yDbwikQKtft1
 KTtqtdDMMiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKwgAKCRAFnS7L/zaE
 w6OuD/4zPA74drmfeqhUyo1KEaxXhhhdfBx0+mCETQAaXZVxinzUTtMU+cYKtozIiJYUIMZKNyB
 1ZsCFc/FE+fv1NUvXZ9a4yxkzuvG0Ec//565pchVrOHrPbjOs0yiM3JpMYVVumzriF2lREehVEj
 Ia7f91E5ODhFX6Yccp2hApR/40AM27icIGK9J+2fbozO4SyXtiVPv9aV5sUtVYLfm5tEjvz4Ghc
 yxvd5wJnqscNrNy02SUj4U1doUnv798meLMxu+uHqa/ai9BB70qToYFzK8dlMiLdn8GgDD5KlPA
 8HCHp1pmWtZZjXrVTtYxOvJzUNyeH7aDieBtPxWhUzbwX518OFObCqa2lLcdQSbWDVPUbhsNZUI
 1M9SBkpgVDrCeKWEcMU8baGVJhZq4wTjR11ZveOQZSueF8lwVvJkTqDjlURRM8gxdqaraZFHhQ0
 IA8QA+VGg0Pge0nSFjOaOCrjGwnP4r/ueMLWWXj2oB4Qh4xRtCtDJJhcceohh0Ntz8QerbEIKfw
 0ebYD7qKfqPMJMrvf2Vy9b6xfTY7ScWG/523eJsfdpDYYQB5tMVMFTBBc/CbIA54zGmq760eEoQ
 lywH38YJ2y34AkORmBVzyQQup/qNHWjGED4lBcETXH3GG9ycdgNS8E1y6j0bB34yCPvGQ5DuuMU
 sgMmdCddSoiSchQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX6AADDnSh9Ef0
 Qg5Hgh1vwFqeyTRzAmyoQFirle4A71x+p+wuiFJxJoabnkt0PbrxM8IWbPzrMg3g50/fVlNHNEU
 hevmIrF00xZ8jtoNRnNTL0RoUf8YwPFsfeJQLn8MPh1Ja6UbOrilurNXSMP+vCi7CG1oPKp4RJS
 UhuqQN4/PxMAmPd1yEjmBEJCnBp8TE2+lsVgUWrz3LdhiW5C5jzKuS69TFDikkWVLZzJgwA5gNm
 Kv/FXUYM4feFQmFpMW9hmDVs/t4geH8lMMdCAioOS/57eRxb6wZ5qyUDU0cZWQEgPUsjO8EgpGZ
 FcRJdV+WBA/xbVm2xrh6pKFi1D4a6j7ShiUbMxuZokAJj6Rzz6wh8j0MY1GkPcyPng0lhhmjd7u
 Jv6S1vu2qTLzZHu+DXDCppmYRQNXIiUrOgworpa80yXoK7Arc5unminMdtPnYSh8xzzh7G/u73n
 3EwN7+sOEZabtz6vvAg==
X-Proofpoint-ORIG-GUID: DRJXtgu9H0G1aXFx4Xm2nqJAsrpclEfm
X-Proofpoint-GUID: DRJXtgu9H0G1aXFx4Xm2nqJAsrpclEfm
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a624ada cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ioP1PY9e4_dTeLeN8ycA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX+agrmM0bdtlM
 ccxhSzL7clcSrhZsfDen4atfY4GFzhjaAyYIbESAl9AE1bGg5lp7a6KkoO2+rbTQDIIhDs30qO3
 F3HvQyPlh3p1tejy2hRwILN/l/4qsXY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230167

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
 drivers/dma/qcom/bam_dma.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index ea3df28e777f99c0532761b6aee6807ab23ab4ca..8ce0fe085c5fea6cc614edd692b5cfd264b94d5a 100644
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
 static const struct reg_offset_data bam_v2_0_reg_info[] = {
 	[BAM_CTRL]		= { 0x0000, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x1000, 0x00, 0x00, 0x00 },
@@ -229,6 +245,10 @@ static const struct reg_offset_data bam_v2_0_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0xC820, 0x00, 0x1000, 0x00 },
 };
 
+static const struct bam_device_data bam_v2_0_data = {
+	.reg_info = bam_v2_0_reg_info,
+};
+
 /* BAM CTRL */
 #define BAM_SW_RST			BIT(0)
 #define BAM_EN				BIT(1)
@@ -422,7 +442,7 @@ struct bam_device {
 	bool powered_remotely;
 	u32 active_channels;
 
-	const struct reg_offset_data *layout;
+	const struct bam_device_data *dev_data;
 
 	struct clk *bamclk;
 	int irq;
@@ -440,7 +460,7 @@ struct bam_device {
 static inline void __iomem *bam_addr(struct bam_device *bdev, u32 pipe,
 		enum bam_reg reg)
 {
-	const struct reg_offset_data r = bdev->layout[reg];
+	const struct reg_offset_data r = bdev->dev_data->reg_info[reg];
 
 	return bdev->regs + r.base_offset +
 		r.pipe_mult * pipe +
@@ -1234,10 +1254,10 @@ static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
 }
 
 static const struct of_device_id bam_of_match[] = {
-	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_reg_info },
-	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_reg_info },
-	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_reg_info },
-	{ .compatible = "qcom,bam-v2.0.0", .data = &bam_v2_0_reg_info },
+	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_data },
+	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_data },
+	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_data },
+	{ .compatible = "qcom,bam-v2.0.0", .data = &bam_v2_0_data },
 	{}
 };
 
@@ -1261,7 +1281,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bdev->layout = match->data;
+	bdev->dev_data = match->data;
 
 	bdev->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(bdev->regs))

-- 
2.47.3

