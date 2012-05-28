From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Date: Mon, 28 May 2012 15:52:03 +0200
Message-ID: <20120528135203.GH17705@kronos.redsun>
References: <20120527144919.GE17705@kronos.redsun>
 <20120528092505.211453i11cwxhp4w@naisho.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120528092505.211453i11cwxhp4w@naisho.dyndns.info>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

> It would be benefical to expand the twofish vectors in
> crypto/testmgr.h from 3 blocks
> to 8 blocks so that 8-way algorithm(s) can be checked runtime. And
> while at expanding
> test-vectors, why not just expand to 16 blocks... AVX2 is just one year away:
> https://github.com/jkivilin/crypto-avx2/commit/1a72d7a6a1553aee70ad4b6a1980ca372181f40d

that's a good idea. Thank you for the link to your commit. I will send this as
an extra patch.

> I think you mean serpent_sse2_glue.c :)

Yeah, that's right, I replaced a bit too much *g* I will resend the patch.

- Johannes
