From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: crypto/cavium MSI-X fixups
Date: Wed, 15 Feb 2017 14:47:09 +0530
Message-ID: <58A41C95.2090408@caviumnetworks.com>
References: <20170215071843.30108-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>,
        George Cherian <george.cherian@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170215071843.30108-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Christoph,


On 02/15/2017 12:48 PM, Christoph Hellwig wrote:
> Hi George,
>
> your commit "crypto: cavium - Add Support for Octeon-tx CPT Engine"
> add a new caller to pci_enable_msix.  This API has long been deprecated
> so this series switches it to use pci_alloc_irq_vectors instead.
>
> Can you please test it and make sure it goes in before the end of the
> merge window so that no more users of the old API hit mainline?

Yes the changes works well.
Acked-by: George Cherian <george.cherian@cavium.com>

for the series.
>
