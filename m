Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC6341228E
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947728; cv=none; b=GnywFs6NooiC+GeI9HcDPHk/6WRLcaMJFvfUqQsIT55Qt05bC85Sn2/AgDhphY3uA9jR8gik1D3oNuIpd0/0v+Mk/WAaTnZrttpgu/6PvvsiUuuyK4DCgsSGUFaAxsOAsnDnGlYadxo8M7OeSTL2rlq/jxFngJXGhG6v27fEp8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947728; c=relaxed/simple;
	bh=czoxItsxxVvFFRsK/bUJo7zI9PxP/5bmJEdhhzZ9wNU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eH4jKrVSHPrh4ERGnzcFit/Mw3A6lLgc2mAduxKaCMjTx/VPNVD0ok2J7yYeYthOy55OfCztJI1IsIN4zR4HcOZ61JlER1fJUkF8TF7Gce2UeyzFW8zxUvCxBArqWiKdX98CsNrvn/8UTpANnLq3zq1aAv4NPKFtx21mq1ZX4YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TKwMSV98; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U3OVjG+W; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TKwMSV98";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U3OVjG+W"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCDe0A1299381
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eLuzW4UoyjLIBOHVkT1M1Bap2xQlYADrM6wCNEKkohQ=; b=TKwMSV98S9Pnsx26
	KkuLfaI756DKEf7K1DTY7r6ZVk4EjqvMmE1y4JlOlD4eWyOR0e3avJ93fOj+eHNb
	4eSS0OQpeKKYUFCztUyDKx680FFfmOK1KtDpFUnMa2n1Itgu+WF5IVvrk19D+rvx
	k2ftv0WNM1S9fOy8odZoQ8no7SfZDgdfyCFkLVY58Dowjr0Clpb/R+cfIK5nAtD5
	BY/acZZKQ96GzYHEdk9FljFslVNeFGOdHkYlsihZ+ho0b0BtgJxeB3TzUvpLWgbT
	uq8l6kIxUFBiyXwOEwJOGiyD/BLmQ7A4OIDAJXtM6bbE3NJugJAjmMbPVT7AN1ow
	CYNBoA==
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcwk3gq3u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:05 +0000 (GMT)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a374e480daso4223068eaf.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947724; x=1784552524; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eLuzW4UoyjLIBOHVkT1M1Bap2xQlYADrM6wCNEKkohQ=;
        b=U3OVjG+WPgiuhXjUgER1KFOXyDcHpuDNYc9G244BEKobxzsmHdcxH1hYLwPsA4eCSP
         +Mtxg3urgoT8NAUw064rMCudlFksO5jsBX64JHNIUvmvObTn1UlbssDMejmxEWAS/wa5
         aCpspmvUyHTX7cKXOp8WAtZhI/fnHlndorTxLZMf0npSPRATH9WT9QB4ob6qyZ6Av0gB
         kCtkWZXD9X0t7yCL9rCFAQuKJFrFbmfOgWbgffGoYpXwFmtnxw1JtM/QAv2FU55xS1Oh
         evF3TxAg7QG4PMv0k9VbgyTo7FVuxuruLl/BlZPszTYOAy99+2/d5UgT2B9tNFfQUxGB
         TWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947724; x=1784552524;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eLuzW4UoyjLIBOHVkT1M1Bap2xQlYADrM6wCNEKkohQ=;
        b=bgY5ZaXb/ZP5WOm1GInTEhfzJB5i1dO1ECe9K8M1tcI8jPAyPIo5H+TjZZEWwbVRz/
         aE1TZDaEbyPgYN9u8E5Qe6jT3fxt/dZ6ksFX2nMBsQ/XlROaf+n6lsHCWy9x6y8ik1u5
         nqPYo5hdQn5SjtY3/8/RXJ4vWGaWHYKmNweiEicKaqPAVoxuBpaAQgfjPMKYuJ616XDZ
         InzKiYNIW9TAtkAzXW9D6imp5qqhTexD66/4hKD10iXLnJzI/TVRDIi6XuY/K7TZUHAC
         /T2d+5Ckd+5jY2wEs/Vpuw+SgYxfLYmonYKjJWDRnKQmSy1HxVBxvUGJl1qLK1WshGHj
         frUg==
X-Forwarded-Encrypted: i=1; AFNElJ8sOS6PWBG2EiskSeMwc4ozT5PSWtsAGLdqfzD88XfcPl8Emkb+QL8yVzlnnH74tQ2rvZ4l3YiJgP8Ph/8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz7cSf7DMMKnDHqu4MB/F9omkpzaD8LN+5HceAJs1yDJVB23+Y
	hXyeBwKOVVgNrTO7/0V67ehAG9K34lA3Vj+0N1lwcxp2aV9hXbw5s+hHOEAYn3n1H45GzWiNNzU
	499dtogaeO9aGj3VWRHLGs8Lu819fEeubfsRqUqJO3hhCbgzPi57wvaVyuCZllQp6uvY=
X-Gm-Gg: AfdE7ck9KjUsOHlQd56Ul5eBR7LKVJ7myYK0cFpKf/Qe9qRudQrHbaZDFf4TpFsyS1m
	UxiEWazO0c378v7FWe72Mc+BZq85tpJzcCrXfSx80aDXkF+gmaFKHZIok58SBWaF+D/deihki08
	7bR2bRyqntxGo8PC9HaC3TotGOFV/otOCWmIVY0mQbrBWk/8+6RaS5OFhCq4JYrMpobE7HNBgLJ
	4UQQcEJC81Ozn/PGPDUrN8ZBg11+1x43L8s9pq22etYFK8ISUf+TlIXRqsJVHnlQdYvA40pfbY/
	MMRuCGO5BMz4xEPODLlAXjP+vNLHmQINFYzxlo1sbRlGPXLZfmFLSmf6SMzOV+/ckpbZPyqxSiS
	8lTc1NbYJZ4m8JKjRu/tkGCnk5/8vYVRlOHF8oz5X
X-Received: by 2002:a05:6820:f00e:b0:69e:5e9b:a47d with SMTP id 006d021491bc7-6a38b887ca9mr6712893eaf.5.1783947723338;
        Mon, 13 Jul 2026 06:02:03 -0700 (PDT)
X-Received: by 2002:a05:6820:f00e:b0:69e:5e9b:a47d with SMTP id 006d021491bc7-6a38b887ca9mr6712811eaf.5.1783947722306;
        Mon, 13 Jul 2026 06:02:02 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:02:00 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:12 +0200
Subject: [PATCH v21 11/14] crypto: qce - Use existing devres APIs in
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-11-bc2583e18475@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2502;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=9GKLcUmlCf8HlWjhhByBBy4VvPdK7WbPpBpBdYahW+0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGfa3qCCvUSTBUNBBBq4Lg8R9jvA1p2051gH
 Jtq7nsynmiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThnwAKCRAFnS7L/zaE
 w4/WD/4hgXQX2CSj/PnOZODDHnT6Q80RgU+fJzQ+FnT+fJXkgjxpy6MXvm21TuAboGFwGrZupza
 9Vk7rAIcG4P1wb96wFHFQkbF+hYoYaMldGMV3zRdObffQgZK7Z3ZUkZoAkLU8q8U8LjGnGSaR1g
 KP4n1EWkH6CMar358JbT3NP781GXxlUxl4lgqlulMJZp6b9Kt+0W4pRtZvCzlDUP06p63W3pL5C
 2XejF+uAhdaGj2IcGhvB/tPsUfmxWQZX3I2qNLdIehPMkt4tBwTaWcvQSTOPD/3IIOixtzuO4A+
 oHZAmSP0RHRWw14tqZQkjxjkbC8Vi1StCibKANBELkTRxu+xyDELWC5wDENgq+u/TAkXjEwUNxb
 pQ1TLhJM+5FRqqDB2jJXdbZz6b2/qyxUDPZgzIuKDmN9+YDX0jRdn71ai9nT2q6K4cyw0j69Iwq
 2Mt4ydFuvKnpW7l3RW5+GPTkiQNQ5Vv4l+iAuO/Z1+yJx+YGQWWFRG5q+Y5mJUPslYyn6T9n5s9
 Y29vSuDdbRCeKwOvXopztBB2TMXk3ddWjVz2nvYg7LwNw2YZSpAffYEtmo40DIutQX7o5SMNUX6
 2KRuEJuMdGW/TkJA6Hs1aOckqLpgY1UdsFZ3E9Rsx5+BIpKbr6RtQlOespje+u2xmNsRyQQR54M
 AHNiypLa8FuVBRg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: yPpXzGm-TKRP7Fiqra_VXRcZrjEWLjAj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfXyyYLqwN+EpSe
 VhcqZ+ELj4QgWEcbiu+aLEB6OGLtjCrA1k++S5mKg5nkYN2TD3gbUSab4MMR9/Xyl9F7GTsBd4E
 ZZo/ObdOWcxgWg1P1mMxr/yHyN5O27o=
X-Authority-Analysis: v=2.4 cv=e6c2j6p/ c=1 sm=1 tr=0 ts=6a54e1cd cx=c_pps
 a=wURt19dY5n+H4uQbQt9s7g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=rzIBUVXPi645tD0pnwUA:9 a=QEXdDO2ut3YA:10
 a=-UhsvdU3ccFDOXFxFb4l:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX6ovrVLm5sYH/
 aSwY9ZCmXJEcxDh/ZpVyzlOMuz9dujOARvI8Ai/a2IB987GHTJMsOEImSHDV0eWgZBrnbJNJUEM
 ryyZGrf8xCGOA1jz4CTVCn5Z0AX6CZqENiyIGdwqZqD5SmuV1woUe3FKfTGrGH0gQ+sF5SSmeRn
 Lsrsh+K5g71TRhIu2b6+tRpNl4zw7gO2ixOGP+hwIKfDVXRYt7UTFDfAbQoexXgr2dQM8HjX4Eu
 J4db/GJysXHkWtS5aLK9RmAOr0epSwAeihcFSPjit96pjmqMQm692WdAbgZT+F0fJpSko0XMNvk
 6hkEtC4jKn28a3c7pE1ZyNnbide3lfc4QC4BsSsIhZeXN6gwH4Gq/yQgOWsBqe3nWLuvOyP8DTB
 DAocY4wsA0HRKdR9zaquMonui7pV7zozBR08yYAfmgoAgtlhc61Wrv47eCWEDEtYe0Efb4OVR79
 rGR36IkNFND47kOXvmA==
X-Proofpoint-GUID: yPpXzGm-TKRP7Fiqra_VXRcZrjEWLjAj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Switch to devm_kmalloc() and devm_dma_alloc_chan() in
devm_qce_dma_request(). This allows us to drop two labels and shrink the
function.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index d60efb5c26d88f8b0259b1dccc8724d0f75571c6..26347e9fc078adede712722107e74958538accdf 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -12,49 +12,34 @@
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
 
-static void qce_dma_release(void *data)
+static void qce_dma_terminate(void *data)
 {
 	struct qce_dma_data *dma = data;
 
 	dmaengine_terminate_sync(dma->txchan);
 	dmaengine_terminate_sync(dma->rxchan);
-	dma_release_channel(dma->txchan);
-	dma_release_channel(dma->rxchan);
-	kfree(dma->result_buf);
 }
 
 int devm_qce_dma_request(struct qce_device *qce)
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

