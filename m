From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Fri, 22 Jun 2018 22:50:48 +0800
Message-ID: <20180622145047.dqyxwptttivaca2s@gondor.apana.org.au>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
 <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
 <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
 <6782b1c0-ea94-b07c-2fae-3fe3223bb22a@linaro.org>
 <20180622143829.rd2ys6ci7q3aupst@gondor.apana.org.au>
 <20180622144809.GP27187@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Vinod <vkoul@kernel.org>, Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180622144809.GP27187@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2018 at 08:18:09PM +0530, Vinod wrote:
>
> Okay I am doing the port taking the exynos-rng as a ref.
> Question is how to test it, how is one supposed to exercise the rng, any
> test utils/apps for that? Sorry for noob question, new to crypto
> interfaces.

algif_rng is available through the af_alg socket interface.

Ccing Stephan as he has a library that may help you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
