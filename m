From: Andi Kleen <andi@firstfloor.org>
Subject: Re: linux/bitops.h
Date: Wed, 4 May 2016 16:06:38 -0700
Message-ID: <20160504230638.GO13997@two.firstfloor.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, tytso@mit.edu,
	noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: John Denker <jsd@av8n.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:56751 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbcEDXGm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 19:06:42 -0400
Content-Disposition: inline
In-Reply-To: <572A724C.6010704@av8n.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 03:06:04PM -0700, John Denker wrote:
> On 05/04/2016 02:56 PM, H. Peter Anvin wrote:
> >> Beware that shifting by an amount >= the number of bits in the
> >> word remains Undefined Behavior.
> 
> > This construct has been supported as a rotate since at least gcc2.
> 
> How then should we understand the story told in commit d7e35dfa?
> Is the story wrong?

I don't think Linux runs on a system where it would make a difference
(like a VAX), and also gcc always converts it before it could.
Even UBSan should not complain because it runs after the conversion
to ROTATE.

So it's unlikely to be a pressing issue.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
