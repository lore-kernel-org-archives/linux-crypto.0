Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A5340260
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 15:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774884031; cv=none; b=pbydsD0YklgbeYv3LKV66a+1sP/hCsgkzdv8LHfioMA0kdkcQg//QtwiBS82wXu68pw1OmFcK+WsbVxhmCZqKnGbjyXae139OvAuNZ7KK8QzZXd6Q1rvnw5EQTAo6+936VbwATAfHCYfBRWfAy+loSvvu4sx9bgoJQzjr4mr6LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774884031; c=relaxed/simple;
	bh=zaYZzXfNb5Yh8uDxRqRlNV+NT11MzWt0MOXKtvGWU2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rWjth/II1106T13R5UMQQjzanc0vdCXlLfZkafBJ2tO4DaC7eZYeetlOW7vQpcZwJCsnMATbvvpLC5/oz08SpmFlOamAJbU0X2VYJj+m5vBGdA+iSje+UvMOBZs48FoYAAaKJ6u6uuVTanTB0dN4rjBFw/jfSAIMccTfg6La0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kdfF/Qnq; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kdfF/Qnq"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so6215185e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 08:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774884028; x=1775488828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sDvERDZoAlGyHoO/AmLOjRnD9UlryXe2PNrEtyg6T8E=;
        b=kdfF/QnqU1ROaamS1piMLKusCEuszMSB0Gji+sPdcN9y9r5ZSEz2/RAS750gKsmUte
         hwDakI0sD3MNcfR9c3VHQ5o5kjjCyGILxBGhfLNu+jyriu/bK+amjO6HbLQFfVek7/Ew
         VBRMUYFmR0zLWGxYcrxQDHPI1CPi1tH5a1757jBfFiieMYVkYCN3V5R5YWKbFPAmWvLv
         OpjFDn/zGWmZBfVFP7Eb0pGCbuLxS6+GZUbrUVKbdtV064fc5CPP28ZYze/TaA+ga832
         iouKK1SlA0p9GxIXRFWI+fZRyGB68nMxGoj99JJ2MIhzbU5SWZR33TOwVxjfkmd4Z3BU
         GHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774884028; x=1775488828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDvERDZoAlGyHoO/AmLOjRnD9UlryXe2PNrEtyg6T8E=;
        b=nr63lNkXYi+IC7mvnaxDlOK+YzB7CIKrfb+sKvFCsJ54dxs/ixG3iSADlelFuLWBLQ
         UR7+DX4Qj+J8MiNL9CRVCeC8Mr/NwvZkoiTD70lxMANqTU8uXYf8bWVXQUeYzELM8snh
         KkPCxDba8npKJelgb2k1GD1PPDP/FNX3YMoI2bjOpNv45NQWRUHuyZ0Iw5mHTqKqTguI
         2gIczFdp+ByOgXS8RqKz2+Nazw5HiXgV7qeoPzvQnbLBvY1CY/rjKRMuG7RDWQ5zq+hP
         uy5IcGYb8y5ICQcN4YdzpL05r860Z39gZMMzOOzpHwHPyM4AP9jY9mXBBHu3H7wrSetk
         niuQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8V2U+iFmeuFRr5yZRFtty7kEHcWZwxmuEe9SvRkW6XlSfnhezNABDx3Ts/TkS/5GtZHkI4RPoHMSwCXI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0UkpQpvoDFByENyc//BFpOl62341yU7N06F1qbDumCgq9/pQh
	T25QLJU5AEItxs564lvl1hhtf72xrlGYz5Wm88CBkzo6raHaVirk8uPY
X-Gm-Gg: ATEYQzz38dGAwSoROCPGnrHB9pR0kxD3oy22ZmnxrohoY3vgC1+hnNWaAuepaoACcid
	JL3cFst/p+HOMG0iQiY/qlYl7ymegrXbD3osYg7XT0UU0s3CGGFMcKTvUYpD8Sbwcp+jGPicl9Y
	p2YI2nUIroLyMxfln1LMgAXdoNGtiSrpQz5DGWCqC/Wd7YYbEXhy5vOre6tuItR3fPX74m0lele
	3LUxuR4Gz3ny4YqzVvUBnsvaYwUxkQUf7sSs/XaX9+hIKLfZL/CsxXJojG4IrmMlL513PoYMdY8
	BTUJhVxGXmHJXSdtkZJDGT543c5WN3Kf/TtHkJxAxpMl5hrsBMn7KrBC2e9SsSOkfANtzYIECZl
	7NBIurtUMTNCheqbDGnqTooEae9m1sEeaej5Ccv1873/Tp0XIvZ88RhwwEmsbas+GDbjt3Cja5L
	FKMGRM3mNWEBrxyT5WENzCVYG8FbuTyAHCHumTlfpEdBCzAVoLMFFkIqrA0lgD9YxQ1eUPYRl82
	4X1FLsO/G0719ybjGLg
X-Received: by 2002:a05:600c:c493:b0:486:ff8e:1911 with SMTP id 5b1f17b1804b1-48727ef0319mr107582435e9.5.1774884027689;
        Mon, 30 Mar 2026 08:20:27 -0700 (PDT)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-82-131.paris.inria.fr. [128.93.82.131])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-48722be608bsm430820075e9.0.2026.03.30.08.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 08:20:27 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon - Fix dma_unmap_single() direction
Date: Mon, 30 Mar 2026 17:19:32 +0200
Message-ID: <20260330151937.83837-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direction used to map the buffer skreq->iv is DMA_TO_DEVICE but it is
unmapped with direction DMA_BIDIRECTIONAL in the error path.

Change the unmap to match the mapping.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 54e24fd7b9be..85eecbb40e7e 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -844,7 +844,7 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 	if (crypto_skcipher_ivsize(atfm))
 		dma_unmap_single(info->dev, sec_req->dma_iv,
 				 crypto_skcipher_ivsize(atfm),
-				 DMA_BIDIRECTIONAL);
+				 DMA_TO_DEVICE);
 err_unmap_out_sg:
 	if (split)
 		sec_unmap_sg_on_err(skreq->dst, steps, splits_out,
-- 
2.43.0

