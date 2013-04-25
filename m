From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/9 v2] crypto: ux500/hash - Prepare clock before
 enabling it
Date: Thu, 25 Apr 2013 14:46:36 +0100
Message-ID: <20130425134636.GP4623@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
 <1366280825-31136-2-git-send-email-lee.jones@linaro.org>
 <20130419122428.GC3432@gmail.com>
 <CACRpkdYrCA6SduwMJF=7C9hyjP2Or7gxhjVFtLshdzkbYnxX1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdYrCA6SduwMJF=7C9hyjP2Or7gxhjVFtLshdzkbYnxX1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Fri, Apr 19, 2013 at 2:24 PM, Lee Jones <lee.jones@linaro.org> wro=
te:
> > Slight change of plan for v2.
> >
> > Now we're doing a seperate clk_prepare(), as the clk_enable() in th=
e
> > previous patch turned out to be called inside a spin_lock().
> >
> > Arnd, can you confirm your Ack please?
>=20
> Do you really want letters to Arnd to be part of the commit log?
>=20
> >
> > ---
>=20
> Note: stuff following the three dashes (---) will be *omitted*
> from the change log. This seems to be turned upside-down.

Ah, I didn't know that, thanks.

This patch wasn't due for 'plucking', just reviewing.

> > crypto: ux500/hash - Prepare clock before enabling it
> >
> > If we fail to prepare the ux500-hash clock before enabling it the
> > platform will fail to boot. Here we insure this happens.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Andreas Westin <andreas.westin@stericsson.com>
> > Cc: linux-crypto@vger.kernel.org
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>=20
> Pls include Ulf Hansson <ulf.hansson@linaro.org> on this patch.

Sure.

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
