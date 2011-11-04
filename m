From: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] crypto: driver for tegra AES hardware
Date: Fri, 4 Nov 2011 14:21:23 -0700
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E83@HQMAIL01.nvidia.com>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
To: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
	"herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320405256-29374-1-git-send-email-vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Varun Wadekar wrote at Friday, November 04, 2011 5:14 AM:
> From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

If you teach git your full name, it'll omit this From: header from the
email body, which will be a little more idiomatic:

git config --global sendemail.from "Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>"

> driver supports ecb/cbc/ofb/ansi_x9.31rng modes,
> 128, 192 and 256-bit key sizes.
> 
> Change-Id: Ic7d8d6d76b8ab6712f3bc9048e2dee7b5ebd13ff

Please remove the Change-Id lines from patches before posting them.

> Signed-off-by: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

I ran this patch through checkpatch, and there's one error and some
warnings to fix.

> +config CRYPTO_DEV_TEGRA_AES
> +	tristate "Support for TEGRA AES hw engine"
> +	depends on ARCH_TEGRA_2x_SOC

Is this HW specific to Tegra20 such that the driver won't be useful for
Tegra30? In other words, should this depend on ARCH_TEGRA instead?

> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
...
>  obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
> +obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
> +

Can you please remove the extra blank line?

> +static int tegra_aes_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct tegra_aes_dev *dd;
> +	struct resource *res;
> +	int err = -ENOMEM, i = 0, j;
> +
> +	if (aes_dev)
> +		return -EEXIST;
> +
> +	dd = kzalloc(sizeof(struct tegra_aes_dev), GFP_KERNEL);

If you use devm_kzalloc here, and other devm_*() functions throughout,
you'll need a bunch less cleanup code in the failure path in probe(),
and the teardown path in remove().

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

Don't you need to call request_mem_region() between get_resource() and
ioremap()?

> +	dd->io_base = ioremap(dd->phys_base, resource_size(res));

There's a devm_ variant for this.

> +	/* Initialize the vde clock */
> +	dd->aes_clk = clk_get(dev, "vde");

That clock doesn't exist in the mainline kernel; "bsev" exists for device
"tegra-aes"...

> +	err = clk_set_rate(dd->aes_clk, ULONG_MAX);

That's a little fast... What rate should it be running at. Is this
something the driver should be configuring, or should the board file or
device-tree be configuring this?

> +	err = request_irq(INT_VDE_BSE_V, aes_irq, IRQF_TRIGGER_HIGH,
> +		"tegra-aes", dd);

Shouldn't the IRQ number come from a resource rather than being hard-coded?

> +static struct platform_driver tegra_aes_driver = {
> +	.probe  = tegra_aes_probe,
> +	.remove = __devexit_p(tegra_aes_remove),
> +	.driver = {
> +		.name   = "tegra-aes",
> +		.owner  = THIS_MODULE,
> +	},
> +};

Can you please allow instantiation from device-tree too; see drivers/
gpio/gpio-tegra.c's tegra_gpio_of_match[] for an example.

> diff --git a/drivers/crypto/tegra-aes.h b/drivers/crypto/tegra-aes.h

> +#define ICMDQUE_WR		0x1000

It'd be nice to prefix all the defines in this file with e.g. TEGRA_AES_
so that they're guaranteed not to conflict with any unrelated defines.

-- 
nvpublic
