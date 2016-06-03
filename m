From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v2 2/3] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Fri, 3 Jun 2016 18:47:57 +0800
Message-ID: <CAMz4kuLnWtUWEEt9eu6uq5ixM_N9zDmO4j9fMa-ZaXmUXRLUeA@mail.gmail.com>
References: <cover.1464346333.git.baolin.wang@linaro.org> <47e9ddd8c9ea9ad9e29c8cb027d19d8459ea1479.1464346333.git.baolin.wang@linaro.org>
 <20160602082606.GA15226@gondor.apana.org.au> <CAMz4kuJsR0OUJFq68B6znmoTfSeaT_Xhmq14Y4yGSWDJcNE6Hw@mail.gmail.com>
 <20160603065146.GA29953@gondor.apana.org.au> <CAMz4ku+C75VxiO41dBZDm9+PZ_BuUWqY_bmhRDbRwKPVCp+O-g@mail.gmail.com>
 <20160603075435.GA30149@gondor.apana.org.au> <CAMz4kuJA7ii=sjGq9APNSDMZQmh4yj46mmm44noYQegQo+=cAw@mail.gmail.com>
 <20160603082152.GA30551@gondor.apana.org.au> <CAMz4kuL4zAg8dRRM7Lv4tp-c_GHq=0mYzvb88gDEd5YSOtvpRA@mail.gmail.com>
 <20160603100951.GA31382@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
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
	<linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.ker
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160603100951.GA31382@gondor.apana.org.au>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3 June 2016 at 18:09, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Jun 03, 2016 at 05:23:59PM +0800, Baolin Wang wrote:
>>
>> Assuming one 64K size bio coming, we can map the whole bio with one sg
>> table in crypt_convert_bulk_block() function. But if we send this bulk
>> request to crypto layer, we should divide the bulk request into small
>> requests, and each small request should be one sector size (512 bytes)
>> with assuming the correct IV, but we need to allocate small requests
>> memory for the division, which will not good for IO mapping, and how
>> each small request connect to dm-crypt (how to notify the request is
>> done?)?
>
> Why won't it be good? The actual AES block size is 16 and yet we

Like I said, we should avoid memory allocation to improve efficiency
in the IO path. Another hand is how the divided small requests
(allocate request memory at crypt layer) connect with dm-crypt? Since
dm-crypt just send one bulk request to crypt layer, but it will be
divided into small requests at crypt layer.

> have no trouble when you feed it a block of 512 bytes.

That's right.

-- 
Baolin.wang
Best Regards
