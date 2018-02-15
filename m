From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chelsio - Make function aead_ccm_validate_input
 static
Date: Thu, 15 Feb 2018 23:52:25 +0800
Message-ID: <20180215155225.GN7352@gondor.apana.org.au>
References: <20180206230920.13764-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206230920.13764-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 06, 2018 at 11:09:20PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Function aead_ccm_validate_input is local to the source and does not
> need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> drivers/crypto/chelsio/chcr_algo.c:2627:5: warning: symbol
> 'aead_ccm_validate_input' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
