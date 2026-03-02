Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A93E421EF3
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467066; cv=none; b=OroatLizO29vhYakLO8fgPC/xhxVmyTeUJFzoUAXB882KZ7T028ybFntz9TlkY3Yr2zD/0Lg8OezuVpIMEmknCZHgL8gr3vBmS01KUfjKZ4VeEt6m/hOhz1QYKN31TW+LFweB9BDRtJv08P0D5yxpFOpFgfgD77U/CTO1NXZxi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467066; c=relaxed/simple;
	bh=H6RGZzI1m6Hy642I73fornlozWd6x9hkPKo2H6raYsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TmBKnPz9v8g0fnbbXyZFH97r62pLgzhO3TURVZjOdvOWQNGpdSw+e3TzFP2427rb9l0kw48Sj+55oeSd4sj0OT+2feUSLhoop/aBsYzR+wlTvrvqrEyVWXTpnYFTgwwFRgB+/v06sNzrnD1LpqQvMVVYBpONUwmQPJPTahwEliw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aQ6hsgyO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZB8WwlSu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aQ6hsgyO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZB8WwlSu"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622E5Bxu2358125
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 15:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=; b=aQ6hsgyOrwv/XjdN
	K6Cy1RvPnmTtr8oQNppm7QSEZF9mP1iAI3EE/3M4IRTINiC2ljQ1DugLmN5+A8EI
	f6D9yuyLC6kLqgbo8tUw7owiDL2E2wgdeIpGjG6gX2L2o7CKwaF9v5VOc6SwLRRE
	0KENO3c0sOQXBk/iI63PbC0L38Z+0TRsqwdXzhq6n0SRF2/tnk7c2CSPy+lPFseu
	aNIM671nmsTIEBp6Gx6W0IkAB/lWEjnWoCJt+eDcQyTOWPrfKdDLBsdqiqr3DAcG
	NnYiWmjjykkIZT7ccuroU8D/rC6/lor85rvxvfQiVJ9u2tEieZS92yK5coEANcqB
	sFJWPQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cmgbav2g4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 15:57:44 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-89546cbb998so430203956d6.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 07:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772467063; x=1773071863; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=ZB8WwlSuse7BiTXACl5UBM/OY1btuxvzp01Cc70gst60tDfIw/E/tpMG06lAETbfLt
         bm+RkMv5RIJrAYOmmGGdwv0uBUjjpPMC9VwVqukyG7LqVNury7WGhY4EyJXfWl10YHNc
         +zMnhswz0YrCHSvBlTWZ/tomtr1eJKZHJLUV5FnuwexFNGGrk20R6f2V51klENHMnVHS
         mawzgTuZDAvuytzdXGCo4ri3cH1rf5nvEEzZrSNxxSOU807W8HxiV0+CSvFdAfcxiAXs
         PndJGdDAzS70IkpO+Hoeqm5+7SBdeyYdEql94tbunTagXIDHPUNceN9U6ZKdzgaaTbx3
         NETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467063; x=1773071863;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=WBaDbID8OiOzRWYvaOuFeKDvK7rDjC6O8a1/Q7/7dpk6UfTkwUBtJxjTKk3VIQivyI
         7gE+/FlON0hJtQBmebAbVfaMINspOBAEQP81k9z7ySYdWLu8bD2J79s9HCPDPNiwi5bC
         gz95Z0sk2FxrBTVNPDphTeeVpeD9IK0oHTrXI2erNrwES4M0SjReiTbZfILJeITyRNMo
         yNKQXy58SRRaVp7vghxi4MobtZ4uqpPRcZ3qDkArolRb0V/HGsvin9r6Cn2H2S31g1cI
         v2Y0EeNq+e21hynspxaZJo1iC0zE2PJtCctDQLCGNkkMRPbRvKkoicOHichN7yFfhnxK
         WEYg==
X-Forwarded-Encrypted: i=1; AJvYcCXvu03mplJdZBVI8Dk9NLAN7/e+0JSYtMl3jltpFu9w3PVfdtg1kzOJ0YJdxr2V3sjXlfts8weTrusRofg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/KIGDhQ/rSBy0UQj8VKIk1HlvUpGoucV+JcvSL5Gj3YcIB8xf
	91DDx+6NcW2+QmC5nCGFKkuoc/SwdWvPuapwu+GzhpYMcVHcNTvMhEoYtuf6a3tKqanim/La1Uo
	UdigpPo2CMLi9zToTn+gEb/wTmM9vFcziXXCZKFEOPRDOLUbK9K0s6OQwCWigGp0jRgQ=
X-Gm-Gg: ATEYQzxZhXsU5+cAuyDj5PboTtIj3m/2m1vMj8PTDy+9P6WTmJVb6S+I69sq5uds5lQ
	Mu+icfzUyVcO17SDLEa7tt9tDqSOtUyzIl2Z+sA1Pah0oBFHPiMJgMyUtfswGyaZa6Llw1wLZ1D
	kNxYV/4v20VeuTK0dZAGZ1XpNz2QsqqawG3SCLzAh0+NGnFuWUS1pSxlPv34PuWrTDej+KOxwlS
	Grt+8U7vFgOLLy/HRiks8TmiPTSdOEgq/XWso0wBq2Teu4GrS89liy1FOAgpppXjwYBO69hXijq
	7gMcqsi6TnaoYNsapU3UUqch5fKK6beWlkPXsPty0tVggFXMlSeF/xKiD9v+sgq6japJzg7ifVA
	Z7TmTKB8pRiYGjDY+RkGill3aDIDAohuraPM2ZRSOAW9w31hmGvhU
X-Received: by 2002:a05:620a:4608:b0:8cb:4a3b:5e06 with SMTP id af79cd13be357-8cbc8e222c8mr1398997285a.67.1772467063392;
        Mon, 02 Mar 2026 07:57:43 -0800 (PST)
X-Received: by 2002:a05:620a:4608:b0:8cb:4a3b:5e06 with SMTP id af79cd13be357-8cbc8e222c8mr1398992885a.67.1772467062914;
        Mon, 02 Mar 2026 07:57:42 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:87af:7e67:1864:389d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b41831easm11282438f8f.12.2026.03.02.07.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:57:42 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:57:16 +0100
Subject: [PATCH RFC v11 03/12] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-qce-cmd-descr-v11-3-4bf1f5db4802@oss.qualcomm.com>
References: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
In-Reply-To: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBppbNlZG9LYSOKfu5TlTDseIe/TgDfGHUo+ed7K
 9LnJ2eJ032JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaaWzZQAKCRAFnS7L/zaE
 wxShEACbtCvIVVakGFfkdp+go+XnzCkQJ2cVC+uPIiyIvG8vB0m5MYzgjVEEQuizT5Om48orKFO
 Dv9WnyBpd4u5lsgJCcef3LjQuOconyGuIZwzF56VlNnrHG4gRO3FrUMYaEpvDd/avaUZWvXV5Jq
 tRpDzMLe8+l+UfkbS2WJ8xyxBRaR5kqUwrCvzGzjb1V+3BqQR0p+ccdNX7hYBOXsVj3MYawfvf8
 0jYdBwK7B+ilI9Fev2ZkM6IZ495svAEWmEAlqwGn7LprjASLX8pyDX0MJml5ATSMx7W0arufyZS
 3QWunDUcsbD2Jt5g1XYNoE+S0yNDQCs+dTkVP6k0V3+idx2VwhvRuACHCAr8zpO9Ek+VrXGDcUD
 yD1ogpHf7riRlIPLmlnpKYf/wBUgq0P9oGuO58bNfLOqBmGrPzT2IAD0wvaQJ0i6kFqAr91Ip1e
 fcb8YuYR7DSDS46UbMKlzsHe8tAXX8O9H92eJEFvanCA9MbsjYQEAHCI6w3WVOtqJsHzDUh2mjP
 Dx8iMe0vezyl9gWvaradWUGc7T53RoVja9XHFD1UkBh70E9ElXDi6Lub5Ng+JJDs9VRMXS5TbvB
 cpnKz/UMqM9mG/gESnL+YgDvpA8aZt5/UZC/+0AWonxkMHfKY/ixMu2BhEVAesKwHYlP3DO+he8
 4c8t2NdUEFvtphw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfXwWGGZL2F3s4s
 jU0la3u3/p6cKJaXKyfsozNdnl4PVt8HsWJDb57fKwIM6WsOMwFkdLNh+FnU6AHMK3AaP0SHhub
 jtKk9ClYbkjhidWQ8XZX6rKHqUX4iKS8teX9spCc+zn42cBf36pgtGIZRx0vaJf8RVMvIc5X5CG
 NEI2bozm7j4JgPSCNGILLShaPYksHEaJY5pmwIZpGtiI6TwbvH86ifC8dT7B+LcrCz34CaVfaK6
 rOrnJZGrU+DeUEMy9hnfSSuzSjeNV0/6fMLwfNKWm0uMIfRCGT4IHOCWSIbZCoxzq74Q174i7Qs
 mZAH7hkTSJILSc7caw5wPeiIe6IOumEEYlqlr9L68Dmq+yztoFbqh7zzn9dTV/rwCRCsNbIHlYc
 RgbdmSlOXU4ZvUWN9rB0AT0gWBa4dwFrpjpQaCrl8kaI/FXA2cLrvEK+RTnuzqFIDzPV4DbHlRW
 hgcV9CyGH4RFTVxUUMg==
X-Authority-Analysis: v=2.4 cv=QfVrf8bv c=1 sm=1 tr=0 ts=69a5b378 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=KrkfD191a8oFwBap4LAA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: eO46x3yKR0M8JU-g1yX6-Szm6ma8W2ZE
X-Proofpoint-GUID: eO46x3yKR0M8JU-g1yX6-Szm6ma8W2ZE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020133

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

