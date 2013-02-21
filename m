From: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 15:18:36 +0100
Message-ID: <CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
	<201302211259.26763.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernel@pengutronix.de, herbert@gondor.apana.org.au,
	davem@davemloft.net, tony@atomide.com, swarren@nvidia.com,
	shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:33002 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3BUOSh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 09:18:37 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so7642579wer.22
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 06:18:36 -0800 (PST)
In-Reply-To: <201302211259.26763.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Arnd,

On 21 February 2013 13:59, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 21 February 2013, Javier Martin wrote:
>> This series of patches provide AES-ECB and AES-CBC support
>> for the SAHARA2 cryptographic accelerator which is inside the i.MX27 SoC.
>> It is expected that more algorithms will be supported in the future.
>>
>> For testing, a Visstrim M10 board has been used and the code related
>> to this platform has been included too.
>
> As a new device driver, this needs to be supported on the DT based imx27
> machines, while support for the individual board files seems unnecessary.
>
> How about converting the Visstrim M10 board file over to DT so you don't
> have to add any more infrastructure for imx that we will just have to
> remove again one day?

We know about the existence of DT and the constant migration process
that is taking place towards it.

Moreover we are strongly interested in converting the Visstrim SM10
platform to DT. Unfortunately, there are several issues that need to
be solved so that Visstrim M10 can be fully converted to DT:
- full SoC camera DT support
- DT support for ov7670
- pinctrl support for i.MX27

Furthermore, we have limited resources at the moment and we have to
decide priorities. But having an hybrid platform-DT support is our
next task for Visstrim M10.

However, I understand your concern about new drivers having DT
support. Maybe a good approach could be that I added compile-tested
only DT support for this driver and remove platform support for
mainline submission (although we maintain it internally in our
repositories).

What do you think?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
