From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 5/7] hwrng: st: Add support for ST's HW Random Number
 Generator
Date: Mon, 5 Oct 2015 15:52:59 +0100
Message-ID: <20151005145259.GD17172@x1>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <1442497557-9271-6-git-send-email-lee.jones@linaro.org>
 <5612548E.8090405@linaro.org>
 <20151005121102.GB17172@x1>
 <561272EC.6080300@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kieranbingham@gmail.com, kernel@stlinux.com,
	Pankaj Dev <pankaj.dev@st.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37742 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbbJEOxF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Oct 2015 10:53:05 -0400
Received: by wicfx3 with SMTP id fx3so118303833wic.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Oct 2015 07:53:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <561272EC.6080300@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 05 Oct 2015, Daniel Thompson wrote:
> On 05/10/15 13:11, Lee Jones wrote:
> >On Mon, 05 Oct 2015, Daniel Thompson wrote:
> >>Late but...
> >
> >That's okay.  Fixup patches can always be submitted.
> >
> >We have forever. :)
> >
> >>On 17/09/15 14:45, Lee Jones wrote:
> >>>diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_ran=
dom/Makefile
> >>>index 055bb01..8bcfb45 100644
> >>>--- a/drivers/char/hw_random/Makefile
> >>>+++ b/drivers/char/hw_random/Makefile
> >>>@@ -30,4 +30,5 @@ obj-$(CONFIG_HW_RANDOM_TPM) +=3D tpm-rng.o
> >>>  obj-$(CONFIG_HW_RANDOM_BCM2835) +=3D bcm2835-rng.o
> >>>  obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) +=3D iproc-rng200.o
> >>>  obj-$(CONFIG_HW_RANDOM_MSM) +=3D msm-rng.o
> >>>+obj-$(CONFIG_HW_RANDOM_ST) +=3D st-rng.o
> >>>  obj-$(CONFIG_HW_RANDOM_XGENE) +=3D xgene-rng.o
> >>>diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_ran=
dom/st-rng.c
> >>>new file mode 100644
> >>>index 0000000..8c8a435
> >>>--- /dev/null
> >>>+++ b/drivers/char/hw_random/st-rng.c
> >>>@@ -0,0 +1,144 @@
> >>>+/*
> >>>+ * ST Random Number Generator Driver ST's Platforms
> >>>+ *
> >>>+ * Author: Pankaj Dev: <pankaj.dev@st.com>
> >>>+ *         Lee Jones <lee.jones@linaro.org>
> >>>+ *
> >>>+ * Copyright (C) 2015 STMicroelectronics (R&D) Limited
> >>>+ *
> >>>+ * This program is free software; you can redistribute it and/or =
modify
> >>>+ * it under the terms of the GNU General Public License version 2=
 as
> >>>+ * published by the Free Software Foundation.
> >>>+ */
> >>>+
> >>>+#include <linux/clk.h>
> >>>+#include <linux/delay.h>
> >>>+#include <linux/hw_random.h>
> >>>+#include <linux/io.h>
> >>>+#include <linux/module.h>
> >>>+#include <linux/of.h>
> >>>+#include <linux/platform_device.h>
> >>>+#include <linux/slab.h>
> >>>+
> >>>+/* Registers */
> >>>+#define ST_RNG_STATUS_REG		0x20
> >>>+#define ST_RNG_DATA_REG			0x24
> >>>+
> >>>+/* Registers fields */
> >>>+#define ST_RNG_STATUS_BAD_SEQUENCE	BIT(0)
> >>>+#define ST_RNG_STATUS_BAD_ALTERNANCE	BIT(1)
> >>>+#define ST_RNG_STATUS_FIFO_FULL		BIT(5)
> >>>+
> >>>+#define ST_RNG_FIFO_SIZE		8
> >>>+#define ST_RNG_SAMPLE_SIZE		2 /* 2 Byte (16bit) samples */
> >>>+
> >>>+/* Samples are available every 0.667us, which we round to 1us */
> >>>+#define ST_RNG_FILL_FIFO_TIMEOUT   (1 * (ST_RNG_FIFO_SIZE / ST_RN=
G_SAMPLE_SIZE))
> >>>+
> >>>+struct st_rng_data {
> >>>+	void __iomem	*base;
> >>>+	struct clk	*clk;
> >>>+	struct hwrng	ops;
> >>>+};
> >>>+
> >>>+static int st_rng_read(struct hwrng *rng, void *data, size_t max,=
 bool wait)
> >>>+{
> >>>+	struct st_rng_data *ddata =3D (struct st_rng_data *)rng->priv;
> >>>+	u32 status;
> >>>+	int i;
> >>>+
> >>>+	if (max < sizeof(u16))
> >>>+		return -EINVAL;
> >>>+
> >>>+	/* Wait until FIFO is full - max 4uS*/
> >>>+	for (i =3D 0; i < ST_RNG_FILL_FIFO_TIMEOUT; i++) {
> >>>+		status =3D readl_relaxed(ddata->base + ST_RNG_STATUS_REG);
> >>>+		if (status & ST_RNG_STATUS_FIFO_FULL)
> >>>+			break;
> >>>+		udelay(1);
> >>
> >>How much bandwidth does using udelay() cost? I think it could be
> >>>10% compared to a tighter polling loop.
> >
> >Samples are only available every 0.7uS and we only do this for every
> >4.  The maximum it could 'cost' is <1uS.  Do we really want to fuss
> >over that tiny amount of time?  It's an understandable point if we
> >were talking about milliseconds, but a single microsecond?
>=20
> This code is called in a tight loop so we're not talking about a
> *single* microsecond! We are are talking about about one microsecond
> in every five[1] and yes, I think we should care about that.
>=20
> It takes 2.67uS for the FIFO to come ready so with a polling
> interval of 1uS + loop overhead so I would fully expect on average
> to "waste" 0.5uS each time st_rng_read() is called (in a tight
> loop).
>=20
> [1]... point three recurring  ;-)

`time dd if=3D/dev/hwrng of=3D/dev/null bs=3D1 count=3D10M`

/* Current code, inc delay */
Run 1: real 0m17.996s
Run 2: real 0m17.991s
Run 3: real 0m17.996s
Run 4: real 0m18.000s
Run 5: real 0m18.000s
Total       0m89.983s

/* Tight loop, no delay */
Run 1: real 0m18.011s
Run 2: real 0m17.995s
Run 3: real 0m18.005s
Run 4: real 0m18.020s
Run 5: real 0m17.990s
Total       0m90.021s

(89.983 / 90.021) * 100 =3D 99.958%

0.042% saving.

Not quite the >10% predicted.  I'd say that's negligible.=20

> >>>+	}
> >>>+
> >>>+	if (i =3D=3D ST_RNG_FILL_FIFO_TIMEOUT)
> >>>+		return 0;
> >>
> >>Isn't a timeout an error condition?
> >
> >Yes, which is why we're returning 0.  In this context 0 =3D=3D 'no d=
ata'.
> >This will be converted to -EAGAIN if the caller did not request
> >NONBLOCKING.
>=20
> I took the view that hitting the timeout means the hardware is
> broken. Is it likely that the next time we call it there will be
> data ready? If it is should it be trusted?

=46rom experience gained whilst testing, I can say that when returning
an error the HNG breaks and the user receives an error.  If instead we
return 0, we get to have another go and random numbers again pour
out.  Perhaps we're just not waiting long enough?  Either way, the
current implementation works real well.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
