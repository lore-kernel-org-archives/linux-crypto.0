Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9482C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FAC620E65
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750842AbgJWTWQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 15:22:16 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42678 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbgJWTWM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 15:22:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id i22so2236966qkn.9;
        Fri, 23 Oct 2020 12:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rybpjupXWyCo0yLZ9NEgjQq2QiRjNeLKs2uYGAtk9sY=;
        b=FgM9KcxHHLi5/dtjCDOYsj6aHKRRHthNr6/ZcEm2lOi7V5CpwSg9PwDQOq47T9eqB4
         sL7T6+jmQE1zJx9zEw9H1UzojMpcuqU+XYEzEGMPwUjofkIekUBc00vHYw8sfFxwWK6n
         lCdF4S2nv4McXnG0TXk6uRUU4vrHWMpUHyNNolyAzChEUG7DPbvwxhZ/IoapdOexiWPR
         jGxJAGEIRGAZ1HJlBrocaVuc6S88AQ1SfZbMbvQuxnZ56J2LIau3wEWmyNf8UFOLVsQv
         3ZmNufmVan7rf5v6KFX3iJmR4pJd0w8Y7fekuPr0dKC4Ofic1i51f3S3gji2Q0uOvDQk
         YvNg==
X-Gm-Message-State: AOAM53096bQy3/Fhw+I33eUnSChw2tDR6YdmmEOaAtfTUQEZaY8P0n9b
        tt67q1hC/p9YDk1vgeuwZ3I=
X-Google-Smtp-Source: ABdhPJyylrFMKbqm8pN8Uu40iZWqkKQdrfSuG++ijxAkjIyXpib1VPruhJJjwLX6FL/FXkezVYap9g==
X-Received: by 2002:ae9:f507:: with SMTP id o7mr3658481qkg.420.1603480931081;
        Fri, 23 Oct 2020 12:22:11 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id n199sm1398493qkn.77.2020.10.23.12.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 12:22:10 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH v3 5/5] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Date:   Fri, 23 Oct 2020 15:22:03 -0400
Message-Id: <20201023192203.400040-6-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023192203.400040-1-nivedita@alum.mit.edu>
References: <20201023192203.400040-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Unrolling the LOAD and BLEND loops improves performance by ~8% on x86_64
(tested on Broadwell Xeon) while not increasing code size too much.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 lib/crypto/sha256.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index e2e29d9b0ccd..cdef37c05972 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -76,12 +76,28 @@ static void sha256_transform(u32 *state, const u8 *input, u32 *W)
 	int i;
 
 	/* load the input */
-	for (i = 0; i < 16; i++)
-		LOAD_OP(i, W, input);
+	for (i = 0; i < 16; i += 8) {
+		LOAD_OP(i + 0, W, input);
+		LOAD_OP(i + 1, W, input);
+		LOAD_OP(i + 2, W, input);
+		LOAD_OP(i + 3, W, input);
+		LOAD_OP(i + 4, W, input);
+		LOAD_OP(i + 5, W, input);
+		LOAD_OP(i + 6, W, input);
+		LOAD_OP(i + 7, W, input);
+	}
 
 	/* now blend */
-	for (i = 16; i < 64; i++)
-		BLEND_OP(i, W);
+	for (i = 16; i < 64; i += 8) {
+		BLEND_OP(i + 0, W);
+		BLEND_OP(i + 1, W);
+		BLEND_OP(i + 2, W);
+		BLEND_OP(i + 3, W);
+		BLEND_OP(i + 4, W);
+		BLEND_OP(i + 5, W);
+		BLEND_OP(i + 6, W);
+		BLEND_OP(i + 7, W);
+	}
 
 	/* load the state into our registers */
 	a = state[0];  b = state[1];  c = state[2];  d = state[3];
-- 
2.26.2

