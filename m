From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] padata: free correct variable
Date: Mon, 10 Apr 2017 19:25:53 +0800
Message-ID: <20170410112553.GA9016@gondor.apana.org.au>
References: <20170407003330.6552-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org, Jason@zx2c4.com,
        stable@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170407003330.6552-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> The author meant to free the variable that was just allocated, instead
> of the one that failed to be allocated, but made a simple typo. This
> patch rectifies that.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: stable@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
