From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: IV copy strategy
Date: Fri, 16 Nov 2007 09:19:13 +0100
Message-ID: <20071116081913.GA24538@Chamillionaire.breakpoint.cc>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37476 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbXKPITP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2007 03:19:15 -0500
Content-Disposition: inline
In-Reply-To: <20071116020851.GC32509@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-16 10:08:51 [+0800]:

>You must copy it back to allow chaining.  Even when we go async
>someone may wish to chain.  So in that sense you've just found a
>bug in the hifn driver :)
Not only in hfin. My SPU-AES has the same bug. Do you know someone who
wants to chain? I can remember that you said once "that this is
currently the case but we can change this since IPsec brings a new IV
for ever packet".
So, both of us have to fix it or must the crypto users complete their
encryption/decryption process in one go once they use async (we have no
documentation so we are very flexible here I guess :) )?

>Cheers,

Sebastian
