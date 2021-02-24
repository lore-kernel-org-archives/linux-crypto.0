Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BCAC43333
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321A764F00
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhBXQdX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:33:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234915AbhBXQb3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QHAXN62NKSYCiC1JTav+S2nx7912U3/cEpM7FBeWNPo=;
        b=AMIzG+hY/Lz6hpjfnJdpXeCE8Oznsq1t0wOEZdDjJaEFi+ea6vUzmJIdBL5BSWxfUL8Vok
        KqkLseqxZrt4TnCk7m8Fcb5Bd+9IOKkOJ5gc5N+AVypCBxGSkKjLzp8gfVZYRU5qY8v5gJ
        OCpxoNLIaAeOjMe2QljG24YE4eQxjp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-W4AgpMZVPHycxmJilMLD3g-1; Wed, 24 Feb 2021 11:29:52 -0500
X-MC-Unique: W4AgpMZVPHycxmJilMLD3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D1541936B60;
        Wed, 24 Feb 2021 16:29:50 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E65260862;
        Wed, 24 Feb 2021 16:29:49 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 12/13] x86/crypto/sha512-ssse3: Standardize stack alignment prologue
Date:   Wed, 24 Feb 2021 10:29:25 -0600
Message-Id: <6ecaaac9f3828fbb903513bf90c34a08380a8e35.1614182415.git.jpoimboe@redhat.com>
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
 arch/x86/crypto/sha512-ssse3-asm.S | 41 ++++++++++++++----------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index 50812af0b083..bd51c9070bed 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -74,14 +74,10 @@ tmp0 =		%rax
 
 W_SIZE = 80*8
 WK_SIZE = 2*8
-RSPSAVE_SIZE = 1*8
-GPRSAVE_SIZE = 5*8
 
 frame_W = 0
 frame_WK = frame_W + W_SIZE
-frame_RSPSAVE = frame_WK + WK_SIZE
-frame_GPRSAVE = frame_RSPSAVE + RSPSAVE_SIZE
-frame_size = frame_GPRSAVE + GPRSAVE_SIZE
+frame_size = frame_WK + WK_SIZE
 
 # Useful QWORD "arrays" for simpler memory references
 # MSG, DIGEST, K_t, W_t are arrays
@@ -283,18 +279,18 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	test msglen, msglen
 	je nowork
 
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
-	mov	%rbx, frame_GPRSAVE(%rsp)
-	mov	%r12, frame_GPRSAVE +8*1(%rsp)
-	mov	%r13, frame_GPRSAVE +8*2(%rsp)
-	mov	%r14, frame_GPRSAVE +8*3(%rsp)
-	mov	%r15, frame_GPRSAVE +8*4(%rsp)
 
 updateblock:
 
@@ -355,15 +351,16 @@ updateblock:
 	dec	msglen
 	jnz	updateblock
 
-	# Restore GPRs
-	mov	frame_GPRSAVE(%rsp),      %rbx
-	mov	frame_GPRSAVE +8*1(%rsp), %r12
-	mov	frame_GPRSAVE +8*2(%rsp), %r13
-	mov	frame_GPRSAVE +8*3(%rsp), %r14
-	mov	frame_GPRSAVE +8*4(%rsp), %r15
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
 
 nowork:
 	ret
-- 
2.29.2

