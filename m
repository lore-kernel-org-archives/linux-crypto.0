Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B968CC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 696F364EF1
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhBXQcw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:32:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234708AbhBXQbT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BGP1D+fN8RYYb6r5ixsRX3SnpxjoEGyiGCXv8vP6/MA=;
        b=AczzPNyftfCwbLDC90SetT5H8nj4WjjNqt/A9Hb7otKshDaBUJp1agLN5P2Pn3oEIL6alz
        1RNInWk+MVSEkhbL9Mb2xsfwn2lMCV9zIAJ+/Urah0olJ3MRWPGyWl4K74NtuKSRMOpBME
        eZJuTQC7hWqtqMK5ITyWXZIZs8tbFZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-EpMdybTKMISHxWLyChJ06A-1; Wed, 24 Feb 2021 11:29:43 -0500
X-MC-Unique: EpMdybTKMISHxWLyChJ06A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67D3179EC3;
        Wed, 24 Feb 2021 16:29:41 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13EF960CE7;
        Wed, 24 Feb 2021 16:29:39 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 06/13] x86/crypto/crc32c-pcl-intel: Standardize jump table
Date:   Wed, 24 Feb 2021 10:29:19 -0600
Message-Id: <5357a039def90b8ef6b5874ef12cda008ecf18ba.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Simplify the jump table code so that it resembles a compiler-generated
table.

This enables ORC unwinding by allowing objtool to follow all the
potential code paths.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 884dc767b051..ac1f303eed0f 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -53,7 +53,7 @@
 .endm
 
 .macro JMPTBL_ENTRY i
-.word crc_\i - crc_array
+.quad crc_\i
 .endm
 
 .macro JNC_LESS_THAN j
@@ -168,10 +168,7 @@ continue_block:
 	xor     crc2, crc2
 
 	## branch into array
-	lea	jump_table(%rip), %bufp
-	movzwq  (%bufp, %rax, 2), len
-	lea	crc_array(%rip), %bufp
-	lea     (%bufp, len, 1), %bufp
+	mov	jump_table(,%rax,8), %bufp
 	JMP_NOSPEC bufp
 
 	################################################################
-- 
2.29.2

