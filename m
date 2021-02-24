Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594FAC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0390064EF5
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhBXQfs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:35:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235268AbhBXQdk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:33:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AuvWSaJ9jqWTQR6peCcPaZV/0nyJwPI7/KUXsD2VZRA=;
        b=RuLvmd2bph2Xgh7JoGsT0u9mrTZ8LUaDRgL0EzJ4keDSPBIo9c7+gU5K0WikovJ/Wgc4ip
        VwvSIyVehWh/97HxnHhCx//G3bSsSLKhVHnK3JcIKVayEOa1UDEvwe7X1JlhaqlUMOvhH9
        gcJSs/1v01LiJyH7rMX07eFpiUwQiPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-qtnbYkXpOa2FDxm45LwWDA-1; Wed, 24 Feb 2021 11:29:46 -0500
X-MC-Unique: qtnbYkXpOa2FDxm45LwWDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798931005501;
        Wed, 24 Feb 2021 16:29:44 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40F5960862;
        Wed, 24 Feb 2021 16:29:43 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 08/13] x86/crypto/sha1_avx2: Standardize stack alignment prologue
Date:   Wed, 24 Feb 2021 10:29:21 -0600
Message-Id: <fdaaf8670ed1f52f55ba9a6bbac98c1afddc1af6.1614182415.git.jpoimboe@redhat.com>
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
 arch/x86/crypto/sha1_avx2_x86_64_asm.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index 1e594d60afa5..5eed620f4676 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -645,9 +645,9 @@ _loop3:
 	RESERVE_STACK  = (W_SIZE*4 + 8+24)
 
 	/* Align stack */
-	mov	%rsp, %rbx
+	push	%rbp
+	mov	%rsp, %rbp
 	and	$~(0x20-1), %rsp
-	push	%rbx
 	sub	$RESERVE_STACK, %rsp
 
 	avx2_zeroupper
@@ -665,8 +665,8 @@ _loop3:
 
 	avx2_zeroupper
 
-	add	$RESERVE_STACK, %rsp
-	pop	%rsp
+	mov	%rbp, %rsp
+	pop	%rbp
 
 	pop	%r15
 	pop	%r14
-- 
2.29.2

