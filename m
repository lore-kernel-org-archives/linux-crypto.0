From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Wed, 18 Apr 2007 00:02:56 +1000
Message-ID: <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, helge.hafting@aitel.hist.no,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: francis.moro@gmail.com (Francis Moreau)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1409 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754408AbXDQODC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 10:03:02 -0400
In-Reply-To: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
> On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> Actually, I was referring to your AES module :)
> 
> Well I don't if I can do that unfortunately.

What's the problem?

> Actually there's nothing really interesting in this code, only key or
> acc loadings and that's it.
> 
> What do you want to see exactly ?

Well if your code's faster than what we have in the kernel then we
should use yours instead.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
