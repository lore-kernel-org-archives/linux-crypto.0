From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in
 cbc mode
Date: Mon, 02 Jun 2008 23:55:46 +0200
Message-ID: <48446C62.60502@swiss-it.ch>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <484038CE.2080606@swiss-it.ch> <20080530224622.GA1788@gondor.apana.org.au> <20080531163718.GB3130@localhost.localdomain> <4841FEF7.4020203@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:46290 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYFBVzv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 17:55:51 -0400
In-Reply-To: <4841FEF7.4020203@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adrian-Ken Rueegsegger wrote:
> Neil Horman wrote:
>> On Sat, May 31, 2008 at 08:46:22AM +1000, Herbert Xu wrote:
>>> On Fri, May 30, 2008 at 07:26:38PM +0200, Adrian-Ken R=FCegsegger w=
rote:
>>>> I was wondering why you created your own test vectors. Wouldn't st=
andardized test vectors by NIST or ANSI be preferable?
>>> If you could post a patch with those that would be very much
>>> appreciated.  Thanks!
>=20
> I am putting together a patch using the test vectors found at [3] and=
 the ones I gathered from ANSI X9.52 and ISO/IEC FDIS 10116:2005. Stran=
ge enough the ANSI and ISO test vectors pass while the ones from NIST d=
o not yield the expected results. I have not yet identified the specifi=
c differences between the various test vector sets. It is not clearly s=
tated if/which padding was employed so that might be the reason...

The reason for getting different results with test vectors from [3] is,=
 that one must repeatedly
apply the encryption/decryption 10000 times eventhough it's not clearly=
 specified in that document
itself. The Monte Carlo test that has to be used to get the results is =
described in [2]
(section 3.2, page 24).

Adrian
=20
>> For future reference, do you have a link where NIST standard test ve=
ctors can be
>> obtained?
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
