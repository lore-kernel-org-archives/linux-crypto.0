From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 3/6] crypto: Add Qcom prng driver
Date: Wed, 04 Jul 2018 18:02:03 +0200
Message-ID: <19909549.EUeuX9KOs7@tauon.chronox.de>
References: <20180703060434.19293-1-vkoul@kernel.org> <20180703060434.19293-4-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Vinod Koul <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703060434.19293-4-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 3. Juli 2018, 08:04:31 CEST schrieb Vinod Koul:

Hi Vinod,

> +static int qcom_rng_seed(struct crypto_rng *tfm, const u8 *seed,
> +			 unsigned int slen)
> +{
> +	return 0;
> +}

One more question: is it not possible to mix in data into the DRNG? I thought 
it would be possible with the Qualcomm DRBG.

Note, I am asking because of my /dev/random drop-in-replacement 
implementation, any RNG from the kernel crypto API can be configured to be 
used as an output DRNG. Though, this will only work if the DRNG also accepts 
seed from the software noise sources.

Ciao
Stephan
