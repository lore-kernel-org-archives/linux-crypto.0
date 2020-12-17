Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB0CC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8525233FE
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgLQW0V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 17:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732081AbgLQW0V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 17:26:21 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v2 08/11] crypto: blake2s - remove unneeded includes
Date:   Thu, 17 Dec 2020 14:21:35 -0800
Message-Id: <20201217222138.170526-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217222138.170526-1-ebiggers@kernel.org>
References: <20201217222138.170526-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

It doesn't make sense for the generic implementation of BLAKE2s to
include <crypto/internal/simd.h> and <linux/jump_label.h>, as these are
things that would only be useful in an architecture-specific
implementation.  Remove these unnecessary includes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2s_generic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
index e3aa6e7ff3d83..b89536c3671cf 100644
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -4,11 +4,9 @@
  */
 
 #include <crypto/internal/blake2s.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/hash.h>
 
 #include <linux/types.h>
-#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-- 
2.29.2

