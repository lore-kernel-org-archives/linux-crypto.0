Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8191C4363A
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FCAC22256
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438624AbgJTUkS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:40:18 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43952 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438558AbgJTUkI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 16:40:08 -0400
Received: by mail-qk1-f194.google.com with SMTP id c2so3093684qkf.10;
        Tue, 20 Oct 2020 13:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BCw7VQquYIPd9JPnAjoiF0ZfNAHI16hdt3AF4EdaI8s=;
        b=IQjd+HED8RY9unoapsDgf7A7S33hMhYzTsKtudNxEsHuJ/hjWfNZXwj+unzJsqmOjn
         /viROiPLpLJXs0uMfKZzP0w+IqcLQhfezRnWjYweJgHoVIQkdt7zrCQ7PAedfy4l2tmO
         J8799aMFhtQ9FMc5A4MqGMBWop5/aVICetW231cTirC++A38JVhLW8MVaCBkai64FUO0
         xn7VVrlDkl2+b8vJHGiPvJ19p8/RFRBn/5RbGnsMC+Ps139qGnReNJJamgM60ONYSp9O
         ebYJ0jP6zAv7SqCGTF3E39RHskpjgJuVSsyPoFuxqbpAIAzPflwKJeG1QpP6IjGCFSIs
         Jb6Q==
X-Gm-Message-State: AOAM530leu4qt3awrX1TOD8rL5NkjpIIoMpaVXIKAL6EUI1JhLvfR21z
        c1Q69jJcFn0/osHL94x8Log=
X-Google-Smtp-Source: ABdhPJxMGCQ4K0SCS+bCPOy6kEHVB4i5UbRyQ4MWuaMTJynumL/mEmyGcFgJ6Tmfop097cyVGLGslQ==
X-Received: by 2002:a05:620a:40f:: with SMTP id 15mr73478qkp.398.1603226406685;
        Tue, 20 Oct 2020 13:40:06 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m18sm1411165qkk.102.2020.10.20.13.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:40:05 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] crypto: lib/sha - Combine round constants and message schedule
Date:   Tue, 20 Oct 2020 16:39:57 -0400
Message-Id: <20201020203957.3512851-7-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020203957.3512851-1-nivedita@alum.mit.edu>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Putting the round constants and the message schedule arrays together in
one structure saves one register, which can be a significant benefit on
register-constrained architectures. On x86-32 (tested on Broadwell
Xeon), this gives a 10% performance benefit.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
---
 lib/crypto/sha256.c | 49 ++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 3a8802d5f747..985cd0560d79 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -29,6 +29,11 @@ static const u32 SHA256_K[] = {
 	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
 };
 
+struct KW {
+	u32 K[64];
+	u32 W[64];
+};
+
 static inline u32 Ch(u32 x, u32 y, u32 z)
 {
 	return z ^ (x & (y ^ z));
@@ -56,39 +61,39 @@ static inline void BLEND_OP(int I, u32 *W)
 
 #define SHA256_ROUND(i, a, b, c, d, e, f, g, h) do {		\
 	u32 t1, t2;						\
-	t1 = h + e1(e) + Ch(e, f, g) + SHA256_K[i] + W[i];	\
+	t1 = h + e1(e) + Ch(e, f, g) + KW->K[i] + KW->W[i];	\
 	t2 = e0(a) + Maj(a, b, c);				\
 	d += t1;						\
 	h = t1 + t2;						\
 } while (0)
 
-static void sha256_transform(u32 *state, const u8 *input, u32 *W)
+static void sha256_transform(u32 *state, const u8 *input, struct KW *KW)
 {
 	u32 a, b, c, d, e, f, g, h;
 	int i;
 
 	/* load the input */
 	for (i = 0; i < 16; i += 8) {
-		LOAD_OP(i + 0, W, input);
-		LOAD_OP(i + 1, W, input);
-		LOAD_OP(i + 2, W, input);
-		LOAD_OP(i + 3, W, input);
-		LOAD_OP(i + 4, W, input);
-		LOAD_OP(i + 5, W, input);
-		LOAD_OP(i + 6, W, input);
-		LOAD_OP(i + 7, W, input);
+		LOAD_OP(i + 0, KW->W, input);
+		LOAD_OP(i + 1, KW->W, input);
+		LOAD_OP(i + 2, KW->W, input);
+		LOAD_OP(i + 3, KW->W, input);
+		LOAD_OP(i + 4, KW->W, input);
+		LOAD_OP(i + 5, KW->W, input);
+		LOAD_OP(i + 6, KW->W, input);
+		LOAD_OP(i + 7, KW->W, input);
 	}
 
 	/* now blend */
 	for (i = 16; i < 64; i += 8) {
-		BLEND_OP(i + 0, W);
-		BLEND_OP(i + 1, W);
-		BLEND_OP(i + 2, W);
-		BLEND_OP(i + 3, W);
-		BLEND_OP(i + 4, W);
-		BLEND_OP(i + 5, W);
-		BLEND_OP(i + 6, W);
-		BLEND_OP(i + 7, W);
+		BLEND_OP(i + 0, KW->W);
+		BLEND_OP(i + 1, KW->W);
+		BLEND_OP(i + 2, KW->W);
+		BLEND_OP(i + 3, KW->W);
+		BLEND_OP(i + 4, KW->W);
+		BLEND_OP(i + 5, KW->W);
+		BLEND_OP(i + 6, KW->W);
+		BLEND_OP(i + 7, KW->W);
 	}
 
 	/* load the state into our registers */
@@ -115,7 +120,7 @@ void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
 	unsigned int partial, done;
 	const u8 *src;
-	u32 W[64];
+	struct KW KW;
 
 	partial = sctx->count & 0x3f;
 	sctx->count += len;
@@ -129,13 +134,15 @@ void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 			src = sctx->buf;
 		}
 
+		memcpy(KW.K, SHA256_K, sizeof(KW.K));
+
 		do {
-			sha256_transform(sctx->state, src, W);
+			sha256_transform(sctx->state, src, &KW);
 			done += 64;
 			src = data + done;
 		} while (done + 63 < len);
 
-		memzero_explicit(W, sizeof(W));
+		memzero_explicit(KW.W, sizeof(KW.W));
 
 		partial = 0;
 	}
-- 
2.26.2

