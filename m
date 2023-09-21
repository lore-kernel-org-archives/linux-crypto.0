Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CEBE7D0A3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Sep 2023 17:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjIURwe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjIURwX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2023 13:52:23 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89306133
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2023 10:27:16 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qjBMM-00GbZs-Il; Thu, 21 Sep 2023 12:32:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Sep 2023 12:32:17 +0800
Date:   Thu, 21 Sep 2023 12:32:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/8] crypto: skcipher - Add lskcipher
Message-ID: <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920062551.GB2739@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 19, 2023 at 11:25:51PM -0700, Eric Biggers wrote:
>
> Is lskcipher only for algorithms that can be computed incrementally?  That would
> exclude the wide-block modes, and maybe others too.  And if so, what is the

You mean things like adiantum? We could add a flag for that so
the skcipher wrapper linearises the input before calling lskcipher.

> model for incremental computation?  Based on crypto_lskcipher_crypt_sg(), all
> the state is assumed to be carried forward in the "IV".  Does that work for all
> algorithms?  Note that shash has an arbitrary state struct (shash_desc) instead.

Is there any practical difference? You could always represent
one as the other, no?

The only case where it would matter is if an algorithm had both
an IV as well as additional state that should not be passed along
as part of the IV, do you have anything in mind?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
