From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v3 3/6] crypto: Add Qcom prng driver
Date: Wed, 4 Jul 2018 11:40:35 +0530
Message-ID: <20180704061035.GY22377@vkoul-mobl>
References: <20180703060434.19293-1-vkoul@kernel.org>
 <20180703060434.19293-4-vkoul@kernel.org>
 <2990655.vKmMgW600W@tauon.chronox.de>
 <20180704041059.GT22377@vkoul-mobl>
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
In-Reply-To: <20180704041059.GT22377@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04-07-18, 09:40, Vinod wrote:
> Hi Stephan,
> 
> On 03-07-18, 15:28, Stephan Mueller wrote:
> > Am Dienstag, 3. Juli 2018, 08:04:31 CEST schrieb Vinod Koul:
> > > +static int qcom_rng_read(struct qcom_rng *rng, void *data, size_t max)
> > > +{
> > > +	size_t currsize = 0;
> > > +	u32 *retdata = data;
> > 
> > How can you be sure that this cast is appropriate? I.e. how is it guaranteed 
> > that data is 4-byte aligned?
> 
> While reading we check the alignment:
> 
>                /* make sure we stay on 32bit boundary */
>                if ((max - currsize) < WORD_SZ)
>                        break;
> 
> > Also, the data variable in qcom_rng_generate is a u8 -- shouldn't this type be 
> > used instead of a void?
> 
> That does make sense to me. IIRC the read is for a byte. I will check
> this and update it

Okay so I rechecked this, the hardware gives 32 bits of random data. I
am thinking of splitting the word and updating by each byte. That way
trailing zero can also be avoided which is the case now

-- 
~Vinod
