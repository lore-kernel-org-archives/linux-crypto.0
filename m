From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 0/3] support for interleaving in generic chaining modes
Date: Fri, 7 Feb 2014 08:30:26 +0100
Message-ID: <CAKv+Gu-4J6jO135QgNrLrEX96U7aS7k4BE82j9ZLzwe60HfTTQ@mail.gmail.com>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140207022335.GA27694@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:53784 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBGHa1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 02:30:27 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so2324767lab.37
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2014 23:30:26 -0800 (PST)
In-Reply-To: <20140207022335.GA27694@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7 February 2014 03:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Feb 06, 2014 at 01:25:01PM +0100, Ard Biesheuvel wrote:
>> My apologies if this has been discussed/debated before on linux-crypto.
>>
>> When working on accelerated crypto for ARM and arm64, I noticed that many of
>> the existing accelerated implementations for other architectures duplicate much
>> of the chaining modes, not because they can be accelerated themselves but mainly
>> because the generic chaining mode implementations cannot present the data in
>> large enough chunks for the accelerated implementations to reach their optimal
>> speed.
>>
>> This series proposes a way to improve on that. I have only implemented the CBC
>> example because it makes for nice a benchmark, but CTR and XTS are other obvious
>> candidates for the treatment.
>>
>> I have included my arm64 AES cipher implementation for reference.
>
> We can already do this using the existing blkcipher interface
> if the underlying accelerated implementation exports an ECB
> version of itself.
>

That had occurred to me as well.

> So if we're going to do this I'd like to see CBC/CTR/XTS simply
> be modified to use ecb(X) instead of X where appropriate.
>

I agree that it would be trivial for cbc(%s) to probe for ecb(%s)
before settling on using plain '%s.
But how to probe for an /accelerated/ ecb(%s), i.e., how to avoid
using the generic ecb(%s) which adds nothing but overhead?
The other issue is how to find out what the optimal chunk size is for
the accelerated ecb(%s) implementation, which would involve adding a
struct member that holds the preferred number of blocks presented in a
single invocation.
In fact, that would solve both issues, as the probe could check this
struct member for a >1 value (as my current series does but in against
a cipher_alg instance)

The downside is that this adds some overhead in handling the
scatterlists: even though the cbc mode handler will only ever call the
ecb mode handler with exactly the preferred number of blocks
contiguously in memory (thanks to the outer
blkcipher_walk_virt_block()), the ecb implementation -being a
blkcipher instance- cannot make any assumptions so it needs its own
level of blkcipher walking to traverse the data. Would there be any
way around that?

-- 
Ard.
