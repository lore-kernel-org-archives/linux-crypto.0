From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Sun, 23 Apr 2017 12:48:58 +0300
Message-ID: <CAOtvUMcOib2xr=THj1hy_uPtVhRHgJ2-4__mUBb5VwANQ1GA_A@mail.gmail.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
 <1492693983-8175-7-git-send-email-gilad@benyossef.com> <6020947.G2hzgUSCE3@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:33143 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1044448AbdDWJtA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 05:49:00 -0400
Received: by mail-yb0-f170.google.com with SMTP id 81so54474088ybp.0
        for <linux-crypto@vger.kernel.org>; Sun, 23 Apr 2017 02:49:00 -0700 (PDT)
In-Reply-To: <6020947.G2hzgUSCE3@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Thank you for the review.

On Thu, Apr 20, 2017 at 4:39 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:

>> +/* The function verifies that tdes keys are not weak.*/
>> +static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen=
)
>> +{
>> +#ifdef CCREE_FIPS_SUPPORT
>> +        tdes_keys_t *tdes_key =3D (tdes_keys_t*)key;
>> +
>> +     /* verify key1 !=3D key2 and key3 !=3D key2*/
>
> I do not think that this check is necessary. There is no FIPS requirement=
 or
> IG that mandates this (unlike the XTS key check).
>
> If there would be such requirement, we would need a common service functi=
on
> for all TDES implementations

I am not sure. I have forwarded a question internally and based on the
answer will either drop this or add a common function and post a patch
add the check to all 3DES implementation.

This has been added to the staging TODO list for the driver.

>
>> +        if (unlikely( (memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2,
>> sizeof(tdes_key->key1)) =3D=3D 0) || +                  (memcmp((u8*)tde=
s_key->key3,
>> (u8*)tdes_key->key2, sizeof(tdes_key->key3)) =3D=3D 0) )) { +
>> return -ENOEXEC;
>> +        }
>> +#endif /* CCREE_FIPS_SUPPORT */
>> +
>> +        return 0;
>> +}
>> +
>> +/* The function verifies that xts keys are not weak.*/
>> +static int ssi_fips_verify_xts_keys(const u8 *key, unsigned int keylen)
>> +{
>> +#ifdef CCREE_FIPS_SUPPORT
>> +        /* Weak key is define as key that its first half (128/256 lsb)
>> equals its second half (128/256 msb) */ +        int singleKeySize =3D k=
eylen
>> >> 1;
>> +
>> +     if (unlikely(memcmp(key, &key[singleKeySize], singleKeySize) =3D=
=3D 0)) {
>> +             return -ENOEXEC;
>
> Use xts_check_key.

Will fix. Added to TODO staging list for the driver.

>
>> +The test vectors were taken from:
>> +
>> +* AES
>> +NIST Special Publication 800-38A 2001 Edition
>> +Recommendation for Block Cipher Modes of Operation
>> +http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf
>> +Appendix F: Example Vectors for Modes of Operation of the AES
>> +
>> +* AES CTS
>> +Advanced Encryption Standard (AES) Encryption for Kerberos 5
>> +February 2005
>> +https://tools.ietf.org/html/rfc3962#appendix-B
>> +B.  Sample Test Vectors
>> +
>> +* AES XTS
>> +http://csrc.nist.gov/groups/STM/cavp/#08
>> +http://csrc.nist.gov/groups/STM/cavp/documents/aes/XTSTestVectors.zip
>> +
>> +* AES CMAC
>> +http://csrc.nist.gov/groups/STM/cavp/index.html#07
>> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/cmactestvectors.zip
>> +
>> +* AES-CCM
>> +http://csrc.nist.gov/groups/STM/cavp/#07
>> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/ccmtestvectors.zip
>> +
>> +* AES-GCM
>> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/gcmtestvectors.zip
>> +
>> +* Triple-DES
>> +NIST Special Publication 800-67 January 2012
>> +Recommendation for the Triple Data Encryption Algorithm (TDEA) Block Ci=
pher
>> +http://csrc.nist.gov/publications/nistpubs/800-67-Rev1/SP-800-67-Rev1.p=
df
>> +APPENDIX B: EXAMPLE OF TDEA FORWARD AND INVERSE CIPHER OPERATIONS +and
>> +http://csrc.nist.gov/groups/STM/cavp/#01
>> +http://csrc.nist.gov/groups/STM/cavp/documents/des/tdesmct_intermediate=
.zip
>> +
>> +* HASH
>> +http://csrc.nist.gov/groups/STM/cavp/#03
>> +http://csrc.nist.gov/groups/STM/cavp/documents/shs/shabytetestvectors.z=
ip
>> +
>> +* HMAC
>> +http://csrc.nist.gov/groups/STM/cavp/#07
>> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/hmactestvectors.zip
>> +
>> +*/
>
> Is this test vector business really needed? Why do you think that testmgr=
.c is
> not sufficient? Other successful FIPS validations of the kernel crypto AP=
I
> managed without such special code.

That is a very good question. I am guessing this has something to do
to with this driver spending its life out of tree and being maintained
against old kernel versions that may have had some gaps in FIPS
testing and since fixed.

I will review what, if at all, is missing from testmgr and fold those
missing parts (if found) there and drop this from the driver.

>
> Also, your entire API seems to implement the approach that if there is a =
self
> test error, you disable the cipher functions, but leave the rest in-tact.=
 The
> standard kernel crypto API handling logic is to simply panic the kernel. =
Is it
> really necessary to implement a special case for your driver?
>
>

No it isn't. What ever the behavior we need it should be added,
pending review of course, to the generic FIPS logic handling.

I do wonder if there is value in alternate behavior of stopping crypto
API on FIPS error rather than a panic though. I will try to get an
explanation why we do it this way.

Handling all these has been added to the driver staging TODO list and
will be handled before it matures into drivers/crypto/

Many thanks for the review!

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
