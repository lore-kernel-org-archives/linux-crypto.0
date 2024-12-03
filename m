Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E7F1DF736
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733217595; cv=none; b=SlCx2y4VF3qpMXAUUvAB0q9T2o/tcQZ/GPZxLw7lt40PGb0rMoC/c9TrR2MWezGbvDajePk28DiEh2mXCl/2iW0p0ViXWE0yG+C3uKBLDqk6G5qoO8hr/z2Kx87tZS1CcIR+vyJFZb7LSRUQGVWlxinbswAH9N5yM0rnFjAV8Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733217595; c=relaxed/simple;
	bh=a/a90MwMNFc+GxsiPvK3hlVi3Cfoeup3Cw0hJE7QZ8c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V7lMeyCvm1H46Z/bHlFc/dbIQNg+LvjkJOlvhz7Lvu7uKpkLoNw6u7mvlz0IdYj9GmW1JK/ZeL4xRg/RrUHleV6efCRJrHXqE/ZvdfklGyoIoV//Er6uaaFI2Ga7q75l/M5tuKAJmjHjxboBg5A7fwD1rV+QQEH39IFnvjx5i94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=YfBIXwfZ; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="YfBIXwfZ"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ffa8df8850so59479701fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 01:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733217592; x=1733822392; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6k2L140W1gZGlavDo9n9M/YySHsyHY7A8KJtnjO2Uw=;
        b=YfBIXwfZlUSEijvwE8zS3odGzaIM014MxMPEE/hCidxPwqgTebETz4Hl7zz54xk2pN
         +0Sl+c7MoWFV1Koqx4q8JMgwjZGZTj9L/E1BiA8iNzVcXz+sv2ENLKT1wmkOFWHuPehe
         SpTqshBR9n/h1aomqkNsnIHj5U1KODKSu4bcCMlZgEAV1bYy6U5r7fk4Tmh4HNQ+FBzj
         /cZqLlY3M82qpGK1bZmTEN3EdZ/XyhjOMeOvZu6KC+GJVKEiImx+Xkyihiartsm8cbHV
         z+c+yf5TAizsJ38PiWp+AKwSf4Z7W8tgvPOHv81/M9IYWpcwQwonKSNIwwSEBRp6MVF+
         aD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733217592; x=1733822392;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6k2L140W1gZGlavDo9n9M/YySHsyHY7A8KJtnjO2Uw=;
        b=Yw9186okIJFHD0bhMWREM/T9iPdxIz906/EivMCa9DMfOdbqNrX/5hY7fJownEzC05
         8mphrfMdEwwevRajDdiQLn3QrMV60Wx6bUg/3f5Vbjn28fukR2VLqJU9YfpEYF4LCCOZ
         M8jCqeD82pbqFSqBuPJzTCLRplXS0z8+WrVpAoFhKydD4C4vZdH6Yqzc0ds/6VwUsK+p
         rCa7RPnYp1Oo2dh43cD/qjnvRafeSaA4T7KQ48IWfPcPXokFOHDjytlgahtuHxmf5hM5
         XTCRnHXcTpBuewAU6IKrVDemMPBe5DyAhj9h55PGY+/jVVtThr7KmaDwCtNhJYc44k1X
         bXSg==
X-Gm-Message-State: AOJu0YyShw3UMt15c6i8N36VDsiPTE3f1nH3eozuCY16QVw9jnj+Tcf7
	Lsuz5okXLvZEeXaDJXNxjma74wo3XIKGCHKQViDCoIWXgO/Wslmq7JhM8Iq4vKQ=
X-Gm-Gg: ASbGnctXf4XzTEgsa5nXLfm6lbMtZ07N+Vb685f5m5qCzSmUe2K3pIL1JTko4HQdatC
	fG7Wx9RduvbGmmRtGmY/EFd2APxHknBC3CMqLFdfmWZBc8uladHOnnBu/cTsr6JHAvIkOb3o3Q8
	Xp9KYJSrGLHIrLLwf2T4EcZzsDjh3WH8zZwMhScK9XJfAqd6nEX7xT8zDlVdLQzSU3qvpnSzisj
	Y4EHJDJagcszyeVcFUn/SYOk+q0dryJpJl2wq1njmbssE1zCJQYbCtrCzZY1udyb2M4mXDTCO5l
	l9AXU0s=
X-Google-Smtp-Source: AGHT+IEFWbr1zwOKq4r9HKNY4A2niJg6mEKSn2jXVRltpQlBC4u5eKxbX5aii3pqpt8ekqkvMGxP3g==
X-Received: by 2002:a05:651c:1605:b0:2fe:fec7:8adf with SMTP id 38308e7fff4ca-30009d29edemr7573921fa.38.1733217591609;
        Tue, 03 Dec 2024 01:19:51 -0800 (PST)
Received: from [127.0.1.1] (217.97.33.231.ipv4.supernova.orange.pl. [217.97.33.231])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ffdfbb915esm15591811fa.19.2024.12.03.01.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 01:19:51 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 03 Dec 2024 10:19:31 +0100
Subject: [PATCH 3/9] crypto: qce - remove unneeded call to icc_set_bw() in
 error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241203-crypto-qce-refactor-v1-3-c5901d2dd45c@linaro.org>
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
In-Reply-To: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
To: Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=990;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=HwsKCoEKlyX+6A6A6vYVvj3FWwSlHH/aqK3VHfeTQ1w=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTs0xuy13gNwVh4GBpYH/G6g0ZAVf0zKVYlq7s
 wTi+HyNkFOJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ07NMQAKCRARpy6gFHHX
 chMKEADPUtJZmkMcMO6clrMtTNe+NsFRTE2wmmxKSzcTh9TAjGJFn9zhkkxNF36L/oTTSLDedai
 L4Isuj83Fhg8Q1wWyEZKb2hla8S9b5+u0Y00wQWWVp5E3lNuXfWyT6VPd8127CK4G5XwD2ranLD
 1GutHcvaz1nZhMOK/ynvp3by2jwM4w0Wt/akhP4vC86J9kNC772AbJL9wmc0ydIKYR3xgMlEvGf
 kWOm5tfLc+33XpXk1sM/h0As4tYbtcXqTFBKW+debJXjuPNv/zMPUpAQTr6JI3x8usvtprORwKJ
 2hfSUXOPoGv6kNCZsHxtcy2m/bPP2+Lzmrf8+NUxuOOLy9yisAu1HPL0dz/FTOEXlzZT7t9OQgJ
 pMcx/4whGy6nayk10WHlAnubKlLcrj6Jpv99zZG9+a04cthBjmW8NkElKwp0C5TH+IpHo9gK4FT
 U4RD/So+AzEAZiJ+/2tnpMv60tvBSudwtIvMVCoblOaQhgFUHg4t103OTlWorglDkiGeLUoXQf3
 FLbhNKdg6qCze/j0HMMz0slarTwpt3t52dAsFzlMlDR1GY/Q69SJfMAPxMxftorq5rI++wsg7j3
 nqXXh1PzjGhM9rCxs+LiIut/dX5+V6lMJiIFTBO4dgt0ryzDeae98BD2VibmKEfBCFbO86VazTM
 VfO561uDhqz6yjA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

There's no need to call icc_set_bw(qce->mem_path, 0, 0); in error path
as this will already be done in the release path of devm_of_icc_get().

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/crypto/qce/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 848e5e802b92b..f9ff1dfc1defe 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -234,7 +234,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(qce->core);
 	if (ret)
-		goto err_mem_path_disable;
+		return ret;
 
 	ret = clk_prepare_enable(qce->iface);
 	if (ret)
@@ -274,8 +274,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	clk_disable_unprepare(qce->iface);
 err_clks_core:
 	clk_disable_unprepare(qce->core);
-err_mem_path_disable:
-	icc_set_bw(qce->mem_path, 0, 0);
 
 	return ret;
 }

-- 
2.45.2

