From: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] crypto: driver for tegra AES hardware
Date: Mon, 7 Nov 2011 09:52:17 -0800
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A508D@HQMAIL01.nvidia.com>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E83@HQMAIL01.nvidia.com>
 <4EB4EFC0.1060702@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"Olof Johansson (olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org)" <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>,
	"Colin Cross (ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org)" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
To: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EB4EFC0.1060702-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Varun Wadekar wrote at Saturday, November 05, 2011 2:12 AM:
> >> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > Don't you need to call request_mem_region() between get_resource() and
> > ioremap()?
> 
> I am remapping the module register space. Used IORESOURCE_IO instead.

But you should be using IORESOURCE_MEM; that's what it is, and that's what
all the other entries in arch/arm/mach-tegra/devices.c use.

And I don't think simply changing the type of the resource would remove
the need to request that region of MEM or IO space.

> >> +	/* Initialize the vde clock */
> >> +	dd->aes_clk = clk_get(dev, "vde");
> > That clock doesn't exist in the mainline kernel; "bsev" exists for device
> > "tegra-aes"...
> 
> We need to use the "vde" clock. I will submit a patch to add the "vde"
> clock. "bsev" might not be needed at the moment.

> [from another email by Varun]
> Just checked and we have "vde" as a duplicate clock for "tegra-aes"

Ah right, I do see the CLK_DUPLICATE line. So, this is probably fine.

> >> +	err = clk_set_rate(dd->aes_clk, ULONG_MAX);
> > That's a little fast... What rate should it be running at. Is this
> > something the driver should be configuring, or should the board file or
> > device-tree be configuring this?
> 
> We need to run the hardware at the highest speed. AFAIK,
> clk_set_rate(ULONG_MAX) will set the clock rate at the max clock
> specified for the clock. Need to get every bit of performance from that
> piece of hardware.

Hmmm. This still seems wrong. Hopefully somebody else more familiar with
clocks will chime in either saying this is fine, or pointing out a better
way to do this.

> >> +static struct platform_driver tegra_aes_driver = {
> >> +	.probe  = tegra_aes_probe,
> >> +	.remove = __devexit_p(tegra_aes_remove),
> >> +	.driver = {
> >> +		.name   = "tegra-aes",
> >> +		.owner  = THIS_MODULE,
> >> +	},
> >> +};
> >>
> > Can you please allow instantiation from device-tree too; see drivers/
> > gpio/gpio-tegra.c's tegra_gpio_of_match[] for an example.
> 
> Actually, I am planning to add complete device tree support in the next
> patch. But if you insist, I can add partial support here and then
> complete it in the next patch.

Why not just add complete device-tree support from the start? Since this
driver uses no platform data, isn't the of match table the /only/ device-
tree support this driver needs?

-- 
nvpublic
