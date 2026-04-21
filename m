Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B16274B46
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 09:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776764706; cv=none; b=R49iJF+BEE0hAbqjzhnhz5N9WtTpK3NFNgWR2FVXTQH8CyVwVeP5BZDwVW9cC9TI5Fp5XJcfnLUh8DZaUUu2bQioFk5pR0bC2E2S9RuB+rb9P+6DiKyIgNE64GK9gW4j+M7FfZ52R3whPiLD4h1EvA8KMn2bSuQHdv9bqEOlb38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776764706; c=relaxed/simple;
	bh=wWRC36KWWwFbbnT4QloUdLOrZzDIPevpQj8nJ48WPek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fK/LhmYGW2PeAa76J2Ys1UwZkgg5Gxeb5HDlWxjMYaJ9k6kMY4UDa5HucHrigaYu0SZt2sUuVl7uYTr5ZC5JDHg1dxvC1kJ1sLwMkDKy9iYa7GyoCp8Vdar2d3z82Sd1ItX4A+pUOJ0MzY8ETB9/teGHjKiuBJP5PU4B8QAloOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ma4xpiJG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ma4xpiJG"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82f8b60e485so1663706b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 02:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776764705; x=1777369505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eVBypKJw+Ak0MJauOtJvmP4dIZgy02ZaGmQO+Q25Zt4=;
        b=ma4xpiJG43I3hFkAf0AS1AVWGTqa5YFZbKXKZP6v+rCDRvxVdjxZgEF+4bm2HlvS/u
         VR64tGugpOjsQVoiHm1S/1+HtBjpAjPqaKZ8kMpM35e9Xab6asQagfOBmzTALQpRq3Sv
         W6ALSBw68HzkxG40upRvgyoFU17uZMcnBY6PnsgfsyI4FdqmFzA19uEMaJ8xOIVJGaLl
         a5O30xWkRvMhqg1vzpg4D92VlQYd5O5qwK7H3W/QM0PVU4Jnsp6YPafpqR2JG6Bf/NJ7
         1yc1Xb37qGf2uOyRPMrlYeyPoUq+gVG/5PaD2PJMlAWl6Wsc6cSqWlITXS8cvFmPfHat
         Kd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776764705; x=1777369505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVBypKJw+Ak0MJauOtJvmP4dIZgy02ZaGmQO+Q25Zt4=;
        b=JEzizF+dAfkhdCDRfMDy20gTiKnvJtUFTI0y3en3nQkPl/5yS14nu7AM80zOzn/xWU
         4NQmor0jZDIHpT/lv3r/bbU67xcMNWs2GmScQJ7zbKJzmX2e8mZ33agyLNehjblnCqeh
         wIzsI6PRNUAfO98WI0XJWIbQC2xGXjydNDWUcsxFS+hoeq8NctfavXsPwiwlCYvZdBln
         3I3iBX4lECuYQN6qdC50xcAx74xgEyU1scYFvS594BmRpG+S3wSRJAzBQtz9PIN0TU1x
         mJ1K4pG0RdfP9nfKNnJz3mDM1wF7yu9Tz+KaWjwKCFKzb/HDp4M6nsg0pv+i+++ffVcd
         ecRw==
X-Gm-Message-State: AOJu0YxGqj2GxJIioBqc5ZsFSJwZRC5s1l2mIiEERv9PLPY/MvB9GE7H
	lKUqhrMnjtb3RRoIZK7VMWJQd7/L5yhPsXzxmlSBNJgHtM7ddEDP5UmS
X-Gm-Gg: AeBDietf+jnhfC0k2F7ebeVADVZ574GuwSowXYHN3jGPQC2BHPrNuy1dqz47ELh94vr
	81JKszPD2lMdZtY83k7K14LeA3DqYWincOmnAKrUVwHKQyfKrx5rWGOECdI5uP5wV4aJztZzm68
	2YXQTYZ765gHmi5Yhg8USIKs6o/61/HN+bpyWMbypoT4qXAcgFjE/Qan0l3wCwd0ex1pbIeCfdw
	7phrwEgrxTS9ath73vRuXlP5bpF0zCmngLC6QUvYjjo5KsujlzMM5cA4HmrLkGpgIP1ffNsAnwS
	/QioaPZVtCEwvMfvKQNoAHaHzQPkaXE8ZhO/hHd7AcY2JGkPbi9pUq7lRBmG5Ysj4xconT23q4e
	PfJhMdqNl4qu47rh2eb+v1DedRQDk6vUjQ+cKeplyuFvqi9LL/IvhOA/HIBjtBSDw9jU+R2iL10
	Cxb0Vp+y9FGKz2+QXvPbuiPWuatCH4/kyGb/3was7KgalsVTiuKAdtvMNKRUU/2IU=
X-Received: by 2002:a05:6a00:2d03:b0:829:9f46:280d with SMTP id d2e1a72fcca58-82f8c87db23mr17788188b3a.1.1776764704749;
        Tue, 21 Apr 2026 02:45:04 -0700 (PDT)
Received: from LAPTOP-CUCB24GH.tail9a93e7.ts.net ([175.159.176.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebb3fa2sm13292215b3a.29.2026.04.21.02.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 02:45:04 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: clabbe@baylibre.com,
	linusw@kernel.org,
	kaloz@openwrt.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] crypto: ixp4xx: Fix null-pointer dereference in chainup_buffers()
Date: Tue, 21 Apr 2026 17:39:17 +0800
Message-ID: <20260421093917.1001688-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chainup_buffers() builds a linked list of buffer descriptors for a
scatterlist. If dma_pool_alloc() fails while constructing the list, the
current code sets buf to NULL and later dereferences it unconditionally
at the end of the function:

  buf->next = NULL;
  buf->phys_next = 0;

This can lead to a null-pointer dereference on allocation failure.

If the failure happens after part of the descriptor chain has already
been allocated and DMA-mapped, the partially constructed chain also
needs to be released.

Fix this by unwinding the partially constructed chain, resetting the
caller-provided hook descriptor, and returning NULL on allocation
failure.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 24 +++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index fcc0cf4df637..63ef28cd5766 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -874,6 +874,11 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 		struct buffer_desc *buf, gfp_t flags,
 		enum dma_data_direction dir)
 {
+	struct buffer_desc *first = buf;
+
+	first->next = NULL;
+	first->phys_next = 0;
+
 	for (; nbytes > 0; sg = sg_next(sg)) {
 		unsigned int len = min(nbytes, sg->length);
 		struct buffer_desc *next_buf;
@@ -883,10 +888,15 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 		nbytes -= len;
 		ptr = sg_virt(sg);
 		next_buf = dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
-		if (!next_buf) {
-			buf = NULL;
-			break;
-		}
+		if (!next_buf)
+			goto err_unwind;
+
+		/*
+		 * Keep the chain well-formed even on partial construction,
+		 * so free_buf_chain() can safely unwind it on failure.
+		 */
+		next_buf->next = NULL;
+		next_buf->phys_next = 0;
 		sg_dma_address(sg) = dma_map_single(dev, ptr, len, dir);
 		buf->next = next_buf;
 		buf->phys_next = next_buf_phys;
@@ -899,6 +909,12 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 	buf->next = NULL;
 	buf->phys_next = 0;
 	return buf;
+
+err_unwind:
+	free_buf_chain(dev, first->next, first->phys_next);
+	first->next = NULL;
+	first->phys_next = 0;
+	return NULL;
 }
 
 static int ablk_setkey(struct crypto_skcipher *tfm, const u8 *key,
-- 
2.43.0
