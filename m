From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Tue, 3 May 2016 18:20:57 +0200
Message-ID: <CAJU7zaLn6KCWjMTVmtS=NKsnBM7qbRf3Wf0Tpyxhi0Ctr6GqyA@mail.gmail.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <1499137.D4Mft7n8bh@tauon.atsec.com>
 <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
 <2009968.Rf1hsrr5t0@tauon.atsec.com> <CAJU7zaL+jYCgq0RzSraCQF6hd6QtxhobkPtxt+_YqxiZ+vfkMw@mail.gmail.com>
 <20160426011137.GC28496@thunk.org> <CAJU7zaKTjb9QhYP6eVyri0b9Ow_GRpqT5HgOVpNMhaEDrVA4gA@mail.gmail.com>
 <20160503144824.GB11832@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:33290 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbcECQVi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 12:21:38 -0400
In-Reply-To: <20160503144824.GB11832@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 3, 2016 at 4:48 PM,  <tytso@mit.edu> wrote:
> On Tue, May 03, 2016 at 03:57:15PM +0200, Nikos Mavrogiannopoulos wrote:
>> I believe their main concern is that they want to protect applications
>> which do not check error codes of system calls, when running on a
>> kernel which does not provide getrandom().  That way, they have an
>> almost impossible task to simulate getrandom() on kernel which do not
>> support it.
>
> The whole *point* of creating the getrandom(2) system call is that it
> can't be simulated/emulated in userspace.  If it can be, then there's
> no reason why the system call should exist.  This is one of the
> reasons why haven't implemented mysql or TLS inside the kernel.   :-)
> So if their standard is "we need to simulate getrandom(2) on a kernel
> which does not have it", we'll **never** see glibc support for it.  By
> definition, this is *impossible*.

I know, and I share this opinion. To their defense they will have to
provide a call which doesn't make applications fail in the following
scenario:
1. crypto/ssl libraries are compiled to use getrandom() because it is
available in libc and and in kernel
2. everything works fine
3. the administrator downgrades the kernel to a version without
getrandom() because his network card works better with that version
4. Mayhem as applications fail

However I don't see a way to avoid issues - though limited to corner
cases - with any imperfect emulation. It would be much clear for glibc
to just require a kernel with getrandom().

regards,
Nikos
