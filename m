Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797227;
	b=RdLUod15AqhRDm313G2X4vTWOa29uPyS77NRzYPlDk3mgjqkwzcrxXtKKibuCbouM3Zi
	 CDb41fQObZi+fQsNgZjrb1amt5MlH6U1fkFggLDE1UZGrquvo0jvSTUh0vUT/m2Ez+NBA
	 p7N/XqJ0QzZMQtEVU/29x/+bIV/JbMVArWw4es2BVRIZeMI5awdnZ0bspN6+gXTC9X9w2
	 P5iqzAPgZffnO8Aqo4DYVWEZ2HxdsBjWakBKFePywTjgD1RexxdGB5fImXYVSLi8eMFWx
	 XFQ4XS4XO3czWIDPeeCuspyrDl67rB1c9or7wWl1EGme5AIywhWwOcN5vL8JhZ1OH4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1XLQrZEkqD3KAW0Mn/q6lYR9t6l5fJC8NHgRNhvLrQ4=;
	b=bX4pNhUG5NBnN+Ar/FTOEUDdCJHFrGuMirma8X5+/ueiO7l7v3LvWU3hOMkpdMSrS8vy
	 usrhk81uPqEmE3RNU3qKEkWN3wLRr9UFIgU8ibvIhjJoNJfzWN/VIkvkGPo36f7ZWCVjZ
	 E3D0/PoASPFlLe7WvHMio/+1wytIAhMtYMgoicDJ3Jx0nZaYWbARZAVoxJbs04KPaLekz
	 LdrcrIZzTdhJCULDvM+F+VT5D646pWLKZHpeUC/bpQBIAZVTfqhTg3Q4IxBFX5+l3yP1E
	 qF87CKKQO+j+l5kKWplrknaN4/rbZSiaQQdp/Dnw9MbA1QlDGKQ/omjMKTdaWAoGRLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=POAI2t6Y;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CD4606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 16:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2CD4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=POAI2t6Y
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-490b7266f7bso411579f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 08:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795797225; x=1796402025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1XLQrZEkqD3KAW0Mn/q6lYR9t6l5fJC8NHgRNhvLrQ4=;
        b=POAI2t6Yksv847KU/d1+a8CxhS+qXpwb2cp+WIMr5z3BjZ7EansvWNFXz4RoxU/OeQ
         F7WWlduc5aSQCN+8bBhexnPNVoJ3qsKXuEvhvWJ83Kq3u3FvA9uwjVMw5MCwoHIKcWeW
         rMDsZtIM8JVDPjEIWQzfW14A1pvwwe+CevWBQic+kfA5pixJVT/NCYAi/aR+KOoBNvUB
         IjGiX6b+Q3ICYcwrQ0hrYqzimfLejme1OYvbM7z74bt3NFhImSxOOfLkhxiDiqbeyCCO
         fCf9BmobxjVS53HeNfEg9hU5ibJ12l9b7kqfHTQ/wYhITX7a0qKmpl2Q+qiljRJZWboS
         EumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795797225; x=1796402025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1XLQrZEkqD3KAW0Mn/q6lYR9t6l5fJC8NHgRNhvLrQ4=;
        b=fcdu9MSJfyzK7DR0by8iBbRlmf7dAwEfkdHyX68pTreq4rjR8yNP4e2Y+NWhehGdyx
         m2Td3GFMYI4KVKHIaOX8esFJGBGJLG8WlctBvFiIB2hpNSDF7R5axcY5oU2//bywkWKV
         7WYQPDXL9B8CXOTn1/W4i+OdHnSie/WHQ2cZp6uUSHhUhmbposCuJLfEvxsydXk5aAIY
         N1Jo8Aexy3VwcT8cUrn8axCkDLUJ8QUZXLtKQGNjimt28S1qKUY64AgUyx39XL/ThmZf
         eGkFGB75nYxHfOGrFcQDO5s3zYobYOR4jzSIu7OVPbz4qEu9wHCqX5KqdOnFbqIvUGzp
         TJ7A==
X-Forwarded-Encrypted: i=1; AL+hErGouOyPFJLr7QLxxIKLUl4in7wxuxR7EqZS7Z+snjbzH9R11BkPanDYJC5ZIcMf7N9WJjsqtR4qGpnTFzE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ql5euO6i7zEJ8lLcSoUDHaU4RHaRSsopUH0VKOnOiLKiw7Hs2
	9RJzZ3XhrrvewIFGPBN9EDIHDnPWdV4/W5TgYXWer2eo3yBTD7sKCtCa
X-Gm-Gg: AZFdTZcfz+JInohA4MaVFqDn+QM0EhamAY7fCZUFD2S0PPtZMWAUWwi8qhG1iU3BDov
	9vAI7C82dk4kgHwyCmy0PMaqiVaG2oT1eVwmdw9KQOmrknjhN7nVSs2wzQvq1KlIUyaexZMAq/K
	JiDwe2a34oL9W9cCTAMI5VorpfU3Eh2sBEqLjZmScQKFNjLAPiW4eJHLEIdlHfPAMhbXW28Qu6f
	O8jBgZYYfoeSFR4d2vfAL/7hqJb0N7fEz2FaslaN8b2tXI85YQCoXBHkiMYwz0RuGg2FEfYrcpf
	xKPV5oE5wwxccb5wsN7sw1q12R6scjQKM5gYpT0z0t9n/Ct+6w2s4pwJWRxUwLe6M6A4uxa/QCY
	AkvTibFruzXCQHB2DgPTAFeCx6Yc6Ce9aUadm/95skgd9wm6WUZTsDansjCJ7K1MFjJ8LA96yXN
	XAPAoUSWnuulbqSwwITtrnPnJsKit5WKaATqaPRxVsLWY4Nb9H8Fgv5QAy2bzzhxi9aYEwwvbDo
	qmpInwC47H7J9rWsXSfS0OjYz8Pvls1E11d8oWsZA6HN4bZWYGwkMLJHoz4Bv1NXlaoqS+R1xmM
	3i79Tolz4y72PSJUTmZ/lRteMT3B8qzxfctL6F2p8mwfKsIRlwAJGSVFidm89TzQI8F96QE6DKQ
	8pA1Hh7kW9kldr1SBE9o=
X-Received: by 2002:a5d:5f88:0:b0:4a3:45b4:f0cc with SMTP id ffacd0b85a97d-4abb253e271mr45139769f8f.3.1795797224935;
        Fri, 27 Nov 2026 08:33:44 -0800 (PST)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-006.paris.inria.fr. [128.93.83.6])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4ab6a68048esm50425276f8f.29.2026.11.27.08.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 08:33:44 -0800 (PST)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Harsh Jain <harsh@chelsio.com>,
	linux-crypto@vger.kernel.org (open list:CXGB4 CRYPTO DRIVER (chcr)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: chelsio - unmap the IV with its mapped size
Date: Fri, 27 Nov 2026 17:31:49 +0100
Message-ID: <20261127163151.59138-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chcr_aead_dma_map() maps reqctx->iv with IV + reqctx->b0_len bytes, but
when mapping the source or destination scatterlist fails its error path
unmaps only IV bytes. For CCM b0_len is not zero, so the unmap may leave
parts of the buffer mapped. This may violate safety garuaties provided
by IOMMU for example.

Unmap with IV + reqctx->b0_len, as chcr_aead_dma_unmap() does.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Fixes: 4262c98aab95 ("crypto: chelsio - Remove separate buffer used for DMA map B0 block in CCM")
---
 drivers/crypto/chelsio/chcr_algo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index e2f2b2a6200e..ca4bde6b7b1f 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2544,7 +2544,8 @@ int chcr_aead_dma_map(struct device *dev,
 
 	return 0;
 err:
-	dma_unmap_single(dev, reqctx->iv_dma, IV, DMA_BIDIRECTIONAL);
+	dma_unmap_single(dev, reqctx->iv_dma, IV + reqctx->b0_len,
+			 DMA_BIDIRECTIONAL);
 	return -ENOMEM;
 }
 
-- 
2.53.0

