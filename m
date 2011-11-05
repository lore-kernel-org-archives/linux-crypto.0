From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] crypto: driver for tegra AES hardware
Date: Sat, 5 Nov 2011 13:41:44 +0530
Message-ID: <4EB4EFC0.1060702@nvidia.com>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E83@HQMAIL01.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E83-C7FfzLzN0UxDw2glCA4ptUEOCMrvLtNR@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> Don't you need to call request_mem_region() between get_resource() and
> ioremap()?

I am remapping the module register space. Used IORESOURCE_IO instead.

>
>
>> +	/* Initialize the vde clock */
>> +	dd->aes_clk = clk_get(dev, "vde");
> That clock doesn't exist in the mainline kernel; "bsev" exists for device
> "tegra-aes"...
>

We need to use the "vde" clock. I will submit a patch to add the "vde"
clock. "bsev" might not be needed at the moment.

>> +	err = clk_set_rate(dd->aes_clk, ULONG_MAX);
> That's a little fast... What rate should it be running at. Is this
> something the driver should be configuring, or should the board file or
> device-tree be configuring this?
>

We need to run the hardware at the highest speed. AFAIK,
clk_set_rate(ULONG_MAX) will set the clock rate at the max clock
specified for the clock. Need to get every bit of performance from that
piece of hardware.

>> +static struct platform_driver tegra_aes_driver = {
>> +	.probe  = tegra_aes_probe,
>> +	.remove = __devexit_p(tegra_aes_remove),
>> +	.driver = {
>> +		.name   = "tegra-aes",
>> +		.owner  = THIS_MODULE,
>> +	},
>> +};
> Can you please allow instantiation from device-tree too; see drivers/
> gpio/gpio-tegra.c's tegra_gpio_of_match[] for an example.

Actually, I am planning to add complete device tree support in the next
patch. But if you insist, I can add partial support here and then
complete it in the next patch.
