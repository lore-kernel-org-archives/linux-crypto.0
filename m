From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 19:21:44 +0100
Message-ID: <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	 <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	 <20081207174435.GB1687@ioremap.net>
	 <20081207175245.2d074299@lxorguk.ukuu.org.uk>
	 <20081207175438.GA3181@ioremap.net>
	 <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
	 <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:64708 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbYLGSVs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 13:21:48 -0500
Received: by nf-out-0910.google.com with SMTP id d3so380217nfc.21
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 10:21:47 -0800 (PST)
In-Reply-To: <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 7, 2008 at 19:15, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Yes, log nowhere instead of running in a loop would be much better
>> than loading a 5:1 driver which will never exist as a module.
>
> The loop is detected and terminated.

No. Please back up what you are trying to talk about.

>> > Why is this useful - you now get failing module loads producing no
>> > diagnostics and in many case the setup just dying silently.
>>
>> It's obviously more useful than not to boot up.
>
> What makes you think it will now boot up. The loop is already detected
> and terminated. What will you do if it doesn't and you get no
> diagnostics. How will distributions debug those reports in bugzilla.

The boxes of the reporters hang! Read the bug! Please!

>> No, the pci driver will never get loaded by modprobe 5:1,
>
> Why not ? You have no idea how the other millions of Linux users have
> their module loading rules configured. A change which breaks this
> behaviour is a regression.

There is no cheap way out of the problem, it's a kernel bug, and we
will fix it - you may just delay it with your zero arguments.

Kay
