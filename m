From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/4] scatterlist: Introduce some helper functions
Date: Wed, 20 Apr 2016 16:38:42 +0800
Message-ID: <20160420083842.GA2455@gondor.apana.org.au>
References: <cover.1458023695.git.baolin.wang@linaro.org>
 <9442060edaca12f520bcbb76545ad33a52346e58.1458023698.git.baolin.wang@linaro.org>
 <87r3eoukb9.fsf@belgarion.home>
 <CAMz4kuKcJKHKoX8JTs5zSrre5y+cVo+hcHS6BZi1M=WOAHyu-g@mail.gmail.com>
 <CAMz4kuK41221jQGtDb0d4MfOXwr=7S5_1f0ThC3c+8TKHs6VgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	David Miller <davem@davemloft.net>,
	Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>,
	dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	david.s.gordon@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	smueller@chronox.de, tadeusz.struk@intel.com,
	Masanari Iida <standby24x7@gmail.com>, shli@kernel.org,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4kuK41221jQGtDb0d4MfOXwr=7S5_1f0ThC3c+8TKHs6VgA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 20, 2016 at 03:34:47PM +0800, Baolin Wang wrote:
> It seems there are no more comments about this patchset? We really
> want to these APIs to coalesce scatterlists to improve the crypto
> engine efficiency. Thanks.

Your patch-set makes no sense.  If the data can be coalesced then
it shouldn't have been split up in the first place.  I'm nacking
the whole series.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
