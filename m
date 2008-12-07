From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 18:39:48 +0100
Message-ID: <ac3eb2510812070939h17ef6316hea96fe89f01207a6@mail.gmail.com>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	 <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207155507.GA15355@gondor.apana.org.au>
	 <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	 <20081207160921.693f637a@lxorguk.ukuu.org.uk>
	 <20081207163151.GA31838@ioremap.net>
	 <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	 <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:39052 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYLGRju (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 12:39:50 -0500
Received: by ik-out-1112.google.com with SMTP id c29so612235ika.5
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 09:39:48 -0800 (PST)
In-Reply-To: <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 7, 2008 at 18:28, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > /dev/console is a logical mapping to a device which may well be
>> > different, loaded after PCI is initialised and dependant on PCI.
>>
>> So wrong. If no driver is associated, like early, in that case, we
>> must return -ENODEV, instead of calling modprobe in a loop. It's a
>> built-in device, and it's easy to fix.
>
> You've clearly no idea how initrd even works have you ?

Not sure, if you understand the real problem. A kernel forked binary
is allowed to access /dev/console, but it triggers a kernel bug.

> If it just
> returned -ENODEV you wouldn't be able to open the console and you
> wouldn't trigger the loading of the module to get the console running. So
> you've now completely buggered the boot process.

Utter nonsense. Exactly when the driver is available shortly later,
the console will work. If it's not backed by a driver, it should not
try to load it, it will never get any driver loaded by opening it. The
kernel must handle that.

> The correct sequence is
>
>        Open device
>                Kernel issues hotplug message
>                        Hotplug script loads drivers to policy

Nonsense. The kernel calls /sbin/modprobe directly, no hotplug involved.

> The problem case you have due to initrd bugs is
>
>        Open device
>                Kernel issues hotplug message
>                        Hotplug script opens same device (BUG)

The kernel calls modprobe for something, modprobe tries to log an
error, and the kernel calls modprobe again. Bug! No hotplug involved.

>                                Kernel issues hotplug message
>                                .....
>                                Kernel detects this is stuck
>                                Kernel replies with -ENODEV/-ENXIO to try
> and rescue itself from buggy initrd scripts

Totally wrong, It never was that way.

> That is how it has worked since we first had script based module
> requesting which is some years now.

Please update your idea of hotplug and the kernel module loader, you
are on the totally wrong track.

Thanks,
Kay
