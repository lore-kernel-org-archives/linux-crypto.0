From: Stephan Mueller <smueller@chronox.de>
Subject: Re: USB HID devices not linked to RNG
Date: Mon, 07 Sep 2015 23:09:17 +0200
Message-ID: <2343086.CRIplH0oLU@tauon.atsec.com>
References: <1735492.1FWVU9y0M8@myon.chronox.de> <1461912.H1d3XDk5sm@myon.chronox.de> <CAF8px55WFMO54uJT2kME4OauXAUCfsv2K2W1EA0ufuaVjFtXfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-input@vger.kernel.org,
	tytso@mit.edu
To: Mike Mestnik <cheako@mikemestnik.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33797 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbIGVJW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 17:09:22 -0400
In-Reply-To: <CAF8px55WFMO54uJT2kME4OauXAUCfsv2K2W1EA0ufuaVjFtXfg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 7. September 2015, 15:07:47 schrieb Mike Mestnik:

Hi Mike,

>This is just an off the wall guess.  Wouldn't such entropy already be
>collected at a lower level, like raw usb traffic?

The RNG collects data from interrupts (that also covers normal PS/2 mice and 
keyboards), block devices and HID (it hooks itself into the input layer).

So, raw USB traffic is not a source of entropy other than for the interrupts 
the base PCI traffic would generate.

What I am wondering: isn't the USB mouse/keyboard support hooking into the 
kernel's input layer?

Ciao
Stephan
