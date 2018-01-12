From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt - free xoutbuf instead of axbuf
Date: Fri, 12 Jan 2018 23:23:56 +1100
Message-ID: <20180112122356.GF21636@gondor.apana.org.au>
References: <20180102154304.14523-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180102154304.14523-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 02, 2018 at 03:43:04PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There seems to be a cut-n-paste bug with the name of the buffer being
> free'd, xoutbuf should be used instead of axbuf.
> 
> Detected by CoverityScan, CID#1463420 ("Copy-paste error")
> 
> Fixes: 427988d981c4 ("crypto: tcrypt - add multibuf aead speed test")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
