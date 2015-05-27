From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 3/3] crypto: ccp - Protect against poorly marked end
 of sg list
Date: Wed, 27 May 2015 17:43:05 +0800
Message-ID: <20150527094305.GA28142@gondor.apana.org.au>
References: <20150526180635.6527.5580.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45337 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbbE0JnK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 05:43:10 -0400
Content-Disposition: inline
In-Reply-To: <20150526180635.6527.5580.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tom Lendacky <thomas.lendacky@amd.com> wrote:
> Scatter gather lists can be created with more available entries than are
> actually used (e.g. using sg_init_table() to reserve a specific number
> of sg entries, but in actuality using something less than that based on
> the data length).  The caller sometimes fails to mark the last entry
> with sg_mark_end().  In these cases, sg_nents() will return the original
> size of the sg list as opposed to the actual number of sg entries that
> contain valid data.
> 
> On arm64, if the sg_nents() value is used in a call to dma_map_sg() in
> this situation, then it causes a BUG_ON in lib/swiotlb.c because an
> "empty" sg list entry results in dma_capable() returning false and
> swiotlb trying to create a bounce buffer of size 0. This occurred in
> the userspace crypto interface before being fixed by
> 
> 0f477b655a52 ("crypto: algif - Mark sgl end at the end of data")
> 
> Protect against this in the future by counting the number of sg entries
> needed to meet the length requirement and supplying that value to
> dma_map_sg().

Is this needed for any reason other than this bug that's already
been fixed?

The reason I'm asking is because while this patch fixes your driver
everybody else will still crash and burn should something like this
happen again.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
