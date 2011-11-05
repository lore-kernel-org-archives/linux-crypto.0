From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] crypto: driver for tegra AES hardware
Date: Sat, 5 Nov 2011 12:58:20 +0530
Message-ID: <4EB4E594.4080309@nvidia.com>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com> <20111104135436.GA29112@mail.familie-heinold.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111104135436.GA29112-/JE64I/RTDPrEm6qDNUMlj7Snszu6STo@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Friday 04 November 2011 07:24 PM, Henning Heinold wrote:
> Hi Varun,
>
> thanks that you come up with an "official" patch for the aes-stuff.
>
> Against which tree you did test the patch?

I tested it against Linus's master branch but unfortunately, some other
changes crept inside this patch due to which you saw that compilation
errors.

> I tested it against  git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git for-next
> choose to build it as module and got the following errors:
>
> drivers/crypto/tegra-aes.c: In function 'aes_start_crypt':
> drivers/crypto/tegra-aes.c:226:13: error: 'eng' undeclared (first use in this function)
> drivers/crypto/tegra-aes.c:226:13: note: each undeclared identifier is reported only once for each function it appears in
> drivers/crypto/tegra-aes.c: In function 'aes_irq':
> drivers/crypto/tegra-aes.c:614:18: error: 'intr_err_mask' undeclared (first use in this function)
> drivers/crypto/tegra-aes.c:620:1: warning: label 'done' defined but not used
>
> Which are problems inside the driver it self, which can be easy fixed:
>
> -       aes_writel(eng, 0xFFFFFFFF, INTR_STATUS);
> +       aes_writel(dd, 0xFFFFFFFF, INTR_STATUS);
>
> -       aes_writel(dd, intr_err_mask, INTR_STATUS);
> +       aes_writel(dd, INT_ERROR_MASK, INTR_STATUS);
>
> Second problem it don't build as modul 
>
> first:
> typo in
> MODULE_LICENSE("GPLv2") it needs a space MODULE_LICENSE("GPL v2")

All the above changes will be present in my next patch.

> second:
> tegra_chip_uid function is not exported

Will submit a different patch to Olof and Stephen to get this change in
the mach-tegra tree. If you want to post the fuse changes to them
yourself, please go ahead.

> I have attched patch which fixes all the stuff besides the not used variable. 
> I did not runtime test it for 3.x kernels, but works backported to
> the 2.6.38-chromeos tree.

Thanks for your help.

> Bye Henning 
