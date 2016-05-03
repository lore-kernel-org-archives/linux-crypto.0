From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Regarding mechanism to store/retrive the private data structure
 in any SHA/AEAD/ablkcipher algos
Date: Tue, 3 May 2016 15:10:11 +0800
Message-ID: <20160503071011.GA16446@gondor.apana.org.au>
References: <6ea8dcf8e1ddab3436531e8027d8b016@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, james.l.morris@oracle.com,
	linux-crypto@vger.kernel.org
To: Pramod Kumar <pramod.kumar@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40039 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcECHK0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 03:10:26 -0400
Content-Disposition: inline
In-Reply-To: <6ea8dcf8e1ddab3436531e8027d8b016@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 28, 2016 at 10:38:39AM +0530, Pramod Kumar wrote:
> Hi Herbert Xu/ James Morris/ David
> 
> 
> 
> I was writing driver for one of my secure processing unit(SPU) which
> offloads all SHA/AEAD/ablkciphers.
> 
> 
> 
> While registering algos for crypto subsystem I could not find any way where
> I could store my SPU private data structure and retrieve it in any alog
> callback to maintain things related to SPU like we have in platform or
> other drivers where we could store our private structure and retrieve it in
> its callback?

Other drivers don't seem to have any issues with storing device
data, e.g., talitos.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
