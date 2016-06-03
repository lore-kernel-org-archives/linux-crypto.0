From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v2 2/3] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Fri, 3 Jun 2016 14:48:34 +0800
Message-ID: <CAMz4kuJsR0OUJFq68B6znmoTfSeaT_Xhmq14Y4yGSWDJcNE6Hw@mail.gmail.com>
References: <cover.1464346333.git.baolin.wang@linaro.org> <47e9ddd8c9ea9ad9e29c8cb027d19d8459ea1479.1464346333.git.baolin.wang@linaro.org>
 <20160602082606.GA15226@gondor.apana.org.au>
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
In-Reply-To: <20160602082606.GA15226@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbet,

On 2 June 2016 at 16:26, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, May 27, 2016 at 07:11:23PM +0800, Baolin Wang wrote:
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
> I think a better aproach would be to explicitly move the IV generation
> into the crypto API, similar to how we handle IPsec.  Once you do
> that then every algorithm can be handled through the bulk interface.
>

Sorry for late reply.
If we move the IV generation into the crypto API, we also can not
handle every algorithm with the bulk interface. Cause we also need to
use different methods to map one whole bio or map one sector according
to the algorithm whether can support bulk mode or not. Please correct
me if I misunderstand your points. Thanks.


> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
