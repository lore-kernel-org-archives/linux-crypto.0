From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 16:41:56 +0800
Message-ID: <20160418084155.GA18513@gondor.apana.org.au>
References: <20160418070407.GA17760@gondor.apana.org.au>
 <CAMz4kuJvnbRBSiuStYeGkgOXFPVmPJmChd2Gz1aHP40Uh1VxbQ@mail.gmail.com>
 <20160418072434.GA17954@gondor.apana.org.au>
 <CAMz4kuJ4Yp=dZVjxvM5Cw3gBm_mEKdu7-ReSGQ9avAFyG3G=MQ@mail.gmail.com>
 <20160418080454.GA18200@gondor.apana.org.au>
 <CAMz4kuKJn4nW2Mzau2OnVFMMG+833wULFCAz_UbyqvM_eanZnA@mail.gmail.com>
 <20160418081753.GA18323@gondor.apana.org.au>
 <CAMz4kuLu3gsYoSm4aDDBTi-gOpDqiw7PEC-ZfMEOgOcuOAsbEA@mail.gmail.com>
 <20160418083116.GA18406@gondor.apana.org.au>
 <CAMz4kuKxp4uRtKNTU0emKtWCdgeYdEHDyoktokYS7j0EqRpMCw@mail.gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4kuKxp4uRtKNTU0emKtWCdgeYdEHDyoktokYS7j0EqRpMCw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 18, 2016 at 04:40:36PM +0800, Baolin Wang wrote:
>
> Simply to say, now there are many different hardware engines for
> different vendors, some engines can support bulk block but some can
> not (or no cipher hardware engine), then the dm-crypt can not know
> your hardware engine features. If the dm-crypt send one bulk block to
> low level, but the engine driver can not support bulk block, then it
> will crash. So we did the merging action in driver level not dm-crypt
> level.

Surely we can handle it in the crypto API layer, just as we do GSO
in the network stack for drivers that can't handle TSO?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
