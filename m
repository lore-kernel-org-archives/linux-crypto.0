Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E56285418;
	Mon, 19 May 2025 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747667675; cv=none; b=gI4JWxE0B+qbl2W0R+rReipvdK5bSHVNkJQ4ZihIyWhSJvcNgXY7TA3VCVqrXnmhD7sgg8crDng9l5ZwZrnfPsHl8DUo86fE+BOV8WCZGfHlwZ9VKooCkpWKoO+Yn4rL0e4yp4rx2qvdSwN8owEFgx6g3XXZA3PKUbmUgaXxlxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747667675; c=relaxed/simple;
	bh=jBoiZ2GaWcghwbS8pyGx4WZcTi5x2cK8RY/sPEKxu5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYLzPo8yuwh+LAWZ/aJXNympwdlG/Cv+YP6ZNQ1gAW2RxSs82EbgOgJ8lLXa1TxnrZRbXPWQkHjHFMaoGLDtRRtT9tvAeEM4WAQzJ0gh6kH3I1E8RPuDRVbB0mSZTenbT+YKYRKkESA9X+wkUwtlqCjIrB3dHLDpE5rz+2pqj5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=McyPLrHJ; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="McyPLrHJ"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ad52dfe06ceso346506666b.3;
        Mon, 19 May 2025 08:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747667671; x=1748272471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzPLTyR8BLY/EVNJO6GgeWhpConHv27PYp6Y5vYD5J0=;
        b=McyPLrHJkVIhMoo/jGkf2uZKOXfd0vPCBLzmokev2hnaUmA+Fq4xWunSdLsnJHj9e8
         i0wCt7dkTR2sDIq3S+mpVQyOpL7oZq7KDy4DpZef4qlCENEnszCXcoiv7MLciLjvHTF2
         5fHuOn9oLsBx0DNPVDwjuHhr/9Q8PfyHhkt12Ysrxu1zKbAGb5SFFH5ARZVqUfjzQ4bI
         9TKf33GHVf3dNyrBXVh9ghczGEYmgX19CVF0LpvW4RghKv62pW49HSxiA3KrWCES5cOb
         gmfdMm6TvAXF6o0hWfAKpoYt8zRu+oPZ8pyAYFHb2M08VDs84s8zIZ/tMsVOjLNlMgdC
         9jxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747667671; x=1748272471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AzPLTyR8BLY/EVNJO6GgeWhpConHv27PYp6Y5vYD5J0=;
        b=XmOlynnTSyb68lOythlDjydE3mVC2emYCz3N23ZxSuyiwXaVINwhcxVVPOpqPUqKZt
         /+GSBE//q7v/fWDjD4UgQ5qzIYT4B7JBCB23/pa34cVnYsQPtxI/WoDvPqyzLi9NqxrJ
         E9gRQyHXpQe6Fnjz5+Ch99Vs1m2sHzaCjLEZHCWRGHVeKZza08kblZHvQMG/OkYWNiPS
         nIiQuU/d0Drg3R1GHJZZK+q9mfQe1dK22oHHK2+n6BCh4NZ+pBx0JuJYF62OG2N+/W9F
         Z9qDONf0kZiAkES1WOnTXoBt3fHzQBGBp0w8Agk0kQOSMktCyLQLlKVkNVYQGmTc8y1P
         8E1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+/hC5JLZ6Ts20r+H0abIsWHb931YOV28uuKXKevADp8xR1bDCijsFmklf0XTSReJHSKZdj5ctZTUpEnM=@vger.kernel.org, AJvYcCVC6na32E849MqXipI+VSL4dK5xwtoUWTTUkzQOxdqj/worfDV89cTl+LmWhdmP3zrCquXgCIXgO6fItWCT@vger.kernel.org
X-Gm-Message-State: AOJu0YwZAe4GsOj/sL0tQu17/h9lCFVulJlfsYiRjp0/jx38def8gP2H
	78GJtM2CC76W6Yeje0xncPvyL3Wbim+A6qILzRit0a3gB4QXCGF+Ovm+1lk6Dw==
X-Gm-Gg: ASbGncsHc7qZKQuO9OGLr3asTRrhKFmK9oKPbr2orWkgOvbXsKBQqovxkvDDWQ5J+dj
	YupO8CMCHfnvjwCewK1bQJHPFlkqzquVCNeF5puCmyFp8WaxnS8AubPv+Zn3sU5x/AXE6j1i0JL
	cRUGj0tadAqDfPXvjm9541reXaWOF6O8y25/gcKfUAWebP6qa4h/7CMLMgC/zASlSdIgjZIWwYu
	KuVV0F14dDNxSP8WezKd0XUcE/+mlISViUVqHGUdV++r+DkPQ/cc+FKwW+OY/lyuwzs0rhNG8H1
	pfbzsiGT6IKC9N+p6QldSmDdHjVPPxIpWDXVG/IbYDrN8Z/DQljs2EMSXCKHnm8QeaMneP4IbF8
	dQJ8=
X-Google-Smtp-Source: AGHT+IHgJ+seY57z+XoTNGawx66JWeSgri2TnpAdEN3iSpX2I08ljlzJynMEjU7v1ngmRpqeLCLRKA==
X-Received: by 2002:a17:906:dc93:b0:ad5:6ca3:c795 with SMTP id a640c23a62f3a-ad56ca3cb15mr472987066b.33.1747667671489;
        Mon, 19 May 2025 08:14:31 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f07:610b:a400:6472:d2f9:d536:4c30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d04b08bsm608522566b.13.2025.05.19.08.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 08:14:31 -0700 (PDT)
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
Subject: [PATCH 3/3] crypto: sun8i-ce - use helpers to get hash block and digest sizes
Date: Mon, 19 May 2025 18:13:50 +0300
Message-ID: <20250519151350.3442981-3-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250519151350.3442981-1-ovidiu.panait.oss@gmail.com>
References: <20250519151350.3442981-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use crypto_ahash_blocksize() and crypto_ahash_digestsize() helpers instead
of directly accessing 'struct ahash_alg' members.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index bef44f350167..13bdfb8a2c62 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -342,8 +342,8 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 	ce = algt->ce;
 
-	bs = algt->alg.hash.base.halg.base.cra_blocksize;
-	digestsize = algt->alg.hash.base.halg.digestsize;
+	bs = crypto_ahash_blocksize(tfm);
+	digestsize = crypto_ahash_digestsize(tfm);
 	if (digestsize == SHA224_DIGEST_SIZE)
 		digestsize = SHA256_DIGEST_SIZE;
 	if (digestsize == SHA384_DIGEST_SIZE)
@@ -455,7 +455,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 err_unmap_result:
 	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
 	if (!err)
-		memcpy(areq->result, result, algt->alg.hash.base.halg.digestsize);
+		memcpy(areq->result, result, crypto_ahash_digestsize(tfm));
 
 err_unmap_src:
 	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
-- 
2.48.1

