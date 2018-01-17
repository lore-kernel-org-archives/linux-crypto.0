From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: kernel failure while loading X.509 certificate
Date: Wed, 17 Jan 2018 07:03:10 +0100
Message-ID: <6C0341FB-6557-4C48-8232-938AB4A4EA72@linaro.org>
References: <F5505112-180F-4889-A73E-D0AB9054E58E@linaro.org>
 <CAK8P3a1E6YOXK2heCz0eiaQLpzpb6jjnvyNK_Y4Fu8bjZuPDZw@mail.gmail.com>
 <48DEA233-E708-4661-B5F0-15CEC60877E4@linaro.org>
 <20180117051627.GA15527@zzz.localdomain>
 <88A6FE91-795D-4F17-BF8C-E597239A2C46@linaro.org>
 <20180117054415.GB15527@zzz.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        David Howells <dhowells@redhat.com>,
        crypto <linux-crypto@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34686 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeAQGDP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 01:03:15 -0500
Received: by mail-wm0-f44.google.com with SMTP id 81so20203513wmb.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jan 2018 22:03:15 -0800 (PST)
In-Reply-To: <20180117054415.GB15527@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> Il giorno 17 gen 2018, alle ore 06:44, Eric Biggers =
<ebiggers3@gmail.com> ha scritto:
>=20
> On Wed, Jan 17, 2018 at 06:36:16AM +0100, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 17 gen 2018, alle ore 06:16, Eric Biggers =
<ebiggers3@gmail.com> ha scritto:
>>>=20
>>> Hi Paolo,
>>>=20
>>> On Fri, Jan 12, 2018 at 07:06:12AM +0100, Paolo Valente wrote:
>>>>=20
>>>>=20
>>>>> Il giorno 11 gen 2018, alle ore 23:37, Arnd Bergmann =
<arnd@arndb.de> ha scritto:
>>>>>=20
>>>>> On Thu, Jan 11, 2018 at 7:29 PM, Paolo Valente =
<paolo.valente@linaro.org> wrote:
>>>>>> Hi guys,
>>>>>> this is a help request, for a problem that has been driving me =
crazy
>>>>>> all day long, without any success :(
>>>>>>=20
>>>>>> I've compiled a 4.15-rc7 custom kernel on a freshly-installed =
Fedora
>>>>>> 27, using the usual "make ; make modules_install ; make install"
>>>>>> procedure. No error reported while building.  But at boot the
>>>>>> kernel immediately fails as follows, apparently while =
loading/parsing
>>>>>> an X.509 certificate:
>>>>>=20
>>>>> The BUG_ON() you hit is this one in public_key_verify_signature():
>>>>>=20
>>>>>      BUG_ON(!sig->digest);
>>>>>=20
>>>>> There was a patch series by Eric Biggers that touched these files =
to
>>>>> add some fixes
>>>>> after v4.15-rc1.  I'm not runnig that code myself, but it sounds =
like
>>>>> a real regression,
>>>>> so I'm adding Eric (to look at the code), the corresponding =
mailing
>>>>> list and Thorsten
>>>>> (for regression tracking) to Cc.
>>>>>=20
>>>>> x509_cert_parse() allocates the 'cert->sig' structure, and calls
>>>>> x509_get_sig_params(),
>>>>> which may or may not allocate a digest. It returns with
>>>>> cert->unsupported_sig=3Dtrue
>>>>> in case it fails to allocate a digest for some reason =
(crypto_alloc_shash failed
>>>>> or no sig->hash_algo).
>>>>>=20
>>>>> The full set of Eric's patches is
>>>>>=20
>>>>> 54c1fb39fe04 X.509: fix comparisons of ->pkey_algo
>>>>> 18026d866801 KEYS: reject NULL restriction string when type is =
specified
>>>>> 3d1f0255426a security: keys: remove redundant assignment to =
key_ref
>>>>> aa3300362060 X.509: use crypto_shash_digest()
>>>>> 72f9a07b6bfa KEYS: be careful with error codes in =
public_key_verify_signature()
>>>>> a80745a6de51 pkcs7: use crypto_shash_digest()
>>>>> 7204eb8590c7 pkcs7: fix check for self-signed certificate
>>>>> 8ecb506d3476 pkcs7: return correct error code if =
pkcs7_check_authattrs() fails
>>>>> 8dfd2f22d3bf 509: fix printing uninitialized stack memory when OID =
is empty
>>>>> 47e0a208fb9d X.509: fix buffer overflow detection in sprint_oid()
>>>>> 0f30cbea005b X.509: reject invalid BIT STRING for subjectPublicKey
>>>>> 81a7be2cd69b ASN.1: check for error from ASN1_OP_END__ACT actions
>>>>> e0058f3a874e ASN.1: fix out-of-bounds read when parsing indefinite =
length item
>>>>> 4dca6ea1d943 KEYS: add missing permission check for request_key() =
destination
>>>>> a2d8737d5c78 KEYS: remove unnecessary get/put of explicit =
dest_keyring
>>>>>=20
>>>>> and it's based on -rc2. If you want to do a quicker bisection, I'd
>>>>> suggest you try
>>>>> 4.15-rc2 and 54c1fb39fe04 to start with.
>>>>>=20
>>>>=20
>>>> Thank you very much Arnd.  Fortunately, for the task I'm =
performing, a
>>>> 4.14 will do too.  And I'm under pressure to finally finish this =
task.
>>>> Yet, even before I finish with this task, I'm willing to do any =
test
>>>> that the guys you added may want me to do.  And, if more useful for
>>>> the community, ok for me to switch to the most appropriate public
>>>> mailing lists.
>>>>=20
>>>=20
>>> Have you managed to bisect this yet?  I'm not seeing how my changes =
could have
>>> caused this, but it does seem there may be an existing bug where =
this BUG() can
>>> be hit if a certificate's signature uses a hash algorithm that is =
not built into
>>> the kernel.  To verify whether that is happening can you try adding:
>>>=20
>>> diff --git a/crypto/asymmetric_keys/x509_public_key.c =
b/crypto/asymmetric_keys/x509_public_key.c
>>> index 9338b4558cdc..f1804640445a 100644
>>> --- a/crypto/asymmetric_keys/x509_public_key.c
>>> +++ b/crypto/asymmetric_keys/x509_public_key.c
>>> @@ -58,6 +58,8 @@ int x509_get_sig_params(struct x509_certificate =
*cert)
>>> 	tfm =3D crypto_alloc_shash(sig->hash_algo, 0, 0);
>>> 	if (IS_ERR(tfm)) {
>>> 		if (PTR_ERR(tfm) =3D=3D -ENOENT) {
>>> +			pr_err("Hash algorithm %s not supported by =
crypto API\n",
>>> +			       sig->hash_algo);
>>> 			cert->unsupported_sig =3D true;
>>> 			return 0;
>>> 		}
>>>=20
>>> If the pr_err() is hit then check the status of the corresponding =
CONFIG_CRYPTO_
>>> option in your .config, for example CONFIG_CRYPTO_SHA256 if the =
algorithm is
>>> "sha256".
>>>=20
>>=20
>> Hi Eric,
>> in the meantime I have moved to rc8, and the problem has disappeared.
>> Does this ring any bell?  Otherwise, I'll retry with rc7 after adding
>> your error message.
>>=20
>> Thanks,
>> Paolo
>>=20
>=20
> No, it doesn't ring a bell.  Is it possible you changed your kernel =
config
> between rc7 and rc8?

I have used the same procedure to generate for both configs: with a
4.14 running,
./scripts/kconfig/streamline_config.pl > ~/linux-build/.config

Unfortunately, I have overwritten the config I used for rc7.  I'll
repeat my workflow for rc7 and get back to you.

Thanks,
Paolo
