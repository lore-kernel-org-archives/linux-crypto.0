From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 16:04:54 +0800
Message-ID: <20160418080454.GA18200@gondor.apana.org.au>
References: <cover.1458023695.git.baolin.wang@linaro.org>
 <20160415134849.GA32694@gondor.apana.org.au>
 <CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
 <20160418054511.GA17368@gondor.apana.org.au>
 <CAMz4ku+e=53jYJs0y03_catfWzE495sgiiQY_KsLy+v7YOdu+w@mail.gmail.com>
 <20160418070407.GA17760@gondor.apana.org.au>
 <CAMz4kuJvnbRBSiuStYeGkgOXFPVmPJmChd2Gz1aHP40Uh1VxbQ@mail.gmail.com>
 <20160418072434.GA17954@gondor.apana.org.au>
 <CAMz4kuJ4Yp=dZVjxvM5Cw3gBm_mEKdu7-ReSGQ9avAFyG3G=MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51152 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbcDRIFi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 04:05:38 -0400
Content-Disposition: inline
In-Reply-To: <CAMz4kuJ4Yp=dZVjxvM5Cw3gBm_mEKdu7-ReSGQ9avAFyG3G=MQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 18, 2016 at 03:58:59PM +0800, Baolin Wang wrote:
>
> That depends on the hardware engine. Some cipher hardware engines
> (like xts(aes) engine) can handle the intermediate values (IV) by
> themselves in one bulk block, which means we can increase the size of
> the request by merging request rather than always 512 bytes and thus
> increase the hardware engine processing speed. But for some other
> hardware engines (like cbc(aes) engine), they can not support bulk
> block, must sector by sector. So the engine drivers can select the
> suitable mode to do encryption/decryption.

So what is this supposed to handle, xts or cbc?

> > Even with batching we should be involving the user because only the
> > user knows (if anyone does) whether more data will be forthcoming.
> 
> If this cipher engine can support bulk block encryption, the crypto
> engine framework can merge requests if they are eligible
> automatically. Don't need to worry about how many data will be
> forthcoming.

Merging is simply wrong when the data is coming in as one piece
and you've just artifically broken it up, only to merge it later.

If the data can be merged then it should have stayed as one piece
rather than being fragmented.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
