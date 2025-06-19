Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E533085DB;
	Thu, 19 Jun 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750346943; cv=none; b=cN8fZz9uWBQ75euD0yZgDfVglX17ZuaWgjV3faKiZR6iP/KfKzs3fOXOvhOa6SfCiPjUnXkWa8IixP20GUcme/KQ1qmr0T4QRohrDDJAj6+7fGwo18CPaas0L1C2K2mBhwncdn7ygoWBoqQPLjKJSVFAY0fnvX3B/cl3ueXG+a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750346943; c=relaxed/simple;
	bh=uLayjOda+JdH9N+Ha4k+1m0ww499qXcNEPzCrwKzI28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AqWcx0iPhLUdzBvKZjOYYyik3m9m3hx/fX+8Kg1FFLo/VWD0Z8d5gNrEnDVuD4EELGwsh1gIQuPbpX+6jDo0O9TTp7hPIVnucEz8q9tvK9VzadP1gYx3UiZWxYSKS4WSvfBmBEXId58j/fM6VGUOsMvmOZhDDU6vQ451czKEOy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRVD7+UN; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRVD7+UN"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4531898b208so429855e9.3;
        Thu, 19 Jun 2025 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750346940; x=1750951740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/slM1VLvNtE9LZ3cjdrqxy5oIQVtpGyicT5X+Hl0SkA=;
        b=DRVD7+UNUpwMap16LUg9XW07mosd0YyPjGdSrT0ug3YtjHPJyYq/3R61p/qX4f657S
         gj5koOZCI/ej0IGpF6Ovp6oNALrrZ70NkPcplq37jHAj8SFsfRRYp/pL6ckoDLwD9TYZ
         cvEuDMVcWUxJRDwbSMHY7j9Ut8U4ebhmcFZowM/NP0gcIVYykESfvgYNU4PpBXZMhZvZ
         dTM4LlQRHUPa7ZHYSjVyM+HWnIzOZW9x3eMyFxaDfZCFOl5BFIYZzGVKDzkxRGmKZqsi
         cHE8CyYDZOQto75OTHK72AThbnj5Jo8qKrDVhs+vuqI6M2e5mWE4Uhr36TRct+D6aUPs
         iILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750346940; x=1750951740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/slM1VLvNtE9LZ3cjdrqxy5oIQVtpGyicT5X+Hl0SkA=;
        b=FFnYOW/ft5hffr6P2UKO58NlQK5fVAyff+kc5SLKYIAkmRvJ91fVuay6dDdcUOf8Md
         rsbKX5mmO0v2BujxT7EzV4JnhPQpfxKVXJRMIEjeHLVxu97CHwDNN4I2sEJzch0Yb7hW
         3dv5qaEKluyjWn5qrgay59ezXFx5QbVf8RnHyVKDJoAlO6lQ+kUo030MSdLRgXmriRlN
         mMBOfLofMwUSwzY6tPcv+MZ78XLSDn6OosEb839HjeoCztqjL90Ig8jMcKcqfhkpv1C4
         9RRtB6WJFp6ncoxOjyrDalSOJIhfwT8ja9tPtRO47Dnl/mAj2xLWJWiS2qYttqWTaPrl
         jTxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBGZpyumlqE4Ggi/mrJAZOvsZAnvUgv4ReZ388NMsU7YKPywx1m51pYAeJzAFcbLrv/QrcNs2ZStQcoYWR@vger.kernel.org, AJvYcCVE54WeD27R/AQaCboLKqWxJQw/ffV40cYtjib8A6LpAQl/nnZtjInAgnJRtG3Ft4cYwDXPDYGsSbk5ZTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YySLw2V6kpgFff1+gb03QcmM/eiVxIZ320BBlMTEMoONdJcBCDP
	9xf8LkKeQNIK9uag+JmAEuSbXQET4OCqZ0N6m/jZQy9GxJuK+M5az96/
X-Gm-Gg: ASbGnct8bLU4l4XjBkSY+Ne31jLySiKB8jIHaqbc/1sDQo+llmIBLgaZbnSVpvT9xQo
	YPaTmABtgBpxQJ3eMM+IwFwld4IFaxTZZ9gioNAP0T+9f0Ykb+wnN54hvqxiWIzssSGwF2+xh2y
	EWfRjFLsbDqBXUO/0bKEhun1zGMGTvO8yvnAE5mzWoqfbG+TZcvodyfzBBfQRtAysao96Mt9wN0
	lxI7cPZIddq0JkcjVncN0IGzO5ttowaLZFBCiRGSL10YBRbPuOt+VqqKXlwXRk5JBq0uZgc8Nnr
	fuEpN08C13rCm0qDKzGtHZsd8DTz09qXJTqjIF3/rn4efxuNdXznFQF6R/0yXk+KnPimNgAbPM2
	cKmTP9FoX6FSLjs59s7abyyqCZvMVS/p3hRkA6/lZlMdzzMZOipw6gy85HXGDOBkdFFUA1yHf1g
	9MHsitc+zoKQ==
X-Google-Smtp-Source: AGHT+IG15dfCwnBTt8OxmT/F7NrdFhJDq2Qr5JR3JFgsAm9i8HN8pMww9BrOgXeQHVTDDa2ETMnlCA==
X-Received: by 2002:a05:600c:45c8:b0:439:9c0e:36e6 with SMTP id 5b1f17b1804b1-4535f9c1880mr12381255e9.3.1750346939483;
        Thu, 19 Jun 2025 08:28:59 -0700 (PDT)
Received: from thomas-precision3591.home (2a01cb00014ec300e6d7f532784aebda.ipv6.abo.wanadoo.fr. [2a01:cb00:14e:c300:e6d7:f532:784a:ebda])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4535e98b48asm32633925e9.16.2025.06.19.08.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:28:59 -0700 (PDT)
From: fourier.thomas@gmail.com
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: inside-secure: Fix `dma_unmap_sg()` nents value
Date: Thu, 19 Jun 2025 17:28:36 +0200
Message-ID: <20250619152838.349584-1-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Fourier <fourier.thomas@gmail.com>

The `dma_unmap_sg()` functions should be called with the same nents as the
`dma_map_sg()`, not the value the map function returned.

Fixes: c957f8b3e2e5 ("crypto: inside-secure - avoid unmapping DMA memory that was not mapped")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index d2b632193beb..1ef1ccfaaa95 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -249,7 +249,10 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 	safexcel_complete(priv, ring);
 
 	if (sreq->nents) {
-		dma_unmap_sg(priv->dev, areq->src, sreq->nents, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev,
+			     areq->src,
+			     sg_nents_for_len(areq->src, areq->nbytes),
+			     DMA_TO_DEVICE);
 		sreq->nents = 0;
 	}
 
@@ -497,7 +500,10 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 			 DMA_FROM_DEVICE);
 unmap_sg:
 	if (req->nents) {
-		dma_unmap_sg(priv->dev, areq->src, req->nents, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev,
+			     areq->src,
+			     sg_nents_for_len(areq->src, areq->nbytes),
+			     DMA_TO_DEVICE);
 		req->nents = 0;
 	}
 cdesc_rollback:
-- 
2.43.0

