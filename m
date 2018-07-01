From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Sun, 1 Jul 2018 14:27:34 +0800
Message-ID: <20180701062734.s6ldsbhi42hnn6x6@gondor.apana.org.au>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
 <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
 <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
 <CAOZdJXVO-0JDvX4OdJMNCmY_BXrEenXpoWBf=Ww5uFBtXKN86A@mail.gmail.com>
 <20180629083732.GB22377@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Timur Tabi <timur@kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Vinod <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180629083732.GB22377@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 29, 2018 at 02:07:32PM +0530, Vinod wrote:
>
> I think Stan did bring this point earlier that PRNG is compliant to
> FIPS-140-2. So it can be used by rng clients for various purposes but
> should not be fed to dev/random as the hw_random does.
> 
> Herbert, can you please confirm..

Yes this is a PRNG.  A hardware RNG should return 1 bit of entropy
per bit of output.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
