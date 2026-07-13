Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767E541DEDD
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947723; cv=none; b=ganX7UqmB0yMi5NLJWKPgysVYz9k3/WobamFZVLpbzGuta7Br5jl+kyDX6YIQTSwZfSztMwEjDsjlho2SPJEeVRIiCOXXbv3J27dSLgjg0FZe2Fwl/8Q5zR45nd3amzTuf0fyCA8t5o5yWI/YPdGrH/utszzX01SnqrVvRB63Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947723; c=relaxed/simple;
	bh=/3Q5BLE2qswUURgRMp8Md6+CmS+GMHS0PuiKEz36BBw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gUWW6L2zjIUHSVjYrb2+fFR93Y12C0wR7CgeSTydqpJ8vPAT/nS8+nUYCieYhC/Vbxth6NL4gG4eTTeetU60dx+vbt1r3OfIWGJZKPXBAxY+LcLI4G5Up4MYVab1C7NUPx52fbfjZ2FCkjVM1gm5a6/6ISOp/70spKm1bRLvnI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YqmcbfQW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KRMT3TIp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YqmcbfQW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KRMT3TIp"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCE1sn1210093
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=; b=YqmcbfQWyFimoHqy
	hTBs1MZbNm3SnxRLjRNQ/3iGwHDx7cdV6hRdap6aJLHbCp0KnDZTWain2cD/yTH7
	6c+jmCNZ/lI+ReAH4xtBGzF19kJzM01ws3kYh1iQ9St5Cbj5GnQatB6pjhrZNxXc
	gzDCmV/Ph3lBZsLerwrUsTkdlGELQeu7nHQNIgeg5fo/XjCvz54VAfBPeOBcc7ps
	qvoAFnR07kKU+JNSI1eZw7ScSD3DxYtAcPw6U0URd2t7rlNulhBQOtYQ9dinfpOQ
	BKhzUUWld1vqgfVhlvup/eVKzFJnES/jgk6Sin5kmHS77bepwnnjbkYLNuhMG4KZ
	+ftuLg==
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcw4qrtfe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:01 +0000 (GMT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a1632e1c13so2021586eaf.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947721; x=1784552521; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=KRMT3TIpBFyYr5oPo9cbboMBT6umMGoOUaIe28/I7RBhywd5wir+CTU3WIRXJ5zCFE
         wNNS/YV/mYnxcsOdDzxJtlL/VinhDAOubtSPLHgWUtUHBzzmiLOYeeordxqp39rFj75F
         a4wJBw/LuLNZSc2FPM34ZKlfYBx4Ycks25RItQOjKHn19uyoDgJHkvXCgyT3aB6qyPmU
         X0l9T2SonNMkCBBAj14le3ZN4J9oM3ycnisAI+6JumQGaUxpZg+ph7hpDn9jdN/uUC+0
         P8e51NEvqBgN1SuyBKnb0Is+pNHwTwY0Ehdg7IBsHXLceHwJE2RsJwG6kfRpWwTOMNHk
         DS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947721; x=1784552521;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=pF+6NGwPLIpBFF/m0ALInrXMv9eOq3Mbn51g78N9J/k/fLNCGZOuAxCmUmewpM21va
         rqtqNqPuDujyg97WAxwAJoq606d1OKKNmraq0u8EffYqyzeYFD4TWA+PFKjvvYcX7vt+
         xbP/J07k0sF/Ij4BiB8obN1b17gwwe+r746kjvdRqScITNCQERny1ZXAtqVei1HUKrU1
         E0F4fT5My3kQX4n4SWw88GW74aPV8Dn4sGncWb+E6JDC+xjfsB2ThOF2KR8qB6FwLpX9
         BjQ+KnKLMIwD2xtL9MXAWkBN+lB2xpWbjzSE1ae9tT60ZhNl09/jrvNvZ5EXWaJ3OMgS
         b+yQ==
X-Forwarded-Encrypted: i=1; AFNElJ/HzEn4PGAtk4NTaLpIlb2qtiUMeW97ulqCDdtPnufmdOfEyY248Ar5vCifopQ0WERZECW9b70UE4tCxNA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdnxBN1pVLezl6vd1SlgS3pn3JemVifNXlH4mymnBdaz4Hw+0d
	EYG9OibapoYceJznUDpqKh/zNaju8fuurfqg1dab3tf30nuojQUAG3pxIDUsO9T3uWYpJL3ni4N
	6tlJ7+Q5lfoz+UqGrERphMlosOajGEE5YvKJ3qnPE1mHBz4C5HRBBsseQ984nVKL5O8c=
X-Gm-Gg: AfdE7cnJ9ggRzrXePt3rgMCM0y/QTDP21Jr7Pmj3SQXSVKc50+fqjYxeZlA8oiC6Z4q
	zi03sHLF74gkVjDyTxdXLkvHbSa9CK4RPaOZr2vFY1xvx6JXnW0nECsprfxkmdfx8ltSoCO1Pv1
	5EuLXQUh9v2mWMpYSwHx4WZDLLUf3fdnoz121h7b1wA3qWrsKXviF/r/1qgLEs/HT+Itzin34vS
	ue7V8gaqfuL9uORNKT2P1wB4RMBaFItWycN712LBt5XX+Z1JLAUT97M4mBpBsr6YrVgtJzonTgY
	lnwUKUn5CCH9zwPVY2ec5V2USGn3jQv/rjSxFIX0uMDDONThEUmCF8+Bf5mSbIlTNDcoeGvyUBa
	hi5WPYE7LwTlhF35+hBUOe0qnRH7pGZhPzwawQPG6
X-Received: by 2002:a05:6820:2220:b0:6a3:2de8:797a with SMTP id 006d021491bc7-6a39a55bfa3mr5264893eaf.11.1783947720032;
        Mon, 13 Jul 2026 06:02:00 -0700 (PDT)
X-Received: by 2002:a05:6820:2220:b0:6a3:2de8:797a with SMTP id 006d021491bc7-6a39a55bfa3mr5264804eaf.11.1783947718791;
        Mon, 13 Jul 2026 06:01:58 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:56 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:11 +0200
Subject: [PATCH v21 10/14] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-10-bc2583e18475@oss.qualcomm.com>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
In-Reply-To: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
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
 bh=34ButmP/zHfg7ujor83QeeFN6rzFB4sOTC9ae7ymGro=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGfuyASyenMkoXWOhJgZ00qytHI++2nO2fsz
 8TkfCIEhOqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThnwAKCRAFnS7L/zaE
 w33VD/4rDhltcSAEuGqwmCDJE+p6NI3I7To90AxBT9EjTdXDOmQAXXyyoRUCS7QE2RaoZhWaYLa
 nrvWzWyLMm6SuZi36hJjvs4a1X5cxgUzc39f/m16shf7v9PmFTtg4WWrtEyg7u9sxtw7r14WKdo
 Q+M5H3YlRG0TvrVH3IDdBaue7HxeJ4lgGNhH3bRdSZnlvlU0KhZyq49gZjVQOsiiCt9jvbh6ZRq
 2L4Y2+FQ/xMWhiOZA8kifB4l18XmoacEaVOis1e1CMF9OBPzp4mRicU+3OWhJkxZO+UuRLDOf5V
 tsuw1VuyXBYRuWqAwFD/B1G/jsDNi9pMQ98vJ2fFEpIHJN6sX2/DfczE09bNz6+3Y8oHXCjl9Gc
 pUwuC8LezSx3PGEswV/DFsmWs0USYxG0WTXDCLctElR45wnT7/hCSpN1cSOXEzrigDgNSmgraTT
 bVJUaydalw0ScF7XTLQXrO7JS+18IkOSEw3mpk3Q1apkddV1Mlr01gKdJknJBaN/3AIULDVfFX1
 4SN0oxTWYqHaL8k7iE1SD04j+x32Up/D13O0SC9ZWXOxGP09OIsVALrHAPw55l/Y0kGJwPcfR7I
 L+v3ZUxQsYa8GAct/qpNhql4ZEbX1Y4mut0n+N1UCfAGyOdTM/fVofa94puMrkopl2CPPPEKFdu
 QUVPNik9+ylXWIQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX1uezujlc6/ST
 7Y4K2fN2tNDvUTdqPL9Qbo6o76YvvkoYFKucRRXEQZBQsZRGjCKsJ6U381e0UbUnDR54T09baLr
 UCA4nZuUDwYG5INKq/bZJdLL4r1IRtXg3UPq49mLo+Ez+3uoIDWlZBxXYhAf8O0Xrp03tkyMspB
 Jlz6PPrzJtrP+d59oT5S2+WXqRMmnPtpqKnPWOUREZ47sADPohcoyP/Xv563MVyUF0DvY0+evqb
 GXamUORtoHyxJEtThNXL1EWSe+zXu4gdBZS4zyms+U99U0zwhikxFqALHt98yGbuaBoNu8RLXiU
 NMCNqKp7//ZFnCmih4tNT4KN2tQvvjYMf0d7Cdmrb0qHOz2q0HcRMDq4pgt3BaSW3Roj5EGcC7Y
 z2J/r+I9KNk0YoRJ/5M6+SpnkxmTFrSGRN5CqgiJXsOtWFA8sV15wKcBtM+0iK6fnb/zP9G7Ffq
 +dRFXbLwvPPQr/vMXpg==
X-Authority-Analysis: v=2.4 cv=HJrz0Itv c=1 sm=1 tr=0 ts=6a54e1c9 cx=c_pps
 a=lkkFf9KBb43tY3aOjL++dA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lH6k5GM5CfRwGFUYfCYA:9 a=QEXdDO2ut3YA:10
 a=k4UEASGLJojhI9HsvVT1:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: -yi7XHF2o64ChJRyorCxzOcr1pdK8qVl
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX8yEdUFr/eCh8
 w3kPjogXETMFuR5wi9do8HE+WsyekjLP5y6O9nZ9OW+Cm84w3wATwION1KztQF7GA3AxC44iiNU
 C3RfImZddY0bbfereW0HR5RLrQYNbrs=
X-Proofpoint-ORIG-GUID: -yi7XHF2o64ChJRyorCxzOcr1pdK8qVl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

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

