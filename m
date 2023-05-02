Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283A8C77B73
	for <linux-crypto@archiver.kernel.org>; Tue,  2 May 2023 10:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjEBK3K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 May 2023 06:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbjEBK2U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 May 2023 06:28:20 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF37659DC
        for <linux-crypto@vger.kernel.org>; Tue,  2 May 2023 03:26:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ptnDc-004Hv7-3z; Tue, 02 May 2023 18:26:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 02 May 2023 18:26:49 +0800
Date:   Tue, 2 May 2023 18:26:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: api - Fix CRYPTO_USER checks for report function
Message-ID: <ZFDlab+L4GMNEmIn@gondor.apana.org.au>
References: <20230502080233.2964058-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502080233.2964058-1-omosnace@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 02, 2023 at 10:02:33AM +0200, Ondrej Mosnacek wrote:
> Checking the config via ifdef incorrectly compiles out the report
> functions when CRYPTO_USER is set to =m. Fix it by using IS_ENABLED()
> instead.
> 
> Fixes: c0f9e01dd266 ("crypto: api - Check CRYPTO_USER instead of NET for report")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  crypto/acompress.c | 2 +-
>  crypto/aead.c      | 2 +-
>  crypto/ahash.c     | 2 +-
>  crypto/akcipher.c  | 2 +-
>  crypto/kpp.c       | 2 +-
>  crypto/rng.c       | 2 +-
>  crypto/scompress.c | 2 +-
>  crypto/shash.c     | 2 +-
>  crypto/skcipher.c  | 2 +-
>  9 files changed, 9 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
