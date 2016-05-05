From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: better patch for linux/bitops.h
Date: Thu, 5 May 2016 17:34:50 -0400
Message-ID: <CACXcFmmk=DZMVqgZAOm1Lf3LP76By50af8NnPquRA8sF2Vgk0w@mail.gmail.com>
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
	<20160505035028.GD10776@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Jeffrey Walton <noloader@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	Jason Cooper <cryptography@lakedaemon.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34738 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbcEEVew (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 17:34:52 -0400
In-Reply-To: <20160505035028.GD10776@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 4, 2016 at 11:50 PM, Theodore Ts'o <tytso@mit.edu> wrote:

> Instead of arguing over who's "sane" or "insane", can we come up with
> a agreed upon set of tests, and a set of compiler and compiler
> versions ...

I completely fail to see why tests or compiler versions should be
part of the discussion. The C standard says the behaviour in
certain cases is undefined, so a standard-compliant compiler
can generate more-or-less any code there.

As long as any of portability, reliability or security are among our
goals, any code that can give undefined behaviour should be
considered problematic.

> But instead of arguing over what works and doesn't, let's just create
> the the test set and just try it on a wide range of compilers and
> architectures, hmmm?

No. Let's just fix the code so that undefined behaviour cannot occur.

Creating test cases for a fix and trying them on a range of systems
would be useful, perhaps essential, work. Doing tests without a fix
would be a complete waste of time.
