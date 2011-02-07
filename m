From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: crypto: sha-s390 - Reset index after processing partial block
Date: Mon, 07 Feb 2011 13:47:07 +0100
Message-ID: <1297082827.11137.15.camel@bender>
References: <20110207092817.GA16881@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:37811 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1BGNrx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Feb 2011 08:47:53 -0500
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate4.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p17DlqqC011285
	for <linux-crypto@vger.kernel.org>; Mon, 7 Feb 2011 13:47:52 GMT
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p17Dlter1880104
	for <linux-crypto@vger.kernel.org>; Mon, 7 Feb 2011 13:47:55 GMT
Received: from d06av06.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p17DlpUJ010227
	for <linux-crypto@vger.kernel.org>; Mon, 7 Feb 2011 06:47:51 -0700
In-Reply-To: <20110207092817.GA16881@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ouch.

Acked-by: Jan Glauber <jang@linux.vnet.ibm.com>

On Mon, 2011-02-07 at 20:28 +1100, Herbert Xu wrote:
> Hi:
> 
> This patch fixes an old but nasty bug in the sha-s390 code.
> 
> commit 9d20b571f5bda7273656e1b86ef91eddc94adacc
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Mon Feb 7 20:26:06 2011 +1100
> 
>     crypto: sha-s390 - Reset index after processing partial block
>     
>     The partial block handling in sha-s390 is broken when we get a
>     partial block that is followed by an update which fills it with
>     bytes left-over.  Instead of storing the newly left-over bytes
>     at the start of the buffer, it will be stored immediately after
>     the previous partial block.
>     
>     This patch fixes this by resetting the index pointer.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
> index f42dbab..48884f8 100644
> --- a/arch/s390/crypto/sha_common.c
> +++ b/arch/s390/crypto/sha_common.c
> @@ -38,6 +38,7 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
>  		BUG_ON(ret != bsize);
>  		data += bsize - index;
>  		len -= bsize - index;
> +		index = 0;
>  	}
> 
>  	/* process as many blocks as possible */
> 
> Cheers,
