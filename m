From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: engine: permit to enqueue ashash_request
Date: Thu, 2 Jun 2016 17:42:54 +0800
Message-ID: <20160602094254.GB16489@gondor.apana.org.au>
References: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
 <20160602083258.GB15226@gondor.apana.org.au>
 <20160602091213.GA2521@Red>
 <20160602091940.GB16160@gondor.apana.org.au>
 <20160602093835.GB2521@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602093835.GB2521@Red>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 02, 2016 at 11:38:35AM +0200, LABBE Corentin wrote:
>
> Since my patch is small and easy (and only one client is modified), do you mind if I choose the first one ?

Sure.

> I will add this type checking on my patch against omap-aes/des.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
