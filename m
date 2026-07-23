Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC604EA394
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826634; cv=none; b=C5brtiusUNN1+RFiL+HPqwWo0w7k233KC/NsDxFqEqKMZNwx2+0y5JMeXHfsFtg4rOSJX+Ul2Mma3wPMQLUCe1HsrmILp+r8dUArNej1STtZQK51iRWpDMQZus+u3FAJvYWKHzRRKAU8WUOEfnVFcPic7kR92NhLTdzkFC7I0Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826634; c=relaxed/simple;
	bh=/3Q5BLE2qswUURgRMp8Md6+CmS+GMHS0PuiKEz36BBw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ml8RKK1t7yiwAiWvgmIyP5PxbSrmWxtpF9I2lGYuodohZpKVHl4lWFyrt5jNZo7HypM/T1mKdjLcOmpSSyjzMInTOnyGiy86dzEh7jilEoTpL1sVTrdeLn9o78OhBMrNufQ/966/7pgN6/fJfML9UWomtb7HpNWh7qWAmSRVOBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W1SU1wG1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hJlQcRe8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W1SU1wG1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hJlQcRe8"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NCvZgv3954511
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=; b=W1SU1wG1cOiAxKSD
	Gdcxxsx6tVxyntq52L3+AiSd4xlX1k+IUpucp/6Dc3aJJE/W5aTNvUDNKAZKaBdz
	jhpTvpRKi+x3Fn1VocP6NssLgV20ZuxZZL3xqh6scI6+btGUFddBHRJXsgbtJHWg
	VSkTRq4u5O/b8htAlXaboBjROtfoSuh6IOC91lqO5nkGDfC0xvOYQxVLic0eap+r
	dIJMJMI8gT4UvZ+DWRIokzQCA0pRjCbuHPbGOZkuXLO2lmutLdnA5ygkclMYret+
	gV2gIPnThW4qeCzwUHSOaM1xqGeBkoRmFcipTF5epI1Y0Qb/BQ0q+c/DH4trikRK
	ZnmS9w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke0ktntk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:02 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c1e6f602cso15102611cf.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826602; x=1785431402; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=hJlQcRe8vcRFdM435fS/p8hdcUcNPPxN7efmSA9s+sNw8d1N+7bF9LF8zEjxXxG6ve
         wfcSB2dtlXL2m3rbWAf4imZ5pIjttNo7+zpsB7n+4kdLTpqMNAWyIXuTNiQmydIT2EqH
         9ZUtc/vzXllBQaCO9PBjIbvnfo37IybpOLiSI/CuHqHLjlrsTorx5xplauAEZM5Qc7G9
         o4d7t0qHAKhmTReD5aYEYJeDYBeiWqe3Ur0ZAAEFZcajcTNgkm1PDpe6Oq4Wk7eTp7kH
         tSYmwbIgaihAib5iMUahSGQ+RraRYBAhRmOPgTSYT9T1zfLIuQcPJjYKr2XPjJBL51tU
         3n0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826602; x=1785431402;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=H7BrtltISIZkl1kLbG+L0PJRGCxKYPnbwJFbsmTGQygDEQo9CoN3insrIr88Qfdy+z
         YUmKb/jE5hToclFcepbDwwhRwLRaF/8iAfeNVPXkc3aGc9Wyw3wBsaOsNwWKhilpjH8+
         7EGWuqyuKJ8dBS/0pYMd68IoeYy3Ilq2GImRXm+lFl6utrZ6oL/SqE1SbsD7hHld4XQA
         vYW4KNibE0VF7KbI7mwSXZlG9xB2d0jySzCo897hriQ40LzFiOM46VeO72nUlmuNLtKl
         1Xeus1peSm73BNiJI43baoGVW7bCbyEXcA6NQ7eQWMKzu57gwVgMCfjWhkWwR8hk5yLH
         kZ4g==
X-Forwarded-Encrypted: i=1; AHgh+Rq0h8W50A1eNnxZZkQ2xpOB77vp0pRJ9pS7cYZyUh8McrISDj2wkGrUfcfckl+jwOYcR+X1ao8sed/bewE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUXFsna5zfmdZO9uGCjbcunZ4YMfPbIp3X0TOekahR23PILf+g
	XHmHNhYDWCEPa6rjz4DBaNOwffmxSqktWYtn3hrIx7LyDUiaKP0HD5jgMOHFTJge+ytDHr61toP
	c0WcKzHaTEzg2yhagHP6RDzBVY5nqLN9d25ThgUqwpW4I55AXk88dqOV7RwWJWJaWIUw=
X-Gm-Gg: AR+sD13D0vIVP8P532dPKtkRELfwnGddteklNvjhIsHFFD4yMBeYex69jBTmbXP9Y3o
	3hvKRK3Q7+MRxSTEE+4HSiY8pjuwExs4deRf/6FMzaXgV3DCDTm83kXvFJH2DpFoZYFJZJwG9AU
	CzWNfxgavOrqy4CZ7Bh9vsh/QXllnEjCR3OYYB8+hIR9VIaTyYbzinXqdAzzQB2vxsW8b1DdRxU
	bF1/9Bw3wmwLy7Z9Q6AfZzitC5CS7+kHlN51+xyCXZFFQ9Ly06t2DRhnlebcIsI6twnzsGvDYnw
	Jxx/fehgjFpUe7l0eakFiHM+Y06c7GYziC6iLVglTVdUmBuxlwtK87SkzOb3ZktyRTq/ox9gaRZ
	KZKC9jb5XJ8FbT59qJyIuwyiuSjcg
X-Received: by 2002:ac8:5711:0:b0:51c:1291:911c with SMTP id d75a77b69052e-5283ddfb0edmr35646681cf.14.1784826601625;
        Thu, 23 Jul 2026 10:10:01 -0700 (PDT)
X-Received: by 2002:ac8:5711:0:b0:51c:1291:911c with SMTP id d75a77b69052e-5283ddfb0edmr35646141cf.14.1784826601146;
        Thu, 23 Jul 2026 10:10:01 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:10:00 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:16 +0200
Subject: [PATCH v24 10/14] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-10-4f87bb4d9938@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2674;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=34ButmP/zHfg7ujor83QeeFN6rzFB4sOTC9ae7ymGro=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrITet9bWWLlF1QKOA3a8SVNipTK2mq9EKg6
 mnbit3+FIiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKyAAKCRAFnS7L/zaE
 wwGoEACZ+RmlquNZErTNw//QiZlhjQQf6QcXzkBFThMY6q8Zr2WHRA+PKl0pKeNy5bfcaUPaYLI
 aa3kTfzcoTGyW5IJZEJ/C/Xdv6Ao75I75LEIjIAKnNuAJxNp23Cuj8E/Xa3EOOk9HAmILlJPBKB
 n+ZD6GIVXWBve9KwXr6MqAouS27taz8n4kw+ptOmdngOaI7jxOJgHkB1v3FcuCk9PZpS+7y560v
 5CGYgGge7GF8zt4rJk6Nw9fc4wvBG5qz9DdbN4MdLVqNGISuP/CodKg32hvb+YsHQJdJpkEIchD
 imPpbHCPfeoXFdvhDjmRNVsqCq5KQnilNnHiWgdW6Eo+RJieeEN8wD+TuMhMo2sarSAGj9PluGe
 XQItDy4ymVBmCdVt7Vfwm6x6LhCW35mnnqZamOT+CNlZ9rXCIQBD9udrswfIhPN1CFABWmrpCfZ
 O8oh23hz1Z0XY9pCVgfi3Xw+JMQrCi1SVbD4CYEh95T91n3qdW6Lg/xv1I25j9nWY6TFX7WTJhk
 3gHZnD0M+gUD5JTFLYZbU6oBYmjBSJjP7Mvydb6xYEZyijORxd4MMKfGgeFCmdJZwfiivPxFiaU
 VV3maAF3APxQ6CQeMDLBVopbArKNWfACsvuLr9jaTwTdi/QZjRTWm9P56+mKm8jTfNTE8rj5cvK
 pWy+eAQez6U8Y7w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: Z6UQztmtVYwNHV-NNssCJ2eV436TPfjn
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX+jMUJ171ruha
 pfDS3F5uuUMZXJafQPS43EBWPXDLrXScFyGiOaZg7tSToj5YPMXzVO56RUanWFRVfjGiG3CYwc3
 JV7h7HQsDaNUso1yPvBcerZHl2C3xlk=
X-Authority-Analysis: v=2.4 cv=S7DpBosP c=1 sm=1 tr=0 ts=6a624aea cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lH6k5GM5CfRwGFUYfCYA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: Z6UQztmtVYwNHV-NNssCJ2eV436TPfjn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX/R9VVREbflfQ
 7d0Yo+0m6EjtXphjBk3TR05C69lDvWqEQ79v07tlS75/zz48sc/Zxcc1RDevvKKvXJgZxune1M5
 vx2p8QA3XzQ8O4diF4JwhisN+cl15nInYkk3741WkN82uELrFqAb0TNvMP4nSaold02b/klhrZg
 bal2bTxL1+INSUnBhdfCBgpY82fCEzLbf6MqyF6FkzvaQxKJ0333RYup2FH0m2wHgFbMruph8ko
 3wFpHVZ3CR9QWGiLrsIz20PXdZRS8921XPq916ThGwK4PmpGIGj6CecZmmOdhppWUK3J0U0Y9Pk
 tIOA0z2lwsORekqENxkJW+8r72kBSO+4Bnn8Cyr2XZKILLo5KRwnE8YNKDIFjlYNeoMKnSgbvdO
 OxumX3GTwcQOqq0Z86fHRuXrYoxv/ZL0ISu2dgcZyj1x3uHQB5JxLHNymlc0X4WDSef/sxS6vxz
 OTbTm4JQPlKLEQBqi1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230167

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
index dd860435d2c47a608c82cc2686583a44ff96c889..aa4a0b17749081f1ad653424bc265ee81e348e15 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -237,7 +237,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
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

