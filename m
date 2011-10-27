From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Date: Thu, 27 Oct 2011 09:45:44 +0200
Message-ID: <20111027074544.GA19905@gondor.apana.org.au>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au> <4EA75759.3050900@xenotime.net> <20111026062717.GA10230@gondor.apana.org.au> <7836.1319699116@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7836.1319699116@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 27, 2011 at 03:05:16AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 26 Oct 2011 08:27:17 +0200, Herbert Xu said:
> > On Tue, Oct 25, 2011 at 05:42:01PM -0700, Randy Dunlap wrote:
> > > When CONFIG_NET is not enabled:
> >
> > Thanks, I'll add this patch.
> 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > +	select NET
> 
> Are there any use cases where a config (probably embedded) would wantq
> CRYPTO_USER but not CRYPTO_NET?  Would seem a shame to pull in the entire

Since the CRYPTO_USER interface sits on top of netlink I don't
see how you could possibly avoid NET.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
