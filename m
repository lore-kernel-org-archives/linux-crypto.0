Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B70C433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84518224B8
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgLWIOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgLWIOP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:14:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21E37224DF;
        Wed, 23 Dec 2020 08:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711177;
        bh=hdS/nZMIHIRlLDU4jx0otHFHReXXhN43ibKqK9h7cxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgkNBHtTnftbt2Yj+NrWKD07vzQfqRiCOm5RYBPIAWygx4wk49tKLg9uxWVW8BapX
         QShd3x1h26NWOwlSVXGibc8YCZ0VlCSh/ACErt1bh3qJE2TM9Rzj0GDkTT2iPKPC92
         vV4ecO7uvjODQkAhWBRUsdx5JyDOgWOocYmeUd6sIjDo85udnTQ5ZTge6Tpv04BA8K
         RoSanYrtI6Wecg48nt84HBLC+VFo6foFGLpq2geneq80fRwN7zzzsxDo6K/kr6MqCz
         AJO/xTaRkwxSrNmZOindPqu18cqbH4w2kq1Nzke6SNKv5ak9h19bupG+w+7w7hgGYx
         HQpo2hXw7N95w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 09/14] crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>
Date:   Wed, 23 Dec 2020 00:09:58 -0800
Message-Id: <20201223081003.373663-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Address the following checkpatch warning:

	WARNING: Use #include <linux/bug.h> instead of <asm/bug.h>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/blake2s.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
index 3f06183c2d804..bc3fb59442ce5 100644
--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -6,12 +6,11 @@
 #ifndef _CRYPTO_BLAKE2S_H
 #define _CRYPTO_BLAKE2S_H
 
+#include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 
-#include <asm/bug.h>
-
 enum blake2s_lengths {
 	BLAKE2S_BLOCK_SIZE = 64,
 	BLAKE2S_HASH_SIZE = 32,
-- 
2.29.2

