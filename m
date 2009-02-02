From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: crypto: sha-s390 - Switch to shash
Date: Mon, 02 Feb 2009 13:20:46 +0100
Message-ID: <1233577246.18006.1.camel@localhost>
References: <20090118225517.GA30510@gondor.apana.org.au>
	 <20090128035615.GA13051@gondor.apana.org.au>
Reply-To: schwidefsky@de.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:58811 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZBBMUu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Feb 2009 07:20:50 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id n12CKlvo139344
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2009 12:20:47 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n12CKlxY1917074
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2009 13:20:47 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n12CKlsk020400
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2009 13:20:47 +0100
In-Reply-To: <20090128035615.GA13051@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2009-01-28 at 14:56 +1100, Herbert Xu wrote:
> On Mon, Jan 19, 2009 at 09:55:17AM +1100, Herbert Xu wrote:
> > 
> > Could you let me if this patch breaks s390?
> > 
> > commit 0fe7dddf02811152d7e58747bfe419ec0f43ea4e
> > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > Date:   Sun Jan 18 20:33:33 2009 +1100
> > 
> >     crypto: sha-s390 - Switch to shash
> >     
> >     This patch converts the S390 sha algorithms to the new shash interface.
> >     
> >     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> I'm going to throw this into cryptodev and if it breaks, please
> yell.

Just back from my vacation. Jan will check if the patch breaks anything,
we'll complain if it does..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


