Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794428113;
	b=q6Ki8Zvwc5Ok0PFQ3u7ygwPJNaDBQn4iN0DdZFjdVoLyny3wSLaCRC+YQD/8kseLyLi7
	 TRYuVzHSvZOEo+15Sg2rov0b73vUXZqWFoANUK+xkEk5pUe+d5ruxpXhzGZM6IQ+VKSRU
	 2+hkxzhAADF1/UBp5IE3tMuwvlj3PuM+awwzwUN7Xz6s5vzhfjoXDIppWr0l3potDOWc5
	 OqzgPTQ8iVTeGCpCJ1eiHkm37siyAev1vAeksl/CyArAX6OYAX/dL71l/SvzO1xyJPLFN
	 cuhzHZEnkFaRp3pRkO76uHeVwc8nrrxQYcjQntVrIBVqX9dsjh3MUouPOCrA1tsEJcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794428113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fswX6d9UIE/xGMSzpJoHKuSxeWuTVUIa3MDn9uteH9A=;
	b=OQvREwlEmGb85w2VpmXHpzbHaH8ccJ+d7EX8mJunEJwCnjOcztixCmbtYs/+sZ9yXb8E
	 NXQwNZ0ZiprQslT8IZYqdG67EZTmpAiOQA5IYRq24KPkj29TrF5QqesTcij6Hda7ksD1O
	 r5sMiuS/lGTaur+Ksm3w/WGdJO3rD6MBgyjNf1xnp/i4+7nAH25S2q2endUn9iKoE3tbt
	 34M2ALg1HAWH41IQdLwUv7SnUoGDd6+EFBwTTGr09sRb5b/m4kYjY2wSh5OJzEAq1msly
	 Q7xTQhAqtnXythCQsPfYh6TI8kU598tjTYesO/3Onx3pJdvGhsu+e4IkAJsBtuvXuJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DsNx/+7o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A61606A32D
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 20:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DsNx/+7o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49F91F00A07;
	Wed, 11 Nov 2026 20:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794428113;
	bh=fswX6d9UIE/xGMSzpJoHKuSxeWuTVUIa3MDn9uteH9A=;
	h=From:To:Cc:Subject:Date;
	b=DsNx/+7o+m53/OtSjzvYHoVLK2UfmV7S7eZ9bzMJ31rZEK2qITtyZCTJmkBsGZQEr
	 RpulqF/7G6skaigP6cnimbd+oqU7vhV82qHUBS37hLPXdXM7m3T//uk4P2k1taeASc
	 OLLRlARZhxZEMnIjO3Uudvqh67tG40GeH38JN/eamg/Mn1sqAOu0qt7jrBVSucqpsi
	 7vWFCRXBjP8GzdyTWbq2+vZOuUY17goLpYhC6LWKYkNEycgiu2NRTQYDBSY8ES85HF
	 CoVlXEeciEEZM+FxCvF5tGP1BbMboCLFfNWqaJCkjpkmmFfDg4OrDpMZC2gjpb4BBR
	 bGT031LKfB/WQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/blake2s: Drop redundant checks for AVX and AVX512F
Date: Wed, 11 Nov 2026 12:14:36 -0800
Message-ID: <20261111201436.39855-1-ebiggers@kernel.org>
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

X86_FEATURE_AVX2 implies X86_FEATURE_AVX.  Similarly,
X86_FEATURE_AVX512VL implies X86_FEATURE_AVX512F (and X86_FEATURE_AVX).

Simplify blake2s_mod_init_arch() accordingly.  Also nest these checks
under the block that sets the static key for blake2s_use_ssse3,
mirroring the code that uses these static keys.

(Note: as usual, arch/x86/kernel/cpu/cpuid-deps.c is non-enforcing: if a
dependency isn't met, it warns and doesn't prevent booting.  However,
that case doesn't occur in real CPUs and is unsupported.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/lib/crypto/x86/blake2s.h b/lib/crypto/x86/blake2s.h
index 952db559eed34..e504279a2fa38 100644
--- a/lib/crypto/x86/blake2s.h
+++ b/lib/crypto/x86/blake2s.h
@@ -49,12 +49,10 @@ static void blake2s_compress(struct blake2s_ctx *ctx,
 #define blake2s_mod_init_arch blake2s_mod_init_arch
 static void blake2s_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_SSSE3))
+	if (boot_cpu_has(X86_FEATURE_SSSE3)) {
 		static_branch_enable(&blake2s_use_ssse3);
-
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_AVX2) &&
-	    boot_cpu_has(X86_FEATURE_AVX512F) &&
-	    boot_cpu_has(X86_FEATURE_AVX512VL))
-		static_branch_enable(&blake2s_use_avx512);
+		if (boot_cpu_has(X86_FEATURE_AVX2) &&
+		    boot_cpu_has(X86_FEATURE_AVX512VL))
+			static_branch_enable(&blake2s_use_avx512);
+	}
 }

base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.1

