From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] nvmem: sunxi-sid: SID content is not a valid source of
 randomness
Date: Tue, 25 Oct 2016 07:38:55 +0200
Message-ID: <20161025053855.GA901@Red>
References: <1477144408-15896-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161024201020.h6akyqad2o42xkhq@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: srinivas.kandagatla@linaro.org, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34373 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754713AbcJYFjA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2016 01:39:00 -0400
Content-Disposition: inline
In-Reply-To: <20161024201020.h6akyqad2o42xkhq@lukather>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 24, 2016 at 10:10:20PM +0200, Maxime Ripard wrote:
> On Sat, Oct 22, 2016 at 03:53:28PM +0200, Corentin Labbe wrote:
> > Since SID's content is constant over reboot,
> 
> That's not true, at least not across all the Allwinner SoCs, and
> especially not on the A10 and A20 that this driver supports.
> 

On my cubieboard2 (A20)
hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eeprom/sunxi-sid0/nvmem 
00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200
cubiedev ~ # reboot
cubiedev ~ # hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eeprom/sunxi-sid0/nvmem 
00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200

So clearly for me its constant.

> > it must not be used as source of randomness.
> 
> And I don't think that's true either. A constant entropy provider will
> not add any entropy, but will not remove any, would it?

I cced linux-crypto at the begining for confirmation on that.
But the problem is increased as a part of the content is predicatable over same type of device (at least the thirst bytes and all the zeros).
