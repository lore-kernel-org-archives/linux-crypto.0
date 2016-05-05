From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: better patch for linux/bitops.h
Date: Wed, 4 May 2016 21:35:44 -0400
Message-ID: <CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
	<1462170413-7164-2-git-send-email-tytso@mit.edu>
	<CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
	<20160504174901.GC3901@thunk.org>
	<CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
	<BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
	<20160504190723.GD3901@thunk.org>
	<572A6CDD.10503@av8n.com>
	<572A6F1C.2080708@av8n.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: John Denker <jsd@av8n.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34505 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbcEEBfp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 21:35:45 -0400
In-Reply-To: <572A6F1C.2080708@av8n.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 4, 2016 at 5:52 PM, John Denker <jsd@av8n.com> wrote:
> On 05/04/2016 02:42 PM, I wrote:
>
>> I find it very odd that the other seven functions were not
>> upgraded. I suggest the attached fix-others.diff would make
>> things more consistent.
>
> Here's a replacement patch.
> ...

+1, commit it.

Its good for three additional reasons. First, this change means the
kernel is teaching the next generation the correct way to do things.
Many developers aspire to be kernel hackers, and they sometimes use
the code from bitops.h. I've actually run across the code in
production during an audit where the developers cited bitops.h.

Second, it preserves a "silent and dark" cockpit during analysis. That
is, when analysis is run, no findings are generated. Auditors and
security folks like quiet tools, much like the way pilots like their
cockpits (flashing lights and sounding buzzers usually means something
is wrong).

Third, the pattern is recognized by the major compilers, so the kernel
should not have any trouble when porting any of the compilers. I often
use multiple compiler to tease out implementation defined behavior in
a effort to achieve greater portability. Here are the citations to
ensure the kernel is safe with the pattern:

  * GCC: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=57157
  * ICC: http://software.intel.com/en-us/forums/topic/580884

However, Clang may cause trouble because they don't want the
responsibility of recognizing the pattern:

 * https://llvm.org/bugs/show_bug.cgi?id=24226#c8

Instead, they provide a defective rotate. The "defect" here is its
non-constant time due to the branch, so it may not be suitable for
high-integrity or high-assurance code like linux-crypto:

  * https://llvm.org/bugs/show_bug.cgi?id=24226#c5

Jeff
