From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/4] hwrng: omap - remove #ifdefery around PM methods
Date: Wed, 11 Mar 2015 14:08:56 -0700
Message-ID: <20150311210856.GA8434@dtor-ws>
References: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
 <1425922598-16538-2-git-send-email-dmitry.torokhov@gmail.com>
 <20150311105957.GA5351@gondor.apana.org.au>
 <20150311154407.GA37516@dtor-ws>
 <20150311210034.GA10537@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Deepak Saxena <dsaxena@plexity.net>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150311210034.GA10537@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 12, 2015 at 08:00:35AM +1100, Herbert Xu wrote:
> On Wed, Mar 11, 2015 at 08:44:07AM -0700, Dmitry Torokhov wrote:
> > 
> > SIMPLE_DEV_PM_OPS() produces an empty omap_rng_pm structure in case of
> > !CONFIG_PM_SLEEP so neither omap_rng_suspend nor omap_rng_resume will
> > end up being referenced.
> 
> OK, could you please resend this patch?

Done.

Thanks!

-- 
Dmitry
