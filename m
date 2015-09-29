From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 0/7] hwrng: Add support for STMicroelectronics' RNG IP
Date: Tue, 29 Sep 2015 15:29:32 +0100
Message-ID: <20150929142932.GY27197@x1>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <20150918140756.GK9249@gondor.apana.org.au>
 <CAF2Aj3h7Jy=tpYdZTdbxAJwa=147_hAu3reOFrbEh=JdrMFWLQ@mail.gmail.com>
 <20150918151137.GA10763@gondor.apana.org.au>
 <20150918155112.GE3218@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Peter Korsgaard <peter@korsgaard.com>,
	Fabio Estevam <festevam@gmail.com>,
	Kieran Bingham <kieranbingham@gmail.com>,
	"kernel@stlinux.com" <kernel@stlinux.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37094 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965317AbbI2O3h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Sep 2015 10:29:37 -0400
Received: by wicfx3 with SMTP id fx3so18869325wic.0
        for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2015 07:29:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150918155112.GE3218@x1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 18 Sep 2015, Lee Jones wrote:
> On Fri, 18 Sep 2015, Herbert Xu wrote:
> > On Fri, Sep 18, 2015 at 03:53:50PM +0100, Lee Jones wrote:
> > > On 18 September 2015 at 15:07, Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
> > > > On Thu, Sep 17, 2015 at 02:45:50PM +0100, Lee Jones wrote:
> > > >> v1 =3D> v2:
> > > >>  - New patch: Also fixing /dev/hw_random =3D> /dev/hwrng in Kc=
onfig
> > > >>  - Fix 2099 =3D> 2009 typo in commit log
> > > >>  - Fix 'number of random numbers sourced' return value
> > > >>  - Treat devm_clk_get()'s return value correctly
> > > >>  - Check return value of clk_prepare_enable()
> > > >>  - Use sysfs_streq() instead of manually stripping '\n' from s=
ysfs
> > > >
> > > > All applied.  Thanks.
> > >=20
> > > Just to be clear.  Which patches have you applied?
> >=20
> > All of your patches.
>=20
> I think it's okay for you to take all but patch 6.
>=20
> Patch 6 is an ARM patch and needs to go into ARM SoC via
> STMicroelectronics STi tree.

Hi Herbert,

I see that your tree is 8 days old, so this may have been resolved
already, but would you be kind enough to ensure you remove the 6th
(ARM) patch from your repo please?  I wouldn't want it to cause
conflicts and for Maxime and yourself to get shouted at by Linus.

Much appreciated.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
