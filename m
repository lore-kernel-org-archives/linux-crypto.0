From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Wed, 9 May 2012 10:36:58 +0200
Message-ID: <CACRpkdaEV-vMjh-ObWuJ3AyqVZyG1QNbzOkz8OZ7E+rNaPSZUQ@mail.gmail.com>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com>
	<1336476513-17145-2-git-send-email-andreas.westin@stericsson.com>
	<201205081937.24450.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Westin <andreas.westin@stericsson.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, sfr@canb.auug.org.au,
	lee.jones@linaro.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53405 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2EIIg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 May 2012 04:36:59 -0400
Received: by gglu4 with SMTP id u4so7235ggl.19
        for <linux-crypto@vger.kernel.org>; Wed, 09 May 2012 01:36:58 -0700 (PDT)
In-Reply-To: <201205081937.24450.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 8, 2012 at 9:37 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 08 May 2012, Andreas Westin wrote:
>> This adds the required platform data and calls to enable
>> the CRYP/HASH driver.
>>
>> index 15a0f63..a69db46 100644
>> --- a/arch/arm/mach-ux500/id.c
>> +++ b/arch/arm/mach-ux500/id.c
>> @@ -17,7 +17,10 @@
>> =A0#include <mach/hardware.h>
>> =A0#include <mach/setup.h>
>>
>> +#include <linux/module.h>
>> +
>> =A0struct dbx500_asic_id dbx500_id;
>> +EXPORT_SYMBOL(dbx500_id);
>>
>> =A0static unsigned int ux500_read_asicid(phys_addr_t addr)
>> =A0{
>
> This needs an explanation! Why do you export an internal data structu=
re
> to non-GPL modules?

This does not look like it's needed at all, none of the other two patch=
es use
it. Andreas can you just drop this hunk of the patch?

BTW if the asic variant is needed by some driver use cpu_is_*() from
<mach/id.h> or pass a flag in platform data or something.

> On a more general topic, I wonder if it's really necessary to add new
> devices to the legacy probing path in mach-ux500. Why not make new dr=
ivers
> for this platform dt-only, so we don't need to add code now that we w=
ill
> have to remove again in one or two kernel releases?

This is a simple platform_device which means that its IRQ/PIO mode is
already supported with standard bindings if you instantiate the device
from drivers/of/platform.c using the generic bindings for platform devi=
ces
and their resources.

The only thing that is passed in platform data, as you can see is the
DMA channels and configuration, which is debated elsewhere I
think. The day we know how to pass DMA channels to any platform/amba
device this device should be trivial to fully support with DT.

Yours,
Linus Walleij
