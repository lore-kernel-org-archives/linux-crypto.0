From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.6
Date: Thu, 14 Apr 2016 14:25:35 +0800
Message-ID: <20160414062535.GA19807@gondor.apana.org.au>
References: <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160330091150.GA17143@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40027 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbcDNGZp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Apr 2016 02:25:45 -0400
Content-Disposition: inline
In-Reply-To: <20160330091150.GA17143@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes an NFS regression caused by the skcipher/hash
conversion in sunrpc.  It also fixes a build problem in certain
configurations with bcm63xx.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git li=
nus


Herbert Xu (1):
      sunrpc: Fix skcipher/shash conversion

=C1lvaro Fern=E1ndez Rojas (1):
      hwrng: bcm63xx - fix device tree compilation

 drivers/char/hw_random/bcm63xx-rng.c  |    1 +
 net/sunrpc/auth_gss/gss_krb5_crypto.c |    8 ++++++--
 net/sunrpc/auth_gss/gss_krb5_mech.c   |    3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
