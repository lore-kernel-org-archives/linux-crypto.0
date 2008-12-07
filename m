From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 18:15:59 +0000
Message-ID: <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
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
	<ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52286 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752467AbYLGSPv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 13:15:51 -0500
In-Reply-To: <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Yes, log nowhere instead of running in a loop would be much better
> than loading a 5:1 driver which will never exist as a module.

The loop is detected and terminated.
> 
> > Why is this useful - you now get failing module loads producing no
> > diagnostics and in many case the setup just dying silently.
> 
> It's obviously more useful than not to boot up.

What makes you think it will now boot up. The loop is already detected
and terminated. What will you do if it doesn't and you get no
diagnostics. How will distributions debug those reports in bugzilla.

> No, the pci driver will never get loaded by modprobe 5:1,

Why not ? You have no idea how the other millions of Linux users have
their module loading rules configured. A change which breaks this
behaviour is a regression.

Alan
