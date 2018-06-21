From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Thu, 21 Jun 2018 19:53:12 +0800
Message-ID: <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
 <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
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
In-Reply-To: <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 21, 2018 at 02:27:10PM +0300, Stanimir Varbanov wrote:
>
> OK, I just wanted to say that it is _not_ PRNG and the register names
> gives us wrong impression.

So does it generate one bit of output for each bit of hardware-
generated entropy like /dev/random? Or does it use a hardware-
generated seed to power a PRNG?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
