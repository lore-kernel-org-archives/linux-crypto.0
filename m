From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 1/3] crypto: ccp - Use devres interface to allocate
 PCI/iomap and cleanup
Date: Mon, 26 Jun 2017 16:17:16 -0500
Message-ID: <262828f7-b433-b271-3caf-dbb4a8a7c5dd@amd.com>
References: <20170623160630.63292-1-brijesh.singh@amd.com>
 <20170623160630.63292-2-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: gary.hook@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: Brijesh Singh <brijesh.singh@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0076.outbound.protection.outlook.com ([104.47.40.76]:60096
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751381AbdFZVRX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 17:17:23 -0400
In-Reply-To: <20170623160630.63292-2-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/23/2017 11:06 AM, Brijesh Singh wrote:
> Update pci and platform files to use devres interface to allocate the PCI
> and iomap resources. Also add helper functions to consolicate module init,
> exit and power mangagement code duplication.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>   drivers/crypto/ccp/ccp-dev-v3.c   |   8 +++
>   drivers/crypto/ccp/ccp-dev.c      |  61 ++++++++++++++++++++
>   drivers/crypto/ccp/ccp-dev.h      |   6 ++
>   drivers/crypto/ccp/ccp-pci.c      | 114 +++++++++-----------------------------
>   drivers/crypto/ccp/ccp-platform.c |  56 ++-----------------
>   5 files changed, 107 insertions(+), 138 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 367c2e3..1cae5a3 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -586,6 +586,14 @@ static const struct ccp_actions ccp3_actions = {
>   	.irqhandler = ccp_irq_handler,
>   };
>   
> +const struct ccp_vdata ccpv3_platform = {
> +	.version = CCP_VERSION(3, 0),
> +	.setup = NULL,
> +	.perform = &ccp3_actions,
> +	.bar = 2,

Platform devices don't use BARs so should probably delete this (unless
you want to make it more generic and then use this value for the
IORESOURCE_MEM entry).

> +	.offset = 0,
> +};
> +
>   const struct ccp_vdata ccpv3 = {
>   	.version = CCP_VERSION(3, 0),
>   	.setup = NULL,
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 2506b50..ce35e43 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -538,8 +538,69 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
>   
>   	return ccp->cmd_q_count == suspended;
>   }
> +
> +int ccp_dev_suspend(struct ccp_device *ccp, pm_message_t state)
> +{
> +	unsigned long flags;
> +	unsigned int i;
> +
> +	spin_lock_irqsave(&ccp->cmd_lock, flags);
> +
> +	ccp->suspending = 1;
> +
> +	/* Wake all the queue kthreads to prepare for suspend */
> +	for (i = 0; i < ccp->cmd_q_count; i++)
> +		wake_up_process(ccp->cmd_q[i].kthread);
> +
> +	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
> +
> +	/* Wait for all queue kthreads to say they're done */
> +	while (!ccp_queues_suspended(ccp))
> +		wait_event_interruptible(ccp->suspend_queue,
> +					 ccp_queues_suspended(ccp));
> +
> +	return 0;
> +}
> +
> +int ccp_dev_resume(struct ccp_device *ccp)
> +{
> +	unsigned long flags;
> +	unsigned int i;
> +
> +	spin_lock_irqsave(&ccp->cmd_lock, flags);
> +
> +	ccp->suspending = 0;
> +
> +	/* Wake up all the kthreads */
> +	for (i = 0; i < ccp->cmd_q_count; i++) {
> +		ccp->cmd_q[i].suspended = 0;
> +		wake_up_process(ccp->cmd_q[i].kthread);
> +	}
> +
> +	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
> +
> +	return 0;
> +}
>   #endif
>   
> +int ccp_dev_init(struct ccp_device *ccp)
> +{
> +	if (ccp->vdata->setup)
> +		ccp->vdata->setup(ccp);
> +
> +	ccp->io_regs = ccp->io_map + ccp->vdata->offset;

This should be before the above call to setup().

Thanks,
Tom

> +
> +	return ccp->vdata->perform->init(ccp);
> +}
> +
> +void ccp_dev_destroy(struct ccp_device *ccp)
> +{
> +	if (!ccp)
> +		return;
> +
> +	ccp->vdata->perform->destroy(ccp);
> +}
> +
>   static int __init ccp_mod_init(void)
>   {
>   #ifdef CONFIG_X86
