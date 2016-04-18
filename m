From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 16:28:46 +0800
Message-ID: <CAMz4kuLu3gsYoSm4aDDBTi-gOpDqiw7PEC-ZfMEOgOcuOAsbEA@mail.gmail.com>
References: <20160415134849.GA32694@gondor.apana.org.au>
	<CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
	<20160418054511.GA17368@gondor.apana.org.au>
	<CAMz4ku+e=53jYJs0y03_catfWzE495sgiiQY_KsLy+v7YOdu+w@mail.gmail.com>
	<20160418070407.GA17760@gondor.apana.org.au>
	<CAMz4kuJvnbRBSiuStYeGkgOXFPVmPJmChd2Gz1aHP40Uh1VxbQ@mail.gmail.com>
	<20160418072434.GA17954@gondor.apana.org.au>
	<CAMz4kuJ4Yp=dZVjxvM5Cw3gBm_mEKdu7-ReSGQ9avAFyG3G=MQ@mail.gmail.com>
	<20160418080454.GA18200@gondor.apana.org.au>
	<CAMz4kuKJn4nW2Mzau2OnVFMMG+833wULFCAz_UbyqvM_eanZnA@mail.gmail.com>
	<20160418081753.GA18323@gondor.apana.org.au>
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
In-Reply-To: <20160418081753.GA18323@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 April 2016 at 16:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Apr 18, 2016 at 04:14:48PM +0800, Baolin Wang wrote:
>> On 18 April 2016 at 16:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> > On Mon, Apr 18, 2016 at 03:58:59PM +0800, Baolin Wang wrote:
>> >>
>> >> That depends on the hardware engine. Some cipher hardware engines
>> >> (like xts(aes) engine) can handle the intermediate values (IV) by
>> >> themselves in one bulk block, which means we can increase the size of
>> >> the request by merging request rather than always 512 bytes and thus
>> >> increase the hardware engine processing speed. But for some other
>> >> hardware engines (like cbc(aes) engine), they can not support bulk
>> >> block, must sector by sector. So the engine drivers can select the
>> >> suitable mode to do encryption/decryption.
>> >
>> > So what is this supposed to handle, xts or cbc?
>>
>> As I know, now cbc engine also need to handle requests sector by
>> sector, but for xts/ecb engine can support bulk block, which means can
>> merge requests.
>
> If it's just xts then why can't dm-crypt merge it and send a single
> request?

What I meaning is if the xts engine can support bulk block, then the
engine driver can select bulk mode to do encryption, but if their xts
engine can not support bulk mode, which depends on hardware design,
the engine driver can not select bulk mode. So the dm-crypt can not
know what will be selected by the engine driver, it can not send one
bulk block each time.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
