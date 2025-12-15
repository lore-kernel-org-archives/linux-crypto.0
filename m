Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A88C33D6DB
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808268; cv=none; b=GPIAeQP/5JwN/BgyFlBk8mneklxvXxmmvbm/fHi7j+NJ/1oiIBW3VyqR+egWs24OiLItdw4u31WFs3pBkoKl/YhavVcO0ozWHcXOBhM+AHnoWDSqG3bEj2KqeeezvZlYULJEbbBjxk7aTvSjuXZ1y7Pb0TxdnwuUGxHfpAP5y/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808268; c=relaxed/simple;
	bh=1uJJpA9Ql9BbSXGSv2HLkK7u07CA6mF+itptx+5e3Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sIIPnIcB2a9zqpqoVr6S6Zt8+7uwpmkqI8NQ2aKWOBOttMVOZIvBIeeQpTWAthYQB4WLrrOvm90gANtdTWMdRJcvnBegREOJBa8ufilUEEFgEUohpL9Y6PCI0rG9ISBa8wu6VPUmZqPOHejsejGEvdPYuFtLb19LR3A5Q5Ub8rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=Ugxs9h9H; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="Ugxs9h9H"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b75c7cb722aso688929566b.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 06:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765808262; x=1766413062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIUQR9A1vYIw9QlcE/Qa0VTdIdcn5aCO46D96t68m0E=;
        b=Ugxs9h9Hu14Zr8d6axdt8o7D8NR++TA/EqsmVSN1W5KjJ4/8lcRl5QHu/R+TShngmF
         5+mOpQmpRwD1dCLCiyR+ext32DdGM9ix7WVY++3fYMNNL4EJdMuqE8kfUEeRChv30SGg
         DwjWJgTJqik3RlGq0D4wWw2ur7flrQh0RrLyZlSRnbJpqYbX4GZU2dvl1cv6r2Bf0BXT
         xIkkxrzXCNRMM6/FuR5AFJbxe99kYxYTiPuvkFkePsfH28g5H5OGnM9yLkASWFz26IlY
         X/uIYiPfY3FYbZYGvYu09GyAO5kwGh8oRB6jmb7rUYK9QQLvqi3RsXwtsWPWBR20ugxW
         RGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765808262; x=1766413062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QIUQR9A1vYIw9QlcE/Qa0VTdIdcn5aCO46D96t68m0E=;
        b=sepH5bUcVWNqrdOnAPrYsZK7Nq6k0SBFZHwP02hKmZe3CTzQUknTUqhjVjCNiLMFGZ
         d7sm+cWFLAhpJW+SVgjl4rUKBTnN/sp+y/OYaYST/YxoJa1VkA8YJ4HRDDtjQi+BF1M2
         UyPt1CYkwjAV8SZXzgwcBicsISyhLLt7VgkTuGsh3LucqC2tg8y18fMbr+nO10JmDwzd
         H2wFBzEnmTyFffzetsRr8rdqu4/SIaJiajNTwEzi6jjARwcYpY9IRcbNy70UNykTPyGi
         IudHCzxTyf4HTIVD7V4/UZMA289t2FE/qnOd5Pl9AHfR3WdkTVBpX4U4cTG+ss+gjb50
         YpKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAW6Boyk+WnJ43E1kgDRRoBJ7cI+wPwTq4pJntKCFbEzuFpGSkoSTJcG+D6//vvltaMieYNvpXysfIU6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiEHOuuxM6xQFyT7Y2H++GbyS8V2xzDSUlow9EgTGlqknX4mf2
	znj3A3EqGY+2rWDI51dsTKEYFyCjRe63iB7tbikEi6hxf/HjOTuI4IqGkKoRhidHE4c=
X-Gm-Gg: AY/fxX4D2QkEpGMERbGEeTuRuMCmtJ4XkjvqdZ7PEoAijdD4BRT4+f73cN2//wg/5Y7
	LxQBfeNECFBJ+G2tJ5KG+wHTEtN6Smcn8+xJrCuirnHLN67bb9jBMyAnDeX+mBO7yb8SC0VlguK
	Bebe8vbt+ypFXPoyMAl4yEV59SgnoM9iPsNsUhn/webeVEqCX9AzYv3uQC9PExJAejAXsH8p7Ga
	I1F6nbou6akga4xgxAri+UVC4vaVFp0IzyrwyjqcdOC1IqlUvLDdfqGzi41JLptm1dEB2gfo9xq
	NWQh5viKNXEABrvx3a2qF2d18HHz2lVGBnRJruZLtV8OAeP90T4CM4H6sUi2fOjiAEZTeIIMcif
	b7l42SnDuc82xXp1rkbhfnfhmk3FCjM5CZ/bjfksTDQhz3ZXMFEGKDL1MUp9CM9bPFmr7RLQ+/0
	totANdmdpwg6gHZkLhhq9R8DvY87dPPJpRu6yOlVKK4jOVfs3pW6ox3HbiFw==
X-Google-Smtp-Source: AGHT+IGgNV09AuYgsqnGmm65Wezv684KCpS+08Dd8VMBIrTAAoyAJyvM9gNMVpz7WAarxXBPjKme+g==
X-Received: by 2002:a17:907:1c0b:b0:b7a:1be1:984 with SMTP id a640c23a62f3a-b7d23a912c7mr1001442866b.64.1765808262516;
        Mon, 15 Dec 2025 06:17:42 -0800 (PST)
Received: from localhost (ip-046-005-122-062.um12.pools.vodafone-ip.de. [46.5.122.62])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6498204fbb3sm13523420a12.8.2025.12.15.06.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 06:17:42 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: op-tee@lists.trustedfirmware.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: [PATCH v2 05/17] hwrng: optee - Make use of tee bus methods
Date: Mon, 15 Dec 2025 15:16:35 +0100
Message-ID:  <170dceec036ffe468a1f9f26fa08ac9e157ada29.1765791463.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765791463.git.u.kleine-koenig@baylibre.com>
References: <cover.1765791463.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1885; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=1uJJpA9Ql9BbSXGSv2HLkK7u07CA6mF+itptx+5e3Xs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpQBhXu4/bwtxASM5yQ5sR2LOaNmcTkAhZ5XaYd riWdpm51lGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUAYVwAKCRCPgPtYfRL+ TiHYB/0Rn5IqZ2NZ5jNZ7qhs3+bCUIODZ5brLERcCe++79d/CFyEMLoIbkC7IrHhW/w6rf8d5ec P3QZ4XFV36zh0ByWKjm37dnphaan9VGVrf3AOnvcgTNpNtFsFzh70z9s8VN9xvgRW5tbAllBM7f fd6pZoiQz7yXeDj/OkdNa8vtTlSqOpTihSEM6wu3U97yq1lWfdiYBrT8Gjj3IP4VXRlPbVJHG44 3sLs6/eDddZUsq1L/LxYImmr8SVdBeskUGgqQufZsne2BQzMWhpxd2mBDY1olq/Bx/0yevHUr7Z CvGicBaxS9KGPVUHWdtAeD3h/4gmlwcbWLWHtXpWAJX/J/l4
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The tee bus got dedicated callbacks for probe and remove.
Make use of these. This fixes a runtime warning about the driver needing
to be converted to the bus methods.

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/char/hw_random/optee-rng.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 6ee748c0cf57..5a3fa0b38497 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -211,9 +211,9 @@ static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
 		return 0;
 }
 
-static int optee_rng_probe(struct device *dev)
+static int optee_rng_probe(struct tee_client_device *rng_device)
 {
-	struct tee_client_device *rng_device = to_tee_client_device(dev);
+	struct device *dev = &rng_device->dev;
 	int ret = 0, err = -ENODEV;
 	struct tee_ioctl_open_session_arg sess_arg;
 
@@ -261,12 +261,10 @@ static int optee_rng_probe(struct device *dev)
 	return err;
 }
 
-static int optee_rng_remove(struct device *dev)
+static void optee_rng_remove(struct tee_client_device *tee_dev)
 {
 	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
 	tee_client_close_context(pvt_data.ctx);
-
-	return 0;
 }
 
 static const struct tee_client_device_id optee_rng_id_table[] = {
@@ -278,11 +276,11 @@ static const struct tee_client_device_id optee_rng_id_table[] = {
 MODULE_DEVICE_TABLE(tee, optee_rng_id_table);
 
 static struct tee_client_driver optee_rng_driver = {
+	.probe		= optee_rng_probe,
+	.remove		= optee_rng_remove,
 	.id_table	= optee_rng_id_table,
 	.driver		= {
 		.name		= DRIVER_NAME,
-		.probe		= optee_rng_probe,
-		.remove		= optee_rng_remove,
 	},
 };
 
-- 
2.47.3

