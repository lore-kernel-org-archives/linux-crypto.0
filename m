From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes - use offset_in_page macro
Date: Tue, 24 Nov 2015 18:24:10 +0800
Message-ID: <20151124102410.GB363@gondor.apana.org.au>
References: <19b0bc324e0d893c4b516f3873b6dcbcff0da6ea.1448115766.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19b0bc324e0d893c4b516f3873b6dcbcff0da6ea.1448115766.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 21, 2015 at 10:24:11PM +0800, Geliang Tang wrote:
> Use offset_in_page macro instead of (addr & ~PAGE_MASK).
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
