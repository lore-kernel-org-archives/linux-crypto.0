Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794428121;
	b=leimKAQXFpPzMA400XFwhOEbWtRP2Bkq+oqEOVsY2O3gy/IfKlAeI0RM+LiCY1r1bCrM
	 hKoX10fQyq3pH5iC62k7zctQXFTAOtTDGm3nAnuvefnDygyhh9+hpflzwuy/lmDjmc/sh
	 u/vHQ6JXvgnFiQhZNioAiD4gmFqvlDKBiytAMT8BbrMmyEvQgKg9eqhiS54rl4099y25A
	 UWIWepVeJsxFa7XP/EBWndYa3FXQv+RkdbfyaBNvR70Fj+DclFsv3O5wd+DzLOrvDFUxv
	 rLXVPumT+q5XnDRcPbYZLtuwz+T98DQjruiUu07VH1bmWXMlSloLTd3Pi1DrSBpruhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794428121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s6V0RNyXyZYrQMxuFEP3/ICRTep3TpJ9KGiBuY2dqZw=;
	b=UHa1BjI2t2mgKaWALav74eyPTav6vh1A8f6Z/sHZ+Vm7xgqTVN+7hDuX6btEqhmkG3Sz
	 N6MbMSyppuL9+SrbRRMdo8I4fuytW+IETTBNMED6HLQ3qbBhRgvr2OPsKmjfu5gTj/VXS
	 u/lpY4kCns+3M94cKeF90mUIhOf2UYKyIGS9O7lLXjjhRMWe21UoLbHRGXQo6oyZK1Bun
	 FD19LAyh36+fuCLaGIooWmXlHyYEP+JIDO7/n5WrXluy0eVgXbakwUkVlqmW+PuuPQHFr
	 +AtsxPFRJf+5qmJWWPDHRKy/D4/1Fioe4PH/geRcMpnlMRSI7cOgy2zdF4JvZMmEoNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DS0EuSoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0BC606A334
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 20:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DS0EuSoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1791F00A07;
	Wed, 11 Nov 2026 20:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794428121;
	bh=s6V0RNyXyZYrQMxuFEP3/ICRTep3TpJ9KGiBuY2dqZw=;
	h=From:To:Cc:Subject:Date;
	b=DS0EuSoAeu2EJ606SJ2+UyhrH+N6gY5cDk5WQyaoIY/rZarptOA3RN+EKVXUZa9f8
	 tcA/PTBH/TBzUGNtYD+FSslmbya2qNmPTJqLXSSNMlxayM0nk1eD+opb/Hb1sK3KP2
	 iskrzOYEpLY4nDxTwJvdyHQ7vzI06hbXxuFhp5RpcH3n69ChYhVL8xIZfgDkOa17Oi
	 L2/loGO/YNL3HgNI+f4dfEl5m6tDSJQuZA4YLSjGmFOr781Wr9h2lsCwy+K/Yo4pb5
	 MEVBZPdXqbzbFIBXkPDqP+XQI6F1MzHhZFd+U2pRLBvyz04FekCJzCzKJ1Rs/YN2f7
	 SLPGgguUOBRuA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Drop redundant check for AVX
Date: Wed, 11 Nov 2026 12:15:17 -0800
Message-ID: <20261111201517.39989-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
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

X86_FEATURE_AVX2 implies X86_FEATURE_AVX.  Simplify
chacha_mod_init_arch() accordingly.

(Note: as usual, arch/x86/kernel/cpu/cpuid-deps.c is non-enforcing: if a
dependency isn't met, it warns and doesn't prevent booting.  However,
that case doesn't occur in real CPUs and is unsupported.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index 76cddc522fa04..3e465184ca87b 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -188,8 +188,7 @@ static void chacha_mod_init_arch(void)
 
 	static_branch_enable(&chacha_use_simd);
 
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_AVX2)) {
+	if (boot_cpu_has(X86_FEATURE_AVX2)) {
 		static_branch_enable(&chacha_use_avx2);
 
 		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&

base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.1

