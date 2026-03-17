Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706853E867A
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756262; cv=none; b=FvyYHH8XlrdI2fyf8id+xFTmLjyedqpL49Qib8QlMMoGlw8cpEkOdMgm88FKwKeQwPE6B/9q9/lMOnVx5I5ZoEN2vhkEM2ceF0VbrDGeOJDAhm7PUI3EDi+jp9+nwmM9DGsD3CuM2hyME/GtWg2NHFwRXgMSkTqP3Xv9z6T27xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756262; c=relaxed/simple;
	bh=6dN4XjHr+6OQnOzxmGwMll0VZH7PW0q5aNlxk1E5+Hg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SlchY9mjH2zevGrRy9VwpSCptteAESzsAGT21pQD4R9e5ZUiyuw1/gDBRL2cb15YP/K9pWDvkvugBYzAe5psbtCCH5PFmDzEzRmX6R2U03THWgj5A9GN2GJvGx8MGPvW1Ysoyo8m+Z6SM5MbZOeQ4PT4VPzrd5/1mhr8l1F06rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=liKAUSj0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QgkhGuKI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="liKAUSj0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QgkhGuKI"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62HD4x5C668941
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=; b=liKAUSj0fGhwnrdz
	tyZen0SYblevWbWtazQX1DnMSZTXAhXUXUwWWOlmvS4oQBzMlB14rIHZVQE7sFrj
	hD2nrkDFohSZZxM/7a57YJMXtujybwEw6LDfEqSvKZ1GOnVd90Ig5F0/933LjkET
	pOGASoW9ZTP5O9ABV1rETkz2CLAsZiu+nrc1UXSRRucdW/ZE/Jop+EFVFukqYOs4
	3bno5WTqr8pgWVTsdXK6dgluusSOQjPVmkhqdUKoTkBNGRD3vX7L0bJPfKFHQ6/i
	X0J+sGY4k8kqKE/KEEu7NI/eANdT2GjWfS/XyxdGCApfLUTZy9CGW6q9s55QhwPj
	IxHpTQ==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy7he074q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:04:20 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-60276247301so445254137.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756260; x=1774361060; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=QgkhGuKIHrwAW7aC82Kv8uhMkoGrU7k9PWkyUnY9Sbst8EIbh0kD990MnElrYqRCnd
         89OVSVhNiiCO33bwtee8WTizRaKN6Me7F6vnOhoZljZtBA95ybSG0zh4E8ZRHJ4srylw
         KLhXWUYb/xGnJLt0NdHyWTYinstO8LRs/u9Q8+Q6fWC3uqb1s92xuWUzTIsN0+wXrC0a
         frk2ZiiG00ZOCq0kZivgxhUl3jJOD29F16dAnVK+W7kEiztCPrF/Gm9iP7ddvECE75we
         lw/wjrfIcWyZJZZoH/EvDEhm9RtRsMytiM77AdoMfMGVtpmI/6eb0+7ZPhM3jor47zT7
         JVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756260; x=1774361060;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=Wd6PTXWC7X36O1pvHZZXOEmAorsFk/1Y2bQX1/Ac8BmeNc7y+hyer5nTiG5V4R2o9g
         BewOE5rw/80Na2E6FOvUAuMwtOWoy1CZ+JDh33oL1EIhX7kKrEnCXCUYFWxsPecVqZMA
         a0GoHD8n5KT1t4nlmcdjKeeXYrNxz1AuRxP1z57Xnt6EMfo9OmSS06EEgKNwKAcIRIfA
         64o/X8DDxyjVRQTKI3uZh4MxLXPNnpchNm7misskNKAitLZKJKCe6W0DGGxzt0qKIhrB
         q8NimBFPaByzLak9dQI6YoIkNXouMDmoiJhalQnnmw1r8jf1Xkix7yuvEAX6ZhFSAxaF
         MTlA==
X-Forwarded-Encrypted: i=1; AJvYcCXTxIMzcIAprEMk+adUzlFTCCFc0dkPDFCEENjTsJ/7s257E1iW09e5wVgMtd0rcJ5mIb7OaGD6g+Yi9a4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAI/lCO7DonX80VRqB5OzArcsZXR6MX8KsprMk6JpJr0dVpXVi
	IdmVsjvhZwY1pbwrXpAG01wtCXuRO/DMPhxuEoD4WIA7VUf+9APr+US9uMhhPnbyv4WD/nEgk8t
	5IePWz64mPnN198flqmEUMkUAeIYHySe/x1tNLL562+i3uPtrhfl/lOpw29YhB26KfOA=
X-Gm-Gg: ATEYQzxEG6DSh7QVP2M6bhOpkC6Or3gZX3gILaqdFGQJAuETtIh8uajNYqo5GRLWnTJ
	WI/pfLV150CMcqRXlOMDYyyTt1uNEEur7PUjXg3Yv9DzYYV9tv2nKXE/u59ojPp5hNC/E/JP+sN
	pm0GVcirnNmsXYb+LkgS1sJdNX7ElWfxiL6a62d0SScEOTHFyXmSQuIbvzOna/6EHR/VN4C8LbL
	VdihnHAc1Mb8fQmIfS0baT3x5P6TYm4twEPoPG5W8QTD1eTvEltikg5GWgHGdBxKG0ed8nys0uw
	pxHF5oJocr38RvyTB0WIAyzXuHtUIhsvlyY9RWZOynM0/GYDaZin8QUKg8UZAvOc1YpfKO3l1mu
	FsPQ/aGu8JKwKOeC3/EZBd/zmMtmiRnbtbSLG9wqCGyqeRCmMgjr1
X-Received: by 2002:a05:6102:1626:b0:5ff:a34:6ce0 with SMTP id ada2fe7eead31-6020e220116mr6678600137.12.1773756216909;
        Tue, 17 Mar 2026 07:03:36 -0700 (PDT)
X-Received: by 2002:a05:6102:1626:b0:5ff:a34:6ce0 with SMTP id ada2fe7eead31-6020e220116mr6675040137.12.1773756174174;
        Tue, 17 Mar 2026 07:02:54 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:53 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:14 +0100
Subject: [PATCH v13 07/12] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-7-0968eb4f8c40@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2012;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=DfH5Bb+Cx5AadRW9+jaH1GcMtyO0VLpMWlVREcJBr7o=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV73iujZQ5OmYbLyGhNvpgHfkyjrM4PJIPIUX
 CAKWC4U0W+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable9wAKCRAFnS7L/zaE
 w+CkD/46HMPC12W0V4MTUjE7Rk/IgkkBeNhNdo/H3IAMjUsoEi7JvMB4HcgQgD97k+fm29N59JX
 aR46Vp6Z5XGMc8x4qg5SjywfxX/wosezI64FMejNfgWypWlunTqo4Q5EoEcGXQQV3Cn3G2KuReA
 GAkucWdzOyWNm+mhxJW+QTIazutS0Der71WjtfY3DJt7b2ts7IGKqINU+gmNOzUHMfS9tM9G+KG
 ENczoKR1rdTX+tUx5T6MaLirm5YOMZQhMJk5pV+pNjpTdV85MyPoL0n2WEpPaBCtMOzl6amLI8s
 1LmcSKvdKjwBfG4ckHRQGyMv/yi9m30GNWdno0b48+qBe5UG8krkd+c6BXvVP8qXDVEjmB8ljBi
 kjeJvZsANSff142+RajX+M+NnkFB6Feoj9lx6cBwB0EuQHwQF5NFWznzcQmlDvfTfHN1bNl9PfS
 lbSl7ygc2fBRQP0gIMvlrebG6YBL7SirsGgi/2cGmD8rchSa+wISYcGInFSPjQzPAoqkY8qoYc5
 YuVXBzHSRFd2yUJElUxCcgV14jGksbPVLzg2bqXHtNLeZHcjZuYM+b4nWAtNPGWp39XE2SnrYMn
 MIyilz4aIrmfIHg2KbiFLMGIB/yMrCDZ/YpJM2CXwlVynf74wjunpjLAONagl+SW+5JE296iY6I
 igYbF8oUxNjwwWw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 2OnFrmMrgb7z4W9Gt_iXXWyM6hQSgdNV
X-Proofpoint-ORIG-GUID: 2OnFrmMrgb7z4W9Gt_iXXWyM6hQSgdNV
X-Authority-Analysis: v=2.4 cv=QsVTHFyd c=1 sm=1 tr=0 ts=69b95f64 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfX9QrKEsz83QYs
 cHRW64vjR4nvpaJvkoAgjYNOkb5BGvURjEHX8iawpcSiciu5mIeJfXYpvENsE+d/6/3h2oCrgYd
 DNIxl5SnTF5zpsl4Hl1bFoyGbjlYolotjN6le9rlFgLLEr0qF7qs6jeeNf13+yPUVBMTowu5LNX
 FTh0OeFOLQUAgHcMcwQYPUcUgdUWX8RpEaxL65W0DGLGkFeJIHTm1lU00mpWn5SxhoD0YsVg7Jd
 9nU6BmHUKgwaSyQSa4qs0FSMR6/V5i5UALMPGL6O+xHfchJtJA53Hh7GrSaaaniYCMFv57fFfwz
 i3YsUBmk/el8wU0BymFUV7reLnKS0Z+uCYt8mNXfiV2KYTyL6pHVNNkh13+70KbUpNF5g2AMiDg
 tuqtLbHzsr5TDRc2cUn5bQuB+4/j/lnTF4yE1DjCB6F8gjbU3vFFVi4wdBsiwtn0PEZhvtYG+Tx
 KfPbEAVSa7WhuTz6MYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170124

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

It's unclear what the purpose of this field is. It has been here since
the initial commit but without any explanation. The driver works fine
without it. We still keep allocating more space in the result buffer, we
just don't need to store its address. While at it: move the
QCE_IGNORE_BUF_SZ definition into dma.c as it's not used outside of this
compilation unit.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 4 ++--
 drivers/crypto/qce/dma.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 68cafd4741ad3d91906d39e817fc7873b028d498..08bf3e8ec12433c1a8ee17003f3487e41b7329e4 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -9,6 +9,8 @@
 
 #include "dma.h"
 
+#define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
+
 static void qce_dma_release(void *data)
 {
 	struct qce_dma_data *dma = data;
@@ -41,8 +43,6 @@ int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
 		goto error_nomem;
 	}
 
-	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
-
 	return devm_add_action_or_reset(dev, qce_dma_release, dma);
 
 error_nomem:
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index 31629185000e12242fa07c2cc08b95fcbd5d4b8c..fc337c435cd14917bdfb99febcf9119275afdeba 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -23,7 +23,6 @@ struct qce_result_dump {
 	u32 status2;
 };
 
-#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
 #define QCE_RESULT_BUF_SZ	\
 		ALIGN(sizeof(struct qce_result_dump), QCE_BAM_BURST_SIZE)
 
@@ -31,7 +30,6 @@ struct qce_dma_data {
 	struct dma_chan *txchan;
 	struct dma_chan *rxchan;
 	struct qce_result_dump *result_buf;
-	void *ignore_buf;
 };
 
 int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma);

-- 
2.47.3

