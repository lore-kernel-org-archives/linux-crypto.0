From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 10/22] staging: unisys: visorbus: Make use of the new
 sg_map helper function
Date: Fri, 14 Apr 2017 10:12:30 -0600
Message-ID: <a182336f-ebda-66c6-3a2e-90f2d43582d7@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-11-git-send-email-logang@deltatee.com>
 <CY4PR07MB317691139A5B2F902CDA9B0EF0050@CY4PR07MB3176.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
To: "Kershner, David A" <David.Kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>,
 "linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org" <linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>,
 "intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>,
 "linux-raid@vge
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CY4PR07MB317691139A5B2F902CDA9B0EF0050-tf0iTMRrrlgs/z/azo2A2OFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

Great, thanks!

Logan

On 14/04/17 10:07 AM, Kershner, David A wrote:
> Can you add Acked-by for this patch? 
> 
> Acked-by: David Kershner <david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>
> 
> Tested on s-Par and no problems. 
> 
> Thanks,
> David Kershner
> 
>> ---
>>  drivers/staging/unisys/visorhba/visorhba_main.c | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c
>> b/drivers/staging/unisys/visorhba/visorhba_main.c
>> index 0ce92c8..2d8c8bc 100644
>> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
>> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
>> @@ -842,7 +842,6 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct
>> scsi_cmnd *scsicmd)
>>  	struct scatterlist *sg;
>>  	unsigned int i;
>>  	char *this_page;
>> -	char *this_page_orig;
>>  	int bufind = 0;
>>  	struct visordisk_info *vdisk;
>>  	struct visorhba_devdata *devdata;
>> @@ -869,11 +868,14 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp,
>> struct scsi_cmnd *scsicmd)
>>
>>  		sg = scsi_sglist(scsicmd);
>>  		for (i = 0; i < scsi_sg_count(scsicmd); i++) {
>> -			this_page_orig = kmap_atomic(sg_page(sg + i));
>> -			this_page = (void *)((unsigned long)this_page_orig |
>> -					     sg[i].offset);
>> +			this_page = sg_map(sg + i, SG_KMAP_ATOMIC);
>> +			if (IS_ERR(this_page)) {
>> +				scsicmd->result = DID_ERROR << 16;
>> +				return;
>> +			}
>> +
>>  			memcpy(this_page, buf + bufind, sg[i].length);
>> -			kunmap_atomic(this_page_orig);
>> +			sg_unmap(sg + i, this_page, SG_KMAP_ATOMIC);
>>  		}
>>  	} else {
>>  		devdata = (struct visorhba_devdata *)scsidev->host-
>>> hostdata;
>> --
>> 2.1.4
> 
