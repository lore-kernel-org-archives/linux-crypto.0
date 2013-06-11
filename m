From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 05/39] ARM: ux500: Stop passing MMC's platform data for
 Device Tree boots
Date: Tue, 11 Jun 2013 11:31:45 +0200
Message-ID: <CACRpkdbkyMF4brGYr2c4=NuTLN20pHsBM=227-mFAPv7S+Ac7w@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-6-git-send-email-lee.jones@linaro.org>
	<CACRpkdbOxzhgR=ugXLrSBJ_Y1rw=0mcrvtuRi=-c5v039xsPWA@mail.gmail.com>
	<20130610091503.GF20297@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Felipe Balbi <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vinod Koul <vinod.koul@intel.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:50771 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3FKJbq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Jun 2013 05:31:46 -0400
Received: by mail-oa0-f48.google.com with SMTP id f4so3400903oah.21
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2013 02:31:46 -0700 (PDT)
In-Reply-To: <20130610091503.GF20297@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 10, 2013 at 11:15 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 15 May 2013, Linus Walleij wrote:
>
>> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > It was required to pass DMA channel configuration information to the
>> > MMC driver before the new DMA API was in place. Now that it is, and
>> > is fully compatible with Device Tree we can stop doing that.
>> >
>> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> So since the use of dma_request_slave_channel() is not upstream,
>> I guess this will break DMA use (i.e slow down transfers!) on all
>> device tree boots?
>>
>> I'd be happy to apply it once the MMCI patch is in linux-next
>> indicating there may just be a window in the merge period
>> where it falls back to IRQ mode, but I don't want to disable
>> DMA on DT boots for an entire kernel cycle just like that.
>>
>> Not applied as of yet.
>
> I believe it's now okay to apply this.

Yep, I've rebased and applied it to the ux500-devicetree
branch.

I have some stuff on this branch which is queued up but may
miss v3.11, because I need the 5 outstanding pull requests
to land in ARM SoC so I get a merge base there before I
can send any more stuff.

It's mainly because this stuff isn't any orthogonal, everything
just conflicts in the AUXDATA all the time.

Yours,
Linus Walleij
