From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hifn_795x, picoxcell - use
 ablkcipher_request_cast
Date: Tue, 29 Dec 2015 21:35:10 +0800
Message-ID: <20151229133510.GA5307@gondor.apana.org.au>
References: <9b6f300df7ffd4c5d65253fdbbb2d1a1cba04835.1451310459.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Jamie Iles <jamie@jamieiles.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Geliang Tang <geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9b6f300df7ffd4c5d65253fdbbb2d1a1cba04835.1451310459.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 28, 2015 at 09:53:07PM +0800, Geliang Tang wrote:
> Use ablkcipher_request_cast() instead of open-coding it.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
