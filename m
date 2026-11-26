Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721612;
	b=zYVWIvNbiCBkPBEaXy9wBCAXQ4UH+ecZnN4bwuviONtQeHdGEZygvze2N8Ht4kNpzVl4
	 6FbvF4zGIEuNPfTYX6nPlD0f1WKOIvvn82FZEFHVS4g79Nd6al3ssoYIyzP3OEabOxTaT
	 X5PvYAQXBfZ/m49/Udp0Ggqmg4Hua7ruc1x5LDjpBxDnGajF8y/aBYjh2lC9kJ75gnWfS
	 0vliyfSIy3oF0WGQMY6kfng8XxG3wQhrfB3Q+5sc0azS7a6WVKqpLkEwZNqqJWcgULg4O
	 Rh7NafcWe26gryzbZE7GO0Yst3xgbaSWN2VV45PZAIl4kP6mm0+fh98xeptuX6ybWZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721612;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6o5PkBcDr5mo9vn6AHRcwo7DgEVc20BXfKxW4pDcM60=;
	b=cw730ToIsYiK+qvCHWI5y6BKIYOJQubVxbpmVcKhhmzSx3sNcXzpA5bM3ydrk9Lid44N
	 g6W/RqGjwAGaVAPyiqkZ1IDkJMHPO1ZNuNB7eOTYwESP2hiUNkc8LdcmwperIVf1UHk//
	 pqCMQPby+xCrXA7H+J45K6Xn+saL61FRKcbWJMCkSzEo4yPnXigZ9j2bY7MO71kZSw/KH
	 zfCuhpg/hR8Xcx9V8kCG+tgmlt3XTdug8w76LiJwp+JIBtBqJY24XAJBc8uFD0RXjRCNi
	 mMqJq/y3e7rZBFIn+0P8tx3Y+6O2GLpS7DVR3LJ22I/ozmqOJCMgGbsN9td1rj3VpHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ksh08Imw;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39E4606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C39E4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ksh08Imw
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso74459615e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721610; x=1796326410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6o5PkBcDr5mo9vn6AHRcwo7DgEVc20BXfKxW4pDcM60=;
        b=ksh08ImwjMsbkPCVgubgvskNXfr9QkAtTtHiqOknVabKQbp8kPEh7bQh1o7vRfSm4/
         1vj5Qsv7BjAj1WrzPYq//u96uTQaiS75GPuSLCWtlD4/HVdIpFMAKPZnes52ofuGQV5K
         5xiZzgwPi85zAorQPALidYX1pVkUhboqhdBqgNh1zEXtdxdFgBUnV3kp9B/7YjLiAwRE
         SLddUBsbLuw9FLgsy8xdrGngMwsJ7CtpJf2vRZeWx+K07miFHwnS8oB7utjdn7BKMzi9
         sNTajnh9EfR0yyVr4vDZoX4BBxs6kTPDbEeEqy526Oyiy/yaQFlVRJrNXbUe7kBjLPBb
         Xtzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721610; x=1796326410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6o5PkBcDr5mo9vn6AHRcwo7DgEVc20BXfKxW4pDcM60=;
        b=XgftVcsMFNhcNHVes9JHE4SRgwkFm5BsCi6FItySgKjiDsDW1xkZv5dHqBT0KsHcfb
         4v0ekpbHJx8fi8FVfamJ45AVy2EZsRj3H4fgsgYMhSPdmZ5u9Xrlz2ljbiSE665O3dh8
         EaMlIZ3xm3/s81+Ztoers4MEJ6eNR3+xI+cRNTezYxRyANceMp0b/7vkZMMreVAuMRmg
         cjY6s8KknjI43yg3g7fxL10oRnyuij0pbfaX9VZVSOUUE/GZLEYUZklQGQIlU6qRMZqj
         Jg3WWLpdc2VS5UsX3J2ozhobuR/+wUXJUqTDc3PzO6cTdUr93Yl4LKT1IBbLWpQCxNYe
         Em9w==
X-Gm-Message-State: APuU4Z+hPZKsisCF63C/q+CPiytnhDUPACxnKPvTNrfxHE/oqqgp4yX7
	kX5AP3nOdS0F4qlMnn3yei7bpA+n7FUG3oZ5Qzy+9KGus4Ov3b8Lwx5A
X-Gm-Gg: AZFdTZdR6YRoVlMuwVt0H/W/MuGadHUiUyKhCuBwMe+aCLDmTnGpoZZY0Dc0tbnNFXc
	FnK3OThC2CCKF+9X3eohdm24T42arYVmTu5Rcoqf54vMnD7fqDe8ynzcVdOwFvd3Kuq+hFURpzS
	o0cn/K705+PFwlZ+t3b8Ne3mRH1p6l7DOOhjj51osyXBFDGBTy4pcFG3YyLlCSEit6E1qj5Wkj1
	KbwqA37uq7svgj1Fpjw8FoBG1LyPMfu5Y0tAmTbKNjwVwp7sTAoz9NchlXRXuWXHpv7r1XKxkzu
	e97Z/IGJo02psCzODn4BMjgHNYc3KT9IuhktW5t+16eAfa4VQ2db3pBucQXmFpw7YccYYEghKgj
	G8F/GeJ2Xq5Nn+tCKlnfjo18vNTEbJAAz5HrhodbJ5RN8p0rMhDW8f657SitXLwf0ysfNTLmnq2
	n3Hm+XiWTPyKQ0K1ZhVxk90rOOQP8kkbhAsY/i6vjFArXYx8Okva05csaH0KuyFpk3YuPaUOEJ3
	LMxNNVm+p48z2M4OUGRZN51YLxybXhAJ8TaJ/SnT9RX7vKgrj/THSLYY4diwwHrTlRkKtdGaAgA
	fhEoVKcKXA3SOrW+OT9SyEzmrpD9ju+6JwlzZrop7NWhtA==
X-Received: by 2002:a05:600c:4504:b0:4a1:9078:911 with SMTP id 5b1f17b1804b1-4bb888284d7mr463782755e9.31.1795721610174;
        Thu, 26 Nov 2026 11:33:30 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:28 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v13 18/25] crypto: amlogic: g12: drop CRYPTO_ALG_ALLOCATES_MEMORY
Date: Thu, 26 Nov 2026 20:32:34 +0100
Message-ID: <20261126193241.1471372-19-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

The driver queues requests to a crypto_engine kthread and does not
allocate memory per request, so CRYPTO_ALG_ALLOCATES_MEMORY is stale.

dm-crypt allocates its skcipher with a mask that excludes
implementations carrying CRYPTO_ALG_ALLOCATES_MEMORY, which prevented
the hardware cipher from being selected.  Dropping the flag lets
dm-crypt bind to the engine.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 6070ee6b488e..72892fdcd55d 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -498,7 +498,7 @@ static struct meson_alg_template algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -526,7 +526,7 @@ static struct meson_alg_template algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
-- 
2.47.3

