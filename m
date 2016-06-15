From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v4 2/4] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Wed, 15 Jun 2016 15:38:02 +0800
Message-ID: <CAMz4ku+s-6MQWHhnaau9fK9ssYJNpS9UFvgASoacP0e3vj-zzg@mail.gmail.com>
References: <cover.1465301616.git.baolin.wang@linaro.org> <238ce3d506051c863300b90720c3e103175747cc.1465301616.git.baolin.wang@linaro.org>
 <20160607141613.GA2237@gondor.apana.org.au> <CAMz4kuLsAyo7pO3VhCV9QdyHJ8njc6dfvORf55Nc_JTDVR-inQ@mail.gmail.com>
 <CAMz4kuKXJ5xUXj111VBb9hMH=kT3Y5P3_iVtgeS8kidbLZ+6TA@mail.gmail.com> <20160615064939.GA14227@gondor.apana.org.au>
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
In-Reply-To: <20160615064939.GA14227@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 15 June 2016 at 14:49, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jun 15, 2016 at 02:27:04PM +0800, Baolin Wang wrote:
>>
>> After some investigation, I still think we should divide the bulk
>> request from dm-crypt into small request (each one is 512bytes) if
>> this algorithm is not support bulk mode (like CBC). We have talked
>> with dm-crypt
>> maintainers why dm-crypt always use 512 bytes as one request size in
>> below thread, could you please check it?
>> http://www.kernelhub.org/?p=2&msg=907022
>
> That link only points to an email about an oops.

Ah, sorry. Would you check this thread?
http://lkml.iu.edu/hypermail/linux/kernel/1601.1/03829.html

>
> Diggin through that thread, the only objection I have seen is about
> the fact that you have to generate a fresh IV for each sector, which
> is precisely what I'm suggesting that you do.
>
> IOW, implement the IV generators in the crypto API, and then you can
> easily generate a new IV (if necessary) for each sector.
>
>> That means if we move the IV handling into crypto API, we still can
>> not use bulk interface for all algorithm, for example we still need to
>> read/write with 512 bytes for CBC, you can't use 4k or more block on
>> CBC (and most other encryption modes). If only a part of 4k block is
>> written (and then system crash happens), CBC would corrupt the block
>> completely. It means if we map one whole bio with bulk interface in
>> dm-crypt, we need to divide into every 512 bytes requests in crypto
>> layer. So I don't think we can handle every algorithm with bulk
>> interface just moving the IV handling into crypto API. Thanks.
>
> Of course you would do CBC in 512-byte blocks, but my point is that
> you should do this in a crypto API algorithm, rather than dm-crypt
> as we do now.  Once you implement that then dm-crypt can treat
> every algorithm as if they supported bulk processing.

But that means we should divide the bulk request into 512-byte size
requests and break up the mapped sg table for each request. Another
hand we should allocate memory for each request in crypto layer, which
dm-crypt have supplied one high efficiency way. I think these are
really top level how to use the crypro APIs, does that need to move
into crypto laryer? Thanks.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
