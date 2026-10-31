Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793424104;
	b=3MhzelQvbHIeZIRpcglDDEX2SxkLlP5hI216A4MG38utmgd52rgo65CSX0Y+kTbzcjZK
	 zNxoNUa33ZZGkBQI4Iy3jHUXOWO1//s6nrVmUz94Jilg3B6tBb0pyBe2OqhVm3zXW+pW9
	 T0su7ViCpZp8FmxEn3M22GlTKUhiSRUVzptnqmI2YxGKnt7A+j+Jp5vSG7bnP1TWlnadf
	 OQ5IOGAxgZ2guupsTovwYVY1OcgI9WtMyqwPSgTSZZ79I5AsZgb86TpRkDxokoKbrBi/X
	 NOppm+MqywwhM2JAvOYwlQUdlbfQb7RzbJZwx9mHW5AUV8VUDXUkgsTq1HAXRxgrr/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793424104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UVQLNKSJ0xoMcIh6PNK6CJrWvUDHEQR4CpLyeNGEsgQ=;
	b=HGfWRdHCjVumx4uFoFCYynXCzXTbIxWJcAy0UFg3s4yhtSSoGwNtnVtKrdrjO5rrp447
	 9oA8jVKVd3gTk6ihCi5ZWa/wqAPqHuq/UEkZ/nik+UtYcEAHrPYxWGvwmZCwwl8TXsxLk
	 rGnoCqR5wbgxwQlbqCUj781wH4nJpuqH2QqG5mGAZNKkso4i43I6b/T26PYF1RvlGtJYc
	 gALjUEwMNHqLilMJCP7tfKuGUn0XWvV4e2OQV5/6JM7SGJEeBL7kU52aamrwAK6+CubtE
	 MFLnn0g6oCPkXciw6aHRVA5pH5xaUXYZt7KLjeu+GhdYnkJxt//RQcWm16ugJoyniqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l96ikhgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54443606A31D
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2026 05:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l96ikhgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B67A1F00A02;
	Sat, 31 Oct 2026 05:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793424104;
	bh=UVQLNKSJ0xoMcIh6PNK6CJrWvUDHEQR4CpLyeNGEsgQ=;
	h=From:To:Cc:Subject:Date;
	b=l96ikhgmTYeAtdTjSDqAkvgg9yJmAoBDN1GNy6q+tFoUEOXmTGoB8GC3m4xsmkM7Y
	 BX3bmD4V+nobdGldgiWBDgbra0b0cs9KxramSlmfyYpjMlsPQnpZ9DmjaoaTZHYeW9
	 HrmAhVtHUlb/bdFnEnNzgUDYnxQj0qxJT1iDm4Y+N9caJ9pP52hJpkD4JeIGFwukDz
	 CX+d1b3TPdLMp3yEw+e7F4CWgzqhS4dCDxcU49p02xJdcYOnRrm2zEp0ijJ6I9sN03
	 mMP0TinrbKiFUgsawAV9qIA+ZhBIyjTfU/icLiyHH2/oAv+W5S0OkY/rVHIk+eB83r
	 3AtBz0ODtcbQw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: aes-cmac: Hide selection mask value from compilers
Date: Fri, 30 Oct 2026 22:20:53 -0700
Message-ID: <20261031052053.201779-1-ebiggers@kernel.org>
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

Hide selection mask values from compilers, so that they cannot see that
they are used to select between two values and potentially generate a
secret-dependent branch.  This is not known to be happening here, but we
might as well be extra careful.

Since the selected values are only 0x87 and 0 here, change the type of
the mask to 'unsigned long' so that the compiler is not forced to
materialize it in a register pair on 32-bit architectures.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index e1c191551736..1d26fd8be028 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -578,7 +578,7 @@ static void aes_cbcmac_blocks(u8 h[AES_BLOCK_SIZE],
 int aes_cmac_preparekey(struct aes_cmac_key *key, const u8 *in_key,
 			size_t key_len)
 {
-	u64 hi, lo, mask;
+	u64 hi, lo;
 	int err;
 
 	/* Prepare the AES key. */
@@ -596,9 +596,11 @@ int aes_cmac_preparekey(struct aes_cmac_key *key, const u8 *in_key,
 	hi = be64_to_cpu(key->k_final[0].w[0]);
 	lo = be64_to_cpu(key->k_final[0].w[1]);
 	for (int i = 0; i < 2; i++) {
-		mask = ((s64)hi >> 63) & 0x87;
+		unsigned long mask = (s64)hi >> 63;
+
+		OPTIMIZER_HIDE_VAR(mask);
 		hi = (hi << 1) ^ (lo >> 63);
-		lo = (lo << 1) ^ mask;
+		lo = (lo << 1) ^ (mask & 0x87);
 		key->k_final[i].w[0] = cpu_to_be64(hi);
 		key->k_final[i].w[1] = cpu_to_be64(lo);
 	}

base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
-- 
2.56.0

