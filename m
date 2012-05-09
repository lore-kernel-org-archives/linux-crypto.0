From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Wed, 9 May 2012 13:47:10 +0000
Message-ID: <201205091347.10558.arnd@arndb.de>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com> <201205091217.30631.arnd@arndb.de> <CACRpkdaR-LTcD+rsq8HbxT7uzWtazC=xJ_dkBsxeq2GvassxPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andreas WESTIN <andreas.westin@stericsson.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
	"lee.jones@linaro.org" <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2EINr0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 May 2012 09:47:26 -0400
In-Reply-To: <CACRpkdaR-LTcD+rsq8HbxT7uzWtazC=xJ_dkBsxeq2GvassxPA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 09 May 2012, Linus Walleij wrote:
> On Wed, May 9, 2012 at 2:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > How about using distinct identification strings for each version of the
> > crypto hardware? The driver should really only care about what kind
> > of device it is talking to, not which SoC it is built into.
> 
> Do you mean like this (from a recent pinctrl driver):
> 
> static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
> {
>         const struct platform_device_id *platid = platform_get_device_id(pdev);
>         ....
>        (Here we use that ID to control runtime codepath)
> }
> 
> static const struct platform_device_id nmk_pinctrl_id[] = {
>         { "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
>         { "pinctrl-db8500", PINCTRL_NMK_DB8500 },
> };
> 
> static struct platform_driver nmk_pinctrl_driver = {
>         .driver = {
>                 .owner = THIS_MODULE,
>                 .name = "pinctrl-nomadik",
>         },
>         .probe = nmk_pinctrl_probe,
>         .id_table = nmk_pinctrl_id,
> };
> 
> Here one version of ASIC registers the "pinctrl-db8500" device.
> And so on.
> 
> So instead of registering "cryp1" and "hash1", register
> "db8500-cryp-v1", "db8500-cryp-v2" etc for the versions,
> then use the ID to control code path.
> 
> Is that what you were thinking of?

Yes, exactly.

	Arnd
