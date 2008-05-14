From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: tcrypt: hmac test with keys > blocksize fail
Date: Wed, 14 May 2008 09:27:10 +0200
Message-ID: <20080514072710.GA9280@Chamillionaire.breakpoint.cc>
References: <481BAD7A.3010003@swiss-it.ch> <E1JtKP9-0004NE-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Adrian-Ken R??egsegger <rueegsegger@swiss-it.ch>,
	linux-crypto@vger.kernel.org, linux-crypto@ml.breakpoint.cc
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41237 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbYENH1O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 03:27:14 -0400
Content-Disposition: inline
In-Reply-To: <E1JtKP9-0004NE-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-05-06 18:28:15 [+0800]:

>Actually this just exposed an ancient bug in hmac.  It relied
>on the key to be in identity-mapped memory which has never been
>guaranteed.

huh. Thanks Herbert. I haven't seen this on 32bit machine.

>Thanks,

Sebastian
