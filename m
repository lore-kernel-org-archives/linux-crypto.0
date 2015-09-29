From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v2 0/7] hwrng: Add support for
 STMicroelectronics' RNG IP
Date: Tue, 29 Sep 2015 11:42:01 +0100
Message-ID: <20150929104201.GX27197@x1>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <20150929092047.GA16955@griffinp-ThinkPad-X1-Carbon-2nd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kieranbingham@gmail.com, kernel@stlinux.com
To: Peter Griffin <peter.griffin@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150929092047.GA16955@griffinp-ThinkPad-X1-Carbon-2nd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 29 Sep 2015, Peter Griffin wrote:
> On Thu, 17 Sep 2015, Lee Jones wrote:
>=20
> > v1 =3D> v2:
> >  - New patch: Also fixing /dev/hw_random =3D> /dev/hwrng in Kconfig
> >  - Fix 2099 =3D> 2009 typo in commit log
> >  - Fix 'number of random numbers sourced' return value
> >  - Treat devm_clk_get()'s return value correctly
> >  - Check return value of clk_prepare_enable()
> >  - Use sysfs_streq() instead of manually stripping '\n' from sysfs
> >=20
> > The main aim of this set is to allow users to access ST's hardware
> > random number generator.  It's a simple device, which only requires
> > a simple driver.
> >=20
> > We're also taking the liberty to update some out of date HWRNG
> > documentation and making the sysfs interface a little easier to
> > use by ignoring any '\n' which may have been inadvertently passed.
>=20
> Looks good, for the series: -
>=20
> Acked-by: Peter Griffin <peter.griffin@linaro.org>

Thanks, but Herbert already applied the series.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
