From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 6/8] scsi/ipr: Use sgl_alloc_order() and
 sgl_free_order()
Date: Mon, 30 Oct 2017 16:01:48 -0500
Message-ID: <33515fd2-9639-7981-e344-80cdacd40d32@linux.vnet.ibm.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
 <20171016224940.1332-7-bart.vanassche@wdc.com>
 <c804098f-5543-395c-1395-5778ef74a61b@suse.de>
 <ce6f2f5b-b4bc-380f-8ac1-1e91e4d6bf24@linux.vnet.ibm.com>
 <1509395828.27259.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
To: Bart Van Assche <Bart.VanAssche@wdc.com>,
        "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1509395828.27259.21.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/30/2017 03:37 PM, Bart Van Assche wrote:
> On Wed, 2017-10-18 at 15:57 -0500, Brian King wrote:
>> On 10/17/2017 01:19 AM, Hannes Reinecke wrote:
>>> On 10/17/2017 12:49 AM, Bart Van Assche wrote:
>>>> [ ... ]
>>>
>>> Not sure if this is a valid conversion.
>>> Originally the driver would allocate a single buffer; with this buffer
>>> we have two distinct buffers.
>>> Given that this is used to download the microcode I'm not sure if this
>>> isn't a hardware-dependent structure which requires a single buffer
>>> including the sglist.
>>> Brian, can you shed some light here?
>>
>> The struct ipr_sglist is not a hardware defined data structure, so on initial
>> glance, this should be OK. I'll load it up and give it a try to make sure
>> it doesn't break code download.
> 
> Hello Brian,
> 
> Have you already obtained any test results?

Bart,

Yes. I tried this out on an ipr adapter and it looks fine.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
