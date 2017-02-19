From: Christoph Hellwig <hch@lst.de>
Subject: Re: crypto/cavium MSI-X fixups
Date: Sun, 19 Feb 2017 18:32:23 +0100
Message-ID: <20170219173223.GA4682@lst.de>
References: <20170215071843.30108-1-hch@lst.de> <58A41C95.2090408@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>,
        George Cherian <george.cherian@cavium.com>,
        David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <gcherian@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54894 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751013AbdBSRd5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2017 12:33:57 -0500
Content-Disposition: inline
In-Reply-To: <58A41C95.2090408@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

any comment?  I'd really like to avoid introducing new pci_enable_msix
users in this merge window..

On Wed, Feb 15, 2017 at 02:47:09PM +0530, George Cherian wrote:
> Hi Christoph,
>
>
> On 02/15/2017 12:48 PM, Christoph Hellwig wrote:
>> Hi George,
>>
>> your commit "crypto: cavium - Add Support for Octeon-tx CPT Engine"
>> add a new caller to pci_enable_msix.  This API has long been deprecated
>> so this series switches it to use pci_alloc_irq_vectors instead.
>>
>> Can you please test it and make sure it goes in before the end of the
>> merge window so that no more users of the old API hit mainline?
>
> Yes the changes works well.
> Acked-by: George Cherian <george.cherian@cavium.com>
>
> for the series.
>>
---end quoted text---
