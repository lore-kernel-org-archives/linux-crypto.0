From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Question about ahash export and import
Date: Tue, 26 Sep 2017 11:36:37 +0200
Message-ID: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:56008 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965142AbdIZJgj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 05:36:39 -0400
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Today, the talitos driver dma maps/unmaps context and keys at every 
single request.
I'm looking at doing the dma mapping at hash init and doing unmapping at 
final/finup/digest

However, I'm wondering how to manage hash exports and imports. I was 
initially thinking about doing a dma_sync_for_cpu() before any export 
and a dma_sync_for_device() after any export, but that supposes that the 
dma area is already mapped, which means that we have done the init and 
not yet done a final/finup/digest.

I'm a bit sceptic when reading the following text in include/crypto/hash.h :

@export: Export partial state of the transformation. This function dumps the
  *	    entire state of the ongoing transformation into a provided block of
  *	    data so it can be @import 'ed back later on. This is useful in case
  *	    you want to save partial result of the transformation after
  *	    processing certain amount of data and reload this partial result
  *	    multiple times later on for multiple re-use


Does it mean that import may be called in lieu of hash init, or is hash 
init always called before doing an import ?

Thanks
Christophe
