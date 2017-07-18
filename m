From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/5] Introduce AMD Secure Processor device
Date: Tue, 18 Jul 2017 18:38:17 +0800
Message-ID: <20170718103817.GQ6479@gondor.apana.org.au>
References: <20170706145917.98876-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, gary.hook@amd.com,
        davem@davemloft.net, thomas.lendacky@amd.com
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33314 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdGRKin (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:38:43 -0400
Content-Disposition: inline
In-Reply-To: <20170706145917.98876-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 06, 2017 at 09:59:12AM -0500, Brijesh Singh wrote:
> CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
> which is not dedicated solely to crypto. The AMD Secure Processor includes
> CCP and PSP (Platform Secure Processor) devices.
> 
> This patch series adds a framework that allows functional component of the
> AMD Secure Processor to be initialized and handled appropriately. The series
> does not makes any logic modification into CCP - it refactors the code to
> integerate CCP into AMD secure processor framework.
> 
> ---
> 
> Changes since v3:
>  - guard sp_dev_resume and sp_dev_suspend with CONFIG_PM
>  - update Kconfig description for AMD SP device
> 
> Changes since v2:
>  - move the ccp->io_regs initialization before device setup().
>  - maintain the original Kconfig hierarchy
>  - rename ccp-{pci,platform}.c -> sp-{pci,platform}.c
>  - do not fail the module_init() when ccp device is not found
> 
> Changes since v1:
>  - remove unused function [sp_get_device()]
> 
> Brijesh Singh (5):
>   crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup
>   crypto: ccp - Introduce the AMD Secure Processor device
>   crypto: cpp - Abstract interrupt registeration
>   crypto: ccp - rename ccp driver initialize files as sp device
>   crypto: ccp - remove ccp_present() check from device initialize

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
