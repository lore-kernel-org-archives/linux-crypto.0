From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND] crypto: sun4i-ss: Replace spinlock_bh by
 spin_lock_irq{save|restore}
Date: Tue, 5 Apr 2016 20:49:43 +0800
Message-ID: <20160405124943.GN13048@gondor.apana.org.au>
References: <1458745884-27798-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
	wens@csie.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable <stable@vger.kernel.org>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458745884-27798-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 23, 2016 at 04:11:24PM +0100, LABBE Corentin wrote:
> The current sun4i-ss driver could generate data corruption when ciphering/deciphering.
> It occurs randomly on end of handled data.
> No root cause have been found and the only way to remove it is to replace
> all spin_lock_bh by their irq counterparts.
> 
> Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> Cc: stable <stable@vger.kernel.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
