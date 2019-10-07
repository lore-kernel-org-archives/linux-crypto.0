Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663A4C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37EA620659
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tBHqbCz6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfJGQqy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34975 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729126AbfJGQqy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so218440wmi.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l8cC6Plr9Pjy6A3czOGNz4y4TekSjUV9NitiUk1ehQ0=;
        b=tBHqbCz6T6xWpbqBVtCbqQbMhWL7rQZ6MMBP459qOKUAqgoq3SCwd1eOUpDkp1fAUn
         BsdotWKYC546hRZa3+Ml5EhKP/8+pQETAT9ju3eDsPH/elr7+Vm3qilFCAJhRNMqG19x
         UkODQFyJY/4tf7kaWAQJ9Q2wGu6eQggE3bPkuY93Nqs1JoKbYx6+bidtteZ3NyKIHJdH
         5wn1gWYNgNxHWw2sPgKJDe/GK5id0xzt9hcUzFgBLgW98p8/K3QWm+Rp8zfPk7Z7Bnze
         Cp0Caa5F8TC4eNRcnUsynEzMF6dsB1fW9rjGftgbPUniNQnbXuoSvOmZOTEzsA/7YhFu
         kirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8cC6Plr9Pjy6A3czOGNz4y4TekSjUV9NitiUk1ehQ0=;
        b=m8YIzD82yaQMKN82BLQF1b/tL5VvpCfMuEsk1RTbvQJ0tPfLlPVteN+T8+o9F/sFB+
         VW+Gzho5Awrnp+vqCD8R1BH8J9UmdoGllbcF23zQEB86qEgkxcpOEbXIWyhFDdgZv9L2
         Upm2ZVgdpkrxEN5C1h60iLMlNBNrLIdiB/3zTVontDyr+43XQDL/LUaSanknHBQ9c8RH
         B5mbTvC5O4di9+XETOUVwEvYX/t9pXhcfJfjqM459qpwlLoOhBKlr0N/wwEYTNCj0q8Q
         Hkrkr0uyns+oBUsntybj+TMCsYErCX+HL1/x+nsQ2nt52PlHfHXJRfMYofWdbDiOlcLx
         AZuw==
X-Gm-Message-State: APjAAAU8DQ+p4R5bnQsawUZ7V51amFfxTOUmycQKrGLoFGZ2gqZ0Dd/O
        TljJ3u8qu3yhQsNJe7Ux0MhtlHuhiEBA5Q==
X-Google-Smtp-Source: APXvYqz5hqnVsYTltXR9XArNBgaOpQE26XsQwkKg6mp9GTSa/ZmG4zx3XIcd3oNgjj5/LCnD7TDGvQ==
X-Received: by 2002:a1c:2d54:: with SMTP id t81mr131696wmt.167.1570466812451;
        Mon, 07 Oct 2019 09:46:52 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 24/29] crypto: lib/curve25519 - work around Clang stack spilling issue
Date:   Mon,  7 Oct 2019 18:46:05 +0200
Message-Id: <20191007164610.6881-25-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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

