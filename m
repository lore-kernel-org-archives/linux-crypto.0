Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBA01F8756;
	Fri, 20 Jun 2025 07:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750404921; cv=none; b=f/37IfclR4e/Www6pGJ49Kykx5+WFWcPD9f9tBBPIhBr2zgOS8tIe+r9YPOdS7pDJnhZh4q+LtbtqoMouuuNJkZWhzRD4e0HYI8ZKct7lDUsofUIt/0Exv/gZNTE4+8B/o2op+0ossZsKnx3tUwov3DHnCn5W82g20br8nQDtVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750404921; c=relaxed/simple;
	bh=AIvL/6g2H/0sTgoq/ACnifDpyEvv8ah2mbQnCZ/NZcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IiXfA0TV+He2PWSlJiN0qzE31RFOEg/b2R21e1z21cf0yKJ0Zj1cGaV3E8I+d1W8UXLJ0DNCi8faa/4Tod6lJI7ikBniy8/N4m6W6rpEow+8+3oW74fhh+/bR53U5a7UWQ2mNk0Gdh7awDTmMaqeMhyJGYOR2IFE/qvJebbYmgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKdUMLkq; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKdUMLkq"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a4f64cdc2dso251528f8f.1;
        Fri, 20 Jun 2025 00:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750404918; x=1751009718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/n2D/c88J35CJ4xA93h8LPGldZG/T3YYZwEnGb335pg=;
        b=WKdUMLkqoyhLno2XGd8w8ERQD+/8Un8PVaaUbN6QJH2amB8Eea0LlbqlIBEXRQsIoL
         uYwKAmXcqP089uSqg/1jgeKpuPGB1qO0SUgJejkfA5xyRygWjvR1My4cPqkQmUe8L87M
         Pq4J5KuAjjCZB3VkHDJ02alTtzQGrPySi4A1SZEOjXah8Z3mSqz+/OVOVgfc44Eu4IN2
         uZ9I5aHr8D/+/B4nyUCLhbANFsJhG42n37Y6kkugqnabCY477hHkKY+frV8+kIYcPu3i
         MPtlGGY22qZWhJ5+W8PiWilQnj9KoLJOR8OME+EYInMMvZ/i0kyigmC8uCqt7lK2Gtth
         aMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750404918; x=1751009718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/n2D/c88J35CJ4xA93h8LPGldZG/T3YYZwEnGb335pg=;
        b=W9SXjeSzcGqhpj2Q+PQOxvAZ9OTlQJ3ZqWLN6XcrCFxJQoH3/0NJv+W8pAeoxtc2J6
         rhqKhxTlhrEMnbmL0ABUq8wAKYgE+NkXLsEMA0w0aIEbi7p3KTCmUVUBlfnQLAX1n1FC
         nSC4/UZIi74TMeuVmK1lCCiez2mh0qpWqc+MKEngSKzdAfJLqAxfdilZ3VZCM8fUUckx
         xEDig8k+j5qlLHgDQjnGFH1oop64Vj+4yOltRDrpho038Sg81Uoi9J0yCPrtqEIIxtNR
         ga5kwl6nCEBkC/D8heElgrSNmVIUjuhU3kgLfhvSXneEUoWuVHdO3tUuyOCrz7ScVXeb
         yTeA==
X-Forwarded-Encrypted: i=1; AJvYcCVDqybWXncEm+KIRvbUxjOyXIAXL2ApKFSK3VcXsR0fqlI1dXI69Meq/WaVkapbuLoPBjruw3bpUpBa1Vu9@vger.kernel.org, AJvYcCWdDYUKSM7YzwZFAaxeOBrSGu3R0SHJI6nZ7EZuZcrQDNM5vziFMP8Hn83S9I6IkqfLbyM+TGKR1yuqH7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlDGtvUHELpAg3pe3DT0XRQzZs1lxx9dIE6WHiXJMB5bXnMcAb
	if5/xq28F60pTeyM2jRVL6Gkom9ACWw7Os3PYo4ROMS1YdrB8RoMaux4
X-Gm-Gg: ASbGncvWLW8nI6n4FBllS1kF/OISPZBBeSg8qPJ2CF8OG2VfuZeE/ql5g9h9HF/gEUB
	Tlpo1HH4vqRR1wvmo8MGq33FQBmkIUchvovEQCKOZYZrPIOwbRcqP6glU+rUne2XRRFi3FMUcwN
	E835RKuwklHSj4Xui5xEPxfNVaN6bPKzkILSth4hQUmPwoJiQ3A4dTmAvt3el6pnJYeJ0x7dyJM
	dgWafGauIGUSV3RGmw0TnSie3qKict5nK+G0akQpioSvWrFaf8d8M0Q8MIu7Re4sR5zYFoiF2YL
	C24dhBL0XdZVO9W6GMG6qBhXNOgs8lOfF2kcWwrIee2Xjzv0lU0Uvs4KVvz9F58FEloYX5OuqBN
	DqzGpG8Fx
X-Google-Smtp-Source: AGHT+IG9uq871/vm49hT7v7R+52axsivlpKJWrEcHdv0QAYKq50BJGM11XgD1kQsciNUlFJOBk2lqA==
X-Received: by 2002:a05:600c:5026:b0:451:df07:cd00 with SMTP id 5b1f17b1804b1-453659d8ffbmr5029475e9.7.1750404917817;
        Fri, 20 Jun 2025 00:35:17 -0700 (PDT)
Received: from thomas-precision3591.. ([2a0d:e487:44f:8ec9:e0c0:3bc5:bbdf:e81])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-453646d14f3sm16091875e9.13.2025.06.20.00.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 00:35:17 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: inside-secure: Fix `dma_unmap_sg()` nents value
Date: Fri, 20 Jun 2025 09:29:26 +0200
Message-ID: <20250620072930.8223-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `dma_unmap_sg()` functions should be called with the same nents as the
`dma_map_sg()`, not the value the map function returned.

Fixes: c957f8b3e2e5 ("crypto: inside-secure - avoid unmapping DMA memory that was not mapped")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index d2b632193beb..5baf4bd2fcee 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -249,7 +249,9 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 	safexcel_complete(priv, ring);
 
 	if (sreq->nents) {
-		dma_unmap_sg(priv->dev, areq->src, sreq->nents, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, areq->src,
+			     sg_nents_for_len(areq->src, areq->nbytes),
+			     DMA_TO_DEVICE);
 		sreq->nents = 0;
 	}
 
@@ -497,7 +499,9 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 			 DMA_FROM_DEVICE);
 unmap_sg:
 	if (req->nents) {
-		dma_unmap_sg(priv->dev, areq->src, req->nents, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, areq->src,
+			     sg_nents_for_len(areq->src, areq->nbytes),
+			     DMA_TO_DEVICE);
 		req->nents = 0;
 	}
 cdesc_rollback:
-- 
2.43.0

