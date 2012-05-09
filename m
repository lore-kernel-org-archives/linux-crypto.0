From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Wed, 9 May 2012 15:09:48 +0200
Message-ID: <CACRpkdaR-LTcD+rsq8HbxT7uzWtazC=xJ_dkBsxeq2GvassxPA@mail.gmail.com>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com>
	<CACRpkdaEV-vMjh-ObWuJ3AyqVZyG1QNbzOkz8OZ7E+rNaPSZUQ@mail.gmail.com>
	<4FAA300A.9090000@stericsson.com>
	<201205091217.30631.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas WESTIN <andreas.westin@stericsson.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
	"lee.jones@linaro.org" <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51389 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab2EINJt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 May 2012 09:09:49 -0400
Received: by yenm10 with SMTP id m10so225053yen.19
        for <linux-crypto@vger.kernel.org>; Wed, 09 May 2012 06:09:49 -0700 (PDT)
In-Reply-To: <201205091217.30631.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 9, 2012 at 2:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 09 May 2012, Andreas WESTIN wrote:
>> On 2012-05-09 10:36, Linus Walleij wrote:
>> >> This needs an explanation! Why do you export an internal data structure
>> >> to non-GPL modules?
>> >
>> > This does not look like it's needed at all, none of the other two patches use
>> > it. Andreas can you just drop this hunk of the patch?
>>
>> It is needed if you compile the drivers as modules, but it should be a
>> GPL export. I will change it.
>
> How about using distinct identification strings for each version of the
> crypto hardware? The driver should really only care about what kind
> of device it is talking to, not which SoC it is built into.

Do you mean like this (from a recent pinctrl driver):

static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
{
        const struct platform_device_id *platid = platform_get_device_id(pdev);
        ....
       (Here we use that ID to control runtime codepath)
}

static const struct platform_device_id nmk_pinctrl_id[] = {
        { "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
        { "pinctrl-db8500", PINCTRL_NMK_DB8500 },
};

static struct platform_driver nmk_pinctrl_driver = {
        .driver = {
                .owner = THIS_MODULE,
                .name = "pinctrl-nomadik",
        },
        .probe = nmk_pinctrl_probe,
        .id_table = nmk_pinctrl_id,
};

Here one version of ASIC registers the "pinctrl-db8500" device.
And so on.

So instead of registering "cryp1" and "hash1", register
"db8500-cryp-v1", "db8500-cryp-v2" etc for the versions,
then use the ID to control code path.

Is that what you were thinking of?

That might be a good idea, however it requires some changes to patches
earlier in the series (but can be done as an incremental add-on of
course).

Yours,
Linus Walleij
