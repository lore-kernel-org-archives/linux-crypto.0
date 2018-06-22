From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Fri, 22 Jun 2018 22:38:29 +0800
Message-ID: <20180622143829.rd2ys6ci7q3aupst@gondor.apana.org.au>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
 <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
 <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
 <6782b1c0-ea94-b07c-2fae-3fe3223bb22a@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vinod Koul <vinod.koul@linaro.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6782b1c0-ea94-b07c-2fae-3fe3223bb22a@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2018 at 11:27:59AM +0300, Stanimir Varbanov wrote:
> Hi Herbert,
> 
> On 06/21/2018 02:53 PM, Herbert Xu wrote:
> > On Thu, Jun 21, 2018 at 02:27:10PM +0300, Stanimir Varbanov wrote:
> >>
> >> OK, I just wanted to say that it is _not_ PRNG and the register names
> >> gives us wrong impression.
> > 
> > So does it generate one bit of output for each bit of hardware-
> > generated entropy like /dev/random? Or does it use a hardware-
> > generated seed to power a PRNG?
> 
> I believe it is the second one. Isn't the second one SP 800-90A?

In that case it should switch over to algif_rng.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
