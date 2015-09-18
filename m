From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 0/7] hwrng: Add support for STMicroelectronics' RNG IP
Date: Fri, 18 Sep 2015 16:51:12 +0100
Message-ID: <20150918155112.GE3218@x1>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <20150918140756.GK9249@gondor.apana.org.au>
 <CAF2Aj3h7Jy=tpYdZTdbxAJwa=147_hAu3reOFrbEh=JdrMFWLQ@mail.gmail.com>
 <20150918151137.GA10763@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150918151137.GA10763@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 18 Sep 2015, Herbert Xu wrote:
> On Fri, Sep 18, 2015 at 03:53:50PM +0100, Lee Jones wrote:
> > On 18 September 2015 at 15:07, Herbert Xu <herbert@gondor.apana.org=
=2Eau> wrote:
> > > On Thu, Sep 17, 2015 at 02:45:50PM +0100, Lee Jones wrote:
> > >> v1 =3D> v2:
> > >>  - New patch: Also fixing /dev/hw_random =3D> /dev/hwrng in Kcon=
fig
> > >>  - Fix 2099 =3D> 2009 typo in commit log
> > >>  - Fix 'number of random numbers sourced' return value
> > >>  - Treat devm_clk_get()'s return value correctly
> > >>  - Check return value of clk_prepare_enable()
> > >>  - Use sysfs_streq() instead of manually stripping '\n' from sys=
fs
> > >
> > > All applied.  Thanks.
> >=20
> > Just to be clear.  Which patches have you applied?
>=20
> All of your patches.

I think it's okay for you to take all but patch 6.

Patch 6 is an ARM patch and needs to go into ARM SoC via
STMicroelectronics STi tree.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
