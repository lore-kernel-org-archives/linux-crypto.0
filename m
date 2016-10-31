From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/5] ARM: wire up HWCAP2 feature bits to the CPU modalias
Date: Mon, 31 Oct 2016 16:13:19 +0000
Message-ID: <20161031161319.GF1041@n2100.armlinux.org.uk>
References: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476787939-21889-2-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu_y7e=sJT+7FNj846NczgpNOdVx53SDC7dupmN-3ztNwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60646 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756881AbcJaQN1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 12:13:27 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_y7e=sJT+7FNj846NczgpNOdVx53SDC7dupmN-3ztNwA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 29, 2016 at 11:08:36AM +0100, Ard Biesheuvel wrote:
> On 18 October 2016 at 11:52, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > Wire up the generic support for exposing CPU feature bits via the
> > modalias in /sys/device/system/cpu. This allows udev to automatically
> > load modules for things like crypto algorithms that are implemented
> > using optional instructions.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/arm/Kconfig                  |  1 +
> >  arch/arm/include/asm/cpufeature.h | 32 ++++++++++++++++++++
> >  2 files changed, 33 insertions(+)
> >
> 
> Russell,
> 
> do you have any concerns regarding this patch? If not, I will drop it
> into the patch system.

It's still something I need to look at... I've been offline last week,
and sort-of offline the previous week, so I'm catching up.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
