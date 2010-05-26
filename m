From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC][PATCH] crypto: disable tests when they are not enabled
Date: Wed, 26 May 2010 10:43:58 +1000
Message-ID: <20100526004357.GE20073@gondor.apana.org.au>
References: <1274693724-23831-1-git-send-email-virtuoso@slind.org> <20100524112726.GB29848@gondor.apana.org.au> <20100524122050.GB27432@shisha.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Alexander Shishkin <virtuoso@slind.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:52050 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758463Ab0EZAoA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:44:00 -0400
Content-Disposition: inline
In-Reply-To: <20100524122050.GB27432@shisha.kicks-ass.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 24, 2010 at 03:20:50PM +0300, Alexander Shishkin wrote:
>
> Yes, it saves ~180 miliseconds for me at prng_mod_init(), for example.

I see.  In that case please introduce a new Kconfig option for
this that defaults to testing being enabled.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
