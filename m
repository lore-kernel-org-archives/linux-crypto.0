Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E25DC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA4E64F02
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhBXQeg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:34:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234450AbhBXQcf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bBgJZbU8XJohBWogHzPnPQnzXHFLyp1Xf0dJOi3AIyQ=;
        b=Ug+m+ZEheT/Kg5bsr1sgdiwRRaUNkGA53w773Ml5BzYa7vw3JgEG9EdtHmfDxKGZqoyGUU
        eqPBZqlTkbH/0lP1GTTlSJGaanfy+FL9atH3WWHGAAT/EZZAQcU/M5+fFuJyZXOlORv2TL
        st81Uh12MiWgLwfj/pFkFQCggVJb6YM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-Xj6PoKWAOfu6p6elvNLZnA-1; Wed, 24 Feb 2021 11:29:42 -0500
X-MC-Unique: Xj6PoKWAOfu6p6elvNLZnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D97DB107ACE6;
        Wed, 24 Feb 2021 16:29:39 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A9B960862;
        Wed, 24 Feb 2021 16:29:38 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 05/13] x86/crypto/camellia-aesni-avx2: Unconditionally allocate stack buffer
Date:   Wed, 24 Feb 2021 10:29:18 -0600
Message-Id: <85ac96613ee5784b6239c18d3f68b1f3c509caa3.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A conditional stack allocation violates traditional unwinding
requirements when a single instruction can have differing stack layouts.

There's no benefit in allocating the stack buffer conditionally.  Just
do it unconditionally.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index 782e9712a1ec..706f70829a07 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -990,6 +990,7 @@ SYM_FUNC_START(camellia_cbc_dec_32way)
 	 *	%rdx: src (32 blocks)
 	 */
 	FRAME_BEGIN
+	subq $(16 * 32), %rsp;
 
 	vzeroupper;
 
@@ -1002,7 +1003,6 @@ SYM_FUNC_START(camellia_cbc_dec_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rdx, (key_table)(CTX, %r8, 8));
 
-	movq %rsp, %r10;
 	cmpq %rsi, %rdx;
 	je .Lcbc_dec_use_stack;
 
@@ -1015,7 +1015,6 @@ SYM_FUNC_START(camellia_cbc_dec_32way)
 	 * dst still in-use (because dst == src), so use stack for temporary
 	 * storage.
 	 */
-	subq $(16 * 32), %rsp;
 	movq %rsp, %rax;
 
 .Lcbc_dec_continue:
@@ -1025,7 +1024,6 @@ SYM_FUNC_START(camellia_cbc_dec_32way)
 	vpxor %ymm7, %ymm7, %ymm7;
 	vinserti128 $1, (%rdx), %ymm7, %ymm7;
 	vpxor (%rax), %ymm7, %ymm7;
-	movq %r10, %rsp;
 	vpxor (0 * 32 + 16)(%rdx), %ymm6, %ymm6;
 	vpxor (1 * 32 + 16)(%rdx), %ymm5, %ymm5;
 	vpxor (2 * 32 + 16)(%rdx), %ymm4, %ymm4;
@@ -1047,6 +1045,7 @@ SYM_FUNC_START(camellia_cbc_dec_32way)
 
 	vzeroupper;
 
+	addq $(16 * 32), %rsp;
 	FRAME_END
 	ret;
 SYM_FUNC_END(camellia_cbc_dec_32way)
-- 
2.29.2

