From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chelsio: make arrays sgl_ent_len and
 dsgl_ent_len static
Date: Mon, 11 Dec 2017 22:46:14 +1100
Message-ID: <20171211114614.GH12014@gondor.apana.org.au>
References: <20171130113208.3381-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "avid S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171130113208.3381-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 30, 2017 at 11:32:08AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The arrays sgl_ent_len and dsgl_ent_len are local to the source and do
> not need to be in global scope, so make them static. Also re-format the
> declarations to match the following round_constant array declaration
> style.
> 
> Cleans up sparse warnings:
> drivers/crypto/chelsio/chcr_algo.c:76:14: warning: symbol 'sgl_ent_len'
> was not declared. Should it be static?
> drivers/crypto/chelsio/chcr_algo.c:81:14: warning: symbol 'dsgl_ent_len'
> was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
