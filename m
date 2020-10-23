Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C87C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B9B5206DC
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751737AbgJWTWJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 15:22:09 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40468 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbgJWTWJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 15:22:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id h140so2237496qke.7;
        Fri, 23 Oct 2020 12:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2MMdXJnn8I5qbdPqNRJaBrVa9H2HlYZso3sU1VlHnnc=;
        b=GZSC6nz6G/Hv8vSqa4V+nuUq6c5J5ur8sp6iawql1orNUosyVXZKfnbZdDyeHidvCx
         yeDVSOawEFDYSIz72UBxrM4BIE9K6YtoFitdSM8YF53xpxPzSQEymClECsXEBuqfzHgG
         jHcpEB3YlwiBWutk5KMwXxakeJcjfb5F2VvNDac/lTh445wLi52cfcTvUkK4eMhSFGQm
         qBFTRpUVF7uqqeL7yjSFBHdZ1nJ9dWE4tSLhh7uGozPvtwdrVIHdPHbjGIMPFmow1TBc
         bePnb7WOzz3DXMBEPl9lKzxmbfpBMr//cXykzsTFbxn/hA+TRfIExMephnIQTBco84NJ
         FtiQ==
X-Gm-Message-State: AOAM531kLKHiGFbDUVDRIn+zJG7kSvDWHoAuTwHTcV/S8/Vi5wkc0haE
        ymG4EOzcSWZyvxOl0oeY9usDy/TZzr5caQ==
X-Google-Smtp-Source: ABdhPJwfoi1h8DUj9DC3Y6t1HmHe7rYHitdm4mibV5dm5Jtk9J8ABhu5i5U4p47WC4EXl6ICwhVfwA==
X-Received: by 2002:a05:620a:4f8:: with SMTP id b24mr3565552qkh.299.1603480927925;
        Fri, 23 Oct 2020 12:22:07 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id n199sm1398493qkn.77.2020.10.23.12.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 12:22:06 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] crypto: lib/sha256 - Don't clear temporary variables
Date:   Fri, 23 Oct 2020 15:22:00 -0400
Message-Id: <20201023192203.400040-3-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023192203.400040-1-nivedita@alum.mit.edu>
References: <20201023192203.400040-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The assignments to clear a through h and t1/t2 are optimized out by the
compiler because they are unused after the assignments.

Clearing individual scalar variables is unlikely to be useful, as they
may have been assigned to registers, and even if stack spilling was
required, there may be compiler-generated temporaries that are
impossible to clear in any case.

So drop the clearing of a through h and t1/t2.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 lib/crypto/sha256.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index d43bc39ab05e..099cd11f83c1 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -202,7 +202,6 @@ static void sha256_transform(u32 *state, const u8 *input)
 	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
 
 	/* clear any sensitive info... */
-	a = b = c = d = e = f = g = h = t1 = t2 = 0;
 	memzero_explicit(W, 64 * sizeof(u32));
 }
 
-- 
2.26.2

