From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: ccree: fixes and cleanups
Date: Fri, 3 Aug 2018 21:59:39 +0800
Message-ID: <20180803135939.5ccgaifj4kbkfv3n@gondor.apana.org.au>
References: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 24, 2018 at 03:12:42PM +0100, Gilad Ben-Yossef wrote:
> Various code clean ups and fix ups.
> 
> Gilad Ben-Yossef (4):
>   crypto: ccree: drop useless type flag during reg
>   crypto: ccree: remove cipher ivgen left overs
>   crypto: ccree: zero all of request ctx before use
>   crypto: ccree: allow bigger than sector XTS op
> 
>  drivers/crypto/ccree/cc_aead.c       | 16 +---------------
>  drivers/crypto/ccree/cc_buffer_mgr.c |  8 ++------
>  drivers/crypto/ccree/cc_cipher.c     | 36 ++++--------------------------------
>  drivers/crypto/ccree/cc_cipher.h     |  1 -
>  drivers/crypto/ccree/cc_driver.h     |  1 -
>  5 files changed, 7 insertions(+), 55 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
