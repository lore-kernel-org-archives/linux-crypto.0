From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Mon, 25 Apr 2016 10:23:51 +0200
Message-ID: <CAJU7zaL+jYCgq0RzSraCQF6hd6QtxhobkPtxt+_YqxiZ+vfkMw@mail.gmail.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <1499137.D4Mft7n8bh@tauon.atsec.com>
 <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com> <2009968.Rf1hsrr5t0@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ted Tso <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2009968.Rf1hsrr5t0@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 25, 2016 at 10:02 AM, Stephan Mueller <smueller@chronox.de> wrote:
>> > One more item to consider: If you do not want to change to use
>> > getrandom(2), the LRNG provides you with another means.
>> The main problem is not about willing to switch to getrandom() or not,
>> but finding any system where getrandom() exists. Today due to libc not
>> having the call, we can only use /dev/urandom and applications would
>> most likely continue to do so long time after getrandom() is
>> introduced to libc.
> Implement the syscall yourself with syscall(). If you get ENOSYS back, revert
> to your old logic of seeding from /dev/urandom.

That's far from a solution and I wouldn't recommend to anyone doing
that. We cannot expect each and every program to do glibc's job. The
purpose of a system call like getrandom is to simplify the complex use
of /dev/urandom and eliminate it, not to make code handling randomness
in applications even worse.

regards,
Nikos
