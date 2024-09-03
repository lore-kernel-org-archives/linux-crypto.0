Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129391EC00F
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 21:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398574; cv=none; b=kyz6nkfi6Fc+ut76CI1sEMbw2tVktPgXH/ZnLVrmSF+GEiusmBIhHCE1KgFZxKlrva6uJtBcQ5qlQFfAOiNo5fnlu2GYq1reRhXoaK1W8fqULW1BPGas1+dr2XMZ9/0ihS54Tm6gxvkH3GxorEZXq90jE++xjHb3fICOOCD7u2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398574; c=relaxed/simple;
	bh=8P1Jum47rGgM7FDX62HMOHw91bamdwad0+5M/vSm+X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=YTWAXcDBVOpjsEz95kAXxQRUfzDNfpnwtkdVX7wuKEd/oMt/yp1B7eaHKU5pGBgabEP+JDJnPEkG9mO0gFbX0W/uN/btxG4r/YvtkPEGOx2LP3wvXrNc8Hk7/D5Fnyi7MwRjKz64SZHCgtv5WufoT1DsIqDj5H9Wfg/jcNKhrmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U640d6iX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U640d6iX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725398571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8BQfqOVIo0s9x5Bh8x8Xi9+zxZ5VGhm3NLe1eX0SoQ=;
	b=U640d6iXbRZbI42cUA81k+AhotHl6t835KYw8r2TuY8aQKYFrN3u3dkwEYkhdisZOVJdGb
	O86/ING9HdXSDaepBrYNlRFwCsRZw4rtlCSDCdgsTsDlurZchU7tMBH46SShFx6AGaNKAE
	FnMcl0u//dYOdIGv8VLMl+eNPj4RXyw=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-8_3bMAhoOf6CLTSR4__J9w-1; Tue, 03 Sep 2024 17:22:50 -0400
X-MC-Unique: 8_3bMAhoOf6CLTSR4__J9w-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2700478ee09so6616286fac.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 14:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725398569; x=1726003369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8BQfqOVIo0s9x5Bh8x8Xi9+zxZ5VGhm3NLe1eX0SoQ=;
        b=YHp6DRkfNA4GhBCJb3F0vJgi8rLS9a1C4Q6eUoezp6QMG421FF356CMUL/bhVk7VAe
         8U5mORLk5s4znpw1uHvpO08RlJhbK2e2uu5itkXbIaJuh9o7TUj5Ej0wQKzRSnbxObmg
         mr4WtUCRuWoohHZaT1NsjVBPVTQfOzE2zcF+uJImRuvwK2GTVU9cqHJ3zQg+DlQ8FOja
         aBnK8GjZWe54kIlzuheeu7Zqm14R3ToWbr9xwRCh6VFHD7AdEG7M+uuo0wBfenicoy0e
         3Y0WO5RRH5qUBB+zmxTUgx9eS5BSYVuOBRRakDBWmbgoHdHGTyqVPmWDLIaW9TlIMiM+
         XmvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXc4h5P0tPcaOCUmyq/rc4SVOfXSLz3REsIR45DIM5c9/dtiGPOgGd+7gJJraY0/l5k3Ce0C6xaxYCblzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYm4Rwb/H0sHbS68J3PgL86uB2oBzzR1p9O9XTBCjo/ussh6TI
	mOt/yT0OHPb/IveZc/IKn423CCbKugdammfB/lcraCo5GLSdSzmPEa8J9YBPtBaf5ZRt0Zs/tQx
	mbmQowGhJPxuMAH8S8vH2hOSaOt6j6jBqogev4P6riYd8tMiLkohprxhQtaUZNg==
X-Received: by 2002:a05:6870:ab13:b0:261:648:ddc5 with SMTP id 586e51a60fabf-277d0440313mr13448321fac.22.1725398569449;
        Tue, 03 Sep 2024 14:22:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkeRLWZ/sDG45fCql0Gm6F6kVH9oaiaaJPzDMm1J3AN0Z6MSDkiIcKaR6kgJxb0RqGP1wSkQ==
X-Received: by 2002:a05:6870:ab13:b0:261:648:ddc5 with SMTP id 586e51a60fabf-277d0440313mr13448302fac.22.1725398569071;
        Tue, 03 Sep 2024 14:22:49 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806bfb8c9sm564737185a.25.2024.09.03.14.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 14:22:47 -0700 (PDT)
From: Brian Masney <bmasney@redhat.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	quic_omprsing@quicinc.com,
	neil.armstrong@linaro.org,
	quic_bjorande@quicinc.com,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ernesto.mnd.fernandez@gmail.com,
	quic_jhugo@quicinc.com
Subject: [PATCH v2 2/2] crypto: qcom-rng: rename *_of_data to *_match_data
Date: Tue,  3 Sep 2024 17:22:20 -0400
Message-ID: <20240903212230.707376-3-bmasney@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240903212230.707376-1-bmasney@redhat.com>
References: <20240903212230.707376-1-bmasney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

The qcom-rng driver supports both ACPI and device tree based systems.
Let's rename all instances of *_of_data to *_match_data so that it's
not implied that this driver only supports device tree.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 drivers/crypto/qcom-rng.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 7ba978f0ce8b..f630962469c8 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -36,14 +36,14 @@ struct qcom_rng {
 	void __iomem *base;
 	struct clk *clk;
 	struct hwrng hwrng;
-	struct qcom_rng_of_data *of_data;
+	struct qcom_rng_match_data *match_data;
 };
 
 struct qcom_rng_ctx {
 	struct qcom_rng *rng;
 };
 
-struct qcom_rng_of_data {
+struct qcom_rng_match_data {
 	bool skip_init;
 	bool hwrng_support;
 };
@@ -155,7 +155,7 @@ static int qcom_rng_init(struct crypto_tfm *tfm)
 
 	ctx->rng = qcom_rng_dev;
 
-	if (!ctx->rng->of_data->skip_init)
+	if (!ctx->rng->match_data->skip_init)
 		return qcom_rng_enable(ctx->rng);
 
 	return 0;
@@ -176,17 +176,17 @@ static struct rng_alg qcom_rng_alg = {
 	}
 };
 
-static struct qcom_rng_of_data qcom_prng_of_data = {
+static struct qcom_rng_match_data qcom_prng_match_data = {
 	.skip_init = false,
 	.hwrng_support = false,
 };
 
-static struct qcom_rng_of_data qcom_prng_ee_of_data = {
+static struct qcom_rng_match_data qcom_prng_ee_match_data = {
 	.skip_init = true,
 	.hwrng_support = false,
 };
 
-static struct qcom_rng_of_data qcom_trng_of_data = {
+static struct qcom_rng_match_data qcom_trng_match_data = {
 	.skip_init = true,
 	.hwrng_support = true,
 };
@@ -212,9 +212,10 @@ static int qcom_rng_probe(struct platform_device *pdev)
 		return PTR_ERR(rng->clk);
 
 	if (has_acpi_companion(&pdev->dev))
-		rng->of_data = &qcom_prng_ee_of_data;
+		rng->match_data = &qcom_prng_ee_match_data;
 	else
-		rng->of_data = (struct qcom_rng_of_data *)of_device_get_match_data(&pdev->dev);
+		rng->match_data =
+			(struct qcom_rng_match_data *)of_device_get_match_data(&pdev->dev);
 
 	qcom_rng_dev = rng;
 	ret = crypto_register_rng(&qcom_rng_alg);
@@ -224,7 +225,7 @@ static int qcom_rng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (rng->of_data->hwrng_support) {
+	if (rng->match_data->hwrng_support) {
 		rng->hwrng.name = "qcom_hwrng";
 		rng->hwrng.read = qcom_hwrng_read;
 		rng->hwrng.quality = QCOM_TRNG_QUALITY;
@@ -256,9 +257,9 @@ static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
 MODULE_DEVICE_TABLE(acpi, qcom_rng_acpi_match);
 
 static const struct of_device_id __maybe_unused qcom_rng_of_match[] = {
-	{ .compatible = "qcom,prng", .data = &qcom_prng_of_data },
-	{ .compatible = "qcom,prng-ee", .data = &qcom_prng_ee_of_data },
-	{ .compatible = "qcom,trng", .data = &qcom_trng_of_data },
+	{ .compatible = "qcom,prng", .data = &qcom_prng_match_data },
+	{ .compatible = "qcom,prng-ee", .data = &qcom_prng_ee_match_data },
+	{ .compatible = "qcom,trng", .data = &qcom_trng_match_data },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qcom_rng_of_match);
-- 
2.46.0

