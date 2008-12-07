From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 19:13:13 +0100
Message-ID: <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207160921.693f637a@lxorguk.ukuu.org.uk>
	 <20081207163151.GA31838@ioremap.net>
	 <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	 <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	 <20081207174435.GB1687@ioremap.net>
	 <20081207175245.2d074299@lxorguk.ukuu.org.uk>
	 <20081207175438.GA3181@ioremap.net>
	 <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:63411 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYLGSNP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 13:13:15 -0500
Received: by nf-out-0910.google.com with SMTP id d3so379116nfc.21
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 10:13:13 -0800 (PST)
In-Reply-To: <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 7, 2008 at 19:03, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 7 Dec 2008 20:54:38 +0300
> Evgeniy Polyakov <zbr@ioremap.net> wrote:
>
>> On Sun, Dec 07, 2008 at 05:52:45PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
>> > > Alan, let's make some progress on this fingerpointing. If Herbert's
>> > > patch fixes the crypto loading problem, it will find its way upstream
>> > > for the current tree, and in the merge window Kay's patch may be applied
>> > > and widely tested. Thoughts?
>> >
>> > I have no intention of applying Kay's patch because it is wrong and it
>> > will only break things not fix them.
>>
>> And you are sure it breaks something based on what?
>
>
> Firstly:
>
> You propose to implement
>
>                modprobe fails (due to crypto requirements)
>                open /dev/console
>                        -ENODEV
>                log error to nowhere

Yes, log nowhere instead of running in a loop would be much better
than loading a 5:1 driver which will never exist as a module.

> Why is this useful - you now get failing module loads producing no
> diagnostics and in many case the setup just dying silently.

It's obviously more useful than not to boot up.

> Previously
> you got an attempt to recover and diagnostics which allowed the problem
> to be found (as Herbert did)
>
> Secondly:
>
> If I have a /dev/console on a PCI device and I have modprobe set to load
> 8250_pci or a framebuffer driver when the console is opened you will
> break the current working behaviour.

No, the pci driver will never get loaded by modprobe 5:1, that's all
what this bug is about. It connects to the existing console device
when the driver is loaded, and at that moment /dev/console gets
working.

Kay
