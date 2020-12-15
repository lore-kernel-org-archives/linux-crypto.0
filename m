Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3041BC3526A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DC8E22D07
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgLPABg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgLOXzY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 18:55:24 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH 4/5] crypto: blake2b - update file comment
Date:   Tue, 15 Dec 2020 15:47:07 -0800
Message-Id: <20201215234708.105527-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201215234708.105527-1-ebiggers@kernel.org>
References: <20201215234708.105527-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The file comment for blake2b_generic.c makes it sound like it's the
reference implementation of BLAKE2b with only minor changes.  But it's
actually been changed a lot.  Update the comment to make this clearer.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2b_generic.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index fd5159b7aa9f2..c82a12dd47f17 100644
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

