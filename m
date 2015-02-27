From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 0/5] crypto: ccp - CCP driver updates 2015-01-28
Date: Fri, 27 Feb 2015 22:51:45 +1300
Message-ID: <20150227095145.GA29177@gondor.apana.org.au>
References: <20150128224110.30751.93990.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39586 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbB0Jvt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2015 04:51:49 -0500
Content-Disposition: inline
In-Reply-To: <20150128224110.30751.93990.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2015 at 04:41:10PM -0600, Tom Lendacky wrote:
> The following series of patches includes functional updates to the
> driver as well as some trivial changes.
> 
> - Fix checks/warnings from checkpatch
> - Update how the CCP is built (Kconfig and Makefile)
> - Use dma_set_mask_and_coherent to set the DMA mask
> - Use devm_ calls where appropriate
> - Add ACPI support
>   
> This patch series is based on cryptodev-2.6.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
