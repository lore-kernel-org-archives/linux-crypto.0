From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 16:40:36 +0800
Message-ID: <CAMz4kuKxp4uRtKNTU0emKtWCdgeYdEHDyoktokYS7j0EqRpMCw@mail.gmail.com>
References: <20160418054511.GA17368@gondor.apana.org.au>
	<CAMz4ku+e=53jYJs0y03_catfWzE495sgiiQY_KsLy+v7YOdu+w@mail.gmail.com>
	<20160418070407.GA17760@gondor.apana.org.au>
	<CAMz4kuJvnbRBSiuStYeGkgOXFPVmPJmChd2Gz1aHP40Uh1VxbQ@mail.gmail.com>
	<20160418072434.GA17954@gondor.apana.org.au>
	<CAMz4kuJ4Yp=dZVjxvM5Cw3gBm_mEKdu7-ReSGQ9avAFyG3G=MQ@mail.gmail.com>
	<20160418080454.GA18200@gondor.apana.org.au>
	<CAMz4kuKJn4nW2Mzau2OnVFMMG+833wULFCAz_UbyqvM_eanZnA@mail.gmail.com>
	<20160418081753.GA18323@gondor.apana.org.au>
	<CAMz4kuLu3gsYoSm4aDDBTi-gOpDqiw7PEC-ZfMEOgOcuOAsbEA@mail.gmail.com>
	<20160418083116.GA18406@gondor.apana.org.au>
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
Received: from mail-yw0-f171.google.com ([209.85.161.171]:35396 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcDRIkh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 04:40:37 -0400
Received: by mail-yw0-f171.google.com with SMTP id g133so11203922ywb.2
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2016 01:40:36 -0700 (PDT)
In-Reply-To: <20160418083116.GA18406@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 April 2016 at 16:31, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Apr 18, 2016 at 04:28:46PM +0800, Baolin Wang wrote:
>>
>> What I meaning is if the xts engine can support bulk block, then the
>> engine driver can select bulk mode to do encryption, but if their xts
>> engine can not support bulk mode, which depends on hardware design,
>> the engine driver can not select bulk mode. So the dm-crypt can not
>> know what will be selected by the engine driver, it can not send one
>> bulk block each time.
>
> Why can't the xts code just break it up if it can't handle it?

Simply to say, now there are many different hardware engines for
different vendors, some engines can support bulk block but some can
not (or no cipher hardware engine), then the dm-crypt can not know
your hardware engine features. If the dm-crypt send one bulk block to
low level, but the engine driver can not support bulk block, then it
will crash. So we did the merging action in driver level not dm-crypt
level.

>
> You want to postpone splitting as much as possible.  Even if the
> underlying xts code couldn't handle it, it would still make sense
> for the crypto API to see the request in one piece.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
