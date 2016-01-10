From: Thomas Egerer <hakke_007@gmx.de>
Subject: Re: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Sun, 10 Jan 2016 21:16:34 +0100
Message-ID: <5692BC22.4010903@gmx.de>
References: <568AC07B.8020605@gmx.de> <4445865.9O5pIU29W2@myon.chronox.de>
 <568AD989.8060802@gmx.de> <20160108094855.GA3472@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54816 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348AbcAJUQC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2016 15:16:02 -0500
In-Reply-To: <20160108094855.GA3472@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/08/2016 10:48 AM, Herbert Xu wrote:
> On Mon, Jan 04, 2016 at 09:43:53PM +0100, Thomas Egerer wrote:
>> Similar to CTR mode selecting CRYPTO_SEQIV, CBC mode requires echainiv
>> and has to select CRYPTO_ECHAINIV in order to work properly. This solves
>> the issues caused by a misconfiguration as described in [1].
>>
>> [1] https://lists.strongswan.org/pipermail/users/2015-December/009074.html
>>
>> Signed-off-by: Thomas Egerer <hakke_007@gmx.de>
> 
> Please patch net/ipvX/Kconfig instead as ECHAINIV is only used
> by IPsec.
This does not seem right to me. By depending on CRYPTO_CBC in a particular
Kconfig, I would expect the 'default algorithm for CBC' to be transitively
selected with it. It's what CRYPTO_CTR does. There are a couple of places
that use select CRYPTO_CBC but not CRYPTO_ECHAINIV  (ext4, wusbcore, md
to mention a few). Wouldn't these end up unusable too, if CBC-mode doesn't
activate echainiv?

Cheers,
Thomas

> Thanks,
> 
