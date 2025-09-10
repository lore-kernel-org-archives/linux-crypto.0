Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5A3309EEF
	for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 08:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757493297; cv=none; b=lLUoePPW+OgAzqzQzDT9SLpo2CBZaWxl3EMzddpR2+1rgNSLfVdsbG0wvePQErMh7GNMnVub17GcATBTlJMlmVRaekZ0mfzVqLZfBMzlMB62PML4YSNQQ/wXwTChoqhPeGdRzD5q0q1xlZb5BrmKFUt+/Od46J4tZsOty7vMynM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757493297; c=relaxed/simple;
	bh=SpvRzD0bOjvGf2Nx8OuBFCP4M+Ir0Zip7/CfVuzu4QI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SJco/PVuQcrGb7LUDjX5NF7KklwEXewdixA+boY5Xi6Vlv/TSgNjP9QZA7SQVFKifsmKUqsmN4pzbr6nb+kx3ar/UXzQD6faibmub83iOHLaRf3E9n+VJWOoYAFLP1N4HTuf/Nx7l+L1E0W3wdBwkWSlq0AbpO+wIFY+9/xlaaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AzTNt0/v; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzTNt0/v"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3e753a310a8so87346f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 01:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757493294; x=1758098094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5bYSYMP2Z0IUIJfdQoYkXYkAGdrYTGhMeil+naL+UQc=;
        b=AzTNt0/v68SMTQmrd+R2D4oRjd2K/T3QJw4jc3cYeVQVcAHf2/Ffj8oL8pFZl9TzHw
         zKqkal/3N0gD5AkZ26S8nzuEzJdtGPNvwuUtf9Nk/KJxsC0CJVfrcI20V+T/uSUY2l3h
         v6fQBm4F5s1+SV+04nCtBr1v113DuXSz22HHtuT4Plkp5zAz22MlJ53yWWXfIBZ6kW/B
         XdBUnKkZWksiYkhJRxh+aGyDKJxSpkBsZChbb7/x2V+ISIwyDTETlSa3IY2twPSPMDra
         GGO9ugqLsLmf/pHNKUTPGnHsmOSIu2SAvgiMPNwiK8dJF7WiU5YxrJiYQWSItgCTkttV
         HuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757493294; x=1758098094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5bYSYMP2Z0IUIJfdQoYkXYkAGdrYTGhMeil+naL+UQc=;
        b=ubsY4lUNpuR+/dQEOqLMqNaaJPtZoLTmQPcM+Yke1RvHIDCU2qH0I8Ge595FKt11IB
         ShzEzUoLQLXbfFhlv3cGFrt2lvLa7kGzCxRGtKJ6QrTGuuzZ8PLLfxrsX4mtmTEDlT/i
         OFb70VNeKG0kn3kTYR62pE2SvE8ouBxQWFoH7A84HGfCQL18vSZdp30lADBlLYGEnBka
         BNKednXtZiD1Xyl/UhNGUw+cZBLOqiaJWSGPVUArOjW2OQ4YIjVR8Oi2SBDfTP7LGzP1
         LfsW62Pe2csaxnGEisBIA1H38WRKfpdYGm2tFBTM3IMwyQFyQEE3HJzKf1X+iFXHPaDK
         IUNg==
X-Forwarded-Encrypted: i=1; AJvYcCVAaCSl2zT8xerhRqKCEwwCM+1nLWa8dkS67R+2dZs2h6S22SlaByWbyMTLGVof0Si4zyj/L0bXLSuTmSs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4LW5DhbRvytR560IfiPOifagV3MWFuYIJ/id6MZNPgrVCsRJN
	ghavoV9Dit5QZcDftWFlcwV//AjcZRk2T8xTI2UZt/XmLhDhoh5eT0+h
X-Gm-Gg: ASbGncvvRmYELWNYhIbhZ73bTBTHBJCkEMqa4SpaqNPYIu3sQMwBMQ59t9Ooh7ZWJ+E
	sKnmohGVp7mdXuvsMhJspeRAelKi4aw8LHjgRlwGc86tblJ7uy4AJ4yhiElsfMAGz0ITP8MOFSE
	7StZJ/5DLkNU5HqpIaiyN+PqQgv+ALW0MbdMmW15ktG0kWh3uzLPPUmmj8YWG8MOETZG8yyHGJt
	VTl7APydf2u0ncPCuBbuZbxQVdy1KWQEWM1YATr24zT+XYSpDvpYG3P4UY+FwWHYwjuXaS8SG72
	wzB84Q0bPWVNZTVTA9eJOZwoboO6a64tLcTY6gacCMYaF6kDpeKF/cvGNUdL+cstr42jjHizxFI
	GPE4TevV269nIMtYUbQ+zufVYcwn51zT5pzL0+tcSNlaSx/bFvaMMfgFsEM0aNnX7sb0=
X-Google-Smtp-Source: AGHT+IFvK6FSXou9OenUrrz/PdbIoxF3WcJL69A9lP4CdFPOW3aq92qZPlSoHiBDeanssK1jlGOOKg==
X-Received: by 2002:a5d:5d05:0:b0:3e4:e4e:3438 with SMTP id ffacd0b85a97d-3e63736d9bcmr5889161f8f.1.1757493294125;
        Wed, 10 Sep 2025 01:34:54 -0700 (PDT)
Received: from thomas-precision3591.inria.fr ([2a0d:e487:311f:7c67:b163:f387:29a1:c54d])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3e7521c9a2esm6378854f8f.14.2025.09.10.01.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 01:34:53 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Neal Liu <neal_liu@aspeedtech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Johnny Huang <johnny_huang@aspeedtech.com>,
	Dhananjay Phadke <dphadke@linux.microsoft.com>,
	linux-aspeed@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: aspeed - Fix dma_unmap_sg() direction
Date: Wed, 10 Sep 2025 10:22:31 +0200
Message-ID: <20250910082232.16723-3-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems like everywhere in this file, when the request is not
bidirectionala, req->src is mapped with DMA_TO_DEVICE and req->dst is
mapped with DMA_FROM_DEVICE.

Fixes: 62f58b1637b7 ("crypto: aspeed - add HACE crypto driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
v1->v2:
  - fix confusion between dst and src in commit message 

 drivers/crypto/aspeed/aspeed-hace-crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c b/drivers/crypto/aspeed/aspeed-hace-crypto.c
index a72dfebc53ff..fa201dae1f81 100644
--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -346,7 +346,7 @@ static int aspeed_sk_start_sg(struct aspeed_hace_dev *hace_dev)
 
 	} else {
 		dma_unmap_sg(hace_dev->dev, req->dst, rctx->dst_nents,
-			     DMA_TO_DEVICE);
+			     DMA_FROM_DEVICE);
 		dma_unmap_sg(hace_dev->dev, req->src, rctx->src_nents,
 			     DMA_TO_DEVICE);
 	}
-- 
2.43.0

