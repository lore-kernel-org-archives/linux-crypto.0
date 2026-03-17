Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624EB3E277E
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756184; cv=none; b=Dm7rMykJ6QUi0rvDUb4p2mwB04rsuKOR1GRwb+gcQaSajEwjLmYY0w5PEnqRH1vKMpa4Y0hsDLDjArHw2rY/eHTq+Bcf/Pe5oj3E957ZWXrFXtvSuBb+6fCfPyh5oRlUkHLIJnF0PN2JEFzwEnvEG7G2/a1yzxBOitUpvfCdAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756184; c=relaxed/simple;
	bh=0l3gdVnkPeEhRWmaFMSjmRRcTqey535uYCWAXzuHtwc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hoHIoUTxmJsJYBDI/Z2HTRqozDL0m44DoRzPtiQQce/KDcvBynXnUimkpx4gEyYgwOdXNDGS5GQz9rOgVQKm9enoEIqutI9VjEmsINkoAR/vzJJl6+kCSKGr3nAIUAzloJ7HUBwBLnD5tlyZ7/7/ByR9bv7aikYk/nUPwBnX+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EGz+aa29; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GJqeR2i1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EGz+aa29";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GJqeR2i1"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H83K833295281
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:03:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bP+u/9sMDsi5B9HZu73nJnAW0uvD7B1160U6L0iNO8E=; b=EGz+aa29zlBil2m5
	eJtCvruY8xpVmLJNEFbZoZ/wVHvSvjr3+pp9x+bQH/t2w4oeExip9jIqnAiVnHvr
	60QaLxx0nObYr8jXe5dQXvOG/3tl7tSwvSor2oQQqVPbgmnfleRfC/Gbz1VdfCK5
	j0zZ5D9Gix7tB1WkVSLXE01bDMi/cr5JX1Zyu+qv1/Dru+Df/0lLQOvuBkoHk4do
	/azoLuQKlJ0l9ALhq20AQsIcnKLDSgFQdMQxApW73N1vo5zsMDKfrWn4xpWWx/9f
	H6PJ0xCiNRheRw/BM6bUeiVOjw4/V3MQraaC7VU+aTWXlgMHstOnNiWBCacWPvC3
	4JOhcQ==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxkuy4a1p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:03:01 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5ffa63f874aso6164002137.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756181; x=1774360981; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bP+u/9sMDsi5B9HZu73nJnAW0uvD7B1160U6L0iNO8E=;
        b=GJqeR2i12SHL6cf+QLmHf7/8dEkxqHIkvMnu7f5ILBjUQMiH6wNBryocv7HXJWl5wS
         6ZfgDfKUfOEwalwNSWDXcZXwhr7+flB6nHpU8/DDcI2Pwtm+cCgXrmt/Xc5EAs0CXAC1
         ZVcvd4bj6/Z+RQBbJWfBUc30V+eSZ1N7pIQAV1ZTrwrPTUJDkEtOz0jCff8m3Y3NRETR
         A0ChY6MwJ6kJHlXs7yIAwB18swWmUGRt21h7N8Jg059jCPgHuvL+WXvCRhbC1fH+0a5W
         8JdlfhfHgWceXeBPDGHWOtN2VryfVeT+bqh2dlDo4qagspYRECLI7AXR8U2AJo0YbIhy
         wLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756181; x=1774360981;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bP+u/9sMDsi5B9HZu73nJnAW0uvD7B1160U6L0iNO8E=;
        b=g4u/3Je5+pHdju7GwwbN31ZWYQS3euIeNwJSxmJBEoXIm9AV5KGrDlIbvpAcnHU3MX
         vdS6vxxvs6GN875PgGsFhIDr4NFVfSTC9G7KD9DcKPEu336Qx5LW/MQva68nIFdqnXma
         Us1AVOLZspifhzBIRrw8aG9u6qy/GioM717IbJzRK+kLimqIau+FBTSRVfinv8uQNcHO
         2JoITVLhdKHVX4qz2j2xWH0VQG2S6Kg+Agxy5OXpy40Fe36a1JOOlVP2HYC++65yUU0A
         b4giWiJnleXcO5QBo1zSX+OVrEtXKXeXOY+KPVlBlOYnUpTbqQ7LXc1deWkrXwAZ/BZW
         4z1w==
X-Forwarded-Encrypted: i=1; AJvYcCVk92wPGW3zEtGDTdfYFmbGKrVgssD8w947qNa01gJ7aFDs5pOGNaaaA9AaxQnDf0do0uHdU4RZw3b1+Mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjBjs8Vj8F6KyTbfvnoahCFcXDbYOPNE7VeSu8PzehlhB7Yopg
	QK2uDaC0kAv0aaLgIV9XJwOPuVkhNkB9Pl5VZ5payQk2PsbtM6pr3kWTHvxNmFaa0nzodSqMo3C
	cGF/36EyHf9iO66JcIWyb6rhl1sMskrbrnN/bbQAsXSzhmm0KSrXI34xLglppKrvbX+A=
X-Gm-Gg: ATEYQzxxrFb324cdUONibtQF+sARgr6agYUsVMhH5QOkn2jo2vuEukoAbG9mC0W5t3W
	ONS740AYJ0t95BAeZGuYVRoew3BSbhdrRzQqDiwFaPPatIKbiXgIJIcFWST9foaK9DAnbB8W6q5
	H9AUXIVDQc9s5Uh7IamQzp1ATZy7uJ7TUk3GT+3YhT6ezDbZvFNYjibs1ierz0wr/lm/eM3IEZL
	yFp9Rn65a2zIV9sh+sANaybnQ4D36ZrBSiY7W6V6L48Fm1Wb3D8WdaZq2BvGqyGeHZX06Efmtzr
	hIk9AjYE9idaXWzgY106vIWNf/jutdswgMXfUsLdbmP5BwO7cAH2+FUccjzr0q81/SV4vpi4trl
	3UmOFCoiwrRSeGJnKiKnDnh0ARlj76BGeOKea1wJgtyyet3MlRy4x
X-Received: by 2002:a05:6102:3e94:b0:5ff:befc:6769 with SMTP id ada2fe7eead31-6020e501571mr7431236137.19.1773756180525;
        Tue, 17 Mar 2026 07:03:00 -0700 (PDT)
X-Received: by 2002:a05:6102:3e94:b0:5ff:befc:6769 with SMTP id ada2fe7eead31-6020e501571mr7431185137.19.1773756180060;
        Tue, 17 Mar 2026 07:03:00 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:59 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:16 +0100
Subject: [PATCH v13 09/12] crypto: qce - Use existing devres APIs in
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-9-0968eb4f8c40@oss.qualcomm.com>
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2266;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=azGHQ+ypZ4Lhe2NPlFIx77n1JCkKbs9Xx9/yXH7ccEw=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV75a/3hqKscMttJVdIpHU0Ak2Rn1jbf9LnQu
 W95CnUaur2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable+QAKCRAFnS7L/zaE
 w2XtEACBewY081381qeqX5U47HXcuZKex2c6satG7MyFWMealTHUY3EW1swTfruzBAe4lrO4rP6
 93JvwRd454mu76difO54tSmpYX2kWMT3A1cKuy47ag+D52tLLRdf2FrLwjIVMnEPEMEnGppBJlV
 nqEB3a0Omz2xwXEeKi9RWFskSG0stfmIMvWg1Khgb7X0mi2WkEh8DU7r06mbS7TVH18Y5EqL5Ur
 PhYFzqd8VNdNmV41K1PBY/G3xlJiLgsq5VEC2k8qwqz7hLmLGCHgKtfl8DpLlq18G/rxSOCy0Zq
 efFms1UhJo3WBqpoXBkFuJZxpNrjL4LbSksIOrU2YTzur+p3zQgICAeUDYxkm4UKSsufe8ADPsN
 y8XW3LA1P6K4YHqGwbq2+E4QRP77TA67KSobE8MSUlnEILPcJEvxG9eT3J0sGOEzdYcuYdN9/MN
 bHlW1Z9LStS4t/bmPnRYJH8uCAZOjlU+cjCK/+XTW2P43ASegV8CqbK/kc1ja3oybX476cW+dRp
 lHm+VSbjFfRNaxzWVeFmxna/bJj+TgYOr8dmjYmU2HleCupjq8O/odr2awqucVTxpHqaRUcJdHD
 6gP9jYe1UetONfiII8OQyZhJicACUml61IKwd/gOUz8R3L0JNtv2miSDbAjfr0MfSyTTz9Nf5de
 7lCvFlvWj6eC93w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=br1BxUai c=1 sm=1 tr=0 ts=69b95f15 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=r78XHnC5kAO70zNBxnsA:9 a=QEXdDO2ut3YA:10
 a=ODZdjJIeia2B_SHc_B0f:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfX/lcf6kFXRPcY
 4va3yEvvMnA6k33djdHMPtNdvNQ2+bUwegIfG/JhQTe0Q+ZXk3edfu35qTEQm/NNOOzeVkD0OQf
 aL5ORMVKVQ6a6T6ZtS59OKMZU0uaMSa7jHSlYIPpgQ3OeEx29Q1XgpAUMc4yv5Q/RQKcLgFTa/u
 ozFkcyRyjfuBU61XQyRtqRs3WJOcul2T+2tNBFRigbe2Y0X7hJBwgoXouWT9PsCiP5bK/G0Z88v
 CDMhRG74+NQqkRPkWhBqhB6XLvajZF+cWJGEZTNrBkH149qRHVxKGcBRm4FgqJHKcXIMXMBM6ze
 hjkJtUoLFIHAdZ95ZsO/bAo6AA+3/T7gJJWdyytopo+KCxboW9HzEon3QJtHY17Gmu2L25tNXGj
 hxMFScaPk/l7+y7OWoddQ5zoOfiqHmnJiMG+DyGw9EBZz6oP1jFmA4viQMlOSKPLE+NhfsXAf1V
 VgxZReihpsU7E3u9ZoQ==
X-Proofpoint-ORIG-GUID: SkWOLqkkqMcWInjMtpeSVoEqrUUdrEh-
X-Proofpoint-GUID: SkWOLqkkqMcWInjMtpeSVoEqrUUdrEh-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170124

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

