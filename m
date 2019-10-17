Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AC2ECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F52921835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JTrpH5vM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503396AbfJQTKq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45928 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503404AbfJQTKp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so3568093wrm.12
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l8cC6Plr9Pjy6A3czOGNz4y4TekSjUV9NitiUk1ehQ0=;
        b=JTrpH5vMG4pRHdwhPUcRaOLrAQJrXB21I1UgYWDWYCbLl1o+OLRQ27LBhLTTSN5pDL
         TuIOaPHu15kOTFszlcEZnGwqg7bGNJjgR44yLhOOzy6OkrPZb5WywEJMs2CHwKGifD+R
         LMzIzUjn1F5sPeAgKB0qTm+5GdQzX1+kbD59QKr20FVi3W/C9ri/SqLf6vN9AlDbo/eT
         bCP6oTTFGRgB6BtI47HrrksplqnHZPxVbqKLJXg0mKj2/KZCecWP80b1mebSlmRMhc0H
         1bhuRCfDQ+4+e3aIfI5YYsTyascoMDkWJhK5uStZ1Lf14lMp+ltPMdfyykMbH/GzdDMk
         v1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8cC6Plr9Pjy6A3czOGNz4y4TekSjUV9NitiUk1ehQ0=;
        b=EN1xGVLNGOFLFzTvtXPOwfOfXqsN/9NMQ3XQSHzpfuJZ7v0pYmrw4+9dtBdsFHzsIU
         mxKiZwTLmJ6JGaBLTm4Ti118VZqWGIL3/Eny4mTjj/nlIcuPPiTgpmJoO2MSARq0nz1o
         batDRYo0v3ZJSoTVMlyj9MtlLaUbG+FXaJP9iC60agwTIlWFGRr6Tc4oEtVZakFN3OTe
         QrYldI6mekI++9Ql5nNUMMYgDGevrjsW34rEJQcHgWDI35xL3qb38umLgeQPiIbwX78Y
         PQWniPoUSBLSWxsfhWrqGcYEPEe4n2nOIVxXJ/9Sc6rvMHg9kqcNCPYmUZi7jQhnd0K+
         2Y/Q==
X-Gm-Message-State: APjAAAXYcwnbmDSjmqP2fjFE3tANEzvFbzOFEfweY3ElrVIy303Nt7Xw
        LGU9hCv6OAGJgyyPNLhxOZ/hb3H3pXFegXow
X-Google-Smtp-Source: APXvYqzDXkvWOgnVcTuIGaJ4j5NePKT6AY2NOuZlVUh8fGerdyffG7pISgXs0Mo5m1T5djmOtAe3Jw==
X-Received: by 2002:adf:fcd2:: with SMTP id f18mr1569432wrs.388.1571339443532;
        Thu, 17 Oct 2019 12:10:43 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:42 -0700 (PDT)
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
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 30/35] crypto: lib/curve25519 - work around Clang stack spilling issue
Date:   Thu, 17 Oct 2019 21:09:27 +0200
Message-Id: <20191017190932.1947-31-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
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

