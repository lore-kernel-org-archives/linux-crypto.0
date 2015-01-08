From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-des: fix BUG_ON condition
Date: Thu, 8 Jan 2015 21:48:28 +1100
Message-ID: <20150108104827.GA8374@gondor.apana.org.au>
References: <20150105082310.GA19423@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Asaf Vertz <asaf.vertz@tandemg.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150105082310.GA19423@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 05, 2015 at 10:23:10AM +0200, Asaf Vertz wrote:
> dd->total is unsigned so it won't do any good to check for negative value after subtracting
> instead of that we should check if the subtracted value is bigger than him
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
