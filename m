Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC58C4332E
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D212A64EF1
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhBXQdD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:33:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234881AbhBXQb3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a5xSosP/C+AktqnKcTC1zhdA3nQKp0XFHHslguVKp40=;
        b=geetHY4gZPx309/naBbC7EsfAQP1kq2hDd+CEjcCu8RzlqFrsF9g/3ZEfo73DKLN+1U17d
        Ayn2TYVA4Jgl8Ta34O5ouZjq+1vuzixMsQw+fMjjlwn0mh4OlGAKWvXw9r7Y8y8w6wYCPa
        9SRmB2LOxjhJJqHoLlT5JK5jngXFYkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-sHhUE2crP_ihPEziQ6xsKw-1; Wed, 24 Feb 2021 11:29:50 -0500
X-MC-Unique: sHhUE2crP_ihPEziQ6xsKw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00382107ACE4;
        Wed, 24 Feb 2021 16:29:49 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8A5260CE7;
        Wed, 24 Feb 2021 16:29:47 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 11/13] x86/crypto/sha512-avx2: Standardize stack alignment prologue
Date:   Wed, 24 Feb 2021 10:29:24 -0600
Message-Id: <b1a7b29fcfc65d60a3b6e77ef75f4762a5b8488d.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use a more standard prologue for saving the stack pointer before
realigning the stack.

This enables ORC unwinding by allowing objtool to understand the stack
realignment.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha512-avx2-asm.S | 42 +++++++++++++++----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 3a44bdcfd583..072cb0f0deae 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -102,17 +102,13 @@ SRND_SIZE = 1*8
 INP_SIZE = 1*8
 INPEND_SIZE = 1*8
 CTX_SIZE = 1*8
-RSPSAVE_SIZE = 1*8
-GPRSAVE_SIZE = 5*8
 
 frame_XFER = 0
 frame_SRND = frame_XFER + XFER_SIZE
 frame_INP = frame_SRND + SRND_SIZE
 frame_INPEND = frame_INP + INP_SIZE
 frame_CTX = frame_INPEND + INPEND_SIZE
-frame_RSPSAVE = frame_CTX + CTX_SIZE
-frame_GPRSAVE = frame_RSPSAVE + RSPSAVE_SIZE
-frame_size = frame_GPRSAVE + GPRSAVE_SIZE
+frame_size = frame_CTX + CTX_SIZE
 
 ## assume buffers not aligned
 #define	VMOVDQ vmovdqu
@@ -570,18 +566,18 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 # "blocks" is the message length in SHA512 blocks
 ########################################################################
 SYM_FUNC_START(sha512_transform_rorx)
+	# Save GPRs
+	push	%rbx
+	push	%r12
+	push	%r13
+	push	%r14
+	push	%r15
+
 	# Allocate Stack Space
-	mov	%rsp, %rax
+	push	%rbp
+	mov	%rsp, %rbp
 	sub	$frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
-	mov	%rax, frame_RSPSAVE(%rsp)
-
-	# Save GPRs
-	mov	%rbx, 8*0+frame_GPRSAVE(%rsp)
-	mov	%r12, 8*1+frame_GPRSAVE(%rsp)
-	mov	%r13, 8*2+frame_GPRSAVE(%rsp)
-	mov	%r14, 8*3+frame_GPRSAVE(%rsp)
-	mov	%r15, 8*4+frame_GPRSAVE(%rsp)
 
 	shl	$7, NUM_BLKS	# convert to bytes
 	jz	done_hash
@@ -672,15 +668,17 @@ loop2:
 
 done_hash:
 
-# Restore GPRs
-	mov	8*0+frame_GPRSAVE(%rsp), %rbx
-	mov	8*1+frame_GPRSAVE(%rsp), %r12
-	mov	8*2+frame_GPRSAVE(%rsp), %r13
-	mov	8*3+frame_GPRSAVE(%rsp), %r14
-	mov	8*4+frame_GPRSAVE(%rsp), %r15
-
 	# Restore Stack Pointer
-	mov	frame_RSPSAVE(%rsp), %rsp
+	mov	%rbp, %rsp
+	pop	%rbp
+
+	# Restore GPRs
+	pop	%r15
+	pop	%r14
+	pop	%r13
+	pop	%r12
+	pop	%rbx
+
 	ret
 SYM_FUNC_END(sha512_transform_rorx)
 
-- 
2.29.2

