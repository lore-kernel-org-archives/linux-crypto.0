Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A587EC55178
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE472085B
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415098AbgJYObj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 10:31:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40116 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1414982AbgJYObj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 10:31:39 -0400
Received: by mail-qt1-f193.google.com with SMTP id m9so4899067qth.7;
        Sun, 25 Oct 2020 07:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i4eX+361CNFGQN2UQLtgO0wdjlQPWSbW5hz94r5g1po=;
        b=tScp24scpYi2zAVXN+6cWi7UoQWz5yBBWFgZ5tgQ076hhFabZKGCc825tuzy2TNdz8
         m3Lo/aDSMI6cWWTsIbNciemzSqHdZUcXRGBXZjqCFmNt+FlVQzqU/KeavkNjvQz+bepY
         ZyuC6lHp6yBc9mPbK6s/mE6jA/oRFWK/JsLL+Vb2IxL87srq0EV+t/kGYpIDL4svzKax
         eam5Z8LOGBVB9MF0CGT3ymIS/uj7CiCJ9gSczeoBjO85TTwXb7h06CIAADs9YTl1VW1a
         hwjFa2zrxgoAzNv9Dp+hQrn5IM5HW0VYaKhJxWoruxlmJj8x1TS5X3fEwl+1Y8TRkupS
         Amyg==
X-Gm-Message-State: AOAM53350OucaiVPtJ1tYsA+NaaiePa8CgRCjE2OYSb8fCVZfWF1ggF5
        u00/PyWcq8pA1L3ynFV3QTqLoJhfXuxTEQ==
X-Google-Smtp-Source: ABdhPJzsyfCxly9OaP5gTUypi9SJ3XskYCAgFs2n8MAOXaQkSc0VJXtdrA9GC6ZXK/ovTZ5RkX0y+A==
X-Received: by 2002:ac8:4e0d:: with SMTP id c13mr11383519qtw.382.1603636285799;
        Sun, 25 Oct 2020 07:31:25 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id s73sm4740898qke.71.2020.10.25.07.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 07:31:24 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH v4 3/6] crypto: lib/sha256 - Don't clear temporary variables
Date:   Sun, 25 Oct 2020 10:31:16 -0400
Message-Id: <20201025143119.1054168-4-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025143119.1054168-1-nivedita@alum.mit.edu>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
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
Reviewed-by: Eric Biggers <ebiggers@google.com>
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

