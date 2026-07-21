Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5025F374A0E
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640849; cv=none; b=jVnN9Dqt2tDvYD1qjx3gKDDr5WrmAKhMu9iVXQik+jlhfPaJAl2Lanw3J62iAKr4lFNpNzRclEHaTiWHN51rpOioxygm6xN29vqwmCtsXWl90p1VxFJI9KtrMlBCiNUsseTB6xPhnpGNJbj/wrnTYUaKQcHSbusHvJwH9WdCphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640849; c=relaxed/simple;
	bh=/3Q5BLE2qswUURgRMp8Md6+CmS+GMHS0PuiKEz36BBw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LqucAznNsMGfkhncCcih6pMdq20MK4qL5KS0dJtrSP5V9MAX6gec01x9mR0iGV654n0WwiJHcZijmRB+rebaUO7EvlIukzKX0UNJJJXw/q1RrGilLYg8JUzUKl3mPMlPxDuoJVFfV0/xLNQWHsrHDck6Alk2DTRBc9CUxyHP1A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AHr51DXm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GgYNign0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AHr51DXm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GgYNign0"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDM0PK2914600
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=; b=AHr51DXmH92LdgDJ
	vSMOYYLczG0FFQ0NjXnA/4JDJTMZSVsyWOW495MKpgznsL69QKzz4YXIif8XvGoT
	5EYvkVNukEV39P/L+9Z+tWK9szMiqWZdrUYAKI0Myzp3XsdmB8DHyA26igDrfo+x
	EPWHoTIJII5KdrWCzOdjGOcjybgi+fPLj/FVZ/1nxIYWhnXVBfZJNVUxyU7GMiPz
	3vqJxsLQzm2AtyjSEP1Mh9S0PazImUMsvyi5HoF6ylgDSuOPHXM1qJikQD6bBnA8
	qxUcnQHlpcHQRLopiw9iFtQZucuiMzom/qi0IF3Te8ADCMv7VbXLAZAq1+bbQmHE
	FzTWqg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6nss0e6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:34:07 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c20762d21so109823881cf.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 06:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784640846; x=1785245646; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=GgYNign0KwDPT3KW8fLkqW01e6ALnqagOfwxNLyDAkde6xEPkP79wEj2aTrOTWKJBV
         kRWBX2Io+kaMRmXefKbYxeUo76f4mB7jVDez3t/2kYArgwjY3KSvhsmIF81WS7H62YkK
         EIylCOQ3eWqot6lYMucmuykTCOJduXZraI8BLFfnstiXU2v981rBhMkAm7SnKkHJ/gGu
         1B2CP6GQGvttAFJPp4L/GmWsATWrTIJHfF+3Txfq9QVHgB+t3ZRgtbeAaitW28NSnVcn
         SqEbvgWKPWfED4wnxXUJeOoubitE25Y0r8JVd93ZqPbBKo4AZndjI2PGaaH29ma5bb67
         KmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784640846; x=1785245646;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=K7hUQhPgGbLHTJ0qfywuu4r3wkOE1TZc0NECwnRQSlX+pXYVHTJHBRjOy/wsBosbJF
         nFjHfGxvjTLUnWFheftotviu8P6ozfrB3cnnl981iMHTNoT/QFHqlDTR8PzvAoZ8ZTvq
         prqLscaLWplk64CcEn8XBK7G+GLysjd9KEig0v5q/BO0/wXQS4JIxHgZKIkcpF36rVXk
         YLHfHqy9hVZdA0tqYZoDkY+OigARi+uBrbspOAFhXmUNlWbmVJ1THwyiABAHMfT9ilTK
         BdEPYmFko+TIubvejfUXj2zbYXQ+Lb6Ie4gBS+z7Q1G10LzcZbl2zdVTzuJoxBcW2LGE
         7qCg==
X-Forwarded-Encrypted: i=1; AHgh+RrYZzLcRh+TWxNo++7RkICWrnZBSQNRmsYTiiOXw1+ZqzHJxDSX0zraa/IKrHCTHaoJRAZdycZuKSsJHv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgpNOymdTRFYuOmDvtnn6eVNZRM/nHeBmWmiZWgmur8Kjudu4Y
	77qnVSuu9FPXWWbV7x1pjj86ttgtr5UCcbImammFsRAc3l26y2H0b/3VVWkREdOvaYSx93xGMnS
	zdUZYE2HsGP3OcWYuQ1RVP5q2RX9dGU/f91Tkx6oA4Wj0mlODueHmC7viSknJcK5XsoQ=
X-Gm-Gg: AfdE7cnujqZ7+nj7mrgMjKDHwqqbvA+e/Fde8BAXrzp9GRJ4XK6GcsSrHsB9RxtE2ZI
	BHbI97h3cSkmu7peiqhF7Xap8PIP4gvAxudnlyYFbCRhbLjRE1dVqzVJ5MbQa9fYjmd5TkaP7Br
	bLZXjQLphf/XMXz6V65cuR+joxl26zJqzEpfBdTB9HdRFEuoe2la1XSVK3vNkiy04x9F0cXepYd
	JxPkt8FWiSqj1hMqhEONfymTjOdwJrIQM9V2Gbkm5iwqEkD2V16cuWH9Ke9HqHXyyfHz7rojWSr
	+sP1jcLzVQo+IMcRI6AMv6zKfT3CZjW0YGQaxbxPUx2EnBXnVlMz802pbkASme//5+KLKTHCSAB
	62jk/TM8yK46v92feckj+tvaub4Ipvg==
X-Received: by 2002:ac8:5a02:0:b0:517:9c91:6246 with SMTP id d75a77b69052e-5213e48b0c5mr166430921cf.44.1784640846260;
        Tue, 21 Jul 2026 06:34:06 -0700 (PDT)
X-Received: by 2002:ac8:5a02:0:b0:517:9c91:6246 with SMTP id d75a77b69052e-5213e48b0c5mr166430361cf.44.1784640845627;
        Tue, 21 Jul 2026 06:34:05 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:9dcf:9ab8:bffb:ec35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495499d1d4asm237901185e9.2.2026.07.21.06.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 06:34:04 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 15:33:15 +0200
Subject: [PATCH v23 10/14] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-qcom-qce-cmd-descr-v23-10-1be02deffda9@oss.qualcomm.com>
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
In-Reply-To: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqX3Um0Szp2FQ/7u08UOOwXOEmTqCbPyKy+Kk7h
 zt1sPJWfrWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCal91JgAKCRAFnS7L/zaE
 wxU2EAC6rmyDxMJm9Nysia5rt+6YD50durxhSSEqb88XkqKCqwBnIvnxJUQfv3jffZs4kAZ6iWa
 AK2fzd7WqrsO9s3/O3b36spfUWvx7gYTCURbeYFoKZBzsxPhstjpiIKpFSUdVM4nc5K5xjXAMzM
 acl41vgFyHzZ9/FnuZf5NnzVCIetrEVzDJIpc4TAD9IbhQje9sVW4foZ6fmW5tUXU08SzNC9q1Y
 ldq5xCkipfUygTnJ7os18ArHSgVMJGYii09Fw3g3hoO1cpZLRWK9TMGJrn5khm8M2zB5JgTlkfg
 zYhOLQPSJA05iJQM0CBfio2N4VRI1RP87cD6zGaI9fJ3EQeqnBI3hcTmBe9QB31cCsDabWAgBwi
 +Hz+DBeEwF2MWq/GqQQzHe/cooYkaKzeRlAwhebfrEHCHeM0v8g/7GR/uGKY7U9Zdp/Eoza1Jlz
 wiSmZzWZQD6WJ54nYEDUnU9Q7vldznRp9nIeNcmNg2lyd2C2ZOBw/Fpexa22zG5WGL1/0slL7lX
 xsAt7Oxg+kh/mc77N0tkHNuN5+Dz8Cb6Ek8tcBvzVwcrOU9awwcQoz/5BQ+6rc5xPxI8hNh2FC/
 QALORHjnJ4ZPKjnHiMBf00DHjK4ykiZxwjkOQJkFOFK00r+XjHlkim+AEO49dUX4JcB4/vlQnzA
 FgoDdF2SeyFaTcA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 3Mxaj3R1k8d881VWNc0XqeMPOLqSOMK4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfX2nVIPRhvqt+f
 qDGHd3XI4gltcLTnlvXgCbrmPcXh9xNXrPbhwjvknPf+mFHi67fbI1zd5GgJyim7HLPn8xF0hfL
 R+hm8sLGJNTJtm3DBzUeZX2YlyMm80s=
X-Authority-Analysis: v=2.4 cv=ZJjnX37b c=1 sm=1 tr=0 ts=6a5f754f cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lH6k5GM5CfRwGFUYfCYA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 3Mxaj3R1k8d881VWNc0XqeMPOLqSOMK4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfX89ooj/xzfEU3
 cgSo4F980WJ2crsr29oltdlXM1NIJMkfOpvRUoWi3xDstWSIVWUXzvplrzBhExurju3XXpP+2eD
 vee8f9ZWlY8wFT7s3lq14UFDsX057zXzfukaHjEO4yvHGpgzuCaDyf7pjgPHoIAYky4UcKoxiYc
 GI+cFGAE1tBIgHsCmCH0tsHAhzbfa3uiqpoPRzXwTSDomoCvFfDjjW1NSJ3X/D06xlgAxQe21ld
 o3DNOaVJnkSXb4KFHIfVz5GjBcYPbSJKTnhQrZv9OkIJFp6GgtFA0mRVeUJbC6LBqlfFQHAP1OY
 GATKRUyByjd2JshXYbIGjWhXFsJ+OGN2o4vpBatScYJ8h9oPt0Xguxr48Ojr32+qIMlvevDpa/Y
 VWAHTL0vbJSH88JREjbuhAIkN34inIo4uosEyXtZFIcDgqwpzI7uL29j8c/A2I24QCm6ZPuFbyl
 U8Ad1yCdq4p56flWiVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_02,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210144

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

