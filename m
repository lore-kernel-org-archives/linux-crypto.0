From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/testmgr: fix uninitialized warning from gcc
Date: Fri, 11 Dec 2009 14:28:22 +0800
Message-ID: <20091211062822.GB28849@gondor.apana.org.au>
References: <1260359524-15515-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52046 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757098AbZLKG2T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2009 01:28:19 -0500
Content-Disposition: inline
In-Reply-To: <1260359524-15515-1-git-send-email-vapier@gentoo.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2009 at 06:52:04AM -0500, Mike Frysinger wrote:
> Since err is not set to a value if tcount is 0, gcc issues a warning:
> crypto/testmgr.c: In function =E2=80=98test_cprng=E2=80=99:
> crypto/testmgr.c:1204: warning: =E2=80=98err=E2=80=99 may be used uni=
nitialized in this function
>=20
> Since this is test code, forcing initialized sanity should be fine.
>=20
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks but a similar patch has already been merged.
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
