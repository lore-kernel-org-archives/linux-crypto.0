From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] nvmem: sunxi-sid: SID content is not a valid source of
 randomness
Date: Thu, 10 Nov 2016 16:14:34 +0100
Message-ID: <20161110151434.GA1209@Red>
References: <1477144408-15896-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161024201020.h6akyqad2o42xkhq@lukather>
 <20161025053855.GA901@Red>
 <20161025132648.txeo3rw6yz5wutrg@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: srinivas.kandagatla@linaro.org, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33848 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933838AbcKJPOj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2016 10:14:39 -0500
Content-Disposition: inline
In-Reply-To: <20161025132648.txeo3rw6yz5wutrg@lukather>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 25, 2016 at 03:26:48PM +0200, Maxime Ripard wrote:
> On Tue, Oct 25, 2016 at 07:38:55AM +0200, LABBE Corentin wrote:
> > On Mon, Oct 24, 2016 at 10:10:20PM +0200, Maxime Ripard wrote:
> > > On Sat, Oct 22, 2016 at 03:53:28PM +0200, Corentin Labbe wrote:
> > > > Since SID's content is constant over reboot,
> > > 
> > > That's not true, at least not across all the Allwinner SoCs, and
> > > especially not on the A10 and A20 that this driver supports.
> > > 
> > 
> > On my cubieboard2 (A20)
> > hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eeprom/sunxi-sid0/nvmem 
> > 00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000200
> > cubiedev ~ # reboot
> > cubiedev ~ # hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eeprom/sunxi-sid0/nvmem 
> > 00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000200
> > 
> > So clearly for me its constant.
> 
> It's constant across reboots, but not across devices. Each device have
> a different SID content, therefore it's a relevant source of entropy
> in the system.
> 

Not the 3 leading digit and not the tailing zeros which are the same accross device.
So only 50% of data are really different accross devices.
Perhaps a "random-range" property could be used ?

Herbert, does it is safe to add that 50% duplicate content via add_device_randomness() ?
Reading add_device_randomness doc, it seems finally it is safe, but if you could confirm it.

Regards
