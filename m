From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] consider keysize in algorithm selection
Date: Thu, 11 Oct 2007 14:43:14 +0200
Message-ID: <20071011124314.GA28993@Chamillionaire.breakpoint.cc>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc> <20071011114700.GA17801@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58272 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610AbXJKMnS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 08:43:18 -0400
Content-Disposition: inline
In-Reply-To: <20071011114700.GA17801@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-11 19:47:00 [+0800]:

>I'm not quite happy with adding keysize to the core API though.
>At some point I'd like to see the DMA operations folded into the
>API as well so having a key is going to be far from universal.
ACK

>In fact the compression operation is an existing example of a
>user that doesn't have a key.
ACK

>> In the fixup, crypto_authenc_alloc() got a little ugly. The keysize is
>> only consider for the blkcipher but the hash might also be limited. Tell
>> me what you thing about this one. Maybe something like cbc(aes|192) is a
>> better solution.
>
>We could do that.
Than we will end up with cbc(aes|192) and cbc(aes|128) being the same
algorithm in most cases (boxes)....

>However, I think the number of extant devices that actually
>need this is so small that we can solve it using the fallback
>flag instead.
>
>In other words, let's make geode-aes use the padlock-sha method
>and just fall back to a lower-priority AES algorithm if it sees
>a key size that it can't handle.
geode and s390 :)

I'm currently digging in geode's code, it seems that there is bug
hiding somewhere.
>Cheers,

Sebastian
