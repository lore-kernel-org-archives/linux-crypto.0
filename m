From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/testmgr.c: fix sizeof() on COMP_BUF_SIZE
Date: Fri, 12 Oct 2018 14:23:10 +0800
Message-ID: <20181012062310.4z2porvtpib5imfn@gondor.apana.org.au>
References: <20181007115810.27779-1-michael@schupikov.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Schupikov <michael@schupikov.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181007115810.27779-1-michael@schupikov.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 07, 2018 at 01:58:10PM +0200, Michael Schupikov wrote:
> After allocation, output and decomp_output both point to memory chunks of
> size COMP_BUF_SIZE. Then, only the first bytes are zeroed out using
> sizeof(COMP_BUF_SIZE) as parameter to memset(), because
> sizeof(COMP_BUF_SIZE) provides the size of the constant and not the size of
> allocated memory.
> 
> Instead, the whole allocated memory is meant to be zeroed out. Use
> COMP_BUF_SIZE as parameter to memset() directly in order to accomplish
> this.
> 
> Fixes: 336073840a872 ("crypto: testmgr - Allow different compression results")
> 
> Signed-off-by: Michael Schupikov <michael@schupikov.de>
> ---
>  crypto/testmgr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
