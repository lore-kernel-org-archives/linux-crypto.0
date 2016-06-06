From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v2 1/3] block: Introduce blk_bio_map_sg() to map one bio
Date: Mon, 6 Jun 2016 13:04:17 +0800
Message-ID: <CAMz4kuL6PFANg=f0t7mCAk=CqJisdmZyxcUqWf8ZUj0mRLQrXQ@mail.gmail.com>
References: <cover.1464346333.git.baolin.wang@linaro.org> <2f0f6811938dafd14c6c7b1dbe8fbabfdcbb19c1.1464346333.git.baolin.wang@linaro.org>
 <57519670.6050306@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Eric Biggers <ebiggers3@gmail.com>,
	Joonsoo Kim <js1304@gmail.com>, tadeusz.struk@intel.com,
	smueller@chronox.de, Masanari Iida <standby24x7@gmail.com>,
	Shaohua Li <shli@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sagi Grimberg <sagig@mellanox.com>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Keith Busch <keith.busch@intel.com>, Tejun Heo <tj@kernel.org>,
	Ming Lei <ming.lei@canonical.com>,
	Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
	"open list:SOFTWARE RAID (Multiple Disks) SUPPORT"
	<linux-raid@vger.kernel.org>, LKML <linux-ke
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57519670.6050306@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3 June 2016 at 22:38, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/27/2016 05:11 AM, Baolin Wang wrote:
>>
>> +/*
>> + * Map a bio to scatterlist, return number of sg entries setup. Caller
>> must
>> + * make sure sg can hold bio segments entries.
>> + */
>> +int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
>> +                  struct scatterlist *sglist)
>> +{
>> +       struct scatterlist *sg = NULL;
>> +       int nsegs = 0;
>> +
>> +       if (bio)
>> +               nsegs = __blk_bios_map_sg(q, bio, sglist, &sg, true);
>> +
>> +       if (sg)
>> +               sg_mark_end(sg);
>
>
> Put that if (sg) inside the if (bio) section, 'sg' isn't going to be
> non-NULL outside of that.
>
> Additionally, who would call this with a NULL bio? That seems odd, I'd
> get rid of that check completely.

OK. I'll fix these in next version. Thanks for your comments.

-- 
Baolin.wang
Best Regards
