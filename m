Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E772C4320A
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 10:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83E406127B
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 10:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhHVKbt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Aug 2021 06:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbhHVKbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Aug 2021 06:31:48 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D7EC061575;
        Sun, 22 Aug 2021 03:31:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u16so21427319wrn.5;
        Sun, 22 Aug 2021 03:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9X+CpU5/dJXHLe/YiexKZwFlsJapREKfLFd7TDqnCAo=;
        b=Dzud64GxzJoPF4WnW/eg1gl00gg/M/VV378km3mMmlghjdRVJ/blQROzu5z99N/FxQ
         zg/0LKphCQVeGgsZ+v7nBypYEoATGRGQGYl4zsENnwbR+H5SrIr7VWbXNjg+C0Uwex4z
         jIOD3TwJwDPNOvprUCj8QQ8qsVX/E+/j3GHTMpxSi9pg3lrIExmFd8067+glLgdjiSud
         dx6IEzJMGMekKEnm/Uv0IxWYirf2a74ohwZIDqVbujzdujDIRNrOhNnoQ8/ryCQ1gXor
         MSUxt5fb/TRrkp/D94i0FpyA7YtExIe40RXFLZ5cO9mKoVNndLbZCCvExLE3vgoeFzsf
         J93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9X+CpU5/dJXHLe/YiexKZwFlsJapREKfLFd7TDqnCAo=;
        b=ljFqNyMcqnxv353If2mo7pcxe2UrdwgNF3MmhtgTsZ5vGBmyBykPeavdjwLQUvzzoz
         gCDlKJoNrbnvO4T9hB9OXDcl39PB+7yB9Ec9LsrSOwrALRyg82YSWB9xwmuqpMkf1YOd
         ti5Qw53W6is7WXkUqhGcjOdqzhyDfPl8RCjqh22uJn50N6nIjZqZkC3J3rHIlE8wsX8I
         6lXr6qIp58N1Q5NM5MCQbL4bDr/sOfyZpbdAJcvFckvtJvn9t1h8+bB93BPuIEYATrTo
         fuIFCLywLSk/VFf3ySXtp27FFKPWIVp6+lw/qDHfV2aNNti/pzMbmx5aXkxR2Yw7zAsz
         sf9A==
X-Gm-Message-State: AOAM533fGhkSi5J5OIq563FqXHRx7rmiof0JZjLyai/xcQ3uDw4seew2
        Qgp339ApTr6VhCBpa2U6TXg=
X-Google-Smtp-Source: ABdhPJz9zAKop+9s4/jzr41y325y1a1S02ge9Ac/Ov2i4D84ykpZX+qRgVzn41WjX2BabM+T645EBA==
X-Received: by 2002:adf:f40d:: with SMTP id g13mr7992982wro.69.1629628266153;
        Sun, 22 Aug 2021 03:31:06 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id z5sm15389199wmp.26.2021.08.22.03.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 03:31:05 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] crypto: sha512: remove imaginary and mystifying clearing of variables
Date:   Sun, 22 Aug 2021 12:31:07 +0200
Message-Id: <20210822103107.28974-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function sha512_transform() assigns all local variables to 0 before
returning to its caller with the intent to erase sensitive data.

However, make clang-analyzer warns that all these assignments are dead
stores, and as commit 7a4295f6c9d5 ("crypto: lib/sha256 - Don't clear
temporary variables") already points out for sha256_transform():

  The assignments to clear a through h and t1/t2 are optimized out by the
  compiler because they are unused after the assignments.

  Clearing individual scalar variables is unlikely to be useful, as they
  may have been assigned to registers, and even if stack spilling was
  required, there may be compiler-generated temporaries that are
  impossible to clear in any case.

This applies here again as well. Drop meaningless clearing of local
variables and avoid this way that the code suggests that data is erased,
which simply does not happen.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 crypto/sha512_generic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index c72d72ad828e..be70e76d6d86 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -143,9 +143,6 @@ sha512_transform(u64 *state, const u8 *input)
 
 	state[0] += a; state[1] += b; state[2] += c; state[3] += d;
 	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
-
-	/* erase our data */
-	a = b = c = d = e = f = g = h = t1 = t2 = 0;
 }
 
 static void sha512_generic_block_fn(struct sha512_state *sst, u8 const *src,
-- 
2.26.2

