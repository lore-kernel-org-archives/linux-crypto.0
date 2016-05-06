From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: better patch for linux/bitops.h
Date: Thu, 5 May 2016 17:13:53 -0700
Message-ID: <02b472c7-4faf-3e2a-95ad-1025e7a81bb9@zytor.com>
References: <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
 <572A6F1C.2080708@av8n.com>
 <CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
 <28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
 <CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
 <0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
 <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
 <20160505035028.GD10776@thunk.org>
 <CACXcFmmk=DZMVqgZAOm1Lf3LP76By50af8NnPquRA8sF2Vgk0w@mail.gmail.com>
 <20160505221809.GC17625@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, Sandy Harris <sandyinchina@gmail.com>,
	Jeffrey Walton <noloader@gmail.com>,
	John Denker <jsd@av8n.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Jason Cooper <cryptography@lakedaemon.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:35952 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbcEFAOX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 20:14:23 -0400
In-Reply-To: <20160505221809.GC17625@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/05/2016 03:18 PM, tytso@mit.edu wrote:
> 
> So this is why I tend to take a much more pragmatic viewpoint on
> things.  Sure, it makes sense to pay attention to what the C standard
> writers are trying to do to us; but if we need to suppress certain
> optimizations to write sane kernel code --- I'm ok with that.  And
> this is why using a trust-but-verify on a specific set of compilers
> and ranges of compiler versions is a really good idea....
> 

For the record, the "portable" construct has apparently only been
supported since gcc 4.6.3.

	-hpa
