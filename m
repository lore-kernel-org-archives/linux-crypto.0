From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v3 3/6] crypto: Add Qcom prng driver
Date: Thu, 5 Jul 2018 11:31:14 +0530
Message-ID: <20180705060114.GG22377@vkoul-mobl>
References: <20180703060434.19293-1-vkoul@kernel.org>
 <20180703060434.19293-4-vkoul@kernel.org>
 <19909549.EUeuX9KOs7@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19909549.EUeuX9KOs7@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

On 04-07-18, 18:02, Stephan Mueller wrote:
> Am Dienstag, 3. Juli 2018, 08:04:31 CEST schrieb Vinod Koul:
> > +static int qcom_rng_seed(struct crypto_rng *tfm, const u8 *seed,
> > +			 unsigned int slen)
> > +{
> > +	return 0;
> > +}
> 
> One more question: is it not possible to mix in data into the DRNG? I thought 
> it would be possible with the Qualcomm DRBG.
> 
> Note, I am asking because of my /dev/random drop-in-replacement 
> implementation, any RNG from the kernel crypto API can be configured to be 
> used as an output DRNG. Though, this will only work if the DRNG also accepts 
> seed from the software noise sources.

The v1 hardware supports seeding but the register is Read Only for SW and
only trusted zone (firmware) can write.

v2 hardware slice does not have seeding. v2 seeding is not accessible to
SW.

So in short, it is not available for us to use :(

-- 
~Vinod
