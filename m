From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Mon, 25 Apr 2016 21:11:37 -0400
Message-ID: <20160426011137.GC28496@thunk.org>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
 <1499137.D4Mft7n8bh@tauon.atsec.com>
 <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
 <2009968.Rf1hsrr5t0@tauon.atsec.com>
 <CAJU7zaL+jYCgq0RzSraCQF6hd6QtxhobkPtxt+_YqxiZ+vfkMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39392 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbcDZBLn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 21:11:43 -0400
Content-Disposition: inline
In-Reply-To: <CAJU7zaL+jYCgq0RzSraCQF6hd6QtxhobkPtxt+_YqxiZ+vfkMw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 25, 2016 at 10:23:51AM +0200, Nikos Mavrogiannopoulos wrote:
> That's far from a solution and I wouldn't recommend to anyone doing
> that. We cannot expect each and every program to do glibc's job. The
> purpose of a system call like getrandom is to simplify the complex use
> of /dev/urandom and eliminate it, not to make code handling randomness
> in applications even worse.

Yes, but if glibc is falling down on the job and refusing to export
the system call (I think for political reasons; it's a Linux-only
interface, so Hurd wouldn't have it), then the only solution is to
either use syscall directly (it's not hard for getrandom, since we're
not using 64-bit arguments which gets tricky for some architectures),
or as Peter Avin has suggested, maybe kernel developers will have to
start releasing the libinux library, and then teaching application
authors to add -linux to their linker lines.

						- Ted
