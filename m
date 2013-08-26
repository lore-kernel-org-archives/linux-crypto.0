From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH]  Fix for a warning - crypto/fcrypt,c
Date: Mon, 26 Aug 2013 16:04:29 +1000
Message-ID: <20130826060429.GA25922@gondor.apana.org.au>
References: <4092573.JCpLRYcAKP@aragorn.auenland.lan>
 <3514602.viscUS1bgS@aragorn.auenland.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, behanw@converseincode.com,
	pageexec@freemail.hu
To: Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55870 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756136Ab3HZGEe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Aug 2013 02:04:34 -0400
Content-Disposition: inline
In-Reply-To: <3514602.viscUS1bgS@aragorn.auenland.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 21, 2013 at 10:42:01PM +0200, Jan-Simon M=F6ller wrote:
>=20
> Should I resend a fixed version with=20
> (1U << 27) - 1) instead ?

Sure.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
