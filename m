From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] ARM: wire up HWCAP2 feature bits to the CPU modalias
Date: Wed, 4 Jan 2017 16:42:32 +0000
Message-ID: <CAKv+Gu8nKFYBarBgy16xgR35eMYdYipxtnGmMOOWWh4ekXnmfw@mail.gmail.com>
References: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476787939-21889-2-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu_y7e=sJT+7FNj846NczgpNOdVx53SDC7dupmN-3ztNwA@mail.gmail.com>
 <20161031161319.GF1041@n2100.armlinux.org.uk> <CAKv+Gu-hLD0xnLyywceJvPiB8ZkENNwWZTM--OHFvzw6MahYmw@mail.gmail.com>
 <20170102234013.GK14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@linaro.org>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33085 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031514AbdADQnK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Jan 2017 11:43:10 -0500
Received: by mail-io0-f175.google.com with SMTP id d9so458035976ioe.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Jan 2017 08:42:33 -0800 (PST)
In-Reply-To: <20170102234013.GK14217@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 January 2017 at 23:40, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Mon, Jan 02, 2017 at 09:06:04PM +0000, Ard Biesheuvel wrote:
>> On 31 October 2016 at 16:13, Russell King - ARM Linux
>> <linux@armlinux.org.uk> wrote:
>> > On Sat, Oct 29, 2016 at 11:08:36AM +0100, Ard Biesheuvel wrote:
>> >> On 18 October 2016 at 11:52, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> >> > Wire up the generic support for exposing CPU feature bits via the
>> >> > modalias in /sys/device/system/cpu. This allows udev to automatically
>> >> > load modules for things like crypto algorithms that are implemented
>> >> > using optional instructions.
>> >> >
>> >> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> >> > ---
>> >> >  arch/arm/Kconfig                  |  1 +
>> >> >  arch/arm/include/asm/cpufeature.h | 32 ++++++++++++++++++++
>> >> >  2 files changed, 33 insertions(+)
>> >> >
>> >>
>> >> Russell,
>> >>
>> >> do you have any concerns regarding this patch? If not, I will drop it
>> >> into the patch system.
>> >
>> > It's still something I need to look at... I've been offline last week,
>> > and sort-of offline the previous week, so I'm catching up.
>> >
>>
>> Hi Russell,
>>
>> Any thoughts yet?
>
> None, and the patch is well buried now that it'll take me a while to
> find... back in mid-October?  Yea, I'll have to drop everything and
> go digging through my mailboxes to find it... and I'm just catching
> up (again) after a week and a bit's time offline - yep, it's wonderful
> timing.  Sorry, no time to look at it right now, you're not the only
> one wanting my attention at the moment.
>

No worries. It is not exactly urgent, but it is a useful enhancement
nonetheless.

> Please try again in about a week's time - don't leave it a few months,
> and please include the patch.
>

OK
