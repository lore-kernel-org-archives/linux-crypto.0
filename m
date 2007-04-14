From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Sun, 15 Apr 2007 05:34:19 +1000
Message-ID: <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, helge.hafting@aitel.hist.no,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: francis.moro@gmail.com (Francis Moreau)
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753196AbXDNTe2@vger.kernel.org>
In-Reply-To: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
> 
> hmm yes indeed it should do the job, but I don't see how you do that.
> For example, let say I want to use "aes-foo" with eCryptfs. I can give
> a higher priority to "aes-foo" than "aes" one. When eCryptfs asks for
> a aes cipher it will pass "aes" name and since "aes-foo" has a higher
> priority then the cypto core will return "aes-foo" cipher, right ? But
> in this scheme, eCryptfs has not a higher priority than other kernel
> users. How can I prevent others to use "aes-foo" ?

You would assign "aes-foo" a lower priority and then tell eCryptfs to
use "aes-foo" instead of "aes".

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
