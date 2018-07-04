From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 3/6] crypto: Add Qcom prng driver
Date: Wed, 04 Jul 2018 08:16:25 +0200
Message-ID: <2060153.p9Cf2LoRhr@tauon.chronox.de>
References: <20180703060434.19293-1-vkoul@kernel.org> <20180704041059.GT22377@vkoul-mobl> <20180704061035.GY22377@vkoul-mobl>
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
To: Vinod <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704061035.GY22377@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 4. Juli 2018, 08:10:35 CEST schrieb Vinod:

Hi Vinod,

> On 04-07-18, 09:40, Vinod wrote:
> > Hi Stephan,
> > 
> > On 03-07-18, 15:28, Stephan Mueller wrote:
> > > Am Dienstag, 3. Juli 2018, 08:04:31 CEST schrieb Vinod Koul:
> > > > +static int qcom_rng_read(struct qcom_rng *rng, void *data, size_t
> > > > max)
> > > > +{
> > > > +	size_t currsize = 0;
> > > > +	u32 *retdata = data;
> > > 
> > > How can you be sure that this cast is appropriate? I.e. how is it
> > > guaranteed that data is 4-byte aligned?
> > 
> > While reading we check the alignment:
> >                /* make sure we stay on 32bit boundary */
> >                if ((max - currsize) < WORD_SZ)
> >                
> >                        break;

I am not sure I follow your argument.

You cast a void (or u8 pointer into u32:

+       u32 *retdata = data;

You use it:

+       *retdata++ = val;

Followed by your check.

What I mean is that the initial cast and then the subsequent write operation 
is only guaranteed to work if the initial pointer is alighed on a 4 byte 
boundary. However, since it is an u8 pointer, it is not guaranteed to be 
aligned.

So, I guess you want to use memcpy (at least if it is not aligned).

Ciao
Stephan
