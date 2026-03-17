Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDEC3E1D02
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756175; cv=none; b=YvcDBEX0ap0xj07ZWCnb337YSb3yzQbmS4Lsw0Uqo16XnqKy9dSVCq93OyQlJvcR25A/6CHJQoVeXiEvLBX+Evd+rJKxP+7Zh5BOU9FHQs4PLK6Rz4+6V6ynccGVfj763qPc2I95PRSjnhm2hu+r7XJSNc3ItuD9ZIIkUD/ulII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756175; c=relaxed/simple;
	bh=QtDKw3sIoTdfDtZw65i+I58veFyHFSLP2ujI82KTTCs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QqkED59AkiLHXVasJ+fnxSnkX+dQ1i4nnEXHivIBMcEQedGC+IunzoTzWt6/dJIFAWFypWjSP2KZ0S7K8mX5i/foldDPmvc+BpwVbjM1xQwaJEuXfqp6rBRDAYKSMSD/HFiEQCSy42FrvfFvTcQntNLp/XQcVsa0bDQRIb6eEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=loVfwRdh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ch2r+9V2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="loVfwRdh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ch2r+9V2"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H8si892314590
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AJf/VHFbEfrJ7fM8DpDhu22yxXg6EYy+KGz73+G0kyo=; b=loVfwRdh1i/4Boke
	JILvkzsLVUSHae2BjxTwFw8yxFJmAzZtTLOmXWCES+jxhFREgnQWVukaS6+nQXB8
	sUZHk99V8NC5Clj+K+PGbU9rs2OL3AjCAQ47MI3deIT2/HFC1ERja+G5hf4AaTzq
	l612DW/N2W+9uKNzHWPdFVc9shdmqmIA4ursWoxzajWwgZWOMtH+25nikUHePg83
	AZo/fdtJEPzuav6FxZsp2kz9M/xF5ZkLZuDim4pyooRZ2IQ1LAgcL4WSAnjrm/ji
	pNIjBSIcSBZ2QlvxpUwS1Z+IDRyoW4zSzJS53T9KiL1qYqabp2IpjgKYrqiOU4fU
	he7VJA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxmf2c56r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:48 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5ffa0b00da1so8385114137.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756168; x=1774360968; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJf/VHFbEfrJ7fM8DpDhu22yxXg6EYy+KGz73+G0kyo=;
        b=ch2r+9V2vx/P1t7txS2E706Hv2M8zRUSRBVwEhiefc6eI2C2apgaDNi+CuUUOqmcgT
         E1xqgeLRAxVpUrTr6IYw/m9LJcfh5P4vrU4s4jWYmn7XAt9/01DS43PogX+d2XLKL263
         14EVL9fYuCJMSEHJumRYleaKiPbLwrj0cexMWvg9OW2Hl2aa5ZVHu8imLCCeIyz7S2wv
         8N9z6zISdQuGEuvTtVdDRp5AltPj3kzFN/K1z5ycr4elB5SaTXelUbZB+0aqhxGQv+GU
         JlmriSyWT7mEV0T5bgJpck6dWle8FKL+gi1DdNmaBGUQaZf9Pcr/heBWdFO23RmcvAg/
         Qbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756168; x=1774360968;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AJf/VHFbEfrJ7fM8DpDhu22yxXg6EYy+KGz73+G0kyo=;
        b=rB4Oy34S7prw6lP5w0lm81wyBjdjs3hfAxJj6782Vxxm/5CumsqtzYwSUxUfHo/mwA
         Wcs8ExXzIRqozyfT5KRZeh58ueMPBVfOHgIc5dDpntEOQitc//CnFGBXpPA/FNVEThOb
         9M3IUfgiyU88Qaw+PtDoQsaN7lEE0pC8prJ4fj2xdYEwymkU0Wo3wB/tWuNNqAQ8zY3C
         JOlfcF5wA6q9I5h/tMp6NfEuT1Ewj1NdNc3EZB/Wjsvg5zHPAfFTBmUUC3hOa3tFaW9P
         1DFWWjphBhn9N+3P8iRI5iWjgEPb9CWq21BKPdsHID3Ez+fmuzk41byloVmunZ9EMMP8
         648Q==
X-Forwarded-Encrypted: i=1; AJvYcCXYu0akacjM1APq5HA3k0urWxuo44/JQeb9LSkHguzw7QIGtEW2XQBD48aAojixRg2oz78vCVzruKBuitI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9/UlmUc3jhKt0vA0yCT4165cJcTQ81QWk/hp63Wa+FfUdAjnC
	I5OxrDlvbzarMD57c3Jl+3TQFrR1/9k1uoDovXsJujDJCvXMoQD0ArAXfT9ThY0kEIhgQ1KdTKH
	nbPbX8lCnjUgHQQijI/TOhBliKOz0tbAvWGs1rgfyHORSPQuuAEz920RT/zQXuje9lTA=
X-Gm-Gg: ATEYQzxkCJhzi0RQmmGOZkY2hZ56/LbG8QYoBiXUNgp2BQeP/yKZh3/O/h8rU6CkBNW
	sz7edeRUD2RR0+ZmJvOEa41Sk/vEA2tTXO0wD90wXLdp9JwkwyNql8oXWWxfebJyLzI9f+Nzvnl
	mQebcaciRslgFz2CIBp8mAaknjBPyO7c4oaNLZKtaamx/+8CvsbEFAGPqjKC4JNYDZDcV9Ve6EJ
	Bftr9hKd6Lm+PzHAPkTGYlCY8pFhMiq3oDQvl4hvUDrf7OZ50wc4FIhXEwLdl9Tktq09UpuUk+P
	xb1KbnHOneYqsKDr7jak96lkCk19V9dpcZjoPmquJevC3gsx58B7Q2vREi0UuFeySr+GNWsteB+
	AG0VQLX62ii4Yq3WgRbRmPesOt2jLjhRcim9PKHCXZi3P5wfYEZEt
X-Received: by 2002:a05:6102:cd1:b0:5f5:40ab:2d65 with SMTP id ada2fe7eead31-6020e4c7652mr6014757137.22.1773756168171;
        Tue, 17 Mar 2026 07:02:48 -0700 (PDT)
X-Received: by 2002:a05:6102:cd1:b0:5f5:40ab:2d65 with SMTP id ada2fe7eead31-6020e4c7652mr6014711137.22.1773756167698;
        Tue, 17 Mar 2026 07:02:47 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:46 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:11 +0100
Subject: [PATCH v13 04/12] dmaengine: qcom: bam_dma: Add
 pipe_lock_supported flag support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-4-0968eb4f8c40@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1425;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=gfl+Fn+ISpyM/izQ226zR5pAGJiHs0gWIagW7nCmNI0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV7zC1mwn8ggHJQ+ya051XpuSpuUqQakAlBbW
 EbFaeyomTSJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable8wAKCRAFnS7L/zaE
 w0WOD/9z7WuD2HMlS4az2EPaO3BtEOeMdY0s989E4rcqOi8GVYeyjZZuVCEgbixdFdKuCE7ZG//
 wUeoH02qNmzcuJyM576CMaDL3txlad5WizKfRalKpVdO7Pw4WrnSbo88KrocnO4S2+cLHQcX1+S
 AOrGyqz20MKy7ColYQDwkNxGUhG2TZ7DBkapuGsdJnj1iIdcAwx0lN6uVsNVzUsc+yviQrZzvBV
 rx/ibDEM+G6rMudbjkshfEbcvYrqUGPtEjGBPDvJjzb3sxXuTuTPhfzrXmYTFKMdVTOWOzu4Dim
 ufZZDfW5HrMTTVDE+tSdrj2BhKBQZ6atrvAwBT0QwriLzKMzZB544xKTdowHas8ymOQtyGqbW/2
 1XWwqPRphL7Pgnc98JpcIkLYjC8nOYjjry5ana/KbsFYQyQUlhTJVasEPy920tiQOLpo11YZUHY
 am2E6hCgxPir6fVcXkAP8B2GjKvgSinGTZ2r5EP0GtD2oGPelSo1nxL0uYe6GfYUQcrMWX+In9/
 tuD/7wtSi/6LUFG1zRtN9Ne37Cb/5DQzROzgC0bwJq5WdMbJw8AGN+phH6s+x+LFIbyhhUToJ6x
 hLnTkwVPZabyaC0fckn5kQTVbUxAVuJ0eDO4b+4SbHFaTg243/jaGrGb+/vBCYmxZvhV7EguJyu
 09LSShsqq+CfI2w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: rKOPgDEQumVP9MXddG_iNapFXD6khuwG
X-Proofpoint-GUID: rKOPgDEQumVP9MXddG_iNapFXD6khuwG
X-Authority-Analysis: v=2.4 cv=FvcIPmrq c=1 sm=1 tr=0 ts=69b95f08 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=ZSnkYuKn9ZpO9KHknGoA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfX2EebpHJ42zTD
 QKxF5Ov/YAOElvpeydBDpR0EPnp8Ha87+r0Z6Y84E76RaF/HftPgROmXQ6rJmvKzlJvZ2KsXnCs
 IYXczrPUNXpchUv6JukOu6C8+Hzg7ygkCjmuO0iuHSL8VJaO3p3yiMwxkUMgswPDIP8gHPQe7Th
 tAi6HMbG41Y64kpLwE+iR9WPS+1GZ0z52Qxfuco9SF2y/waCznM8Oo1WIaj5UVlGXl/1UeOXr5p
 aWspShcwh1ksdn8xybNIAVV+xL5B0aNiImRDhBY4KqZb2TzaFg6EaXDFC4X78fLEHfVzUxcvK34
 kwQF+KGWj9T1+3KDBpJry9EHDdpWdkrO3MMpg1exu0EFLY4FKgcE/yc4zipV8NhqbTay25ESrLi
 yWWJdxFJ9llyGs3qHhFKKB0G2FxJzplkkmo+qd3d6DRd8TspGdKIfgaKFMTouAvMQqOqgEIRH6f
 euPQ1RAkhsGq/62HdSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170124

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the device match data with a flag indicating whether the IP
supports the BAM lock/unlock feature. Set it to true on BAM IP versions
1.4.0 and above.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8f6d03f6c673b57ed13aeca6c8331c71596d077b..83491e7c2f17d8c9d12a1a055baea7e3a0a75a53 100644
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

