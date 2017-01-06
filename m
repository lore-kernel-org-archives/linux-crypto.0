From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: Geode LX AES/RNG driver triggers warning
Date: Fri, 6 Jan 2017 15:10:19 +0530
Message-ID: <CANc+2y7vh2U_Qrvwof8UZvJqVUL1hc3bQ5qgV-NJQnvQrmQn3Q@mail.gmail.com>
References: <A0185338-47A4-42BE-B2D4-F1EB082593E3@sigma-star.at> <20170103145203.780d3c58@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Gstir <david@sigma-star.at>, linux-geode@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        teheo@suse.de, Richard Weinberger <richard@nod.at>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170103145203.780d3c58@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> I narrowed it down to commit 6e9b5e76882c ("hwrng: geode - Migrate to managed API") which seems to introduce this. It looks to me like some issue between devres, the Geode hwrng and AES drivers which both use the same PCI device.
>
> It does
>
>> I'm no expert here, but I curious if this will cause any issues when using the hardware crypto drivers and also what's the best way to get rid of this?
>
> Probably to create an mfd device that turns the PCI device into two MFD
> devices and bind AES and hwrng one to each MFD device. Take a look in
> drivers/mfd. That would also fix the uglies in mod_init for the rng
> driver.

I am the author of that commit. Code before commit 6e9b5e76882c had
ioremap, wondering why there was no warning message before. Just want
to know if that commit uncovered existing issue or introduced a new
issue? As far as I understand the commit did not change the
functionality. Please feel free to correct if I have missed something.

Regards,
PrasannaKumar
