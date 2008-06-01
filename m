From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc mode
Date: Sun, 1 Jun 2008 11:54:08 -0400
Message-ID: <20080601155408.GA4737@localhost.localdomain>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <484038CE.2080606@swiss-it.ch> <20080530224622.GA1788@gondor.apana.org.au> <20080531163718.GB3130@localhost.localdomain> <4841FEF7.4020203@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4394 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYFAPyZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Jun 2008 11:54:25 -0400
Content-Disposition: inline
In-Reply-To: <4841FEF7.4020203@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 01, 2008 at 03:44:23AM +0200, Adrian-Ken Rueegsegger wrote:
> Neil Horman wrote:
> > On Sat, May 31, 2008 at 08:46:22AM +1000, Herbert Xu wrote:
> >> On Fri, May 30, 2008 at 07:26:38PM +0200, Adrian-Ken R=FCegsegger =
wrote:
> >>> I was wondering why you created your own test vectors. Wouldn't s=
tandardized test vectors by NIST or ANSI be preferable?
> >> If you could post a patch with those that would be very much
> >> appreciated.  Thanks!
>=20
> I am putting together a patch using the test vectors found at [3] and=
 the ones I gathered from ANSI X9.52 and ISO/IEC FDIS 10116:2005. Stran=
ge enough the ANSI and ISO test vectors pass while the ones from NIST d=
o not yield the expected results. I have not yet identified the specifi=
c differences between the various test vector sets. It is not clearly s=
tated if/which padding was employed so that might be the reason...
>=20

I thought that TDES input/output vectors had to be an even multiple of =
the key
length.  As such if the vectors aren't an even multiple, doesn't paddin=
g have to
be employed?


> > For future reference, do you have a link where NIST standard test v=
ectors can be
> > obtained?
>=20
> A good place to start is [1]. More specifically for TDES: [2] and [3]=
=2E Note that the tests described in [2] will not work with the current=
 DES3 implementation since the employed keys will be identified as weak=
 keys and the setkey operation would fail.
>=20
> By the way: when explicitly trying to set a weak key for DES3 I got t=
he following warning:
>=20
> setkey() failed flags=3D0
>=20
> Shouldn't the flags be set to CRYPTO_TFM_RES_BAD_KEY_SCHED at that po=
int (see crypto/des_generic.c, line 873)?
I ran into this too when I wrote my vector. I'm not sure why this is ha=
ppening,
as it appears the *flags->crt_flags | FLAGS statements should set these=
=2E  I'm
looking into why
Neil

>=20
> Thanks,
> Adrian
> __________
>=20
> [1] - http://csrc.nist.gov/groups/STM/cavp/standards.html
> [2] - http://csrc.nist.gov/publications/nistpubs/800-20/800-20.pdf
> [3] - http://csrc.nist.gov/groups/STM/cavp/documents/des/tripledes-ve=
ctors.zip
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
