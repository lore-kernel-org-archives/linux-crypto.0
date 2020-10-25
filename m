Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248F5C4363A
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2A242085B
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416781AbgJYObn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 10:31:43 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:35466 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1415244AbgJYObm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 10:31:42 -0400
Received: by mail-qv1-f68.google.com with SMTP id cv1so3134923qvb.2;
        Sun, 25 Oct 2020 07:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rybpjupXWyCo0yLZ9NEgjQq2QiRjNeLKs2uYGAtk9sY=;
        b=jIi59V8fg766tRd0f4HbdmPRyVIJf/KnKAebRnoQUaZybUE/lMGlo/Sgp00BG6CKXM
         dyo5Yw6YNoVfoaQbnMymg7EbBX9KL23hxNNEvPbMgK6PXpz1vxqxcJcJczzp15e+G7Gk
         FX1iMpCLEPQMv0YlZd4ht/HutMhQVp2+akp5lWSW/rSVdxyMgCfVeJ6LV3cUsShaXYVX
         4wtCdgfDynElEv1jNPS4s7rKUXxtK1Rn3zV0mVSig/qMYOMGFN4To4Ek8R4SnStdb4ZH
         cY1Av+RK6wrqQk+nuJeGxz+U5dn263Xykr1Ah4pp2qBWHW8xtWq10Dz9AuzV1jQGf4Uf
         q2BQ==
X-Gm-Message-State: AOAM531d4AILjWNP/Tl4EA3fX7B5Cxl+kIx4wDE0daH6o2WKmajDg9ub
        OjNdRv2oAb693lPzykq9yK4=
X-Google-Smtp-Source: ABdhPJxsUNDbzN+EXbhacs1WTTLV7SYvwCSmhyoEEWNK5Iat+TXSXLYY98tgMkwvLMmZzQfTIZWOcA==
X-Received: by 2002:a05:6214:174f:: with SMTP id dc15mr8374974qvb.26.1603636289075;
        Sun, 25 Oct 2020 07:31:29 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id s73sm4740898qke.71.2020.10.25.07.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 07:31:28 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Date:   Sun, 25 Oct 2020 10:31:19 -0400
Message-Id: <20201025143119.1054168-7-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025143119.1054168-1-nivedita@alum.mit.edu>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
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

