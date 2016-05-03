From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Tue, 3 May 2016 11:01:14 -0400
Message-ID: <c2c67db6-8111-4304-03cd-25d479536d8e@gmail.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
 <1499137.D4Mft7n8bh@tauon.atsec.com>
 <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
 <2009968.Rf1hsrr5t0@tauon.atsec.com>
 <CAJU7zaL+jYCgq0RzSraCQF6hd6QtxhobkPtxt+_YqxiZ+vfkMw@mail.gmail.com>
 <20160426011137.GC28496@thunk.org>
 <CAJU7zaKTjb9QhYP6eVyri0b9Ow_GRpqT5HgOVpNMhaEDrVA4gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJU7zaKTjb9QhYP6eVyri0b9Ow_GRpqT5HgOVpNMhaEDrVA4gA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2016-05-03 09:57, Nikos Mavrogiannopoulos wrote:
> On Tue, Apr 26, 2016 at 3:11 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Mon, Apr 25, 2016 at 10:23:51AM +0200, Nikos Mavrogiannopoulos wrote:
>>> That's far from a solution and I wouldn't recommend to anyone doing
>>> that. We cannot expect each and every program to do glibc's job. The
>>> purpose of a system call like getrandom is to simplify the complex use
>>> of /dev/urandom and eliminate it, not to make code handling randomness
>>> in applications even worse.
>> Yes, but if glibc is falling down on the job and refusing to export
>> the system call (I think for political reasons; it's a Linux-only
>> interface, so Hurd wouldn't have it),
>
> I believe their main concern is that they want to protect applications
> which do not check error codes of system calls, when running on a
> kernel which does not provide getrandom().  That way, they have an
> almost impossible task to simulate getrandom() on kernel which do not
> support it.
If it had an existing call, then I could reasonably understand this. 
They have no existing wrapper for it, so this really is just BS.  If an 
application isn't checking error codes, then either:
1. They are intentionally ignoring error codes.
2. It's a bug in the application that needs to be fixed.

The fact that they feel they need to support poorly coded applications 
in _new_ system call wrappers is itself somewhat disturbing.  There are 
no existing applications using this function in glibc because it doesn't 
exist in glibc, which means they can't claim legacy support and 
therefore they want to actively enable people to write stupid programs.
