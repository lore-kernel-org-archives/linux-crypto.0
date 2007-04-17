From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 17:04:31 +0400
Message-ID: <20070417130431.GA8685@2ka.mipt.ru>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com> <E1Hco0p-0007np-00@gondolin.me.apana.org.au> <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com> <20070415075201.GA1644@gondor.apana.org.au> <38b2ab8a0704160137g1ef0713fl943c51ed9049212b@mail.gmail.com> <20070417004117.GA16513@gondor.apana.org.au> <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44661 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbXDQNE4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 09:04:56 -0400
Content-Disposition: inline
In-Reply-To: <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 17, 2007 at 02:36:09PM +0200, Francis Moreau (francis.moro@gmail.com) wrote:
> >> BTW, here are figures I got with 2 different versions of the driver
> >> when using tcrypt module. The second being the result with the
> >> optimized driver (no key reloading on each block):
> >>
> >> normal version:
> >> test 4 (128 bit key, 8192 byte blocks): 1 operation in 67991 cycles (8192
> >> bytes)
> >>
> >> optimized version:
> >> test 4 (128 bit key, 8192 byte blocks): 1 operation in 51783 cycles (8192
> >> bytes)
> >>
> >> So the gain is 16000 cycles which seems to worth the change, isn't it ?
> >
> >Sounds like it would.  It would help of course if you posted the patch :)
> >
> 
> OK, I tried to cook up something very simple. Since I don't know this
> code, please be indulgent when reading the following patch ;)

Which means that after one has loaded ecryptfs module it can not use
ipsec and dm-crypt if there is only one crypto algo registered...

-- 
	Evgeniy Polyakov
