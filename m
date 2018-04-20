From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH][next] crypto: chtls: don't leak information from the
 stack to userspace
Date: Sat, 21 Apr 2018 00:51:19 +0800
Message-ID: <20180420165119.3dn67xpcyxglhi22@gondor.apana.org.au>
References: <20180405164403.4412-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Werner <werner@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Casey Leedom <leedom@chelsio.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405164403.4412-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 05, 2018 at 05:44:03PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The structure crypto_info contains fields that are not initialized and
> only .version is set.  The copy_to_user call is hence leaking information
> from the stack to userspace which must be avoided. Fix this by zero'ing
> all the unused fields.
> 
> Detected by CoverityScan, CID#1467421 ("Uninitialized scalar variable")
> 
> Fixes: a08943947873 ("crypto: chtls - Register chtls with net tls")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
