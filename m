From: David Daney <ddaney.cavm@gmail.com>
Subject: Re: crypto/cavium MSI-X fixups
Date: Wed, 22 Feb 2017 09:45:01 -0800
Message-ID: <939dab85-383d-845b-b6db-51567a01cb97@gmail.com>
References: <20170215071843.30108-1-hch@lst.de>
 <58A41C95.2090408@caviumnetworks.com> <20170219173223.GA4682@lst.de>
 <52c432c9-4dc1-861e-5556-0db2f4a42c98@caviumnetworks.com>
 <20170222072752.GA18643@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: George Cherian <gcherian@caviumnetworks.com>,
        George Cherian <george.cherian@cavium.com>,
        David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>,
        David Daney <ddaney@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33740 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932223AbdBVRpD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2017 12:45:03 -0500
In-Reply-To: <20170222072752.GA18643@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/21/2017 11:27 PM, Christoph Hellwig wrote:
> On Tue, Feb 21, 2017 at 09:36:04AM -0800, David Daney wrote:
>> With respect to pci_enable_msix(), what do you recommend as a replacement?
>
> pci_alloc_irq_vectors.  In fact I have a tree ready for after -rc1
> that removes pci_enable_msix() entirely.

I would like to see something that handles the case of this driver that 
I am attempting to get merged:


https://lkml.org/lkml/2017/2/15/1209


>
>> For the crypto/cavium driver, you recommend pci_alloc_irq_vectors(), which
>> works well if the required MSI-X indexes are contiguous starting at zero.
>> What would be used for a device that has 184 MSI-X, but only a sparse
>> subset (fewer than half) of these are required for the driver operation.
>> It would waste system resources to use an API that forces us to allocate
>> 184 when only 80 are required.
>
> Currently we don't have a good API for that.  I've not been through all
> users of pci_enable_msix_{range,exact} yet, but so far I've only found
> one user not using all vectors from 0 to some limit.  Depending how many
> such users we have and how they'll look I will have to look into an API
> to support that use case.
>

See the patch above for the case that doesn't use 0..UPPER_LIMIT

David Daney
