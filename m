From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC v2 1/3] block: Introduce blk_bio_map_sg() to map one bio
Date: Fri, 3 Jun 2016 08:38:40 -0600
Message-ID: <57519670.6050306@kernel.dk>
References: <cover.1464346333.git.baolin.wang@linaro.org>
 <2f0f6811938dafd14c6c7b1dbe8fbabfdcbb19c1.1464346333.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ebiggers3@gmail.com, js1304@gmail.com, tadeusz.struk@intel.com,
	smueller@chronox.de, standby24x7@gmail.com, shli@kernel.org,
	dan.j.williams@intel.com, martin.petersen@oracle.com,
	sagig@mellanox.com, kent.overstreet@gmail.com,
	keith.busch@intel.com, tj@kernel.org, ming.lei@canonical.com,
	broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2f0f6811938dafd14c6c7b1dbe8fbabfdcbb19c1.1464346333.git.baolin.wang@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/27/2016 05:11 AM, Baolin Wang wrote:
> +/*
> + * Map a bio to scatterlist, return number of sg entries setup. Caller must
> + * make sure sg can hold bio segments entries.
> + */
> +int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
> +		   struct scatterlist *sglist)
> +{
> +	struct scatterlist *sg = NULL;
> +	int nsegs = 0;
> +
> +	if (bio)
> +		nsegs = __blk_bios_map_sg(q, bio, sglist, &sg, true);
> +
> +	if (sg)
> +		sg_mark_end(sg);

Put that if (sg) inside the if (bio) section, 'sg' isn't going to be
non-NULL outside of that.

Additionally, who would call this with a NULL bio? That seems odd, I'd
get rid of that check completely.

-- 
Jens Axboe

