From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] crypto: hifn_795x: remove the hifn_test function
Date: Tue, 17 Nov 2015 22:07:11 +0800
Message-ID: <20151117140711.GC9546@gondor.apana.org.au>
References: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
 <1445496712-5654-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445496712-5654-2-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 22, 2015 at 08:51:50AM +0200, LABBE Corentin wrote:
> The hifn_test function is redundant with test done at register time by
> the crypto API, so remove it.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Patches 2-4 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
