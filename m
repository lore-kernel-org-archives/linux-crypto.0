From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 8/8] crypto: testmgr: Use the xxx_zero_message_hash from
 headers
Date: Tue, 17 Nov 2015 17:56:57 +0800
Message-ID: <20151117095657.GC7837@gondor.apana.org.au>
References: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
 <1445326444-11019-9-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445326444-11019-9-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 20, 2015 at 09:34:04AM +0200, LABBE Corentin wrote:
> Since md5/shaxxx headers have hash for zero message length, just use them.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

This too would need a dependency on the MD5/SHA Kconfig options.

However, for now this is just too hard as it would result in a
circular dependency.  Let's revisit this after we move the test
vectors into the generic implementations.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
