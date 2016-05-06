From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: linux/bitops.h
Date: Fri, 6 May 2016 16:08:27 -0400
Message-ID: <572CF9BB.3060902@oracle.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
 <20160504174901.GC3901@thunk.org>
 <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
 <C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com> <572A724C.6010704@av8n.com>
 <572A9437.4020208@zytor.com>
 <CA+55aFwo28F4ZpXn440O_wONsFskd5prrTcRtVOOJvKVczy1iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: John Denker <jsd@av8n.com>, "Theodore Ts'o" <tytso@mit.edu>,
	noloader@gmail.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48120 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbcEFUI6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 May 2016 16:08:58 -0400
In-Reply-To: <CA+55aFwo28F4ZpXn440O_wONsFskd5prrTcRtVOOJvKVczy1iA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/04/2016 08:48 PM, Linus Torvalds wrote:
> That said, the fact that the other cases weren't changed
> (rol64/ror64/ror32) does make that argument less interesting. Unless
> there was some particular code that actively ended up using
> "rol32(..0)" but not the other cases.

Right, the others seemed wrong as well but I couldn't find any code
that triggers that, and preferred to fix just the one I was hitting.

I can go fix the rest if that's something we want to do?


Thanks,
Sasha
