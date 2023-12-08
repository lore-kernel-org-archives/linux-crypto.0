Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H5V2xJ5Y"
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E10910F7
	for <linux-crypto@vger.kernel.org>; Fri,  8 Dec 2023 03:32:50 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d7e7e10231so12634247b3.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Dec 2023 03:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702035169; x=1702639969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tIW6OxkQLD6ojtSOM3oZEkZa7hR7XnG6NZiYsQLCSik=;
        b=H5V2xJ5YINiq/gZGqofpu4lYZF4+LghiGp7lEnHPvKcj2HEAA8L09OCwFpoTLEpPgZ
         VN8JyRC4ScbZhvLxWDuxl7D6SedV1e382B14ZORiYqQWAclKsWFVPhrxYtQj7asC3Ym6
         GzV01qi6dVymox9nBotpSN0doX1vw2GOc0SLwkOQyolWYh8GaGbB8kPwjulLxApn1GB6
         L5XFwkpAOQQ24YDjQfRz2sRgwNiBC4sKVPoxuzGOKKS28iKvNpqiNOqZAwwCibVjWnr8
         6kJClXzhIlFFVPdOwy2jSn2LK8MuzZ2Ayz8ThrOgM9dMwHvnXfnGnYe9+8dNZkYwk4uW
         6A6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702035169; x=1702639969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tIW6OxkQLD6ojtSOM3oZEkZa7hR7XnG6NZiYsQLCSik=;
        b=EeQrWYEyaRnODqrpCEkZ1101amZ1SUlJjHAYnfIcSGFKh1XeZF/aEjwoQvrOXpv77r
         cPIvCT1szQJmeHHuGgU/jdtEGaX12TEG0r7O3e1k3B5Zim2GV/+zMeqBBn7SCVKGoSsI
         OLRcvq4aWlf7+Jxu8si7PmCKQAHCIHzM39zwoPfffOjNmNxnvlPaKW0VTD8bRicIjZcT
         YQB3Pb57eK+F9hy5D+mh5El490RpJ1XSHLFxdgQteImcjnoUdyhs3J763XknWvdXjKIw
         jbPKf1Cmt7r735UUOWKK8COCyKLTF4FLmPOdeiExQOrGbQoJTp+HIwac02qFCw9tataA
         brLw==
X-Gm-Message-State: AOJu0YyU0RbqbP0qaCyEoYJJc6RChR/DNAK/jAP5tblQQqNoayfqBHv0
	mnFmjVQZ6Nh0vGxzMEEG5OSRWOEI
X-Google-Smtp-Source: AGHT+IGmi88gIiTU25m/DqJSHEAZeeNr73MSkwK61S+3OU/oHCtmTGtgJXqoqfhL2wBZUn5l7SaTiMG7
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a81:fe09:0:b0:5d3:d44a:578d with SMTP id
 j9-20020a81fe09000000b005d3d44a578dmr11434ywn.4.1702035169745; Fri, 08 Dec
 2023 03:32:49 -0800 (PST)
Date: Fri,  8 Dec 2023 12:32:23 +0100
In-Reply-To: <20231208113218.3001940-6-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208113218.3001940-6-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6423; i=ardb@kernel.org;
 h=from:subject; bh=CrHTaHJltEK6PeCTI4LoBKpJ8PhFKRqD4hhGSJUvD44=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIbXo37Ft8nUvf9254Rmw993GMzGn3L8e/NO2JereI4mHm
 6oSVCKSO0pZGMQ4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEklkY/medMDjxp/i3kaqn
 vNqdY+7F9XPTTzA+N1x0Y8qkfQIPOjoYGfY7zdJgzWI+tuI8ywOudlmPaqG9V7KDbz+pCk5bzRP AyQAA
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231208113218.3001940-10-ardb@google.com>
Subject: [PATCH v4 4/4] arm64: crypto: Disable yielding logic unless CONFIG_PREEMPT_VOLUNTARY=y
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that kernel mode use of SIMD runs with preemption enabled, the
explicit yield logic is redundant for preemptible builds, and since it
should not actually be used at all on non-preemptible builds (where
kernel work is supposed to run to completion and not give up its time
slice prematurely), let's make it depend on CONFIG_PREEMPT_VOLUNTARY.

Once CONFIG_PREEMPT_VOLUNTARY is removed, all the logic it guards can be
removed as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c      | 8 ++++++--
 arch/arm64/crypto/chacha-neon-glue.c     | 5 ++++-
 arch/arm64/crypto/crct10dif-ce-glue.c    | 6 ++++--
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 5 ++++-
 arch/arm64/crypto/poly1305-glue.c        | 5 ++++-
 arch/arm64/crypto/polyval-ce-glue.c      | 9 +++++++--
 arch/arm64/include/asm/assembler.h       | 4 ++--
 7 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 25cd3808ecbe..82e293a698ff 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -125,13 +125,17 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 			scatterwalk_start(&walk, sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
-		n = min_t(u32, n, SZ_4K); /* yield NEON at least every 4k */
+
+		if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY))
+			n = min_t(u32, n, SZ_4K); /* yield NEON at least every 4k */
+
 		p = scatterwalk_map(&walk);
 
 		macp = ce_aes_ccm_auth_data(mac, p, n, macp, ctx->key_enc,
 					    num_rounds(ctx));
 
-		if (len / SZ_4K > (len - n) / SZ_4K) {
+		if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) &&
+		    len / SZ_4K > (len - n) / SZ_4K) {
 			kernel_neon_end();
 			kernel_neon_begin();
 		}
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index af2bbca38e70..655b250cef4a 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -88,7 +88,10 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
 	do {
-		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
+		unsigned int todo = bytes;
+
+		if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY))
+			todo = min_t(unsigned int, todo, SZ_4K);
 
 		kernel_neon_begin();
 		chacha_doneon(state, dst, src, todo, nrounds);
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 09eb1456aed4..c6e8cf4f56da 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -40,7 +40,8 @@ static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
 		do {
 			unsigned int chunk = length;
 
-			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
+			if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) &&
+			    chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
 				chunk = SZ_4K;
 
 			kernel_neon_begin();
@@ -65,7 +66,8 @@ static int crct10dif_update_pmull_p64(struct shash_desc *desc, const u8 *data,
 		do {
 			unsigned int chunk = length;
 
-			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
+			if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) &&
+			    chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
 				chunk = SZ_4K;
 
 			kernel_neon_begin();
diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index e4a0b463f080..cbbc51b27d93 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -23,7 +23,10 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
+		unsigned int n = srclen;
+
+		if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY))
+			n = min_t(unsigned int, n, SZ_4K);
 
 		kernel_neon_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, nh_neon);
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index 1fae18ba11ed..27f84f5bfc98 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -144,7 +144,10 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 
 		if (static_branch_likely(&have_neon) && crypto_simd_usable()) {
 			do {
-				unsigned int todo = min_t(unsigned int, len, SZ_4K);
+				unsigned int todo = len;
+
+				if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY))
+					todo = min_t(unsigned int, todo, SZ_4K);
 
 				kernel_neon_begin();
 				poly1305_blocks_neon(&dctx->h, src, todo, 1);
diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
index 0a3b5718df85..c4c0fb3fcaf4 100644
--- a/arch/arm64/crypto/polyval-ce-glue.c
+++ b/arch/arm64/crypto/polyval-ce-glue.c
@@ -123,8 +123,13 @@ static int polyval_arm64_update(struct shash_desc *desc,
 	}
 
 	while (srclen >= POLYVAL_BLOCK_SIZE) {
-		/* allow rescheduling every 4K bytes */
-		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
+		unsigned int len = srclen;
+
+		if (IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY))
+			/* allow rescheduling every 4K bytes */
+			len = min(len, 4096U);
+
+		nblocks = len / POLYVAL_BLOCK_SIZE;
 		internal_polyval_update(tctx, src, nblocks, dctx->buffer);
 		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
 		src += nblocks * POLYVAL_BLOCK_SIZE;
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 376a980f2bad..0180ac1f9b8b 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -769,6 +769,7 @@ alternative_endif
 	 * field)
 	 */
 	.macro		cond_yield, lbl:req, tmp:req, tmp2:req
+#ifdef CONFIG_PREEMPT_VOLUNTARY
 	get_current_task \tmp
 	ldr		\tmp, [\tmp, #TSK_TI_PREEMPT]
 	/*
@@ -777,15 +778,14 @@ alternative_endif
 	 * run to completion as quickly as we can.
 	 */
 	tbnz		\tmp, #SOFTIRQ_SHIFT, .Lnoyield_\@
-#ifdef CONFIG_PREEMPTION
 	sub		\tmp, \tmp, #PREEMPT_DISABLE_OFFSET
 	cbz		\tmp, \lbl
-#endif
 	adr_l		\tmp, irq_stat + IRQ_CPUSTAT_SOFTIRQ_PENDING
 	get_this_cpu_offset	\tmp2
 	ldr		w\tmp, [\tmp, \tmp2]
 	cbnz		w\tmp, \lbl	// yield on pending softirq in task context
 .Lnoyield_\@:
+#endif
 	.endm
 
 /*
-- 
2.43.0.472.g3155946c3a-goog

