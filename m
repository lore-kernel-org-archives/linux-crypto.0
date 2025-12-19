Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E224A30BBBF
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766138929; cv=none; b=DBt2wXcL646570N32SRgPjaFtCy0Rc/pXay1eKt32NAdtdDXM5NpE4SFwnv2bKmsNWI41oNHND7LJDZkDxEBsGLQFp/NPd8Hv8e37tn5OTu2w1zpD3ZUzKmvYLHot2NeyAvSvCfFjgHIq+rEBwQdfdui+vrYYipNHnd/rGwLtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766138929; c=relaxed/simple;
	bh=QM2z+7P7ypm7OsbyfBTGFqeOeedQidkSlzTZMZ4IyvA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tmp40tGG2CTHjxUAmasNJvBa/Rs3jUObTiob2HrFdnb9v5ce7fnQbjyhLy+0AiRVyWs+n/XlwiWo/wBw/8j9MK1iAGdIbxnNcxwbvSJbjJo0XYRIzU5vGnO8tpCfz8QCkevtxhD9/mar73nY3JgDfCvaAuKl1+yBmPfQLYa3uOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pUExwoiE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Uc/J497X; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pUExwoiE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Uc/J497X"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ4cbYK3701008
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yZXlSGJ53TEnlagigyR+xAHdi8h1i1t2YWtBsPCJvP4=; b=pUExwoiE6LZaciuu
	/c8DIluhML27vKhaKNjEFVEzoHKneqzX+M9AS52V9aGZC10BhMzSW606Id+Ydh3p
	B0yxjHPY3hSXSLfdkIXBfd/TwMqbkaQ3F4Vey31vJZTMu9a3CPHfq0lWzCWPV0py
	9t7BqORy+NdSw2ZGVq6N0EAXI415MY0UKbrQEbeFW4VWPweC7JLRNxM+snLGzZi+
	etoB/OBSsPHQddEJ8oJldXyevOlWb5zPQRbXetqp5STtjvp1qcVPq5i4etno0kAZ
	Kg6lYO7egL6SEavGZc7X/xc8lydWs3c1v3Tk1ASXK7OV4yeHpNfd7VL34KDbFfD2
	aY/X7w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b4r2ej702-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:45 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4eff973c491so35652051cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 02:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766138925; x=1766743725; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZXlSGJ53TEnlagigyR+xAHdi8h1i1t2YWtBsPCJvP4=;
        b=Uc/J497X658MFOUdEKXB1BFHP+3mlmyczgf30Juw0tOBhqsGa+NohpBQuZlJi/arxt
         On2UIx4J8cldodbKtoA1G5jUsno8m8VNiRfj695gy+Ok818T0VBpVqBEBm+lmrdch/Hh
         jwTKfGhT68UgfL6CQEquAhhcfyswBjf3FCR7YBKdIfAbCdph7pfJNztPOVFA7EfGuq54
         qrWSKMV5JuvWlH9WcHyIjSpf5ap0fV7Dfcp/FldasG9B2kaQc2moSVTdsRL/7iqqG+ke
         EsVKweM5pItIm0HGMiLK1FFfdx0xiwebVZZwPZGgLCczbrraLzLhFZYT1lHdY0RDgKZD
         eQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766138925; x=1766743725;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yZXlSGJ53TEnlagigyR+xAHdi8h1i1t2YWtBsPCJvP4=;
        b=kEb0cHl6wZFHmc5QYK3By36cdEfJ77+k+G+8FsnWyOzmTmPUZrWxY91bA6mozuHfXV
         XuDJaJ9LV4MiA72piK6oXy/zdlH6e4zxuzu7lvITsxvp22wa7LJzCNnbBOemre7XS8aQ
         CTbHUkBe9OS4bZBujrHLcxzge01iAfi3nGMswb56Jg+tmOxruP5cxNdm34L3bEdDANUZ
         45QWP9j4oC1TUWxnwjCMjeQZzbqRAcl/ysiLo/hejSwvHvpUpCkZNW38DA+rBnbB3pzT
         Ef6AKmVEC6K8s74g9kwQFOpGJZcWOuaYIdJIW+W9/vfNJ/FJPBLdOUPJaqHKX1FC5fDS
         ReLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwQpGrRSl5moUgdvPlXXZ4gaS2jzKZwU5YiUaiZeDjv8gm/Vu8I9JxIOT6+8yHhv7UBWpqo1w05fDiJSI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ9eVkELcsbCjeRipxVYvkPh8iiL14ghd4ZVEXShkNzMkVxatn
	geFpHIv6bDjehMI10Y/593lEqUBfxLR7ZddtKA2V98WNRUS2jko26vCOdVq2DZfxmAIHn0eWBw2
	aB8CbNgLbzzjxJeursi6i0MaO9iX5W5UzJOWDSxFfrjhTk1Yevd+5KYq+/bqXwcwGG7s=
X-Gm-Gg: AY/fxX6I/8sqWl63TBnifqTJ6GcNNtwOyyRaGSHPaXe8x6tVHoPE/s0yAIQBZj5+DSG
	2In8pmgy5KYD5EOtAJvxEqRcNDLM+TMD71Zq8gX8OpYjLE/uCfelOK9oEBdnTx7CfgpC3SReWBK
	2RvhnLkerD/lsXjT8JMhv0S62WtBJW7f+IQ3t0eKeApFqjFEXqF+wPFyquGS3Kxe2w7ik86niwI
	hi5tY45wIEEkVpyqIYhAkBtVe1yhVXC0Tb126NOA0EjZTgSlksB4MIzQYX6K+uMfd4OqNKT5so1
	h7j1gt54kWxVSrzNN9A2oBs5fCDVv+n7iMaGYAqLsGtQlitA+zagr6Ml2ROY6KXmXbjrYdLgcVD
	jKMKb3cA+LyC5cX/wGnONsd2FL1pu2m/VCOyF7g==
X-Received: by 2002:ac8:5d02:0:b0:4eb:a3fe:53d with SMTP id d75a77b69052e-4f4abdebbabmr32656211cf.79.1766138925020;
        Fri, 19 Dec 2025 02:08:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRSYwi68MaHD+ZMEiNdl6UXip8p2Dv9OXoVME8W02x6tt42vsvpPJMh/z/5JyciN6mdXbdzA==
X-Received: by 2002:ac8:5d02:0:b0:4eb:a3fe:53d with SMTP id d75a77b69052e-4f4abdebbabmr32655821cf.79.1766138924417;
        Fri, 19 Dec 2025 02:08:44 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:a48:678b:dad2:b2eb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82f6asm4209571f8f.27.2025.12.19.02.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:08:43 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 19 Dec 2025 11:07:51 +0100
Subject: [PATCH v10 12/12] crypto: qce - Switch to using BAM DMA for crypto
 I/O
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-qcom-qce-cmd-descr-v10-12-ff7e4bf7dad4@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6248;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=BIqN1MwUXu99xIB35sQJm42dbVeoM9dbY833xkX2UwU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpRSQXHuAQ03YygRGIANeHKr5lCjUWeSFXgaRXU
 xlvey/zmj+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaUUkFwAKCRAFnS7L/zaE
 w1MND/40ibAWNIT7I8UnW04fzGsZADiSZIkdk/gOX6PzP3fZImjpK8b/HLpFrTF9OMjVObwDp8g
 B17ybSrBu7YHV4TT4NXWnSa1OoD+xI1XVj/yLMa4bZKvWacR5AEl0Il/3F1ztSRK2gev2EFX/Pm
 5noPKLcyAuQ+g//aj0mRWmmIQ72nfsilJ6NbotYqG08sqnMLCbz84BCo7OECfghSC/kL2c9yx3v
 poSDM6HUykymzIIaU0yAUjtg4Diw/PENlSjXtgADHdUS91Wxe6bm+WWpDQ9LRQfZ9HozLiDS+xW
 aDT27DrzhKzNK4W7HOEnhMnnI57jBnFzwEMsYIWyUUnViulSogJwT8tAvBz0u/fWS2aopobHn1U
 Yv+50R01ovPOt9kT2Ocr4kyKAkjseS7Zp6JAz/fgwT6bFv8lc6ry9XM/hJyqwZkxmG+Ft9Fte4C
 V2lTNOODZI7J7GRBo6VBTolvg5pupcoGoe2BJqNvOmvuv5Esg+JhYDul2r1jpxGMnup+t1nMhZ8
 pZrTOift+TMKys7V2YRtJKt+zMEyydjaN2uzwbxXL3jA+y2vGqAUcmcUPnVFxOIFAym3NZGy+75
 sLQA+QKBd/D2YQiT8VjaWxBtZx0MX0YMsUCx6SKcMCwDhDEfl2a13NcfQh/XH3XsOCAe1CU9MAV
 +PdPN/j6ZffteRA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: cwoQ6_UeRbTImcGBY7coPSUxFeXZOgXE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA4MyBTYWx0ZWRfX6g93pxPuVZtx
 ni8nKcwpK1vRxzLvoQ3hgJBxKqsXKXTCGZnqJDDnVU+3HP2GVpKTfb95HMmcGWC3fzukf/Ave/l
 Ynhw/tGLcfiGfLb/4HX37JJrKpAZvkny2vxlNyUo///w1mriCP3AvH5jiCuIs9l0I4kJSv/3TIj
 LcxxEkS2b14DNPlZgiAmUnhz3VwCVAsFfGzMTq+fo0di1luTixaHupTi+pQnXVnYaCjsBzSNSzY
 orMZY3n14x6POTek7MvaUnOemwsBGZjTG4w8jTw0W3nb06nUYTg+NVpmHx4SKAlhPZ8VF0qJddL
 VL4b6ABGyT5mvpBgtSaKDXN3P/BAf5/qSRGReR+q4tO9QIqmr8qHo43nfdgNY8KI1uyGrf+TrxP
 CU4Nfx/F+2PQoAvGppCPREkb5C3yyTZopvHXGqrSwM8p7Pz0vJo5AfzxZpHaMm70XTPFvxZH4Pk
 eMXdSUsbUQul7RViCHg==
X-Proofpoint-ORIG-GUID: cwoQ6_UeRbTImcGBY7coPSUxFeXZOgXE
X-Authority-Analysis: v=2.4 cv=EabFgfmC c=1 sm=1 tr=0 ts=6945242d cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=a5mZHpruE0tutGEvsiIA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011
 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512190083

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

With everything else in place, we can now switch to actually using the
BAM DMA for register I/O with DMA engine locking.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c     | 10 ++++++++++
 drivers/crypto/qce/common.c   | 21 ++++++++++-----------
 drivers/crypto/qce/sha.c      |  8 ++++++++
 drivers/crypto/qce/skcipher.c |  7 +++++++
 4 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 11cec08544c912e562bf4b33d9a409f0e69a0ada..0fc69b019929342e14d3af8e24d7629ab171bc60 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -63,6 +63,10 @@ static void qce_aead_done(void *data)
 		sg_free_table(&rctx->dst_tbl);
 	}
 
+	error = qce_bam_unlock(qce);
+	if (error)
+		dev_err(qce->dev, "aead: failed to unlock the BAM\n");
+
 	error = qce_check_status(qce, &status);
 	if (error < 0 && (error != -EBADMSG))
 		dev_err(qce->dev, "aead operation error (%x)\n", status);
@@ -188,6 +192,8 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct qce_aead_reqctx *rctx = aead_request_ctx_dma(req);
 	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
 	unsigned int assoclen = rctx->assoclen;
 	unsigned int adata_header_len, cryptlen, totallen;
 	gfp_t gfp;
@@ -200,6 +206,10 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 		cryptlen = rctx->cryptlen;
 	totallen = cryptlen + req->assoclen;
 
+	ret = qce_bam_lock(qce);
+	if (ret)
+		return ret;
+
 	/* Get the msg */
 	msg_sg = scatterwalk_ffwd(__sg, req->src, req->assoclen);
 
diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 292fb3c7bbd3d6f096bbdc3c66d37d11e9ea109a..84d6d49a56378a84d2e54f35bbe69ce24ff8fe3e 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -14,6 +14,7 @@
 #include "cipher.h"
 #include "common.h"
 #include "core.h"
+#include "dma.h"
 #include "regs-v5.h"
 #include "sha.h"
 #include "aead.h"
@@ -25,7 +26,7 @@ static inline u32 qce_read(struct qce_device *qce, u32 offset)
 
 static inline void qce_write(struct qce_device *qce, u32 offset, u32 val)
 {
-	writel(val, qce->base + offset);
+	qce_write_dma(qce, offset, val);
 }
 
 static inline void qce_write_array(struct qce_device *qce, u32 offset,
@@ -82,6 +83,8 @@ static void qce_setup_config(struct qce_device *qce)
 {
 	u32 config;
 
+	qce_clear_bam_transaction(qce);
+
 	/* get big endianness */
 	config = qce_config_reg(qce, 0);
 
@@ -90,12 +93,14 @@ static void qce_setup_config(struct qce_device *qce)
 	qce_write(qce, REG_CONFIG, config);
 }
 
-static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
+static int qce_crypto_go(struct qce_device *qce, bool result_dump)
 {
 	if (result_dump)
 		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
 	else
 		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
+
+	return qce_submit_cmd_desc(qce);
 }
 
 #if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
@@ -223,9 +228,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce, true);
-
-	return 0;
+	return qce_crypto_go(qce, true);
 }
 #endif
 
@@ -386,9 +389,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce, true);
-
-	return 0;
+	return qce_crypto_go(qce, true);
 }
 #endif
 
@@ -535,9 +536,7 @@ static int qce_setup_regs_aead(struct crypto_async_request *async_req)
 	qce_write(qce, REG_CONFIG, config);
 
 	/* Start the process */
-	qce_crypto_go(qce, !IS_CCM(flags));
-
-	return 0;
+	return qce_crypto_go(qce, !IS_CCM(flags));
 }
 #endif
 
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 0c7aab711b7b8434d5f89ab4565ef4123fc5322e..286477a3001248e745d79b209aebb6ed6bf11f62 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -60,6 +60,10 @@ static void qce_ahash_done(void *data)
 	rctx->byte_count[0] = cpu_to_be32(result->auth_byte_count[0]);
 	rctx->byte_count[1] = cpu_to_be32(result->auth_byte_count[1]);
 
+	error = qce_bam_unlock(qce);
+	if (error)
+		dev_err(qce->dev, "ahash: failed to unlock the BAM\n");
+
 	error = qce_check_status(qce, &status);
 	if (error < 0)
 		dev_dbg(qce->dev, "ahash operation error (%x)\n", status);
@@ -90,6 +94,10 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		rctx->authklen = AES_KEYSIZE_128;
 	}
 
+	ret = qce_bam_lock(qce);
+	if (ret)
+		return ret;
+
 	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (rctx->src_nents < 0) {
 		dev_err(qce->dev, "Invalid numbers of src SG.\n");
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index cab796cd7e43c548a49df468b2dde84942c5bd87..8317c79fb9c2b209884187d65655d04c580e9cde 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -51,6 +51,9 @@ static void qce_skcipher_done(void *data)
 	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 
 	sg_free_table(&rctx->dst_tbl);
+	error = qce_bam_unlock(qce);
+	if (error)
+		dev_err(qce->dev, "skcipher: failed to unlock the BAM\n");
 
 	error = qce_check_status(qce, &status);
 	if (error < 0)
@@ -78,6 +81,10 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	rctx->ivsize = crypto_skcipher_ivsize(skcipher);
 	rctx->cryptlen = req->cryptlen;
 
+	ret = qce_bam_lock(qce);
+	if (ret)
+		return ret;
+
 	diff_dst = (req->src != req->dst) ? true : false;
 	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;

-- 
2.47.3

