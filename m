From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 19:30:01 +0200
Message-ID: <3163610.mmC4VCYNt8@tauon.atsec.com>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com> <CAH8yC8mibb90J2rkD_YzM2X1HsNuHEOLbV7Wntq39dMxH4KCnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34840 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbcEZRaG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 13:30:06 -0400
In-Reply-To: <CAH8yC8mibb90J2rkD_YzM2X1HsNuHEOLbV7Wntq39dMxH4KCnQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. Mai 2016, 13:25:02 schrieb Jeffrey Walton:

Hi Jeffrey,

> > What I am wondering is that when encrypting 256 16 byte blocks, I get a
> > speed of about 170 MB/s with the AES-NI driver. When using the
> > aes-generic or aes- asm, I get up to 180 MB/s with all else being equal.
> > Note, that figure includes a copy_to_user of the generated data.
> > 
> > ...
> 
> Something sounds amiss.
> 
> AES-NI should be on the order of magnitude faster than a generic
> implementation. Can you verify AES-NI is actually using AES-NI, and
> aes-generic is a software implementation?

I am pretty sure I am using the right implementations as I checked the 
refcount in /proc/crypto.
> 
> Here are some OpenSSL numbers. EVP uses AES-NI when available.
> Omitting -evp means its software only (no hardware acceleration, like
> AES-NI).

I understand that AES-NI should be faster. That is what I am wondering about.

However, the key difference to a standard speed test is that I set up a new 
key schedule quite frequently. And I would suspect that something is going on 
here...

Ciao
Stephan
