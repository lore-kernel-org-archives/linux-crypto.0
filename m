From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 15:58:59 +0800
Message-ID: <CAMz4kuJ4Yp=dZVjxvM5Cw3gBm_mEKdu7-ReSGQ9avAFyG3G=MQ@mail.gmail.com>
References: <cover.1458023695.git.baolin.wang@linaro.org>
	<20160415134849.GA32694@gondor.apana.org.au>
	<CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
	<20160418054511.GA17368@gondor.apana.org.au>
	<CAMz4ku+e=53jYJs0y03_catfWzE495sgiiQY_KsLy+v7YOdu+w@mail.gmail.com>
	<20160418070407.GA17760@gondor.apana.org.au>
	<CAMz4kuJvnbRBSiuStYeGkgOXFPVmPJmChd2Gz1aHP40Uh1VxbQ@mail.gmail.com>
	<20160418072434.GA17954@gondor.apana.org.au>
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
In-Reply-To: <20160418072434.GA17954@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 April 2016 at 15:24, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Apr 18, 2016 at 03:21:16PM +0800, Baolin Wang wrote:
>>
>> I don't think so, the dm-crypt can not send maximal requests at some
>> situations. For example, the 'cbc(aes)' cipher, it must be handled
>> sector by sector (IV is dependency for each sector), so the dm-crypt
>> can not send maximal requests, but must sector by sector in this
>> situation.
>
> If you can't merge them as requests, then how is the hardware going
> to benefit from batching them? Or are you talking about parallel

That depends on the hardware engine. Some cipher hardware engines
(like xts(aes) engine) can handle the intermediate values (IV) by
themselves in one bulk block, which means we can increase the size of
the request by merging request rather than always 512 bytes and thus
increase the hardware engine processing speed. But for some other
hardware engines (like cbc(aes) engine), they can not support bulk
block, must sector by sector. So the engine drivers can select the
suitable mode to do encryption/decryption.

> processing similar to sha-mb?
>
> Even with batching we should be involving the user because only the
> user knows (if anyone does) whether more data will be forthcoming.

If this cipher engine can support bulk block encryption, the crypto
engine framework can merge requests if they are eligible
automatically. Don't need to worry about how many data will be
forthcoming.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
