From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 1/1] crypto: engine - Permit to enqueue skcipher
 request
Date: Fri, 22 Sep 2017 17:10:16 +0800
Message-ID: <20170922091016.GB15677@gondor.apana.org.au>
References: <20170818114227.15739-1-clabbe.montjoie@gmail.com>
 <20170818114227.15739-2-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38520 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdIVJKe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 05:10:34 -0400
Content-Disposition: inline
In-Reply-To: <20170818114227.15739-2-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 18, 2017 at 01:42:27PM +0200, Corentin Labbe wrote:
> The crypto engine could actually only enqueue hash and ablkcipher request.
> This patch permit it to enqueue skcipher requests by adding all necessary
> functions.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Hmm, you have not addressed my suggestion in

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1474434.html

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
