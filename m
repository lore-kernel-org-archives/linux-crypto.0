Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC0D2FFFB6
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766138921; cv=none; b=pM5570ll7qNog5B29rZKQO8jB/YVJG/9fmlYt/f72Rj9+GG2rXrNw+A6RnrO8UeTtMlGp1UelHwCnfqMwcsQ0ZAJfY90cO9TDUyFVpsaAxdNn9WivVJcCqqf3hAKBYinE12l7cRjS+9wJ7Ad8QI2L3+HfD2heDBiq+CXuqEhRp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766138921; c=relaxed/simple;
	bh=H6RGZzI1m6Hy642I73fornlozWd6x9hkPKo2H6raYsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h162gZ+Au+lfqXypywvpPpoZYIczEOmGodr/ApFDm1zjWBGVNa5jtwtN3qx6NixoKBfTMpFm5vXB7YvkgmW2ZFLpyAoBGJoZackxv6drWDbqP9tM1SrwsjVjXkbII0dp9KOTfSew+4XQIO3scejam75Hx0vHXfhyAo3+Sea2Ics=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FblUbiks; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J87bdN7t; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FblUbiks";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J87bdN7t"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ4c1N34145372
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=; b=FblUbiksDdOT6ybC
	0eFMd8FZPiQC1MNzvNl0gINkd03cAer4YZ3VDYH6Qp/KIeOKp87DQRyRcMBHn8Se
	6xEsfWd38BtmAtbA/vR6kHzZw8eknmT8ycBjFZNTyk2zPTCAjrKMTFvSKQOyfyTz
	8GmGmJnIl5vxodjlvfpDszkHG9lCuntckx4hdwg4cbm62csSDDUqn7dH1psnJbGB
	plMnJzq/ngYmMsQi6UPw5kXjudYO9axYaldM+YUCsDZiNe5we/ok3VvX0806ysXZ
	xGGLy+4gligIZbBSYWG3rqrjzqmkbDRgZGRQVOTReT7s5tx/ZWSFplGtcjl7XQeA
	TQIzVQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b4r2dt941-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:37 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ed6855557aso55116251cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 02:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766138917; x=1766743717; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=J87bdN7t6xKkW4I8NyKQ9PIhP6mScQfjV+3kKr66HycsjhUOQIOri3pP655VUt2o5n
         Bflm42aVKAdNYUaWyc90oIurZX28QZJ3tRCe5EIJkwbH8gOO41VTEFsV8bN8wRQjezKl
         B3TyE2zlr2PBlnAWdZKD0nSdcGPpazSc93coe2xgTmSFP1Pvj8dXmyGKjIkRNmzlG0dF
         C+x064FedWORFoLRypSycY2fnlYXAIgoSgeew/6+9rTq1tgmU6E1wWwyCAsDVltyTmNR
         l29q0Gl1KMfYA0O68FMfeo59bnKYPJJMkT98Uobktq9Ggt3k21aOCUsNyzbjygJ7U3Ss
         iiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766138917; x=1766743717;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=aWgwvEGJnrDoBgeZdINjEhNlmVF1l1g0Kj+mPX+UOGOmC1X0j+Kklc5m/sgdzXM7kI
         Ha1XoLoDaSYAro2rQ17XCYheXq+QLc7bcGn3z8I/98aBNOj2dnwyfOHdikoHz9Ruf5yM
         DqvNWESnnQNJQRUk7M6wgAk7cWx8Vyj42+JzY7CabfE6X+3MmYWYuKuls55P7lXtH54I
         3FgxOq1LlrTAToQhf+p37XMyownSUqGd45YAaueN4fyvXiOITtbCoQwX4+BRC4owN607
         FArdj5wvYQHtLz0dMPUUmkanWQZaCpsofBqNYeYuMXyRHkXIiXQNIU3Lov1ralW1zPih
         LlIw==
X-Forwarded-Encrypted: i=1; AJvYcCU2qFYetmPlpv26fjUV7ouH5QYnWF/SO/cRSiQ0ovrc8OmycvELs1Dbp3eoZtwEl3Xu2jcr8BRSDLiA91g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc8jwn39VsczADGcvszaeASq3V7/OJqdwS9mGoyJY6IcSEGir4
	MQ++y4Bi8VKY+k8Wg5q8EZ+qiHVa1aFBV0ReGnig76ZfIjHpirXw/1MZKdDEy7odkn/s3nxgfRw
	D9fhSw9oMGEnDmg+WEmJQ/aw6T6l5YVMgeZ+Am9ePd3Z/ThIs2y9vqM/bxjlhZe6INm4=
X-Gm-Gg: AY/fxX44p2NCDF4DDGl7DRw13+VyNFk2GBS86x6IEDwymNDQptkf8lJObEv2f8NH86D
	2ZBJOTZpsMfhVRSTUcTqi0rO/uaUKS/p4LEnVYL6ePxMUYxk8dsx1fp9jJHz5eFcgnQ6/KJ7We5
	3Lr2c4A4+B7R3AV/qX4JIUOlEAVyyk43hIhlT+wb5inRuZKTh+ARfzb0byGMHuaQXI3dKzSfmLr
	n2GsVLA14ybRPPMmn/GpMM3gLIgpXaoedpjVVSdbKPg1M43ZMUK334NVLFyo+ldhnd4eiHr5B6O
	bQt9xywkcXqTVeXpLD2EGS8WSHQoNHXJ5vb9OE6qTbyP+mClBS/9T4o3/x4KGHwEEuIqb0Ewrcg
	HdB905BRNIxZ07Fs2kAw+/fXv2WAfD9r8pNJq/w==
X-Received: by 2002:ac8:5f8e:0:b0:4f1:bd60:eb7d with SMTP id d75a77b69052e-4f35f3a0f1dmr74754791cf.1.1766138916745;
        Fri, 19 Dec 2025 02:08:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3KPEegnMuKT75tg6XjQJTnbgPfXlp5ec6OVQCeKcX2ems3nTyFKNO6BdQDvZWNhuFnoUV5w==
X-Received: by 2002:ac8:5f8e:0:b0:4f1:bd60:eb7d with SMTP id d75a77b69052e-4f35f3a0f1dmr74754551cf.1.1766138916340;
        Fri, 19 Dec 2025 02:08:36 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:a48:678b:dad2:b2eb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82f6asm4209571f8f.27.2025.12.19.02.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:08:35 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 19 Dec 2025 11:07:46 +0100
Subject: [PATCH v10 07/12] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-qcom-qce-cmd-descr-v10-7-ff7e4bf7dad4@oss.qualcomm.com>
References: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
In-Reply-To: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2620;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=TfRVgyaOMZw2GJQ0rx6WhRl0huHGm4mvuAmz76BcVUM=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpRSQUTzmSGLFyrlG2gEZOV46m/aXCFMmi/dETO
 y9XVLzl7a2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaUUkFAAKCRAFnS7L/zaE
 wwubD/4pvTivO1ePmCtJUdSnGlI1Y295t5L5NP4cseSIqIWmOvUk6OR31ukM+4U6a2uyw33CL8N
 x46pBMvqf3dk99TNSzqsweJdYITYtYNiHv35f+/Yjo84hL61azE2qcrKuKPZTgMgzebKIGqC5FG
 LxOmE23qmKuJZZXfW5RDc7wNd9PWswydsAeH++Pyl9wPmuiwgLDKPaR0jJANiFSb/MoorrsPx/u
 MFxFlTCQPDkdq038laMZnoJjEWW5mFtwu3H8rNckqPAlrQqbkn3OLCZmFzIarv/hhV3M2Hh8Q17
 WYnfprGleqa2vbJp0WFdPp69hQSTE/LXo3lpqenRLxRgyuqAnmKps1L44kWepRpnXXaRZzr8Fsz
 L8jsdHcuJA+rSiU2KGfDZgPgNfHmbMUgPHuHqc2nPwj3bWgn4tx1m39uaTobEKD3mBrs+7HDKvt
 rtR223K+FYfkO7G+hCKKJlhGOUtG0WL0wtroFkK7lfiCQGwUhw3mUGkdkkX6UWlp4U4lkkm23KE
 wMC+uJoHqxNSSXCnVuPrMR2VpG+T9+PJZoL2cfN2D4Mg9jku3vnJ0coxe9h9747DrL8uvX9x+p7
 ho44htD8gWdrzYQYR8o67RyLFPKMvtWeHSM52kCeUFspOS9m9muUlwZ1T1+G3tWJBxo/GSvZ+aJ
 fHmpKPKfJq+71OA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: uGYVhg13q-unT5EUUy75I8VnPE3RjdtO
X-Authority-Analysis: v=2.4 cv=A7ph/qWG c=1 sm=1 tr=0 ts=69452425 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=KrkfD191a8oFwBap4LAA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: uGYVhg13q-unT5EUUy75I8VnPE3RjdtO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA4MyBTYWx0ZWRfX/fM20py2gpNn
 CJUbNfa1LLPdW2yxr/pyGk3olsZPXGMnm5F/LL5aM7xZs3O3OzIDszabbsdx3MLDhzYoDUVQQCe
 ovg6GKK823mzBOYUE8HkCTK2y0bd6NyMrCB9yHrd0WDeSIf6wX4Ph0gqvJFJY0SPwByHk42QF+6
 JHSyb0J+mEBcXeLsuvOm9HUd9eFYAiBjR75jx7BB0HbdK8yatUmjhjBu+wD48YNlX/71VEE5MR9
 Sg2juaPEnn+a1lr12QPKCtD3FIzh6w91wgvCIcH1hA08Xx2vPhTfaq6N33v238y7z8H7MizswTm
 4nODn+wbvqonn2iIvWnznt6LRqnJoq4iceN3BW3P1MkJsd74kJiYOJZO/FVofizemVbrJOlA2cH
 7+UgfwZRc/RHX3+EaxTcRFgIPCf09a6zZbqjBxXn6TynDzKvVESbS9SSREuRo5so8gHu44QvmW5
 LqqhEnGnQZxotDOs/Hg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512190083

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

This function can extract all the information it needs from struct
qce_device alone so simplify its arguments. This is done in preparation
for adding support for register I/O over DMA which will require
accessing even more fields from struct qce_device.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 2 +-
 drivers/crypto/qce/dma.c  | 5 ++++-
 drivers/crypto/qce/dma.h  | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 65205100c3df961ffaa4b7bc9e217e8d3e08ed57..8b7bcd0c420c45caf8b29e5455e0f384fd5c5616 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -226,7 +226,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = devm_qce_dma_request(qce->dev, &qce->dma);
+	ret = devm_qce_dma_request(qce);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 08bf3e8ec12433c1a8ee17003f3487e41b7329e4..c29b0abe9445381a019e0447d30acfd7319d5c1f 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -7,6 +7,7 @@
 #include <linux/dmaengine.h>
 #include <crypto/scatterwalk.h>
 
+#include "core.h"
 #include "dma.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
@@ -20,8 +21,10 @@ static void qce_dma_release(void *data)
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

