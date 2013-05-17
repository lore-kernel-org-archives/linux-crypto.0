From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Date: Fri, 17 May 2013 08:35:04 +0200
Message-ID: <CACRpkdaJ7_p=ggax2gE86ea75Da7p9xB6A6Kte36j2LZq6_TVQ@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-21-git-send-email-lee.jones@linaro.org>
	<CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
	<20130515201439.GA10141@balto.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Lee Jones <lee.jones@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Felipe Balbi <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vinod Koul <vinod.koul@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42261 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3EQGfF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 May 2013 02:35:05 -0400
Received: by mail-ie0-f180.google.com with SMTP id ar20so8187807iec.25
        for <linux-crypto@vger.kernel.org>; Thu, 16 May 2013 23:35:04 -0700 (PDT)
In-Reply-To: <20130515201439.GA10141@balto.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 10:14 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Wed, May 15, 2013 at 07:18:01PM +0200, Linus Walleij wrote:
>> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > For all ux500 based platforms the maximum number of end-points are used.
>> > Move this knowledge into the driver so we can relinquish the burden from
>> > platform data. This also removes quite a bit of complexity from the driver
>> > and will aid us when we come to enable the driver for Device Tree.
>> >
>> > Cc: Felipe Balbi <balbi@ti.com>
>> > Cc: linux-usb@vger.kernel.org
>> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> > Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> I guess this stuff is dependent on the stuff Fabio has recently sent to
>> Felipe for the ux500 musb DMA so these musb patches should
>> primarily go through his tree.
>
> Not really, I only sent some coding style fix for the dma driver, as
> almost all of my work was in the usb phy files.  I also checked my
> latest series against Lee's tree and the two seems to merge without any
> conflict, so as far as I'm concerned it's really up to you and Felipe.

OK so Felipe can merge these smallish patches to musb, fine...

The other (DMA) stuff needs to be merged together with the rest
of the DMA40 series, so here basically Felipe needs an indication
if he can ACK it so I merge it through ARM SoC without colissions
and it sounds like we can make the assumption that this will work.

Yours,
Linus Walleij
