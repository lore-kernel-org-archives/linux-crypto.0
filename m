From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Date: Tue, 12 Jun 2012 18:05:26 +0800
Message-ID: <20120612100526.GE14078@gondor.apana.org.au>
References: <20120528135424.GI17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120528135424.GI17705@kronos.redsun>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 28, 2012 at 03:54:24PM +0200, Johannes Goetzfried wrote:
> This patch adds a x86_64/avx assembler implementation of the Twofish block
> cipher. The implementation processes eight blocks in parallel (two 4 block
> chunk AVX operations). The table-lookups are done in general-purpose registers.
> For small blocksizes the 3way-parallel functions from the twofish-x86_64-3way
> module are called. A good performance increase is provided for blocksizes
> greater or equal to 128B.
> 
> Patch has been tested with tcrypt and automated filesystem tests.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
