From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] chcr: ensure cntrl is initialized to fix bit-wise or'ing
 of garabage data
Date: Mon, 11 Dec 2017 22:46:45 +1100
Message-ID: <20171211114645.GK12014@gondor.apana.org.au>
References: <20171130142354.21225-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171130142354.21225-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 30, 2017 at 02:23:54PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where skb->ip_summed != CHECKSUM_PARTIAL then cntrl contains
> garbage value and this is possibly being bit-wise or'd and stored into
> cpl->ctrl1.  Fix this by initializing cntrl to zero.
> 
> Cleans up clang warning:
> drivers/crypto/chelsio/chcr_ipsec.c:374:9: warning: The left expression
> of the compound assignment is an uninitialized value. The computed value
> will also be garbage
> 
> Fixes: 6dad4e8ab3ec ("chcr: Add support for Inline IPSec")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
