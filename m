Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BBEC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 05:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF2B61131
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 05:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhIVFmn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232258AbhIVFmm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 01:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632289273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bJXkEkfWdDJCAURztjziNenOw4qGpHyUiriN1i4JZCM=;
        b=VXAb6V4/M7LhCnZaCKiWdAdWMKvP/nEx+aeXglE6WiQypc/Vmgefsl4wm4h86zKSjydE+z
        K9SS9ibewkbg6kAjRa6ChkqtTaZx0ZOy3YP1nDCH7CX94ERIUNLljJX2WMv9yvzCZWrHfW
        QAAYq4+KKQdplqwHBj2JlXMyoCD41Js=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-c52lzspQNBKNg9iKaAsteQ-1; Wed, 22 Sep 2021 01:41:08 -0400
X-MC-Unique: c52lzspQNBKNg9iKaAsteQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76646BBEE0;
        Wed, 22 Sep 2021 05:41:07 +0000 (UTC)
Received: from treble.redhat.com (unknown [10.22.33.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F9E56B544;
        Wed, 22 Sep 2021 05:41:05 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] x86/crypto/sm4: Fix frame pointer stack corruption
Date:   Tue, 21 Sep 2021 22:40:26 -0700
Message-Id: <2010f60571abe6fe53d89189ab6da7e641cb027b.1632289099.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sm4_aesni_avx_crypt8() sets up the frame pointer (which includes pushing
RBP) before doing a conditional sibling call to sm4_aesni_avx_crypt4(),
which sets up an additional frame pointer.  Things will not go well when
sm4_aesni_avx_crypt4() pops only the innermost single frame pointer and
then tries to return to the outermost frame pointer.

Sibling calls need to occur with an empty stack frame.  Do the
conditional sibling call *before* setting up the stack pointer.

This fixes the following warning:

  arch/x86/crypto/sm4-aesni-avx-asm_64.o: warning: objtool: sm4_aesni_avx_crypt8()+0x8: sibling call from callable instruction with modified stack frame

Fixes: a7ee22ee1445 ("crypto: x86/sm4 - add AES-NI/AVX/x86_64 implementation")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Arnd Bergmann <arnd@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sm4-aesni-avx-asm_64.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sm4-aesni-avx-asm_64.S b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
index fa2c3f50aecb..18d2f5199194 100644
--- a/arch/x86/crypto/sm4-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
@@ -367,10 +367,11 @@ SYM_FUNC_START(sm4_aesni_avx_crypt8)
 	 *	%rdx: src (1..8 blocks)
 	 *	%rcx: num blocks (1..8)
 	 */
-	FRAME_BEGIN
-
 	cmpq $5, %rcx;
 	jb sm4_aesni_avx_crypt4;
+
+	FRAME_BEGIN
+
 	vmovdqu (0 * 16)(%rdx), RA0;
 	vmovdqu (1 * 16)(%rdx), RA1;
 	vmovdqu (2 * 16)(%rdx), RA2;
-- 
2.31.1

