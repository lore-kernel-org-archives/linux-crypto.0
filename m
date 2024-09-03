Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98401126C1F
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 21:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398572; cv=none; b=Wt5YZlHKtTD429aGZUNdqOB3hOXe3wYL8eHc1DrDqyBz/+I+WjQRxFdovDpePRCf+BrwHotuO7SJtaFNqwjtAXly+nQojm7zY+ZEnWlegv91ZPue5L5mmSac+0CaWvF7pGpQQfrmRnQ00mib9mPNpcXlWtZ3n6MIPDArRGUhmXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398572; c=relaxed/simple;
	bh=XeVESrItEVM4R9ipyaNeknfhuHOQ4dILrBWsO0yCW3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=pGKL2DPk5zWttPgpFF6kgBZMLqEmaOx8LWvX7qDx6Ee6OleLsN2aRuODodUdawVcsr/kZnzIMMh6WTvIRzUuq18gg162+pFbKeenz8As1HsTq/BuSbtlYjlGiKkwwidL8HlMY9U8tvdoZmBYF6MSQEq1ZRagpSNF5UXQ8ahdrTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7N5XGLk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7N5XGLk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725398569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5OaxE+qf4J1jZnk8c8Xd2x+KJy3fbwff+kIsNtq2Opo=;
	b=L7N5XGLkRKQtN+OxAUFbXBeEomevjrLg7DLibICXjbY3GkdmpuerHOrtSUsDRK+wBvoloW
	KzS6821jewIb5nnM0/G4M6Jj4DcSE3kRmVygwNs7oha6JhMY2HlytCJQmx8MhihwmXUseV
	giS6f0352pMCu8ahXd3GdyWZ+m66hYE=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-aevltahCMBqbqEQfca2krQ-1; Tue, 03 Sep 2024 17:22:48 -0400
X-MC-Unique: aevltahCMBqbqEQfca2krQ-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-277f1e27d63so3955055fac.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 14:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725398566; x=1726003366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OaxE+qf4J1jZnk8c8Xd2x+KJy3fbwff+kIsNtq2Opo=;
        b=Y8hlHxCbX+JDLOxETWvL/D1xIAvpym3TxmTj3a9UQodO6R1/hn0Ol8/8gb5sGxNTtA
         2GmGzNeT1C8/w6vduq6rY+vvPLlGRArv30VKCO9Wx4fFIeM30DMocOaSK+Jy8olTy3ay
         VrrGwgf1TOKIT2EGQa4jbCMwrMyfsFtbOVQB3N1w4v6Yorvoru0sZFDGt8iplECEEkpP
         w6Am/fKt/jYd46VQW1/9A2vB66z3NPWuLTNuuv2BG9QCrZgf0YiFSsZ8A+LAFW0NRPtT
         0KiBd31BgIB3ZQosVzGrXzsoGI6Q81L7CuvffAdzoWblIja6Y9XaV5bkJ5pLupr6DAxe
         vitA==
X-Forwarded-Encrypted: i=1; AJvYcCWttAJWTU6VxD2omdB5cOka8omP5fXv7XtdtEDwnrSXHicn3d1X/H5kZsnktH7mRRD/W90FlrbWnpzjUZs=@vger.kernel.org
X-Gm-Message-State: AOJu0YydOnlN8CfcUFM9PYpgRkOq6SrJsfnZ1ToZDoWwP4jTPwp86Wym
	tJefvdVbo6LVYXehUORH7ojVHIyGBTT/TiuJcKECy68NeZbSaFXFkbHOqSZ/QoEJ90jiKBzJjB8
	QQJH4tOCy6JzONeItob4/ef6FAS8UEYw6uSi3eN2E6PtDRuOd4APXhlvzpxwjlu2+8X5cIerU
X-Received: by 2002:a05:6870:331e:b0:25e:7a1:ea8f with SMTP id 586e51a60fabf-277d06c897amr10603223fac.47.1725398566458;
        Tue, 03 Sep 2024 14:22:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5djy4RfXuBi03LceJtw15luMRH4Faxo5Y9BNdPLILRJ8AbHm4nzFztUWK6JYZrH61sMi09w==
X-Received: by 2002:a05:6870:331e:b0:25e:7a1:ea8f with SMTP id 586e51a60fabf-277d06c897amr10603204fac.47.1725398566139;
        Tue, 03 Sep 2024 14:22:46 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806bfb8c9sm564737185a.25.2024.09.03.14.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 14:22:44 -0700 (PDT)
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
Subject: [PATCH v2 1/2] crypto: qcom-rng: fix support for ACPI-based systems
Date: Tue,  3 Sep 2024 17:22:19 -0400
Message-ID: <20240903212230.707376-2-bmasney@redhat.com>
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
ACPI support was broken when the hw_random interface support was added.
Let's go ahead and fix this by adding a check for has_acpi_companion().

This fix was boot tested on a Qualcomm Amberwing server.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Reported-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Closes: https://lore.kernel.org/linux-arm-msm/20240828184019.GA21181@eaf/
Cc: stable@vger.kernel.org
Signed-off-by: Brian Masney <bmasney@redhat.com>
---
Note: I looked at updating the struct qcom_rng_acpi_match to have
driver_data point to &qcom_prng_ee_of_data, however that won't work
since struct acpi_device_id has a driver_data member of type
kernel_ulong_t. struct of_device_id has the data member set to
type const void *. As I get available time, I'll look to see if
it's possible to migrate struct acpi_device_id.driver_data from
a kernel_ulong_t to a const void * to match what's done in
struct of_device_id. That will allow removing the has_acpi_companion()
check in the future. I suspect that change is not going to be trivial
though.

 drivers/crypto/qcom-rng.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index c670d7d0c11e..7ba978f0ce8b 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -176,6 +176,21 @@ static struct rng_alg qcom_rng_alg = {
 	}
 };
 
+static struct qcom_rng_of_data qcom_prng_of_data = {
+	.skip_init = false,
+	.hwrng_support = false,
+};
+
+static struct qcom_rng_of_data qcom_prng_ee_of_data = {
+	.skip_init = true,
+	.hwrng_support = false,
+};
+
+static struct qcom_rng_of_data qcom_trng_of_data = {
+	.skip_init = true,
+	.hwrng_support = true,
+};
+
 static int qcom_rng_probe(struct platform_device *pdev)
 {
 	struct qcom_rng *rng;
@@ -196,7 +211,10 @@ static int qcom_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->clk))
 		return PTR_ERR(rng->clk);
 
-	rng->of_data = (struct qcom_rng_of_data *)of_device_get_match_data(&pdev->dev);
+	if (has_acpi_companion(&pdev->dev))
+		rng->of_data = &qcom_prng_ee_of_data;
+	else
+		rng->of_data = (struct qcom_rng_of_data *)of_device_get_match_data(&pdev->dev);
 
 	qcom_rng_dev = rng;
 	ret = crypto_register_rng(&qcom_rng_alg);
@@ -231,21 +249,6 @@ static void qcom_rng_remove(struct platform_device *pdev)
 	qcom_rng_dev = NULL;
 }
 
-static struct qcom_rng_of_data qcom_prng_of_data = {
-	.skip_init = false,
-	.hwrng_support = false,
-};
-
-static struct qcom_rng_of_data qcom_prng_ee_of_data = {
-	.skip_init = true,
-	.hwrng_support = false,
-};
-
-static struct qcom_rng_of_data qcom_trng_of_data = {
-	.skip_init = true,
-	.hwrng_support = true,
-};
-
 static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
 	{ .id = "QCOM8160", .driver_data = 1 },
 	{}
-- 
2.46.0

