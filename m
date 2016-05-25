From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC 1/3] block: Introduce blk_bio_map_sg() to map one bio
Date: Wed, 25 May 2016 17:02:53 +0800
Message-ID: <CAMz4kuJiQqEuoD9bDohaiD=jV7PoDzK55LE8Cejod-MX1hHaxQ@mail.gmail.com>
References: <cover.1464144790.git.baolin.wang@linaro.org>
	<abe693fad3abb0adfc0cf9ca5b3d287fdb0f2d5b.1464144791.git.baolin.wang@linaro.org>
	<CACVXFVMYm_3rHe5wxs9YA15h+N0EfjMcGQEgnzLZTVbh7HUaRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>, ebiggers3@gmail.com,
	js1304@gmail.com, tadeusz.struk@intel.com, smueller@chronox.de,
	Masanari Iida <standby24x7@gmail.com>,
	Shaohua Li <shli@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sagi Grimberg <sagig@mellanox.com>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Keith Busch <keith.busch@intel.com>, Tejun Heo <tj@kernel.org>,
	Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
	"open list:SOFTWARE RAID (Multiple Disks) SUPPORT"
	<linux-raid@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel
To: Ming Lei <ming.lei@canonical.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMYm_3rHe5wxs9YA15h+N0EfjMcGQEgnzLZTVbh7HUaRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 25 May 2016 at 16:52, Ming Lei <ming.lei@canonical.com> wrote:
>>  /*
>> + * map a bio to scatterlist, return number of sg entries setup.
>> + */
>> +int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
>> +                  struct scatterlist *sglist,
>> +                  struct scatterlist **sg)
>> +{
>> +       struct bio_vec bvec, bvprv = { NULL };
>> +       struct bvec_iter iter;
>> +       int nsegs, cluster;
>> +
>> +       nsegs = 0;
>> +       cluster = blk_queue_cluster(q);
>> +
>> +       if (bio->bi_rw & REQ_DISCARD) {
>> +               /*
>> +                * This is a hack - drivers should be neither modifying the
>> +                * biovec, nor relying on bi_vcnt - but because of
>> +                * blk_add_request_payload(), a discard bio may or may not have
>> +                * a payload we need to set up here (thank you Christoph) and
>> +                * bi_vcnt is really the only way of telling if we need to.
>> +                */
>> +
>> +               if (bio->bi_vcnt)
>> +                       goto single_segment;
>> +
>> +               return 0;
>> +       }
>> +
>> +       if (bio->bi_rw & REQ_WRITE_SAME) {
>> +single_segment:
>> +               *sg = sglist;
>> +               bvec = bio_iovec(bio);
>> +               sg_set_page(*sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
>> +               return 1;
>> +       }
>> +
>> +       bio_for_each_segment(bvec, bio, iter)
>> +               __blk_segment_map_sg(q, &bvec, sglist, &bvprv, sg,
>> +                                    &nsegs, &cluster);
>> +
>> +       return nsegs;
>> +}
>> +EXPORT_SYMBOL(blk_bio_map_sg);
>
> You can use __blk_bios_map_sg() to implement blk_bio_map_sg(),
> then code duplication may be avoided.

OK. I'll re-factor the code to map one bio.

>
>> +
>> +/*
>>   * map a request to scatterlist, return number of sg entries setup. Caller
>>   * must make sure sg can hold rq->nr_phys_segments entries
>>   */
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 1fd8fdf..e5de4f8 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1013,6 +1013,9 @@ extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fu
>>  extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
>>
>>  extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
>> +extern int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
>> +                         struct scatterlist *sglist,
>> +                         struct scatterlist **sg);
>>  extern void blk_dump_rq_flags(struct request *, char *);
>>  extern long nr_blockdev_pages(void);
>>
>> --
>> 1.7.9.5
>>



-- 
Baolin.wang
Best Regards
