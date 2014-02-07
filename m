From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] support for interleaving in generic chaining
 modes
Date: Fri, 7 Feb 2014 17:44:06 +0800
Message-ID: <20140207094406.GA3012@gondor.apana.org.au>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140207022335.GA27694@gondor.apana.org.au>
 <CAKv+Gu-4J6jO135QgNrLrEX96U7aS7k4BE82j9ZLzwe60HfTTQ@mail.gmail.com>
 <20140207092304.GA2573@gondor.apana.org.au>
 <CAKv+Gu_kQFA26Ntc1p1yNRpxfJd8xgk27OnS7LG4V5qzH5NBjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34045 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBGJoS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 04:44:18 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_kQFA26Ntc1p1yNRpxfJd8xgk27OnS7LG4V5qzH5NBjg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 07, 2014 at 10:42:14AM +0100, Ard Biesheuvel wrote:
>
> Another example is bit sliced AES like the implementation in
> arch/arm/crypto. It is 45% faster than the ordinary ARM asm
> implementation, but its natural chunk size is 8 blocks. Passing fewer
> blocks hurts performance, while passing more blocks does not give any
> additional benefit at all.
> 
> So in many cases, it would be good to know the preferred chunk size of
> an algorithm.

So are there cases where passing more blocks hurt the performance
or not?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
