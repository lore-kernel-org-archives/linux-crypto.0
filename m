Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C392BC4363A
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916B5208E4
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416635AbgJYOb2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 10:31:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40120 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1414677AbgJYOb2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 10:31:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id m9so4899089qth.7;
        Sun, 25 Oct 2020 07:31:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bi7rG0H94VO76zPLa4Hh0/sN75asB3cy5CcRjg5R6zI=;
        b=nyp0VgarkLXREJjtBpcWE0kZDqvPQ0R2yuPDrRgGg2lEClPv/Slonlc94thftyEBHV
         pwHUqAjSix+ap5kdAfn1YGOeI19gBHm2vru48ThN9OfE8RqbzbcQBO9D05qdGXf3jptG
         1HQGULOuHNGncGYDyMEuxFTmFqa2nDcVfOaNv7NhyS9p4SnaA1d2+gZZNHsR50iNZv5x
         w3tRu6XRVaVOaHdChrKovEl5n/THltSuE28ZBBO3tmPJ2oOju2RTsKXvvrS8eRPLV1fJ
         lLnD8T/a/ZQlVJwwAHsjjdkRk8PYEx6eCHFd2KDb2Yqq6usLwZuztS1jYgv+uhcaShRk
         lgOw==
X-Gm-Message-State: AOAM531tKJupFq/8CXE+PD/M+n4tLdrMnYmgFyOMwOFs93Hrrdi9B1Yt
        u4Kh4Y4GEMQWtbYfnFNKX1Q=
X-Google-Smtp-Source: ABdhPJy6TJ7OnnPMnOVBY7QpOsC5dVA//baSaIV9SoClXC96369xl8GnFioUvT3jfKCGp6Xr8IyUnw==
X-Received: by 2002:a05:622a:242:: with SMTP id c2mr12600299qtx.230.1603636287091;
        Sun, 25 Oct 2020 07:31:27 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id s73sm4740898qke.71.2020.10.25.07.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 07:31:26 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH v4 4/6] crypto: lib/sha256 - Clear W[] in sha256_update() instead of sha256_transform()
Date:   Sun, 25 Oct 2020 10:31:17 -0400
Message-Id: <20201025143119.1054168-5-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025143119.1054168-1-nivedita@alum.mit.edu>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The temporary W[] array is currently zeroed out once every call to
sha256_transform(), i.e. once every 64 bytes of input data. Moving it to
sha256_update() instead so that it is cleared only once per update can
save about 2-3% of the total time taken to compute the digest, with a
reasonable memset() implementation, and considerably more (~20%) with a
bad one (eg the x86 purgatory currently uses a memset() coded in C).

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 lib/crypto/sha256.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 099cd11f83c1..c6bfeacc5b81 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -43,10 +43,9 @@ static inline void BLEND_OP(int I, u32 *W)
 	W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
 }
 
-static void sha256_transform(u32 *state, const u8 *input)
+static void sha256_transform(u32 *state, const u8 *input, u32 *W)
 {
 	u32 a, b, c, d, e, f, g, h, t1, t2;
-	u32 W[64];
 	int i;
 
 	/* load the input */
@@ -200,15 +199,13 @@ static void sha256_transform(u32 *state, const u8 *input)
 
 	state[0] += a; state[1] += b; state[2] += c; state[3] += d;
 	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
-
-	/* clear any sensitive info... */
-	memzero_explicit(W, 64 * sizeof(u32));
 }
 
 void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
 	unsigned int partial, done;
 	const u8 *src;
+	u32 W[64];
 
 	partial = sctx->count & 0x3f;
 	sctx->count += len;
@@ -223,11 +220,13 @@ void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 		}
 
 		do {
-			sha256_transform(sctx->state, src);
+			sha256_transform(sctx->state, src, W);
 			done += 64;
 			src = data + done;
 		} while (done + 63 < len);
 
+		memzero_explicit(W, sizeof(W));
+
 		partial = 0;
 	}
 	memcpy(sctx->buf + partial, src, len - done);
-- 
2.26.2

