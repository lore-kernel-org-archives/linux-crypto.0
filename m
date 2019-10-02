Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31782C352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BE6222BE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qsq0LJou"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfJBOSH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:18:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41548 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfJBOSG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:18:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id q9so1092546wrm.8
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l8cC6Plr9Pjy6A3czOGNz4y4TekSjUV9NitiUk1ehQ0=;
        b=Qsq0LJoujxz7MIHt0LpKbFOEBfni0+2aEhAzk8LlJqOkSFQgW/avAyZ9ny5PBPeWdp
         0ZK2UpVh1JTnWIwHBY38xyRAGfX7z7h4bZdB3G/CeJ0/KniC+//hf0IgfHBj94rPkMTf
         iwPT7Cx7d+c4EHrcCJm+uQP7vMbeAy9CFbFtb9h2GlLCvgZnJxa/kOIlDzCXyNZuzf7Y
         dnAX3gjoQ2t6Z83vQJVVKg7dAfK2otSQW+kkXktw2M19JJE71+ZlUdyYe6oX3gZKgHqZ
         L+6nMN9Ad8sUrdQqinOjwnG2A6jXWn/v7sU46K+2H7I54cd2w2kCSMukfrQW81GeaIuS
         IRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8cC6Plr9Pjy6A3czOGNz4y4TekSjUV9NitiUk1ehQ0=;
        b=MuGegs8n1LVp3jsIrPafDOiGJP/nMsLyJLMqXVkyTfZcD21FpEEkmfnoF9/NBVwrlC
         LE+pGgGdQbWQ/rnjekcHzAxDRxqklKKvUNJAPGw59HzFv9yjTvwlJd95Nw6z2WRRApvd
         sNeeJj9Pxgql7Y/4zbOmMBUiLEwGPlnSzueFud7uFqKRdahJ8OT1v7R7MIcI3q62SY74
         F0FD4A7QCw045yuoXN905vQAuo/5Goh5le+xbWzwV5XQHxTRwdstiKpJ7fW2zkuCgTPX
         vd1SvwDnkjjpt9xgtRf9ypD2b3tWQMq5+4Jfvi3201QAjzvTGjVPRqgAv01ESA3PkQAB
         vCfQ==
X-Gm-Message-State: APjAAAWKvXFTkZhAd0oF8mB4sJFZ0lbvQ9BEtp0mdzuVtVRhKWaG5OzS
        X3qBLTwk3Lf73GZ7p+I7u8iW41UxckBYz9i/
X-Google-Smtp-Source: APXvYqzCzxQliSRntq+hWxhctb0gkxCft+1j/DK/VeKClNfHVWgcBQjadU1emVLCOCjNYvsS/eI1rw==
X-Received: by 2002:a5d:5052:: with SMTP id h18mr2824697wrt.397.1570025884285;
        Wed, 02 Oct 2019 07:18:04 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:18:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 15/20] crypto: lib/curve25519 - work around Clang stack spilling issue
Date:   Wed,  2 Oct 2019 16:17:08 +0200
Message-Id: <20191002141713.31189-16-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
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
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

