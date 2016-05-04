From: John Denker <jsd@av8n.com>
Subject: Re: linux/bitops.h
Date: Wed, 4 May 2016 15:06:04 -0700
Message-ID: <572A724C.6010704@av8n.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
 <20160504174901.GC3901@thunk.org>
 <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
 <C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "H. Peter Anvin" <hpa@zytor.com>, tytso@mit.edu,
	noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cloud.av8n.com ([174.136.99.130]:51443 "EHLO cloud.av8n.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbcEDWGG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 18:06:06 -0400
In-Reply-To: <C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/04/2016 02:56 PM, H. Peter Anvin wrote:
>> Beware that shifting by an amount >= the number of bits in the
>> word remains Undefined Behavior.

> This construct has been supported as a rotate since at least gcc2.

How then should we understand the story told in commit d7e35dfa?
Is the story wrong?

At the very least, something inconsistent is going on.  There
are 8 functions.  Why did d7e35dfa change one of them but
not the other 7?
