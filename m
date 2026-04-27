Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C99435A397
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281360; cv=none; b=WWAKnLTx+XTYba6C9c9e9/5LJuiuA3zplI3RJeX8WWUaRe9S3qvYZeDFA7FOvp0lWwna3v+jLrBnesMCX9mI9cTVKeXvpdoPQiJvXqRpioXMiPb/0SksXAPSwSi6rZqe/SoqdGyKqsHJEIFRYzI4M6UBXvu+tcRJDSDHk8thVOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281360; c=relaxed/simple;
	bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V8H9yLPc7+URW+b4bTETfniUlkeb2Cj7pKVV0uvB+1JlqEnn7mmM2sWEM/xGAGtEiaueYsg/EJyYeJtsBAxpMAPboVoCV7vQsQbGEQbQyw5MIUCtfxnVVVJT6wLjI46hTG+Yb+6aUninDhJ0JGHT8esBPbEw/b3/ytbQF9DprQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FjHdN666; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dvIGJ3pZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FjHdN666";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dvIGJ3pZ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R8TMJE3682002
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=; b=FjHdN666g2PqthR8
	V45oXYnO/VUmnauw2NoEVFfCkXZ6BLY/FCRuqtYw8tizUiOa+W1HYzA4Z8/RSTFf
	dgmqlWgwtCea0K6UId9xn3lF5L3iNwYWBdmnMnyCg22nXILpxWtoAUgW+kvCSpuD
	f34X3hfkp5YRU1q6jelBEDeqlhuVzArpxQPIiP5+92eovPh5CZRFqHL1jbrFS1Fn
	4fxzmN4hwwcIDZM/uX0PfJxe48aP3IVSgYINxZNMGSrLC6wigM5OzjzMOnyFA949
	GPylZTzW/SPD0cVsBwQMQCcgJZX3g0R8J2DxCFfiOja2cyLqqjSE4L4xDYCPaDa/
	212VPw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drpsgwabu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:15:58 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50faf575af4so38010971cf.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777281357; x=1777886157; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=dvIGJ3pZ/MGePlqaxxw9agnOcu6wW9i+e2flhw1VoP2sZR7J+wqVUZ81zlp+I/6ZP7
         bflh2HkQYV0yXySco901ROIrFldfXigP9v46uWgfpo5uJcAk0E45nFHA2y/AwK4FO96o
         MAxMN50GFsAsV8LQson/qMpEyNsnL22j5/v64vRgOwN04RfdBoyttJ1P6BgNDwzEITpt
         9XOThzyT2Q5wy/uw2gOSnEryH+1zS8jqo1wCOouHIx83kB+JNm5zQJsUPzlzog89v7Si
         oItEl34OQY5JFHWVaLe5DJeQ1DLOONZZSQR+AAqjvtfFaoElolTwmvMz8GSKR8krzl4g
         UugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777281357; x=1777886157;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=Jk4rXAq0pBoaltVkp+IKt9vUhILaZEnQlGD8wro3SKzgKACBrSokduQFeWj/TO/8dD
         S8X9lujy0gT5JBkxcFISkzoS2X74xsMeINqg1AXL9VOw/L+qBAOnDs7uxCbrdmIO3pou
         zcLA+lFu7v8wZerq1Ye0FWjOd94eKAhLrpC8usV9cCtn1ztnHyntIUE9El2UlqG22RSK
         mpw6L1mQ1y/VtlE90xCq64sO26UsgKIaSY+SflRwX3JowmRybEyXP31wdNjYx83Qkm+x
         2mTVCplrkoPdea065OEdoJcPZ4XVkADyEMALU8+BX05Ihg2PjtDpbh30THhXPXflI4ep
         Wiww==
X-Forwarded-Encrypted: i=1; AFNElJ8AXHaTlOFcs72TgbwlbVgYU/Rh93p90av60w7LITXkB0hS3Wbt5LQsW3qcD0thAjnUj0fUtuIfuFsEeYc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5k8x+6gFv7FFdeVyRSGfOYYM2lisftmItgspfHouX3AdoPCRC
	4hA0xSufOZ8BJ9mfASg/JS569YtIgwmmiYtnQgXVdRjtvXbCOQhomUzZkKyLNpbK4Cgoulmae42
	f2FYspHmztk5Fh/5t21N8pKjaDSQ59poGEMKO3cBm564wkQo6uz02esZMmLnstyXeJpI=
X-Gm-Gg: AeBDieveftcspglcp2YZS1Anfn+w68Jlo6IR/2TqrfI8uco2miVcYXRNZ3JXvvgu12e
	9Fj5IucJ7LcrO0efacmYNnFroclE486A5VLO5126YdUteFg+5cfBZ+BScayi9xKGaxpu0OwXBe4
	qPfcD+DX/TL1KO5nTSzR7u3279sSMtWWdOE2dH+4LyYztliHSZYbSgVkAxUxuJzm4GB+71LBlMm
	kBENMr5IQPhOAhMFNTqcts6LzuEzxw97gMymHG6DKVGgrffw+xHqHSgSW5eP2UOgJdic3KhyZwk
	IuIp0gc1w9EjUNorIgIBuAS+iF6gg7rwzdHhMt8yHf315m9oBwb1ifVHPifa658sZl2NLxnd2fZ
	QOsI4m3uD5AbWLZQ7VT+NE8TyeoN8Qo2Zzl9NdYbO44ilACAwi462V4tnFSlahw==
X-Received: by 2002:a05:622a:4d98:b0:50e:614e:4428 with SMTP id d75a77b69052e-50e614e4711mr465044311cf.37.1777281357572;
        Mon, 27 Apr 2026 02:15:57 -0700 (PDT)
X-Received: by 2002:a05:622a:4d98:b0:50e:614e:4428 with SMTP id d75a77b69052e-50e614e4711mr465043841cf.37.1777281357133;
        Mon, 27 Apr 2026 02:15:57 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5062:ae86:23aa:702c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a6dbfd4b5sm40559365e9.28.2026.04.27.02.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:15:55 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 11:15:34 +0200
Subject: [PATCH v16 01/12] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-qcom-qce-cmd-descr-v16-1-945fd1cafbbc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBp7yk8aml8U/uuKzfLTF1QDzBZcTS5SzTnwUDLj
 Rf7fhGjq6eJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCae8pPAAKCRAFnS7L/zaE
 w1CTD/9M7yohPsNybzjJthNYlFsJYi4zy+/0cXFzB/USDDxoHI0Q/ANqR+s5n/RQEw0X6x/Dvai
 uDhEojPP3frikVdiOxTx/CLcA940MFKtpXK4vLVncbpz6fhpogA9CQ9rEThuN4kyKkRqvGS8wcC
 wvBnssSbYNel08atGXLfBpNzAehokknmj+RJ1AZnHXP78aF33Pu22gQHnnPTsxF/BAhi18TcIUn
 2N6/j99zOp3zfRUVdDV3F4TXrfOohhTJwN59zDwfZgTrkQ8SmlkkKxrlSYRQflQjRh2TvDzT1ry
 LqhNka0RCVw4tJ6EdYUcmFnzGjqudjIn0NeivlCgGDGocaBmuMSjN6/APtfEs9DZSHimh2eFnyw
 2FJMyLWttOf2k4VlY89PnpOQawzomgb4a7YiHJom2IOZvB4gBu9oNnkPbV0O4rsMR1qcUtNoOF5
 CL99W4qwNpkmPCdwrn/w9KSK93pUyr5TtnviPlpJnMlL5+FU1tO0CCyy7o3nQjSQ8zC2Xp6D+id
 Lxdugtmz+N0vCsbO0QEWZCzNjwrxTsaKYnuGXYTBZj38dzSI/hyc/p2UGTJLtyPbi8OBm/j1AWp
 KPlHX0ahhuPgAHLBvrxEbY2++CaC5bFkRZcoJC48MR+RwsOCZTG1C3hHU71aJLSXODhx70TXnR5
 TBQYsv0L5TdfvxA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 75ts88-vdjIAagv0V1ygVXkuYF8Dx9xv
X-Proofpoint-ORIG-GUID: 75ts88-vdjIAagv0V1ygVXkuYF8Dx9xv
X-Authority-Analysis: v=2.4 cv=Y+fIdBeN c=1 sm=1 tr=0 ts=69ef294e cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5OCBTYWx0ZWRfX5BuIHqobHhMR
 qyVizomCywg0cu6ukJGnLYZJtTZKjOinUb+/yxhUkO7SLA6gJTQi937BlglSksmIpgn4KjbTzLz
 lVcBLfOlB73CXs44QV5/XwtT7QpbOnx0f3KVXRS8paeFKwpW3ROCeDAI14sS/XXL7RJJ03dmkFC
 aVnSIZMKK39fkCRPyLEJEJjqUVsqA7hnWjcS/1cbOOox5JaTvELH3QV1dOQ7XDPOMha/4ckSyhZ
 ILAlQxxvdkKFyBe6c3T1xt1x4sAKjkF093pjK0t1aWNGinYOCr/YQ9P2FBMAG7DI0VDsBzchWXd
 oCURUyZG3OjkbzbnTUlE6ygAnZAz4VSUf3LpUUNv4uh2xpDPOdryg9W+V7hkMnRnNXCAav/RYjT
 2SAhrne5XKMvnI8/A+eEpIT4E6P87WiKXZedH41EMZdNQ9PZrcg3dOnP9bP6CrLRWIP3tu2I++I
 xoXsYT289s3ox+W+b+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604270098

There's no reason for the instances of this struct to be modifiable.
Constify the pointer in struct dma_async_tx_descriptor and all drivers
currently using it.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/ti/k3-udma.c        | 2 +-
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 include/linux/dmaengine.h       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index c964ebfcf3b68d86e4bbc9b62bad2212f0ce3ee9..8a2f235b669aaf084a6f7b3e6b23d06b04768608 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3408,7 +3408,7 @@ static int udma_set_metadata_len(struct dma_async_tx_descriptor *desc,
 	return 0;
 }
 
-static struct dma_descriptor_metadata_ops metadata_ops = {
+static const struct dma_descriptor_metadata_ops metadata_ops = {
 	.attach = udma_attach_metadata,
 	.get_ptr = udma_get_metadata_ptr,
 	.set_len = udma_set_metadata_len,
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 404235c1735384635597e88edc25c67c7d250647..165b11a7c776abc6a8d66d631e19da669644577d 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -653,7 +653,7 @@ static void *xilinx_dma_get_metadata_ptr(struct dma_async_tx_descriptor *tx,
 	return seg->hw.app;
 }
 
-static struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
+static const struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
 	.get_ptr = xilinx_dma_get_metadata_ptr,
 };
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b3d251c9734e95e1b75cf6763d4d2c3a1c6a9910..5244edb90e7e7510bf4460b6a74ee2a7f91c1ccc 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -623,7 +623,7 @@ struct dma_async_tx_descriptor {
 	void *callback_param;
 	struct dmaengine_unmap_data *unmap;
 	enum dma_desc_metadata_mode desc_metadata_mode;
-	struct dma_descriptor_metadata_ops *metadata_ops;
+	const struct dma_descriptor_metadata_ops *metadata_ops;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;

-- 
2.47.3

