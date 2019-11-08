Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188E1C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E332021848
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215867;
	bh=2JrP8gPhfgYcRdWTz9spSaAHplwvwGOJpDI7tez+vlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WVfFTpU/nPQSsGqt9h9zcP9TKEOfPK9LNPhpofqbSWw2xy4N+YaskPymphKVb0flz
	 B3mg5PrILmBiSf6pRgqBOOu0vcQw7TjWsFLITQ6To0zQQccjmSJj31FSKkJClK0M3h
	 C1WFHQ2QNI0Fvvs3Da+ATtlJV5+wMmmTs4nWlnOY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbfKHMY0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732457AbfKHMY0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:24:26 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98B9721924;
        Fri,  8 Nov 2019 12:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215865;
        bh=2JrP8gPhfgYcRdWTz9spSaAHplwvwGOJpDI7tez+vlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/oYi8qF3W9MaTRgQsCcfx/MwJOiYmBwHNtD4KYSDq6v6eEkRUGsXf4gjoKErJKLP
         HR2OPSBgaUelCViE+eCEJZmxmdAKmeAQvigrJ8sXzU4rsIH8yxpAQwByqrCgz9bjgv
         2YIMa6ev8X+PtAWbfEuKjuyreJZdFaUt+aZehOmE=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 29/34] crypto: lib/curve25519 - work around Clang stack spilling issue
Date:   Fri,  8 Nov 2019 13:22:35 +0100
Message-Id: <20191108122240.28479-30-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Arnd reports that the 32-bit generic library code for Curve25119 ends
up using an excessive amount of stack space when built with Clang:

  lib/crypto/curve25519-fiat32.c:756:6: error: stack frame size
      of 1384 bytes in function 'curve25519_generic'
      [-Werror,-Wframe-larger-than=]

Let's give some hints to the compiler regarding which routines should
not be inlined, to prevent it from running out of registers and spilling
to the stack. The resulting code performs identically under both GCC
and Clang, and makes the warning go away.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crypto/curve25519-fiat32.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/crypto/curve25519-fiat32.c b/lib/crypto/curve25519-fiat32.c
index 1c455207341d..2fde0ec33dbd 100644
--- a/lib/crypto/curve25519-fiat32.c
+++ b/lib/crypto/curve25519-fiat32.c
@@ -223,7 +223,7 @@ static __always_inline void fe_1(fe *h)
 	h->v[0] = 1;
 }
 
-static void fe_add_impl(u32 out[10], const u32 in1[10], const u32 in2[10])
+static noinline void fe_add_impl(u32 out[10], const u32 in1[10], const u32 in2[10])
 {
 	{ const u32 x20 = in1[9];
 	{ const u32 x21 = in1[8];
@@ -266,7 +266,7 @@ static __always_inline void fe_add(fe_loose *h, const fe *f, const fe *g)
 	fe_add_impl(h->v, f->v, g->v);
 }
 
-static void fe_sub_impl(u32 out[10], const u32 in1[10], const u32 in2[10])
+static noinline void fe_sub_impl(u32 out[10], const u32 in1[10], const u32 in2[10])
 {
 	{ const u32 x20 = in1[9];
 	{ const u32 x21 = in1[8];
@@ -309,7 +309,7 @@ static __always_inline void fe_sub(fe_loose *h, const fe *f, const fe *g)
 	fe_sub_impl(h->v, f->v, g->v);
 }
 
-static void fe_mul_impl(u32 out[10], const u32 in1[10], const u32 in2[10])
+static noinline void fe_mul_impl(u32 out[10], const u32 in1[10], const u32 in2[10])
 {
 	{ const u32 x20 = in1[9];
 	{ const u32 x21 = in1[8];
@@ -441,7 +441,7 @@ fe_mul_tll(fe *h, const fe_loose *f, const fe_loose *g)
 	fe_mul_impl(h->v, f->v, g->v);
 }
 
-static void fe_sqr_impl(u32 out[10], const u32 in1[10])
+static noinline void fe_sqr_impl(u32 out[10], const u32 in1[10])
 {
 	{ const u32 x17 = in1[9];
 	{ const u32 x18 = in1[8];
@@ -619,7 +619,7 @@ static __always_inline void fe_invert(fe *out, const fe *z)
  *
  * Preconditions: b in {0,1}
  */
-static __always_inline void fe_cswap(fe *f, fe *g, unsigned int b)
+static noinline void fe_cswap(fe *f, fe *g, unsigned int b)
 {
 	unsigned i;
 	b = 0 - b;
-- 
2.20.1

