Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D9D2248A0;
	Thu,  1 May 2025 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126461; cv=none; b=iFprJ05lHON3EIlHzoZrpRyryz9zcqZG9HAX+XdS13zLmLtHTE+ERVUll42bZ4rk6rI5qpxbA7OcRVBuzelIHaK+mycV/LfsgbCUeNGWLWT/5hxnfm2iI4FAl+braeKxysX5iBzhDgiOQiXFGOVLMMdPvhvlb8pt/ii2sUx0e1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126461; c=relaxed/simple;
	bh=2PjYxqC2TvoFNeTYXNE58FNx+yDrrBK7F/NyaMPn/rE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uZx9cVFScaAjxzrABM5RbTxg5USJmMQC4mPQJShsfpvMFoJNCU2Ihi5NQ89VfiWTsVu9s2NEthap6bmgjzyy0ToFos2asX+E7mMXaw/c0jXKmmE8QRp6jHwuKDnbEg0rbKNGmCqLBDnRQY7rWcJD+tkGWx8O5AgbKlHrzob9WoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q1IOek0V; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1IOek0V"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac345bd8e13so196516466b.0;
        Thu, 01 May 2025 12:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746126458; x=1746731258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYcnJfHyu9Qya9nm0+iaohPyzIhpcE4qtAIXaJuOv9M=;
        b=Q1IOek0VCu8TLcoIUjZLaO3ejuc8IUwT7HrhTngCiCydh9GO/zIUCkeL3miJM8l73r
         8N8fFkATeuvELeeKtgRcbji+I5uyOpWKhsZuxJTMsyF2NFIOlqeIv5rtmpuj02+Tw9qg
         pcDMcaquU/3UuVam2XAtIWLJCn6oYnTdNB200ytTYyBwwk3N0YtJeE020Qtb5gCxPXWy
         mXOZT04ElQ12Dka+KkyLc84o+rR5cJUK+YpipalUoH6IqaB+C+EcWvBZvG/57rTLqmUF
         XcrUQKdXXmHdHuISZxoHQC11Q5EfDMDt2PMTt3Bz0fjSDBQPtoEMqyllw4tHpdvORsag
         0APg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746126458; x=1746731258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYcnJfHyu9Qya9nm0+iaohPyzIhpcE4qtAIXaJuOv9M=;
        b=hD2fuVsDhIcRClBrBJjw+0AgdgmzCsQGTnzhIPKpD/d2oAWcgWLB57g4Wof6E+PL5K
         oivh5Q/7f0Rq8dSwp011pQ5/FgSv5RzZLQf8rNzwyPe9XoMetpyOR97x1H1FtC8ZOkFS
         x5gktsQm87NhLx+lFadB5CR7C/1T0CVE5NvFwkD6tn9F0f7sJVsVrgXn2VMkmFNPgfFv
         KqkeMksYpuRqOiYpxfn7BvJ8tU6wxeWp+p/gIjtiPZeCnL0y+uM8LoTBB4R0zX3L06yL
         1A9wZYlabxOiu8PXtjD3aP/yj8D/9WGzXC4LCW3xnJzelmJ9PDFaYJTMszjpP3jsl3ro
         +D0A==
X-Forwarded-Encrypted: i=1; AJvYcCWpT+bODIJYXg1jzoY6+jV/UdRJcUddsDnkBySbTEgCdF7/HyL/qkNjV9t2xhBvkzrfJgij3hz6wJ2w1pk=@vger.kernel.org, AJvYcCXT+Isw/WjTscupwG9SCVXv1RgsM4tA2DkZ9v3ow+x2ZU5BTrSx1K32b3Z0dC4gbYMsqSlFt6VVeLTsqOaB@vger.kernel.org
X-Gm-Message-State: AOJu0YyRrb+sZr0034sNOL24pE3fi9RvALE+QAe77cc/7uyLIncy0VjC
	OVjDPU++4H4FffYzXZapMVM3KnfHjznRq+sOOh0RIPr2VGqBkP6Gu2aIoA==
X-Gm-Gg: ASbGncseCbUyydZp6+5tkVZLIP1mpHcwsqRT9uxmTpeG71zrdGY2snIRm9wouskTDS7
	fl4u7vYKzy+9rRIaUku/fo0NYbqWtng4RywbNVFAlfM7VrDKQZAZvqNhQlojEUSbOOcB3guWhHY
	IHhPcbxFrU0kATDPfvk2yVmtaOPD7EX1p77tvPSBnt6iv7fkPegkXp/aClhUM6aazQO2VMa2VAa
	fn1L3PUpC6mpWTDjTFC6bfwOm0W6OIqZ4S5tE/XIRi0fIwgQwERnAp0jsU77GwJIX0K+30lmS5t
	VQ1UlP9aZEPeeUzrwbYq/Pr0tYoAmtNbigEVFcNNM92tDyPtUaZvPXvoecveGcEHixqI
X-Google-Smtp-Source: AGHT+IHfDMVIQ26ycHG3NCY+1odFkBcAwHTLJ2hCKHMBoEhxiuT8ZDLFmo0kkKjR+EXlLecp/8T5kw==
X-Received: by 2002:a17:907:1b17:b0:ace:37d6:a5ce with SMTP id a640c23a62f3a-ad17ad819e2mr39669966b.19.1746126458067;
        Thu, 01 May 2025 12:07:38 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0c70c6917sm80349266b.4.2025.05.01.12.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 12:07:37 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 1/2] crypto: sun8i-ce: undo runtime PM changes during driver removal
Date: Thu,  1 May 2025 22:06:50 +0300
Message-ID: <20250501190651.3863582-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pm_runtime_use_autosuspend() call must be undone with
pm_runtime_dont_use_autosuspend() at driver exit, but this is not
currently handled in the driver.

To fix this issue and at the same time simplify error handling, switch
to devm_pm_runtime_enable(). It will call both pm_runtime_disable() and
pm_runtime_dont_use_autosuspend() during driver removal.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index ec1ffda9ea32..658f520cee0c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -832,13 +832,12 @@ static int sun8i_ce_pm_init(struct sun8i_ce_dev *ce)
 	err = pm_runtime_set_suspended(ce->dev);
 	if (err)
 		return err;
-	pm_runtime_enable(ce->dev);
-	return err;
-}
 
-static void sun8i_ce_pm_exit(struct sun8i_ce_dev *ce)
-{
-	pm_runtime_disable(ce->dev);
+	err = devm_pm_runtime_enable(ce->dev);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 static int sun8i_ce_get_clks(struct sun8i_ce_dev *ce)
@@ -1041,7 +1040,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 			       "sun8i-ce-ns", ce);
 	if (err) {
 		dev_err(ce->dev, "Cannot request CryptoEngine Non-secure IRQ (err=%d)\n", err);
-		goto error_irq;
+		goto error_pm;
 	}
 
 	err = sun8i_ce_register_algs(ce);
@@ -1082,8 +1081,6 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	return 0;
 error_alg:
 	sun8i_ce_unregister_algs(ce);
-error_irq:
-	sun8i_ce_pm_exit(ce);
 error_pm:
 	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
 	return err;
@@ -1104,8 +1101,6 @@ static void sun8i_ce_remove(struct platform_device *pdev)
 #endif
 
 	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
-
-	sun8i_ce_pm_exit(ce);
 }
 
 static const struct of_device_id sun8i_ce_crypto_of_match_table[] = {
-- 
2.48.1

