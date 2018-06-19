From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] hwrng: msm - Add support for prng v2
Date: Tue, 19 Jun 2018 22:30:32 +0800
Message-ID: <20180619143032.4qov5jrbhbsbp6dv@gondor.apana.org.au>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <20180619095430.26358-3-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Vinod Koul <vkoul@kernel.org>
To: Vinod Koul <vinod.koul@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619095430.26358-3-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 19, 2018 at 03:24:30PM +0530, Vinod Koul wrote:
> Qcom 8996 and later chips support prng v2 which requires to
> implement only .read callback for hwrng.
> 
> This version of chip has multiple Execution Environments (EE) and
> secure world is typically responsible for configuring the prng.
> 
> Add driver data for qcom,prng as 0 and qcom,prng-v2 as 1 and use
> that to skip initialization and cleanup routines.
> 
> Signed-off-by: Vinod Koul <vkoul@kernel.org>

Is this a pseudo RNG?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
