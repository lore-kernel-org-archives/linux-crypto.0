From: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 15:57:31 +0100
Message-ID: <CACKLOr1nqbuAS_9oQ1XEO-LK-YnNsnEpVy6-UHag2cm5K04hMg@mail.gmail.com>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
	<201302211259.26763.arnd@arndb.de>
	<CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
	<201302211440.59577.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernel@pengutronix.de, herbert@gondor.apana.org.au,
	davem@davemloft.net, tony@atomide.com, swarren@nvidia.com,
	shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60740 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3BUO5e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 09:57:34 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so7481687wgb.35
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 06:57:33 -0800 (PST)
In-Reply-To: <201302211440.59577.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 February 2013 15:40, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 21 February 2013, javier Martin wrote:
>> We know about the existence of DT and the constant migration process
>> that is taking place towards it.
>>
>> Moreover we are strongly interested in converting the Visstrim SM10
>> platform to DT. Unfortunately, there are several issues that need to
>> be solved so that Visstrim M10 can be fully converted to DT:
>> - full SoC camera DT support
>> - DT support for ov7670
>> - pinctrl support for i.MX27
>
> Ok, I see. Full device tree support is certainly asking too much then.
>
>> Furthermore, we have limited resources at the moment and we have to
>> decide priorities. But having an hybrid platform-DT support is our
>> next task for Visstrim M10.
>
> Ok, cool.
>
>> However, I understand your concern about new drivers having DT
>> support. Maybe a good approach could be that I added compile-tested
>> only DT support for this driver and remove platform support for
>> mainline submission (although we maintain it internally in our
>> repositories).
>>
>> What do you think?
>
> Sounds good. Since it sounds like the hardware is available in all
> imx27 device, maybe someone else can test your driver on an imx27
> board that already has partial DT support when you add it to
> arch/arm/boot/dts/imx27.dtsi?

Yes, since the module is integrated in i.MX27 that seems the way to go.

> Is there any reason why an imx27 based board would not support this
> driver? Are there any other chips that could use it, e.g. imx25 or
> imx6?

No, there's no reason for an i.mx27 board not to support this driver
since the module doesn't have any external interfaces.

I think other i.MX chips have similar devices but I am not sure to
what extent they are compatible or not. Probably Sascha Hauer or Shawn
Guo (already in CC) could tell better than me since they have a wider
view on the i.MX range.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
