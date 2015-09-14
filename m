From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/6] hwrng: st: Add support for ST's HW Random Number
 Generator
Date: Mon, 14 Sep 2015 08:42:34 +0100
Message-ID: <20150914074234.GC27591@x1>
References: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
 <1442002110-28733-5-git-send-email-lee.jones@linaro.org>
 <CAOMZO5CWywFHd1HE2=G-KEvQZpu_rJibmJL4fL5yCWRsnpi05Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pankaj Dev <pankaj.dev@st.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>, kernel@stlinux.com
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOMZO5CWywFHd1HE2=G-KEvQZpu_rJibmJL4fL5yCWRsnpi05Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 12 Sep 2015, Fabio Estevam wrote:

> On Fri, Sep 11, 2015 at 5:08 PM, Lee Jones <lee.jones@linaro.org> wro=
te:
>=20
> > +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +       base =3D devm_ioremap_resource(&pdev->dev, res);
> > +       if (IS_ERR(base))
> > +               return PTR_ERR(base);
> > +
> > +       clk =3D devm_clk_get(&pdev->dev, NULL);
> > +       if (!clk)
> > +               return -EINVAL;
>=20
> This should be:
>=20
>     if (IS_ERR(clk))
>         return PTR_ERR(clk);

You're right.  Will fix.

> > +
> > +       clk_prepare_enable(clk);
>=20
> This may fail, so better check its return value and propagate it on e=
rror.

Looks like the jury is out on this one.

$ git grep clk_prepare_enable | grep '=3D clk\|if (' | wc -l
659
$ git grep clk_prepare_enable | grep -v '=3D clk\|if (' | wc -l
569

=2E.. but it's not a problem to fix up.  Will do.

> > +       ddata->ops.priv =3D (unsigned long)ddata;
> > +       ddata->ops.read =3D st_rng_read;
> > +       ddata->ops.name =3D pdev->name;
> > +       ddata->base     =3D base;
> > +       ddata->clk      =3D clk;
> > +
> > +       dev_set_drvdata(&pdev->dev, ddata);
> > +
> > +       ret =3D hwrng_register(&ddata->ops);
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "Failed to register HW RNG\n");
> > +               return ret;
> > +       }
> > +
> > +       dev_info(&pdev->dev, "Successfully registered HW RNG\n");
>=20
> No need to put this info.

Ah, you caught me!

I know these types of prints are usually deemed not useful; however,
unless there is a failure both this driver and the core driver are
silent, so the user doesn't know that 1 or more of these devices are
available.  I personally like to see an entry in the bootlog for this
kind of functionality.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
