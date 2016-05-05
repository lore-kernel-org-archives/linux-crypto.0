From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux/bitops.h
Date: Wed, 4 May 2016 17:48:40 -0700
Message-ID: <CA+55aFwo28F4ZpXn440O_wONsFskd5prrTcRtVOOJvKVczy1iA@mail.gmail.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
	<1462170413-7164-2-git-send-email-tytso@mit.edu>
	<CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
	<20160504174901.GC3901@thunk.org>
	<CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
	<BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
	<20160504190723.GD3901@thunk.org>
	<572A6CDD.10503@av8n.com>
	<C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com>
	<572A724C.6010704@av8n.com>
	<572A9437.4020208@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: John Denker <jsd@av8n.com>, "Theodore Ts'o" <tytso@mit.edu>,
	noloader@gmail.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sasha Levin <sasha.levin@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <572A9437.4020208@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 4, 2016 at 5:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yes. d7e35dfa is baloney IMNSHO.  All it does is produce worse code, and the
> description even says so.
>
> As I said, gcc has treated the former code as idiomatic since gcc 2, so that
> support is beyond ancient.

Well, we're *trying* to get clang supported, so the argument that gcc
has always supported it and compiles correct code for it is not
necessarily the whole story yet.

The problem with "32 - shift" is that it really could generate garbage
in situations where shift ends up being a constant zero..

That said, the fact that the other cases weren't changed
(rol64/ror64/ror32) does make that argument less interesting. Unless
there was some particular code that actively ended up using
"rol32(..0)" but not the other cases.

(And yes, rol32(x,0) is obviously nonsense, but it could easily happen
with inline functions or macros that end up generating that).

Note that there may be 8 "rol/ror" functions, but the 16-bit and 8-bit
ones don't have the undefined semantics. So there are only four that
had _that_ problem, although I agree that changing just one out of
four is wrong.

            Linus
