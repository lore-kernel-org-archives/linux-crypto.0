From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Sat, 14 Apr 2007 14:30:59 +1000
Message-ID: <E1HcZud-0006DB-00@gondolin.me.apana.org.au>
References: <38b2ab8a0704130630v4c840bd1w19f2a239f86a93b@mail.gmail.com>
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: francis.moro@gmail.com (Francis Moreau)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1351 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754177AbXDNEbI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Apr 2007 00:31:08 -0400
In-Reply-To: <38b2ab8a0704130630v4c840bd1w19f2a239f86a93b@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
> 
> Crypto core already seems to implement a priority mechanism. But I
> don't think I'm able to say "I'd like to use this algo for encrypting
> filesystems. If another part of the kernel wants to use this algo then
> give it the generic one". This choice seems really to depend on the
> system the kernel is running.

It should be easy to restrict a crypto device so that it's used
by one specific user.  That's why we have generic names ("aes") vs.
specific ones ("aes-foo").

So if you let the priority user pick "aes-foo" instead of "aes",
and given that there is a higher priority variant of the generic
"aes" registered, the system will do exactly what you want.

The only part missing right now is the ability to change the priority
of an algorithm so that for example you can let "aes-generic" take
priority over "aes-padlock", but that should be fairly easy to add.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
