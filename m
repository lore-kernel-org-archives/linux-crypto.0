Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F005C4363A
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24182208E4
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 14:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414761AbgJYObY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 10:31:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34851 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1414677AbgJYObY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 10:31:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id c15so4921116qtc.2;
        Sun, 25 Oct 2020 07:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MN0s8vlWrwWpnF9v8V5eNRd1d4ATTd49nrUqABX5hio=;
        b=ABdQs9FVB8/FzH8dKAILE4TkU/0WO2NHBuHP9zeq4lYz1kyJ1asNrBgxWVMh3bsIUA
         AGWqBw/D8j0CWprixxXJBrfZn8QYylaPBG7j5JXYE1xztO5/jP7cuyVTCaJcYI7JMFet
         ym9MPhVf2aSjXQxLDSVp/zbA6OmTWs09RCgsd/fHdThVOn8Wk/TfeArCL3yq7DUeLGAA
         54iSTNyKhgttz/geEpm2deBV/KaYlKB0zzSO8LlXDbSkAj+8uwmb/T6i1iYAXSk7Tpep
         gHkd4elqXb8n6A1OXl/6X0xDJzvEdITCAJ3HNCWDLn/8iHZu9arKrirb3D+wxoQwm1jV
         6BRw==
X-Gm-Message-State: AOAM532lF+KE9aJ4fJKsjf2EHbOqj8UbFy5WyumVkF4m0ddCexbIT5hD
        LG1SBDNbJW3nsw5kwcP9kpk=
X-Google-Smtp-Source: ABdhPJyOKIf4i9PAJrrokcQidlOn76hVGHHE4GJVfoadKRDzionc4xHJHuexCc+Z/QteZtRrMAURNg==
X-Received: by 2002:aed:3a86:: with SMTP id o6mr11818147qte.333.1603636283458;
        Sun, 25 Oct 2020 07:31:23 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id s73sm4740898qke.71.2020.10.25.07.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 07:31:22 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH v4 1/6] crypto: lib/sha256 - Use memzero_explicit() for clearing state
Date:   Sun, 25 Oct 2020 10:31:14 -0400
Message-Id: <20201025143119.1054168-2-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025143119.1054168-1-nivedita@alum.mit.edu>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Without the barrier_data() inside memzero_explicit(), the compiler may
optimize away the state-clearing if it can tell that the state is not
used afterwards. At least in lib/crypto/sha256.c:__sha256_final(), the
function can get inlined into sha256(), in which case the memset is
optimized away.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 lib/crypto/sha256.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 2321f6cb322f..d43bc39ab05e 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -265,7 +265,7 @@ static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
 		put_unaligned_be32(sctx->state[i], &dst[i]);
 
 	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(*sctx));
+	memzero_explicit(sctx, sizeof(*sctx));
 }
 
 void sha256_final(struct sha256_state *sctx, u8 *out)
-- 
2.26.2

