From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 13:31:09 +0800
Message-ID: <CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
References: <cover.1458023695.git.baolin.wang@linaro.org>
	<20160415134849.GA32694@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Miller <davem@davemloft.net>,
	Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>,
	dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	david.s.gordon@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	smueller@chronox.de, tadeusz.struk@intel.com,
	Masanari Iida <standby24x7@gmail.com>, shli@kernel.org,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160415134849.GA32694@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 15 April 2016 at 21:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Mar 15, 2016 at 03:47:58PM +0800, Baolin Wang wrote:
>> Now some cipher hardware engines prefer to handle bulk block by merging requests
>> to increase the block size and thus increase the hardware engine processing speed.
>>
>> This patchset introduces request bulk mode to help the crypto hardware drivers
>> improve in efficiency.
>
> Could you please explain why this merging can't be done in dm-crypt
> instead?

We've tried to do this in dm-crypt, but it failed.
The dm-crypt maintainer explained to me that I should optimize the
driver, not add strange hw-dependent crypto modes to dm-crypt, this is
not the first crypto accelerator that is just not suited for this kind
of use.
He thought if it can process batch of chunks of data each with own IV,
then it can work with dm-crypt, but he thought such optimized code
should be inside crypto API, not in dmcrypt.

I think his suggestion is reasonable, so we introduce the crypto
engine framework to factor out the common patterns for driving the
queue of operations. Then it will be more reasonable to do the bulk
mode optimization in crypto engine framework. Thanks.

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
