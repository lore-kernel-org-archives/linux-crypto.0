From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: crypto/cavium MSI-X fixups
Date: Tue, 21 Feb 2017 09:36:04 -0800
Message-ID: <52c432c9-4dc1-861e-5556-0db2f4a42c98@caviumnetworks.com>
References: <20170215071843.30108-1-hch@lst.de>
 <58A41C95.2090408@caviumnetworks.com> <20170219173223.GA4682@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: George Cherian <george.cherian@cavium.com>,
        David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>,
        George Cherian <gcherian@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0089.outbound.protection.outlook.com ([104.47.38.89]:20704
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751177AbdBURgL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Feb 2017 12:36:11 -0500
In-Reply-To: <20170219173223.GA4682@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/19/2017 09:32 AM, Christoph Hellwig wrote:
> Herbert,
>
> any comment?  I'd really like to avoid introducing new pci_enable_msix
> users in this merge window..

Hi Cristoph,

With respect to pci_enable_msix(), what do you recommend as a 
replacement?  For the crypto/cavium driver, you recommend 
pci_alloc_irq_vectors(), which works well if the required MSI-X indexes 
are contiguous starting at zero.   What would be used for a device that 
has 184 MSI-X, but only a sparse subset (fewer than half) of these are 
required for the driver operation.  It would waste system resources to 
use an API that forces us to allocate 184 when only 80 are required.

Currently pci_enable_msix() allows an arbitrary set of MSI-X to be 
requested, which exactly fits the requirements of our (non 
crypto/cavium) hardware.

Thanks in advance for any insight you can provide,
David Daney


>
> On Wed, Feb 15, 2017 at 02:47:09PM +0530, George Cherian wrote:
>> Hi Christoph,
>>
>>
>> On 02/15/2017 12:48 PM, Christoph Hellwig wrote:
>>> Hi George,
>>>
>>> your commit "crypto: cavium - Add Support for Octeon-tx CPT Engine"
>>> add a new caller to pci_enable_msix.  This API has long been deprecated
>>> so this series switches it to use pci_alloc_irq_vectors instead.
>>>
>>> Can you please test it and make sure it goes in before the end of the
>>> merge window so that no more users of the old API hit mainline?
>>
>> Yes the changes works well.
>> Acked-by: George Cherian <george.cherian@cavium.com>
>>
>> for the series.
>>>
> ---end quoted text---
>
