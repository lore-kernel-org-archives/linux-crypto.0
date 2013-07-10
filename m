From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH][RESEND] crypto: caam - Moved macro DESC_JOB_IO_LEN to
 desc_constr.h
Date: Wed, 10 Jul 2013 16:54:04 +1000
Message-ID: <20130710065404.GB32296@gondor.apana.org.au>
References: <1373437641-21841-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:35630 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038Ab3GJGyG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jul 2013 02:54:06 -0400
Content-Disposition: inline
In-Reply-To: <1373437641-21841-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 10, 2013 at 06:27:21AM +0000, Vakul Garg wrote:
> DESC_JOB_IO_LEN is a generic macro which indicates the space required in
> the descriptor for placing SEQIN/OUT commands, job descriptor header,
> shared descriptor pointer. Moving it to descriptor construction file
> which can be supposedly included by different algo offload files.
> 
> Change-Id: Ic8900990d465e9079827b0c7fcacc61766d7efb6
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> Reviewed-by: Geanta Neag Horia Ioan-B05471 <horia.geanta@freescale.com>
> Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
> Tested-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>

Patch applied to cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
