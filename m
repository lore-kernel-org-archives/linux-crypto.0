From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/6] crypto: tcrypt: fix and add multi buf speed tests
Date: Thu, 28 Dec 2017 18:02:06 +1100
Message-ID: <20171228070206.GA9639@gondor.apana.org.au>
References: <1513499346-9047-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48968 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbdL1HCX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Dec 2017 02:02:23 -0500
Content-Disposition: inline
In-Reply-To: <1513499346-9047-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 17, 2017 at 08:28:59AM +0000, Gilad Ben-Yossef wrote:
> The performance of some crypto tfm providers is affected by
> the amount of parallelism possible with the processing.
> 
> We already had some support for speed test of multiple concurrent
> requests, dubbed multi buffer, in ahash speed tests.
>                                                                                 
> This patch set extends said support and add similar support for skcipher
> and AEAD, as well as fixes some odd bugs discovered along the way.
>                                                                                 
> It is noted that it is possible to consolidate some of the none multi
> buffer speed test code better, but given that tcrypt as a whole is a
> developer testing harness rather than production code, the value of
> this activity seems questionable. Do let me know if you disagree.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
