Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291F8224AE1;
	Thu,  1 May 2025 19:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126462; cv=none; b=E/BWVB8BSdPzHNie+dF2bukjq6OFCPZJaPoqo0UTaMjKqUaIz4/UARELiHDTjei51Me7Ax651hI5gB6xgMUj6t8tb+8DwPs9ZF8Snz78B0Yg1bacX/E/Q30HPnqFO4DYqlGBZFikbAgiJAhgTdbc9fO4TRv6lxhPxK9xmTxzT30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126462; c=relaxed/simple;
	bh=YXKPVxRR7Upwwq5LKZvZEYOzYl8UfelO+cPhSJKCGp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLwtpFBh+nM6H4yMAofChvznPIXz09OpeNjLQ6zX3SWxAawZ42COmx32jDBsnat+rPL9Gdgt/COlfF6JIMcxW1pkGvBc26EzQ4AJY+PNVEKOXbTGJCQsSR8WQO0Fy7dyF/P6+vahbiOAc+xRS6UTJ/BxObpVSTI+6DOnJpApHkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dzydkw8o; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dzydkw8o"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac7bd86f637so437002766b.1;
        Thu, 01 May 2025 12:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746126459; x=1746731259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qsp9CaqkI2nnPLo+C7isQc9cYVKQaKUwpPDF4hWhLBE=;
        b=Dzydkw8oe0zA2qq+AEJuUMC2BMe68TM+uoaJBq9pdiDKYKY8NHPQByUGUf59GUPsTm
         mKn0PbfxQKKM1UhON43qFHmJFDlW91ueVd7FYSUYWj++eJ+qhu/Azx9wNIIMdp06W+Z0
         lWKUmkjJAb0OF5n0S41vSWLJYe7YkXxjOySYroFlzroje2rdV14CPuh/2uhrOjIfl6ht
         RTBuzaJPIylNtVfDOtPPCuN4EAw8Fdj6F8j5qU6CWFYmhZn91bh1gS1ueShCZwicrsV3
         XBIAZCeBYaMD4LkosZKXO5kUMmMh3BaPl8rrhWZP+ZWfYMjYbRCjK5V95ZPLC++H2NQJ
         Bukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746126459; x=1746731259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qsp9CaqkI2nnPLo+C7isQc9cYVKQaKUwpPDF4hWhLBE=;
        b=nYPu2SqeSzlNyR1uoc/r0XTDoWsGyf3bWMLhxSzDEsGJ77eOCfJt2wWf2hjw8FqBoC
         k5mcs1FE3YWnPaSggzgJOqQoS4zDhXIyoIXFXc3TN/ufQzHoFktp878bKB4G7+iG6kTw
         csr+A7UwWlbpNg7CSi9YZy8zdyr/eGbasvm/AXuupDs4boBQJMDwuyQ8dQ/v9DugBLuJ
         KUSAKXLweVHz5fuEgWQRrxTyfO9TSBeMbdzVk+uHnYOL2RuC8bDGhitnVYEyNZDZ1Q4R
         ErYW+yjRxBJVeqRjSg3vDg1EaFNgeEFpKpYXax022MmHWg4j4i6u1ZnoaZWNj1ugq3l6
         QvXg==
X-Forwarded-Encrypted: i=1; AJvYcCU3gQFbeB9+xvZYOZKcsx8L+anS9O/pVb6cBCGM+U36iA460H6O0lOcS+ry1Jp6ZoOC8nmUbwHKNUUffDha@vger.kernel.org, AJvYcCVPXGk3dUly3vbyvDv7d3bpPOwW8sL21YIsWOJsNcwcbIQVCGZ/hzV0KsJ1yWXJP/3j+pEzjWqAiTMPzeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK4bI1bzsc7JPUIinysN2TZ6KtxiTic8Q2NQR2mrt9307wmYy2
	GS8TiA6KjXAP+qV6S5/ME8/QpAVsNTU+wAg4vUHpw0dmzVcvNK05
X-Gm-Gg: ASbGncs5WTlo6wWUOh9lgn+9PTKroQOoE3vyzgYuQ8EYqGCfVxWIct+h87eXYlZcS+b
	xLXgi+PuPCUzdYz2Dib+mGXxdtiqwbQMhrWIlI3b1NK+C29ZG0D2opbyClgE7AYSObmAMr0w+4O
	05kJEQVdlaYduvPv47eW5GCLK3m/Sbf7I+MvsDb9Lffh7qiQrB5+28KOWDm57760b0XiY4uNs8U
	rMBGtmvyQtpi3Ztj8AhFSNFGMLKXtdEhQXUC+Yb5a0ZeojkZFcfRqzzTsHVDFT30ZZ16t6dJ8tj
	FRw6aHhVVBXPkJr9oHr2O5y2H/tYio5pV1uuVC0ELE6Hd0VelsgSorenBy4/V3AK/JEB
X-Google-Smtp-Source: AGHT+IFPbjdkqPWUcDwWn3gcKgKCDuCT59+nrEo/GOkvbNTeX+sbsXL7iBibXH8JV2ff9RTUgMaADg==
X-Received: by 2002:a17:906:4fc5:b0:aca:c67d:eac0 with SMTP id a640c23a62f3a-acefe63defemr318866466b.0.1746126459184;
        Thu, 01 May 2025 12:07:39 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0c70c6917sm80349266b.4.2025.05.01.12.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 12:07:38 -0700 (PDT)
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
Subject: [PATCH 2/2] crypto: sun8i-ce-hash - use pm_runtime_resume_and_get()
Date: Thu,  1 May 2025 22:06:51 +0300
Message-ID: <20250501190651.3863582-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250501190651.3863582-1-ovidiu.panait.oss@gmail.com>
References: <20250501190651.3863582-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace pm_runtime_get_sync() usage with pm_runtime_resume_and_get() to
simplify error handling.

This is recommended in the documentation of pm_runtime_get_sync().

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index ba13fb75c05d..bef44f350167 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -65,12 +65,11 @@ int sun8i_ce_hash_init_tfm(struct crypto_ahash *tfm)
 		       crypto_ahash_driver_name(op->fallback_tfm),
 		       CRYPTO_MAX_ALG_NAME);
 
-	err = pm_runtime_get_sync(op->ce->dev);
+	err = pm_runtime_resume_and_get(op->ce->dev);
 	if (err < 0)
 		goto error_pm;
 	return 0;
 error_pm:
-	pm_runtime_put_noidle(op->ce->dev);
 	crypto_free_ahash(op->fallback_tfm);
 	return err;
 }
-- 
2.48.1

