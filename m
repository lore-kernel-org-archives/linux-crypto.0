Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BABC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD9326334A
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhKPLnt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhKPLmg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:42:36 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8CDC061767;
        Tue, 16 Nov 2021 03:38:19 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso1679397wms.3;
        Tue, 16 Nov 2021 03:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=eHO+LnzYTLvi1ibWQBQ4VJT9l42Re/gLaBNAO09hBu0=;
        b=pu130IqB8Qy4jcg4TDLmnmcKdgryY8vLFCykVkkPJfcnk+FX8jnNgtK88l1bDHL5+W
         lhhes8rAN46j/p3Ok/L8YwIUH/K78PiaU9P5ABv+gQAfN9pr5rSoh84kTj6SYzbrycdL
         vKffhO1bYf30ZbIaqxezRU5MqfGyCC7XDMRqgf0G7elhzzoeNZm23WJpPJmyR2r9OIsV
         2QQL3OnET3qK27plJHFGEyMVRfwxvWeOpPUAfMga6eRvT9+Dls8y92ry6RhzHMsvl+vz
         1Zh/UrSN0tvDDaT7DzWilExeBYmWK0o+4BwLntgVF+SqWq0xvITEyVkv75qikIV+OJfU
         LGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eHO+LnzYTLvi1ibWQBQ4VJT9l42Re/gLaBNAO09hBu0=;
        b=c1jr6Tz51KM/PAg+yntP2Dc8MaP7LwwCPHtB+0VVr7vasxaR8/J5tNmGaRb0QTXvJh
         EN4RLmSZSaZXnGKPWWzno0HbLDN3iT8mumlRQk3mtUxsSSvCRawixewbz84f+MQfAKHH
         E+UbP7Ng5qQhHuZzWuxje2YP+f54orSfoNkycmEw001sUKYdHlkx0RJk1lnLC7Ff6QK6
         DBUh/Wa9uRoc0SmRSmY3cTv6sz9PvR1n0iZ8ZUwcaWpb5EhUog1r+9q7sKAG+43Kwy4s
         VLLLSz1nXOMXpFBJiXrxG0us2MXZQQchNMDKjd7UfcGEKsnVyWKqnkuGGKdF2dWmPJEu
         NOaw==
X-Gm-Message-State: AOAM5305BlISJ/yVE2hAPzPzpOA0ovpfhIcbypajp3bPZ9FA7+D147Cu
        BACO3vhaMpNfVDE7JPPMhMZMcviPJCP/4h2qHV35ByAY/u0=
X-Google-Smtp-Source: ABdhPJyeOJR96UJvqBee6IUrqwD26c0Xsj7Rz0iifGm1qj625vOJ1lY28aMdqEdExTkhtHnu3XsR5Oexjj5iVJnHvwI=
X-Received: by 2002:a05:600c:1f13:: with SMTP id bd19mr52327080wmb.9.1637062698315;
 Tue, 16 Nov 2021 03:38:18 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:38:06 +0800
Message-ID: <CACXcFmm=eUjfVAJGgFGPfHWCc7s37j0==eASdqJK3OBAazeyOQ@mail.gmail.com>
Subject: [PATCH 7/8] Replace memset() with memzero_explicit()
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
 crypto/sm2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/sm2.c b/crypto/sm2.c
index db8a4a265669..58641d964671 100644
--- a/crypto/sm2.c
+++ b/crypto/sm2.c
@@ -124,7 +124,7 @@ static void sm2_ec_ctx_deinit(struct mpi_ec_ctx *ec)
 {
     mpi_ec_deinit(ec);

-    memset(ec, 0, sizeof(*ec));
+    memzero_explicit(ec, sizeof(*ec));
 }

 /* RESULT must have been initialized and is set on success to the
--
