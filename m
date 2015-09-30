From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] hwrng: Add support for STMicroelectronics' RNG IP
Date: Wed, 30 Sep 2015 21:47:57 +0800
Message-ID: <20150930134757.GA18408@gondor.apana.org.au>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <20150918140756.GK9249@gondor.apana.org.au>
 <CAF2Aj3h7Jy=tpYdZTdbxAJwa=147_hAu3reOFrbEh=JdrMFWLQ@mail.gmail.com>
 <20150918151137.GA10763@gondor.apana.org.au>
 <20150918155112.GE3218@x1>
 <20150929142932.GY27197@x1>
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
	"kernel@stlinux.com" <kernel@stlinux.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150929142932.GY27197@x1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 29, 2015 at 03:29:32PM +0100, Lee Jones wrote:
> 
> I see that your tree is 8 days old, so this may have been resolved
> already, but would you be kind enough to ensure you remove the 6th
> (ARM) patch from your repo please?  I wouldn't want it to cause
> conflicts and for Maxime and yourself to get shouted at by Linus.

I prefer not to merge patches that cannot be tested.  Without
the DT bits in patch 6 the other five patches are useless.  So
I think patch 6 should be applied together with the other five
which add the driver.

Of course if Linus wants me to revert patch 6 in case of any
potential conflicts with Maxime's tree I'll do that.  Linus?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
