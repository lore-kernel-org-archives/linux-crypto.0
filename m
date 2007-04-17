From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 10:41:17 +1000
Message-ID: <20070417004117.GA16513@gondor.apana.org.au>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com> <E1Hco0p-0007np-00@gondolin.me.apana.org.au> <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com> <20070415075201.GA1644@gondor.apana.org.au> <38b2ab8a0704160137g1ef0713fl943c51ed9049212b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1659 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754228AbXDQAl2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 20:41:28 -0400
Content-Disposition: inline
In-Reply-To: <38b2ab8a0704160137g1ef0713fl943c51ed9049212b@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 16, 2007 at 10:37:01AM +0200, Francis Moreau wrote:
> 
> BTW, here are figures I got with 2 different versions of the driver
> when using tcrypt module. The second being the result with the
> optimized driver (no key reloading on each block):
> 
> normal version:
> test 4 (128 bit key, 8192 byte blocks): 1 operation in 67991 cycles (8192 
> bytes)
> 
> optimized version:
> test 4 (128 bit key, 8192 byte blocks): 1 operation in 51783 cycles (8192 
> bytes)
> 
> So the gain is 16000 cycles which seems to worth the change, isn't it ?

Sounds like it would.  It would help of course if you posted the patch :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
