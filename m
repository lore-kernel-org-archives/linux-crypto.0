From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH][next] crypto: chtls: remove redundant assignment to
 cdev->ports
Date: Sat, 21 Apr 2018 00:51:27 +0800
Message-ID: <20180420165127.5lpk4covlw2zkzdn@gondor.apana.org.au>
References: <20180406165847.29310-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Michael Werner <werner@chelsio.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180406165847.29310-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 06, 2018 at 05:58:47PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a double assignment to cdev->ports, the first is redundant
> as it is over-written so remove it.
> 
> Detected by CoverityScan, CID#1467432 ("Unused value")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
