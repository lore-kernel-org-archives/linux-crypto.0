From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: better patch for linux/bitops.h
Date: Wed, 4 May 2016 23:50:28 -0400
Message-ID: <20160505035028.GD10776@thunk.org>
References: <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org>
 <572A6CDD.10503@av8n.com>
 <572A6F1C.2080708@av8n.com>
 <CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
 <28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
 <CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
 <0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
 <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>,
	linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: Jeffrey Walton <noloader@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48374 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbcEEDuj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 23:50:39 -0400
Content-Disposition: inline
In-Reply-To: <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Instead of arguing over who's "sane" or "insane", can we come up with
a agreed upon set of tests, and a set of compiler and compiler
versions for which these tests must achieve at least *working* code?
Bonus points if they achieve optimal code, but what's important is
that for a wide range of GCC versions (from ancient RHEL distributions
to bleeding edge gcc 5.x compilers) this *must* work.

>From my perspective, clang and ICC producing corret code is a very
nice to have, but most shops I know of don't yet assume that clang
produces code that is trustworthy for production systems, although it
*is* great for as far as generating compiler warnings to find
potential bugs.

But instead of arguing over what works and doesn't, let's just create
the the test set and just try it on a wide range of compilers and
architectures, hmmm?

						- Ted
