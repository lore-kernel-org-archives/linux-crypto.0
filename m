Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D522BE02E;
	Sun,  6 Jul 2025 23:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751843507; cv=none; b=mcI+/udLC0Pe9e38xet3HJnLX9oX5du2mNHDgJTe8oEx0P0YhoFIUXErqxAnaFNyInE84rCvH5k2M3AbEuQcp5lNjLHepLQbM8ydHsmnxtbngTJyBhV+lQivAdiLe9V3obBbbsFdPCg4UV7hjMU4oyZKcJRnbo0oaDySIp81AmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751843507; c=relaxed/simple;
	bh=Szsb85EsQ+Zh1w4jNZz/88qNbUj4Tj26HrAtW7FyjqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMqU+gKKT26W0QvwEQa0BbC8EcN3k7ZfZF5vw7x/8Ww3Buy5C8NQd5W1wX9luwO3eypTcgyZwpeybapLF0Fpc4QXgfRlcO9iN90R+rjd4edaun2i3uiS2rZy54XnMBgv7Xr87IRbjMHxDrrLFnPSRawQhdpotm70ahYDK0DsaGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLw6kDkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLw6kDkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489D6C4CEED;
	Sun,  6 Jul 2025 23:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751843506;
	bh=Szsb85EsQ+Zh1w4jNZz/88qNbUj4Tj26HrAtW7FyjqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLw6kDkrizdxub9fjMWAZyiLgAQCIRS02Qtjf8aBUsmv08tcyRIpytwlj6zVajjSx
	 A7gFOuwgrjL+9yKxrWrIi3ND3tl0UGiRNQPz5q2gRrfFMHt1YvASf4ssJfSo4nXqKc
	 /33jxZCkDvHL93ZJGVywgCZdV7QkLSBkjZvmXZvdv/KuDakTidmefdfshG55iLCOZ1
	 9gDLNdYzbhTlCxHYF0+CyeHRoGGkaLBeTqQ6p/0CJ839Vrva+HomoBhwSGAC60vnb7
	 oAIEx4RUFtj1kMA0eLGt5ERxEXxrxjKQv0uci+8sRz4TeJL1SG7XG9IRfuS//mkmpX
	 Ux/qgcMUvcIEw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 5/5] lib/crypto: x86/poly1305: Fix performance regression on short messages
Date: Sun,  6 Jul 2025 16:11:00 -0700
Message-ID: <20250706231100.176113-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250706231100.176113-1-ebiggers@kernel.org>
References: <20250706231100.176113-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore the len >= 288 condition on using the AVX implementation, which
was incidentally removed by commit 318c53ae02f2 ("crypto: x86/poly1305 -
Add block-only interface").  This check took into account the overhead
in key power computation, kernel-mode "FPU", and tail handling
associated with the AVX code.  Indeed, restoring this check slightly
improves performance for len < 256 as measured using poly1305_kunit on
an "AMD Ryzen AI 9 365" (Zen 5) CPU:

    Length      Before       After
    ======  ==========  ==========
         1     30 MB/s     36 MB/s
        16    516 MB/s    598 MB/s
        64   1700 MB/s   1882 MB/s
       127   2265 MB/s   2651 MB/s
       128   2457 MB/s   2827 MB/s
       200   2702 MB/s   3238 MB/s
       256   3841 MB/s   3768 MB/s
       511   4580 MB/s   4585 MB/s
       512   5430 MB/s   5398 MB/s
      1024   7268 MB/s   7305 MB/s
      3173   8999 MB/s   8948 MB/s
      4096   9942 MB/s   9921 MB/s
     16384  10557 MB/s  10545 MB/s

While the optimal threshold for this CPU might be slightly lower than
288 (see the len == 256 case), other CPUs would need to be tested too,
and these sorts of benchmarks can underestimate the true cost of
kernel-mode "FPU".  Therefore, for now just restore the 288 threshold.

Fixes: 318c53ae02f2 ("crypto: x86/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/poly1305_glue.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/crypto/x86/poly1305_glue.c b/lib/crypto/x86/poly1305_glue.c
index 968d84677631..856d48fd422b 100644
--- a/lib/crypto/x86/poly1305_glue.c
+++ b/lib/crypto/x86/poly1305_glue.c
@@ -96,11 +96,19 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *inp,
 
 	/* SIMD disables preemption, so relax after processing each page. */
 	BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
 		     SZ_4K % POLY1305_BLOCK_SIZE);
 
+	/*
+	 * The AVX implementations have significant setup overhead (e.g. key
+	 * power computation, kernel FPU enabling) which makes them slower for
+	 * short messages.  Fall back to the scalar implementation for messages
+	 * shorter than 288 bytes, unless the AVX-specific key setup has already
+	 * been performed (indicated by ctx->is_base2_26).
+	 */
 	if (!static_branch_likely(&poly1305_use_avx) ||
+	    (len < POLY1305_BLOCK_SIZE * 18 && !ctx->is_base2_26) ||
 	    unlikely(!irq_fpu_usable())) {
 		convert_to_base2_64(ctx);
 		poly1305_blocks_x86_64(ctx, inp, len, padbit);
 		return;
 	}
-- 
2.50.0

