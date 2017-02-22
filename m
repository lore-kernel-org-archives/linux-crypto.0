From: Christoph Hellwig <hch@lst.de>
Subject: Re: crypto/cavium MSI-X fixups
Date: Wed, 22 Feb 2017 08:27:52 +0100
Message-ID: <20170222072752.GA18643@lst.de>
References: <20170215071843.30108-1-hch@lst.de> <58A41C95.2090408@caviumnetworks.com> <20170219173223.GA4682@lst.de> <52c432c9-4dc1-861e-5556-0db2f4a42c98@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>,
        George Cherian <gcherian@caviumnetworks.com>,
        George Cherian <george.cherian@cavium.com>,
        David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Daney <ddaney@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41466 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754004AbdBVH1y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2017 02:27:54 -0500
Content-Disposition: inline
In-Reply-To: <52c432c9-4dc1-861e-5556-0db2f4a42c98@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 21, 2017 at 09:36:04AM -0800, David Daney wrote:
> With respect to pci_enable_msix(), what do you recommend as a replacement?  

pci_alloc_irq_vectors.  In fact I have a tree ready for after -rc1
that removes pci_enable_msix() entirely.

> For the crypto/cavium driver, you recommend pci_alloc_irq_vectors(), which 
> works well if the required MSI-X indexes are contiguous starting at zero.   
> What would be used for a device that has 184 MSI-X, but only a sparse 
> subset (fewer than half) of these are required for the driver operation.  
> It would waste system resources to use an API that forces us to allocate 
> 184 when only 80 are required.

Currently we don't have a good API for that.  I've not been through all
users of pci_enable_msix_{range,exact} yet, but so far I've only found
one user not using all vectors from 0 to some limit.  Depending how many
such users we have and how they'll look I will have to look into an API
to support that use case.
