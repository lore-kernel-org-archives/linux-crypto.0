From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Assign DMA commands to the channel's CCP
Date: Thu, 16 Mar 2017 17:53:10 +0800
Message-ID: <20170316095310.GA12039@gondor.apana.org.au>
References: <20170310182818.21186.92711.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44959 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751141AbdCPJxY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 05:53:24 -0400
Content-Disposition: inline
In-Reply-To: <20170310182818.21186.92711.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 10, 2017 at 12:28:18PM -0600, Gary R Hook wrote:
> From: Gary R Hook <ghook@amd.com>
> 
> The CCP driver generally uses a round-robin approach when
> assigning operations to available CCPs. For the DMA engine,
> however, the DMA mappings of the SGs are associated with a
> specific CCP. When an IOMMU is enabled, the IOMMU is
> programmed based on this specific device.
> 
> If the DMA operations are not performed by that specific
> CCP then addressing errors and I/O page faults will occur.
> 
> Update the CCP driver to allow a specific CCP device to be
> requested for an operation and use this in the DMA engine
> support.
> 
> Cc: <stable@vger.kernel.org> # 4.9.x-
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
