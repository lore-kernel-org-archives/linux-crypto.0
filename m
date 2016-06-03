From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v2 2/3] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Fri, 3 Jun 2016 17:23:59 +0800
Message-ID: <CAMz4kuL4zAg8dRRM7Lv4tp-c_GHq=0mYzvb88gDEd5YSOtvpRA@mail.gmail.com>
References: <cover.1464346333.git.baolin.wang@linaro.org> <47e9ddd8c9ea9ad9e29c8cb027d19d8459ea1479.1464346333.git.baolin.wang@linaro.org>
 <20160602082606.GA15226@gondor.apana.org.au> <CAMz4kuJsR0OUJFq68B6znmoTfSeaT_Xhmq14Y4yGSWDJcNE6Hw@mail.gmail.com>
 <20160603065146.GA29953@gondor.apana.org.au> <CAMz4ku+C75VxiO41dBZDm9+PZ_BuUWqY_bmhRDbRwKPVCp+O-g@mail.gmail.com>
 <20160603075435.GA30149@gondor.apana.org.au> <CAMz4kuJA7ii=sjGq9APNSDMZQmh4yj46mmm44noYQegQo+=cAw@mail.gmail.com>
 <20160603082152.GA30551@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160603082152.GA30551@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3 June 2016 at 16:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Jun 03, 2016 at 04:15:28PM +0800, Baolin Wang wrote:
>>
>> Suppose the cbc(aes) algorithm, which can not be handled through bulk
>> interface, it need to map the data sector by sector.
>> If we also handle the cbc(aes) algorithm with bulk interface, we need
>> to divide the sg table into sectors and need to allocate request
>> memory for each divided sectors (As Mike pointed out  this is in the
>> IO mapping
>> path and we try to avoid memory allocations at all costs -- due to the
>> risk of deadlock when issuing IO to stacked block devices (dm-crypt
>> could be part of a much more elaborate IO stack). ), that will
>> introduce more messy things I think.
>
> Perhaps I'm not making myself very clear.  If you move the IV
> generation into the crypto API, those crypto API algorithms will
> be operating at the sector level.

Yeah, IV generation is OK. But it is not only related to IV thing. For example:

(1) For ecb(aes) algorithm which don't need to handle IV generation,
so it can support bulk mode:
Assuming one 64K size bio coming , we can map the whole bio with one
sg table in dm-crypt (assume it used 16 scatterlists from sg table),
then issue the 'skcipher_request_set_crypt()' function to set one
request with the mapped sg table, which will be sent to crypto driver
to be handled.

(2) For cbc(aes) algorithm which need to handle IV generation sector
by sector, so it can not support bulk mode and can not use bulk
interface:
Assuming one 64K size bio coming , we should map the bio sector by
sector with one scatterlist at one time. Each time we will issue the
'skcipher_request_set_crypt()' function to set one request with only
one mapped scatterlist, until it handled done the whole bio.

(3) As your suggestion, if we also use bulk interface for cbc(aes)
algorithm assuming it did all the requisite magic to generate the
correct IV:
Assuming one 64K size bio coming, we can map the whole bio with one sg
table in crypt_convert_bulk_block() function. But if we send this bulk
request to crypto layer, we should divide the bulk request into small
requests, and each small request should be one sector size (512 bytes)
with assuming the correct IV, but we need to allocate small requests
memory for the division, which will not good for IO mapping, and how
each small request connect to dm-crypt (how to notify the request is
done?)?

Thus we should not handle every algorithm with bulk interface.

>
> For example, assuming you're doing lmk, then the algorithm would
> be called lmk(cbc(aes)) and it will take as its input one or more
> sectors and for each sector it should generate an IV and operate
> on it.



>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
