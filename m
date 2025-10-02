Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7B0299AB5;
	Thu,  2 Oct 2025 02:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372447; cv=none; b=VcuDbXXiCEUVaQDF+QggxsF6nezGdtLQ1jADXk551JetSCCsbziDT1mvjiqdIQWMlQiChZnquQuphbRvLSTMXvjoEyLodMxoUknG0X6kZ7TZ1/c2bC6zLVx7no3wuvgZSrTR1WCbVGtAmEh1gyWe6/MNxhxL3px1Q9DeWVcs5Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372447; c=relaxed/simple;
	bh=6DWpnf3bNtDRR7n325DwUu9lzxzMM6/DywrQc7FkP/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4Uqf5873GbLLzelngNO6sDJkUsz5Ii6gx517YVVFIZoVUCgj9bLO63oQH1xXWICgNYZLUvDR0ueZ2JMvZEgbZaeLuVksNdVXi0X+JAAogdTlqQ2KRuQ+sSansb3k7alPJgLbVOkNCIlNRFohINUpiqQDkFlb0JyJMV2FYa81/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O92lb1Cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O92lb1Cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F02C4CEF1;
	Thu,  2 Oct 2025 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372447;
	bh=6DWpnf3bNtDRR7n325DwUu9lzxzMM6/DywrQc7FkP/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O92lb1Cqcu6Wzn8/3DevXpbKaTHATydmPzpoWLTp382+ndBOj4p/nS/wBBx9u/ffe
	 303j1248OSCnCVJPTFBw39lRbEhlkc+QCEzfXlsnhQ0cQ0mBdIfsOrk5zinHP42o4/
	 bdtN63MCjc1smjNPX+0IJnwPLDlNT5dX+DlARmyGHqUL+POJc3Y/Mu0REnQDIETdS9
	 YB1KWfEioxlmD8FeggJZ8XCCNBUiFQe3hRHOAV/7UB7hQJuKTy1VjHxl2tbmyBXyy8
	 Q2zPz34M7vQ3YH1wvsO0cfMiGImTzPr9ex7LQqp89iFk55p14d0IBetLn588vduiDN
	 G/tZ9YxcjzDYg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/8] crypto: x86/aes-gcm - revise some comments in AVX512 code
Date: Wed,  1 Oct 2025 19:31:15 -0700
Message-ID: <20251002023117.37504-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002023117.37504-1-ebiggers@kernel.org>
References: <20251002023117.37504-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Fix some references to field names in struct aes_gcm_key_vaes_avx512.

- Remove the mention of the counter having to start at 2.  The assembly
  code doesn't actually assume that it does.

Note that these changes improve consistency with aes-gcm-vaes-avx2.S.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aes-gcm-vaes-avx512.S | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-vaes-avx512.S b/arch/x86/crypto/aes-gcm-vaes-avx512.S
index 81a8a027cff8e..3cf0945a25170 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx512.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx512.S
@@ -260,16 +260,12 @@
 	vpternlogd	$0x96, \t0, \mi, \hi
 .endm
 
 // void aes_gcm_precompute_vaes_avx512(struct aes_gcm_key_vaes_avx512 *key);
 //
-// Given the expanded AES key |key->aes_key|, this function derives the GHASH
-// subkey and initializes |key->ghash_key_powers| with powers of it.
-//
-// The number of key powers initialized is NUM_H_POWERS, and they are stored in
-// the order H^NUM_H_POWERS to H^1.  The zeroized padding blocks after the key
-// powers themselves are also initialized.
+// Given the expanded AES key |key->base.aes_key|, derive the GHASH subkey and
+// initialize |key->h_powers| and |key->padding|.
 SYM_FUNC_START(aes_gcm_precompute_vaes_avx512)
 
 	// Function arguments
 	.set	KEY,		%rdi
 
@@ -467,14 +463,13 @@ SYM_FUNC_END(aes_gcm_precompute_vaes_avx512)
 //				       u8 ghash_acc[16],
 //				       const u8 *aad, int aadlen);
 //
 // This function processes the AAD (Additional Authenticated Data) in GCM.
 // Using the key |key|, it updates the GHASH accumulator |ghash_acc| with the
-// data given by |aad| and |aadlen|.  |key->ghash_key_powers| must have been
-// initialized.  On the first call, |ghash_acc| must be all zeroes.  |aadlen|
-// must be a multiple of 16, except on the last call where it can be any length.
-// The caller must do any buffering needed to ensure this.
+// data given by |aad| and |aadlen|.  On the first call, |ghash_acc| must be all
+// zeroes.  |aadlen| must be a multiple of 16, except on the last call where it
+// can be any length.  The caller must do any buffering needed to ensure this.
 //
 // AES-GCM is almost always used with small amounts of AAD, less than 32 bytes.
 // Therefore, for AAD processing we currently only provide this implementation
 // which uses 256-bit vectors (ymm registers) and only has a 1x-wide loop.  This
 // keeps the code size down, and it enables some micro-optimizations, e.g. using
@@ -620,16 +615,16 @@ SYM_FUNC_END(aes_gcm_aad_update_vaes_avx512)
 //
 // |datalen| must be a multiple of 16, except on the last call where it can be
 // any length.  The caller must do any buffering needed to ensure this.  Both
 // in-place and out-of-place en/decryption are supported.
 //
-// |le_ctr| must give the current counter in little-endian format.  For a new
-// message, the low word of the counter must be 2.  This function loads the
-// counter from |le_ctr| and increments the loaded counter as needed, but it
-// does *not* store the updated counter back to |le_ctr|.  The caller must
-// update |le_ctr| if any more data segments follow.  Internally, only the low
-// 32-bit word of the counter is incremented, following the GCM standard.
+// |le_ctr| must give the current counter in little-endian format.  This
+// function loads the counter from |le_ctr| and increments the loaded counter as
+// needed, but it does *not* store the updated counter back to |le_ctr|.  The
+// caller must update |le_ctr| if any more data segments follow.  Internally,
+// only the low 32-bit word of the counter is incremented, following the GCM
+// standard.
 .macro	_aes_gcm_update	enc
 
 	// Function arguments
 	.set	KEY,		%rdi
 	.set	LE_CTR_PTR,	%rsi
-- 
2.51.0

