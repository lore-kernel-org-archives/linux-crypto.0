Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9EEC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B6C61360
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbhKPLfv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhKPLdt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:33:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBC4C061766;
        Tue, 16 Nov 2021 03:30:52 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d5so36908926wrc.1;
        Tue, 16 Nov 2021 03:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=3vMY7wpgxEOPnmcVhZUPHgtnZuCn2Fi54kwyxPuSgk8=;
        b=kzFtBPZjmp0qawjCbfxG0hnHk7KOrRP6WQUQX5LTYV2SFnL6XudBi5VXQpJjg+H3cR
         VMDzyBvvzhcucCY5qTArAiyUOaVmww1jULjbJWYqhmgIuofuniWBVQrzDPa/nhbfmaHb
         uNhsjT3Jh090Pe7+ISUlSpA8Kwsj5/+egeesATH6wHGnqCBSWME+Hn8AyRSTnBsdaizJ
         XbmIEoLvOkDjDcTp/EhIzMXUIuLR7o78amgM7h+/6Oq6ZjkPTnTqL0fGzFC4iUS79453
         jLM6Lok1davECP+gqPQd0oZObZPLZMz2lXmrZaUmkCytScvgk5d3d+ovz+KXTN0Py1vc
         Z8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3vMY7wpgxEOPnmcVhZUPHgtnZuCn2Fi54kwyxPuSgk8=;
        b=sh2tJsScShaqrOJzLMig94XqVK5Y6ZgdJUGRwWww0d3Dq7fZz59bDJqgckU+0hfiNJ
         odulci9s5eNHIgJkch51idhDKVtz+hO0xlEEb6LRU1VwLGdQM/cSE4O4POioV9vxr7VJ
         B4vEibUeO2H53uB1w3i86PQGO/T8EVem7Q1lx+Dl343cG4tRRCAPujrobO7tqespBG7R
         nUdvJZfenUrqTRngx6fATAPbOApt3pYhElmmiYmtY70RrQvItO4Ur7oxwkGdIiyN/UkD
         cSElOcyhy+kDwshDtDgSHeIl5HxVmIieZiGhgpj8yF73CEyZT3O1TIayFwYk4d/BRqyN
         Be/A==
X-Gm-Message-State: AOAM530AJfXypxL5j/2zaje/AAyuxo6MAbEybp+agS6lj+MVeYaDJK54
        kx3YpbrIgAzdOhKFUXXcJt+zeMYGPxyx6hUEkw+igxb5LhU=
X-Google-Smtp-Source: ABdhPJzzFCih2BQmHE18MCNDHQ736Sv16LAswewqmtT6w64I5zRTmsiO6WN0ZLPpnX5P8nlDxIj6cB0AOBnu6Oq3hs4=
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr8225993wrx.192.1637062250915;
 Tue, 16 Nov 2021 03:30:50 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:30:39 +0800
Message-ID: <CACXcFmnGYb_7Priu+JF3p2mKgB=5aua7VpMnpxENjfssg2bL_g@mail.gmail.com>
Subject: [PATCH 3/8] Replace memset() with memzero_explicit()
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace memset(address,0,bytes) which may be optimised
away with memzero_explicit(address,bytes) which resists
such optimisation

---
 crypto/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index cd4f32092e5c..ff7dc65b3b41 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -25,7 +25,7 @@ static void dh_clear_ctx(struct dh_ctx *ctx)
     mpi_free(ctx->q);
     mpi_free(ctx->g);
     mpi_free(ctx->xa);
-    memset(ctx, 0, sizeof(*ctx));
+    memzero_explicit(ctx, sizeof(*ctx));
 }

 /*
-- 
2.25.1
