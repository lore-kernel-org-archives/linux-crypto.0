Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D933FE66F
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801105; cv=none; b=XF9cV5O8KADRfqP99ggWKK1WX2h5xrM/Q09uO5/03WHL9BlYkaCL5moRO83m0NVaCM/KrDbtKLvtudQOwGDOBr2rAOybSH41stohVSIAaYi6WtIHJks67zhF0OOiD/zHOCHe3vLlJvj8RTMEAnru9yFkRbEoSRuPAi75QGFy1+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801105; c=relaxed/simple;
	bh=igdExzts6hGBwpmb82pSXSqv7njgqWKOAQxuOIrd/o4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DG8UwwxovueK2eIEqSCxR9RD9WJb/+NV2+jndAoXuGlJvsuPhmF1D+PpFPOrojZNY9CWTo4Eq+hNKp+6jtsKtLjqQy++PQPpheidggp8FNg0wg0JtwoR60xC57E/0u4mLteE6E4MXqWRNfTa4v9hPnHW/UnYY08uJecWM7FVT7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DYHfIrWC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZWSynj3P; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DYHfIrWC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZWSynj3P"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsYPU2882626
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fS5IBVsYa2e0KErQG1aApZysP0c6Drm/Zin4N96y3dI=; b=DYHfIrWCRvPDgXat
	C3k7E6eCbibBxjEmfL4JRvoJ+UAqTA+ixYDz4GL7yAztI/96a6cindtr/pwiKWLc
	apTnyppsY8pIb1Z+4j12JFYE5m6dx1M/1vC3j97nSvtHDsLCxIhJOIAgnMjNmw16
	21weRK89WfQ0CLSAzTVlhlOwgHT27ZVzLYxIUO981RVxx5YHGOYQt4JVcaZOW+rJ
	7Z4PZ/A8bZRa28L6rGfqRLBdMbDyVCFc12mVI3fhUWjOBP1SxqipwXKIMNrO9d/+
	HNG+uf/jL+Qxrp/SEtl56W240JAojtTG0evb09pTrnLSvmjLtNYSiWj6CwOtBT1O
	yJTwKg==
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecqudc84p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:42 +0000 (GMT)
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-69d733e7995so4078331eaf.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801102; x=1780405902; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fS5IBVsYa2e0KErQG1aApZysP0c6Drm/Zin4N96y3dI=;
        b=ZWSynj3Pvk8DkHI218QV6jGpCikihEC8WdjSrMnenDJ3LihhTJQrUlAaiTUOA9K7Bt
         Y7Gi8HjiTw+Z2ZaDOqKl6zS+qAM/0HSJTuwfQdtsNOal8LHyC3SJPhHRFwWAxNdQuc84
         D9rpq/sgncOZeTnYBKUVhegDJM2V2jn8n2LSk2sBrgRoXb88rsJD8v73c7zPs2VapI6e
         3xS+a+wwApBDIUlToKIB6hPlPaFrG16zaSY7RF6fdzf6XetzMy64tlYtK/yN630g+9OZ
         KyARL7viYHu2T9rTojYZx02bohAeuCmjjY/4MidJrTS2XLM70N6cZVeQ80yflnsYvW22
         sR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801102; x=1780405902;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fS5IBVsYa2e0KErQG1aApZysP0c6Drm/Zin4N96y3dI=;
        b=g9nvQeUNjHaB+pSbIGz4CydhW/JVGLJYUvDHmtOvYCoHzaV733Wof05qtB87F3gBb4
         YC5AETJbF2bsdSV36DJKQnaHuBx00wdAeGMgrpUBci6cOKEAvLM7lqqKkwIAE0v7Z/3Q
         u9V5Gq9Rxtstc1y44BGNdhbhqmt51T73M8Sukwv6R/z1YRkMjcdP8b/1I3e7F2IWjN6H
         GR54xNdJM6KW+XZSYC7tvotzTXmXdkyORUTmn4r0+vfdyI9cfpbDMxojmtYcg1uVuDjF
         7vY0R3VZ6zrpJ2mjsHyv3vVN7ihWq3YAMumcspfwGJss49phXPfPVYt0XwgxJm7S44O6
         UPJg==
X-Forwarded-Encrypted: i=1; AFNElJ86LwfwGAaFQG6PmXDZ4Ex7NYCVrvVhM93SVn27tmR2ftW2hDSxpUs9p+vTk50gHVfPAJC0efs6J7S6zgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE1SpfykGKsE2DFe/N+HHGdWAP4UCnnrdLA0JCoSqSJw9s5/B7
	saM2eLlkRuNxpquiqjk6Wx4+rkXsCvzlCKUBqgnzXZBjdyuqnNEbcCoapwvKHm93xS7sK8ge96W
	OjT5LpITNIM9qWqEiq/quS6OHskkJA+dv9EeNpVD8Q9NLgw6t9PHZRUoPC5nbQS5vkfM=
X-Gm-Gg: Acq92OFPUIEBV979p0cN41e/0BGvDHk9kIq9kYJ6iwpHEVeOBODanAfs7JNI7ERvVDs
	dYZ8zcrisPQFHOuWIiVuwh+UQEG3gwsapyf/Y4OqCv/6IGmXoa7LDNHzPEX6M4sAJ8CDDGZUfSz
	5YQzfq5Pfn+yff3jLT1J8Bj+EozSe5u2O4OSWqqjdrzUVJ+Gard1nw3IUkzNmH95tccNSBcbWw5
	64CojXkMZXQNrAb/VVZFtX9XxyIQnTQyM+Y6W8TWnr0cGassT3xTdR99HVaLVVlJ5TgK/b81xQJ
	m54/NRg5oDKxQhzSjBrUUpTzwEo7Wv2PemM/K+b0xKlD/n+bkAk91Gx6z/10eYeKOGa9ZXgToQX
	MEIlLEU7kknRHf66QNCXpXz++P5bO8THJrRTbSLWcJSe+5uzLpdA=
X-Received: by 2002:a05:6820:8748:b0:686:48b7:d822 with SMTP id 006d021491bc7-69d7ec669d5mr7214609eaf.39.1779801102047;
        Tue, 26 May 2026 06:11:42 -0700 (PDT)
X-Received: by 2002:a05:6820:8748:b0:686:48b7:d822 with SMTP id 006d021491bc7-69d7ec669d5mr7214543eaf.39.1779801100822;
        Tue, 26 May 2026 06:11:40 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:40 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:10:59 +0200
Subject: [PATCH v19 11/14] crypto: qce - Use existing devres APIs in
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-11-08472fdcbf4a@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2324;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=LBuvKb1KuCRjlB/LWrhUiOm8ZPEYJ6TQ+hit1E8hQ2c=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvyYUMx14CV2qOvBEHOWkAID6TiiOEjVKggi
 O/WEdIfs+WJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb8gAKCRAFnS7L/zaE
 wyRTD/4hg9wYGDDSy818hpIPlgz9BZ8RyHJGOAdVeinF5HhcFxqOgrqpl+6veVx4dZSB1JHkCs1
 +rYVAVniujQFZ0tODiNVro2eRwO/te/v1Y9xuoA7VqETbn72Cvml5+DMnNX4hPIp69aRDCaCcaM
 kFhBEikic9Oz/nRdSZ06OZdjAAWSegIH/Oj4Gvb1pjY73KkzkgG1b6PRmS16ml6kGhjlfXdag+/
 m18+OmiDlkKl+RjyQDh0bNbfhFLbWsS31LeVnF4s6E/l5hEIpJZ90qP2kDNNLLRjAue2v7msYOc
 7xIYWzyPgNgpXHxjlRD0CI6ZeR1MM4G2RQwjgkXOoAq8aLPhPHE48Xjw0EkvqnsAT77YshFKzPJ
 /URjf0hbUIOixGnRUaPMGkdCji2T7/Gt7JWiMK0dUdg2lZ6oqrd0buljm3vOkY78grpuBLKGvNC
 rYsxOKZips4HzMZ/WTH+NcWGIq2lwop+3kXg3XJRFAXZaFRczjoU+ni1xjW/cnfJ3Ppfx9679T8
 opHau7RhCwVUU7h7Z/Lys5VXqPY06561BwwNKvkWD4u64As+hTG+up+vlC6a/2kD3D9wQUbHlBY
 67o/pwLPywx78dKQ223mbKU2nUAHF946vO0fhHzeDNyxSGWHpDci5ELRdaet4csQ3vyL7b+8L/q
 G69dsKySRqClcEw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: K82g6JT8AwlXiu5byr1i2n-cy9wINQvS
X-Proofpoint-GUID: K82g6JT8AwlXiu5byr1i2n-cy9wINQvS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfX/M2O5+D28Si6
 kP81m/xmRSHBslGJeCHCZ+Je9pxxHA4/mYSIh5Kma4EYxLhsUMuwl/acfcGIq1Iw2qQJNkZusTJ
 BYdf7/4mzueN6hqEdWGkVJ6XtEGIw6cM9rkcjqlnOFY3J2oV33Rg3RaPy0CW3IsWDlmoGzGY5P7
 HMzjXvFpIbTYKv/BMvkSbDAl5zxx1v7pBUb6UGJKOz+0PcBb8OpPG/fXcfiqdDtSzcuxYvkV7c1
 ruezBaUBa19aLiZDTL2AVtOMbYzWq4FLFw0X/tFVUtESdAvLBHd7aKSJX9GBHt+z65IjllipqSD
 xTXD5DRWPC6L6pK3MaydJjfBuQ50qIXeiHNlV2JeIPfXD/KUuOgOKMSJGk1y9TlRnC4IOt0LJrH
 kNkbd+hOmRheZR6qZzWPVEepTbdL1rei/8JpFw6IYjrVv4O/I4Ex1Lu7dD8dZswoyHvZHORd2hO
 sT6wYVBd+uCQtOkMVSg==
X-Authority-Analysis: v=2.4 cv=C9jZDwP+ c=1 sm=1 tr=0 ts=6a159c0e cx=c_pps
 a=V4L7fE8DliODT/OoDI2WOg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=Y9RhJx1ZIj24Qa2dK9gA:9 a=QEXdDO2ut3YA:10
 a=WZGXeFmKUf7gPmL3hEjn:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260114

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Switch to devm_kmalloc() and devm_dma_alloc_chan() in
devm_qce_dma_request(). This allows us to drop two labels and shrink the
function.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index d60efb5c26d88f8b0259b1dccc8724d0f75571c6..c2602d35baa6ad3ca5de734de7ff6160ff29567c 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -12,7 +12,7 @@
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
 
-static void qce_dma_release(void *data)
+static void qce_dma_terminate(void *data)
 {
 	struct qce_dma_data *dma = data;
 
@@ -27,34 +27,22 @@ int devm_qce_dma_request(struct qce_device *qce)
 {
 	struct qce_dma_data *dma = &qce->dma;
 	struct device *dev = qce->dev;
-	int ret;
 
-	dma->txchan = dma_request_chan(dev, "tx");
+	dma->result_buf = devm_kmalloc(dev, QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ, GFP_KERNEL);
+	if (!dma->result_buf)
+		return -ENOMEM;
+
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
-
-	return devm_add_action_or_reset(dev, qce_dma_release, dma);
+	dma->rxchan = devm_dma_request_chan(dev, "rx");
+	if (IS_ERR(dma->rxchan))
+		return dev_err_probe(dev, PTR_ERR(dma->rxchan),
+				     "Failed to get RX DMA channel\n");
 
-error_nomem:
-	dma_release_channel(dma->rxchan);
-error_rx:
-	dma_release_channel(dma->txchan);
-	return ret;
+	return devm_add_action_or_reset(dev, qce_dma_terminate, dma);
 }
 
 struct scatterlist *

-- 
2.47.3

