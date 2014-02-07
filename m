From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] support for interleaving in generic chaining
 modes
Date: Fri, 7 Feb 2014 17:53:41 +0800
Message-ID: <20140207095341.GA3120@gondor.apana.org.au>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140207022335.GA27694@gondor.apana.org.au>
 <CAKv+Gu-4J6jO135QgNrLrEX96U7aS7k4BE82j9ZLzwe60HfTTQ@mail.gmail.com>
 <20140207092304.GA2573@gondor.apana.org.au>
 <CAKv+Gu_kQFA26Ntc1p1yNRpxfJd8xgk27OnS7LG4V5qzH5NBjg@mail.gmail.com>
 <20140207094406.GA3012@gondor.apana.org.au>
 <CAKv+Gu_uZRYqhi_8ReKabBGJxtKQSR4X4DJBse4muDOMMMf8Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55128 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaBGJxn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 04:53:43 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_uZRYqhi_8ReKabBGJxtKQSR4X4DJBse4muDOMMMf8Ww@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 07, 2014 at 10:51:08AM +0100, Ard Biesheuvel wrote:
> 
> So i get your point: I will have a go at passing the entire buffer to
> ecb(%s), and then wrapping the chaining mode around that.
> I guess you don't think the (avoidable) additional memory usage is a concern?

You mean the temporary buffer for the in-place case? It's a hard
problem and this will more likely determine how much you can pass
to ecb than anything else.  If you find a good solution we could
make use of it in other places, e.g., ctr on s390.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
