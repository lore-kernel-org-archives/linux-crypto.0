Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC1DC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0966336D
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhKPLnu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbhKPLn2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:43:28 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51FFC06120E;
        Tue, 16 Nov 2021 03:39:57 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a9so10733331wrr.8;
        Tue, 16 Nov 2021 03:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=0lnIW5bIuasV3MVGJulBjO6erZ6NZCFpVTL6XPkUY7g=;
        b=UTENRlvJv4CKfNdhgLfetOkofGUZ4Zvf1hW/NurNT5vUDxHNNIb/33acvpw1+D77OS
         RvrwY+3Da+G0yn/wpX2PwmfBo2Fw11YM+9pTZpZB2NuProGgpT6TKugrcGdEc5KqCvZM
         vwZGV7OG+wZjz4KAAFS/IJEIQE8bnRXLsjgD12Rjg/T/Tv4+5tQ+iq3zPs9/o4E+e8q/
         5nYBR5MlANoH56B+5qlZj/z0S69ytkHHKgHOiE26ae3ghN4rQFiT77yWuG761QL5piO1
         eMsLFG2qCR+MHRs1nd5AaLNE2C3n98hbtjeATSRPY+BCdMQI49O9ghgOKjy7lkBTyI4V
         Y+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0lnIW5bIuasV3MVGJulBjO6erZ6NZCFpVTL6XPkUY7g=;
        b=eF8AGFFV9D2JJ3F+kZg3buGiSs0YF0sUY6dwqFlp6aAbsmg4Bj0FaoG5+HZkPnkRNx
         6gyPJD7nuUBO5JE2wdiIQzR9fwXlO1ZgmLnUMIf21EYtSb7MYw79e8GlVMWOBJZ0yh+T
         dsVg7pdlsmo9V9LrSy2CcNDdpftC5eeMdPKplTOjQ4TJPdfnxNBW6zqLJW8dk6Ms7Xa2
         znr3XI7xpKx8LEYpvuxjeYDWPknmFNUvgJ5gKNoT5ergwGNe5vSVWRBCs2RnJi+lv2NJ
         +LaVRVzFwnflocIlaxBzb401H+4gNh04orqkxXFmUVl+nUax6i/pXxjvcrQxadkEM4pf
         m1xQ==
X-Gm-Message-State: AOAM530XkfLr33q6W5ZCfUsLVW5VrUHCOPvESOiW43Hoj2qIDZ0nBRW+
        fn5OM3e6k32A9MXQLKESdGN1zxPzVIi1+pnpZD0y6NaFQ4o=
X-Google-Smtp-Source: ABdhPJxdqnHy+l4gg9zlNJwBz43z7HVYBhCmcU6R3AaNMLjruGuDQXNbnm08ViAsE3fyjpx103quBwNYR6jNnV3NPwE=
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr8294124wrx.192.1637062796271;
 Tue, 16 Nov 2021 03:39:56 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:39:44 +0800
Message-ID: <CACXcFmnYNSLvjNfyvWXq4VSxoreKTC27E+hotcFz-AQ0FCDT5w@mail.gmail.com>
Subject: [PATCH 8/8] Replace memset() with memzero_explicit()
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
 crypto/rmd160.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index c5fe4034b153..a80f783d5a4f 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -329,7 +329,7 @@ static int rmd160_final(struct shash_desc *desc, u8 *out)
         dst[i] = cpu_to_le32p(&rctx->state[i]);

     /* Wipe context */
-    memset(rctx, 0, sizeof(*rctx));
+    memzero_explicit(rctx, sizeof(*rctx));

     return 0;
 }
--
