From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC] crypto: testmgr - Document struct cipher_testvec
Date: Tue, 9 Jun 2015 22:34:14 +0800
Message-ID: <20150609143414.GA14482@gondor.apana.org.au>
References: <20150605093922.GA16806@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52970 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbbFIOeS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 10:34:18 -0400
Content-Disposition: inline
In-Reply-To: <20150605093922.GA16806@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

LABBE Corentin <clabbe.montjoie@gmail.com> wrote:
> Hello                                                                           
>                                                                                
> I was adding a test to testmgr for cbc(aes) but I hesitate on the cipher_testvec parameter also_non_np.
>                                                                                
> Since its functions is not trivial, I propose a patch for documenting the struture.
>                                                                                
> So does I have well understand the purpose of also_non_np ?                      
> And if yes what it is the interest of doing a test twice (one with and one without SG splitting) ?
>                                                                                
> Regards
> 
> From 0156e32be7dd7ffd0a4fdad8d0a3eaf3c0bf92c7 Mon Sep 17 00:00:00 2001
> From: LABBE Corentin <clabbe.montjoie@gmail.com>
> Date: Wed, 3 Jun 2015 09:09:13 +0200
> Subject: [PATCH 02/11] crypto: testmgr - Document struct cipher_testvec
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Applied.  Please don't include nested headers like this without
using scissors (see git help am).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
