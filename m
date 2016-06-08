From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AES-NI: slower than aes-generic?
Date: Wed, 08 Jun 2016 14:21:10 +0200
Message-ID: <1589442.qtzhyGZuyR@positron.chronox.de>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com> <4972668.UQ1QRNriDb@positron.chronox.de> <20160527021429.GA21331@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36082 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422766AbcFHMVN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 08:21:13 -0400
In-Reply-To: <20160527021429.GA21331@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. Mai 2016, 22:14:29 schrieb Theodore Ts'o:

Hi Theodore,

> On Thu, May 26, 2016 at 08:49:39PM +0200, Stephan Mueller wrote:
> > Using the kernel crypto API one can relieve the CPU of the crypto work, if
> > a hardware or assembler implementation is available. This may be of
> > particular interest for smaller systems. So, for smaller systems (where
> > kernel bloat is bad, but where now these days more and more hardware
> > crypto support is added), we must weigh the kernel bloat (of 3 or 4
> > additional C files for the basic kernel crypto API logic) against
> > relieving the CPU of work.
> 
> There are a number of caveats with using hardware acceleration; one is
> that many hardware accelerators are optimized for bulk data
> encryption, and so key scheduling, or switching between key schedules,
> can have a higher overhead that a pure software implementation.

As a followup: I tweaked the DRBG side a bit to use the full speed of the AES-
NI implementation. With that tweak, the initial finding does not apply any 
more.

I depending on the request size, I now get more than 800 MB/s (increase by 
more than 450% compared to the initial implementation) from the AES-NI 
implementation. Hence, the frequent key schedule update seems to be not too 
much of an issue.

Ciao
Stephan
