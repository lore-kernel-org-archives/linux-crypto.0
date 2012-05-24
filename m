From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Crypto Update for 3.5
Date: Thu, 24 May 2012 09:03:52 +0200
Message-ID: <CACRpkdZHYqj71F2KG0S+W_n8SL0cRQ-D2ON6OWtsGR6XRJnRWQ@mail.gmail.com>
References: <20100521104404.GA29530@gondor.apana.org.au>
	<20100804140448.GA4042@gondor.apana.org.au>
	<20101024061625.GA23715@gondor.apana.org.au>
	<20110106000157.GA16089@gondor.apana.org.au>
	<20110315145940.GA15373@gondor.apana.org.au>
	<20110520235409.GA1722@gondor.apana.org.au>
	<20110724011752.GA14373@gondor.apana.org.au>
	<20111031040952.GA19659@gondor.apana.org.au>
	<20120106041250.GA7759@gondor.apana.org.au>
	<20120320032736.GA21367@gondor.apana.org.au>
	<20120523013528.GA20781@gondor.apana.org.au>
	<CA+55aFwR=wZfpXPTn9e+ZbEB4srVOHVZFz_STg9jxngmhJxT=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Andreas Westin <andreas.westin@stericsson.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Lee Jones <lee.jones@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54075 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2EXHDx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 May 2012 03:03:53 -0400
Received: by qcro28 with SMTP id o28so5439602qcr.19
        for <linux-crypto@vger.kernel.org>; Thu, 24 May 2012 00:03:52 -0700 (PDT)
In-Reply-To: <CA+55aFwR=wZfpXPTn9e+ZbEB4srVOHVZFz_STg9jxngmhJxT=w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 24, 2012 at 1:06 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> There's a declaration for dbx500_add_platform_device_noirq() that does
> not exist and is not used anywhere. Why? It was added in commit
> 585d188f8072, and I see no rhyme or reason to it.
>
> I only noticed because I happened to get a conflict due to the
> location it was added. I removed it. WTF is going on?

AFAICT this was retrofitted to get a booting kernel on
the cryptodev base which was based on something old like
v3.2 just some weeks back. (Now it's upgraded to mainline, great!)

Greg was pushing for us to allocate all devices dynamically at
one point, but there was no real infrastructure for it and some local
implementations to meet that requirement, that's why these
functions pop up and down. We're working on it with device tree
etc, mea culpa...

Yours,
Linus Walleij
