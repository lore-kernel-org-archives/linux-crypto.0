Return-Path: <SRS0=7/wf=D2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF40C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 15:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C3F2231B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 15:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgJSPaX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:30:23 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34344 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730159AbgJSPaX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Oct 2020 11:30:23 -0400
Received: by mail-io1-f67.google.com with SMTP id z5so120141iob.1;
        Mon, 19 Oct 2020 08:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aC0csafA10XEKxluLw+TGr+3B4XctKQH20XSmRK1UrE=;
        b=MSWB6fqIC6j6CuW5pNwGF6kA9prfZNxEGnGCkLHeyHeN2vqvRGcbZ5n3F1Ug71+3TR
         S3pnKQ/qV9Son6pwJjK41QHMvK5DFRhX6iM/TicSgVZttJb8lj/voLn8ct+abl5qsLK0
         kyTwMN05MYFIKMfcGPNGDQ0txA5McrADbXjbUOHusMltZAtxnbH1v48Y/xejve1Yx48q
         V9SZIA8QziVRTVma/PUiZ2uJ+7PRxyxJT7NnMspIsZ0XWo0gftZ7xPHru4oJ/LuLjNwb
         h0su3WyzRrTd3gsFd4lJ8e9d/yZea8gJQsoHStpO2jT0B9brQsEUiC3LvSHqhCRY7wnU
         kzFQ==
X-Gm-Message-State: AOAM530FvBO7nVHsR8R+KFgPZ5zj4anzcNpRQLpJwQqBqvIH8wfiVBtw
        gVdpsyW+gdg0F6NaBgShKn8uGKB5Jy1PrA==
X-Google-Smtp-Source: ABdhPJw6vOfZ53/ezVU4AfArNOg2Eqfsf+hVvOCdWsrW2Ftb3e/WpgVAoeJLJYjdkRpu7CwYqg9uoA==
X-Received: by 2002:a02:8661:: with SMTP id e88mr390665jai.43.1603121421961;
        Mon, 19 Oct 2020 08:30:21 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m86sm20898ilb.44.2020.10.19.08.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:30:21 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] crypto: lib/sha256 - Clear W[] in sha256_update() instead of sha256_transform()
Date:   Mon, 19 Oct 2020 11:30:14 -0400
Message-Id: <20201019153016.2698303-4-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201019153016.2698303-1-nivedita@alum.mit.edu>
References: <20201019153016.2698303-1-nivedita@alum.mit.edu>
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

