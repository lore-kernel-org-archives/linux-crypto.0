From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Thu, 22 Dec 2016 16:55:09 +0800
Message-ID: <20161222085509.GA2160@gondor.apana.org.au>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
 <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52027 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750727AbcLVI5F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 03:57:05 -0500
Content-Disposition: inline
In-Reply-To: <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 11:01:08AM +0100, Milan Broz wrote:
>
> By the move everything to cryptoAPI we are basically introducing some strange mix
> of IV and modes there, I wonder how this is going to be maintained.
> Anyway, Herbert should say if it is ok...

Well there is precedent in how do the IPsec IV generation.  In
that case the IV generators too are completely specific to that
application, i.e., IPsec.  However, the way structured it allowed
us to have one single entry path from the IPsec stack into the
crypto layer regardless of whether you are using AEAD or traditional
encryption/hashing algorithms.

For IPsec we make the IV generators behave like normal AEAD
algorithms, except that they take the sequence number as the IV.

The goal here are obviously different.  However, by employing
the same method as we do in IPsec, it appears to me that you
can effectively process multiple blocks at once instead of having
to supply one block at a time due to the IV generation issue.
 
> I really do not think the disk encryption key management should be moved
> outside of dm-crypt. We cannot then change key structure later easily.

It doesn't have to live outside of dm-crypt.  You can register
these IV generators from there if you really want.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
