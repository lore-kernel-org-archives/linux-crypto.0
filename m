Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC82630F804
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352647; cv=none; b=kcrHgUws8gl7/qNJxA24dRnhzBEMpZiMXavumuQ+bO83cIVBhyzakzEsP0qtGEkO+CYKZ1/97W/kF/8YSHnmv+GLHOjJi4NIkkU+ASN5vvVw/xKx+6qOgCZJqW78IpyHvv6Z5DuCesi7PuAZQGyuVjBs7ISuhFKFoY70+SLoYeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352647; c=relaxed/simple;
	bh=dDKP7cf/IwxD7BPlX7fXIXQ/LuMlM/dY4qugXMO1+Ks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=taAMbTw5/unGXZzSoMJxdXBjRl7BUnshAPl+GJTwNkAyr1MeZvjpWviBkkrZ8iqzcamz+p2jKzI+BVU9HB+gTUy+IwNj9coMS5yfMoJEjwWPQ+0o4ZyB5ZXasqxOkmfIKZSct/UqQ0X29OzHED15cyb+g5aXDk1KiAMHmscxY2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bpLStXfw; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bpLStXfw"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ecdd80ea44so105136f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352644; x=1759957444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qcvrL2whjEnKHntdPNXOlg2YOLj5Bio52ZSIjpgqpWY=;
        b=bpLStXfwP631JVblTXBDL3zxuO7JksO9pzhHiigI1ZXoxTprmub6ZgxdWEikCfYIXN
         RSctJcNcL1v9BLAolzr8ztMh3zzCau0BOLUIMXeqDLlDe3Q7+Iy4MsacRyGPat7KoJUo
         Iys78XhKxD1ej8qn7AFcvM/+nc1w37aiGK4GyuFN6E+Khl3vw+yKa6F/U0Mz+3gC1zV/
         hI94lYewB1Mmb53BPonHO5WNfxSVnJux6/t3H3RMjouUDiXvVq+sfuchdeWUr90EhSzS
         aFJ2UDMZJ4bWw8lU9qgXJFT9d/EPNJTCDSUgRPqvbJTBeMoJ6AH26PQOdbC+0S5LI7BL
         BhNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352644; x=1759957444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qcvrL2whjEnKHntdPNXOlg2YOLj5Bio52ZSIjpgqpWY=;
        b=CkYAk6hpliLBz3lHvecEBpgxxQRJSSBdb8bSlRr2nBze7gAV2Hik/FWxWcwePX++EU
         9X5Y/4zu1Cw5u5MPsQxwaluJR25/1g+xv575BDl26y2jQGlKeun3r6B8Q48VgkIiCpX5
         nvx4/das++4La1iBQgb22hYfdgqmKMVvJvkJZcLmzXveLJNgEgvsRzK8jLh/j+9S9vFJ
         WBTbP4JGpmwW7MGt6qSTu4PoLaqtbhPJWWaFllMwv30F2CnS7lZr4S0R6tix+wfkedn6
         KVRcdBmcrL1nzi/S+NA8GfyzUIXmEmEZMxOkuHMc5NzOFD93eUxdkgo6zFQ3VVdSBYMW
         k32w==
X-Gm-Message-State: AOJu0Yw+EZStyKsl94xGQnRVIFYzdjiwGqSLLFeIbOcGc4ExteOdlQ5v
	vohTwIO6iqV7dyoBtw9nKNKJHEVWKx7B+LvqGvU4xuaI6IXki/njOnWU2mDZLywn0RdcV2WUHw=
	=
X-Google-Smtp-Source: AGHT+IFgnronrhyrUGQbEd1tw99/RmLAuopJxtgZuzG70+rn7tFXZp9Z4jQhbFBg2A3csmpX/luoY+KJ
X-Received: from wmep20.prod.google.com ([2002:a05:600c:4314:b0:46e:3212:7c8f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:584a:0:b0:425:58d0:483a
 with SMTP id ffacd0b85a97d-4255d294cb7mr680156f8f.3.1759352643936; Wed, 01
 Oct 2025 14:04:03 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:13 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4507; i=ardb@kernel.org;
 h=from:subject; bh=ZZLbTVVt22jlbrdSe9T5dbgBqhdIsvid01EOnLK51YY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutB+MjZ87zJ8nF8qUiPf+vhsS3eN260KLvOGy28p7j
 a8kHH/eUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbCVMfwP1b11I7kc0k/2j7z
 3BdgviGzfdeviMjbLzzm+r6qz/+9zJ+RYb7Fzy6L4LN3/7zofmkyK15hq9g6/nWafRsuVhbyX/9 7kQEA
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-33-ardb+git@google.com>
Subject: [PATCH v2 11/20] crypto/arm64: aes-ccm - Switch to 'ksimd' scoped
 guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 135 ++++++++++----------
 1 file changed, 66 insertions(+), 69 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 2eb4e76cabc3..c4fd648471f1 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -8,7 +8,6 @@
  * Author: Ard Biesheuvel <ardb@kernel.org>
  */
 
-#include <asm/neon.h>
 #include <linux/unaligned.h>
 #include <crypto/aes.h>
 #include <crypto/scatterwalk.h>
@@ -16,6 +15,8 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/module.h>
 
+#include <asm/simd.h>
+
 #include "aes-ce-setkey.h"
 
 MODULE_IMPORT_NS("CRYPTO_INTERNAL");
@@ -184,40 +185,38 @@ static int ccm_encrypt(struct aead_request *req)
 	if (unlikely(err))
 		return err;
 
-	kernel_neon_begin();
-
-	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac);
-
-	do {
-		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
-		const u8 *src = walk.src.virt.addr;
-		u8 *dst = walk.dst.virt.addr;
-		u8 buf[AES_BLOCK_SIZE];
-		u8 *final_iv = NULL;
-
-		if (walk.nbytes == walk.total) {
-			tail = 0;
-			final_iv = orig_iv;
-		}
-
-		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
-			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
-					   src, walk.nbytes);
-
-		ce_aes_ccm_encrypt(dst, src, walk.nbytes - tail,
-				   ctx->key_enc, num_rounds(ctx),
-				   mac, walk.iv, final_iv);
-
-		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
-			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
-
-		if (walk.nbytes) {
-			err = skcipher_walk_done(&walk, tail);
-		}
-	} while (walk.nbytes);
-
-	kernel_neon_end();
+	scoped_ksimd() {
+		if (req->assoclen)
+			ccm_calculate_auth_mac(req, mac);
+
+		do {
+			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+			const u8 *src = walk.src.virt.addr;
+			u8 *dst = walk.dst.virt.addr;
+			u8 buf[AES_BLOCK_SIZE];
+			u8 *final_iv = NULL;
+
+			if (walk.nbytes == walk.total) {
+				tail = 0;
+				final_iv = orig_iv;
+			}
+
+			if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+				src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
+						   src, walk.nbytes);
+
+			ce_aes_ccm_encrypt(dst, src, walk.nbytes - tail,
+					   ctx->key_enc, num_rounds(ctx),
+					   mac, walk.iv, final_iv);
+
+			if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+				memcpy(walk.dst.virt.addr, dst, walk.nbytes);
+
+			if (walk.nbytes) {
+				err = skcipher_walk_done(&walk, tail);
+			}
+		} while (walk.nbytes);
+	}
 
 	if (unlikely(err))
 		return err;
@@ -251,40 +250,38 @@ static int ccm_decrypt(struct aead_request *req)
 	if (unlikely(err))
 		return err;
 
-	kernel_neon_begin();
-
-	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac);
-
-	do {
-		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
-		const u8 *src = walk.src.virt.addr;
-		u8 *dst = walk.dst.virt.addr;
-		u8 buf[AES_BLOCK_SIZE];
-		u8 *final_iv = NULL;
-
-		if (walk.nbytes == walk.total) {
-			tail = 0;
-			final_iv = orig_iv;
-		}
-
-		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
-			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
-					   src, walk.nbytes);
-
-		ce_aes_ccm_decrypt(dst, src, walk.nbytes - tail,
-				   ctx->key_enc, num_rounds(ctx),
-				   mac, walk.iv, final_iv);
-
-		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
-			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
-
-		if (walk.nbytes) {
-			err = skcipher_walk_done(&walk, tail);
-		}
-	} while (walk.nbytes);
-
-	kernel_neon_end();
+	scoped_ksimd() {
+		if (req->assoclen)
+			ccm_calculate_auth_mac(req, mac);
+
+		do {
+			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+			const u8 *src = walk.src.virt.addr;
+			u8 *dst = walk.dst.virt.addr;
+			u8 buf[AES_BLOCK_SIZE];
+			u8 *final_iv = NULL;
+
+			if (walk.nbytes == walk.total) {
+				tail = 0;
+				final_iv = orig_iv;
+			}
+
+			if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+				src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
+						   src, walk.nbytes);
+
+			ce_aes_ccm_decrypt(dst, src, walk.nbytes - tail,
+					   ctx->key_enc, num_rounds(ctx),
+					   mac, walk.iv, final_iv);
+
+			if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+				memcpy(walk.dst.virt.addr, dst, walk.nbytes);
+
+			if (walk.nbytes) {
+				err = skcipher_walk_done(&walk, tail);
+			}
+		} while (walk.nbytes);
+	}
 
 	if (unlikely(err))
 		return err;
-- 
2.51.0.618.g983fd99d29-goog

