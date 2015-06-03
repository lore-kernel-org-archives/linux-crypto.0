From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 0/2] scatterlist: introduce sg_nents_for_len
Date: Wed, 3 Jun 2015 13:09:06 +0800
Message-ID: <20150603050906.GC3884@gondor.apana.org.au>
References: <20150601161519.729.75909.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34519 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbbFCFJO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 01:09:14 -0400
Content-Disposition: inline
In-Reply-To: <20150601161519.729.75909.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 11:15:19AM -0500, Tom Lendacky wrote:
> This series introduces and makes use of a new scatterlist function named
> sg_nents_for_len. The purpose of this function is determine the number
> of scatterlist entries required to satisify a specified length. The
> resulting count can be used as input to the dma_map_sg function to map
> only the entries needed.
> 
> This function is needed for cases where a supplied scatterlist has not
> marked the last filled sg entry as the end of the scatterlist. In these
> cases, the sg_nents function count includes sg entries that may not have
> been filled in. When using this value in a dma_map_sg call it can result
> in errors/bugs being generated.
> 
> The following patches are included in this series:
> - Introduce the sg_nents_for_len function
> - Update the ccp driver to use the sg_nents_for_len function
> 
> This patch series is based on cryptodev-2.6.

Both applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
