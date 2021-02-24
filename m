Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FDCC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41AAF64EBA
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBXQcu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:32:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234689AbhBXQbT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGOdN7tSFAaU3AO1CqR7TyZfZzGj2VWJcbMfTD3exzQ=;
        b=IjYu2dXzv3kXsgoEt+zZ2pO1ecg7E9N7X/2Q6tlnRi8cjXgmjO5a00qzRhsZbNzf7EkJ8T
        /lcO63sLOqNgge3nPzaOJbaM3o1KKrOOCxvJ/DLGQnCQpO+V9/G8P5oU2D6bqnt6LVLD/a
        WTCniB0VuDsSv8sVqDsDrxrrvoiRB+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-cRY8inFFN_OWfJ0gTvgbRw-1; Wed, 24 Feb 2021 11:29:40 -0500
X-MC-Unique: cRY8inFFN_OWfJ0gTvgbRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C42E1936B66;
        Wed, 24 Feb 2021 16:29:38 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FCF360C5B;
        Wed, 24 Feb 2021 16:29:36 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 04/13] x86/crypto/aesni-intel_avx: Standardize stack alignment prologue
Date:   Wed, 24 Feb 2021 10:29:17 -0600
Message-Id: <02d00a0903a0959f4787e186e2a07d271e1f63d4.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use RBP instead of R14 for saving the old stack pointer before
realignment.  This resembles what compilers normally do.

This enables ORC unwinding by allowing objtool to understand the stack
realignment.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 188f1848a730..98e3552b6e03 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -251,22 +251,20 @@ VARIABLE_OFFSET = 16*8
 .macro FUNC_SAVE
         push    %r12
         push    %r13
-        push    %r14
         push    %r15
 
-        mov     %rsp, %r14
-
-
+	push	%rbp
+	mov	%rsp, %rbp
 
         sub     $VARIABLE_OFFSET, %rsp
         and     $~63, %rsp                    # align rsp to 64 bytes
 .endm
 
 .macro FUNC_RESTORE
-        mov     %r14, %rsp
+        mov     %rbp, %rsp
+	pop	%rbp
 
         pop     %r15
-        pop     %r14
         pop     %r13
         pop     %r12
 .endm
-- 
2.29.2

