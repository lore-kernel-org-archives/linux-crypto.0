From: Andreas WESTIN <andreas.westin@stericsson.com>
Subject: Re: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Wed, 9 May 2012 15:18:59 +0200
Message-ID: <4FAA6EC3.5090205@stericsson.com>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com> <CACRpkdaEV-vMjh-ObWuJ3AyqVZyG1QNbzOkz8OZ7E+rNaPSZUQ@mail.gmail.com> <4FAA300A.9090000@stericsson.com>	<201205091217.30631.arnd@arndb.de> <CACRpkdaR-LTcD+rsq8HbxT7uzWtazC=xJ_dkBsxeq2GvassxPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
	"lee.jones@linaro.org" <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:47590 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759027Ab2EINUJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 May 2012 09:20:09 -0400
In-Reply-To: <CACRpkdaR-LTcD+rsq8HbxT7uzWtazC=xJ_dkBsxeq2GvassxPA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2012-05-09 15:09, Linus Walleij wrote:
>>
>> How about using distinct identification strings for each version of the
>> crypto hardware? The driver should really only care about what kind
>> of device it is talking to, not which SoC it is built into.
>
> Do you mean like this (from a recent pinctrl driver):
>
> static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
> {
>          const struct platform_device_id *platid = platform_get_device_id(pdev);
>          ....
>         (Here we use that ID to control runtime codepath)
> }
>
> static const struct platform_device_id nmk_pinctrl_id[] = {
>          { "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
>          { "pinctrl-db8500", PINCTRL_NMK_DB8500 },
> };
>
> static struct platform_driver nmk_pinctrl_driver = {
>          .driver = {
>                  .owner = THIS_MODULE,
>                  .name = "pinctrl-nomadik",
>          },
>          .probe = nmk_pinctrl_probe,
>          .id_table = nmk_pinctrl_id,
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
>

No, I think Arnd is referring to the registers in the crypto hardware, 
I'm preparing a patch for that.

Regards
Andreas
