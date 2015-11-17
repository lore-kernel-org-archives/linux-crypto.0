From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/7] crypto: marvell: check return value of
 sg_nents_for_len
Date: Tue, 17 Nov 2015 22:09:05 +0800
Message-ID: <20151117140905.GG9546@gondor.apana.org.au>
References: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arno@natisbad.org, boris.brezillon@free-electrons.com,
	davem@davemloft.net, thomas.petazzoni@free-electrons.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 04, 2015 at 09:13:33PM +0100, LABBE Corentin wrote:
> The sg_nents_for_len() function could fail, this patch add a check for
> its return value.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
