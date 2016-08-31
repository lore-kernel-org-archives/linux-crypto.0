From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: hide unused label
Date: Wed, 31 Aug 2016 22:37:52 +0800
Message-ID: <20160831143752.GA26616@gondor.apana.org.au>
References: <20160829124050.3405624-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160829124050.3405624-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 29, 2016 at 02:40:43PM +0200, Arnd Bergmann wrote:
> A recent change left an existing label unused in some configurations,
> as seen from a gcc warning:
> 
> crypto/xor.c: In function 'calibrate_xor_blocks':
> crypto/xor.c:156:1: error: label 'out' defined but not used [-Werror=unused-label]
> 
> This adds an #ifdef around it to match the one around the respective "goto".
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 39457acda913 ("crypto: xor - skip speed test if the xor function is selected automatically")

Thanks for the patch.  But I've already queued up a fix at

https://patchwork.kernel.org/patch/9301603/
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
