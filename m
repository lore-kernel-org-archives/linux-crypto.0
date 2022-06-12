Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA04DCCA47C
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jun 2022 06:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiFLG5o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jun 2022 02:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbiFLG5o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jun 2022 02:57:44 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C3166AD2;
        Sat, 11 Jun 2022 23:57:41 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o0HXK-005qwQ-1k; Sun, 12 Jun 2022 16:57:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Jun 2022 14:57:26 +0800
Date:   Sun, 12 Jun 2022 14:57:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jason Self <jason@bluehome.net>, stable@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <YqWOVp2P8Qp/9/Ek@gondor.apana.org.au>
References: <20220609162943.6e3bba4f@valencia>
 <YqLTecx7MGFPOvhw@kroah.com>
 <20220610182523.2f5620a2@valencia>
 <20220610184255.20ecde41@valencia>
 <YqQHZB6/u4nrFzIm@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqQHZB6/u4nrFzIm@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 10, 2022 at 08:09:24PM -0700, Eric Biggers wrote:
>
> It looks like "crypto: memneq - move into lib/" is going to fix this
> (https://lore.kernel.org/linux-crypto/20220528102429.189731-1-Jason@zx2c4.com).
> At the moment it's queued in cryptodev/master.  Herbert, are you planning to
> send it upstream soon?

OK I have added it to the crypto tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
