Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A52938BF6F;
	Mon, 12 Jan 2026 19:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245817; cv=none; b=RYjpP8hjUddO1t30F+yga5/RRkMx2YqFziGlLRQcX5Zg/GYCVe/BsgA+RmcjA8t6XBFv5n689jt32cOd+pFTG1LL9VoywcT5NRyLEKa2251cnHybdR07alwdg/ECPazJuUeYza899ywaSW0ITqHdVD+Yq36+7moDnr0yM/kRThg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245817; c=relaxed/simple;
	bh=b8+2isc/mWUmlO/3JdSbmkX86zq1F/K7GlRJMz6JOGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyWlJgq8E/oKhKxEK86Fsfp4RxHLUtAxrof1x3wUwrvLUtmGX5FE34CuwxfX8SnktxmvCXKlU1fKAUiwONtvaAe8/hcwK5kVmiHSTXjpYDcpxSDPxhOwcLcIK8TVDnYt1jsuR/S1rbN0HiU0iiGDJlLZiZ0Kjz7HsNhyfqE+arg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0KxQKZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0KxQKZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6FEC2BC87;
	Mon, 12 Jan 2026 19:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245817;
	bh=b8+2isc/mWUmlO/3JdSbmkX86zq1F/K7GlRJMz6JOGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0KxQKZz4i1RsOIjwLOOJXRfsPl591C6xVTDsyPT/wulXI86KQAv8RU2kd7ep/SaL
	 zQvgA1Gym7fI7zoT+USMG//U9qE9UXwwME2vdvVHXKVdXjAtx54Ohch2D7CMbhkA5/
	 X6C0SH88Al9aHufVFNgjnGM96SggfDltB7624aEEJGCeq/fizRgyG19Oi5XUMRgsY3
	 N5+7hHLYL3IuXtC2+uvsqfw8e5vT743c3gn+zrczsKCTpxZzMemonA8zrSunSiIagR
	 D96qKtgMHNtpzT799tZxr8HGA0htwIxkqmMFBRFAiCEHlUA9gxLwDwC6SW2U2VaUuN
	 x3lQpzaJ9SoXw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 35/35] lib/crypto: aes: Drop 'volatile' from aes_sbox and aes_inv_sbox
Date: Mon, 12 Jan 2026 11:20:33 -0800
Message-ID: <20260112192035.10427-36-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The volatile keyword is no longer necessary or useful on aes_sbox and
aes_inv_sbox, since the table prefetching is now done using a helper
function that casts to volatile itself and also includes an optimization
barrier.  Since it prevents some compiler optimizations, remove it.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aes.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index b7ab2d0c4e59..b73e19f1bb95 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -9,15 +9,11 @@
 #include <linux/crypto.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
 
-/*
- * Emit the sbox as volatile const to prevent the compiler from doing
- * constant folding on sbox references involving fixed indexes.
- */
-static volatile const u8 ____cacheline_aligned aes_sbox[] = {
+static const u8 ____cacheline_aligned aes_sbox[] = {
 	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
 	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
 	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
 	0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
 	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
@@ -48,11 +44,11 @@ static volatile const u8 ____cacheline_aligned aes_sbox[] = {
 	0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
 	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
 	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
 };
 
-static volatile const u8 ____cacheline_aligned aes_inv_sbox[] = {
+static const u8 ____cacheline_aligned aes_inv_sbox[] = {
 	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
 	0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
 	0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,
 	0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
 	0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d,
@@ -428,11 +424,11 @@ static void __maybe_unused aes_decrypt_generic(const u32 inv_rndkeys[],
 		w[1] = w1;
 		w[2] = w2;
 		w[3] = w3;
 	} while (--n);
 
-	aes_prefetch((const void *)aes_inv_sbox, sizeof(aes_inv_sbox));
+	aes_prefetch(aes_inv_sbox, sizeof(aes_inv_sbox));
 	put_unaligned_le32(declast_quarterround(w, 0, *rkp++), &out[0]);
 	put_unaligned_le32(declast_quarterround(w, 1, *rkp++), &out[4]);
 	put_unaligned_le32(declast_quarterround(w, 2, *rkp++), &out[8]);
 	put_unaligned_le32(declast_quarterround(w, 3, *rkp++), &out[12]);
 }
-- 
2.52.0

