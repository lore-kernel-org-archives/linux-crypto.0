From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 0/3] crypto: ccp - CCP driver updates 2015-05-26
Date: Wed, 27 May 2015 17:55:58 +0800
Message-ID: <20150527095558.GC28255@gondor.apana.org.au>
References: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:32919 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbbE0J4C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 05:56:02 -0400
Content-Disposition: inline
In-Reply-To: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 26, 2015 at 01:06:13PM -0500, Tom Lendacky wrote:
> The following patches are included in this driver update series:
> 
> - Remove the checking and setting of the device dma_mask field
> - Remove an unused field from a structure to help avoid any confusion
> - Protect against poorly marked end of scatter-gather list
>  
> This patch series is based on cryptodev-2.6.

Patches 1 and 2 applied.  I'll wait for your response before
deciding on patch 3.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
