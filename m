Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2B318E20
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 01:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894495; cv=none; b=fZD/l7ydBnvrNxfHrKKhftnQlIh+QR7e8hmi5d3n2krcuT1AheWckjWvDB7D/2uZrJ/DP6VDwBqlPLUMYY5BAqWv1C05A5JTb+GEdiFo1MvTkCMa+O5teeMWHrH4JZFM2NuTjK0DbNFctNwsKkozatblZ49XWAg5dkGFjD6aNdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894495; c=relaxed/simple;
	bh=pVIsjIwUVSuD9f5vpgG6Je4vWyRG4TASquy5YfmS7vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=R52eRCm7id5nkjAHHoHYYHv5SlTOb6o7QeZu/ijbbckLOZwNO+ivDauPJ/CLTUCRfcZKCdxJ/8NouhMLENjnY6LyLBAUhOAfGyb5OfFmy5HJfAjn44H0S4ivq1frFSEyp9Q/vIl2yEbVMGWjZbfEeTDUR/4nR/wtg9fv7kiwPTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U1XAPBih; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1XAPBih"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724894493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uPFXZeRskPV1LBySPC5AK+d7TuSi/RtTN6Kvr+xrijg=;
	b=U1XAPBihyi/jcsMsoqK2rPQxl5aOi/g6tsj6uKDmvdmzeHl+XymVEmR4IcA5jDwWZmGnnG
	EYtuFRjAfyJ5+iBBpwMOzW+OeZ8pi+G0pR6qD2Qv7HMUh57KRTDP6vdzBA5NXaN1axfqS5
	6wqm1mYJ7Fn2JzjRNUdR/Y72M/sdqZM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-LG2L7SdaM5Gq_mb8hS18XA-1; Wed, 28 Aug 2024 21:21:31 -0400
X-MC-Unique: LG2L7SdaM5Gq_mb8hS18XA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6bf7ad66ab7so26187676d6.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 18:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724894490; x=1725499290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uPFXZeRskPV1LBySPC5AK+d7TuSi/RtTN6Kvr+xrijg=;
        b=kr7YoE8zrOwQezWIojW8Ieu/JYWX7LLdWrn4a2MU/vx66WC0qC4JXZmhuaObd5acS+
         V8wLyuSwAZma4lU3Ry8PhIMgyD8nOEKsHhJvJI+XK4IodCfjyYoAIpguw+hVp+iCnMmD
         Cjo0q5CJd+WVIeApOaOT81zsuD7knqT2nOIFwPLAMYX5GNeB+ADKf/Q0hr4S0bCeG5Pv
         eXxh+KVp7GPA/M/qLLMWsw95i9Rq38aQFDczyEVhcyyCQ/0+jHMS9qkXj9zvJE9wPuPl
         wHbUimKEZg9qClWkLieyvpMPxgKHEvhkV8bIWqgA0rz0nO/RO5Ss3EWUCqBHF6Auucps
         kEBA==
X-Forwarded-Encrypted: i=1; AJvYcCUy3v9CbX427EJO6kMfLcWESzPdwegrHo+ObOOXxJqHlNoSXZtaNnZjpiXb33jOQenram7xvxZPNuAxWAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjIzxWXX1dgFMJj2LMRcoUE8JP7+Lb5QbpTwUot33U0QBM0hzE
	4u3mAvI/FxnkcgKG4zAjwUepRoUThN3nf5SS5Ty8q8Q17X85B17TH61IjbogNvuWsXCjWk6OcKp
	0IDYt1JFQBB4FbxtUqlrLELhXIUk7H8ZM80oGXXK6014Ns8aMfcJWDtnGsTAwBA==
X-Received: by 2002:a05:6214:1946:b0:6bf:7efc:1117 with SMTP id 6a1803df08f44-6c33f33d66emr20160226d6.9.1724894490325;
        Wed, 28 Aug 2024 18:21:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+83JODhwFjiVeEZ7C0/0RpEBcm05e8lIief195xyZB9E5UbynGRmQWhUDqK+J30xjphpQgg==
X-Received: by 2002:a05:6214:1946:b0:6bf:7efc:1117 with SMTP id 6a1803df08f44-6c33f33d66emr20160006d6.9.1724894490020;
        Wed, 28 Aug 2024 18:21:30 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c340c96825sm1013236d6.75.2024.08.28.18.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 18:21:28 -0700 (PDT)
From: Brian Masney <bmasney@redhat.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	quic_omprsing@quicinc.com,
	neil.armstrong@linaro.org,
	quic_bjorande@quicinc.com,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: qcom-rng: rename *_of_data to *_match_data
Date: Wed, 28 Aug 2024 21:20:04 -0400
Message-ID: <20240829012005.382715-2-bmasney@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240829012005.382715-1-bmasney@redhat.com>
References: <20240829012005.382715-1-bmasney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

The qcom-rng driver supports both ACPI and device tree based systems.
Let's rename all instances of *_of_data to *_match_data in preparation
for fixing the ACPI support that was broken with commit
f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support").

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 drivers/crypto/qcom-rng.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index c670d7d0c11e..4ed545001b77 100644
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
@@ -196,7 +196,7 @@ static int qcom_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->clk))
 		return PTR_ERR(rng->clk);
 
-	rng->of_data = (struct qcom_rng_of_data *)of_device_get_match_data(&pdev->dev);
+	rng->match_data = (struct qcom_rng_match_data *)of_device_get_match_data(&pdev->dev);
 
 	qcom_rng_dev = rng;
 	ret = crypto_register_rng(&qcom_rng_alg);
@@ -206,7 +206,7 @@ static int qcom_rng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (rng->of_data->hwrng_support) {
+	if (rng->match_data->hwrng_support) {
 		rng->hwrng.name = "qcom_hwrng";
 		rng->hwrng.read = qcom_hwrng_read;
 		rng->hwrng.quality = QCOM_TRNG_QUALITY;
@@ -231,17 +231,17 @@ static void qcom_rng_remove(struct platform_device *pdev)
 	qcom_rng_dev = NULL;
 }
 
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
@@ -253,9 +253,9 @@ static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
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

