Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648472BDC15
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938411; cv=none; b=qkvBgHqllxOttmRFAL6mDcl2u6ffaWbJDLvfWbemp1cNOCuFp1Zs1r4ImMAGgfD/H7n1vRi8GNtv/U3HFriLgbNWTHtdnakUt+IdepmwsW6pm+uIT5b7fFseYBcyiSzV6sQ2xkSh+mI8B4O1ndLt/vsmi0gpg+hzI01QhpWVNLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938411; c=relaxed/simple;
	bh=wEi73K9tOwaYQZRIL/sXTFyXCpFYqwJBcsVGx35P9jc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CH1V3rQxUHhCd2QQ6UwgwAJewWDTdP8m+iVjluBu4sYh5WdZjhlRWCnkqAv6Hu8uMNJ7TW06rR4N/f2QmQe8b38ensDacQWfKppqjIxM372NgOmHq1yGNZ/PObyoF0FLaPddXqs0rSBsJMLJ2h9sv0FNbAeXzxXrXP9q7KVOKXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FPLnnmU1; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FPLnnmU1"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ee10a24246so40990f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938408; x=1760543208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=14A2zAAjYNWwlBslQvMqX7czpAp/zYAIyPXaDxUH4U4=;
        b=FPLnnmU1Sc0hZ1hknsBraciNCn+oecRKYZouOx8NIuPAlEosqcC150x1psWP86IOGn
         mIHLl/yhaOascHIOaq4q27vdOVsBIMatZEecQpsgejwMMwOKjDIwkGoCqvLdZz6W8KlN
         NzktwXIvUj9t6ikPrq12hF5oNp6yV8QfZWGmb4dYa3/O3W2YnOAAEwInDPL14N15VUGU
         0YZjfvkoxNwJT/0ZdF43NGWMeIePS9aNjfLitYDY0LDVC45Ou3Axz+eai8dPTn32o9XB
         LvISuE2E2WTZtPjZw5ZhIjEYVNLYL+xAwCGh2S5vfiN37Y16v2TvMnEaeNsRuLU2UB/B
         nCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938408; x=1760543208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=14A2zAAjYNWwlBslQvMqX7czpAp/zYAIyPXaDxUH4U4=;
        b=VohZME/JZlCi8Wd204K7WLKWK26+PEb/hxcqOZlb4OFygC++wpiNpB92/CDIhQ5lvv
         b0tPrGO8HVECHotjKlCODoFzui0g5RLaiYDNrvd2gPZ65/DzZN8FZDzKirr1DYQaM27e
         YnlxgTbGwcyXlFQXpzIYGVi2dc6JHNgU1a0X20VA/9gG/MLprUEQXfiIyX6xqwHE1nea
         Q3c6/0PSkUhZ0Kv3oGO2Ehr4b+DzU9KZtdGlPdnPgB4lhK+lzQwGJ8lckQZBYHnOKMCZ
         8kOiucxwk8SOWaE0vhRsEyuNKxJbgntEIg+qr552LypGTVgnec6zqFqd/kX+hxTPudGq
         TfSg==
X-Forwarded-Encrypted: i=1; AJvYcCVkXXutVy32UNW1PBeUW14Oc48XJm9F1kp0id/BcrydtaRhC10M0nnycyxQiSLIyHGwxQwvxSf9WKznF8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFlfmqfg678amY5Ek5go2pmIpd/J/Yf5W2n5PjSlStkiZJBOS3
	lgncv6qVthlYidrmmeZwXggTrXp1eybUG/hVqGpuoOF9MMqMi392WzlO3eTzbgoskmnkclB/5g=
	=
X-Google-Smtp-Source: AGHT+IHEE1faiKfKH1tfDaLUrBFzle6tgkGUM1s8NmshfL2C3RktZfgqJpT+SXKKnzw1/mEsdDS3IKGM
X-Received: from wrvz8.prod.google.com ([2002:a5d:6548:0:b0:40f:b976:8cba])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:22c5:b0:3fd:bf1d:15d1
 with SMTP id ffacd0b85a97d-4266e8dde71mr2375302f8f.49.1759938407736; Wed, 08
 Oct 2025 08:46:47 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:37 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2047; i=ardb@kernel.org;
 h=from:subject; bh=V+R1u4QlJCauwRhK0blDYK+Qy9hXMWQp6E2hey/88as=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu7ozS8uvGUohmk1rtfp6zv1Wq5MrdQzzun9T8pyDv
 tKV+psdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCLTtzIyPPJdPPc1bxab9711
 x85sfSLz8ybbgVdxHSd8Hs40uOCj5sTIcP/E5wlprVHtJsG9m7uYTWTlSo9EtVitL3wUfvTK0lp ZBgA=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-26-ardb+git@google.com>
Subject: [PATCH v3 03/21] crypto/arm64: sm4-ce-gcm - Avoid pointless yield of
 the NEON unit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Kernel mode NEON sections are now preemptible on arm64, and so there is
no need to yield it when calling APIs that may sleep.

Also, move the calls to kernel_neon_end() to the same scope as
kernel_neon_begin(). This is needed for a subsequent change where a
stack buffer is allocated transparently and passed to
kernel_neon_begin().

While at it, simplify the logic.

Acked-by: Eric Biggers <ebiggers@kernel.org>
[ardb: Simplify convoluted logic]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-gcm-glue.c | 25 +++++---------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-gcm-glue.c b/arch/arm64/crypto/sm4-ce-gcm-glue.c
index c2ea3d5f690b..8f6fc8c33c3f 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-gcm-glue.c
@@ -154,36 +154,23 @@ static int gcm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	if (req->assoclen)
 		gcm_calculate_auth_mac(req, ghash);
 
-	while (walk->nbytes) {
+	do {
 		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
 		const u8 *src = walk->src.virt.addr;
 		u8 *dst = walk->dst.virt.addr;
+		const u8 *l = NULL;
 
 		if (walk->nbytes == walk->total) {
-			sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
-					       walk->nbytes, ghash,
-					       ctx->ghash_table,
-					       (const u8 *)&lengths);
-
-			kernel_neon_end();
-
-			return skcipher_walk_done(walk, 0);
+			l = (const u8 *)&lengths;
+			tail = 0;
 		}
 
 		sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
 				       walk->nbytes - tail, ghash,
-				       ctx->ghash_table, NULL);
-
-		kernel_neon_end();
+				       ctx->ghash_table, l);
 
 		err = skcipher_walk_done(walk, tail);
-
-		kernel_neon_begin();
-	}
-
-	sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, NULL, NULL, iv,
-			       walk->nbytes, ghash, ctx->ghash_table,
-			       (const u8 *)&lengths);
+	} while (walk->nbytes);
 
 	kernel_neon_end();
 
-- 
2.51.0.710.ga91ca5db03-goog

