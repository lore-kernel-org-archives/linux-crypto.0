From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Date: Thu, 30 May 2013 09:48:33 +0200
Message-ID: <CACRpkda3d9_XvqRmy0nbWyri2xC3Qst2U2Sv=UDxV4w-UxK_JQ@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-21-git-send-email-lee.jones@linaro.org>
	<20130529175741.GG21290@arwen.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Lee Jones <lee.jones@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Vinod Koul <vinod.koul@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Felipe Balbi <balbi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58663 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966777Ab3E3Hsd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 03:48:33 -0400
Received: by mail-ie0-f176.google.com with SMTP id at1so27408003iec.35
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 00:48:33 -0700 (PDT)
In-Reply-To: <20130529175741.GG21290@arwen.pp.htv.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 29, 2013 at 7:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, May 15, 2013 at 10:51:43AM +0100, Lee Jones wrote:
>> For all ux500 based platforms the maximum number of end-points are used.
>> Move this knowledge into the driver so we can relinquish the burden from
>> platform data. This also removes quite a bit of complexity from the driver
>> and will aid us when we come to enable the driver for Device Tree.
>>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: linux-usb@vger.kernel.org
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> for drivers/usb/musb
>
> Acked-by: Felipe Balbi <balbi@ti.com>

Is that only for this patch 20/39 or also 21, 22 & 23?

Poke us if we should re-send them...

Yours,
Linus Walleij
