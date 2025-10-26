Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9F9288C3D;
	Sun, 26 Oct 2025 05:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457989; cv=none; b=VBDtU6NIIL4l1rLLoyW/9YWtV0Pta9VpYLhiJvBizPP600E1jP/AWwvLMo9QzBk06oUgF4cSXDxpLydFuRNYMtCFggkvUOggIC9iDN6IVNKys/hiOTT68L1cgF7VgpwTIDie8ElMNr9xc39IaoQ2I5Ny3sar7CUPGkMzvmsb7k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457989; c=relaxed/simple;
	bh=tK4ZwtbvVT+WWMAoNFlch+KJGW1l/8qhroTz/lgXZ+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtywViQyNsVhA55lRfIMU6mb756YGhJ0d1ffxEBXUgPC06MLu1Vu2uQb1JUdnPfTs6wt7vsk05MZ9Bf4rwfGgaQXCinBW5nkxcqZ3gaI2cFeIz9q9KocRemm80Gzro9Ir5VfSm7zYph6FDhcJJTHYKqffQzEDMlZNuUrtbQi8ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjCjZuVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjCjZuVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68413C116C6;
	Sun, 26 Oct 2025 05:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457988;
	bh=tK4ZwtbvVT+WWMAoNFlch+KJGW1l/8qhroTz/lgXZ+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjCjZuVIcC04piSCOr/VPr+Acxc4Jbc9WzwyZjZsuZyijzdgb4V2ePe38orck/ib4
	 0QDKFZgHjokI7bVMZWsYUuc5osS8lr1CTrTtc4tVumVXTGVy2QFbBft1mQwlkFKYwj
	 EyuYZXpOpVH7tKFGUGFf9wvRiuQibbsFoeFc5THM2DijB77in3MrMLNRpya/Bj0PuX
	 ZDj47k4Sy1BRg1Z5kQEmwrVqxi6F4NHEQldxYeGterWeNg57gMojOcKASpAW3uDvEs
	 Zz7xK6V/lReCdjwRzMavc+tLiIDxETdLKM7iZYd/rjCBbR6EKISWx5mn73nHurZXcE
	 S5wYHNmhhtH5g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/15] lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
Date: Sat, 25 Oct 2025 22:50:29 -0700
Message-ID: <20251026055032.1413733-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some z/Architecture processors can compute a SHA-3 digest in a single
instruction.  Use this capability to implement the sha3_224(),
sha3_256(), sha3_384(), and sha3_512() library functions.

Note that the performance improvement is likely to be relatively small
and be noticeable primarily on short messages, as the actual Keccak
permutation is already accelerated via the implementations of
sha3_absorb_blocks() and sha3_keccakf().  Nevertheless,
arch/s390/crypto/ takes advantage of the "do the full SHA-3" capability,
and it was requested that lib/crypto/ do so as well for parity with it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/s390/sha3.h | 67 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/s390/sha3.h b/lib/crypto/s390/sha3.h
index 668e53da93d2c..85471404775a3 100644
--- a/lib/crypto/s390/sha3.h
+++ b/lib/crypto/s390/sha3.h
@@ -6,10 +6,11 @@
  */
 #include <asm/cpacf.h>
 #include <linux/cpufeature.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha3);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha3_init_optim);
 
 static void sha3_absorb_blocks(struct sha3_state *state, const u8 *data,
 			       size_t nblocks, size_t block_size)
 {
 	if (static_branch_likely(&have_sha3)) {
@@ -58,10 +59,65 @@ static void sha3_keccakf(struct sha3_state *state)
 	} else {
 		sha3_keccakf_generic(state);
 	}
 }
 
+static inline bool s390_sha3(int func, const u8 *in, size_t in_len,
+			     u8 *out, size_t out_len)
+{
+	struct sha3_state state;
+
+	if (!static_branch_likely(&have_sha3))
+		return false;
+
+	if (static_branch_likely(&have_sha3_init_optim))
+		func |= CPACF_KLMD_NIP | CPACF_KLMD_DUFOP;
+	else
+		memset(&state, 0, sizeof(state));
+
+	cpacf_klmd(func, &state, in, in_len);
+
+	if (static_branch_likely(&have_sha3_init_optim))
+		kmsan_unpoison_memory(&state, out_len);
+
+	memcpy(out, &state, out_len);
+	memzero_explicit(&state, sizeof(state));
+	return true;
+}
+
+#define sha3_224_arch sha3_224_arch
+static bool sha3_224_arch(const u8 *in, size_t in_len,
+			  u8 out[SHA3_224_DIGEST_SIZE])
+{
+	return s390_sha3(CPACF_KLMD_SHA3_224, in, in_len,
+			 out, SHA3_224_DIGEST_SIZE);
+}
+
+#define sha3_256_arch sha3_256_arch
+static bool sha3_256_arch(const u8 *in, size_t in_len,
+			  u8 out[SHA3_256_DIGEST_SIZE])
+{
+	return s390_sha3(CPACF_KLMD_SHA3_256, in, in_len,
+			 out, SHA3_256_DIGEST_SIZE);
+}
+
+#define sha3_384_arch sha3_384_arch
+static bool sha3_384_arch(const u8 *in, size_t in_len,
+			  u8 out[SHA3_384_DIGEST_SIZE])
+{
+	return s390_sha3(CPACF_KLMD_SHA3_384, in, in_len,
+			 out, SHA3_384_DIGEST_SIZE);
+}
+
+#define sha3_512_arch sha3_512_arch
+static bool sha3_512_arch(const u8 *in, size_t in_len,
+			  u8 out[SHA3_512_DIGEST_SIZE])
+{
+	return s390_sha3(CPACF_KLMD_SHA3_512, in, in_len,
+			 out, SHA3_512_DIGEST_SIZE);
+}
+
 #define sha3_mod_init_arch sha3_mod_init_arch
 static void sha3_mod_init_arch(void)
 {
 	int num_present = 0;
 	int num_possible = 0;
@@ -77,12 +133,19 @@ static void sha3_mod_init_arch(void)
 	({ num_present += !!cpacf_query_func(opcode, func); num_possible++; })
 	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_224);
 	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_256);
 	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_384);
 	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_512);
+	QUERY(CPACF_KLMD, CPACF_KLMD_SHA3_224);
+	QUERY(CPACF_KLMD, CPACF_KLMD_SHA3_256);
+	QUERY(CPACF_KLMD, CPACF_KLMD_SHA3_384);
+	QUERY(CPACF_KLMD, CPACF_KLMD_SHA3_512);
 #undef QUERY
 
-	if (num_present == num_possible)
+	if (num_present == num_possible) {
 		static_branch_enable(&have_sha3);
-	else if (num_present != 0)
+		if (test_facility(86))
+			static_branch_enable(&have_sha3_init_optim);
+	} else if (num_present != 0) {
 		pr_warn("Unsupported combination of SHA-3 facilities\n");
+	}
 }
-- 
2.51.1.dirty

