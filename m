From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: better patch for linux/bitops.h
Date: Wed, 4 May 2016 23:30:24 -0400
Message-ID: <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
	<1462170413-7164-2-git-send-email-tytso@mit.edu>
	<CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
	<20160504174901.GC3901@thunk.org>
	<CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
	<BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
	<20160504190723.GD3901@thunk.org>
	<572A6CDD.10503@av8n.com>
	<572A6F1C.2080708@av8n.com>
	<CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
	<28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
	<CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
	<0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: John Denker <jsd@av8n.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35919 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbcEEDaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 23:30:25 -0400
In-Reply-To: <0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>> So you are actually saying outright that we should sacrifice *actual*
>>portability in favor of *theoretical* portability?  What kind of
>>twilight zone did we just step into?!
>>
>>I'm not sure what you mean. It will be well defined on all platforms.
>>Clang may not recognize the pattern, which means they could run
>>slower. GCC and ICC will be fine.
>>
>>Slower but correct code is what you have to live with until the Clang
>>dev's fix their compiler.
>>
>>Its kind of like what Dr. Jon Bentley said: "If it doesn't have to be
>>correct, I can make it as fast as you'd like it to be".
>
> The current code works on all compilers we care about.  The code you propose does not; it doesn't work on anything but very recent versions of our flagship target compiler, and pretty your own admission might even cause security hazards in the kernel if compiled on clang.

I'm not sure how you're arriving at the conclusion the code does not work.

> That qualifies as insane in my book.

OK, thanks.

I see the kernel is providing IPSec, SSL/TLS, etc. You can make
SSL/TLS run faster by using aNULL and eNULL.

Jeff
