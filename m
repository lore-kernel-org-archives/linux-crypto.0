From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 10/38] hwrng: fix handling platform_get_irq
Date: Mon, 21 Sep 2015 23:05:25 +0800
Message-ID: <20150921150524.GC2703@gondor.apana.org.au>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
 <1442842450-29769-11-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Andrzej Hajda <a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442842450-29769-11-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 21, 2015 at 03:33:42PM +0200, Andrzej Hajda wrote:
> The function can return negative value.
> 
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2038576
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
