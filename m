Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558DBC43332
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6D164EFC
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhBXQdJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:33:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234934AbhBXQb3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/DLjCfyPdWpsrA8C7WRrfmxuAmIfnze3qgJu059srp4=;
        b=E64oJ7T8mwld4VY1r4y45ENIU7KjE1caB11DXZ3x3+0pLU0qz5Tk0t1WLmxl6kVngTUx6Z
        8zEfD6t0TRzu/7frMwg4sEXQJS3eRNFtyMoS1tes+5miJHR/xhURTe3mg60xML9XoCaJh3
        fw9PXYQTmAL+bgC+2xPDHHnk0DUpXnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-EE2OuDdWNTW4amn49x2nhw-1; Wed, 24 Feb 2021 11:29:54 -0500
X-MC-Unique: EE2OuDdWNTW4amn49x2nhw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29115107ACE4;
        Wed, 24 Feb 2021 16:29:52 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9F8A60862;
        Wed, 24 Feb 2021 16:29:50 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 13/13] x86/crypto: Enable objtool in crypto code
Date:   Wed, 24 Feb 2021 10:29:26 -0600
Message-Id: <fc2a1918c50e33e46ef0e9a5de02743f2f6e3639.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that all the stack alignment prologues have been cleaned up in the
crypto code, enable objtool.  Among other benefits, this will allow ORC
unwinding to work.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index b28e36b7c96b..d0959e7b809f 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,8 +2,6 @@
 #
 # x86 crypto algorithms
 
-OBJECT_FILES_NON_STANDARD := y
-
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
-- 
2.29.2

