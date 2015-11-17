From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: hifn_795x: replace simple_strtoul by
 kstrtouint
Date: Tue, 17 Nov 2015 18:04:18 +0800
Message-ID: <20151117100418.GA8032@gondor.apana.org.au>
References: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 22, 2015 at 08:51:49AM +0200, LABBE Corentin wrote:
> The simple_strtoul function is marked as obsolete.
> This patch replace it by kstrtouint at the cost of changing some function
> return type from void to int.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

If you're going to clean this up then please take one more step and
store the result of req in hifn_init so that you don't have to parse
it over and over agin.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
