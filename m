From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/6] crypto: tcrypt: add multibuf aead speed test
Date: Wed, 13 Dec 2017 23:31:13 +1100
Message-ID: <20171213123113.GA1738@gondor.apana.org.au>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
 <1512036574-26665-7-git-send-email-gilad@benyossef.com>
 <20171211113533.GA11625@gondor.apana.org.au>
 <CAOtvUMf4jMWw46D9=jGhh3apoiWwS-3Nev5A=A=Lh3qByPwXBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:44428 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbdLMMb4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Dec 2017 07:31:56 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMf4jMWw46D9=jGhh3apoiWwS-3Nev5A=A=Lh3qByPwXBg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 13, 2017 at 11:12:10AM +0200, Gilad Ben-Yossef wrote:
> 
> I'm sorry if I'm confused but as the cover letter stated, the patch
> set is supposed to
> go on top of the patch entitled  "crypto: tcrypt - fix S/G table for
> test_aead_speed()"
> which you stated will be applied
> (https://patchwork.kernel.org/patch/9995727/) but
> is not in the tree yet.

It is in cryptodev as

commit 5c6ac1d4f8fbdbed65dbeb8cf149d736409d16a1
Author: Robert Baronescu <robert.baronescu@nxp.com>
Date:   Tue Oct 10 13:21:59 2017 +0300

    crypto: tcrypt - fix S/G table for test_aead_speed()

Yet your patch still fails to apply.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
