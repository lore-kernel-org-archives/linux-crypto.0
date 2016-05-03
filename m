From: tytso@mit.edu
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Tue, 3 May 2016 14:48:24 +0000
Message-ID: <20160503144824.GB11832@thunk.org>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
 <1499137.D4Mft7n8bh@tauon.atsec.com>
 <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
 <2009968.Rf1hsrr5t0@tauon.atsec.com>
 <CAJU7zaL+jYCgq0RzSraCQF6hd6QtxhobkPtxt+_YqxiZ+vfkMw@mail.gmail.com>
 <20160426011137.GC28496@thunk.org>
 <CAJU7zaKTjb9QhYP6eVyri0b9Ow_GRpqT5HgOVpNMhaEDrVA4gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJU7zaKTjb9QhYP6eVyri0b9Ow_GRpqT5HgOVpNMhaEDrVA4gA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 03, 2016 at 03:57:15PM +0200, Nikos Mavrogiannopoulos wrote:
> 
> I believe their main concern is that they want to protect applications
> which do not check error codes of system calls, when running on a
> kernel which does not provide getrandom().  That way, they have an
> almost impossible task to simulate getrandom() on kernel which do not
> support it.

The whole *point* of creating the getrandom(2) system call is that it
can't be simulated/emulated in userspace.  If it can be, then there's
no reason why the system call should exist.  This is one of the
reasons why haven't implemented mysql or TLS inside the kernel.   :-)

So if their standard is "we need to simulate getrandom(2) on a kernel
which does not have it", we'll **never** see glibc support for it.  By
definition, this is *impossible*.

What they can do is do something which is as good as you can get for
someone who is open-coding /dev/urandom support in userspace.  That
means that you won't be able to (a) tell if the urandom pool is has
been adequately initialized right after boot, (b) you will need to
somehow deal with the case where the file descriptors have been
exhausted, (c) or if you are running in a chroot where the system
administrator didn't bother to include /dev/urandom.  About the best
you can do is call abort(0), or if you want, you can let the
application author specify some kind of "I want to run in insecure
mode", via some magic glibc setting.  You could probably default this
to "true" without a huge net reduction of security, because most
application authors weren't getting this right anyway.  And then ones
who do care, can set some kind of flag saying, "I promise to check the
error return from getrandom(2) as implemented by glibc".

     	     	  	       	  	      	 - Ted
