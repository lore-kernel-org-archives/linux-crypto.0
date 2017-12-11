From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: gf128mul - remove incorrect comment
Date: Mon, 11 Dec 2017 13:58:26 -0800
Message-ID: <20171211215826.72183-1-ebiggers3@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>, Harsh Jain <harsh@chelsio.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:41907 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdLKV75 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 16:59:57 -0500
Received: by mail-it0-f65.google.com with SMTP id x28so19672026ita.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Dec 2017 13:59:56 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The comment in gf128mul_x8_ble() was copy-and-pasted from gf128mul.h and
makes no sense in the new context.  Remove it.

Cc: Harsh Jain <harsh@chelsio.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 24e601954c7a..a4b1c026aaee 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -160,8 +160,6 @@ void gf128mul_x8_ble(le128 *r, const le128 *x)
 {
 	u64 a = le64_to_cpu(x->a);
 	u64 b = le64_to_cpu(x->b);
-
-	/* equivalent to gf128mul_table_be[b >> 63] (see crypto/gf128mul.c): */
 	u64 _tt = gf128mul_table_be[a >> 56];
 
 	r->a = cpu_to_le64((a << 8) | (b >> 56));
-- 
2.15.1.424.g9478a66081-goog
