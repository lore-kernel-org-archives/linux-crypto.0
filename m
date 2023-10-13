Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10E0CDB482
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Oct 2023 10:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjJMKVQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Oct 2023 06:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjJMKVO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2023 06:21:14 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9631DB7;
        Fri, 13 Oct 2023 03:21:12 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qrFI1-006j3w-Po; Fri, 13 Oct 2023 18:21:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Oct 2023 18:21:10 +0800
Date:   Fri, 13 Oct 2023 18:21:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ingyu Jang <ingyujang25@unist.ac.kr>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ysjeon@unist.ac.kr,
        ingyujang25@unist.ac.kr
Subject: Re: [PATCH] crypto: authencesn - Fix incorrect setauthsize function
Message-ID: <ZSkaFmV4tfxjV3Kt@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013095523.184497-1-ingyujang25@unist.ac.kr>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ingyu Jang <ingyujang25@unist.ac.kr> wrote:
>
> diff --git a/crypto/authencesn.c b/crypto/authencesn.c
> index 91424e791d5c..c1346d5b7950 100644
> --- a/crypto/authencesn.c
> +++ b/crypto/authencesn.c
> @@ -52,6 +52,8 @@ static int crypto_authenc_esn_setauthsize(struct crypto_aead *authenc_esn,
>        if (authsize > 0 && authsize < 4)
>                return -EINVAL;
> 
> +       authenc_esn->authsize = authsize;
> +

The premise of this patch is incorrect.  Please check the code for
setauthsize in crypto/aead.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
