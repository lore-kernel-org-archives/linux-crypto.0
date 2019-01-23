Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B056DC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75F9F2184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284030;
	bh=OVMlggYjSpXNEz4yzYkF9qJ5ce0TSOvLRhIyZB71b+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2uwM+DSfdTxy5QsUOjJQkoYZZonCWMvrQxBPLd+L32GKftTV0nS5ucbZ/TyC08dZ7
	 Idzu/mK3lgmxAxlo9daLX1BKZCSS74JYx7r8as1pSgD4ZHpyKnw/vEEntuBfkKZUsi
	 Y4rj8oQq42TOWLHWT8i/dhTAAKW3bYgw/7gWeBEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfAWWxj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbfAWWwe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:34 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC43218AC;
        Wed, 23 Jan 2019 22:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283953;
        bh=OVMlggYjSpXNEz4yzYkF9qJ5ce0TSOvLRhIyZB71b+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhsCMB6Dkc4zzW2r6QukrB0GUHspjvLlrDuehElOdVlFbjUKf8CyHl3KfqvgaE+aa
         Ta6Z8LygmDcHgPT8sQxi2PjGbvNGxiwfjjlR9lbzR0I7xCuyyxltnjv/FAZYPAp1AB
         ktr6HWl3UT4meqegQMUli6aVxjCIZh9ygJ7yf3l0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH 07/15] crypto: arm64/aes-neonbs - fix returning final keystream block
Date:   Wed, 23 Jan 2019 14:49:18 -0800
Message-Id: <20190123224926.250525-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The arm64 NEON bit-sliced implementation of AES-CTR fails the improved
skcipher tests because it sometimes produces the wrong ciphertext.  The
bug is that the final keystream block isn't returned from the assembly
code when the number of non-final blocks is zero.  This can happen if
the input data ends a few bytes after a page boundary.  In this case the
last bytes get "encrypted" by XOR'ing them with uninitialized memory.

Fix the assembly code to return the final keystream block when needed.

Fixes: 88a3f582bea9 ("crypto: arm64/aes - don't use IV buffer to return final keystream block")
Cc: <stable@vger.kernel.org> # v4.11+
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-neonbs-core.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index e613a87f8b53..8432c8d0dea6 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -971,18 +971,22 @@ CPU_LE(	rev		x8, x8		)
 
 8:	next_ctr	v0
 	st1		{v0.16b}, [x24]
-	cbz		x23, 0f
+	cbz		x23, .Lctr_done
 
 	cond_yield_neon	98b
 	b		99b
 
-0:	frame_pop
+.Lctr_done:
+	frame_pop
 	ret
 
 	/*
 	 * If we are handling the tail of the input (x6 != NULL), return the
 	 * final keystream block back to the caller.
 	 */
+0:	cbz		x25, 8b
+	st1		{v0.16b}, [x25]
+	b		8b
 1:	cbz		x25, 8b
 	st1		{v1.16b}, [x25]
 	b		8b
-- 
2.20.1.321.g9e740568ce-goog

