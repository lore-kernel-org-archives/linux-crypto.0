From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/6] crypto: tcrypt: add multibuf aead speed test
Date: Mon, 11 Dec 2017 22:35:33 +1100
Message-ID: <20171211113533.GA11625@gondor.apana.org.au>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
 <1512036574-26665-7-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43866 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdLKLgL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:36:11 -0500
Content-Disposition: inline
In-Reply-To: <1512036574-26665-7-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 30, 2017 at 10:09:32AM +0000, Gilad Ben-Yossef wrote:
> The performance of some aead tfm providers is affected by
> the amount of parallelism possible with the processing.
> 
> Introduce an async aead concurrent multiple buffer
> processing speed test to be able to test performance of such
> tfm providers.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Sorry, this no longer applies to the current cryptodev tree.

Please respin.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
