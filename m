Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1382FC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87BB64EBA
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhBXQc5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:32:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234658AbhBXQbU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wjYqxo2PcGDIUf3rOxDJ05fdBFc1pa3drtiPmkHIL9g=;
        b=SoCg0Yozd/7wfiNOtqRmh6nTQxpB/C60p/Z/cuyUKZonAGbEgAy9ZC5QoP1MJ9xCDli9Zf
        v6s+8DaKQtaILQR70E6ooM/i+MajTSVVy9RSF6SLq7y6X0NapGWWJfOi7HEffMxVSgJCUO
        dVWuAtY3k62HcUMnmq8mk9DIIO8GnhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-wspEER2kNEKvO8bC-tS1ew-1; Wed, 24 Feb 2021 11:29:37 -0500
X-MC-Unique: wspEER2kNEKvO8bC-tS1ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEBFE79EC7;
        Wed, 24 Feb 2021 16:29:34 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0F7D60862;
        Wed, 24 Feb 2021 16:29:33 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 02/13] x86/crypto/aesni-intel_avx: Remove unused macros
Date:   Wed, 24 Feb 2021 10:29:15 -0600
Message-Id: <53f7136ea93ebdbca399959e6d2991ecb46e733e.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These macros are no longer used; remove them.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 2cf8e94d986a..4fdf38e92d51 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -212,10 +212,6 @@ HashKey_8_k    = 16*21   # store XOR of HashKey^8 <<1 mod poly here (for Karatsu
 #define arg4 %rcx
 #define arg5 %r8
 #define arg6 %r9
-#define arg7 STACK_OFFSET+8*1(%r14)
-#define arg8 STACK_OFFSET+8*2(%r14)
-#define arg9 STACK_OFFSET+8*3(%r14)
-#define arg10 STACK_OFFSET+8*4(%r14)
 #define keysize 2*15*16(arg1)
 
 i = 0
@@ -237,9 +233,6 @@ define_reg j %j
 .noaltmacro
 .endm
 
-# need to push 4 registers into stack to maintain
-STACK_OFFSET = 8*4
-
 TMP1 =   16*0    # Temporary storage for AAD
 TMP2 =   16*1    # Temporary storage for AES State 2 (State 1 is stored in an XMM register)
 TMP3 =   16*2    # Temporary storage for AES State 3
@@ -256,7 +249,6 @@ VARIABLE_OFFSET = 16*8
 ################################
 
 .macro FUNC_SAVE
-        #the number of pushes must equal STACK_OFFSET
         push    %r12
         push    %r13
         push    %r14
-- 
2.29.2

