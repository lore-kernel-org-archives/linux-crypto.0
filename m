Return-Path: <SRS0=7/wf=D2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21915C433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 15:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B312236F
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 15:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgJSPag (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:30:36 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38765 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbgJSPaV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Oct 2020 11:30:21 -0400
Received: by mail-io1-f67.google.com with SMTP id y20so73345iod.5;
        Mon, 19 Oct 2020 08:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9+fYvZA6OGxCjC49pxceAMWASEc8BRotkYG4ADhk4ho=;
        b=l+lESt79cpyZlrJfXkkh2R9ewcV+FlL9Azk95xc9VlxJkwB2ZFSXOcbVrJddCCnXHQ
         BvMwdlorKquMRX5nrvxhTUtOd7IRwaNU3hhqUDxGWbJ/BTI3cRQUD06kg1+IYQcnS8e9
         RO9TXTWTFqMig3/KWN0BGJkti/5en9MUPsIkQ3BvBymybRiNtX0c/7ddJm3CyRXGLvNm
         W5XJ7sW1hctBSIzs76stTPzxiF61m2JYCG+PwusyRcBRz0aKqPNcUo3rNB1TuMRGQF2/
         3QyVlXxZhLYf77pj780AbYWmMnGbV2s0O5wU8rtWm2cLqMC/+Y2/ylDyTu5y6mopJqxA
         X7uQ==
X-Gm-Message-State: AOAM531fcfO1+B6k+olOvOepqwDvHO3Tt7lZWHgdx2RC0Ih9mBvQrV01
        3arH43jheZ2TY9ivdDv5dOT5DBfUOIsQjg==
X-Google-Smtp-Source: ABdhPJz4KaLdjhHYJPVhlsUrlbCFsf+W1va+HYApX9EVBU2gwjevrbiIHfGSGDMlHghEei/UDKworw==
X-Received: by 2002:a02:b80f:: with SMTP id o15mr366335jam.103.1603121420664;
        Mon, 19 Oct 2020 08:30:20 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m86sm20898ilb.44.2020.10.19.08.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:30:20 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] crypto: lib/sha256 - Don't clear temporary variables
Date:   Mon, 19 Oct 2020 11:30:13 -0400
Message-Id: <20201019153016.2698303-3-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201019153016.2698303-1-nivedita@alum.mit.edu>
References: <20201019153016.2698303-1-nivedita@alum.mit.edu>
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

