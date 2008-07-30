From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - add handling for SEC 3.x treatment of link table
Date: Wed, 30 Jul 2008 16:27:50 +0800
Message-ID: <20080730082750.GA28076@gondor.apana.org.au>
References: <1217370547.17033.17.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Lee Nipper <lee.nipper@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41959 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751812AbYG3IiJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Jul 2008 04:38:09 -0400
Content-Disposition: inline
In-Reply-To: <1217370547.17033.17.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:29:06PM +0000, Lee Nipper wrote:
> Later SEC revision requires the link table (used for scatter/gather)
> to have an extra entry to account for the total length in descriptor [4],
> which contains cipher Input and ICV.
> This only applies to decrypt, not encrypt.
> Without this change, on 837x, a gather return/length error results
> when a decryption uses a link table to gather the fragments.
> This is observed by doing a ping with size of 1447 or larger with AES,
> or a ping with size 1455 or larger with 3des.
> 
> So, add check for SEC compatible "fsl,3.0" for using extra link table entry.
> 
> Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
