Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D815EC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D0164F00
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhBXQcz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:32:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234717AbhBXQbU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eOHOjeFiMtzP9OGzSSHIXYUBmM19lsPz/JuM7QoJPBE=;
        b=TgLQCDy2bgsRVBHmbKeIYGLmStUd1Ogi9NQAC3rVtSH+4TgAP7LSwW4YytPKZu6lJd0yE5
        kp2dHgzV08+385U7V0axuoodY9T9HAPCgEr3WcYHVU6gJGmDajbVs5PQeU0+O6zpdNQYlK
        8Md705a3C2MuHgD5lU6ZycnO49JbqTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-1h4Bbw7aMJuFblwKAqeTwQ-1; Wed, 24 Feb 2021 11:29:45 -0500
X-MC-Unique: 1h4Bbw7aMJuFblwKAqeTwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F3FF79EC1;
        Wed, 24 Feb 2021 16:29:43 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA4DA60862;
        Wed, 24 Feb 2021 16:29:41 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 07/13] x86/crypto/sha_ni: Standardize stack alignment prologue
Date:   Wed, 24 Feb 2021 10:29:20 -0600
Message-Id: <5033e1a79867dff1b18e1b4d0783c38897d3f223.1614182415.git.jpoimboe@redhat.com>
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
 arch/x86/crypto/sha1_ni_asm.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/sha1_ni_asm.S b/arch/x86/crypto/sha1_ni_asm.S
index 11efe3a45a1f..5d8415f482bd 100644
--- a/arch/x86/crypto/sha1_ni_asm.S
+++ b/arch/x86/crypto/sha1_ni_asm.S
@@ -59,8 +59,6 @@
 #define DATA_PTR	%rsi	/* 2nd arg */
 #define NUM_BLKS	%rdx	/* 3rd arg */
 
-#define RSPSAVE		%rax
-
 /* gcc conversion */
 #define FRAME_SIZE	32	/* space for 2x16 bytes */
 
@@ -96,7 +94,8 @@
 .text
 .align 32
 SYM_FUNC_START(sha1_ni_transform)
-	mov		%rsp, RSPSAVE
+	push		%rbp
+	mov		%rsp, %rbp
 	sub		$FRAME_SIZE, %rsp
 	and		$~0xF, %rsp
 
@@ -288,7 +287,8 @@ SYM_FUNC_START(sha1_ni_transform)
 	pextrd		$3, E0, 1*16(DIGEST_PTR)
 
 .Ldone_hash:
-	mov		RSPSAVE, %rsp
+	mov		%rbp, %rsp
+	pop		%rbp
 
 	ret
 SYM_FUNC_END(sha1_ni_transform)
-- 
2.29.2

