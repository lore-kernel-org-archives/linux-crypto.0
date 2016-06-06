From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v2 1/3] block: Introduce blk_bio_map_sg() to map one bio
Date: Mon, 6 Jun 2016 13:03:22 +0800
Message-ID: <CAMz4kuK0_G2sdSzrWLkrCbCmCk1RUH8jjEmXXFU1_mZye5KF4Q@mail.gmail.com>
References: <cover.1464346333.git.baolin.wang@linaro.org> <2f0f6811938dafd14c6c7b1dbe8fbabfdcbb19c1.1464346333.git.baolin.wang@linaro.org>
 <575195CD.6090607@kernel.dk>
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
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <575195CD.6090607@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3 June 2016 at 22:35, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/27/2016 05:11 AM, Baolin Wang wrote:
>>
>> In dm-crypt, it need to map one bio to scatterlist for improving the
>> hardware engine encryption efficiency. Thus this patch introduces the
>> blk_bio_map_sg() function to map one bio with scatterlists.
>>
>> For avoiding the duplicated code in __blk_bios_map_sg() function, add
>> one parameter to distinguish bio map or request map.
>
>
> Just detach the bio in blk_bio_map_sg() instead of adding a separate case
> (and argument) for it in __blk_bios_map_sg().

Make sense.

>
> --
> Jens Axboe
>



-- 
Baolin.wang
Best Regards
