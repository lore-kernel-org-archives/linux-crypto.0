From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: atmel: use devm_xxx() managed function
Date: Wed, 14 Oct 2015 22:28:55 +0800
Message-ID: <20151014142855.GH17455@gondor.apana.org.au>
References: <1444672025-21757-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444672025-21757-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 12, 2015 at 07:47:03PM +0200, LABBE Corentin wrote:
> Using the devm_xxx() managed function to stripdown the error and remove
> code.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Both applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
