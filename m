From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in
 cbc mode
Date: Sun, 01 Jun 2008 18:19:24 +0200
Message-ID: <4842CC0C.2090703@swiss-it.ch>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <484038CE.2080606@swiss-it.ch> <20080530224622.GA1788@gondor.apana.org.au> <20080531163718.GB3130@localhost.localdomain> <4841FEF7.4020203@swiss-it.ch> <20080601155408.GA4737@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:60828 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYFAQT2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Jun 2008 12:19:28 -0400
In-Reply-To: <20080601155408.GA4737@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Neil Horman wrote:
> On Sun, Jun 01, 2008 at 03:44:23AM +0200, Adrian-Ken Rueegsegger wrot=
e:
>> Neil Horman wrote:
>>> On Sat, May 31, 2008 at 08:46:22AM +1000, Herbert Xu wrote:
>>>> On Fri, May 30, 2008 at 07:26:38PM +0200, Adrian-Ken R=FCegsegger =
wrote:
>>>>> I was wondering why you created your own test vectors. Wouldn't s=
tandardized test vectors by NIST or ANSI be preferable?
>>>> If you could post a patch with those that would be very much
>>>> appreciated.  Thanks!
>> I am putting together a patch using the test vectors found at [3] an=
d the ones I gathered from ANSI X9.52 and ISO/IEC FDIS 10116:2005. Stra=
nge enough the ANSI and ISO test vectors pass while the ones from NIST =
do not yield the expected results. I have not yet identified the specif=
ic differences between the various test vector sets. It is not clearly =
stated if/which padding was employed so that might be the reason...
>>
>=20
> I thought that TDES input/output vectors had to be an even multiple o=
f the key
> length.  As such if the vectors aren't an even multiple, doesn't padd=
ing have to
> be employed?

It's actually multiple of the cipher's block length, which all plain-/c=
iphertext values of the test vectors are. I some cases keys are also pa=
dded if one only supplies 2 keys and not 3 (192 bits in total). Since I=
 used the test vectors with three distinct 64 bit keys I was wrong with=
 my thinking that padding could be an issue. As you mentioned in the ot=
her mail, I will see if something with my setup is off.

Adrian
>>> For future reference, do you have a link where NIST standard test v=
ectors can be
>>> obtained?
>> A good place to start is [1]. More specifically for TDES: [2] and [3=
]. Note that the tests described in [2] will not work with the current =
DES3 implementation since the employed keys will be identified as weak =
keys and the setkey operation would fail.
>>
>> By the way: when explicitly trying to set a weak key for DES3 I got =
the following warning:
>>
>> setkey() failed flags=3D0
>>
>> Shouldn't the flags be set to CRYPTO_TFM_RES_BAD_KEY_SCHED at that p=
oint (see crypto/des_generic.c, line 873)?
> I ran into this too when I wrote my vector. I'm not sure why this is =
happening,
> as it appears the *flags->crt_flags | FLAGS statements should set the=
se.  I'm
> looking into why
> Neil
>=20
>> Thanks,
>> Adrian
>> __________
>>
>> [1] - http://csrc.nist.gov/groups/STM/cavp/standards.html
>> [2] - http://csrc.nist.gov/publications/nistpubs/800-20/800-20.pdf
>> [3] - http://csrc.nist.gov/groups/STM/cavp/documents/des/tripledes-v=
ectors.zip
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
