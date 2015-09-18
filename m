From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] hwrng: Add support for STMicroelectronics' RNG IP
Date: Fri, 18 Sep 2015 23:11:38 +0800
Message-ID: <20150918151137.GA10763@gondor.apana.org.au>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <20150918140756.GK9249@gondor.apana.org.au>
 <CAF2Aj3h7Jy=tpYdZTdbxAJwa=147_hAu3reOFrbEh=JdrMFWLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Peter Korsgaard <peter@korsgaard.com>,
	Fabio Estevam <festevam@gmail.com>,
	Kieran Bingham <kieranbingham@gmail.com>,
	"kernel@stlinux.com" <kernel@stlinux.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF2Aj3h7Jy=tpYdZTdbxAJwa=147_hAu3reOFrbEh=JdrMFWLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 18, 2015 at 03:53:50PM +0100, Lee Jones wrote:
> On 18 September 2015 at 15:07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Thu, Sep 17, 2015 at 02:45:50PM +0100, Lee Jones wrote:
> >> v1 => v2:
> >>  - New patch: Also fixing /dev/hw_random => /dev/hwrng in Kconfig
> >>  - Fix 2099 => 2009 typo in commit log
> >>  - Fix 'number of random numbers sourced' return value
> >>  - Treat devm_clk_get()'s return value correctly
> >>  - Check return value of clk_prepare_enable()
> >>  - Use sysfs_streq() instead of manually stripping '\n' from sysfs
> >
> > All applied.  Thanks.
> 
> Just to be clear.  Which patches have you applied?

All of your patches.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
