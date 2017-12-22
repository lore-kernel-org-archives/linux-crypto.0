From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: artpec6: set correct iv size for gcm(aes)
Date: Fri, 22 Dec 2017 20:09:32 +1100
Message-ID: <20171222090932.GA32660@gondor.apana.org.au>
References: <20171212114022.11327-1-larper@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org,
        larper@axis.com
To: Lars Persson <lars.persson@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46456 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965671AbdLVJJg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 04:09:36 -0500
Content-Disposition: inline
In-Reply-To: <20171212114022.11327-1-larper@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lars Persson <lars.persson@axis.com> wrote:
> The IV size should not include the 32 bit counter. Because we had the
> IV size set as 16 the transform only worked when the IV input was zero
> padded.
> 
> Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
> Signed-off-by: Lars Persson <larper@axis.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
