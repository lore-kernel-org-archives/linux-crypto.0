From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc mode
Date: Sat, 31 May 2008 08:46:22 +1000
Message-ID: <20080530224622.GA1788@gondor.apana.org.au>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <484038CE.2080606@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Adrian-Ken =?iso-8859-1?Q?R=FCegsegger?= <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38018 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726AbYE3Wqg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2008 18:46:36 -0400
Content-Disposition: inline
In-Reply-To: <484038CE.2080606@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 30, 2008 at 07:26:38PM +0200, Adrian-Ken R=FCegsegger wrote=
:
>=20
> I was wondering why you created your own test vectors. Wouldn't stand=
ardized test vectors by NIST or ANSI be preferable?

If you could post a patch with those that would be very much
appreciated.  Thanks!
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
