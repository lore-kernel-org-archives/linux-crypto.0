Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05491C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C3761AA3
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbhKPLjI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbhKPLiG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:38:06 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4ECC061764;
        Tue, 16 Nov 2021 03:32:59 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a9so10695411wrr.8;
        Tue, 16 Nov 2021 03:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=MwLBy7MN9rjOVXhuT6sJXkWqGYnANC26XLE5d8TIP2Q=;
        b=D00XmI5yrQrfUGaeKyMzsfY8RNjjMt8lkKZ+ONpTApw9XlyRxU9RYC744+12rvK8Ks
         6JxSFOiWlDSVI3eAFxm8K8caAqtBXetSwMPf3OTWgNNTcGceTAsNkYHcbShp0xv9H6NC
         gk0W+dWgc5BHF3Qb9XdTNaBjIZx45C2SHpbtmZeEa7HxC0NeoZGHwfY898jNio8jRi4S
         NuTyLVkhtj9HtFxKAwUbwZD1PhYhS9jv06Rwqx27sIW1k2EvSBbuiWKSU/hHo6vp+6TP
         0L8zxyx07NO5i6lisAJa56j4yI4kkfMCV2IAiy+ya8DiBvv8gtnMMwRkahQJTbSf+yX/
         R9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MwLBy7MN9rjOVXhuT6sJXkWqGYnANC26XLE5d8TIP2Q=;
        b=RTLkZr6ppz6DO84YoteKaazpujfaBG2HYU0tgBZpr166R27R5R/AzngYtREthGVos2
         E0si9qDRKxVHTY/OYoAjd1PJdYXqyehY4TEDnuP+cX7CT9wtdsYscBtXDxkGzrrVCIee
         FWxvSqgVBhebgm/Op/T8VaPGjikz71F6VK0DQPKZZyogmnis9SODRGIBe2oyv/iA097i
         +dtGMiblr+3QMsjHTsed3M9Eo+xEiozX/fp8HvjVD2BMIYwDS6ftzpqFuzXgomkz5sMQ
         6qr0qVYpzWor7+ee5cDYfRuWIgx4O5cwyIOyq8NNUuwwPEq29k5NCI6dv82ODGwmAXWo
         CnAA==
X-Gm-Message-State: AOAM532gvKuIeiGtSOkpi7+DXPEOKicxCnMJgQGsw74eQo7vX2S4coKa
        qdUv436aOqu8lLa39PU4356DAZj2YIov2dteUhn720VHEdw=
X-Google-Smtp-Source: ABdhPJwCX3Ef/IG/ZRI/s+QbwYsKKUuA0ClGBt/EsUwqNcFVFeMBhoF37aWTvxiJRh58gue/QXMXnQ+Ho0FldLcxgGU=
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr7799584wri.355.1637062377685;
 Tue, 16 Nov 2021 03:32:57 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:32:46 +0800
Message-ID: <CACXcFmmyTXg77Dq1cR+MGCP=DRvcEzM=pCPcKL5u6-O+xofR1Q@mail.gmail.com>
Subject: [PATCH 4/8] Replace memset() with memzero_explicit()
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
 crypto/echainiv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 69686668625e..6a7321da2fc1 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -64,7 +64,7 @@ static int echainiv_encrypt(struct aead_request *req)

     memcpy(&nseqno, info + ivsize - 8, 8);
     seqno = be64_to_cpu(nseqno);
-    memset(info, 0, ivsize);
+    memzero_explicit(info, ivsize);

     scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);

--
