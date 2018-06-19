From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Tue, 19 Jun 2018 09:36:30 +0530
Message-ID: <20180619040630.GK25852@vkoul-mobl>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180618182123.GT14924@minitux>
 <152935345439.16708.16472364970375601294@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152935345439.16708.16472364970375601294@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18-06-18, 13:24, Stephen Boyd wrote:
> Quoting Bjorn Andersson (2018-06-18 11:21:23)
> > On Mon 18 Jun 07:12 PDT 2018, Vinod Koul wrote:
> > 
> > > Qcom 8996 and later chips support prng v2 where we need to only
> > > implement .read callback for hwrng.
> > > 
> > 
> > The hardware still needs initialization, so I think you should expand
> > this to mention that the initialization is moved to secure world and
> > that's the reason why we only implement read.
> > 
> > The question is what happens in projects with other security models.
> 
> Can we still read the PRNG_CONFIG register to see if it's already been
> configured or not and then bail out if it isn't configured? That would
> be better as long as we the system doesn't blow up if non-secure mode
> tries to read the config register.

Unfortunately it did blow up for me when I tried it..

-- 
~Vinod
