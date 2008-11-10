From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: What is the difference between aead.ko and authenc.ko ?
Date: Mon, 10 Nov 2008 14:50:39 +0800
Message-ID: <E1KzQbf-0008LR-JT@gondolin.me.apana.org.au>
References: <200811071027.21178.djenkins@mvista.com>
Cc: linux-crypto@vger.kernel.org
To: djenkins@mvista.com (Dean Jenkins)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45372 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbYKJGuq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2008 01:50:46 -0500
In-Reply-To: <200811071027.21178.djenkins@mvista.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dean Jenkins <djenkins@mvista.com> wrote:
> 
> Can anyone explain the difference between aead.ko and authenc.ko ?

AEAD is a type of crypto algorithms, just like cipher or hash.

Authenc is a particular AEAD algorithm, just like AES is a cipher
or SHA is a hash.

> How does crypto decide to use aead.ko instead of authenc.ko ? I am guessing it 
> is something to do with XFRM ?

Well IPsec uses the AEAD interface so it loads the aead.ko due
to symbol dependencies.  The authenc module is loaded if the
user specifies a normal block cipher and hash algorithm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
