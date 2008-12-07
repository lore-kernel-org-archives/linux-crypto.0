From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 18:03:02 +0000
Message-ID: <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<20081207163151.GA31838@ioremap.net>
	<20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	<ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	<20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	<20081207174435.GB1687@ioremap.net>
	<20081207175245.2d074299@lxorguk.ukuu.org.uk>
	<20081207175438.GA3181@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41363 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752565AbYLGSC4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 13:02:56 -0500
In-Reply-To: <20081207175438.GA3181@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 7 Dec 2008 20:54:38 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Sun, Dec 07, 2008 at 05:52:45PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > Alan, let's make some progress on this fingerpointing. If Herbert's
> > > patch fixes the crypto loading problem, it will find its way upstream
> > > for the current tree, and in the merge window Kay's patch may be applied
> > > and widely tested. Thoughts?
> > 
> > I have no intention of applying Kay's patch because it is wrong and it
> > will only break things not fix them.
> 
> And you are sure it breaks something based on what?


Firstly:

You propose to implement

		modprobe fails (due to crypto requirements)
		open /dev/console
			-ENODEV
		log error to nowhere


Why is this useful - you now get failing module loads producing no
diagnostics and in many case the setup just dying silently. Previously
you got an attempt to recover and diagnostics which allowed the problem
to be found (as Herbert did)

Secondly:

If I have a /dev/console on a PCI device and I have modprobe set to load
8250_pci or a framebuffer driver when the console is opened you will
break the current working behaviour.

