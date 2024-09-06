Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C91D554
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 00:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725582345; cv=none; b=mT5pMoriNOXo87mLT+Jbo06+ghW5rWzqDmVNTGyiM5VVlFB1z9PoFi++EWm2ZKsOPUThAf69SIAnfpx7s+oDQqfc8Pc8i4YkuVeUgicJQl1QDt6KIoQSro2EqnsejgUu36Pn55ehO87g9szJXIIqL0CF9yMZCzNmClT5xQvXG88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725582345; c=relaxed/simple;
	bh=F9Uwhqqdr1QEO4Uf0e3N6m5hVQ48iQS/2mzlZua6pJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=DxpdTyvdlmPItT3gxx7PF6huIPOSg26bcII6rfCYkUpdEojhFR1nMl6ITtwMWCpwob4WyAWnMzqLMlC/WREm9yPMM1rQCfkY+DQ8SVwySDrfCRd1xI9bx6z8hPZPiF6r7mCSCZGsHk0lhSUAhyP9YBm20v2/JU3O/dKQ8OqIfnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RtCqz4OX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RtCqz4OX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725582342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AXs+sSHMxW4xLKVsJ3yX9bT40+qBEQlZQpspzwecfqg=;
	b=RtCqz4OXU/cMnTL3ATRlyTvwGb/mk0GJiNK/QQGfh/6QxujmqAT0pgM8c7pRA8h6DRpaip
	N1XuPKRKXOdl9l0mwg+GaB6ni0nXWHWSUyVDopBh/GWvlrls7PJm9iu2QFjrHUq8KvdU0l
	5qUu8oZaTx6eSoN4Ki64tzD1umdwKMk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-GoJ7D5s-OI2iItq7I4LJdA-1; Thu, 05 Sep 2024 20:25:41 -0400
X-MC-Unique: GoJ7D5s-OI2iItq7I4LJdA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a8196f41cdso254721685a.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 17:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725582341; x=1726187141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXs+sSHMxW4xLKVsJ3yX9bT40+qBEQlZQpspzwecfqg=;
        b=nTRVB3sxfzibcX6nNEbeLvn1JlRVptGHrgRAYZL7Q40qDl8Yd+QsNOgHSrQjAVf7nR
         J82b5xyt703lbsOgNXP0esSUW0zu3Qzpm0k7CPBaQBaQ/13s1G4v90WcaLx1ZJV9HhcO
         m7g89cicnBJwwFpUc0hJd3L881BJh9pwJ2IWGcrTVMq1vny3NbH3VZINSdiZr5DyHrUI
         PavxaqBKGqi5+pjLgcrvEoaYzU4XH8GGKuv2Hvi2TJJt0ziNrmedyGijzeI5dt7znpsh
         gxsvnLWREoV4JIkNz5yAsmJ1U7NiJSY+E7lwSBscAEUayHxRvZXj64NUFgIF4Epo8Xsm
         rt2A==
X-Forwarded-Encrypted: i=1; AJvYcCXcN2lrqUKedH5xOcEKrucMak5zwoCanaFSvg69S1ZEVFN1S5sdNoB2JmlgQUmwyFc5gpxBkn8JX3Ppccw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfHMyQr6Ax/s1Wwp2I/N692qZQwWmCZoxnmJ/acbTbINwkBe3J
	M19iT9BaXts7UznaOeHgbSpiuHVnARie6m6z27AaOZfkvJTSIBHnT1Ucs8JOMiUdxSe9qW0TerN
	9dqyyZmnvQ4WR0bOFSoWYaw//c9/xqFINNC4dzE27IPViR5w4LWitdFdT7EY1Cg==
X-Received: by 2002:a05:620a:44d6:b0:79f:78a:f7b4 with SMTP id af79cd13be357-7a99738053cmr92039285a.42.1725582341057;
        Thu, 05 Sep 2024 17:25:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtgm5o2cQmEAwVZpksxYurvLL3zktTO4nmhdmHXqyWN7CwpD6yac08Ur1BLlemaReX6WXNvg==
X-Received: by 2002:a05:620a:44d6:b0:79f:78a:f7b4 with SMTP id af79cd13be357-7a99738053cmr92037685a.42.1725582340701;
        Thu, 05 Sep 2024 17:25:40 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a98f026309sm120779185a.128.2024.09.05.17.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 17:25:38 -0700 (PDT)
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
Subject: [PATCH v3 2/2] crypto: qcom-rng: rename *_of_data to *_match_data
Date: Thu,  5 Sep 2024 20:25:21 -0400
Message-ID: <20240906002521.1163311-3-bmasney@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240906002521.1163311-1-bmasney@redhat.com>
References: <20240906002521.1163311-1-bmasney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

The qcom-rng driver supports both ACPI and device tree based systems.
Let's rename all instances of *of_data to *match_data so that it's
not implied that this driver only supports device tree-based systems.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 drivers/crypto/qcom-rng.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 6496b075a48d..09419e79e34c 100644
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
 
-	rng->of_data = (struct qcom_rng_of_data *)device_get_match_data(&pdev->dev);
+	rng->match_data = (struct qcom_rng_match_data *)device_get_match_data(&pdev->dev);
 
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
@@ -231,31 +231,31 @@ static void qcom_rng_remove(struct platform_device *pdev)
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
 
 static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
-	{ .id = "QCOM8160", .driver_data = (kernel_ulong_t)&qcom_prng_ee_of_data },
+	{ .id = "QCOM8160", .driver_data = (kernel_ulong_t)&qcom_prng_ee_match_data },
 	{}
 };
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

