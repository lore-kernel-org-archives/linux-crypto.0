Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731635AbfAKOTQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 09:19:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.4 70/88] crypto: x86/chacha20 - avoid sleeping with preemption disabled
Date: Fri, 11 Jan 2019 15:08:39 +0100
Message-Id: <20190111131057.758071155@linuxfoundation.org>
In-Reply-To: <20190111131045.137499039@linuxfoundation.org>
References: <20190111131045.137499039@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Biggers <ebiggers@google.com>

In chacha20-simd, clear the MAY_SLEEP flag in the blkcipher_desc to
prevent sleeping with preemption disabled, under kernel_fpu_begin().

This was fixed upstream incidentally by a large refactoring,
commit 9ae433bc79f9 ("crypto: chacha20 - convert generic and x86
versions to skcipher").  But syzkaller easily trips over this when
running on older kernels, as it's easily reachable via AF_ALG.
Therefore, this patch makes the minimal fix for older kernels.

Fixes: c9320b6dcb89 ("crypto: chacha20 - Add a SSSE3 SIMD variant for x86_64")
Cc: linux-crypto@vger.kernel.org
Cc: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/chacha20_glue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -77,6 +77,7 @@ static int chacha20_simd(struct blkciphe
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	crypto_chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
 
