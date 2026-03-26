Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05CE37F756;
	Thu, 26 Mar 2026 03:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774495986; cv=none; b=bu6IDGd2w9/4ddfr/yu0F7n4kApQ2knZJmIoVVaOOClq397YWJ1oxwX151N3V51DLcB3xiY5fBkJAvNz+v9WHHka/PJb1mQhF9u+z/GwmBP5no7JQMJ3XbarxH8R3zwpeYTEno98QIguCzsesmyNy/exp53dQJ4dkttAPvaVpUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774495986; c=relaxed/simple;
	bh=Tf1Gc+wdaA69JC/0diifOEr9gLMWAOHHyznsWH5jEEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K+3hbzavxUslD4JpmsT6ugpUOG0YuK2BX2VNQr2j5a6QPc4SbfExKvN4iBR1+8rI2NkGFsAYt82v+lh6jbZeOOoVpvQY8xxjeddPN+aWxUR7sPR9qiQPg7l0ObWZsZKJCaK2C9LSqPcmK4RngY3MRji9ehhbeyS0JJQK2u1VcV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drH4eTLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drH4eTLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8232C4CEF7;
	Thu, 26 Mar 2026 03:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774495986;
	bh=Tf1Gc+wdaA69JC/0diifOEr9gLMWAOHHyznsWH5jEEQ=;
	h=From:To:Cc:Subject:Date:From;
	b=drH4eTLXJ0sbgyelffhZhxTdhuW2c2k2Iw2nd3zgjA5+KZvu+vcWt42lnkEvEaeiD
	 91K0kuwfQL8KjYwJD64u5rbUbqDag8DOXIOpWM3hAaXnbRk7KXsScjITvWw5GUrPry
	 oRggzwnaXZiKUI4nH0kigRtdpTA+39l9pG1rNq6jjozZJ4swY2GmmWcGGUSm8rOQ5+
	 gDDi91I6urNFz40gZ/eel+si5lUPsnw7oC4lUyF0QUCs7bFeApOJewQpSTl2pWIYGt
	 myrwKZl2H1m/m8gUJOy9t3csdQxKXJKXE79HE0H4DtLzX/3ul67KGkfQzQxoILNkfs
	 dMy4Kd1rFOxcQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] lib/crypto: chacha - Zeroize permuted_state before it leaves scope
Date: Wed, 25 Mar 2026 20:29:20 -0700
Message-ID: <20260326032920.39408-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the ChaCha permutation is invertible, the local variable
'permuted_state' is sufficient to compute the original 'state', and thus
the key, even after the permutation has been done.

While the kernel is quite inconsistent about zeroizing secrets on the
stack (and some prominent userspace crypto libraries don't bother at all
since it's not guaranteed to work anyway), the kernel does try to do it
as a best practice, especially in cases involving the RNG.

Thus, explicitly zeroize 'permuted_state' before it goes out of scope.

Fixes: c08d0e647305 ("crypto: chacha20 - Add a generic ChaCha20 stream cipher implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-fixes

 lib/crypto/chacha-block-generic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/crypto/chacha-block-generic.c b/lib/crypto/chacha-block-generic.c
index 77f68de71066..4a6d627580cb 100644
--- a/lib/crypto/chacha-block-generic.c
+++ b/lib/crypto/chacha-block-generic.c
@@ -85,10 +85,12 @@ void chacha_block_generic(struct chacha_state *state,
 	for (i = 0; i < ARRAY_SIZE(state->x); i++)
 		put_unaligned_le32(permuted_state.x[i] + state->x[i],
 				   &out[i * sizeof(u32)]);
 
 	state->x[12]++;
+
+	chacha_zeroize_state(&permuted_state);
 }
 EXPORT_SYMBOL(chacha_block_generic);
 
 /**
  * hchacha_block_generic - abbreviated ChaCha core, for XChaCha
@@ -108,7 +110,9 @@ void hchacha_block_generic(const struct chacha_state *state,
 
 	chacha_permute(&permuted_state, nrounds);
 
 	memcpy(&out[0], &permuted_state.x[0], 16);
 	memcpy(&out[4], &permuted_state.x[12], 16);
+
+	chacha_zeroize_state(&permuted_state);
 }
 EXPORT_SYMBOL(hchacha_block_generic);

base-commit: 0138af2472dfdef0d56fc4697416eaa0ff2589bd
-- 
2.53.0

