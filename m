Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E368C4332B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E421E224B0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgLWIOQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgLWIOQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:14:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3B122510;
        Wed, 23 Dec 2020 08:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711179;
        bh=qS5odlNvKzcQ1NLPrL+sF+R4JtS6E6dFmblxMXhMlEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkQPMYnRUb4z6xQnbpCKDKenc6E58KB7clteA90Q9gUGF2XAZWw1e17yNcZEio9Oy
         khoIW0jbfw+D84scqPCSzdlBZYShgWWoWBrs8rYtF6BVE1qXlHWlRZk9w9q3xIwkqQ
         D0wUj8Sq9xkyoJfts6qR4ExNDBrKDQAVQQRKtOJy4CzWj2Y0vnugoZKQaBFBpNlRRh
         q7hIitMn8yMM3kTcQB+3ggVnXPkYD+91ZSQF//wpWXFOIufcEQLqycJIzNiLnIvtTy
         pkGjyUxdDrkYHQzbSVr9jRK1L1pAm6VPd3V63bPewbpemh+KlY8QW2qEz8I0fMf9P2
         mqsBm/b4t5P9Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 13/14] crypto: blake2b - update file comment
Date:   Wed, 23 Dec 2020 00:10:02 -0800
Message-Id: <20201223081003.373663-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The file comment for blake2b_generic.c makes it sound like it's the
reference implementation of BLAKE2b with only minor changes.  But it's
actually been changed a lot.  Update the comment to make this clearer.

Reviewed-by: David Sterba <dsterba@suse.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2b_generic.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 963f7fe0e4ea8..6704c03558896 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -1,21 +1,18 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0)
 /*
- * BLAKE2b reference source code package - reference C implementations
+ * Generic implementation of the BLAKE2b digest algorithm.  Based on the BLAKE2b
+ * reference implementation, but it has been heavily modified for use in the
+ * kernel.  The reference implementation was:
  *
- * Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under the
- * terms of the CC0, the OpenSSL Licence, or the Apache Public License 2.0, at
- * your option.  The terms of these licenses can be found at:
+ *	Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under
+ *	the terms of the CC0, the OpenSSL Licence, or the Apache Public License
+ *	2.0, at your option.  The terms of these licenses can be found at:
  *
- * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
- * - OpenSSL license   : https://www.openssl.org/source/license.html
- * - Apache 2.0        : https://www.apache.org/licenses/LICENSE-2.0
+ *	- CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
+ *	- OpenSSL license   : https://www.openssl.org/source/license.html
+ *	- Apache 2.0        : https://www.apache.org/licenses/LICENSE-2.0
  *
- * More information about the BLAKE2 hash function can be found at
- * https://blake2.net.
- *
- * Note: the original sources have been modified for inclusion in linux kernel
- * in terms of coding style, using generic helpers and simplifications of error
- * handling.
+ * More information about BLAKE2 can be found at https://blake2.net.
  */
 
 #include <asm/unaligned.h>
-- 
2.29.2

