From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: Improve description of the ->read() interface
Date: Wed, 24 Aug 2016 21:13:24 +0800
Message-ID: <20160824131324.GB3850@gondor.apana.org.au>
References: <1471523841-30469-1-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471523841-30469-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 18, 2016 at 01:37:21PM +0100, Daniel Thompson wrote:
> Currently, very few RNG drivers support single byte reads using the
> ->read() interface. Of the 14 drivers in drivers/char/hw_random that
> support this interface only three of these actually support max == 1.
> The other behaviours vary between return 0, return 2, return 4 and return
> -EIO).
> 
> This is not a problem in practice because the core hw_random code never
> performs a read shorter than 16 bytes. The documentation for this function
> already contrains the alignment of the buffer pointer, so let's also
> guarantee that the buffer is at least as large as its alignment.
> 
> This constraint is intended to be the weakest guarantee neccessary to
> allow driver writers to safely simplify their code.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
