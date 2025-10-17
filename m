Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D772FC030;
	Fri, 17 Oct 2025 17:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720932; cv=none; b=T2DdEDjHB19WvVMBLB/u3ZdlQfCtgw7BVzNgWgEa9IKVXV0GUZaDQuR5V285idyIHiFk1Kbnh7tlvoW+h6GdTJQYimoaY9AMBSdpZL8s9jt+FFUXxVkV1QjAzfYxKeRakuogqTU42lvRk+iPEIuTtK3BxUkdEfD1xi/mIdffYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720932; c=relaxed/simple;
	bh=XkqrYshy9f5RBQoj9MIloVV01+5FrU30jnX6f2x2zlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRg7Du1i99iH/wyOTnvnaVng9NfX7UHEg2txzYnurmphAAjh+iQPWSgk23dFTgmNEPsJTt4niVyJfIxez6w9F6auekUJdET2Ukd0hCYoEW5IgflQI0D2XmoggfvrPW35WDkFgzBGDmDC46peSa+7UZODp81svQg2o7/QiGCSIFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RU+rwgSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RU+rwgSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C1FC4CEE7;
	Fri, 17 Oct 2025 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760720931;
	bh=XkqrYshy9f5RBQoj9MIloVV01+5FrU30jnX6f2x2zlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RU+rwgSv4iuKjVg3qskz2Da8IIqfWRx2nH5XNKYx3rABA8SniF8XOSZtxn54ONnh3
	 h3gSp1//4s+avGx+IBevbXWDoA+iH2hZUb7O/etF2nLNGAXWu8HA8HvKvFUnUC6hHl
	 1zWbj1oDGDmj9QFl27wRriu40MrUTWn31CogT/HIoUaBiVQvU0kDf/6SgtI0jbV3l0
	 yvfaIFUYDl1r8Dhmpk462kfowLQGSErbVtwGHFxTwGHCC/QmBQwGaEsFegBmya+P1A
	 OoKJw+odc+Ie2VdNaYIg52Fw1xuOV2qS3D1LYUgKMrpbsoYvuwfbxW35B+3vAVocko
	 U8o8j4vsRcCXA==
Date: Fri, 17 Oct 2025 10:07:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 00/21] arm64: Move kernel mode FPSIMD buffer to the
 stack
Message-ID: <20251017170718.GE1566@sol>
References: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>

On Wed, Oct 08, 2025 at 05:45:34PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
> context switch out of struct thread_struct, and onto the stack, so that
> the memory cost is not imposed needlessly on all tasks in the system.

This patchset needs the following fixup to build:

diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
index 7f02a767f675e..aaeeab0defb5d 100644
--- a/lib/crc/arm/crc-t10dif.h
+++ b/lib/crc/arm/crc-t10dif.h
@@ -17,11 +17,11 @@ asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
 				  u8 out[16]);
 
 static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 {
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
-		if (static_branch_likely(&have_pmull) && likely(may_use_simd()) {
+		if (static_branch_likely(&have_pmull) && likely(may_use_simd())) {
 			scoped_ksimd()
 				return crc_t10dif_pmull64(crc, data, length);
 		} else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
 			   static_branch_likely(&have_neon) &&
 			   likely(may_use_simd())) {
diff --git a/lib/crypto/arm/sha512.h b/lib/crypto/arm/sha512.h
index 8d3af965d2b34..ed9bd81d6d78d 100644
--- a/lib/crypto/arm/sha512.h
+++ b/lib/crypto/arm/sha512.h
@@ -16,10 +16,11 @@ asmlinkage void sha512_block_data_order_neon(struct sha512_block_state *state,
 
 static void sha512_blocks(struct sha512_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
+	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		scoped_ksimd()
 			sha512_block_data_order_neon(state, data, nblocks);
 	} else {
 		sha512_block_data_order(state, data, nblocks);
 	}
