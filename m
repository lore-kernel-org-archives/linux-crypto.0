From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 15:21:16 +0800
Message-ID: <CAMz4kuJvnbRBSiuStYeGkgOXFPVmPJmChd2Gz1aHP40Uh1VxbQ@mail.gmail.com>
References: <cover.1458023695.git.baolin.wang@linaro.org>
	<20160415134849.GA32694@gondor.apana.org.au>
	<CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
	<20160418054511.GA17368@gondor.apana.org.au>
	<CAMz4ku+e=53jYJs0y03_catfWzE495sgiiQY_KsLy+v7YOdu+w@mail.gmail.com>
	<20160418070407.GA17760@gondor.apana.org.au>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:33181 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcDRHVR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 03:21:17 -0400
Received: by mail-yw0-f174.google.com with SMTP id t10so193967237ywa.0
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2016 00:21:17 -0700 (PDT)
In-Reply-To: <20160418070407.GA17760@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 April 2016 at 15:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Apr 18, 2016 at 02:02:51PM +0800, Baolin Wang wrote:
>>
>> If the crypto hardware engine can support bulk data
>> encryption/decryption, so the engine driver can select bulk mode to
>> handle the requests. I think it is a totally driver things, not in
>> dmcrypt. The dmcrypt can not get the hardware engine's attributes.
>
> It has nothing to do with the hardware attributes.  dm-crypt should
> be sending maximal requests in the first place.

I don't think so, the dm-crypt can not send maximal requests at some
situations. For example, the 'cbc(aes)' cipher, it must be handled
sector by sector (IV is dependency for each sector), so the dm-crypt
can not send maximal requests, but must sector by sector in this
situation.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
