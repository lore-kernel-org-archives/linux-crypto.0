From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Geode LX AES/RNG driver triggers warning
Date: Tue, 3 Jan 2017 14:52:03 +0000
Message-ID: <20170103145203.780d3c58@lxorguk.ukuu.org.uk>
References: <A0185338-47A4-42BE-B2D4-F1EB082593E3@sigma-star.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, teheo@suse.de,
        prasannatsmkumar@gmail.com, Richard Weinberger <richard@nod.at>
To: David Gstir <david@sigma-star.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38986 "EHLO
        lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757212AbdACOws (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2017 09:52:48 -0500
In-Reply-To: <A0185338-47A4-42BE-B2D4-F1EB082593E3@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 31 Dec 2016 00:58:54 +0100
David Gstir <david@sigma-star.at> wrote:

> Hi!
> 
> I recently tested kernel v4.9 on my AMD Geode platform and noticed that its AES hardware driver triggers this warning on initialization:

...

> I narrowed it down to commit 6e9b5e76882c ("hwrng: geode - Migrate to managed API") which seems to introduce this. It looks to me like some issue between devres, the Geode hwrng and AES drivers which both use the same PCI device.

It does

> I'm no expert here, but I curious if this will cause any issues when using the hardware crypto drivers and also what's the best way to get rid of this?

Probably to create an mfd device that turns the PCI device into two MFD
devices and bind AES and hwrng one to each MFD device. Take a look in
drivers/mfd. That would also fix the uglies in mod_init for the rng
driver.

Alan
