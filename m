From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 6/8] scsi/ipr: Use sgl_alloc_order() and
 sgl_free_order()
Date: Wed, 18 Oct 2017 15:57:28 -0500
Message-ID: <ce6f2f5b-b4bc-380f-8ac1-1e91e4d6bf24@linux.vnet.ibm.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
 <20171016224940.1332-7-bart.vanassche@wdc.com>
 <c804098f-5543-395c-1395-5778ef74a61b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
To: Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751485AbdJRU5d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Oct 2017 16:57:33 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9IKvWGG022914
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2017 16:57:32 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dpd9rkr9w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2017 16:57:32 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 18 Oct 2017 14:57:31 -0600
In-Reply-To: <c804098f-5543-395c-1395-5778ef74a61b@suse.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/17/2017 01:19 AM, Hannes Reinecke wrote:
> On 10/17/2017 12:49 AM, Bart Van Assche wrote:
>> Use the sgl_alloc_order() and sgl_free_order() functions instead
>> of open coding these functions.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> Cc: linux-scsi@vger.kernel.org
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>  drivers/scsi/Kconfig |  1 +
>>  drivers/scsi/ipr.c   | 49 ++++++++-----------------------------------------
>>  drivers/scsi/ipr.h   |  2 +-
>>  3 files changed, 10 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 41366339b950..d11e75e76195 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -1058,6 +1058,7 @@ config SCSI_IPR
>>  	depends on PCI && SCSI && ATA
>>  	select FW_LOADER
>>  	select IRQ_POLL
>> +	select SGL_ALLOC
>>  	---help---
>>  	  This driver supports the IBM Power Linux family RAID adapters.
>>  	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>> index f838bd73befa..6fed5db6255e 100644
>> --- a/drivers/scsi/ipr.c
>> +++ b/drivers/scsi/ipr.c
>> @@ -3815,10 +3815,8 @@ static struct device_attribute ipr_iopoll_weight_attr = {
>>   **/
>>  static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
>>  {
>> -	int sg_size, order, bsize_elem, num_elem, i, j;
>> +	int sg_size, order;
>>  	struct ipr_sglist *sglist;
>> -	struct scatterlist *scatterlist;
>> -	struct page *page;
>>  
>>  	/* Get the minimum size per scatter/gather element */
>>  	sg_size = buf_len / (IPR_MAX_SGLIST - 1);
>> @@ -3826,45 +3824,18 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
>>  	/* Get the actual size per element */
>>  	order = get_order(sg_size);
>>  
>> -	/* Determine the actual number of bytes per element */
>> -	bsize_elem = PAGE_SIZE * (1 << order);
>> -
>> -	/* Determine the actual number of sg entries needed */
>> -	if (buf_len % bsize_elem)
>> -		num_elem = (buf_len / bsize_elem) + 1;
>> -	else
>> -		num_elem = buf_len / bsize_elem;
>> -
>>  	/* Allocate a scatter/gather list for the DMA */
>> -	sglist = kzalloc(sizeof(struct ipr_sglist) +
>> -			 (sizeof(struct scatterlist) * (num_elem - 1)),
>> -			 GFP_KERNEL);
>> -
>> +	sglist = kzalloc(sizeof(struct ipr_sglist), GFP_KERNEL);
>>  	if (sglist == NULL) {
>>  		ipr_trace;
>>  		return NULL;
>>  	}
>> -
>> -	scatterlist = sglist->scatterlist;
>> -	sg_init_table(scatterlist, num_elem);
>> -
>>  	sglist->order = order;
>> -	sglist->num_sg = num_elem;
>> -
>> -	/* Allocate a bunch of sg elements */
>> -	for (i = 0; i < num_elem; i++) {
>> -		page = alloc_pages(GFP_KERNEL, order);
>> -		if (!page) {
>> -			ipr_trace;
>> -
>> -			/* Free up what we already allocated */
>> -			for (j = i - 1; j >= 0; j--)
>> -				__free_pages(sg_page(&scatterlist[j]), order);
>> -			kfree(sglist);
>> -			return NULL;
>> -		}
>> -
>> -		sg_set_page(&scatterlist[i], page, 0, 0);
>> +	sglist->scatterlist = sgl_alloc_order(buf_len, order, false, GFP_KERNEL,
>> +					      &sglist->num_sg);
>> +	if (!sglist->scatterlist) {
>> +		kfree(sglist);
>> +		return NULL;
>>  	}
>>  
>>  	return sglist;
>> @@ -3882,11 +3853,7 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
>>   **/
>>  static void ipr_free_ucode_buffer(struct ipr_sglist *sglist)
>>  {
>> -	int i;
>> -
>> -	for (i = 0; i < sglist->num_sg; i++)
>> -		__free_pages(sg_page(&sglist->scatterlist[i]), sglist->order);
>> -
>> +	sgl_free_order(sglist->scatterlist, sglist->order);
>>  	kfree(sglist);
>>  }
>>  
>> diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
>> index c7f0e9e3cd7d..93570734cbfb 100644
>> --- a/drivers/scsi/ipr.h
>> +++ b/drivers/scsi/ipr.h
>> @@ -1454,7 +1454,7 @@ struct ipr_sglist {
>>  	u32 num_sg;
>>  	u32 num_dma_sg;
>>  	u32 buffer_len;
>> -	struct scatterlist scatterlist[1];
>> +	struct scatterlist *scatterlist;
>>  };
>>  
>>  enum ipr_sdt_state {
>>
> Not sure if this is a valid conversion.
> Originally the driver would allocate a single buffer; with this buffer
> we have two distinct buffers.
> Given that this is used to download the microcode I'm not sure if this
> isn't a hardware-dependent structure which requires a single buffer
> including the sglist.
> Brian, can you shed some light here?

The struct ipr_sglist is not a hardware defined data structure, so on initial
glance, this should be OK. I'll load it up and give it a try to make sure
it doesn't break code download.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
