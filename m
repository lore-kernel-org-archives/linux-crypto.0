From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - fix unaligned cbc decrypt for
 x86-32
Date: Thu, 31 May 2012 16:51:46 +1000
Message-ID: <20120531065146.GA17926@gondor.apana.org.au>
References: <1338334988-20025-1-git-send-email-minipli@googlemail.com>
 <20120531052754.GA17273@gondor.apana.org.au>
 <CA+rthh9-FL6gqkHfqL21Sh_gvpqS-cPMmE2MQZpk2R0o+SGjpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Daniel <garkein@mailueberfall.de>, linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:46704 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751254Ab2EaGvx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 May 2012 02:51:53 -0400
Content-Disposition: inline
In-Reply-To: <CA+rthh9-FL6gqkHfqL21Sh_gvpqS-cPMmE2MQZpk2R0o+SGjpw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 31, 2012 at 08:45:58AM +0200, Mathias Krause wrote:
>
> No, but the latter will likely be much slower as it would need to
> memmove the data if it's not aligned, right?

Most crypto users should already be providing aligned data.  After
all, padlock-aes requires 16-byte alignment and it works quite well.
 
> That said, I did some micro benchmark on "pxor (%edx), %xmm0" vs.
> "movups (%edx), %xmm1; pxor %xmm1, %xmm0" and observed the latter
> might be even slightly faster! But changing the code to perform better
> is out of scope for this patch as it should just fix the bug in the
> code. We can increase performance in a follow up patch.

OK we can do that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
