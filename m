Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2896A3E51D6
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277427; cv=none; b=sXKOG1zK1aBsCLFj/aeJ5koqsWcegYnttHImrGbnZG3/tMm9Gfs9QH8Hvi+u+JwyuXe7TvJg92qjiop4GVOiRRWxPlJ44AYJ9F0W44I6V722sNts9mQr1uv4mmopOf8vRV8PXhDSPtmkjGqcGT6xvmS1aR46JAiI/uGXyPw2oB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277427; c=relaxed/simple;
	bh=1Q+aPsoEc8W4PfEahFbzsFEdkzT9tiwxUCi1Nvr+Dts=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nMCnir5nk+U7B6QCOvnh7P0yw5YWgrHaTvFh5f5it03Gr0lSMCjPHAyMCgYAUenSmzFKv5WERlo2RM9aSjYf90adeOcrIAtssS/9v8FUtX6YqYadFA+zW3n5PjS+nCDIdLRDN+7XLzfBvzVYsmNy+K9SFwfnIOLrV+P8mbFsRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g4YeLGiH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f0RHS/at; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g4YeLGiH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f0RHS/at"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H6ciPi1093126
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=; b=g4YeLGiH6+ded1ZC
	dZb5TjpvGaZEUjo61tv6Q7n25hKu50vzBpod9Z4iD6CH2Fevc+wsXiXtLLYxOLd+
	7VuCwVMOCbTqqAdgR+X663s+cPQgH4RgtL8nf0rdfKcjGDXU8GMIyistlglMBaLS
	4CkP1Lx2RsmZ77oNXw6tghg534LsogPFFllUhVkBbE4/n+rGyarO8twtoDW5ckba
	gKDxC+iztUXwWgOHRgOe0gJ8JYwj4et4bJaj3BsYwxgi8zKBXxn4cA1QVYuD1B9p
	scMdkTbwzXcciGSABbXEPRYIQRQFliW7P2O9Tv6ihHTQl5OpqdqT3Un94WMuJMiA
	2ftMRA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffe0urrps-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:01 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c1b4d961dso25197251cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 01:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784277421; x=1784882221; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=;
        b=f0RHS/atsLdR/Wujhh68xkGxZoMW9KXjzFJ95m2GmmJJcqRj+fvoxoV9iXH5kDdSh/
         hjkrt6X8UhAS7gV9SYbzLYEgD5lzAzvEeqEWlddG8KAXc+BPOHwqHGC4oriXhx34gfdv
         AbrwCeWrge8v/gUoVm3hpQxe4YxC20WXtTalmBVrRGUxcabQaPaH2mkidemEc1oOIGI/
         Wr+v6DolWkk6C2zGd63Hx4tfZHVM2EqzXlW7ly5cx65p5iIVP4Zs4nmEDPzItTGxoxwS
         zPjMpywIMYHXN19Wmf4YXqXoW5iUcEluwZn3stgBtNFgepMsm9VHqn+HHzzDzUfBhftX
         uS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277421; x=1784882221;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=;
        b=NOd2wZQ39qWHUM43iX+ud1CEoiamph4m5nbGW89ap2KqsVIfbflZ5qUpD9KtYiVtJp
         lGDe9kI9KKE6HQpI2jXH2qTygk5OQt8Y/Mkk/ygkSFZFjkf3al2Tmbv2vt4fn2mkR16C
         xadPeGE8OfOYIRP1Afaic4VcLf32pnYn4isUmxT8xPJ30POgcEJ+0CFC5lnimRbSurdY
         pxbWi26BMAnugRZsclbK3fTsCxwuhGu7vcOIgoXNz1sKhWWxO/sS5xvJAYHrDHc3vw6d
         KrcjR5xB0OGfmUQC1irsoCMjtXpCLOE+8l6Fc2nXsrmZw/ngTq5S0DHOpDi4RvAewDzQ
         wrCg==
X-Forwarded-Encrypted: i=1; AHgh+RoKc1Swc3ZmwzMMmneImyStsE2Xw9+CO0dkmAipvZVvpSm8S/NgDe72jeGaIWvHfmZ4H2UcglKuWi7jFRM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Dsj9dkjw6PeOLOQ3nQ8EqDiKFN513GkwfER7UQYnAvauIil5
	XN6e+ek0SR+gcj3/9+cSIuULodX4KOTcMoX1dp/Y6emJXRMErJoArHoEsTriembPx0m1w/U5Dx6
	80T6jsNgEARttq4+Fjmg+vjxc9/B0CrIP14HiNUhLZfWvoPIqPccz6OqgUig/L4J5jEc=
X-Gm-Gg: AfdE7cnDFkbPFO9K8wr3E/9DxlmVhWZqlmHXWkP1cg7+P1ku30w0QJYPTqTJIHbLk8w
	iwdiBNufXwHvXM9IGbXu2sCo/VeuFAE2XLgwyZqhOpoTssTYN1XcrcMkT2PCUyeA0V+I45EoMxZ
	vIOD8782wpgLOEJ8qUNF0n/kamNhb0U2Yjvv/Wwo2ukz7Q/LJf5tndsd6/TviSUtzX3Lm1q1FXq
	/6Equ2GqBeTV35boFTc00WGm4lR3DHScptndp83+QAMFwEufVM05jebJUOEv/Op269jka7HfMbt
	L66F2OsISjK65V8MvErJcnLpNnzvm58eb0171LD0gv5fcFYCYd+k8qDKrEfkXqYe8tLSJ0YRv2M
	ImpNybx8VCTi00c4F0PAF87D4fPfhgw==
X-Received: by 2002:ac8:5fd1:0:b0:517:146d:2cb5 with SMTP id d75a77b69052e-51fc1292ee5mr62938851cf.20.1784277420680;
        Fri, 17 Jul 2026 01:37:00 -0700 (PDT)
X-Received: by 2002:ac8:5fd1:0:b0:517:146d:2cb5 with SMTP id d75a77b69052e-51fc1292ee5mr62938581cf.20.1784277420226;
        Fri, 17 Jul 2026 01:37:00 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2b893dsm31268205e9.8.2026.07.17.01.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:36:59 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:36:30 +0200
Subject: [PATCH v22 04/14] dmaengine: qcom: bam_dma: Extend the driver's
 device match data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qcom-qce-cmd-descr-v22-4-ff0d18b27246@oss.qualcomm.com>
References: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
In-Reply-To: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWemY2d5rTg5sbM73ADQjznvK2IlAE9MYo1Zkp
 HOdG6P65i6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalnpmAAKCRAFnS7L/zaE
 wz6CEACJVl1lDxT4uVVOANBn/C9UPgXVvI/XRb0g+zvA9zUYyaARpIGrYalGFVY2e24CyaoQSJj
 HqaZzMS6iorvUpcfzrt/jHIImjGzemgoXFDLPeJsAOhjhT3U6HK3UJHb3oOZTabuT5l0LlCCrKi
 k/ZaXOovtp4VrUWw8wyeJeQypA2FWkqtG8HwWAI7hD7Nb+qvz4gb4OfJwfhVFBYOezrUTgbh5ap
 rLKys6MIfLWtTnbO8MO8osefGarY3gZp+4gL61nNqnMHwsYeqwUgsETv5wwrl/amod/qMTYYT5V
 o9VgZwpKO5Je8IUr/GHPsyK/t1yNjmKAlSGLym8QVvnNVw/godQqb/Gt28bBSoAiJHAdXfBU9QJ
 JnHwuV4OwWuva577d1IeSjuuJS0jaeVzrHjcfdX7rp+Rd1dtj6zrYPZnUWypjQEgKiI0xLTg7Ld
 GnjW1XMQmvAPl0Uchk3dsXISZdLZAO5l5dQs/qDZWpDWpK7mbMoCMO6+6PpY3XoqnjO4uVpg3Nx
 db0FRNSrNfMP7U9Uq+1QFbpv5+XfDezjJDqRxWrcQUnn6oR8LQsDadaTM4e1fMtBENrT9c+i6eF
 Zwj+OJdSVME/p6pOrWYKpTCwd4HNvp1Wv35VKzslRWQKZnwjCGT1bP6FqCyIQqdP9dkI/38vAJk
 Ys7ANP4lED5ku3A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=deWwG3Xe c=1 sm=1 tr=0 ts=6a59e9ad cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ioP1PY9e4_dTeLeN8ycA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX9PIB1TgT5ARC
 sVzC61EXWt9OPqKmHpjJD/xHObRb1WJM1y3HzGsw6t7Ykdbg504Os4/dpPihCMKLAVkc09Oqyg7
 YmFRnFsJ4YI1+dDJe/Hi+KoOp6SlEpKUUP4eVhXlLYpeXYbS9xsxMdk3u6UD7B8TClN7WJ/ci4L
 8XdnWAaihXFA3UlBXol7utHkeCmbrSCS/8UEO8tH1w0IECY1to5sKLRrc7vBK9PglVgq8i8ZnO3
 kfgTzKI1Qi34Y9CFG+1hT2dzaSb0CuS8qg1vAZQKr1t21zrIJfkuzAh81LAr7UY/eDXoPy+PFPI
 UAUxBX6ewDN02fmmPbnNDop5PKyO0kos60Kr3mJ26Tvva3u8OXBi/y3L4Kr60VKxU6MtmiMQDNC
 c5uL3GCQb4AvsofCacVNBb3jkgn79yeCzzSrD1En3oOEqjEP9NipZJDGyvDaWbd3cy5C2mZYE4O
 ptILSySecdTkebbAk4w==
X-Proofpoint-ORIG-GUID: 8sFZMR0Dg8wtpp7kiLd3pktthjjIXoru
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfXx8uZNoI1kuNt
 6Bo0lfjkNxsb/mOnNzx1XGmIWiKAa8miqEbLDtxldyYsPzeGMMsjr0xp1yZQUN13v1mV58PayjT
 6aOv9CjW/S5lVmkf9KOnDCaxocrHaW0=
X-Proofpoint-GUID: 8sFZMR0Dg8wtpp7kiLd3pktthjjIXoru
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170084

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

