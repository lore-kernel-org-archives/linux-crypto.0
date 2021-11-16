Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5E9C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCC860F9B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbhKPLli (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhKPLkr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:40:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980E2C061229;
        Tue, 16 Nov 2021 03:36:40 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso2127069wme.3;
        Tue, 16 Nov 2021 03:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=LTEOIY/eUybXZeS3eIxrCfmEcoic7/sGgtFEUDGaJhE=;
        b=TX706o8lUSRxnx83yKZ6yV71gIapSpXePBuPaeHWnam0Id4igbdcZPmccfGZfhpZ0C
         CccmK8bLuDsGAxlXHkRNFn12LSwgEBR4ei9IB42HhhNl6Etrm0gm/EcaEiZrU4oREu5F
         Fi7WVt8/7c64zE2QwZKIKrWjTH098pWekxFwWEI2G1LJPFOT/oADK11W/XWFAEAXBewH
         lLplvb0H0c12nWMR2V5xGSmP+6yGY4CegPi4OU9tJdAnFWb1Gcn9xEkAo5QUnKm0fatw
         OXOyKCzOUuLkyoZVCfdqWzvGVsfqAHOkryQVcWJEIv0yUeDMeIfCZ+Tt3VLz9jhV5Rma
         FJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LTEOIY/eUybXZeS3eIxrCfmEcoic7/sGgtFEUDGaJhE=;
        b=fevG8kj0mwFoofG1LkEW17aDJg9mWL9E1kpl26rjUF7pIyXXDMHo1d8Y/DSsKI3dxj
         fJlK5ujRVOGSFlujlNqf4I8sb+4D+sZrHxvHb60NFnqrce4DpWvYpOwLvqME9VelDnfW
         sgIJDuin+Odad46Qtk0GxKfYlOZzSlyRLO21I56mVKxY3CvjaGbPU2/QZBNICI/XuVf+
         691Ec7Xejlln6hPqLbe1Ueky+3kDG8SJxkzb+b1AExBL+MtRVK5Fzd/t5g4mKnfpyf9N
         9xdB2t+3P54Pl58Zy9H1qFVDlNpE+obdn1L4vNOtsh8OU6s1XVi0qyCiq03x/mTXrivP
         y2ew==
X-Gm-Message-State: AOAM531gkEhn5IwbZtfwsezaClfSq8WH88ZjQQ+oRyLbo+fUHiQ1wapH
        Wl1z63zT+JMVS0M/REQwABIPzWuqTO6Sj3NOiGxFSueLz48=
X-Google-Smtp-Source: ABdhPJzWaXUihz1qRzdj5NZSXo8+WJKVajZuoybvlc540cny3ejqfzkPDvfcpA1jdVeu2+/PHrIjDB+HgptCkgqd//4=
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr67667259wmm.5.1637062599013;
 Tue, 16 Nov 2021 03:36:39 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:36:27 +0800
Message-ID: <CACXcFm=02=y=+0m3h_q4X1Jtf--7Ou=tmvVMKjEC46tFGj=V4A@mail.gmail.com>
Subject: [PATCH 6/8] Replace memset() with memzero_explicit()
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
 crypto/sha3_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 3e4069935b53..cfc10dd62e02 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -232,7 +232,7 @@ int crypto_sha3_final(struct shash_desc *desc, u8 *out)
     if (digest_size & 4)
         put_unaligned_le32(sctx->st[i], (__le32 *)digest);

-    memset(sctx, 0, sizeof(*sctx));
+    memzero_explicit(sctx, sizeof(*sctx));
     return 0;
 }
 EXPORT_SYMBOL(crypto_sha3_final);
-- 
2.25.1
