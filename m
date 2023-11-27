Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CahGLWlb"
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6986F111
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:25 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a541b720aso4567429276.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701087804; x=1701692604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LtKj4jG97S5ROkd3H2gfeK9FLeAMjZ/gxMMmIHx9jAA=;
        b=CahGLWlb37HnP04bXZT6A1WoxjcDJRhYH+3bzz6Z4pM/YkD4LFkro64tMzGDbu5iB5
         wJGuI0AYAEi06UK1/oQa+T7ZiGzBA+gQU+NtqwzzVMg7UHF7+OV6poU/ipB+7iTUCPlf
         zMreawL9/lQ264YkRFEg3jKuDuDnO7QGA0p0efOxbuDNJd5fHwi0WWSiMp1/AU1JLLe2
         1pGWhrlypeoIz6uWa/h2MB9GFTNGq+O7QjGTjy9HtnmUFK4WsqUdzjZQIndPjaOOqP1k
         oLx3pVAb451Xvo4zNx9n7Gj3NDtBSdEAmg2PbbCUz0OuWmJmXqMngiDSdNpMDqdREqf1
         m+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701087804; x=1701692604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LtKj4jG97S5ROkd3H2gfeK9FLeAMjZ/gxMMmIHx9jAA=;
        b=NjNpvwCIGSiGNxFLeoxJmSYU6VCyAnKPx40KZjM/11xCqHxJl6s7+G3Xuc//3u3JNH
         FbPx7Q16n1YwCBVc35N6Bl3xA+yH8cW+jHFTP09bQcpYX9TJMXKkXdf/umYpKNl5u17z
         XDN5mYz/4btHVlhH2vFVaqJDZ2Be3MIdUeNlfrd127Kf27SLBlROV83E9livgF8ZAdoD
         nYp/FoFmYxx7lvH6sqzMaCL7xlDEoJed4GXJ0mxBmUoiK0C2QfaXEmaj5a3c9fB9j0J+
         wDg2QXp0LvED3stcNlUajjJ20g7IHgqMZlOkg3QSc+nm8uhQXd1n9/s4CYAyW6FNOs8N
         mWlw==
X-Gm-Message-State: AOJu0YwtRZ1hwBtvKw8l7XBL5b08/qgX2RgS7wCuwe8+MqyoCts0XcqO
	FtpSgd1ywwCWJHO2WGUOmI0gBUB9
X-Google-Smtp-Source: AGHT+IEe7Hy+nDV+k7QymmY1pBDw6FA1EP22u6IitdInsZJo4dzubHu7ZgGyB0HUS9r6tQh4h5B1ojyq
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a25:738c:0:b0:d90:e580:88e5 with SMTP id
 o134-20020a25738c000000b00d90e58088e5mr311965ybc.10.1701087804633; Mon, 27
 Nov 2023 04:23:24 -0800 (PST)
Date: Mon, 27 Nov 2023 13:23:05 +0100
In-Reply-To: <20231127122259.2265164-7-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231127122259.2265164-7-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6539; i=ardb@kernel.org;
 h=from:subject; bh=KAO1mMfveVRlNLtpRgzO/obJW9IGCdblJhF8gKSOjpo=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JITWlS3NjhFD+pbQDzg/KdTX2f7X5xen80lOvftfNdJFLH
 jyH9fU6SlkYxDgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwESijjP8j58bxVy6sD5o9Rb+
 rJYZHfv+nuOc0TNTqal5id3KdsZSVob/qaJXNblWRYaEHHTj5il+Hi+6xW2zUq7gFe5kjXzHGWb 8AA==
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231127122259.2265164-12-ardb@google.com>
Subject: [PATCH v3 5/5] arm64: crypto: Remove FPSIMD yield logic from glue code
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

A previous patch already removed the assembler logic that was used to
check periodically whether a task has its TIF_NEED_RESCHED set, and to
yield the FPSIMD unit and the timeslice if this is the case. This is no
longer necessary now that we no longer disable preemption when using the
FPSIMD in kernel mode.

Let's also remove the remaining C logic that yields the FPSIMD unit
after every 4 KiB of input, which is arguably worse in terms of
overhead, given that it is unconditional and therefore mostly
unnecessary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c      |  5 ----
 arch/arm64/crypto/chacha-neon-glue.c     | 14 ++-------
 arch/arm64/crypto/crct10dif-ce-glue.c    | 30 ++++----------------
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 12 ++------
 arch/arm64/crypto/poly1305-glue.c        | 15 +++-------
 arch/arm64/crypto/polyval-ce-glue.c      |  5 ++--
 6 files changed, 18 insertions(+), 63 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 25cd3808ecbe..a92ca6de1f96 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -125,16 +125,11 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 			scatterwalk_start(&walk, sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
-		n = min_t(u32, n, SZ_4K); /* yield NEON at least every 4k */
 		p = scatterwalk_map(&walk);
 
 		macp = ce_aes_ccm_auth_data(mac, p, n, macp, ctx->key_enc,
 					    num_rounds(ctx));
 
-		if (len / SZ_4K > (len - n) / SZ_4K) {
-			kernel_neon_end();
-			kernel_neon_begin();
-		}
 		len -= n;
 
 		scatterwalk_unmap(p);
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index af2bbca38e70..37ca3e889848 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -87,17 +87,9 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 	    !crypto_simd_usable())
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
-	do {
-		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
-
-		kernel_neon_begin();
-		chacha_doneon(state, dst, src, todo, nrounds);
-		kernel_neon_end();
-
-		bytes -= todo;
-		src += todo;
-		dst += todo;
-	} while (bytes);
+	kernel_neon_begin();
+	chacha_doneon(state, dst, src, bytes, nrounds);
+	kernel_neon_end();
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 09eb1456aed4..ccc3f6067742 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -37,18 +37,9 @@ static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
-		do {
-			unsigned int chunk = length;
-
-			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
-				chunk = SZ_4K;
-
-			kernel_neon_begin();
-			*crc = crc_t10dif_pmull_p8(*crc, data, chunk);
-			kernel_neon_end();
-			data += chunk;
-			length -= chunk;
-		} while (length);
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull_p8(*crc, data, length);
+		kernel_neon_end();
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
 	}
@@ -62,18 +53,9 @@ static int crct10dif_update_pmull_p64(struct shash_desc *desc, const u8 *data,
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
-		do {
-			unsigned int chunk = length;
-
-			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
-				chunk = SZ_4K;
-
-			kernel_neon_begin();
-			*crc = crc_t10dif_pmull_p64(*crc, data, chunk);
-			kernel_neon_end();
-			data += chunk;
-			length -= chunk;
-		} while (length);
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull_p64(*crc, data, length);
+		kernel_neon_end();
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
 	}
diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index e4a0b463f080..7df0ab811c4e 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -22,15 +22,9 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 	if (srclen < 64 || !crypto_simd_usable())
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
-	do {
-		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
-
-		kernel_neon_begin();
-		crypto_nhpoly1305_update_helper(desc, src, n, nh_neon);
-		kernel_neon_end();
-		src += n;
-		srclen -= n;
-	} while (srclen);
+	kernel_neon_begin();
+	crypto_nhpoly1305_update_helper(desc, src, srclen, nh_neon);
+	kernel_neon_end();
 	return 0;
 }
 
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index 1fae18ba11ed..326871897d5d 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -143,20 +143,13 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
 
 		if (static_branch_likely(&have_neon) && crypto_simd_usable()) {
-			do {
-				unsigned int todo = min_t(unsigned int, len, SZ_4K);
-
-				kernel_neon_begin();
-				poly1305_blocks_neon(&dctx->h, src, todo, 1);
-				kernel_neon_end();
-
-				len -= todo;
-				src += todo;
-			} while (len);
+			kernel_neon_begin();
+			poly1305_blocks_neon(&dctx->h, src, len, 1);
+			kernel_neon_end();
 		} else {
 			poly1305_blocks(&dctx->h, src, len, 1);
-			src += len;
 		}
+		src += len;
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
 
diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
index 0a3b5718df85..8c83e5f44e51 100644
--- a/arch/arm64/crypto/polyval-ce-glue.c
+++ b/arch/arm64/crypto/polyval-ce-glue.c
@@ -122,9 +122,8 @@ static int polyval_arm64_update(struct shash_desc *desc,
 					    tctx->key_powers[NUM_KEY_POWERS-1]);
 	}
 
-	while (srclen >= POLYVAL_BLOCK_SIZE) {
-		/* allow rescheduling every 4K bytes */
-		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
+	if (srclen >= POLYVAL_BLOCK_SIZE) {
+		nblocks = srclen / POLYVAL_BLOCK_SIZE;
 		internal_polyval_update(tctx, src, nblocks, dctx->buffer);
 		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
 		src += nblocks * POLYVAL_BLOCK_SIZE;
-- 
2.43.0.rc1.413.gea7ed67945-goog

