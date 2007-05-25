From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 18:21:25 +1000
Message-ID: <E1HrV37-00076a-00@gondolin.me.apana.org.au>
References: <20070523080354.GA19665@2ka.mipt.ru>
Cc: linux-crypto@vger.kernel.org, linux-crypto@ml.breakpoint.cc
To: johnpol@2ka.mipt.ru (Evgeniy Polyakov)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2985 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752956AbXEYIVa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 04:21:30 -0400
In-Reply-To: <20070523080354.GA19665@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> It does not - your code only supposed to work with ecb, since it is what
> was requested during initialization time. This new scheme with templates
> helps alot for ciphers/crypto modes which do not support several
> templates, so I used old scheme with 'cipher' only template, not
> 'ecb(cipher)', 'cbc(cipher)' and so on.

I just had a look and your driver should use the cra_name of "ecb(aes)"
since ECB is what it implements.  The cra_driver_name can be ecb-aes-hifn
(if there can only be one hifn device, otherwise make it something like
ecb-aes-hifn-<devname> or ecb-aes-<devname>).

Your priority should also be above 200 which is where assembly-optimised
software algorithms are registered at by default.  I suggest 300.

> HIFN supports at least 12 different ciphers/mode (3des, des and aes,
> each one with 4 modes), so it is not a good idea to put them all into
> separated structures, so I rised a question about it.

Well it is a trade-off of a bit of work here vs. the ability to better
support new cipher modes that arise.  Could we perhaps use macro helpers
so that you don't have to type out each one by hand?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
