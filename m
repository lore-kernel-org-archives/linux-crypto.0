Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841C52750FB
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 05:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783919265; cv=none; b=OxwgM5DLeyS2Wg5CKmj4f0uGfvrTTDjeN+mwfUztoDslUMvEqbvhaq9IhPpIziTuFSbPrqtNjx51EoYCdIqt7v/pUgniZVBlROW4tbIVV3pcAWJANKTHD7GMKdxAFMTyi6k5lPzxU6U2k0jCQQc3wrMmgZ6Covv7/iilNjyskRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783919265; c=relaxed/simple;
	bh=efoJ5cAyPmCfC621cs0FhvyiGTUzcPIDbsIrKQKb+ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fGAZSTG1Kc9Lu6R5MORzQ4f09sy7toBG0ku/HbcRoUbBYMNqZrxGdpcEJV5T2a+3Qx/BL3Vt9rUkm5z8kDeh3WX2D4RzpiBEL9o5rVeMAL2clcfB6vW208T0ezuBWGwYiDaUIi6wOWa9r+Xsrm8uArzDJtr/iSp5kbfwW0yHta8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMytH6wt; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMytH6wt"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8051ad12d23so29068507b3.3
        for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 22:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783919263; x=1784524063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p/VdgrZQOd7lEvrg+1tcs7ObaEih5szIwnSr6YpOhNg=;
        b=MMytH6wt1VjPzwkKsEFlpqGojxj9Cnw5PqYe3mAcVE7l5GSKj4VS4T3D9yW8yqFFyQ
         Ne+Xd+UoTeyKvWv8weKCYx+qsd/UUmrJKfggIreV9sF0vfknEysL+5nrQykpEPDxryp3
         IN5kuKoA6lTCjbShaSxJIxdCDvDIdGT+OIp8KFcaetH8ynoP4nV9SiGCHtLd0l7fyiEl
         OaWhuDYhTYnhQ/s9D/3B2lm7QbCt2cZJeQ2t6ueXYcLbKnqy77raIDGK6Hw0mrxLTRDS
         gqd1S2SVzZbAXWTLMjUWkyjQjfYnCK9A5fdbgE2ZYnXCrTIc5MGIKSZLBFO2j0/kTPRh
         uNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783919263; x=1784524063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p/VdgrZQOd7lEvrg+1tcs7ObaEih5szIwnSr6YpOhNg=;
        b=RieumR/yXVTu3BjKF5m9Q5D+x2JAztVzZaZDEreRZlp/yr2BF6i/XmdcfPvEnkHPyr
         RAsUmvKaThVbG5zWXIcNzNYCg3fO49ZDh5aowWilhKW08jtcR8/0i0gLwX4wmRNTTt7Z
         KAAwIgEyW4GDiX2MgnLpb3ynW/59f7A99IPQVNNUldfwxUO0SyXhJSP0FLsorwSEybt1
         QnZUa1vd6MYWtKnyULeGg6wRaYVjaeR3xktY7PDOpLVlsXNZvmUaYbjHd5GbNObufi+B
         yN8kuLzAAsab26BqCJN+xUEKJ8GlWCNJwOBBWu5KZPmBxFRDu6CxwoM+SoDmzRWuvPfy
         YgRw==
X-Gm-Message-State: AOJu0YwAJ1i8c0xZJ+cdfjYz6YzsYBBXx+sKY37+8iLbq13fI5mn4+hl
	7033A0X37MFFK6ivQRKBRQogmTqNoR1sNnzcGny3Ty4EeBx5r15VMUuRd1p3ziBZ
X-Gm-Gg: AfdE7ck4RZzNpvyNf9DyPogE1B4qcqaKGgU7uKY0E+GX/N6rPepUhho6mMbbPm5aIWL
	g6SJtlWHKG4LZqKMSBAt+kldwvAIEByLnU1IHrwrnTHYDE/LMpPzzInJvw7up8R5VLDoVkTBFjp
	fllKYaDYpOK/9oQ6pmITV6F03cF1zRhv96GkGZ4dNFEjDkUTiZIRUcIzOq0XsjsVZ9CRly0JqkF
	eIyh9FpVdyp/ksWQSojK31LsiuLvTwCmX02EoPaqIAOc6aLthvF1ZEPA00KLKbAAJi+/SdWhDDU
	EAi59IrKDrxcGZF95nObHfIB4B7qxJ1lBMT1fqg5SHk2jCqZBT/6CL/hn1YXgXziNW9AU4oJsob
	nFyYS/+FzwtG77hfpxg0753zOkyoeQSEEUBnBtGiBykKPxdH8ciMfyBZ2kg8ACOITst2fzGr7+j
	nflzYpJtwj+7k3RDRTrXkWHtJHR2OBJxiVyMfpSna0IWwq2IyJCMqoLoBmjWwEaw5zUx+OinEF1
	3SR34lDoyh5JSAsmFHRrXTN2rRgesCPyMZ4QvyH3ILHZMmoWFN9iPmgtaiUh7xQrw==
X-Received: by 2002:a05:690c:4b8c:b0:81e:6d84:8027 with SMTP id 00721157ae682-81e90033c25mr55816767b3.22.1783919263535;
        Sun, 12 Jul 2026 22:07:43 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6c22ed8esm105489487b3.44.2026.07.12.22.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 22:07:42 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: cesa: check for sram_dma NULL
Date: Sun, 12 Jul 2026 22:07:40 -0700
Message-ID: <20260713050740.3687230-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dma_map_resource() might fail. In such a case, don't call
dma_unmap_resource()

Fixes: 37d728f76c41 ("crypto: marvell/cesa - Fix DMA API misuse")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 57c9295be711..bcbb909c48d8 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -406,7 +406,7 @@ static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
 	if (engine->pool)
 		gen_pool_free(engine->pool, (unsigned long)engine->sram_pool,
 			      cesa->sram_size);
-	else
+	else if (engine->sram_dma)
 		dma_unmap_resource(cesa->dev, engine->sram_dma,
 				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
 }
-- 
2.55.0

