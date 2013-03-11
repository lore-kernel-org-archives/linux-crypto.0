From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
Date: Mon, 11 Mar 2013 09:19:26 +0800
Message-ID: <20130311011926.GA14930@gondor.apana.org.au>
References: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
 <1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
 <20130304075306.GA1906@pengutronix.de>
 <CACKLOr2kuWXMreEFA4wqyYVRNnPwmEoHPM2+V+tN5P_1bQ+iJQ@mail.gmail.com>
 <20130310083401.GB10448@gondor.apana.org.au>
 <20130310230856.GU1906@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, kernel@pengutronix.de, gcembed@gmail.com,
	shawn.guo@linaro.org, arnd@arndb.de, swarren@nvidia.com
To: Sascha Hauer <s.hauer@pengutronix.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130310230856.GU1906@pengutronix.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 11, 2013 at 12:08:56AM +0100, Sascha Hauer wrote:
> On Sun, Mar 10, 2013 at 04:34:01PM +0800, Herbert Xu wrote:
> > > >
> > > > https://patchwork.kernel.org/patch/1817741/
> > > >
> > > > So the change above becomes unnecessary
> > > 
> > > Very good. Then this patch can be safely dropped.
> > 
> > So should I take this patch or not?
> 
> This clk patch, no. The sahara patch, yes, if it is fine for you.

But will the second patch work fine without the first?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
