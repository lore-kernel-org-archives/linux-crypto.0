From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 5/7] hwrng: st: Add support for ST's HW Random Number
 Generator
Date: Mon, 5 Oct 2015 13:11:02 +0100
Message-ID: <20151005121102.GB17172@x1>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <1442497557-9271-6-git-send-email-lee.jones@linaro.org>
 <5612548E.8090405@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kieranbingham@gmail.com, kernel@stlinux.com,
	Pankaj Dev <pankaj.dev@st.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5612548E.8090405@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 05 Oct 2015, Daniel Thompson wrote:
> Late but...

That's okay.  Fixup patches can always be submitted.

We have forever. :)

> On 17/09/15 14:45, Lee Jones wrote:
> >diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_rando=
m/Makefile
> >index 055bb01..8bcfb45 100644
> >--- a/drivers/char/hw_random/Makefile
> >+++ b/drivers/char/hw_random/Makefile
> >@@ -30,4 +30,5 @@ obj-$(CONFIG_HW_RANDOM_TPM) +=3D tpm-rng.o
> >  obj-$(CONFIG_HW_RANDOM_BCM2835) +=3D bcm2835-rng.o
> >  obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) +=3D iproc-rng200.o
> >  obj-$(CONFIG_HW_RANDOM_MSM) +=3D msm-rng.o
> >+obj-$(CONFIG_HW_RANDOM_ST) +=3D st-rng.o
> >  obj-$(CONFIG_HW_RANDOM_XGENE) +=3D xgene-rng.o
> >diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_rando=
m/st-rng.c
> >new file mode 100644
> >index 0000000..8c8a435
> >--- /dev/null
> >+++ b/drivers/char/hw_random/st-rng.c
> >@@ -0,0 +1,144 @@
> >+/*
> >+ * ST Random Number Generator Driver ST's Platforms
> >+ *
> >+ * Author: Pankaj Dev: <pankaj.dev@st.com>
> >+ *         Lee Jones <lee.jones@linaro.org>
> >+ *
> >+ * Copyright (C) 2015 STMicroelectronics (R&D) Limited
> >+ *
> >+ * This program is free software; you can redistribute it and/or mo=
dify
> >+ * it under the terms of the GNU General Public License version 2 a=
s
> >+ * published by the Free Software Foundation.
> >+ */
> >+
> >+#include <linux/clk.h>
> >+#include <linux/delay.h>
> >+#include <linux/hw_random.h>
> >+#include <linux/io.h>
> >+#include <linux/module.h>
> >+#include <linux/of.h>
> >+#include <linux/platform_device.h>
> >+#include <linux/slab.h>
> >+
> >+/* Registers */
> >+#define ST_RNG_STATUS_REG		0x20
> >+#define ST_RNG_DATA_REG			0x24
> >+
> >+/* Registers fields */
> >+#define ST_RNG_STATUS_BAD_SEQUENCE	BIT(0)
> >+#define ST_RNG_STATUS_BAD_ALTERNANCE	BIT(1)
> >+#define ST_RNG_STATUS_FIFO_FULL		BIT(5)
> >+
> >+#define ST_RNG_FIFO_SIZE		8
> >+#define ST_RNG_SAMPLE_SIZE		2 /* 2 Byte (16bit) samples */
> >+
> >+/* Samples are available every 0.667us, which we round to 1us */
> >+#define ST_RNG_FILL_FIFO_TIMEOUT   (1 * (ST_RNG_FIFO_SIZE / ST_RNG_=
SAMPLE_SIZE))
> >+
> >+struct st_rng_data {
> >+	void __iomem	*base;
> >+	struct clk	*clk;
> >+	struct hwrng	ops;
> >+};
> >+
> >+static int st_rng_read(struct hwrng *rng, void *data, size_t max, b=
ool wait)
> >+{
> >+	struct st_rng_data *ddata =3D (struct st_rng_data *)rng->priv;
> >+	u32 status;
> >+	int i;
> >+
> >+	if (max < sizeof(u16))
> >+		return -EINVAL;
> >+
> >+	/* Wait until FIFO is full - max 4uS*/
> >+	for (i =3D 0; i < ST_RNG_FILL_FIFO_TIMEOUT; i++) {
> >+		status =3D readl_relaxed(ddata->base + ST_RNG_STATUS_REG);
> >+		if (status & ST_RNG_STATUS_FIFO_FULL)
> >+			break;
> >+		udelay(1);
>=20
> How much bandwidth does using udelay() cost? I think it could be
> >10% compared to a tighter polling loop.

Samples are only available every 0.7uS and we only do this for every
4.  The maximum it could 'cost' is <1uS.  Do we really want to fuss
over that tiny amount of time?  It's an understandable point if we
were talking about milliseconds, but a single microsecond?

> >+	}
> >+
> >+	if (i =3D=3D ST_RNG_FILL_FIFO_TIMEOUT)
> >+		return 0;
>=20
> Isn't a timeout an error condition?

Yes, which is why we're returning 0.  In this context 0 =3D=3D 'no data=
'.
This will be converted to -EAGAIN if the caller did not request
NONBLOCKING.

> >+
> >+	for (i =3D 0; i < ST_RNG_FIFO_SIZE && i < max; i +=3D 2)
> >+		*(u16 *)(data + i) =3D
> >+			readl_relaxed(ddata->base + ST_RNG_DATA_REG);
> >+
> >+	return i;	/* No of bytes read */
> >+}
> >+
> >+static int st_rng_probe(struct platform_device *pdev)
> >+{
> >+	struct st_rng_data *ddata;
> >+	struct resource *res;
> >+	struct clk *clk;
> >+	void __iomem *base;
> >+	int ret;
> >+
> >+	ddata =3D devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
> >+	if (!ddata)
> >+		return -ENOMEM;
> >+
> >+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >+	base =3D devm_ioremap_resource(&pdev->dev, res);
> >+	if (IS_ERR(base))
> >+		return PTR_ERR(base);
> >+
> >+	clk =3D devm_clk_get(&pdev->dev, NULL);
> >+	if (IS_ERR(clk))
> >+		return PTR_ERR(clk);
> >+
> >+	ret =3D clk_prepare_enable(clk);
> >+	if (ret)
> >+		return ret;
> >+
> >+	ddata->ops.priv	=3D (unsigned long)ddata;
> >+	ddata->ops.read	=3D st_rng_read;
> >+	ddata->ops.name	=3D pdev->name;
> >+	ddata->base	=3D base;
> >+	ddata->clk	=3D clk;
> >+
> >+	dev_set_drvdata(&pdev->dev, ddata);
> >+
> >+	ret =3D hwrng_register(&ddata->ops);
> >+	if (ret) {
> >+		dev_err(&pdev->dev, "Failed to register HW RNG\n");
>=20
> Why shout about this particular error but not any others? Perhaps
> just rely on the driver core to report the error here?

I have omitted error prints from subsystem calls which do all the
shouting required.  Unfortunately the HWRNG is somewhat stuck in the
past in a number of ways; a lack of subsystem level shouting being one
of them.

> >+		return ret;
> >+	}
> >+
> >+	dev_info(&pdev->dev, "Successfully registered HW RNG\n");
> >+
> >+	return 0;
> >+}
> >+
> >+static int st_rng_remove(struct platform_device *pdev)
> >+{
> >+	struct st_rng_data *ddata =3D dev_get_drvdata(&pdev->dev);
> >+
> >+	hwrng_unregister(&ddata->ops);
> >+
> >+	clk_disable_unprepare(ddata->clk);
>=20
> This mismatches the error paths in the probe function (there is no
> cleanup of clock counts in probe function).

Good catch.  I am missing a clk_disable_unprepare() in the
hwrng_register() failure patch.  Will fix.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
