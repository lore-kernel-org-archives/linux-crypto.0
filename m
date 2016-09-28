From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/2] crypto: ccp - data structure cleanup
Date: Wed, 28 Sep 2016 11:23:10 -0500
Message-ID: <54eba444-82e3-3ca9-3017-7b5ea0232551@amd.com>
References: <20160928154921.22138.76929.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0060.outbound.protection.outlook.com ([104.47.34.60]:27438
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932688AbcI1QXa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 12:23:30 -0400
In-Reply-To: <20160928154921.22138.76929.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/28/2016 10:49 AM, Gary R Hook wrote:
> Change names of data structure instances; add const
> keyword where appropriate.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/ccp-dev-v3.c |    2 +-
>  drivers/crypto/ccp/ccp-dev-v5.c |    7 +++++--
>  drivers/crypto/ccp/ccp-dev.h    |    6 +++---
>  drivers/crypto/ccp/ccp-pci.c    |    4 ++--
>  4 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 578522d..b6615b1 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -566,7 +566,7 @@ static const struct ccp_actions ccp3_actions = {
>  	.irqhandler = ccp_irq_handler,
>  };
>  
> -struct ccp_vdata ccpv3 = {
> +const struct ccp_vdata ccpv3 = {
>  	.version = CCP_VERSION(3, 0),
>  	.setup = NULL,
>  	.perform = &ccp3_actions,
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index 9df1526..a90ca9e 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -839,6 +839,9 @@ static int ccp5_init(struct ccp_device *ccp)
>  
>  	return 0;
>  
> +e_hwrng:
> +	ccp_unregister_rng(ccp);
> +

This label has been added but is never used.  I assume that you wanted
to put a goto e_hwrng if ccp_dmaengine_register() fails.

Thanks,
Tom

>  e_kthread:
>  	for (i = 0; i < ccp->cmd_q_count; i++)
>  		if (ccp->cmd_q[i].kthread)
> @@ -994,7 +997,7 @@ static const struct ccp_actions ccp5_actions = {
>  	.irqhandler = ccp5_irq_handler,
>  };
>  
> -struct ccp_vdata ccpv5 = {
> +const struct ccp_vdata ccpv5a = {
>  	.version = CCP_VERSION(5, 0),
>  	.setup = ccp5_config,
>  	.perform = &ccp5_actions,
> @@ -1002,7 +1005,7 @@ struct ccp_vdata ccpv5 = {
>  	.offset = 0x0,
>  };
>  
> -struct ccp_vdata ccpv5other = {
> +const struct ccp_vdata ccpv5b = {
>  	.version = CCP_VERSION(5, 0),
>  	.setup = ccp5other_config,
>  	.perform = &ccp5_actions,
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index ebc9365..08f58b0 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -639,8 +639,8 @@ struct ccp_vdata {
>  	const unsigned int offset;
>  };
>  
> -extern	struct ccp_vdata ccpv3;
> -extern	struct ccp_vdata ccpv5;
> -extern	struct ccp_vdata ccpv5other;
> +extern const struct ccp_vdata ccpv3;
> +extern const struct ccp_vdata ccpv5a;
> +extern const struct ccp_vdata ccpv5b;
>  
>  #endif
> diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
> index 239cbf2..28a9996 100644
> --- a/drivers/crypto/ccp/ccp-pci.c
> +++ b/drivers/crypto/ccp/ccp-pci.c
> @@ -325,8 +325,8 @@ static int ccp_pci_resume(struct pci_dev *pdev)
>  
>  static const struct pci_device_id ccp_pci_table[] = {
>  	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&ccpv3 },
> -	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&ccpv5 },
> -	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&ccpv5other },
> +	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&ccpv5a },
> +	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&ccpv5b },
>  	/* Last entry must be zero */
>  	{ 0, }
>  };
> 
