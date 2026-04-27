Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37BB3B38A2
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281378; cv=none; b=WciYJ84ptz328csJ7ZsfsKoigVQUasH0UUAMdJCrrcdDqmwP1+SP3aHC9UK86tZCkMqeNFTF5OrnGoczcBdI2YUM0hnEe5DnRk5L+TAij3zRYvX7+zvYbnvIJ9A+Sx25OtuCOI++YWzlohVE0Pd/cn8zycnF/cLMSGbyZcbfgNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281378; c=relaxed/simple;
	bh=H6RGZzI1m6Hy642I73fornlozWd6x9hkPKo2H6raYsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eWUJqZANe0CzHaWFoHS0eFu66h6T3nr1g0o8pt2jjgwOz1Y7HTbnVmL6hsgjd43FbSl2irl2HKhRBg0/94NFGEfe8Ga/XukSrMWA3FZm8jgRLSEcVhnYaT8mk9SUEsKlzxNxaWPDLX63jGifyf5/Vg8XOf/vP2N3GBakS/nPvvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cqjECPOQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bRvrOR/u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cqjECPOQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bRvrOR/u"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R8TBG72793121
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=; b=cqjECPOQBhgp/xal
	uuHwTLcClDvcuPKjvo4pdqq3w4WLLXHo+18z2NvIlf5MahPhuSE/gacEw2ZSJQRR
	6gdhKiDFOdkqIehtZunjo3pHI0oDXyQMqjmZ/e927XPUVSNPkMCU7Fzxr3ufnqe2
	jFcM7hL3QtHlbvT91hKKBKkHGWu0SZ/PAtKG43B/NW6V4EaSiIjhkqzf0nCXesfK
	Wb4UDUvt7xV7xk5ML+lkbQ5P87apMMg/NksrNyJX9KsUEZJ+9nwpYzkLkXQ1skAP
	/KPodTh3wDjVnAJz3P38Pd4i601f+gVeKtx803pwf9IDx7/61nJ/bnRzUUgJdFTI
	uT2p6w==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dsa4uudj8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:16 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50e2592ea3bso104888141cf.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777281375; x=1777886175; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=bRvrOR/uQFKPPdX36qoRYg/j+FDzcs4am8e033i/uVRwhlwPpPtJBszEQ2mFOm1Xli
         U08fd1SmNsa8KWcA06XAyvOlk056J6HCHoLhrIPXys2qRsq3PWyawRTwg1RcxMt2VKCf
         NDlj5WuKUxoIN0GSv8XAylkt+qU5BBgazC7Nz/bcQ7YPsWv2bEaCM9Bx6EFok9FwRKbJ
         pH5ZzCO7l7RDrkmn+ebokAGYktovCCIl0n939Hez2rhgXS+fPJt+KeNjlDDJ/3J9zr3H
         OagQ3ZUTR6jrWeRUniSrtYUAYqX/LRblM5a91QgWSTAd7gl5RTzTDMlj0MPqFnFribYI
         hvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777281375; x=1777886175;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DQ9O/WxlrEXbsvKUWZga3GBiGSWqxH7TMX/h6DSnlY8=;
        b=ejTyeICriiF6MXvE7eA6V7V47AjL9z3QIRWt/sOFgaraSvIo+EflsC0B4dTo4HariN
         L+ZnlKywml0TvpTIeX2YH3k3AqjaqTsFO2fPH2rW7ZgLJyunRKOB0jJxPSPAuq/JfnFj
         WWDe0AD4aybwcWu58fCU+dOajUd+MeNMCpeeUspXiiF0ob0aU1lQB0cFXF5RtcCJYIIr
         1JSNDNcbbH/LzqjtowEjZSn9ZPzyGjclRzEORXsQjqGNL3pXbgcciGTyQY8mZtuIffwu
         Q+Bau/Dp7Jp0o8tW6FZiashuHYKGMnDDoxmehL2yp+9F5ZzoZLam3g3/RaPYSkn6hnNv
         T8gQ==
X-Forwarded-Encrypted: i=1; AFNElJ9SHnQKjMI3PxZirMdSvhco6Sp+Ot7nKJXOTPgiW1eWZLpZb9tcXp9Cum/IeDdDyoVMTtKpWgo/fUyOwf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEiaBoIh9oQ3P8LM4kT2+xtKN73UM7DE1o1BQSbMvCjog228tm
	0LpErzDet80o3Cz+6tore9SUBM4pGWAp4baVAvdnyq+pIyzbIQ6QM6gayVMvzboSi2C36/koOV3
	hyK7vYIiuALW8/vCgtzzUsaaoK7pyqKh/GObHfzpIh0Hz/MYEz6te3wlOE54L00ajk9Q=
X-Gm-Gg: AeBDiesmtaYA7w7Y4we6R+q6bdfGd0JfMuO0fXQ8/et0hovUi2biGDqsplL9Z1LSQfo
	4Idojv6GXiJ/b3rdqR2MDwHKE8JIRHZkPe6iSA+vvJkU5JdS73ZRkGxei6i6EAaO0COn+LBPT52
	ryfAsR5we876DnCiT/ATlsjad8AeJUfjF2EJD7soafMjWKRD8W3AcxU0WLOdZn2DwkE+pYHhkMR
	tuKxlA3MDEVRm/+qBnRl6D6yQfXXNWMunNOZGx6jFhVFa1QupUIsZYLfsx5n5vbIn+kePSDjGpa
	SgY0+lSsXbPV/qmRKnCV7Efur8mC431W58jU/zFvZ6yd1A+vdTp7ijzC1rRZ7lYa0Sm98Up6tTI
	QYMIyhkw1f1wsjsj5yRaoHoYsoozsDyZ5T+vlqoliUzEbEr+nSm3Vu8PWCpAlvA==
X-Received: by 2002:ac8:5f4e:0:b0:50b:5056:fcc4 with SMTP id d75a77b69052e-50e367fe796mr649757621cf.4.1777281375218;
        Mon, 27 Apr 2026 02:16:15 -0700 (PDT)
X-Received: by 2002:ac8:5f4e:0:b0:50b:5056:fcc4 with SMTP id d75a77b69052e-50e367fe796mr649757311cf.4.1777281374731;
        Mon, 27 Apr 2026 02:16:14 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5062:ae86:23aa:702c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a6dbfd4b5sm40559365e9.28.2026.04.27.02.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:16:13 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 11:15:41 +0200
Subject: [PATCH v16 08/12] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-qcom-qce-cmd-descr-v16-8-945fd1cafbbc@oss.qualcomm.com>
References: <20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc@oss.qualcomm.com>
In-Reply-To: <20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBp7ylEQkBhfE2gADseHBpneI75TXF7a2W4RqCZO
 UVezU0cEJuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCae8pRAAKCRAFnS7L/zaE
 w+ITEACxbn5lhWiDiA22lakYAcGbPiPdloTEg9NsX4hB7+zQweJ2BKQ44w1ptY3J/fkSyYhHE1b
 VDD+3mq4jShPWTj29HhzHhHaRone/BLUmgfswv+pvMD2jnyX1VeAbb3y+uUSRVIAWHqXjTZgEAg
 QAqnzxUyHtIhVJrz/q59A2176m8ZxsXboa3p2aiEO1HKQJOlGa+McDuNpz2nIcb4pt2OmjKugZq
 MNBkXuCcrWp6ApU0KTSgzn+1qhrfb/xT5eNfFdK4cHvTSC5TowMB+v4XftQ0Ph+pK9ajt2udYDN
 dBkWaoivuAAfj7rakf9E14msoeLGihUWaYlqhZemDplPDWyF72i9TcxVIdItOGSbVi9CkIjpHeh
 fkqV92BSQjGTQ+SX+geWnA6JTdLq6zj0ndO1vjkpOzlL2jcWRFkaMFkFfOQwht2uP+Z5T9SmsHV
 pL7SIoheRcKEnrZyzLJwH2OPKbOVsegVUSPBX6lEbonu9Tfd3f7VHjcdkN5lSR+MSedxi+O34kI
 CfIiqO3ueachpEuE8Qomk7U5gd0gKhpwm4+imM2xbYz+7ef/YPSc1prbh9GWZ9KjzLBGgzJDbOa
 isAJmwUL+2/o2d/01i/76RMn7M2ZxG4iEw+3tzW9/hD62Hf3LzA1RDUSyttDTAH56g/sUe08dD6
 +edq9r4HES1frQg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: wJd18-sP-wR-_WCd_nNHE-3sbBvdT6rL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5OCBTYWx0ZWRfXyLR5WAXc+CBQ
 BmVhK6/ziCw47r9OvriIK8bcIQTbwsU316bywdKoNAEdfqqampg/5CRzNoww3ba1McN4sa/EOUE
 SI7xYcOEtq81kCBwJuV2K0cXFyNM+s4muvmkm7ahkhhPGSuRe7+q6LdmxF5YX6lwMWJPFNHtIdh
 zNwqy+1rdail/ScRbSbLE4auCE1yW6oK6wMpj5Yb/IzyFTMOoDQnoKe5NNA85mooIIQMvSPRL2S
 U9huSTguZZwhnegbke+3qstUKYVr1rr9KnBpBDjb2U+i7IL9cMvufwPTxQXkk04P6sGVPgR8vOV
 AU2aZKtO7fYvriCYnvebB+y62f3Xq+nhczJT3HT+EtTD8T6p0/m51LncLyRXdj/jh7ASGh+IHmo
 MZ3hGZeF+DrLBWEzXWaW4Xs4My/Q9B3PYSwlggDUIURf3mTqr5JGF217h66AEePJxyAOmHRvflO
 ngtnI+0ogHbSr3DpG1w==
X-Proofpoint-ORIG-GUID: wJd18-sP-wR-_WCd_nNHE-3sbBvdT6rL
X-Authority-Analysis: v=2.4 cv=J/GaKgnS c=1 sm=1 tr=0 ts=69ef2960 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=KrkfD191a8oFwBap4LAA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270098

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

