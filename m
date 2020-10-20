Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5366BC4363A
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0117B2224A
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438580AbgJTUkF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:40:05 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:43333 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438558AbgJTUkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 16:40:04 -0400
Received: by mail-qv1-f67.google.com with SMTP id bl9so1607851qvb.10;
        Tue, 20 Oct 2020 13:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9+fYvZA6OGxCjC49pxceAMWASEc8BRotkYG4ADhk4ho=;
        b=JWLvaS8wCjKWexcPc3BoI4sBdi39bUd8uh5pVd1l//M3aILYIbzthEMxWRZUZL4fXK
         3/z4gbycqaVuCIlfDJLS5uWoBxQkx1BbqfXiMqoYxFdRskVJBLBaNQZMz+wLx+amwu8+
         8im9MTThU+STMa6RtJJFtuoN9shhB1zpuSNyw5qT8rbzxwjj6NYkEea84/zsqCGO4GaU
         wI+BmjLazwGahgYs89fUNXrTerz2+8qEmBYXJk8ct2zLqGjh9w7r1JyM4iMTgSbltbpx
         LlkD870psX3MWg0hMjZz+soyytjjKnMLBnNknq0wz1ZOd7ygcWuEiXPi33ugdFQP1Yde
         hsFQ==
X-Gm-Message-State: AOAM533Q+f5DtHLodhN5x4lWNa+dfzegqrw9sPi5yIAthpG/Y7o6liRG
        Nnbai84dpdHZav59ioyGWuA=
X-Google-Smtp-Source: ABdhPJzfLl4jXSjc8Hggbj0SmPNpo+dqw+5034gdZpKS9UNyuPzF4ug4+ejto4Uo70CiFe9OknsVMQ==
X-Received: by 2002:a05:6214:125:: with SMTP id w5mr5110433qvs.3.1603226401734;
        Tue, 20 Oct 2020 13:40:01 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m18sm1411165qkk.102.2020.10.20.13.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:40:01 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] crypto: lib/sha256 - Don't clear temporary variables
Date:   Tue, 20 Oct 2020 16:39:53 -0400
Message-Id: <20201020203957.3512851-3-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020203957.3512851-1-nivedita@alum.mit.edu>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The assignments to clear a through h and t1/t2 are optimized out by the
compiler because they are unused after the assignments.

These variables shouldn't be very sensitive: t1/t2 can be calculated
from a through h, so they don't reveal any additional information.
Knowing a through h is equivalent to knowing one 64-byte block's SHA256
hash (with non-standard initial value) which, assuming SHA256 is secure,
doesn't reveal any information about the input.

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

