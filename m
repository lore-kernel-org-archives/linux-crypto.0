From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 13:53:10 -0700
Message-ID: <4289ee97-9868-65b8-46cb-9d354f2d9555@zytor.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
 <20160504174901.GC3901@thunk.org>
 <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:57170 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbcEDUxs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 16:53:48 -0400
In-Reply-To: <20160504190723.GD3901@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/04/2016 12:07 PM, tytso@thunk.org wrote:
> 
> If we are all agreed that what is in bitops.h is considered valid,
> then we can start converting people over to using the version defined
> in bitops.h, and if there is some compiler issue we need to work
> around, at least we only need to put the workaround in a single header
> file.
> 

Yes, please.

	-hpa
