From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH V2] crypto: implement DH primitives under akcipher API
Date: Thu, 3 Mar 2016 08:23:48 -0800
Message-ID: <B4E74723-637F-4A0D-9081-0541F1DF64BD@holtmann.org>
References: <1457007345-3412-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:36518 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751002AbcCCQXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 11:23:54 -0500
In-Reply-To: <1457007345-3412-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Salvatore,

> Implement Diffie-Hellman primitives required by the scheme under the
> akcipher API. Here is how it works.
> 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
> 2) Call set_priv_key() to set your own private key (xa) in raw format
> 3) Call decrypt() without passing any data as input to get back the
>   public part which will be computed as g^xa mod p
> 4) Call encrypt() by passing the counter part public key (yb) in raw format
>   as input to get back the shared secret calculated as zz = yb^xa mod p

I am still not convinced that akcipher is good match for key exchange methods. I think we should try to introduce a new abstraction here.

Overloading set_pub_key() with DH params and using decrypt() for private/public key pair generation seems not a good fit. It does not really match.

And as I said before, we know for certain that ECDH has to happen as well. So we need to forward look into making that fit as well.

Regards

Marcel
