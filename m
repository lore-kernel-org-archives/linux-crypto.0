Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF081272AE
	for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 09:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714037695; cv=none; b=U+XTjzbiGfsFiyK+6+Yl/pcwjz4GnjgUL0ZadaUiMrYy0SDwKP4JswRNb3OB7bNH6VvnEUaDCtCvBdt5A0ze2w97b7UqvpBk4sZl0kVP7p/w805YFPJdydXwVSD9uue/k0E5GKEEoOJdXfIlX5y8KI5x0X6hhZo68/rdLLdZee4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714037695; c=relaxed/simple;
	bh=LriGBtRdKxJQZoQIEpXoumDBcitKSt4Yg0AWvuVsfNY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=arQNZDqkTQdS5uBdJJ0ljonE6cDLN5exVnuL3YjooPSrLByN7eoIZhd+OKdLKmJPrOiwuqSy4Tyqgh28pCf6Zkc1SLI1AbO14UfvuOKNkgLccAaqTN5hSr3WkKrFJI3Fv/2q13MoI1xVvOzikJ+SI+L9eC6e7+D0Hpd/8/Hygjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0P9nOIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0P9nOIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA57AC113CC;
	Thu, 25 Apr 2024 09:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714037694;
	bh=LriGBtRdKxJQZoQIEpXoumDBcitKSt4Yg0AWvuVsfNY=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=Y0P9nOIAtE2sfYf673CHvnIXlhdQWZRrxBKLUx5zZ5TArsqBSPf/V1J25zKlEFX+f
	 hPN2I+I+tqY7eM1atLVoD43n3LvnsovP4zaY22255o/aT4+6gPmNRmpWbR29pgqIj4
	 pnwQl4ohFgblSr6km4+FKZ6zeA8Jg6wQFbMDNGx/CXKcmYY6LNTnUCYmSWi96lEUuZ
	 MD5hCzCTGOrrPbVujx9Cszl8QlSbWtO6q8K90oOX/QkwrGwB2mxUKUiJx/2+M+2yv3
	 rd0e+m0MKlkSUuEGNjLErOqV/EYGdbXlQ1vJ57W5VgezKSRLHfS+E25UB+nW5GVvU/
	 H+04MRNMdDv9A==
Date: Thu, 25 Apr 2024 11:34:47 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, Hans de Goede
 <hdegoede@redhat.com>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v7 6/9] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240425113447.5d4b21f4@dellmb>
In-Reply-To: <Zilhvv3ffWMDL1Uj@smile.fi.intel.com>
References: <20240424173809.7214-1-kabel@kernel.org>
	<20240424173809.7214-7-kabel@kernel.org>
	<ZilQiHLLj1eQxP2L@smile.fi.intel.com>
	<20240424205123.5fc82a1a@dellmb>
	<Zilhvv3ffWMDL1Uj@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2024 22:47:10 +0300
Andy Shevchenko <andy@kernel.org> wrote:

> On Wed, Apr 24, 2024 at 08:51:23PM +0200, Marek Beh=C3=BAn wrote:
> > On Wed, 24 Apr 2024 21:33:44 +0300
> > Andy Shevchenko <andy@kernel.org> wrote: =20
> > > On Wed, Apr 24, 2024 at 07:38:05PM +0200, Marek Beh=C3=BAn wrote: =20
>=20
> ...
>=20
> > > > +static void omnia_irq_mapping_drop(void *res)
> > > > +{
> > > > +	irq_dispose_mapping((unsigned int)(unsigned long)res);
> > > > +} =20
> > >=20
> > > Leftover? =20
> >=20
> > What do you mean? I dropped the devm-helpers.h changes, now I do
> > devm_add_action_or_reset() manually, with this function as the action. =
=20
>=20
> But why?
>=20
> ...
>=20
> > > > +	irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> > > > +	irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > > > +	if (irq < 0)
> > > > +		return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n"); =20
>=20
> > > > +	err =3D devm_add_action_or_reset(dev, omnia_irq_mapping_drop,
> > > > +				       (void *)(unsigned long)irq);
> > > > +	if (err)
> > > > +		return err; =20
> > >=20
> > > Are you sure it's correct now? =20
> >=20
> > Yes, why wouldn't it? =20
>=20
> For what purpose? I don't see drivers doing that. Are you expecting that
> the same IRQ mapping will be reused for something else? Can you elaborate
> how? (I can imagine one theoretical / weird case how to achieve that,
> but impractical.)

I do a lot of binding/unbinding of that driver. I was under the
impression that all resources should be dropped on driver unbind.

> Besides above, this is asymmetrical call to gpiod_to_irq(). If we really =
care
> about this, it should be provided by GPIO library.
>=20

Something like the following?

=46rom 5aac93d55f6fb750726f7e879672142956981a4c Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Marek=3D20Beh=3DC3=3DBAn?=3D <kabel@kernel.org>
Date: Thu, 25 Apr 2024 11:33:33 +0200
Subject: [PATCH] gpiolib: devres: Add resource managed version of
 gpiod_to_irq()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Add devm_gpiod_to_irq(), a resource managed version of gpiod_to_irq().
The release function calls irq_dispose_mapping().

Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
---
 drivers/gpio/gpiolib-devres.c | 27 +++++++++++++++++++++++++++
 include/linux/gpio/consumer.h | 10 ++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/gpio/gpiolib-devres.c b/drivers/gpio/gpiolib-devres.c
index 4987e62dcb3d..98a40492e596 100644
--- a/drivers/gpio/gpiolib-devres.c
+++ b/drivers/gpio/gpiolib-devres.c
@@ -12,6 +12,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/device.h>
 #include <linux/gfp.h>
+#include <linux/irqdomain.h>
=20
 #include "gpiolib.h"
=20
@@ -427,3 +428,29 @@ int devm_gpiochip_add_data_with_key(struct device *dev=
, struct gpio_chip *gc, vo
 	return devm_add_action_or_reset(dev, devm_gpio_chip_release, gc);
 }
 EXPORT_SYMBOL_GPL(devm_gpiochip_add_data_with_key);
+
+static void devm_gpiod_irq_release(void *data)
+{
+	irq_dispose_mapping((unsigned int)(unsigned long)data);
+}
+
+/**
+ * devm_gpiod_to_irq() - Resource managed devm_gpiod_to_irq()
+ * @dev: pointer to the device that gpio_chip belongs to.
+ * @desc: gpio whose IRQ will be returned
+ *
+ * Return the IRQ corresponding to the passed GPIO, or an error code in ca=
se of
+ * error.
+ */
+int devm_gpiod_to_irq(struct device *dev, const struct gpio_desc *desc)
+{
+	int virq;
+
+	virq =3D gpiod_to_irq(desc);
+	if (virq < 0)
+		return virq;
+
+	return devm_add_action_or_reset(dev, devm_gpiod_irq_release,
+					(void *)(unsigned long)virq);
+}
+EXPORT_SYMBOL_GPL(devm_gpiod_to_irq);
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index db2dfbae8edb..e8f4829538f6 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -165,6 +165,8 @@ int gpiod_is_active_low(const struct gpio_desc *desc);
 int gpiod_cansleep(const struct gpio_desc *desc);
=20
 int gpiod_to_irq(const struct gpio_desc *desc);
+int devm_gpiod_to_irq(struct device *dev, const struct gpio_desc *desc);
+
 int gpiod_set_consumer_name(struct gpio_desc *desc, const char *name);
=20
 /* Convert between the old gpio_ and new gpiod_ interfaces */
@@ -519,6 +521,14 @@ static inline int gpiod_to_irq(const struct gpio_desc =
*desc)
 	return -EINVAL;
 }
=20
+static inline int devm_gpiod_to_irq(struct device *dev,
+				    const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(desc);
+	return -EINVAL;
+}
+
 static inline int gpiod_set_consumer_name(struct gpio_desc *desc,
 					  const char *name)
 {
--=20
2.43.2

