From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cryptd: make cryptd_max_cpu_qlen module
 parameter static
Date: Mon, 11 Dec 2017 22:46:03 +1100
Message-ID: <20171211114603.GG12014@gondor.apana.org.au>
References: <20171130112614.3090-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171130112614.3090-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 30, 2017 at 11:26:14AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The cryptd_max_cpu_qlen module parameter is local to the source and does
> not need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> crypto/cryptd.c:35:14: warning: symbol 'cryptd_max_cpu_qlen' was not
> declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
