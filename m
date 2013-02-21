From: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 16:23:15 +0100
Message-ID: <CACKLOr2L6DtwjAjnEYujMJyzcngG_WPgqMxKk8EYmE=_qynUMw@mail.gmail.com>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
	<201302211259.26763.arnd@arndb.de>
	<CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
	<20130221151819.GZ1906@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Arnd Bergmann <arnd@arndb.de>, kernel@pengutronix.de,
	herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
	swarren@nvidia.com, shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Sascha Hauer <s.hauer@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38431 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3BUPXR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 10:23:17 -0500
Received: by mail-wg0-f41.google.com with SMTP id ds1so631037wgb.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 07:23:15 -0800 (PST)
In-Reply-To: <20130221151819.GZ1906@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 February 2013 16:18, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Thu, Feb 21, 2013 at 03:18:36PM +0100, javier Martin wrote:
>> Hi Arnd,
>>
>> On 21 February 2013 13:59, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thursday 21 February 2013, Javier Martin wrote:
>> >> This series of patches provide AES-ECB and AES-CBC support
>> >> for the SAHARA2 cryptographic accelerator which is inside the i.MX27 SoC.
>> >> It is expected that more algorithms will be supported in the future.
>> >>
>> >> For testing, a Visstrim M10 board has been used and the code related
>> >> to this platform has been included too.
>> >
>> > As a new device driver, this needs to be supported on the DT based imx27
>> > machines, while support for the individual board files seems unnecessary.
>> >
>> > How about converting the Visstrim M10 board file over to DT so you don't
>> > have to add any more infrastructure for imx that we will just have to
>> > remove again one day?
>>
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
> For the pinctrl stuff I suggest doing what we have done for the newer
> i.MX SoCs before we had pinctrl: Match by board compatible string and
> call into the board code for using the static pinctrl tables which are
> already there. I would like to have propert pinctrl support for the
> older i.MX, but probably the motivation for writing it is quite low for
> the older SoCs.

OK, I take a look at it.

> We have a patch in the queue converting the clock lookups for i.MX27 to
> dt which should be ready for posting soon.

Great.

> Then the main road blockers should be out of the way to get rid of the
> bulk of the board code.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
