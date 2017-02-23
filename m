From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto/cavium MSI-X fixups
Date: Thu, 23 Feb 2017 20:16:49 +0800
Message-ID: <20170223121649.GA14764@gondor.apana.org.au>
References: <20170215071843.30108-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Cherian <george.cherian@cavium.com>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56565 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751032AbdBWMRD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 07:17:03 -0500
Content-Disposition: inline
In-Reply-To: <20170215071843.30108-1-hch@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 15, 2017 at 08:18:40AM +0100, Christoph Hellwig wrote:
> Hi George,
> 
> your commit "crypto: cavium - Add Support for Octeon-tx CPT Engine"
> add a new caller to pci_enable_msix.  This API has long been deprecated
> so this series switches it to use pci_alloc_irq_vectors instead.
> 
> Can you please test it and make sure it goes in before the end of the
> merge window so that no more users of the old API hit mainline?

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
