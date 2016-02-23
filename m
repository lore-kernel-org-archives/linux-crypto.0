From: Stephan Mueller <smueller@chronox.de>
Subject: Re: 3.14.61 breaks dm disk drive encryption?
Date: Tue, 23 Feb 2016 07:22 +0100
Message-ID: <3906278.XRapvzHJ78@tauon.atsec.com>
References: <20160223061755.GA4979@release-approaches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: "J. Paul Reed" <preed@release-approaches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60030 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbcBWGWJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2016 01:22:09 -0500
In-Reply-To: <20160223061755.GA4979@release-approaches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 22. Februar 2016, 22:17:55 schrieb J. Paul Reed:

Hi J,

> Hey all,
> 
> I just upgraded from 3.14.60 to 3.14.61, and when I try to mount my
> luks-encrypted disk drives, I get an error saying the mapping couldn't be
> created and to check whether aes-xts-plain64 is compiled into the kernel;
> it is:
> 
> [preed@underworld linux-3.14.61]$ grep CRYPTO_AES .config
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> 
> This all works fine with 3.14.60 (and previous 3.14-versions), and I
> compiled .61 by copying the .config over and "make oldconfig"'ing, so I'd
> expect this to work.
> 
> I looked around for other config options I need to turn on but nothing
> popped out at me. Looking through the changelog for 3.14.61, perhaps this
> is related to the fix for 7e6978fb73 ?
> 
> I can provide more exact error messaging if it'd help, but I'd expect a
> "make oldconfig" to carry over all the options correctly, as it's done for
> the rest of the 3.14 kernels.

Please see the thread "Broken userspace in crypto in linux-4.1.8" from last 
week in this mailing list for details.
> 
> Any ideas?
> 
> thanks,
> preed


Ciao
Stephan
