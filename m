From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 13:45:11 +0800
Message-ID: <20160418054511.GA17368@gondor.apana.org.au>
References: <cover.1458023695.git.baolin.wang@linaro.org>
 <20160415134849.GA32694@gondor.apana.org.au>
 <CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:42055 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbcDRFpy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 01:45:54 -0400
Content-Disposition: inline
In-Reply-To: <CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 18, 2016 at 01:31:09PM +0800, Baolin Wang wrote:
> 
> We've tried to do this in dm-crypt, but it failed.
> The dm-crypt maintainer explained to me that I should optimize the
> driver, not add strange hw-dependent crypto modes to dm-crypt, this is
> not the first crypto accelerator that is just not suited for this kind
> of use.
> He thought if it can process batch of chunks of data each with own IV,
> then it can work with dm-crypt, but he thought such optimized code
> should be inside crypto API, not in dmcrypt.

That's a completely bogus argument.  The user always has more
information available than the underlying API.  So it is totally
stupid to have the API try to extract information that the user
could have provided in the first place.

I'm not taking this patch-set.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
