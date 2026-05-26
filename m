Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460403FE374
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801103; cv=none; b=t9ZE1FwhsnC4uRcP4E9HXFBgthSICFyiTQDpzn0M8tQjyLBmxBdh7JNMD6BCa5ppPBWdaLxSlGmZIPMceLLkFTvgQwu3eiit+gmKsezTmkkbV4eHVPm0h7JjYdpyZoyP6/vMwMcMovX8z9nf75gNyyUBTMeXrR9OooFqc8GcGts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801103; c=relaxed/simple;
	bh=3yBeQNw3jzjlpjDFEUCe3Cu5wMqOMdw6j0aFa7VZxZs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SBqz2dnBkP9a+SdRqQrrf473km/hpod8E4yNMPC0pPMRwx7CfsS/Pmq1HAtIeIALBXnhFv2cvAyvNDsi05W1R49QFek55SD/elIKsFq8dNnRwpTI6MOKJLZAVsrehN5UlHSfcR9nsVALWGa0CxFbedrf31Bmc8ri+Zfp9tTFdQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KqYUa6mT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iKJpsf38; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KqYUa6mT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iKJpsf38"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsiIw3797189
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HYRuBcDmeSrwysgBk6y3pl9+6SWSAyowGbE1RPyJdFA=; b=KqYUa6mTTSgPnUTR
	20g51nTNeQXj4UzVjRjy7WRvAqxGgl82Mp2i5WEY/SFtnnSeH3pPgHb3n1dQskGx
	qrZS6M2elC/tRdtVD4Pgg8aV1tFNg6AOoqsKFJNbIPcoC/h8GoSN4LXyvavWEtWn
	c4sKAK2VMfVQkxbsy1bWI+/GDVD9ETQkHte1i6AU6PQ5Sv5JLIoRcRXTpnsmKeKu
	iunrnarMQa2Aml8Ruvcbew1jFsD4B+A2H9u++UBTPFQtMsHKUdTjOvAi3MLzEasx
	kADyzFbdABQjlfrn0S7usz+gPdW8n2zH7sVwS/HWtJmCqvo1gfYguYNe49QjrF9L
	vybwtg==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecpy2mga4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:40 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-6312aa1d7adso6729263137.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801099; x=1780405899; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HYRuBcDmeSrwysgBk6y3pl9+6SWSAyowGbE1RPyJdFA=;
        b=iKJpsf38wP7RjzF1udMa2dYY8Twm0XAzsTQjiT+MMiYEPOMrQZMgQsPou8tGcHsko0
         VYhHnZPNo9UN2uZB5Eug/FIZk61IO5BYn+cNUMkM0Qk3M6a9F60wqKtxj8T1JdG/FjNd
         7Us8HG4z5Nz3d3WnzF12BbcxM8HPXHSlryCay5pYOnkDZpBTKJtxtj4n0N8aZrhfeMwQ
         OXDruArB+rDatV5kfe/LwsIgdi3UyA9KpX5O2x3jMsMzfT1GS0Eoi2G+d4Mc9qIT9ayR
         PSYNDJUo75RNIE5F7JYNdKsUMJNqEXnLitTqi2z/TpyMvnx2pedvYjnc+tJHFRs275D4
         NnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801099; x=1780405899;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HYRuBcDmeSrwysgBk6y3pl9+6SWSAyowGbE1RPyJdFA=;
        b=DAGBmvf+X784cjJe10Jvi5jhJmkPHMIhVDCF7tTOTpidFToYjw+6KxH8/3dab6T6Cm
         vxltmz4R4HWt8TCr9xj9g5pNhoz6eSYUQlXlrSTPCg9+IlyQP6Ak7peG+3x9trgmo/jm
         zl5N5OJ8wnXY1go5ct7BHEi7nuKuM4ocStK/0rzQwYcmNkpaSJhEyK9lnhgmUzjMVfMh
         7KXaYs1z1QkB5NYwqDSuCOgRQcYEgoA2XIDtFKGB0gFzU0YQiSZT2zIpINqVxn3UcPDb
         HA2SRkhKT6esUJ29lgOM2mF2oNfvWQlPkTiXZwCuF+u9NUaZEd7/gEQ46napesmX6+Eu
         8+pA==
X-Forwarded-Encrypted: i=1; AFNElJ+qn+rW7w+iVmT1Ol/x+R5QuBMXQppuXV76KVjeWP371Kkr8oe2N8w4FykuzLDbqsd6o5S/S/yT+5mMINM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpa5MQW3j+heCluHKB1qQHGkLIZBSlQdqJrteZJ9YqT7PUVZx7
	W2Lre7ta8ShoT+DkMkdw5gR+Zb0Tq0fj6h6K5USzUGIbE5Jbm3yQGd2oBTpqhySbwiawxEzYEF/
	0eaol0atVrQddIc9nvmv2OIcNm0cHxEqnURuANBpOOYW/MLoxIACB+YTkXfBgq9klyUc=
X-Gm-Gg: Acq92OEGl6CYAqBX9eGC5fHMLCWuJDrp5vJJdGt4ql7TdzfBl1f6o5AY29vGZ96PSII
	6BS4in47+r34hLV/m8nBbSOFa/FKNFxhj4i5wpum6M0vZAKN+ic78cFeOQdzg1PwfhT3YnsBNc6
	ilzpyWx2id1koTK4KbrKBAdFOP3QYQwMClpa0MzZ5ZARJ/ZcNmq45+s7xuTCitUSlcwJe3sxsiM
	aFYUMs5OAxd20l1BTlouwr91Q6OgCi5PwOATP2CWy03e7NGBC7Cxl4vFDerjJbr6E6Rs9DC05g4
	640xaLM7s3g9+1OIYcdTPWUfwURvMhEpPmMX92h80IURZgK6gR83PHuIenYnPyWtrI+D8LcyFJ8
	0wXxbsU4ASf3xpR4fvClCeb4ZYK9nCPX1/PW7PF+7xE7NjkI3NI8=
X-Received: by 2002:a05:6102:4b1c:b0:650:aa33:5dd7 with SMTP id ada2fe7eead31-67c6f273741mr9659063137.2.1779801099538;
        Tue, 26 May 2026 06:11:39 -0700 (PDT)
X-Received: by 2002:a05:6102:4b1c:b0:650:aa33:5dd7 with SMTP id ada2fe7eead31-67c6f273741mr9658983137.2.1779801099018;
        Tue, 26 May 2026 06:11:39 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:38 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:10:58 +0200
Subject: [PATCH v19 10/14] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-10-08472fdcbf4a@oss.qualcomm.com>
References: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
In-Reply-To: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2674;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=fDLeS2ZDhx+ScijOniaw6DzPwcx1IpnjO8zSFEJey9c=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvxilieZXxkagFS4yLDPqAHVk/2laQMRGU/g
 N/8pGfoF2aJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb8QAKCRAFnS7L/zaE
 w1e9D/4yXaFoTfncd6ZGr2f5H5IwaviF/8Xp0SUigtSjDqiB7yFSXFG7EZUn8o5s28BYClwxudc
 te4aq3DoYC2qQE9nczH6XmpHsf3xwIHrF3ybG0+SL1QU3yvnhvSVsGSyvdBjcxCIxclKddqYiuY
 Jqczy2O3H5so62llaWaPo9CGbLWkNJE8xEdvxsZZt2x8zfIrATUsGkI4ZNI0QbI39IxsRX8ysz+
 AyHWXgQbuc6MS5GPNs3P5E18euzP/9FAVlNpu8+BSgSk7AweGjmHaaWxCgYTaDSnF1Kz545bN1c
 vQqCKdN8oqVOsj8Wk4J/6TNsVZ+csDl+L4hq3zvTIRg2PZAT0hV/Cqte3NaipZ51wgnOwAsW1UG
 IQgNkQwmeXEr4hSm792Q6q4oh5I+yYY1xHT4dueYAiyK0sZnrc0nbI/ToduD2nY+YCo5LaCgxs3
 ohaWaUgxU1MZ2soGSdmDbWuA+bjHkO3FvduEDawZ/1/umnZ4JCsBkewabiSswk7WHysQ6tA4xv4
 Vkk5yHwBZIeF2Ai0pQX9vJVQ0Ns0PmTNe8fjCfBufT+uOZZ1+Vo4SYUDgAOEDXi5MjY3+Q2lun/
 XRUE31Ob1aG7VwQ9HygD9lGsO4y0erkc+HtLBUbm27WdSAsf+rSIsOAt/WBPksEk2rIELnlnUCt
 3VGTavLE3wbVyPg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 1D0WVu6-JL981U3c8vWhrnx8wSs1P8Lf
X-Authority-Analysis: v=2.4 cv=ML5QXsZl c=1 sm=1 tr=0 ts=6a159c0c cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lH6k5GM5CfRwGFUYfCYA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 1D0WVu6-JL981U3c8vWhrnx8wSs1P8Lf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfX0WxSLzSl2rGz
 QtJkOalNWEGHlcxBZyr+unuyy4t8HU8QIOG5VvetAG4B1dDljl+TKv0wQB0E7cAguJgP4YneLSM
 tCVe09gXMwRiupC40HN36mi4zIhTsduhTPzL7cHimKJLg7+s5lGOYJ+7+fu/knx+L9Eq17+KY+b
 yt6gAf6bADIYfUNsfzYX6g7Jbuqz714+8bL5njmtevXspzhCRVklhfaGx+5VFVvVdtrUtayYJY5
 G/kkjaSqGwkmxLL0R3bx4OYv4YYUBGiIxNS5b3XjmYQNNz2eSo/679AbSd/vpJ02wAv+I8CDvZK
 Cf2l3YNqmxsfMWVYcoOq9bLj6JBtGHMBaByReXAVONtJWAG21HoFPwzGc9c5wQan2r3CGE1yzxO
 Jpx08IrrwLHF5I1BmrqH5ReDZWurznxOc5vvriLGmDtuEfND+6FTMc0r/p8q1nBtVu8S3MmW9Ok
 bEtmbZzDWNy5SzMTM/g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605260114

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

This function can extract all the information it needs from struct
qce_device alone so simplify its arguments. This is done in preparation
for adding support for register I/O over DMA which will require
accessing even more fields from struct qce_device.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 2 +-
 drivers/crypto/qce/dma.c  | 5 ++++-
 drivers/crypto/qce/dma.h  | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index ad37c2b8ae53a373bb248aff06c3b7946e8439a8..a0e2eadc3afd5f83e46724c8bc3e3690146b86ba 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -238,7 +238,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = devm_qce_dma_request(qce->dev, &qce->dma);
+	ret = devm_qce_dma_request(qce);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index d1daa229361aa74da5d3d7bfe1bc8ab189761e38..d60efb5c26d88f8b0259b1dccc8724d0f75571c6 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -7,6 +7,7 @@
 #include <linux/dmaengine.h>
 #include <crypto/scatterwalk.h>
 
+#include "core.h"
 #include "dma.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
@@ -22,8 +23,10 @@ static void qce_dma_release(void *data)
 	kfree(dma->result_buf);
 }
 
-int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
+int devm_qce_dma_request(struct qce_device *qce)
 {
+	struct qce_dma_data *dma = &qce->dma;
+	struct device *dev = qce->dev;
 	int ret;
 
 	dma->txchan = dma_request_chan(dev, "tx");
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index fc337c435cd14917bdfb99febcf9119275afdeba..483789d9fa98e79d1283de8297bf2fc2a773f3a7 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -8,6 +8,8 @@
 
 #include <linux/dmaengine.h>
 
+struct qce_device;
+
 /* maximum data transfer block size between BAM and CE */
 #define QCE_BAM_BURST_SIZE		64
 
@@ -32,7 +34,7 @@ struct qce_dma_data {
 	struct qce_result_dump *result_buf;
 };
 
-int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma);
+int devm_qce_dma_request(struct qce_device *qce);
 int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
 		     int in_ents, struct scatterlist *sg_out, int out_ents,
 		     dma_async_tx_callback cb, void *cb_param);

-- 
2.47.3

