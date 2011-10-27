From: Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Date: Thu, 27 Oct 2011 03:05:16 -0400
Message-ID: <7836.1319699116@turing-police.cc.vt.edu>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au> <4EA75759.3050900@xenotime.net>
            <20111026062717.GA10230@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319699116_3371P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: Your message of "Wed, 26 Oct 2011 08:27:17 +0200."
             <20111026062717.GA10230@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--==_Exmh_1319699116_3371P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Oct 2011 08:27:17 +0200, Herbert Xu said:
> On Tue, Oct 25, 2011 at 05:42:01PM -0700, Randy Dunlap wrote:
> > When CONFIG_NET is not enabled:
>
> Thanks, I'll add this patch.

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> +	select NET

Are there any use cases where a config (probably embedded) would wantq
CRYPTO_USER but not CRYPTO_NET?  Would seem a shame to pull in the entire
CONFIG_NET stuff just for what appears to me to be a few utility routines (I
know there's still a few people out there fighting kernel bloat).

In any case, I suspect that sort of restructuring will be 3.3 material - this does
look like the right fix for this merge window.


--==_Exmh_1319699116_3371P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOqQKscC3lWbTT17ARAiyhAJ9oRPXZ5LiECOxadROD6Uv2WAZBFQCgh6ps
3azUaNxFSlsnMBsu+0ptrow=
=aJCE
-----END PGP SIGNATURE-----

--==_Exmh_1319699116_3371P--
