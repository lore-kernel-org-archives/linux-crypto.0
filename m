Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEF72C843
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597662; cv=none; b=MynFcWzfJZm/eup6miO5B+gla2tdaOX3+azxo2xuYjhLd5gtvX3wxZq626CSat0I/cAHxfsSC/aacrGP+3a1kcsiyNYmARjercjvpdLE1OL1frzKyi3mutyutbuNlkx+l/UaDRLZP9z9l4/g/keLwO8lu/TmodUnVDDb0c3RYO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597662; c=relaxed/simple;
	bh=92UiQ6e2DOT3H/EOJ5xxiYlizB2H5aO6pwzx1rpb/FA=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Abf+kAlFwa01vWc95u/frclPiQLEKTZZ3ZJ4+SB+Wn6b8LSnX7fzrhbBZ77wUj/U7gA+iwwnVTPIhfBqHvSqYgQ9LvwLHb4DYEjCxlKGJi1KFGGXnooJBzk4KQ/OiLgZ8laKS8fzn7L7ssXwXDktX7M0clTBTNFXa0aXtlEn57Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O06Pg2Hk; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O06Pg2Hk"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5eba564eb3fso224847927b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597659; x=1706202459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dbblg1g18vESHRUanqd3gqjzLxnkVDJAYZyoYzsYl98=;
        b=O06Pg2Hks3eB8xgC7X/NogVHH/+UotKK+NUEpm+raSIu+WXhfad5HB4Fseo82eY5qc
         uMuSfiiZL/+0theVRCAW3+TMuQ38kZGq5lSt1dNUhuLispmkXbQptn2GzQThkipkKozY
         UR1WJwVXBtUNt16f8EF+MqZe0K0UmY3XGcnZGDkUUu8kWlEJGGwN/l03MCTp7qn2n3I+
         XHUUdfpAxDTheA+jn2Ug43FE30RGqdkrGB/pWpJMUZ0x2eiExagDAuO1w7XXmhHOE/8o
         5pieDyJROkQQHOpwzVsNhtFOnGGRlQBU8919LLCLb3If5U5OQxBea3LEkGBLaXoapibp
         PXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597659; x=1706202459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dbblg1g18vESHRUanqd3gqjzLxnkVDJAYZyoYzsYl98=;
        b=F9lbuEZHuPxyeIIMNi7AJKcs/qkPbVHkYsEQAFyu7R6ndBfQ/g73hUXLSV756mC/5H
         3bFCBIg4FQ0taxb6ioPlATHHZAqn8/3R1D7v5MT3awG3ybpQsVwld1wNmgPRAmmOPl8A
         rGYm9KQKmWaOuP1BBex9BJFbI/ZaPP3ExDMIkH9NopYIjBd5UkfaLdrLt8DiS+b6MiRD
         euYnp81yqx4s0R5nVGr82/TlvyAkVJJPW3lvT/z44mO78pleOm3AWhGOgG10GCAvYsO3
         BkvA+P8SEA0SZ87bRB2bb61ToxsppdlmHR7tKs2EMIgcZVktPatqpBi3Q8dqOFFstjfN
         +9kw==
X-Gm-Message-State: AOJu0Yym2QX7mGgD0KP1LSICfApR1ebzM+Y59BLbysehUX81fr93Fzub
	pRKwyh5PQuU203YqPvONgLq0UlIsaIya/VnWyh3Sow4qvBhTV77swaS+EzUDka+aT2hN/mSfqRF
	TuP5X71ZzlPHzCBEQ6NOrbFNVg4ycbyBVwmQSXHQ3TZNMEAa2LCI3gt13F2AxIVwvRsIqDNWUCi
	iWN4z0DxNPuaDhvBhLd/Oi3s4XKoXR0g==
X-Google-Smtp-Source: AGHT+IEj7o01HqXXidK9qvOo9cVEbWYcuM/kY5K8YovBWEfoN2D0lRYW5KX/6215Kh5B6yR1Os+UautR
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a81:99c4:0:b0:5e6:6b2c:8620 with SMTP id
 q187-20020a8199c4000000b005e66b2c8620mr528280ywg.7.1705597659591; Thu, 18 Jan
 2024 09:07:39 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:30 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4040; i=ardb@kernel.org;
 h=from:subject; bh=JFhgp0jLRo+TU0jJ43nYp0OZsvoylBSy/v8YLlAKwv8=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1DTDBw+qFOQN5F8/n8XbOi1JWuyAUMeFB9cz/rDon
 +L+Gze3o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzk9U5Ghrvv5rEbtqtqW7J+
 7K5XkmCSe2EWKda8bX/81rUOj3xUNjMyLBU1jvRYXKcqKOfm/rvj/k6pRF/Nj7NYzrVxyC9lP7O LDwA=
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-11-ardb+git@google.com>
Subject: [PATCH v2 1/8] crypto: arm64/aes-ccm - Revert "Rewrite skcipher
 walker loop"
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This reverts commit 57ead1bf1c54, which updated the CCM code to only
rely on walk.nbytes to check for failures returned from the skcipher
walk API, mostly for the common good rather than to fix a particular
problem in the code.

This change introduces a problem of its own: the skcipher walk is
started with the 'atomic' argument set to false, which means that the
skcipher walk API is permitted to sleep. Subsequently, it invokes
skcipher_walk_done() with preemption disabled on the final iteration of
the loop. This appears to work by accident, but it is arguably a bad
example, and providing a better example was the point of the original
patch.

Given that future changes to the CCM code will rely on the original
behavior of entering the loop even for zero sized inputs, let's just
revert this change entirely, and proceed from there.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 57 +++++++++++---------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 25cd3808ecbe..c4f14415f5f0 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -161,39 +161,43 @@ static int ccm_encrypt(struct aead_request *req)
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
+	if (unlikely(err))
+		return err;
 
 	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	while (walk.nbytes) {
+	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
-		bool final = walk.nbytes == walk.total;
 
-		if (final)
+		if (walk.nbytes == walk.total)
 			tail = 0;
 
 		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		if (!final)
-			kernel_neon_end();
-		err = skcipher_walk_done(&walk, tail);
-		if (!final)
-			kernel_neon_begin();
-	}
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
 
-	kernel_neon_end();
+		if (walk.nbytes) {
+			err = skcipher_walk_done(&walk, tail);
+			if (unlikely(err))
+				return err;
+			if (unlikely(walk.nbytes))
+				kernel_neon_begin();
+		}
+	} while (walk.nbytes);
 
 	/* copy authtag to end of dst */
 	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
 
-	return err;
+	return 0;
 }
 
 static int ccm_decrypt(struct aead_request *req)
@@ -215,36 +219,37 @@ static int ccm_decrypt(struct aead_request *req)
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
+	if (unlikely(err))
+		return err;
 
 	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	while (walk.nbytes) {
+	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
-		bool final = walk.nbytes == walk.total;
 
-		if (final)
+		if (walk.nbytes == walk.total)
 			tail = 0;
 
 		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		if (!final)
-			kernel_neon_end();
-		err = skcipher_walk_done(&walk, tail);
-		if (!final)
-			kernel_neon_begin();
-	}
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
 
-	kernel_neon_end();
-
-	if (unlikely(err))
-		return err;
+		if (walk.nbytes) {
+			err = skcipher_walk_done(&walk, tail);
+			if (unlikely(err))
+				return err;
+			if (unlikely(walk.nbytes))
+				kernel_neon_begin();
+		}
+	} while (walk.nbytes);
 
 	/* compare calculated auth tag with the stored one */
 	scatterwalk_map_and_copy(buf, req->src,
-- 
2.43.0.381.gb435a96ce8-goog

