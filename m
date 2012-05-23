From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 3.5
Date: Wed, 23 May 2012 16:06:35 -0700
Message-ID: <CA+55aFwR=wZfpXPTn9e+ZbEB4srVOHVZFz_STg9jxngmhJxT=w@mail.gmail.com>
References: <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au> <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au> <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au> <20120320032736.GA21367@gondor.apana.org.au>
 <20120523013528.GA20781@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52882 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2EWXG5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 May 2012 19:06:57 -0400
In-Reply-To: <20120523013528.GA20781@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 22, 2012 at 6:35 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Here is the crypto update for 3.5:

I pulled this, but quite frankly, some of it looks like utter garbage.

There's a declaration for dbx500_add_platform_device_noirq() that does
not exist and is not used anywhere. Why? It was added in commit
585d188f8072, and I see no rhyme or reason to it.

I only noticed because I happened to get a conflict due to the
location it was added. I removed it. WTF is going on?

                         Linus
