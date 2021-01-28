Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8382DC433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412FC64DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhA1NII (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 08:08:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229885AbhA1NID (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 08:08:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D3864DE1;
        Thu, 28 Jan 2021 13:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611839216;
        bh=uJWDrD5rQzLnCd/a0JIrE53ldn+CZvw9kgi0laWoSpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSDvBBrE1+PT+/ZtXYAtSh7OnUNBKlDsC/n8xxjOBhCk6rA+4eiM6oSwMDAG5+9c4
         qwVLMwA5wxb2cjWFFDCTR6fuh1NJJl1nWMWpAX9R0gdF1F3jQ+XXBx7nRg6t4kA1rt
         dsLnoDg4XPrR7YQSs9rC47b43Wt62U1N9YbwyKNRvDnpqQK7v/adjENqQiD3uo/KWY
         bFARlTVtGMKF6EjnuVgCUSnEfd7Y300h08eocLewNmp+GQavlb/opiMElgbo9Dg6qi
         ok+GAdEn9o6mxLvvXTmUwOeMUFvH9dA6OHohzENGJY800Wgoaw8gs3DmQ6LoqNNHNA
         wWVjAKKC1w9Mg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6/9] crypto: arm64/aes-neonbs - remove NEON yield calls
Date:   Thu, 28 Jan 2021 14:06:22 +0100
Message-Id: <20210128130625.54076-7-ardb@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128130625.54076-1-ardb@kernel.org>
References: <20210128130625.54076-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no need for elaborate yield handling in the bit-sliced NEON
implementation of AES, given that skciphers are naturally bounded by the
size of the chunks returned by the skcipher_walk API. So remove the
yield calls from the asm code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-neonbs-core.S | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index 63a52ad9a75c..a3405b8c344b 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -613,7 +613,6 @@ SYM_FUNC_END(aesbs_decrypt8)
 	st1		{\o7\().16b}, [x19], #16
 
 	cbz		x23, 1f
-	cond_yield_neon
 	b		99b
 
 1:	frame_pop
@@ -715,7 +714,6 @@ SYM_FUNC_START(aesbs_cbc_decrypt)
 1:	st1		{v24.16b}, [x24]		// store IV
 
 	cbz		x23, 2f
-	cond_yield_neon
 	b		99b
 
 2:	frame_pop
@@ -801,7 +799,7 @@ SYM_FUNC_END(__xts_crypt8)
 	mov		x23, x4
 	mov		x24, x5
 
-0:	movi		v30.2s, #0x1
+	movi		v30.2s, #0x1
 	movi		v25.2s, #0x87
 	uzp1		v30.4s, v30.4s, v25.4s
 	ld1		{v25.16b}, [x24]
@@ -846,7 +844,6 @@ SYM_FUNC_END(__xts_crypt8)
 	cbz		x23, 1f
 	st1		{v25.16b}, [x24]
 
-	cond_yield_neon	0b
 	b		99b
 
 1:	st1		{v25.16b}, [x24]
@@ -889,7 +886,7 @@ SYM_FUNC_START(aesbs_ctr_encrypt)
 	cset		x26, ne
 	add		x23, x23, x26		// do one extra block if final
 
-98:	ldp		x7, x8, [x24]
+	ldp		x7, x8, [x24]
 	ld1		{v0.16b}, [x24]
 CPU_LE(	rev		x7, x7		)
 CPU_LE(	rev		x8, x8		)
@@ -967,7 +964,6 @@ CPU_LE(	rev		x8, x8		)
 	st1		{v0.16b}, [x24]
 	cbz		x23, .Lctr_done
 
-	cond_yield_neon	98b
 	b		99b
 
 .Lctr_done:
-- 
2.29.2

