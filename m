From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp: Fix DMA operations when IOMMU is enabled
Date: Fri, 3 Feb 2017 18:21:28 +0800
Message-ID: <20170203102128.GE2632@gondor.apana.org.au>
References: <20170127212845.27618.32169.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59643 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752982AbdBCKVk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 05:21:40 -0500
Content-Disposition: inline
In-Reply-To: <20170127212845.27618.32169.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 27, 2017 at 03:28:45PM -0600, Gary R Hook wrote:
> An I/O page fault occurs when the IOMMU is enabled on a
> system that supports the v5 CCP.  DMA operations use a
> Request ID value that does not match what is expected by
> the IOMMU, resulting in the I/O page fault.  Setting the
> Request ID value to 0 corrects this issue.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
