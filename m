From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Tue, 3 May 2016 15:57:15 +0200
Message-ID: <CAJU7zaKTjb9QhYP6eVyri0b9Ow_GRpqT5HgOVpNMhaEDrVA4gA@mail.gmail.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <1499137.D4Mft7n8bh@tauon.atsec.com>
 <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
 <2009968.Rf1hsrr5t0@tauon.atsec.com> <CAJU7zaL+jYCgq0RzSraCQF6hd6QtxhobkPtxt+_YqxiZ+vfkMw@mail.gmail.com>
 <20160426011137.GC28496@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:33878 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbcECN54 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 09:57:56 -0400
In-Reply-To: <20160426011137.GC28496@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 26, 2016 at 3:11 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Apr 25, 2016 at 10:23:51AM +0200, Nikos Mavrogiannopoulos wrote:
>> That's far from a solution and I wouldn't recommend to anyone doing
>> that. We cannot expect each and every program to do glibc's job. The
>> purpose of a system call like getrandom is to simplify the complex use
>> of /dev/urandom and eliminate it, not to make code handling randomness
>> in applications even worse.
> Yes, but if glibc is falling down on the job and refusing to export
> the system call (I think for political reasons; it's a Linux-only
> interface, so Hurd wouldn't have it),

I believe their main concern is that they want to protect applications
which do not check error codes of system calls, when running on a
kernel which does not provide getrandom().  That way, they have an
almost impossible task to simulate getrandom() on kernel which do not
support it.

One may agree with their concerns, but the end result is that we have
not available that system call at all, several years after it is
there.

Anyway it seems that there is some activity now, so hopefully we may
have it sometime soon:
https://sourceware.org/ml/libc-help/2016-04/msg00008.html

regards,
Nikos
