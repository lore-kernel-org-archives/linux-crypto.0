Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793770735;
	b=NTdBzG1wWDo0yoTzsBeRBIDujICtpmivw6DMeGCNWSvuenTvgN0e/l6+dmGlpAXjJhf2
	 zEUjV+j5d9SczW8xXnOtdGJ760fR11nH1EgDXC3o492AALoQdk9NXzPIG/5nSrkLdE6tu
	 j02uoTg0mEotH+1prGFlAwzDQ0FwT9lN06RS8QCvQ5pvr/3eurmkHkXwZQ7jFch6NthF2
	 dJWv/tcrsRrLTido1Us1KrJVmuzvWggO4CEldUrIySU+vQtnLMgPm/Toi9nqXHetzGKsV
	 y9b/hYPhvRZ9MJndNPS/Y1HBoqR7bgbFKfZ2QsIe+r0Y9h/DuAPxFJxnJH0NO5sFrSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793770735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xQLzKzl6PB5o9Q+gWyP4dEufl7NGFTpQelnBQNFTonI=;
	b=rm8vzXPi3sVe4PUsACLYLqQQRnCOWQMUEZvlve25GJLxQwRgUB3FOL83+LWbBOZ6QNFo
	 3oQM/ZGmxFW03niHwjOA9RQGUxSzS7F/+nrrjlzKs409Ei4O09sw8/qF4nKcUrBYM+be1
	 rJFCkZpP1GLrvdaAoqE/5PwMFNhN6kr4huwj/LTWHSxYxlFSZmqN3M7ZIQuRgdRK/hamw
	 7SSLkJDJqp5H9Xmb67XRtdLduDbhArleVKOq+16EwMg2TxXvvx+P3jz9eZpyXyfeTpoXS
	 ge2UIcGcQR/ZmflfbWPXnZ8iZrR5CzEx4I5gcjrke6Ic8D72znVzZao8iKgMVoBxwXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcujtlWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29841606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 05:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcujtlWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9501B1F000C1;
	Wed,  4 Nov 2026 05:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793770734;
	bh=xQLzKzl6PB5o9Q+gWyP4dEufl7NGFTpQelnBQNFTonI=;
	h=From:To:Cc:Subject:Date;
	b=hcujtlWcge5NqolCnpgAz2K0sUVt23oPkGvhryeN2ID6HPPSbjqM7RKVWxYnShohU
	 a9Ld9tyqfvGuJ8xG6JprfluTBqdQwp4Kecy8KR2yTqFiYjwMzlA7Us1qfYQvPbRqdm
	 3D8ufd0pZUOqBtAbKUebq51uYnMs2frylPNn4WpeSwhAfoAxVznlfuehfywASS3KhQ
	 r3/oMxJxnWxtoA1Y8leUWnbDO9JP6UCb/buWpoyd0q3I24IqKnPeNeKszd9GtCUuAb
	 DFd2RYUyzN2B21Ex6mmN/zvXZOlvsTERiHihezUSvsvDxCGB2kS+IOzOfTZiBBGLgd
	 DGRzE7nvbubXg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Remove vzeroupper at beginning of functions
Date: Tue,  3 Nov 2026 21:38:30 -0800
Message-ID: <20261104053830.82604-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

There's no point in executing vzeroupper at the beginning of the AVX2
and AVX-512 optimized functions.  Remove it, leaving the vzeroupper at
the end (where it is needed) only.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha-avx2-x86_64.S   | 5 -----
 lib/crypto/x86/chacha-avx512-x86_64.S | 6 ------
 2 files changed, 11 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx2-x86_64.S b/lib/crypto/x86/chacha-avx2-x86_64.S
index f3d8fc018249..0b0cf92a022c 100644
--- a/lib/crypto/x86/chacha-avx2-x86_64.S
+++ b/lib/crypto/x86/chacha-avx2-x86_64.S
@@ -46,8 +46,6 @@ SYM_FUNC_START(chacha_2block_xor_avx2)
 	# on four words in each matrix in parallel, but requires shuffling to
 	# rearrange the words after each round.
 
-	vzeroupper
-
 	# x0..3[0-2] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
@@ -240,8 +238,6 @@ SYM_FUNC_START(chacha_4block_xor_avx2)
 	# required word shuffling has a rather high latency, we can do the
 	# arithmetic on two matrix-pairs without much slowdown.
 
-	vzeroupper
-
 	# x0..3[0-4] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
@@ -548,7 +544,6 @@ SYM_FUNC_START(chacha_8block_xor_avx2)
 	# rotation is done with the slightly better performing byte shuffling,
 	# 7/12-bit word rotation uses traditional shift+OR.
 
-	vzeroupper
 	# 4 * 32 byte stack, 32-byte aligned
 	lea		8(%rsp),%r10
 	and		$~31, %rsp
diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index 422479631d5b..ffdfe005cba6 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -55,8 +55,6 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 	# on four words in each matrix in parallel, but requires shuffling to
 	# rearrange the words after each round.
 
-	vzeroupper
-
 	# x0..3[0-2] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
@@ -220,8 +218,6 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 	# required word shuffling has a rather high latency, we can do the
 	# arithmetic on two matrix-pairs without much slowdown.
 
-	vzeroupper
-
 	# x0..3[0-4] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
@@ -489,8 +485,6 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	# VL=32 encrypts eight blocks in 256-bit ymm registers.
 	# VL=64 encrypts sixteen blocks in 512-bit zmm registers.
 
-	vzeroupper
-
 	# x0..15[0-VL/4] = s[0..15]
 	vpbroadcastd	0x00(%rdi),V0
 	vpbroadcastd	0x04(%rdi),V1

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
prerequisite-patch-id: 890b33260038bff2e3adfe7867af5919666677fc
-- 
2.56.0

