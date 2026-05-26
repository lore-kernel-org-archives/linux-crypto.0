Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811823FFAA6
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801112; cv=none; b=ckUW1k5Jhisq6y4ojis0L2b1mwhoULc2usJi6KIW7T96M38ZjKeOd5qHLDp7QuhR2NdofPh9dKGygQ9nFizhULwM3P9m3kvZsb5F7GH420AqsdxpZNJsBdOGtck0cMBUVRDDuczMxBomb99BXjNbiVhRq0Nxfq8UPbT4EasPLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801112; c=relaxed/simple;
	bh=KsfN95W6j4/1rnBl5r726uQErsmtW0rsSb3wOOAaxR4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EhiMpAM7HMJVHuxpR5GTgY8k2js3eS9GqI77j+LTdlNV5ppBgqXduR7zOGD9Vkk5qIW+tjf8ZrWj+PB4nJonIKaszYk6JkyAF8x/XiKf7Si/biXzthZLpVTPSFFAGyMOwzwt/oBSXDyokWbA+SwOrjL1nnA5h4m3Zldw85PHKOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FGAs4CcP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GLbiuVG1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FGAs4CcP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GLbiuVG1"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsaHO1575513
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XgdDvfLKvypSdiaTXvswqXHAdJrtzA0MdP5FnHmYrfg=; b=FGAs4CcPgPzPlAKo
	RKOEOeYpcJOPnipypoVvgloELjue46b+AB/2E0+/p8YlQtq+A/4usloHVrmDbvRS
	P1mc94a4nlW8eLbeAQWGmmtyfLGk99RjayBUtCJl3EhObjTs4ShvN9zj/gt7112v
	g2zSoMLHfM/jGEhXbJAfeYuBZ/4hbvyFGZJ3vgnhnuj6oCVq/wnq3W1n9unpNMmD
	Nmrt4HXsuv9NSC4A6sKknKCJii9aKF54kQOP+yeEo1E6fpqxlVdcc2zUVi9DGXH1
	VJw8Mxs8P3LNgSBjxezwL0/TmFene3kCMzfd5ECLZwAl6odwY878RCYaG4aK3K+I
	ETV/Yw==
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecqvwv4n9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:47 +0000 (GMT)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-69d7fee2b39so2949791eaf.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801107; x=1780405907; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XgdDvfLKvypSdiaTXvswqXHAdJrtzA0MdP5FnHmYrfg=;
        b=GLbiuVG1s//yXNdoHnNh7NqMxqDo5b4Thwl8O44sGabGyGb1DqAcTUoq8e4sxM/Jj8
         Cn+/56wlYF6cGzh6hE+vQEq7yYsotX1V29dflHenj8wzj52mWpAmWx2CBajxSlCVAfLq
         om9jSPP/wkfbR12PmDomu7ZDMFA3t6767ITWcT4Pu3mQhMGcsc9F0fAM3j43R+hrhrCF
         8T//qPMGnP7DTzGY7FiGrqttgp/82UoVZCGaJlKhGWRYAmI0T5dkUOXKwjKPt/n6ucFZ
         4h4BCp3RcA0Sz0R+T1yRbzhbDiguLk6yzKyYHC8Y5sOgoKPiMImkbAkVvnKuOgjx4ijr
         Y6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801107; x=1780405907;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XgdDvfLKvypSdiaTXvswqXHAdJrtzA0MdP5FnHmYrfg=;
        b=H6TPEj+BDRJMfpMvmRCpZURSIeBFs2CzaXFsSEIR+8TDfnSfr9Y4+AMnWXwy2L6jD+
         5RRLsajsRAywh74hyIdG8qaEiB0fOPHA47hggmHa+2zzkwcX46ClTAizOowfW3sGrxRi
         rPFVsR+peF0yrX8EQ+xQBaptUv+qgAU2M6wqqYh7DBjrl3NKKb0bFZuJWIhEGPg4zFDO
         2VhLG0OIDNbMuP2AFLHm3MORY3YUnNmaoC7oJDfX1BFmNxe2yYC82XLRdDn/235YFW74
         Azml2nkGf8MT0Tsobefs1xF6LyXrZq1Ai8MegVjBfjJgJ4agDAeyHDSBlF9QASSTQZdT
         Id1A==
X-Forwarded-Encrypted: i=1; AFNElJ/vD4c0VsXvvCe0jH8bJx3+jCH0xU4Fevposnl1M7vJtPGj/0lYw5JmShIqlfigs7oezj9UwO9AEqfXLdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCi4/6mF0MU9Zee+Qv6VhO4y/vUAQTSlhJhxA+/x98PFT0s2CL
	5lwqGC4zLFAMbZQs+C04BVPI20UF5mzWZTEhnQzCFqPVEjNPwaTiHpLHRwTANkrIfF8+v9ig7r3
	MCfYX3UBH/Dqv6nDFfpppU48HDld0QabcDaGUrcotzE6pQ+jhXRUcmJ9VE50VtABJHoQ=
X-Gm-Gg: Acq92OG0qzpWrEuBxoHBReif7lMih7tLPyEaQsDtIZp7O7dMRNjKlgFLtBJvOWjHqJY
	GwpvP61PB/zL4iOWLCSMIF5ZmNRAQwyoVh1tPMY6KNEwVeGVull5wOmeZZNuwNpAnkTvaR0I5UF
	tMXAF3grQ2U1wRM2eYQQWys5NtGgVwVrPfXK7f4vqxOppD9wUFvrFYyppEUf2JESkQvYnX3muXY
	9vCkYXaxTzpg07iDPy5bOcZLW7wgeUAx/D0oFVR+jPUcan9E284Jl68rxu+t0Qp2EPqYDKF+NRZ
	cJ4HYj9UQ7JEaBvZz7qv7p9xJSZYO9XpalmeiazQozGTuPib9j7hWb9VfF+kArUczrBr/rDer0w
	t76HvLXCD33kIFve4jBlBgacKwjtMOqXSvZc81gzV/O542OfrsRM=
X-Received: by 2002:a05:6820:824:b0:69b:8c61:796c with SMTP id 006d021491bc7-69d7ecb7ad2mr10004737eaf.42.1779801106133;
        Tue, 26 May 2026 06:11:46 -0700 (PDT)
X-Received: by 2002:a05:6820:824:b0:69b:8c61:796c with SMTP id 006d021491bc7-69d7ecb7ad2mr10004669eaf.42.1779801104832;
        Tue, 26 May 2026 06:11:44 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:44 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:11:01 +0200
Subject: [PATCH v19 13/14] crypto: qce - Add BAM DMA support for crypto
 register I/O
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-13-08472fdcbf4a@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=11802;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=qaZCt19iP288u9GtfZMb8uAiX3X6Ab2pi2SafoSwN8A=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvzD1oBPzRAXakw+q1Fs7rc55AYAhWb1b/Ca
 sUWRIGVbfuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb8wAKCRAFnS7L/zaE
 wxedD/9S265ah5ADNRC3gx4dK187YLec9CGoaeV6dJOlWNhGE8O5Do6jy5vgCssP2cZ7B3+hCFD
 2G23MVr3To3PEicFFoO0tElX2wvsZPiGRtCLONrSyFoZkOPt9iYivdkbkqSPc4E0lXEXJ1X2Mle
 WiB6pv1/VEZZ6pmzftXx8oyseKWP2ka5076KO1DVGXZ+mLhDC9v8IbjGAE04zWntFoAxW26O3mj
 0JrI263gwldk7wDrkod1jpJ6sG/MPgFrlzRgI0qT9hQwqnL6yF/xIir5Y7Z9uvTnBxpXPfmaKgl
 uKISI2Qr7N2zEO9lQPbefx6v5l8Z/F8IXLmq1GKg13Z093fCKvYKf1rjXNsBhjtsGGH51AceZk0
 CqHLxJhtkAGNDJ6XM7aRzI2wjVh3W/jlXXj1IqzT/UVaSbr9y0mRc+vKBUMwB/dFgSRzn3Kx2w/
 +WvBJ0Mv8oaCYNlyqt9oTbQBu1cx9vBtBlNq3ATObG4GQPAa7kpjQaJX7lXhWpQ7xWCYKODT5nn
 XGP0gy4sK9p+yVpgL6jcVevcAs2dmCbc/Q3QgJI9ddQncLWj1aqMJ5QbLXnkjO10o9UQ/2AamKQ
 DeidvTzDJZmuY+6OnmryXbwEdEcuNMY1sM3yhK9G7+y9OE5LffNRxzc499t2W3REwArhH3n8QZk
 kFt5YHVwI4KWbJw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: DOBHMyUSqec_rKensKZk7rB-i0tL0qlW
X-Proofpoint-GUID: DOBHMyUSqec_rKensKZk7rB-i0tL0qlW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfX9IHFqT/s2XGN
 8joOGgN+6ZwdZuuDp0mAyd3VsTLLStCqi1RM1n9+eyhwtJUsI/yLC9kilDqQaNfktJMix1t6jwN
 TFaTwJedfu81EGNgkbG6uS2+iACEGdM4anYYJFZULSZkSNdaTyJSi5VsEshUBhTRGv1gqKmZzNB
 ucWDfLxTj1fk0zVwg/a9Up31aGkS5eADItIP3LgKsoZWcO60V7JsFessAEUX6o0iplJezrhy8lH
 lGVLAWTEzAlnZC9K2+RJEZKeNnFsriq7n5emfizaqa5MEdDrfvgN1l28fHLBPJBOecYfow3eE0p
 hlmnEggDhHGZ+5GtlydvugRc88bmbMoMhpty4FpBnjGXsv0b3lfCHgzpw7+YAq3J+AzIdynd/PH
 29oxVICrGLcAgCUYPB/cPQNeEiM3bBaF6t/7x7TlcMkAT1nGOm5zgOfDDQm4EABH2ZCIDsJ4s76
 1w2vP/eWrzTal3qJUNQ==
X-Authority-Analysis: v=2.4 cv=M4l97Sws c=1 sm=1 tr=0 ts=6a159c13 cx=c_pps
 a=wURt19dY5n+H4uQbQt9s7g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=oAuzKfsFwOPfSl_VwCQA:9 a=QEXdDO2ut3YA:10
 a=-UhsvdU3ccFDOXFxFb4l:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605260114

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Switch to using BAM DMA for register I/O in addition to passing data. To
that end: provide the necessary infrastructure in the driver, modify the
ordering of operations as required and replace all direct register writes
with wrappers queueing DMA command descriptors.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c     |  10 ++--
 drivers/crypto/qce/common.c   |  20 ++++---
 drivers/crypto/qce/dma.c      | 120 ++++++++++++++++++++++++++++++++++++++++--
 drivers/crypto/qce/dma.h      |   5 ++
 drivers/crypto/qce/sha.c      |  10 ++--
 drivers/crypto/qce/skcipher.c |  10 ++--
 6 files changed, 144 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 03b8042da9a1b4aebdc775ad8ab912abc7b2383d..e271ecbcbb4a33c405fbec85c458cf1daa7e2c55 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -463,17 +463,17 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 			src_nents = dst_nents - 1;
 	}
 
-	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, src_nents, rctx->dst_sg, dst_nents,
-			       qce_aead_done, async_req);
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
 	if (ret)
 		goto error_unmap_src;
 
-	qce_dma_issue_pending(&qce->dma);
-
-	ret = qce_start(async_req, tmpl->crypto_alg_type);
+	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, src_nents, rctx->dst_sg, dst_nents,
+			       qce_aead_done, async_req);
 	if (ret)
 		goto error_terminate;
 
+	qce_dma_issue_pending(&qce->dma);
+
 	return 0;
 
 error_terminate:
diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 54a78a57f63028f01870a3edeb8e390f523bb190..37bb6f03244d317a887aeb0aa10cefe327b4ce05 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -25,7 +25,7 @@ static inline u32 qce_read(struct qce_device *qce, u32 offset)
 
 static inline void qce_write(struct qce_device *qce, u32 offset, u32 val)
 {
-	writel(val, qce->base + offset);
+	qce_write_dma(qce, offset, val);
 }
 
 static inline void qce_write_array(struct qce_device *qce, u32 offset,
@@ -82,6 +82,8 @@ static void qce_setup_config(struct qce_device *qce)
 {
 	u32 config;
 
+	qce_clear_bam_transaction(qce);
+
 	/* get big endianness */
 	config = qce_config_reg(qce, 0);
 
@@ -90,12 +92,14 @@ static void qce_setup_config(struct qce_device *qce)
 	qce_write(qce, REG_CONFIG, config);
 }
 
-static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
+static inline int qce_crypto_go(struct qce_device *qce, bool result_dump)
 {
 	if (result_dump)
 		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
 	else
 		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
+
+	return qce_submit_cmd_desc(qce);
 }
 
 #if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
@@ -223,9 +227,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce, true);
-
-	return 0;
+	return qce_crypto_go(qce, true);
 }
 #endif
 
@@ -386,9 +388,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce, true);
-
-	return 0;
+	return qce_crypto_go(qce, true);
 }
 #endif
 
@@ -535,9 +535,7 @@ static int qce_setup_regs_aead(struct crypto_async_request *async_req)
 	qce_write(qce, REG_CONFIG, config);
 
 	/* Start the process */
-	qce_crypto_go(qce, !IS_CCM(flags));
-
-	return 0;
+	return qce_crypto_go(qce, !IS_CCM(flags));
 }
 #endif
 
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index c2602d35baa6ad3ca5de734de7ff6160ff29567c..769cc71da90076be446cbdf7ec7db27f628fa2ac 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -4,6 +4,8 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma/qcom_bam_dma.h>
+#include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <crypto/scatterwalk.h>
 
@@ -11,6 +13,96 @@
 #include "dma.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
+#define QCE_BAM_CMD_SGL_SIZE		128
+#define QCE_BAM_CMD_ELEMENT_SIZE	128
+
+struct qce_desc_info {
+	struct dma_async_tx_descriptor *dma_desc;
+	enum dma_data_direction dir;
+};
+
+struct qce_bam_transaction {
+	struct bam_cmd_element bam_ce[QCE_BAM_CMD_ELEMENT_SIZE];
+	struct scatterlist wr_sgl[QCE_BAM_CMD_SGL_SIZE];
+	struct qce_desc_info *desc;
+	u32 bam_ce_idx;
+	u32 pre_bam_ce_idx;
+	u32 wr_sgl_cnt;
+};
+
+void qce_clear_bam_transaction(struct qce_device *qce)
+{
+	struct qce_bam_transaction *bam_txn = qce->dma.bam_txn;
+
+	bam_txn->bam_ce_idx = 0;
+	bam_txn->wr_sgl_cnt = 0;
+	bam_txn->pre_bam_ce_idx = 0;
+}
+
+int qce_submit_cmd_desc(struct qce_device *qce)
+{
+	struct qce_desc_info *qce_desc = qce->dma.bam_txn->desc;
+	struct qce_bam_transaction *bam_txn = qce->dma.bam_txn;
+	struct dma_async_tx_descriptor *dma_desc;
+	struct dma_chan *chan = qce->dma.rxchan;
+	unsigned long attrs = DMA_PREP_CMD;
+	dma_cookie_t cookie;
+	unsigned int mapped;
+	int ret;
+
+	mapped = dma_map_sg(qce->dev, bam_txn->wr_sgl, bam_txn->wr_sgl_cnt, DMA_TO_DEVICE);
+	if (!mapped)
+		return -ENOMEM;
+
+	dma_desc = dmaengine_prep_slave_sg(chan, bam_txn->wr_sgl, mapped, DMA_MEM_TO_DEV, attrs);
+	if (!dma_desc) {
+		ret = -ENOMEM;
+		goto err_unmap_sg;
+	}
+
+	qce_desc->dma_desc = dma_desc;
+	cookie = dmaengine_submit(qce_desc->dma_desc);
+
+	ret = dma_submit_error(cookie);
+	if (ret)
+		goto err_unmap_sg;
+
+	return 0;
+
+err_unmap_sg:
+	dma_unmap_sg(qce->dev, bam_txn->wr_sgl, bam_txn->wr_sgl_cnt, DMA_TO_DEVICE);
+	return ret;
+}
+
+static void qce_prep_dma_cmd_desc(struct qce_device *qce, struct qce_dma_data *dma,
+				  unsigned int addr, void *buf)
+{
+	struct qce_bam_transaction *bam_txn = dma->bam_txn;
+	struct bam_cmd_element *bam_ce_buf;
+	int bam_ce_size, cnt, idx;
+
+	idx = bam_txn->bam_ce_idx;
+	bam_ce_buf = &bam_txn->bam_ce[idx];
+	bam_prep_ce_le32(bam_ce_buf, addr, BAM_WRITE_COMMAND, *((__le32 *)buf));
+
+	bam_ce_buf = &bam_txn->bam_ce[bam_txn->pre_bam_ce_idx];
+	bam_txn->bam_ce_idx++;
+	bam_ce_size = (bam_txn->bam_ce_idx - bam_txn->pre_bam_ce_idx) * sizeof(*bam_ce_buf);
+
+	cnt = bam_txn->wr_sgl_cnt;
+
+	sg_set_buf(&bam_txn->wr_sgl[cnt], bam_ce_buf, bam_ce_size);
+
+	++bam_txn->wr_sgl_cnt;
+	bam_txn->pre_bam_ce_idx = bam_txn->bam_ce_idx;
+}
+
+void qce_write_dma(struct qce_device *qce, unsigned int offset, u32 val)
+{
+	unsigned int reg_addr = ((unsigned int)(qce->base_phys) + offset);
+
+	qce_prep_dma_cmd_desc(qce, &qce->dma, reg_addr, &val);
+}
 
 static void qce_dma_terminate(void *data)
 {
@@ -42,6 +134,16 @@ int devm_qce_dma_request(struct qce_device *qce)
 		return dev_err_probe(dev, PTR_ERR(dma->rxchan),
 				     "Failed to get RX DMA channel\n");
 
+	dma->bam_txn = devm_kzalloc(dev, sizeof(*dma->bam_txn), GFP_KERNEL);
+	if (!dma->bam_txn)
+		return -ENOMEM;
+
+	dma->bam_txn->desc = devm_kzalloc(dev, sizeof(*dma->bam_txn->desc), GFP_KERNEL);
+	if (!dma->bam_txn->desc)
+		return -ENOMEM;
+
+	sg_init_table(dma->bam_txn->wr_sgl, QCE_BAM_CMD_SGL_SIZE);
+
 	return devm_add_action_or_reset(dev, qce_dma_terminate, dma);
 }
 
@@ -101,28 +203,36 @@ int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *rx_sg,
 {
 	struct dma_chan *rxchan = dma->rxchan;
 	struct dma_chan *txchan = dma->txchan;
-	unsigned long flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
+	unsigned long txflags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
+	unsigned long rxflags = txflags | DMA_PREP_FENCE;
 	int ret;
 
-	ret = qce_dma_prep_sg(rxchan, rx_sg, rx_nents, flags, DMA_MEM_TO_DEV,
+	ret = qce_dma_prep_sg(rxchan, rx_sg, rx_nents, rxflags, DMA_MEM_TO_DEV,
 			     NULL, NULL);
 	if (ret)
 		return ret;
 
-	return qce_dma_prep_sg(txchan, tx_sg, tx_nents, flags, DMA_DEV_TO_MEM,
+	return qce_dma_prep_sg(txchan, tx_sg, tx_nents, txflags, DMA_DEV_TO_MEM,
 			       cb, cb_param);
 }
 
 void qce_dma_issue_pending(struct qce_dma_data *dma)
 {
-	dma_async_issue_pending(dma->rxchan);
 	dma_async_issue_pending(dma->txchan);
+	dma_async_issue_pending(dma->rxchan);
 }
 
 int qce_dma_terminate_all(struct qce_dma_data *dma)
 {
+	struct qce_device *qce = container_of(dma, struct qce_device, dma);
+	struct qce_bam_transaction *bam_txn = dma->bam_txn;
 	int ret;
 
 	ret = dmaengine_terminate_all(dma->rxchan);
-	return ret ?: dmaengine_terminate_all(dma->txchan);
+	if (ret)
+		return ret;
+
+	dma_unmap_sg(qce->dev, bam_txn->wr_sgl, bam_txn->wr_sgl_cnt, DMA_TO_DEVICE);
+
+	return dmaengine_terminate_all(dma->txchan);
 }
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index 483789d9fa98e79d1283de8297bf2fc2a773f3a7..f05dfa9e6b25bd60e32f45079a8bc7e6a4cf81f9 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -8,6 +8,7 @@
 
 #include <linux/dmaengine.h>
 
+struct qce_bam_transaction;
 struct qce_device;
 
 /* maximum data transfer block size between BAM and CE */
@@ -32,6 +33,7 @@ struct qce_dma_data {
 	struct dma_chan *txchan;
 	struct dma_chan *rxchan;
 	struct qce_result_dump *result_buf;
+	struct qce_bam_transaction *bam_txn;
 };
 
 int devm_qce_dma_request(struct qce_device *qce);
@@ -43,5 +45,8 @@ int qce_dma_terminate_all(struct qce_dma_data *dma);
 struct scatterlist *
 qce_sgtable_add(struct sg_table *sgt, struct scatterlist *sg_add,
 		unsigned int max_len);
+void qce_write_dma(struct qce_device *qce, unsigned int offset, u32 val);
+int qce_submit_cmd_desc(struct qce_device *qce);
+void qce_clear_bam_transaction(struct qce_device *qce);
 
 #endif /* _DMA_H_ */
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index a3a1a205aaf8559a04809936e2a3b7d564c16c53..5be82b345753f49202797852cec09dbc7f0a1e03 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -109,17 +109,17 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		goto error_unmap_src;
 	}
 
-	ret = qce_dma_prep_sgs(&qce->dma, req->src, rctx->src_nents,
-			       &rctx->result_sg, 1, qce_ahash_done, async_req);
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
 	if (ret)
 		goto error_unmap_dst;
 
-	qce_dma_issue_pending(&qce->dma);
-
-	ret = qce_start(async_req, tmpl->crypto_alg_type);
+	ret = qce_dma_prep_sgs(&qce->dma, req->src, rctx->src_nents,
+			       &rctx->result_sg, 1, qce_ahash_done, async_req);
 	if (ret)
 		goto error_terminate;
 
+	qce_dma_issue_pending(&qce->dma);
+
 	return 0;
 
 error_terminate:
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 1fef315a7105c869e7fc6a60719087b721e78bb3..6535336a2c57c39db94999011890b8bdad5c58c2 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -142,18 +142,18 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 		src_nents = dst_nents - 1;
 	}
 
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
+	if (ret)
+		goto error_unmap_src;
+
 	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, src_nents,
 			       rctx->dst_sg, dst_nents,
 			       qce_skcipher_done, async_req);
 	if (ret)
-		goto error_unmap_src;
+		goto error_terminate;
 
 	qce_dma_issue_pending(&qce->dma);
 
-	ret = qce_start(async_req, tmpl->crypto_alg_type);
-	if (ret)
-		goto error_terminate;
-
 	return 0;
 
 error_terminate:

-- 
2.47.3

