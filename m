From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC v2 1/3] block: Introduce blk_bio_map_sg() to map one bio
Date: Fri, 3 Jun 2016 08:35:57 -0600
Message-ID: <575195CD.6090607@kernel.dk>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2f0f6811938dafd14c6c7b1dbe8fbabfdcbb19c1.1464346333.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/27/2016 05:11 AM, Baolin Wang wrote:
> In dm-crypt, it need to map one bio to scatterlist for improving the
> hardware engine encryption efficiency. Thus this patch introduces the
> blk_bio_map_sg() function to map one bio with scatterlists.
>
> For avoiding the duplicated code in __blk_bios_map_sg() function, add
> one parameter to distinguish bio map or request map.

Just detach the bio in blk_bio_map_sg() instead of adding a separate 
case (and argument) for it in __blk_bios_map_sg().

-- 
Jens Axboe
