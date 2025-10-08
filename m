Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66472FAC14
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938419; cv=none; b=TasbeBiCgG9BH9ewSNLdMYlH7xv2x9IZvVxKipj+rcj7yPud8QQko0F3JvBkacseXPoOPTewf6Dj+NVoC85/LOEn3MLZId9up5yOGNY3dsyUI2RqfKqjcKskx1LfBvopcnoDX9zpg0lkEBJ7t6lkYU/Z2EYJGwBUSq4sTUWxMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938419; c=relaxed/simple;
	bh=hZ7D2VhE6rmVLNXRjWCtqtkp2VdiXoZ1njBgdHXCPWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NhPruCqYeokuHie7Mhga++azeS+OWDlLvShF2Rjp5c7D+1TGexwHLmAGpprq0mKRRAyaMcanArwEDLsMSDat5QDByuzTlRPlFoPM2exRFWHwTPWSmEudbP2ne8fcUXIYGXgeopvOLlmO3CQ+uPDQQvhKK45EfH5oJoKniuEuEbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hWpFLHvp; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hWpFLHvp"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so40670f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938416; x=1760543216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZTif7/cIVHMtQ45TCGuP+cAI2k4HcRnORL17PDNXW0=;
        b=hWpFLHvp+Ffoed0ZNFgUNyzoK2l3bNY2ONNlkr7Xefzu2VZ7CpPrfiNQgb0eh4Uk7h
         RIplBkOvPLFicy2XDTgMy0Tp9W0suTIwYs+ctfdyPIl9lCU3KH7ecoDMBTsRgkFiiPK2
         K9/9bVq/5uEV4UsHAOSEgtBhMb+ku9szYuMIoa8dhAdsI8lO4DSj5hAwG+iUULcqRgm7
         LyHeGX0Keq2xGCrnSRWe9sKo0ed3Ch1BJVbA53COcGLZyHhZY3KhW1V1GN6BkHcm2XX0
         IEwJvEZYOz8LLI714CgDJnnHkA2PH529zdaq71AUXxRtB3VoVr3iwzi/eWRnwGZ1jCwv
         oczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938416; x=1760543216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZTif7/cIVHMtQ45TCGuP+cAI2k4HcRnORL17PDNXW0=;
        b=NWkmBfl4l7xbU4+AeZHzyYdKpcT8TVB4cAPaZ/E5GcVY1xs61dDuU+tQNhAN5AcC3r
         Ql7VHuqdoJ21kRFTBtiolY+EOUOCD/babKOfJ+iFf8lEBNA0RfXG9LLToTN/ks02S5KK
         dxLBa4sj1Y3Xq5dOun7sVjY8x+yeCF6AWXIQru2veFdtiaMUwyFKW7PDLhthqGdjYT/9
         /PVUPwBuENNUQ41QK0p5x4K5eRIdw07ZWgbCblHNbX5P8xie/y1XGL8qRT8MNbhIktlJ
         azMmvGOiJ7qQOIsTEAMBGUDq8qjvReVl2x2DtfMH/awns7OiFQVP+5wyJ63mKGAqwcDI
         hywg==
X-Forwarded-Encrypted: i=1; AJvYcCWJgR97ds1eGDz950GHT0AjgC0TGh/HcHdXAuI0WsMyZ+562yV9wEIUGM96noNBmo3nSLtcwJHoU4sz67M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIM36HfptHFKsInnE5l4Z6qz6abbQKHVyhbRw6k/8tmGUK7fZm
	o8UI42p6Bsi7bnDRE/M4TMdc2phiSGZh2SbP8gbqN8XfQwFDAFhytF1YyhP1utClhBDwkS7Ufg=
	=
X-Google-Smtp-Source: AGHT+IEyCmYra1GwWRRLmZZtQP0MhI0OXcPDxc0b177KYVx3KWOyy1Y3Egz1AfgFxQB41mo55vgeHUjH
X-Received: from wmju4.prod.google.com ([2002:a7b:cb04:0:b0:46e:6302:1a80])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:290d:b0:405:ed47:b22b
 with SMTP id ffacd0b85a97d-42666abb50fmr2372305f8f.10.1759938416483; Wed, 08
 Oct 2025 08:46:56 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:44 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4882; i=ardb@kernel.org;
 h=from:subject; bh=4UlGg4Ju4YWc+Ic+YbEYvUCY8K/tyCDEsga2nZVeBfU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu80txrdaByc5vmw2PiCQKtyW6Mmrzf6v6zGLx/Pzn
 xq/HH/RUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZik8zwP5VFsj/wi4xbkYbR
 mRViX4tDOiw+xyiw3a0/z/Rsju+bOwz/9F1VbI4HTag/VTjZ88Tt3tTLPgLJSzLmOdWpF71MWxj BAAA=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-33-ardb+git@google.com>
Subject: [PATCH v3 10/21] crypto/arm64: aes-ccm - Switch to 'ksimd' scoped
 guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Switch to the more abstract 'scoped_ksimd()' API, which will be modified
in a future patch to transparently allocate a kernel mode FP/SIMD state
buffer on the stack, so that kernel mode FP/SIMD code remains
preemptible in principe, but without the memory overhead that adds 528
bytes to the size of struct task_struct.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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
2.51.0.710.ga91ca5db03-goog

