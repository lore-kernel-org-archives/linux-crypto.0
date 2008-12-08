From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Mon, 8 Dec 2008 04:56:10 +0100
Message-ID: <ac3eb2510812071956i3630476esf9e95a0bb7f9ca8e@mail.gmail.com>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	 <20081207160921.693f637a@lxorguk.ukuu.org.uk>
	 <20081207163151.GA31838@ioremap.net>
	 <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	 <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070939h17ef6316hea96fe89f01207a6@mail.gmail.com>
	 <20081207175118.09c633e8@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071022le85080aiea301609fa8a50b1@mail.gmail.com>
	 <34909.1228706592@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	"Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:26039 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbYLHD4M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 22:56:12 -0500
Received: by nf-out-0910.google.com with SMTP id d3so452697nfc.21
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 19:56:10 -0800 (PST)
In-Reply-To: <34909.1228706592@turing-police.cc.vt.edu>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 8, 2008 at 04:23,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 07 Dec 2008 19:22:41 +0100, Kay Sievers said:
>
>> We are _not_ loading a console driver that way, we try to load the
>> console device itself, not the driver. There is no driver for 5:1 in
>> any module.

[childish blurb removed]

> It doesn't really matter if it's a "console driver" or "the console device
> itself".  If you're in modprobe loading *any* piece of "all the stuff needed
> to make open("/dev/console") work", the last thing you want to be doing
> is opening /dev/console to complain about something not working.

Nothing in initramfs or userspace tries to load "all the stuff needed
to make open("/dev/console") work". It's the kernel itself, that tries
to resolve its own requirements.

The kernel forked binary _writes_ to /dev/console, if we like it or
not, it seems to do that, and it's arguable why it should not, or how
it should detect that it is not allowed to do that. You may just
depend on the logging of binaries to find other bugs.

The helper was called in the first place for something else, in this
case the "cryptomgr". The loop is caused entirely by the kernel
itself, if /dev/console is just accessed. There is no intentional
loading of any console driver from userspace happening here.

Kay
