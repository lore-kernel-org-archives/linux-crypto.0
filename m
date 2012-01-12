From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 1/2] arm: tegra: export tegra_chip_uid
Date: Thu, 12 Jan 2012 16:09:51 +0530
Message-ID: <4F0EB877.2050407@nvidia.com>
References: <1324034755-3295-1-git-send-email-vwadekar@nvidia.com> <1324034755-3295-2-git-send-email-vwadekar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>,
	<herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
To: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324034755-3295-2-git-send-email-vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add Herbert and David

On Friday 16 December 2011 04:55 PM, Varun Wadekar wrote:
> From: Henning Heinold<heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
>
> The crypto driver will need this api to use
> it in the RNG calculations. In order to build
> the crypto driver as a module, tegra_chip_uid
> has to be exported.
>
> Acked-by: Olof Johansson<olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
> Signed-off-by: Henning Heinold<heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
> Signed-off-by: Varun Wadekar<vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> ---
>   arch/arm/mach-tegra/fuse.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
> index 1fa26d9..ea49bd9 100644
> --- a/arch/arm/mach-tegra/fuse.c
> +++ b/arch/arm/mach-tegra/fuse.c
> @@ -19,6 +19,7 @@
>
>   #include<linux/kernel.h>
>   #include<linux/io.h>
> +#include<linux/module.h>
>
>   #include<mach/iomap.h>
>
> @@ -58,6 +59,7 @@ unsigned long long tegra_chip_uid(void)
>   	hi = fuse_readl(FUSE_UID_HIGH);
>   	return (hi<<  32ull) | lo;
>   }
> +EXPORT_SYMBOL(tegra_chip_uid);
>
>   int tegra_sku_id(void)
>   {
