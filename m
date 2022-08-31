Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1601EECAAD1
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Aug 2022 08:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiHaI5t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Aug 2022 04:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiHaI53 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2022 04:57:29 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F18CE489;
        Wed, 31 Aug 2022 01:56:51 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oTJWe-00H5xj-Sc; Wed, 31 Aug 2022 18:56:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 31 Aug 2022 16:56:44 +0800
Date:   Wed, 31 Aug 2022 16:56:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH] crypto: akcipher - default implementations for setting
 private/public keys
Message-ID: <Yw8iTNjGlsP1LpNG@gondor.apana.org.au>
References: <20220729165954.991-1-ignat@cloudflare.com>
 <Yv9dvvy0rK/1T0sU@gondor.apana.org.au>
 <CALrw=nEh7LX3DSCa3FTu8BYr4QWx+W2h3Jei9Qo67+XXH-Vegw@mail.gmail.com>
 <Yw3Rneo6Ik1QEfbG@gondor.apana.org.au>
 <CALrw=nGJgMACrFVy+FVVCDb4H3wNUN2E-GLZaXzLsm3ReOUeVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALrw=nGJgMACrFVy+FVVCDb4H3wNUN2E-GLZaXzLsm3ReOUeVg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 30, 2022 at 11:48:23AM +0100, Ignat Korchagin wrote:
>
> I vaguely remember some initial research in quantum-resistant
> signatures, which used HMAC for "signing" thus don't have any public
> keys. But it is way beyond my expertise to comment on the practicality
> and availability of such schemes.

We could always add this again should an algorithm requiring
it be introduced.

> I'm more concerned here about a buggy "third-party" RSA driver, which
> may not implement the callback and which gets prioritised by the
> framework, thus giving the ability to trigger a NULL-ptr dereference
> from userspace via keyctl(2). I think the Crypto API framework should
> be a bit more robust to handle such a case, but I also understand that
> there are a lot of "if"s in this scenario and we can say it is up to
> crypto driver not to be buggy. Therefore, consider my opinion as not
> strong and I can post a v2, which does not provide a default stub for
> set_pub_key, if you prefer.

If you're concerned with buggy algorithms/drivers, we should
ensure that the self-tests catch this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
