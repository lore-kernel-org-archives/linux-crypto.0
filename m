Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6483B2FED
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281381; cv=none; b=TZtxbEolLy7BWEZ48I+L3C/uvnYbO5oca3iI5wfOpbc6MOV6csXUMZoHklDrfkVVIsmeL9fPELhwYYhp+GswDTF5tbSLkFCxrXGrbUOKTh92KE33+J2t1Rhln8XtoQ0bjKSx3msy/1jpJkfOCCzqI3Y5h3HDtGhaABE63ex8S/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281381; c=relaxed/simple;
	bh=0l3gdVnkPeEhRWmaFMSjmRRcTqey535uYCWAXzuHtwc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CT/+BQpN5zEXAyBNxrsei3Ikm7SI1GlC/JSz39ZJMN4xEIZQmhaW2+7EBn0nYf27rzd8hRt093kAbwPwHFAr4oOMWVvsVXZ67mK4UDAB/xZ3TREbF6oDtigiQhbRaz0ZqkhqcfP8XJOUVxfmuswTE4+faACeMBO3Uz72XI4H910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gtJe9AdT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BFnjTGYb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gtJe9AdT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BFnjTGYb"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R8TOnh2879948
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bP+u/9sMDsi5B9HZu73nJnAW0uvD7B1160U6L0iNO8E=; b=gtJe9AdT9HkSr3Js
	x38JeDnFSfFGOdRNOe9+KEzBWFWrmSCTwmi8hAmj/tDuBmlPa8+s+Uag8VjhObGC
	gZhKmcTh+K7bWHbYKAQciZS0kiwnqrVK2uCWF99tCQ/5KLLSPz2MU4kEyCMzekTV
	poy5FOVYLjPaKcLjJibfjF5MgB1Nt91FwrMa1WUeJOIQGcIVm+2nRB8Amo854ERp
	exzBk1gxO7lMyb2AwWrXao/IQx39OFt2gCyYGWSCd2UTSHEAwcYTExvVJZ34qp6C
	rtWWVfBUpY3KcN1n5bG4H3xAl9A9fBw/KlnQF4lYTfz9wksveS/IYMjXelxJkbPL
	vnP+6g==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drnu2wdhg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:18 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50fba8d8c40so101300771cf.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777281378; x=1777886178; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bP+u/9sMDsi5B9HZu73nJnAW0uvD7B1160U6L0iNO8E=;
        b=BFnjTGYbcZ2dxQ6AYvFPgB+QwucO1LPM8FtNdISCofiyV0GIECiasWxpoa3nfZTK/m
         ZgWOFCXHjSbrkNCh2PRmUQ0LuKJb5z/+khIhEpvDihtDJ31PgtyieGf3fvE5H1o4awk0
         1avcJNxvnXbO7QdEX/QDiI/vn6SeW25Ij4bYO7NcuAfJFtFWPqBFmmhg13cMguVtIgab
         qkpSzllZMPrk0k5eK11/c7apYSwo8WUrGNIJ3RJV3JWJQvUQ6u5AybacQsBhl+/3WxUA
         gjeoFkzSrcVJdkPyTn68A5y/LQPb3viVsh69EdEbYJLAtw14kQUM2xN5CWr0nBWenM+X
         Ehaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777281378; x=1777886178;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bP+u/9sMDsi5B9HZu73nJnAW0uvD7B1160U6L0iNO8E=;
        b=D2bEm+O5Q5L00F/P8acSFSkhalYlqQ+0K3CPMYWgyGmsb0BTQyL4XukTGP8RxZQFal
         tySraUqEC66cfePgx25Muu/ORBAgfhjU9h5zoX4Y9fSelmWyayE/1QKdlB0hyAFj9xSO
         tpNTSbmzApCfySbOUhWDAO9v3eeeG9mPWY4+iuybW8yizuGvvhZHB17nhPCi5VReh5pG
         K5TcHHP6fqZoDuR185ITAyf4UdaQnvsMwT8SGXw8P5uuSnQGCGF1UUl86U12OkSHIFGP
         Voe6suCBiAjAzYSnPDKWPmf4KVp3SZ/+egUFIrJ7slzwT2P7vLo/Y6aP5TOzmmlvOtHg
         MSAQ==
X-Forwarded-Encrypted: i=1; AFNElJ8pQsT8wrc/LlUQtZZVD/JouEls2ePX093TStDR4dQbeQE4Zk1CIzrEYMUVNLkIOpr1F5XCUOKh0ij/ALE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyjpY+qrL2MZ0AWvlkP6IAQQ9gBqWXjwwdvjbqUmoh0OlnUn7t
	dP+ZQQdemLIQTqmVSJ/5kOAwd6ctOVCM5cyft0peV6OMwi1DSfe3NGJkS94cgFiZrVuyn7wD2Kk
	D+L1h9gDnUmCCGqMiYHYH9mT5UUM3QDBzEIVwjrqRXgXtNppAOunnZBcsiT0XnpoFVos=
X-Gm-Gg: AeBDiesCJPm5NumIcwFTh4vFHFY8kGbcsw/8pKk9A3Mrvlsg1HHCL5wkQiKKos5uq1g
	agjSy4GjfffRfmswQYA9/od08isLqcC4oP7CPgTHrRtMtMZch8X4CVLYJ78Ekpid90fmzDx5faL
	bHR7RXe1WJhSn10OKZjMLrS327PXMR1wnlW390Sd+J5VY6ykj12ZVtg9iu9/BGgg3o3mMXiDYrb
	mBB0QkMrYDjICtEy1zZ42PnQACp2+WW2DucuV27tQp2njdSStGJ2HCqAm1tDQfDqh3lQMFAm2Vs
	ylCIVvT6xiE8uGCMhPoToOujmBs9FqUPEXbN5I6KlgdmWYzJf41a3NNwv2ZD2GdLPRPP16x4Z1+
	o10yVu5n0Xb7tImyeD70NlFoyiKysXMCCmAHpNN0tK4A8uQMgpmI8v2cl2IZB/w==
X-Received: by 2002:a05:622a:1884:b0:50d:a644:69b1 with SMTP id d75a77b69052e-50e36ba3f1fmr568019251cf.25.1777281377955;
        Mon, 27 Apr 2026 02:16:17 -0700 (PDT)
X-Received: by 2002:a05:622a:1884:b0:50d:a644:69b1 with SMTP id d75a77b69052e-50e36ba3f1fmr568019031cf.25.1777281377465;
        Mon, 27 Apr 2026 02:16:17 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5062:ae86:23aa:702c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a6dbfd4b5sm40559365e9.28.2026.04.27.02.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:16:16 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 11:15:42 +0200
Subject: [PATCH v16 09/12] crypto: qce - Use existing devres APIs in
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-qcom-qce-cmd-descr-v16-9-945fd1cafbbc@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2266;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=azGHQ+ypZ4Lhe2NPlFIx77n1JCkKbs9Xx9/yXH7ccEw=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBp7ylFm7c2nvUtUcJ1z2g6SDoZs/iXQQpQZYP/8
 O+2w8pXe2SJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCae8pRQAKCRAFnS7L/zaE
 w0/VD/9baMWDsWkK4NNPbwXnJZguEM2WlDqh5cmEYnMjDW61exw0L221i9YQuxz1FKvSUWB0EXK
 wQZwEczyHis1Ia2k06kvA/lZuUEchbz3qTWQ/lAtk47GtvcvBYl2kFP0ID20FCiSWdNcCGBi2J/
 ilU57jELOOXlzvvmdRZMs3z80vOhTiAyEm7K2zOfbQYopsSb6rd5CGEH7yC4Qy9/7Oga9Mx3cg6
 DAnmBG7pvPKXqq6pJ9OLDJesW3VGWU1r6AGomCIwb6vuT7GRc9fqrkgNDKlfFYh/bBwe5fQI+Ed
 MWV7YAliHyiSA8Sw3O4BTJcUEJBFaBHMTUKyIWy5IZAhXx78RIXWb8r/gf0y2ftoNZqQrjaedEh
 RQayfnx57jEmVr8wBWzN6EEEsBlvvicQ4bmWTb+bX/7KTDrkZ8vB7egEW2Ld/gBB1TGmyFiVezD
 t+CQJf4GyIZmKytis6NvzgKF8R2391RbGCzvQ9RAjdFEUYgMwn5myMfiGAHv1n/uyCk1g4zY9P2
 pv2Wl3qrMSXCX+SKgAqQL1GR+fsP/+xuAIpHw0xb8oaLosSzVaa62s/dP3VHXIQnq6PO33f2qkT
 hXstzncGxDS4N9RodeFwFH8ytChyAtYXC3SKDjjHhQB6D/F20SA2U1cId6UPc1FOPzLhFETzdQN
 ivbkjKgwa0BeqSA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: kfHCpT5GmUuZklYvBMH4Cs0l_A3i4tqE
X-Authority-Analysis: v=2.4 cv=cbriaHDM c=1 sm=1 tr=0 ts=69ef2962 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=r78XHnC5kAO70zNBxnsA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: kfHCpT5GmUuZklYvBMH4Cs0l_A3i4tqE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5OCBTYWx0ZWRfX4XJtJQsSweSF
 kgyYsXpojPAmhP6gyXlJ4t0GTcle9LUV4HTEbMczzWw674VbXfyP6L8zZ9hQDpM4JbbcN7QRzwS
 NNhdJoxrsNPDn0wK6LDqkDvsQGPm2YDJjVL8bDgzmyXspA7Mta6mPuYODIa8YKpkv79+I/eEcQ5
 8WSop9zR2GLTOVQ4riQw12jhA4RAbVOLq9bbrAal+oRpjnmFgRyYPd53rVS9CmI1F7dEWw0/5kx
 zwybbeOMvUNk4Ybzzk2onFbsUGzAwr3q54hRt5zymcw5saqZRhAqZXpBaroP0JsjBX5O8EG17aN
 r6jzKZxwVcLo/R38c0t63eh4tf6PBFL6Z5p8GFT46zjXPt7WiCFpIE/8F7eYcp4OPdAEhvs64jl
 aUoRqvBAjhdov90RF7e/l1zWX16qm57SftI3dsYWQZQnpCCw4rzw59nbezT1vO+IrczoXwSdixG
 7+J6Wr6aBAC1S4nsTBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270098

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Switch to devm_kmalloc() and devm_dma_alloc_chan() in
devm_qce_dma_request(). This allows us to drop two labels and shrink the
function.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index c29b0abe9445381a019e0447d30acfd7319d5c1f..a46264735bb895b6199969e83391383ccbbacc5f 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -12,47 +12,26 @@
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
 
-static void qce_dma_release(void *data)
-{
-	struct qce_dma_data *dma = data;
-
-	dma_release_channel(dma->txchan);
-	dma_release_channel(dma->rxchan);
-	kfree(dma->result_buf);
-}
-
 int devm_qce_dma_request(struct qce_device *qce)
 {
 	struct qce_dma_data *dma = &qce->dma;
 	struct device *dev = qce->dev;
-	int ret;
 
-	dma->txchan = dma_request_chan(dev, "tx");
+	dma->txchan = devm_dma_request_chan(dev, "tx");
 	if (IS_ERR(dma->txchan))
 		return dev_err_probe(dev, PTR_ERR(dma->txchan),
 				     "Failed to get TX DMA channel\n");
 
-	dma->rxchan = dma_request_chan(dev, "rx");
-	if (IS_ERR(dma->rxchan)) {
-		ret = dev_err_probe(dev, PTR_ERR(dma->rxchan),
-				    "Failed to get RX DMA channel\n");
-		goto error_rx;
-	}
-
-	dma->result_buf = kmalloc(QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ,
-				  GFP_KERNEL);
-	if (!dma->result_buf) {
-		ret = -ENOMEM;
-		goto error_nomem;
-	}
+	dma->rxchan = devm_dma_request_chan(dev, "rx");
+	if (IS_ERR(dma->rxchan))
+		return dev_err_probe(dev, PTR_ERR(dma->rxchan),
+				     "Failed to get RX DMA channel\n");
 
-	return devm_add_action_or_reset(dev, qce_dma_release, dma);
+	dma->result_buf = devm_kmalloc(dev, QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ, GFP_KERNEL);
+	if (!dma->result_buf)
+		return -ENOMEM;
 
-error_nomem:
-	dma_release_channel(dma->rxchan);
-error_rx:
-	dma_release_channel(dma->txchan);
-	return ret;
+	return 0;
 }
 
 struct scatterlist *

-- 
2.47.3

