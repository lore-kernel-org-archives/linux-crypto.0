From: John Denker <jsd@av8n.com>
Subject: Re: linux/bitops.h
Date: Wed, 4 May 2016 17:13:00 -0700
Message-ID: <572A900C.20307@av8n.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
 <20160504174901.GC3901@thunk.org>
 <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
 <C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com> <572A724C.6010704@av8n.com>
 <20160504230638.GO13997@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>, tytso@mit.edu,
	noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cloud.av8n.com ([174.136.99.130]:52167 "EHLO cloud.av8n.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbcEEANC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 20:13:02 -0400
In-Reply-To: <20160504230638.GO13997@two.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/04/2016 04:06 PM, Andi Kleen wrote:

> gcc always converts it before it could
[make a difference].

At the moment, current versions of gcc treat the idiomatic
ror/rol code as something they support ... but older versions
do not, and future version may not.

The gcc guys have made it very clear that they reserve the
right to do absolutely anything they want in a UB situation.
 -- What is true as of today might not be "always" true.
 -- What is true at one level of optimization might not be
  true at another.
 -- The consequences can be highly nonlocal and counterintuitive.
  For example, in the case of:
     rslt = word << (32 - N);
     ...
     ...
     if (!N) { ....... }
  the compiler could assume that N is necessarily nonzero,
  and many lines later it could optimize out the whole
  if-block.  So, even if the "<<" operator gives the right
  result, there could be ghastly failures elsewhere.  It
  might work for some people but not others.

> So it's unlikely to be a pressing issue.

Sometimes issues that are not urgently "pressing" ought
to be dealt with in a systematic way.

There are serious people who think that avoiding UB is
a necessity, if you want the code to be reliable and
maintainable.

I renew the question:  Why did commit d7e35dfa upgrade
one of the 8 functions but not the other 7?
  -- I could understand 0 of 8, or 8 of 8.
  -- In contrast, I'm having a hard time understanding
   why 7 of the 8 use the idiomatic expression while the
   8th does not.
