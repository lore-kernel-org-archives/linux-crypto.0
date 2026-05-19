Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4646B4F7988
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779196703; cv=none; b=DKWB1IUivvXdsj+XKxIzL5petAYqSiiMiXIX80XD654IKvpHdtVt/qywOK0BFRSJYkhWOnTzAggy2T9q3wbwOsrVcaqzNNr9iVCYY3/qKiCmj6TXiyCAayJXnyTirlLuroZS8QtrCC4k4x3t1UQ/2Mu9DuXVLK0uaMS7l8lyqfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779196703; c=relaxed/simple;
	bh=FjlWrhg64aXopk2c8TNW8F0ETOsoah/nz+L00f7HWu0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ysid6v9F5SHlhDDBS/S8ENce+Q864r1AyFzPESXAfN3l8BzVAj3+5/pisnLMDHS1qldO9xKM0ljlIKTQbIPs3wyjr38U7BDWkBQFdO+7AO9NuoY+Y9h8xe/R2jIisCQftX8AlsskFxegOh0nNXkmkBUYx6/3v4cdXsrQfynmsrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JkNp9NOI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gynW/fiv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JkNp9NOI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gynW/fiv"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J8EGSe3612448
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1Gr0t6VI/a0hOXrs496vSrF8FkdFJvUknR0vCq1ph70=; b=JkNp9NOIXoxe9TZv
	FR5IE7jqxMa7D63RJSLPOYEmsJlQ1KK5vGaPhXT8UgrhZPACpSSS25Lxw2J/v3qC
	YMWWFUuiJFTsC2viMmb9jVfnygIF6CLuLzM9R4hzSNaGMx0rWUdwCD1Ozq5TCgcU
	rQU7gfM+VWMtrxE6tb2niuPltB1ueqavLthCyqoVkBzwK/NWvoymU34ncnWBcG5n
	rWXfGSqG5zU/0OOdnbGuAyX1z+PzBXBcQCK3VwNfnQP+b+ZnWnCJ01bfW8LLsItC
	Di8PHpdUJBD3rcp3QTiO68OQCbNR4jUQjljQvmassS+XeHFPOggiF/ch5mjV8hUd
	zKamGA==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e8m64s791-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:20 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4824a871018so3276111b6e.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 06:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779196699; x=1779801499; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Gr0t6VI/a0hOXrs496vSrF8FkdFJvUknR0vCq1ph70=;
        b=gynW/fivuNHYfNpN7/cZBw2TYrKe9uU28geaMbo9/C22JV6QoIaDnO6yCINLk4+DWk
         SYpP0PFyCoDrG2CtWDqqGmiwFTwpA4C+QIjWFMdN9Je+F2xU8hah7pT91IvvZNm0ntKi
         te4TnkuRVxmGzq58fkXvTwP8EghKnhzmJfpsggy8CcJtMFBPP6Hj2S9DQ/rs+4KaOgHS
         kcNsZyiNIB+zIFoQ/0/TJYkmMviltwbXNcI0ONpoTlGxbRosdXE5kfCiPsfceoS/NBv0
         A7YRqN0tYYkoe4KBr+fyZC/Dk6DVkGWHchxJZYO9vRitcsK2N4KagSCD2Wj2bc/k5vfR
         a0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779196699; x=1779801499;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Gr0t6VI/a0hOXrs496vSrF8FkdFJvUknR0vCq1ph70=;
        b=hVG66qSWDXNlmGdtTwQiURY4zOJALmSF5uUp4Ns1MfKJ2r/jDNID8i1UN5nbBWONO1
         DhOK7EL8w6c7zAyAT7tQkS9/uVI8s6Mp1HQlKUnqfaJ7QQNNS48AECfJKQc87v8lbIrD
         YAWBOkoY8SPNf+YBiXF+EjO/kaBAlFSElbW1JBrd2G8UN2xaJtOtgoXD+UbAK09vEsDo
         yY8S5aG/uBNxtUOJBnw/5En4osD3/7SIb7iU5nf3y0ESou9z9IV07Z1V6wcF6fmG729Q
         YDTYyOIIEPBJ39m9N/kgUNIMep1Yyp2VC5dtKrNBEHCJ6osPQnUpNlJ4tItr7SnRzuAa
         yM8Q==
X-Forwarded-Encrypted: i=1; AFNElJ8f6aj9fBvFYEsN9AJXEE0jvNWCxRifTnhcchN+oQFdk+IahHycMJt+k6CELHEhygeaboAAZQIJyx+SGGg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf5xS3UtoFqIkZir5n2ZpaHmp8ZSfbIXQ9ZOXCNNYnBMdyf/H+
	SVgq+V28UVg6qPX8aADpaiK9/M/XdyMNY1We7aqfcNQrI8RcvfwsNGZO6DddHZk+BLnJjK75ztp
	+DlD/G+OkNrjgm8ZRNrU/d45rNCKfMKsUqMiF6xSP+glkVpG/U85MyqNh+Jkf5526Rn0=
X-Gm-Gg: Acq92OEdpH1/UdgqqBzbp2noT343mN2NuIBP0fp+eZv8NcYAbotGx81NS920qbQUZ3Z
	CC6ajHN9lcZVSkhNHOK54+i2v2jXJTNpG7msq3gB6+JpciKsW2I0sUTvbH7tzxbibBFHLR//s6f
	kMV0aO3OzVgIHceZG4UjcpPONm8CB2CnQxMk21/r/FMNdmSmwZB2mzu0k0jAguHY6NX7cCwGemj
	rzJFUbcAI7sjtSd9AC2MvjsHFUw9oQvE9c7yuKK9HpdDRvPnJzVvOCvcxFNsO5Y6RL8jNqTj72P
	jTv5pAv4uQfuqUaTr+ju/NHaXYDm8LWH5U6aNBacdcI8RpAu4EeVVoOy5CKcC4MaMt0Q9h7cD11
	2ozj3sMYaxZX8SMAH+fnwgEsFPuQSvlZrBQx6H2oaaSDx6yfqi3w=
X-Received: by 2002:a05:6808:50a6:b0:479:fe0e:e83e with SMTP id 5614622812f47-482e560891emr13202795b6e.14.1779196699284;
        Tue, 19 May 2026 06:18:19 -0700 (PDT)
X-Received: by 2002:a05:6808:50a6:b0:479:fe0e:e83e with SMTP id 5614622812f47-482e560891emr13202768b6e.14.1779196698704;
        Tue, 19 May 2026 06:18:18 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:3fb6:74e3:3c25:ba2f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe7dd22sm143969195e9.7.2026.05.19.06.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:18:17 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 19 May 2026 15:17:47 +0200
Subject: [PATCH v17 05/14] dmaengine: qcom: bam_dma: Add
 pipe_lock_supported flag support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-qcom-qce-cmd-descr-v17-5-53a595414b79@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1530;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=95UZqYCVoso2D8UWFsBEOl96nt3UOjBik5wfLsq4Ngs=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqDGMGcHdXbfyHT99vDrDX+RrK/0ep7PuqhyhyR
 nnEczoWRnWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCagxjBgAKCRAFnS7L/zaE
 w5ThEACBFJwqWuIBl/1eTJS4fTvqoKnroUsfcrhv/TH82B5fHMnFllZQw2arhmDFjmel7jjoQpK
 va/zXYByx92u2Sb7LeXe2wzPO0wME5W8+6Gf3tS6VXg5ataVwgVFZgIhSpWOmUmaNYrgP/3kLUL
 C11zAAjEILXj9zQF5FhHxRB23NnKCKc98FVffOeegnf9Fy2cdcUmKoupF/Xtdwg0wVFYpr2hL6N
 xwHTe1vHdXkB8HoPtKBNJIdCWCVAWQ+iHo/Zx2Oa1A0L9VSg24WTFSibQ+va2dear/TzawVUS+/
 zA56o0x/goHUsNpR3V/fAgnp/b29N5vK0iuz7YCLMIbwYRUItpHoititqPrYtjNF9Pmr7JeReWC
 NwPitUtpPEd//vpuOQ868vp7DZ9LDyJpvlLG/GWQDtsk2hPWsPjOlf6yrE6gyyWF6KDXQWe65HA
 VaIdaLFWYGus05MtH0nbgCWf3FCZ6g2u9GQ42MqcgWQ3aP8QHAIvUnhBR26ajda7W38YEkr0Z3s
 Ck3zlSsLljlFVvfGM9y7kCywteZcnmrSrHrjGpzQurDS1M68Lx7CKjMl3fWNAjYUXEKWzZoTfUH
 V5HZpfGWQDCgM1XgMKyEEvSOuGc5GIo3m8m7rOu9TFfoRUTWzXDB/NWXppwFWxdevONF3FBjU+F
 rAXrD27c+U7tjxA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEzMSBTYWx0ZWRfX8g4S5LIqQS/1
 t1VXlDkYEG2xdvmniM872r+UnmcElSi9Pn/jorY/R+eDiAM8+1e0bvK6OWqxb/Yh3aIloQHL7vC
 9Br4V+w/o9wJWDqMIERO33/9l7d2Eg3O++4vQW+BjDA22YhXUCE1j6mCKnR78L7k0B4TJABdwq+
 i3Es/T/vziLINAWGeKr6hX+oroa+UMXV7nXb5FGvUYWM7cUkol8IvxePbLuAD5Iplyhf/pbTd36
 G14JDwgrh4qdh9h3b8now+4r4CU4Io1H+COPkzuq7K0Cow8iaWwUPgM+1Omff8xgTyJbKUhN59P
 vR2GE4nvjZ/A//spbZ48r/Bg7Buek7V+7UCMtcCq4yWVfxpbQB3frpNdyTCH5C0becwlommRCY1
 jYuYKNQRTuPb4egiMGp7CLYEaHRB3FWhyyB4JyHGWYD6jFnZ3EDiza9oWaIn8gsBPXN4i5i9fqg
 i1MwzKI6WfMSbvK2mbw==
X-Proofpoint-GUID: x8VUmy0l38C0TG_DgFj4InObkKTXtckd
X-Proofpoint-ORIG-GUID: x8VUmy0l38C0TG_DgFj4InObkKTXtckd
X-Authority-Analysis: v=2.4 cv=J8aaKgnS c=1 sm=1 tr=0 ts=6a0c631c cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=ZSnkYuKn9ZpO9KHknGoA:9 a=QEXdDO2ut3YA:10
 a=pF_qn-MSjDawc0seGVz6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190131

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
index 7f3d1b6dd5d7660d2743dafcc43878e5f7952b8d..30318cf01ee20b7e64a988e8ce1ec04dab55e3c3 100644
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

