From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v4 2/4] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Wed, 8 Jun 2016 10:00:56 +0800
Message-ID: <CAMz4kuLsAyo7pO3VhCV9QdyHJ8njc6dfvORf55Nc_JTDVR-inQ@mail.gmail.com>
References: <cover.1465301616.git.baolin.wang@linaro.org> <238ce3d506051c863300b90720c3e103175747cc.1465301616.git.baolin.wang@linaro.org>
 <20160607141613.GA2237@gondor.apana.org.au>
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
In-Reply-To: <20160607141613.GA2237@gondor.apana.org.au>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 7 June 2016 at 22:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jun 07, 2016 at 08:17:05PM +0800, Baolin Wang wrote:
>> Now some cipher hardware engines prefer to handle bulk block rather than one
>> sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
>> the intermediate values (IV) by themselves in one bulk block. This means we
>> can increase the size of the request by merging request rather than always 512
>> bytes and thus increase the hardware engine processing speed.
>>
>> So introduce 'CRYPTO_ALG_BULK' flag to indicate this cipher can support bulk
>> mode.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
>
> Nack.  As I said before, please do it using explicit IV generators
> like we do for IPsec.

OK. I would like to try your suggestion. Thanks.

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
