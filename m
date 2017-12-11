From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix typo in KPP dependency of CRYPTO_ECDH
Date: Mon, 11 Dec 2017 22:43:48 +1100
Message-ID: <20171211114348.GA12014@gondor.apana.org.au>
References: <20171125231646.19042-1-hauke@hauke-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        salvatore.benedetto@intel.com, "# v4 . 8+" <stable@vger.kernel.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43886 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbdLKLos (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:44:48 -0500
Content-Disposition: inline
In-Reply-To: <20171125231646.19042-1-hauke@hauke-m.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 26, 2017 at 12:16:46AM +0100, Hauke Mehrtens wrote:
> This fixes a typo in the CRYPTO_KPP dependency of CRYPTO_ECDH.
> 
> Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
