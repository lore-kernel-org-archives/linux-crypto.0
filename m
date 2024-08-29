Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B795717C67
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 01:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894497; cv=none; b=Nvogx7bGez/lg3qcir7zE4vem4e0qB+p7Yd8bCGByIx+h8BITUayEhyR/0Cd8zFmXP30GtMvf4eAcJz3vpHS96ijuP8j/SYyPaf458Tv1mPsCvpH5uTQfLQiQ1R4cl5HkVedNyBnL3LeyvPFLHDJ6WyY0tOA+z/EAmqN9jjGjMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894497; c=relaxed/simple;
	bh=5cZ/tjRZEvLlBlcMgDypjgg3mVu/wSmTlQDFzZ8a8WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=cL7YVKkbPLI+U8rZ8TBd3CAU280zuuxcv9utiV7oNrVXtqFI8imh6m7NqJ8PNd7PNjOHQJF6pdU1CUkioTgHLJUOCPmXGmFpQx6bv8lammgj4EmZpubbT8ojn56nvW9j+NN/fkZwxWZbDGtQ6s9TOqHae6JS9A+DUWF2JDtzI2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GPO0QDUw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPO0QDUw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724894494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1NZAUVynLNTnl3J66RD+E9gv/iCwUnMmJ5YyN4QH4Ew=;
	b=GPO0QDUw1RX4Yvbufz6sMQEuRvbrm8VgI66Ak6NxYQkqzkhyxwqQetXUeZnvW+QaCY1hn3
	CloobR+XwYJCSsxQ0GO8HpWHoToRA1gg6RaARyaQEM6Gfto9qSGIT2eUgWETSBTkzcQ0PL
	7zMz+I0BMPWYMbncER4g3nujfCKqdPU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-v6CxWPGfPwCLkI9Dh0JTNg-1; Wed, 28 Aug 2024 21:21:33 -0400
X-MC-Unique: v6CxWPGfPwCLkI9Dh0JTNg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6bf8d9867a3so1862966d6.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 18:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724894493; x=1725499293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NZAUVynLNTnl3J66RD+E9gv/iCwUnMmJ5YyN4QH4Ew=;
        b=L6olqYQ1739jHRc5Imw2G8AmM22wg+6ghBzLp3SRZ4V5sZOf51yXBGyQGjRmSupGN9
         cbFVLpIj6+ux5ML06CXm00B5U5heERVrFfMVzQDvhi8FEYgnE4WTck7M1YQEMwqAEzYn
         +nGCnEtmMaRe/PEnwuXAjg0wXOP8B8foWts2Zd4aNFL6EPqYde0SBNDqhLtQ81FqzXD2
         gOu3djzK+2AGNuaUSN0k+Ta6TjqPS/f0qLV41Oex5beYQ/Bb3A/5IH2fLvksX5rhz8jt
         xQQfijv3yfGJmeg5+iXVqkM46PVl5l5oap7NbQ2PKBsnOdEAh+RDj82MNmK57hLOPyD7
         2zsg==
X-Forwarded-Encrypted: i=1; AJvYcCWFhrFyUIjfpa4/0DOHlb5vPgorICXC4Ml17SZVu/OlHS+SrwZT7BjZF0fHTBRPrT0XefVDQlFiu+2S5gM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNUVvxHbDFUzQJpnI9zXxSwCS48fl4OOwF9QOxYq8mxJ0C5HbR
	ZCZ2mbWb0m6B7SmVGfrE70ekyd6DLxXYg9i9ZAfAE6D5d7KxbOEOpBGoCXPTbNGTZDvHKk4t9lU
	2NR1Rbhy9fBgWD8T+NbhqQLKi7aNgCwzhGS6hQ3HQ3LD5g1r0dL2/WUO1w2sGGA==
X-Received: by 2002:a05:6214:451b:b0:6bd:778b:6594 with SMTP id 6a1803df08f44-6c33e6962a0mr14117416d6.54.1724894492856;
        Wed, 28 Aug 2024 18:21:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFicbErcyZiL6ygZRYadzj1SdSXTCvwnpByTUjprwT++cXLx+ACzuYsCKWZ7aVgr6os4cyMlg==
X-Received: by 2002:a05:6214:451b:b0:6bd:778b:6594 with SMTP id 6a1803df08f44-6c33e6962a0mr14117266d6.54.1724894492488;
        Wed, 28 Aug 2024 18:21:32 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c340c96825sm1013236d6.75.2024.08.28.18.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 18:21:30 -0700 (PDT)
From: Brian Masney <bmasney@redhat.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	quic_omprsing@quicinc.com,
	neil.armstrong@linaro.org,
	quic_bjorande@quicinc.com,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: qcom-rng: fix support for ACPI-based systems
Date: Wed, 28 Aug 2024 21:20:05 -0400
Message-ID: <20240829012005.382715-3-bmasney@redhat.com>
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
ACPI support was broken when the hw_random interface support was added.
Let's go ahead and fix this by checking has_acpi_companion().

This fix was boot tested on a Qualcomm Amberwing server.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 drivers/crypto/qcom-rng.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 4ed545001b77..470062cb258c 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -176,6 +176,21 @@ static struct rng_alg qcom_rng_alg = {
 	}
 };
 
+static struct qcom_rng_match_data qcom_prng_match_data = {
+	.skip_init = false,
+	.hwrng_support = false,
+};
+
+static struct qcom_rng_match_data qcom_prng_ee_match_data = {
+	.skip_init = true,
+	.hwrng_support = false,
+};
+
+static struct qcom_rng_match_data qcom_trng_match_data = {
+	.skip_init = true,
+	.hwrng_support = true,
+};
+
 static int qcom_rng_probe(struct platform_device *pdev)
 {
 	struct qcom_rng *rng;
@@ -196,7 +211,11 @@ static int qcom_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->clk))
 		return PTR_ERR(rng->clk);
 
-	rng->match_data = (struct qcom_rng_match_data *)of_device_get_match_data(&pdev->dev);
+	if (has_acpi_companion(&pdev->dev))
+		rng->match_data = &qcom_prng_match_data;
+	else
+		rng->match_data =
+			(struct qcom_rng_match_data *)of_device_get_match_data(&pdev->dev);
 
 	qcom_rng_dev = rng;
 	ret = crypto_register_rng(&qcom_rng_alg);
@@ -231,21 +250,6 @@ static void qcom_rng_remove(struct platform_device *pdev)
 	qcom_rng_dev = NULL;
 }
 
-static struct qcom_rng_match_data qcom_prng_match_data = {
-	.skip_init = false,
-	.hwrng_support = false,
-};
-
-static struct qcom_rng_match_data qcom_prng_ee_match_data = {
-	.skip_init = true,
-	.hwrng_support = false,
-};
-
-static struct qcom_rng_match_data qcom_trng_match_data = {
-	.skip_init = true,
-	.hwrng_support = true,
-};
-
 static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
 	{ .id = "QCOM8160", .driver_data = 1 },
 	{}
-- 
2.46.0

