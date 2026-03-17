Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DC73161A6
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756181; cv=none; b=imW+/lcIONDdHJA+jge7HP4Rg2aTihE2UxDEGcLUktuCcCbIOQ9/O3q4FmDYleOKzke7YeVrrDuWc5bZV9m98Leyo7V0Y4FdJgjLcY4ulZxTBYboj/LPxquUfMdvpkdbq1wmGUDu2gFL8SlSZrBteaHyvmfVqqoF1CHN/4Ku13Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756181; c=relaxed/simple;
	bh=H6RGZzI1m6Hy642I73fornlozWd6x9hkPKo2H6raYsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JYeuoYvmTnEAy5ICXFOau0FwTVSat1DywgaO1bM5U1gNf4qO1jRr3LoZ+x/n6GQ9Hvkm0m6JtkM17zTwAnj9uhJUf8sY8udGHJmN/Nnof2jMU9iCsqNwEcbmJb8k2/aoH53Jzc5TnZih83s8N2LPXS1rnpt3BoHVGxORFzpiWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VG1sP+Xc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OC+EMmOp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VG1sP+Xc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OC+EMmOp"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H7RDxk2905945
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=; b=VG1sP+XcRIQOo27a
	fGyYspmQeIdEzjMzHKUofSMMxPgamN9T0s+sFKFNKJTSbR0TONoyibJ4F7sEnCcY
	cyYCxHAa0A71FA9ygyl8a8LEeSmx+zfxLi6NQP9J/CoHamEGXG13w3w95oZsxc/d
	bqKXNK8IGWkH0GWbAZyOffrH5v0RPtDFBs5J3/nFnz+DydAcwVqvRxrqtbgag42P
	7/wFQN6kA3hH7ZImsBveXT/MaFXSSNO0Hzxah4AoEng1JNYtiIHeR0/fLSUxM4iJ
	xRG7/FwPBUK4qG3PuereA+0AoaIkeECGFPdjuOCv/nDTC2UwtyVFZ+bCTYKn1dcj
	9u3xfA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy2jxhdq1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:59 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5ffb295babbso8653951137.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756178; x=1774360978; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=OC+EMmOpB3ppLlNS0tj/oFhR6Ru1HHQfd6pQp1rV1qqZ425fudihcvK9dhi/Df938K
         iMovQFeFjnCy4vOfxcJCHUEyBjStN5gAKR8hRQOct61DlhIuSfXBSkSlZEH+p6Ft+0RT
         cKi00CoskXQQY1VtZEt5K4AsUF1nVWuzkjMfPdR7xCrfVD1vbmpTISc48njHLq+a4rpa
         Wp+1HVbHqMrUQt/1V/PkuH/eeo8+tVfmxUQnql8oO0XgUYI1gY2eg6s1F7cFfFwYBbb8
         xR07u76gMlxXj1gXGxprIQCagSifLO44v1W9T1x4g9vNwZ18kU2CCEWQvkYkT5OdFss7
         XCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756178; x=1774360978;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=b/PkB11cx1mC4Mn26t5D1ecSuXt6F9RIMDWC/HUc56J9txOHS4u6NmnryLRuj8j30V
         sI/hR7bY1DTNzXtvYK+E3uJRIiunFckr95nm1pBPNoZj0UENhtni1IH4z7AXOi0OBREF
         8NRVgT3v2LxuOlGnlN2d9yvS9lL/LNC7BG2dnyGMbO3grRHTEszINktpslsw1vMxj7oa
         REa0PnhxhodyMFz2g0GuwJawh117jFUD4cXnueBBxvSrPfaSaWYhZ30q0CeOqtLucZsO
         wJD8ZYzCJfN50dTylf2+N+e6fw//0BuziYQOdvaV9RDFq2HmiBwrIZDTnSE8b3qDv7Gy
         1AqA==
X-Forwarded-Encrypted: i=1; AJvYcCXRrYwdlhOmfY5Qg6Q0SW2t2EwzLoXRvOPXgPg/u8eCdL7Bh9ppBNfVlSQ3X6rHMGSuFLVBfDvXqHKZ/6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOVD6eITasweyu0AN5Mk5Ro92qth7ssQHYrK9dvxazOTBPsnRS
	j2LhT70MY0ZMISnmqAjvhON9kyosvLEHdJWw+GMqvq1ZccDF7mjbR5//kf72RUHa7Gmu1iEi3er
	/XGFrBOgB/3VvN9DY+urkQmmmrXkMbU9azP5JSDLQzCs/B3bF/4lt1Pp9xniokhG7RbSNaCaoHo
	Q=
X-Gm-Gg: ATEYQzzgObdASDxzx+QE8JjTi2qC0uC1L2YbpKQju2DArADm4rYas61QM9zBCupp5Cc
	Q1P1NUILWv2kYFczx6/JnSXOhLUwgTatAf8Ku5/HeSbGTIL0xFmL4f7nzF7UaOJHrBspJksVKYK
	kJHiv9EOhaHYdWBOOO4s0tHkknk4ToPrfT076UnJ/fKMZmaODF9Mzn7dN8eNCFeF6Eu/h984WiP
	895wDbEmQx5tFCYVXE5YNFmOxGMszCEwZv48FKgHD5s0lrVzZdoJdp8uSfVnj/cEIDWI6H7kdIU
	WpXsC3Fpbiw8FPncG0kRoIKJKUG+wXFyCLimE+jB+PjMxnQe6JnRdEBW8oU+nYfvYCHWb1y/TAK
	ZLLzdLywUNKT8ZwbOulpyrWLBmat0GAjVt9HTZvdCXNCiEZCRjJ98
X-Received: by 2002:a05:6102:510f:b0:5ff:17bd:9e83 with SMTP id ada2fe7eead31-6020e236a11mr6181953137.14.1773756178122;
        Tue, 17 Mar 2026 07:02:58 -0700 (PDT)
X-Received: by 2002:a05:6102:510f:b0:5ff:17bd:9e83 with SMTP id ada2fe7eead31-6020e236a11mr6181878137.14.1773756177471;
        Tue, 17 Mar 2026 07:02:57 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:56 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:15 +0100
Subject: [PATCH v13 08/12] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-8-0968eb4f8c40@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2620;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=TfRVgyaOMZw2GJQ0rx6WhRl0huHGm4mvuAmz76BcVUM=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV74v6AQxf7crq9AWxEvZhNv4EhOR72KDttI8
 q/1nsz7n12JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable+AAKCRAFnS7L/zaE
 w9dXD/47ORISq1CjAaQ9sUDFL6I1kw3hWOnPBV2CWeej4dNIPVBTHadvPvyqpoIS436Mi7LAyjP
 HOqkol46skL6jyZCAJtQDYY4yjjN2bH52aNG+GZ0n3jGkrqCptM0K96l4UObRAz1h4HTD0nu95J
 FU9+RnrrdZIylaSCyWHhG/JKDWJXjtHhIWkTMS4qlxItVkZIfRidt1EeEvnXfv4MQY3ZRsfc6vd
 1TQ1miFuQ3VN0ow8EEGUKJci+qh9gqF8PIpyAV085Y7ilsXbixV8KBXOimussoptXQmvltZn1qQ
 xTFFVTfxLSv+MfnEv2jv1NEboVyxE6/F6oMFSKrEoiptInuIwlCBV0OnneiZbY0lwvThs0kYBJi
 SMWEBKg86VbgW35Zv1Z4Scb/6PWI5zZJ5lILy/4hho6AE4lhUkUbdkTwmC/HN/rPOr1RwSusRKG
 QbCN/psbd5VoNUetU4jFsTCaft0wmGmTBcjj6RSP4fGhJpKYHAJLlYGL/BRXHZVBHwJzCx48Ef6
 KEr5Xib8bhpboYJ1IyMilK1aXmfl3ZLLWxzrVr2YFxXy/iVK4cCAkiW+J4SI7FTkcf2ksgwLwKf
 0pfHvPPqG307MrLoCqKfg4BiMoOB8ixIXySA1NeK95RU9jQgwuZ7J7F8j99MHGmxefd9RM1sgC+
 NBcINfQUca+8n9Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: rYUQwaHZwAhBm4ll7Hb0FB7cyAR6aGY1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfXyWn6OXW29MV3
 VWlGY+jD4QujHu9hnjbE6mf+6f8yuYThh20N3KgH3Q/hd+t61PiDDucB//4KbqPosrLNKbnrKAo
 sLgdSBLMgXU2voo2n+ysU6t8ZFki0gRANYC/1GqZfj/PtFWPr7FapIurNULy1d0xIyYbYijYnfm
 uBNwpMW81Q7JcrENqweweqY95kk+U9X268Exs7UicM5cs7IZWVj0UrvkRV7sS1P0oQIDxpDWjr8
 KfA+VYoNtw9vpE205kYv61gD23QYB3G3mo7FNdSUlikqumErFz+5FGnbC5bGxbG4nNZHi8MW+Er
 VY0o0DyANhMHBiGyTU7GS9lRFzsY9uEjjZwXF91NBIDjHUys0DtWPb5GB3Fyp7QokrysUxvEbzr
 Rd1mco6mrvlouy5rhXBQgS/ro7Wvr4vYZ8y5t4w7cwlzDRe2HBSo4I7DrQ5zaoL4e7iCJELP5Ug
 Mf8r8m8GSNv5NeIb1eA==
X-Authority-Analysis: v=2.4 cv=c4imgB9l c=1 sm=1 tr=0 ts=69b95f13 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=KrkfD191a8oFwBap4LAA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: rYUQwaHZwAhBm4ll7Hb0FB7cyAR6aGY1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170124

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

