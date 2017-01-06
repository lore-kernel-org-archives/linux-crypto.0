From: David Gstir <david@sigma-star.at>
Subject: Re: Geode LX AES/RNG driver triggers warning
Date: Fri, 6 Jan 2017 14:19:47 +0100
Message-ID: <64A110A1-433C-4903-BDA0-E9E7F9B476CC@sigma-star.at>
References: <A0185338-47A4-42BE-B2D4-F1EB082593E3@sigma-star.at> <20170103145203.780d3c58@lxorguk.ukuu.org.uk> <CANc+2y7vh2U_Qrvwof8UZvJqVUL1hc3bQ5qgV-NJQnvQrmQn3Q@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, teheo@suse.de,
        Richard Weinberger <richard@nod.at>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033941AbdAFNUd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2017 08:20:33 -0500
In-Reply-To: <CANc+2y7vh2U_Qrvwof8UZvJqVUL1hc3bQ5qgV-NJQnvQrmQn3Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PrasannaKumar,

> On 06.01.2017, at 10:40, PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com> wrote:
> 
>>> I narrowed it down to commit 6e9b5e76882c ("hwrng: geode - Migrate to managed API") which seems to introduce this. It looks to me like some issue between devres, the Geode hwrng and AES drivers which both use the same PCI device.
>> 
>> It does
>> 
>>> I'm no expert here, but I curious if this will cause any issues when using the hardware crypto drivers and also what's the best way to get rid of this?
>> 
>> Probably to create an mfd device that turns the PCI device into two MFD
>> devices and bind AES and hwrng one to each MFD device. Take a look in
>> drivers/mfd. That would also fix the uglies in mod_init for the rng
>> driver.
> 
> I am the author of that commit. Code before commit 6e9b5e76882c had
> ioremap, wondering why there was no warning message before. Just want
> to know if that commit uncovered existing issue or introduced a new
> issue? As far as I understand the commit did not change the
> functionality. Please feel free to correct if I have missed something.

This warning is because commit 6e9b5e76882c introduces devres (devm_ioremap vs ioremap). As soon as I have some spare time, I'll look into resolving this via MFD like Alan suggested.

Thanks,
-David
