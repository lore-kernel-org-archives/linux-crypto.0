From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: cipher implementations allowed to sleep?
Date: Thu, 31 Mar 2016 20:58:25 +0800
Message-ID: <20160331125825.GA30134@gondor.apana.org.au>
References: <8342050.C1sDSzNQxT@tauon.atsec.com>
 <20160331092106.GA28538@gondor.apana.org.au>
 <5387862.2PP9F0yuod@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56678 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbcCaM6a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Mar 2016 08:58:30 -0400
Content-Disposition: inline
In-Reply-To: <5387862.2PP9F0yuod@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 31, 2016 at 01:47:50PM +0200, Stephan Mueller wrote:
>
> Considering the implementation in ansi_cprng.c, is it allowed to use 
> spin_lock_bh with the sync operations assuming that a cipher implementation 
> may sleep?

As I said, it's only allowed to sleep if you set the MAY_SLEEP
flag.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
