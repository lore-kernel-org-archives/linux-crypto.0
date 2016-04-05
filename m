From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Register the CCP as a DMA resource
Date: Tue, 5 Apr 2016 10:11:00 -0500
Message-ID: <5703D584.7080801@amd.com>
References: <20160404205035.6295.12620.stgit@taos> <5702E0ED.4050708@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Gary R Hook <gary.hook@amd.com>, <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:19776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758538AbcDEPLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 11:11:37 -0400
In-Reply-To: <5702E0ED.4050708@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 04/04/2016 04:47 PM, Tom Lendacky wrote:
> On 04/04/2016 03:50 PM, Gary R Hook wrote:
>> The CCP has the ability to provide DMA services to the
>> kernel using pass-through mode of the device. Register
>> these services as general purpose DMA channels.
>> ---
> You're missing a cc: to David Miller, be sure to check who
> should be included when emailing.
D'oh! Of course.
>>   drivers/crypto/ccp/Kconfig         |    1
>>   drivers/crypto/ccp/Makefile        |    6
>>   drivers/crypto/ccp/ccp-dev-v3.c    |   13 +
>>   drivers/crypto/ccp/ccp-dev.h       |   49 ++
>>   drivers/crypto/ccp/ccp-dmaengine.c |  718 ++++++++++++++++++++++++++++++++++++
>>   drivers/crypto/ccp/ccp-ops.c       |   77 ++++
>>   6 files changed, 856 insertions(+), 8 deletions(-)
>>   create mode 100644 drivers/crypto/ccp/ccp-dmaengine.c
> For some reason the diffstat is missing include/linux/ccp.h

Ack.
>> <snip>
>>   
>> @@ -408,11 +408,19 @@ static int ccp_init(struct ccp_device *ccp)
>>   
>>   	ccp_add_device(ccp);
>>   
>> +	/* Register the DMA engine support */
>> +	ret = ccp_dmaengine_register(ccp);
>> +	if (ret)
>> +		goto e_hwrng;
>> +
> This either needs to be before ccp_add_device() or you need to
> remove the device in the error path.
Ack. Device registration should be the final step.
>>   	/* Enable interrupts */
>>   	iowrite32(qim, ccp->io_regs + IRQ_MASK_REG);
>>   
>>   	return 0;
>>   
>> +e_hwrng:
>> +	hwrng_unregister(&ccp->hwrng);
>> +
>>   e_kthread:
>>   	for (i = 0; i < ccp->cmd_q_count; i++)
>>   		if (ccp->cmd_q[i].kthread)
>> @@ -436,6 +444,9 @@ static void ccp_destroy(struct ccp_device *ccp)
>>   	/* Remove this device from the list of available units first */
>>   	ccp_del_device(ccp);
>>   
>> +	/* Unregister the DMA engine */
>> +	ccp_dmaengine_unregister(ccp);
>> +
>>   	/* Unregister the RNG */
>>   	hwrng_unregister(&ccp->hwrng);
>>   
>> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
>> index 7745d0b..aa447a7 100644
>> --- a/drivers/crypto/ccp/ccp-dev.h
>> +++ b/drivers/crypto/ccp/ccp-dev.h
>> @@ -22,9 +22,12 @@
>>   #include <linux/dmapool.h>
>>   #include <linux/hw_random.h>
>>   #include <linux/bitops.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irqreturn.h>
>> +#include <linux/dmaengine.h>
>>   
>>   #define MAX_CCP_NAME_LEN		16
>> -#define MAX_DMAPOOL_NAME_LEN		32
>> +#define MAX_DMA_NAME_LEN		40
> Any reason this needed to be increased to 40? Though this change
> may not be needed based on comment below.
This will be removed, per the comment below.

<snip>
>> diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
>> new file mode 100644
>> index 0000000..241ad8a
>> --- /dev/null
>> +++ b/drivers/crypto/ccp/ccp-dmaengine.c
>> @@ -0,0 +1,718 @@
>> +/*
>> + * AMD Cryptographic Coprocessor (CCP) driver
>> + *
>> + * Copyright (C) 2015 Advanced Micro Devices, Inc.
> 2016.
>
>> + *
>> + * Author: Tom Lendacky <thomas.lendacky@amd.com>
> This should be your name.
Ack.
> ...
>
>> +int ccp_dmaengine_register(struct ccp_device *ccp)
>> +{
>> +	struct ccp_dma_chan *chan;
>> +	struct dma_device *dma_dev = &ccp->dma_dev;
>> +	struct dma_chan *dma_chan;
>> +	char dma_cache_name[MAX_DMA_NAME_LEN];
> This can't be a local function variable.  You'll need to allocate
> memory for the cache names and track them (or use devm_kasprintf).
While kmem_cache_create() dups the string, a path down to 
sysfs_slab_alias() shows that the pointer is saved elsewhere. 
devm_kasprintf() will be used to build the cache name string.

<snip>
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index eefdf59..3467a1e 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1311,7 +1311,7 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
>   	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
>   		return -EINVAL;
>   
> -	if (!pt->src || !pt->dst)
> +	if (!pt->src_sg || !pt->dst_sg)
> No reason to change this in this patch. If you're trying to distinguish
> between sg and dma addr because of the new passthru function you should
> change the src and dst name in the new function - src_dma / dst_dma.
Done.
