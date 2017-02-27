From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium: fix leak on curr if curr->head fails to
 be allocated
Date: Mon, 27 Feb 2017 18:37:40 +0800
Message-ID: <20170227103740.GB31739@gondor.apana.org.au>
References: <20170217155743.31525-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Cherian <george.cherian@cavium.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170217155743.31525-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 17, 2017 at 03:57:43PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The exit path when curr->head cannot be allocated fails to kfree the
> earlier allocated curr.  Fix this by kfree'ing it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
