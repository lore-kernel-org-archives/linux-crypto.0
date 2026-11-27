Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780931;
	b=utB0NfilF6EssWD7XNIxinsXygMg/TDEWlrmW9ah1cqYHg8nKbsTq7X4gLSxAqL/bBP5
	 OKq8ehRI8RVXO4CLgLvMjbEyfMUmPxx7yxrj01r7YAPIhWp2kWfGI+QxwZORm9ELPMvmN
	 SEblSq0m2kPWlp4g532uecwLk+TPhfvIaox/Iy1Qz9GQB+N/Iz0uBvPgH7syzxMRkpJi5
	 paomXi1/7qO+rIfsVYJVdFvPZ/CDx+0XxJbDkuf8eu4BpaX/wB7S38Wfhtyu27WoJ51a4
	 usK/z6DOW0Mmjupe3gqmnr8Bi6rwtVL4vY5k2QMVenIYpkMiv2EA+XAsIybEkfcI6+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780931;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ideFtYn4ffgnnNVgM+MGgEFjn8Xh17mg6POE0V0VRbw=;
	b=Cm4dqWzN/HWygLpJwkNIaQ5eX0QfLh3BF9xV4WDayxxK2KXKKPGeJi0/tvbh1peCaLv4
	 OjcswIKz6TD+V7B9t2xQEGpadIp5awPAeOritVQe+AB/DX0h9P+iSuDa02WjszJgULpQo
	 fuSKO8qCEG9QUDVpF7FG003Y818A0kQWCm9QxbO5El1EqfOT60TYSaFwOpbQuc2MMW5DB
	 zHZqEIfnNU2CsyEhyrGnBVO8VhTZKUpqcIw0T9FT17bhC0yEozlLPVl8XqnSkF9GjlyN5
	 +rwUMwu7zyxaVWSpVVhI9j0owamfP+1X+BlS0/oVnQlZ4hmZbjGqJ5bXZHhpOhDmsyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yzEswMY2;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE59606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADE59606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yzEswMY2
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so65053665e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780929; x=1796385729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ideFtYn4ffgnnNVgM+MGgEFjn8Xh17mg6POE0V0VRbw=;
        b=yzEswMY25Uf78QOCaVLO4IO2jI+aZlMVeeaqulC4HiHD89RBFE+VNyjD/Ghcq9oDRD
         s2B/MubFzSbiggtet4AHREwbsG+cOtB7n2xRKn284CPHIa0WgXi59xjpwAGJlviQswrK
         8RUmgf3T9fu94ggPUN/FvXwISQWRar60eoIXDyZ7YVKl6dsIDTG81pu3mgUefBMy3Ttc
         s9uOoKPHZdqBypwHUZPacrbC7+vPmI6XlSEZneGSxqNTsTLZ5poBgR424QTl6Ruxxc6a
         esUbKQ9He6CvDDS2WhHPa3TaXK9fG/bvN6Rk/4HCHF0WiMqrxP1IzSNfx3KPsLFeRMK5
         yI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780929; x=1796385729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ideFtYn4ffgnnNVgM+MGgEFjn8Xh17mg6POE0V0VRbw=;
        b=PCZu6WJxuYp5cOq0kZ+OsgABxwm/VB3ctvpoRww9it4XUeC0gGb84aImTnrvYCsN4X
         8A1ZzGAmQ5jPhibJVx+VTtgUm63m/B0wxTDax43G9F9KCaoOBvLiA8dOO/1bBTWmCpYF
         O3FLwG0GiJS9yizWfrW28Wv8FcMAJzNQtEN7dlK1JojArHN+wKKp9+L6YEMXAZvOBcPN
         1N+Q26aPV7ARV0EqIybjkSyeWlMy1mUcoTkqBeGK/W/IH/kcQ0PdagvprkRB7UNOuVkz
         zeXMB8V+1QqCxnP5hwOiW/MtxTQl/6OelBq+WSp9kj6CU/R1q/cMSFg7P2SUPSnnm5VU
         PyRQ==
X-Gm-Message-State: APuU4Z+CBpmq1RuceS2MdH0gI5r7Y10K0nj/hq27vK50sPqOifTfC1TE
	6D6HiJVC/gsKEiiaht1vx8ZNSE5JhQlwvsr7AFORV9yHQuBLX05sO0eG
X-Gm-Gg: AZFdTZfoH8/AtYiSZ7YRslHAxgl+ZRogp54h2tcqKaDbPHvzbrh28lmFto68zfI7Xlc
	O5O/ypvNSGgD03iV1G20w0hFWNM9yDkd5Cz7PrvgW17QJ9zfXVrmBlTK2RPfhkIh/XREW9VS7ez
	9EMIdf2uJBSSgQho+tdswByDylVQFwrxBZPERa75pWhrsNzwXlu6dtneOokPDQu99aAob//Gyxm
	k8oTA6+ZzP8/TpOCLIl2zcMPFulKH9WJujPPzyAf57CxCejG2dY8EMIygVHtxYOaQxrehqcjGpi
	GrYlUoLGjeMKmO7smn86gq907VAH8rnRzopcYAWd7GWu0Mo0dQJcqAvo/8c2gJ4FMfzOctjImLT
	9P9UlkarArA5U6o8Tan53xUQ1PfV3ZJHQzPTs6itkAjdYzvokQ/EqRGdPX0tHYgi9Vvs0kYK/6k
	56gchk2SJ1PWUeoZypDJTsYc9FLj319kqXAmLFIf2GBMcd790HN+xAQEiIi4Iqfv/kbtnmZduYn
	64Xs45pKx9BM5GixICvF2UqV0ixM+0kz9Xt0JnY45S5/76/V5YkGSX12X7GCtqRY4K0A/h2MEOP
	ms1qk/2sfjGf7bMhhzRcT8Pj5xClDOISYjUpZgfCqCoNBcc=
X-Received: by 2002:a05:600c:c8c:b0:4b7:6942:39bd with SMTP id 5b1f17b1804b1-4bb88820e06mr485025885e9.26.1795780928793;
        Fri, 27 Nov 2026 04:02:08 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:08 -0800 (PST)
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
Subject: [PATCH v14 28/30] crypto: amlogic: fix setup descriptor lengths and CBC IV copy
Date: Fri, 27 Nov 2026 13:01:01 +0100
Message-ID: <20261127120103.1532882-29-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
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

Fix the key/IV and SHA state setup descriptors and drop a duplicated CBC IV
copy, found during review:

  - meson_setup_keyiv_descs(): program the per-descriptor length as
    keyiv.len / setup_desc_cnt instead of the full keyiv.len, so SoCs with
    more than one setup descriptor do not read past the key/IV buffer.
  - meson_setup_state_descs(): use MESON_SHA_BUFFER_SIZE / setup_desc_cnt
    for
    the same reason.
  - Drop the CBC IV memcpy() + dma_sync_single_for_device() in
    meson_setup_keyiv_descs(); the IV is already copied and the buffer
    mapped
    once in meson_cipher().

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 15 +++------------
 drivers/crypto/amlogic/amlogic-gxl-hasher.c |  3 ++-
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index c11ccbaf920d..10815ffe3313 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -147,24 +147,13 @@ static void meson_setup_keyiv_descs(struct cipher_ctx *ctx)
 {
 	struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(ctx->areq);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(ctx->areq);
-	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct meson_alg_template *algt = container_of(alg,
-		struct meson_alg_template, alg.skcipher.base);
 	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct meson_dev *mc = op->mc;
-	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
-	unsigned int blockmode = algt->blockmode;
 	int i;
 
 	if (ctx->tloffset)
 		return;
 
-	if (blockmode == DESC_OPMODE_CBC) {
-		memcpy(op->keyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
-		dma_sync_single_for_device(mc->dev, ctx->keyiv.addr,
-					   ctx->keyiv.len, DMA_TO_DEVICE);
-	}
-
 	for (i = 0; i < mc->pdata->setup_desc_cnt; i++) {
 		struct meson_desc *desc =
 			&mc->chanlist[rctx->flow].tl[ctx->tloffset];
@@ -172,7 +161,9 @@ static void meson_setup_keyiv_descs(struct cipher_ctx *ctx)
 
 		desc->t_src = cpu_to_le32(ctx->keyiv.addr + offset);
 		desc->t_dst = cpu_to_le32(offset);
-		desc->t_status = cpu_to_le32(DESC_OWN | DESC_MODE_KEY | ctx->keyiv.len);
+		desc->t_status = cpu_to_le32(DESC_OWN | DESC_MODE_KEY |
+					     ctx->keyiv.len /
+					     mc->pdata->setup_desc_cnt);
 
 		ctx->tloffset++;
 	}
diff --git a/drivers/crypto/amlogic/amlogic-gxl-hasher.c b/drivers/crypto/amlogic/amlogic-gxl-hasher.c
index 978cdcd8a4f9..710dd413bd51 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-hasher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-hasher.c
@@ -253,7 +253,8 @@ static void meson_setup_state_descs(struct hasher_ctx *ctx)
 		desc = &mc->chanlist[rctx->flow].tl[ctx->tloffset];
 		desc->t_src = cpu_to_le32(ctx->state_addr + offset);
 		desc->t_dst = cpu_to_le32(offset);
-		desc->t_status = cpu_to_le32(MESON_SHA_BUFFER_SIZE |
+		desc->t_status = cpu_to_le32(MESON_SHA_BUFFER_SIZE /
+					     mc->pdata->setup_desc_cnt |
 					     DESC_MODE_KEY | DESC_OWN);
 
 		ctx->tloffset++;
-- 
2.47.3

