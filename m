From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc mode
Date: Sat, 31 May 2008 12:37:18 -0400
Message-ID: <20080531163718.GB3130@localhost.localdomain>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <484038CE.2080606@swiss-it.ch> <20080530224622.GA1788@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Adrian-Ken =?iso-8859-1?Q?R=FCegsegger?=
	<rueegsegger@swiss-it.ch>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4282 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYEaQb6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 May 2008 12:31:58 -0400
Content-Disposition: inline
In-Reply-To: <20080530224622.GA1788@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 31, 2008 at 08:46:22AM +1000, Herbert Xu wrote:
> On Fri, May 30, 2008 at 07:26:38PM +0200, Adrian-Ken R=FCegsegger wro=
te:
> >=20
> > I was wondering why you created your own test vectors. Wouldn't sta=
ndardized test vectors by NIST or ANSI be preferable?
>=20
> If you could post a patch with those that would be very much
> appreciated.  Thanks!
=46or future reference, do you have a link where NIST standard test vec=
tors can be
obtained?
Regards
Neil

> --=20
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
