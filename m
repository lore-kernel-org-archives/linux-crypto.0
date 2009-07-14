From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/9] Convert padlock sha to shash
Date: Tue, 14 Jul 2009 22:26:15 +0200
Message-ID: <20090714202615.GA21476@Chamillionaire.breakpoint.cc>
References: <20090711101958.GA14642@gondor.apana.org.au>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55536 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbZGNU0R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2009 16:26:17 -0400
Content-Disposition: inline
In-Reply-To: <20090711101958.GA14642@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2009-07-11 18:19:58 [+0800]:

>As I don't have the hardware supporting padlock-sha, could someone
>with access to it please test this for me? In particular, I'd like
>to see this tested with an actual IPsec connection.

I have here a via nano so I should be able to test it.
Do you have a particular test case in mind or should I just grab
ipsec-tools, setup a tunnel and send a few packets?

>Thanks,

Sebastian
