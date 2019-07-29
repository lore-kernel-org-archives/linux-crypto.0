Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7320C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C294206DD
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="h88S55JL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfG2JKo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 05:10:44 -0400
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:64146
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbfG2JKo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 05:10:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThgWRXmMUFpyUdWlVPQ5XD2AOw9n9CwsC9Pl0x26j4+K8sXSNCi9n2/Hf1Js9RpgsRgrPSA6K/06IJY5n0RjMNjT7+oMIwCAKVBa5bzIlaJHuGOlByf1kvVVgBp+CdSFGrx5P5rXRbC9RyvtrJtBl4uJkvZbtvU7cb9ezDreGJfYgEVXzbOMg1DyM0TSatULRbnjn0GjMgCGhKoWmqGrmA6gTOpUMR1fvTQVbVFxtKOkbiLFBOQq81VOT1XCj5RJNikfw477+hK9xZDIw/uDJGKAvwO6APHKlwgF7oEe4lFdKIK7huSSEXP6s02X5ZLSa0a4m+rxgXfiWX7shS3jbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOf6S7Gd0jX2pld6+QnzYm9AzyWqHsFU1NJeO+Qa2ZA=;
 b=C7CAAxTi/uu8jWQBxprmr3BEXTR+kzk1Pq1HdLWeo196c7S1T8MXTGjqDOjGGjm7uK8gmuRVqklplMvJqZt3qHGd+xJcBY/UgD8P6+rCFsK3ca9W2gsWSkuOWCg8RRc2hiOzXIRY6yLxXNO66vSsqKUdDq+l5fOByjQaUSztWulkECS9MD+WA9/dHkSDH1Yn+nXJo0qC7hgX8r6EB2x+P4R544N4aTm4DyemjhSntChRefW8yIc+3VbnJrDB3OAJhyntz5gxbR9OKVu5LAeqsyA43HKwp6mXl1xuo3Pi9AQu5DpXhnbU7F95wmisPs10E8Mo+ZAiN3NStSa7okitAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOf6S7Gd0jX2pld6+QnzYm9AzyWqHsFU1NJeO+Qa2ZA=;
 b=h88S55JLbgGdt4r7uu9ETbWOey/TklNZtSadG9ZMRuUPpSYPBJfKof/xv/DiFzSlObVNr5tZpwfHvuEJYUYlQfqXSrgpKXocoYAxYutk4UDX7Y0CYzLnyUdMKlMdJgzhYzrM4MIZqP9es0cRuXwc1TsWykf4fhl3cR39kwkczkQ=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2957.namprd20.prod.outlook.com (52.132.172.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 09:10:38 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 09:10:38 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Topic: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHA=
Date:   Mon, 29 Jul 2019 09:10:38 +0000
Message-ID: <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
In-Reply-To: <20190728173040.GA699@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85c3635b-0cc2-4fe6-aba2-08d714049f83
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2957;
x-ms-traffictypediagnostic: MN2PR20MB2957:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB29579CC7B01D48960B0AB1F5CADD0@MN2PR20MB2957.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39840400004)(396003)(346002)(136003)(13464003)(51914003)(199004)(189003)(6506007)(102836004)(5660300002)(76176011)(53546011)(81156014)(81166006)(8676002)(25786009)(30864003)(52536014)(186003)(26005)(66476007)(68736007)(7696005)(66946007)(8936002)(66446008)(66556008)(64756008)(7736002)(76116006)(99286004)(6246003)(4326008)(6116002)(3846002)(74316002)(229853002)(14454004)(11346002)(14444005)(446003)(256004)(54906003)(6436002)(305945005)(9686003)(66066001)(71190400001)(71200400001)(55016002)(110136005)(316002)(486006)(15974865002)(476003)(86362001)(2906002)(33656002)(478600001)(53946003)(53936002)(579004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2957;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0LXeTvPQ4Ait8gqwMOdOula7EdcTpwgCn8ueePy72CwJEljIxvLn7jg5y/nMfA0n9JZGOEiqjoOrSzVerM+gd1sAhfK4YYhA/PdZZUPT5b1l/F8SrWwn0Vm+LdcUIuGkmnmv4JRK0S7l4+hf1Fx+Bc7KALoSNlc4CGA28N81zAu8W0/YGzSNxQFSKki20tonpryPvyHMS4QKI5YrLZ7L+bcqWPdPIzM731pD68qrph10J/v4pERwhlNPX180yZjJ/cX0kzyhw+s4f+WlaHlAhibaqAByAacKCW1cTy4u2Ic+GXMKXqVuiAourf+HVtOCzFbpK0i8XADxEicH9MHs9n0RE/GNiNgBT4X5bybbdduY/Pf2myMbLAQGceVEF/Yq4OHlwj3olTzBWkYdAiBUT/bJqrEawTbl19xs8zIVdWQ=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c3635b-0cc2-4fe6-aba2-08d714049f83
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 09:10:38.3086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2957
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

Thanks for your feedback!

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Sunday, July 28, 2019 7:31 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@dave=
mloft.net; Pascal Van Leeuwen
> <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params fo=
r AEAD fuzz testing
>=20
> Hi Pascal, thanks for the patch!
>=20
> On Wed, Jul 24, 2019 at 11:35:17AM +0200, Pascal van Leeuwen wrote:
> > The probability of hitting specific input length corner cases relevant
> > for certain hardware driver(s) (specifically: inside-secure) was found
> > to be too low. Additionally, for authenc AEADs, the probability of
> > generating a *legal* key blob approached zero, i.e. most vectors
> > generated would only test the proper generation of a key blob error.
> >
> > This patch address both of these issues by improving the random
> > generation of data lengths (for the key, but also for the ICV output
> > and the AAD and plaintext inputs), making the random generation
> > individually tweakable on a per-ciphersuite basis.
> >
> > Finally, this patch enables fuzz testing for AEAD ciphersuites that do
> > not have a regular testsuite defined as it no longer depends on that
> > regular testsuite for figuring out the key size.
> >
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
>=20
> More comments below, but first I see some test failures and warnings with=
 this
> patch applied:
>=20
> alg: aead: authenc(hmac(sha1-generic),cbc-aes-aesni) decryption failed on=
 test vector "random: alen=3D26 plen=3D594 authsize=3D20 klen=3D60";
> expected_error=3D-22, actual_error=3D-74, cfg=3D"random: may_sleep use_di=
gest src_divs=3D[33.6%@+12, 18.23%@+2452, 13.7%@+3761,
> 35.64%@+4019] iv_offset=3D43"
>
Interesting as the inside-secure driver also advertises this ciphersuite an=
d does not generate such=20
an error.  My guess is you get an error here because plen is not a multiple=
 of 16 and this is CBC
(note to self: for block ciphers, emphasize legal lengths in the randomizat=
ion ...), but the generic
implementation returns -EINVAL while this ciphersuite returns -EBADMSG.
Don't ask me what the actual correct error is in this case, I'm following g=
eneric with my driver.

> alg: aead: empty test suite for authenc(hmac(sha1-ni),rfc3686(ctr(aes-gen=
eric)))
> alg: aead: empty test suite for authenc(hmac(sha1-generic),rfc3686(ctr(ae=
s-generic)))
> alg: aead: authenc(hmac(sha256-generic),cbc-aes-aesni) decryption failed =
on test vector "random: alen=3D14 plen=3D6237 authsize=3D32
> klen=3D72"; expected_error=3D-22, actual_error=3D-74, cfg=3D"random: may_=
sleep use_digest src_divs=3D[93.90%@+2019, 4.74%@alignmask+4094,
> 1.36%@+21] dst_divs=3D[100.0%@+4000]"
>
Idem

> alg: aead: empty test suite for authenc(hmac(sha256-ni),rfc3686(ctr-aes-a=
esni))
> alg: aead: empty test suite for authenc(hmac(sha256-generic),rfc3686(ctr(=
aes-generic)))
> alg: aead: empty test suite for authenc(hmac(sha384-avx2),rfc3686(ctr-aes=
-aesni))
> alg: aead: empty test suite for authenc(hmac(sha384-generic),rfc3686(ctr(=
aes-generic)))

> alg: aead: authenc(hmac(sha512-generic),cbc-aes-aesni) decryption failed =
on test vector "random: alen=3D14 plen=3D406 authsize=3D12
> klen=3D104"; expected_error=3D-22, actual_error=3D-74, cfg=3D"random: may=
_sleep use_digest src_divs=3D[41.41%@+852, 58.59%@+4011]
> dst_divs=3D[100.0%@alignmask+4017]"
>
Idem

> alg: aead: empty test suite for authenc(hmac(sha512-avx2),rfc3686(ctr-aes=
-aesni))
> alg: aead: empty test suite for authenc(hmac(sha512-generic),rfc3686(ctr(=
aes-generic)))
>=20
>=20
> Note that the "empty test suite" message shouldn't be printed (especially=
 not at
> KERN_ERR level!) if it's working as intended.
>=20
That's not my code, that was already there. I already got these messages be=
fore my=20
modifications, for some ciphersuites. Of course if we don't want that, we c=
an make
it a pr_warn pr_dbg?

> > ---
> >  crypto/testmgr.c | 269 +++++++++++++++++++++++++++++++++++++++++++----=
--
> >  crypto/testmgr.h | 298 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  2 files changed, 535 insertions(+), 32 deletions(-)
> >
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 2ba0c48..9c856d3 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -84,11 +84,24 @@ int alg_test(const char *driver, const char *alg, u=
32 type, u32 mask)
> >  #define ENCRYPT 1
> >  #define DECRYPT 0
> >
> > +struct len_range_set {
> > +	const struct len_range_sel *lensel;
> > +	unsigned int count;
> > +};
> > +
> >  struct aead_test_suite {
> >  	const struct aead_testvec *vecs;
> >  	unsigned int count;
> >  };
> >
> > +struct aead_test_params {
> > +	struct len_range_set ckeylensel;
> > +	struct len_range_set akeylensel;
> > +	struct len_range_set authsizesel;
> > +	struct len_range_set aadlensel;
> > +	struct len_range_set ptxtlensel;
> > +};
> > +
> >  struct cipher_test_suite {
> >  	const struct cipher_testvec *vecs;
> >  	unsigned int count;
> > @@ -143,6 +156,10 @@ struct alg_test_desc {
> >  		struct akcipher_test_suite akcipher;
> >  		struct kpp_test_suite kpp;
> >  	} suite;
> > +
> > +	union {
> > +		struct aead_test_params aead;
> > +	} params;
> >  };
>=20
> Why not put these new fields in the existing 'struct aead_test_suite'?
>=20
> I don't see the point of the separate 'params' struct.  It just confuses =
things.
>=20
Mostly because I'm not that familiar with C datastructures (I'm not a progr=
ammer
and this is pretty much my first serious experience with C), so I didn't kn=
ow how
to do that / didn't want to break anything else :-)

So if you can provide some example on how to do that ...

> >
> >  static void hexdump(unsigned char *buf, unsigned int len)
> > @@ -189,9 +206,6 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
> >  	__testmgr_free_buf(buf, 0);
> >  }
> >
> > -#define TESTMGR_POISON_BYTE	0xfe
> > -#define TESTMGR_POISON_LEN	16
> > -
> >  static inline void testmgr_poison(void *addr, size_t len)
> >  {
> >  	memset(addr, TESTMGR_POISON_BYTE, len);
> > @@ -2035,6 +2049,19 @@ static int test_aead_vec(const char *driver, int=
 enc,
> >  }
> >
> >  #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
> > +/* Select a random length value from a list of range specs */
>=20
> Perhaps mention the meaning of the -1 return value in this comment?
>=20
Ok

> > +int random_lensel(const struct len_range_set *lens)
>=20
> static
>=20
Yes

> > +{
> > +	u32 i, sel =3D prandom_u32() % 1000;
> > +
> > +	for (i =3D 0; i < lens->count; i++)
> > +		if (sel < lens->lensel[i].threshold)
> > +			return (prandom_u32() % (lens->lensel[i].len_hi  -
> > +						 lens->lensel[i].len_lo + 1)) +
> > +				lens->lensel[i].len_lo;
> > +	return -1;
> > +}
>=20
> This function isn't really AEAD-specific, so it seems it should be moved =
to near
> the other common fuzz test helpers like generate_random_length(), rather =
than be
> here where the AEAD-specific code is.
>=20
It's currently only used for AEAD, but good point.

> > +
> >  /*
> >   * Generate an AEAD test vector from the given implementation.
> >   * Assumes the buffers in 'vec' were already allocated.
> > @@ -2043,44 +2070,83 @@ static void generate_random_aead_testvec(struct=
 aead_request *req,
> >  					 struct aead_testvec *vec,
> >  					 unsigned int maxkeysize,
> >  					 unsigned int maxdatasize,
> > +					 const struct aead_test_params *lengths,
> >  					 char *name, size_t max_namelen)
> >  {
> >  	struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> >  	const unsigned int ivsize =3D crypto_aead_ivsize(tfm);
> >  	unsigned int maxauthsize =3D crypto_aead_alg(tfm)->maxauthsize;
> > -	unsigned int authsize;
> > +	int authsize, clen, alen;
> >  	unsigned int total_len;
> >  	int i;
> >  	struct scatterlist src[2], dst;
> >  	u8 iv[MAX_IVLEN];
> >  	DECLARE_CRYPTO_WAIT(wait);
> >
> > -	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
> > -	vec->klen =3D maxkeysize;
> > -	if (prandom_u32() % 4 =3D=3D 0)
> > -		vec->klen =3D prandom_u32() % (maxkeysize + 1);
> > -	generate_random_bytes((u8 *)vec->key, vec->klen);
> > +	alen =3D random_lensel(&lengths->akeylensel);
> > +	clen =3D random_lensel(&lengths->ckeylensel);
> > +	if ((alen >=3D 0) && (clen >=3D 0)) {
> > +		/* Corect blob header. TBD: Do we care about corrupting this? */
> > +#ifdef __LITTLE_ENDIAN
> > +		memcpy((void *)vec->key, "\x08\x00\x01\x00\x00\x00\x00\x10", 8);
> > +#else
> > +		memcpy((void *)vec->key, "\x00\x08\x00\x01\x00\x00\x00\x10", 8);
> > +#endif
>=20
> Isn't this specific to "authenc" AEADs?  There needs to be something in t=
he test
> suite that says an authenc formatted key is needed.
>=20
It's under the condition of seperate authentication (alen) and cipher (clen=
) keys,
true AEAD's only have a single key. Because if they hadn't, they would also=
 need
this kind of key blob thing (at least for consistency) and need this code.

> > +
> > +		/* Generate keys based on length templates */
> > +		generate_random_bytes((u8 *)(vec->key + 8), alen);
> > +		generate_random_bytes((u8 *)(vec->key + 8 + alen),
> > +				      clen);
> > +
> > +		vec->klen =3D 8 + alen + clen;
> > +	} else {
> > +		if (clen >=3D 0)
> > +			maxkeysize =3D clen;
> > +
> > +		vec->klen =3D maxkeysize;
> > +
> > +		/*
> > +		 * Key: length in [0, maxkeysize],
> > +		 * but usually choose maxkeysize
> > +		 */
> > +		if (prandom_u32() % 4 =3D=3D 0)
> > +			vec->klen =3D prandom_u32() % (maxkeysize + 1);
> > +		generate_random_bytes((u8 *)vec->key, vec->klen);
> > +	}
> >  	vec->setkey_error =3D crypto_aead_setkey(tfm, vec->key, vec->klen);
>=20
> The generate_random_aead_testvec() function is getting too long and compl=
icated.
>
I'll ignore that comment to avoid starting some flame war ;-)

> It doesn't help that now the 'clen' variable is used for multiple differe=
nt
> purposes (encryption key length and ciphertext length). =20
>
Ah yeah, actually I had seperate variables for that which I at some point m=
erged to
save some stack space. Blame it on me being oldschool ;-)

> Could you maybe factor out the key generation into a separate function?
>=20
I could, if that would make people happy ...

> >
> >  	/* IV */
> >  	generate_random_bytes((u8 *)vec->iv, ivsize);
> >
> > -	/* Tag length: in [0, maxauthsize], but usually choose maxauthsize */
> > -	authsize =3D maxauthsize;
> > -	if (prandom_u32() % 4 =3D=3D 0)
> > -		authsize =3D prandom_u32() % (maxauthsize + 1);
> > +	authsize =3D random_lensel(&lengths->authsizesel);
> > +	if (authsize < 0) {
> > +		/*
> > +		 * Tag length: in [0, maxauthsize],
> > +		 * but usually choose maxauthsize
> > +		 */
> > +		authsize =3D maxauthsize;
> > +		if (prandom_u32() % 4 =3D=3D 0)
> > +			authsize =3D prandom_u32() % (maxauthsize + 1);
> > +	}
> >  	if (WARN_ON(authsize > maxdatasize))
> >  		authsize =3D maxdatasize;
> > -	maxdatasize -=3D authsize;
> >  	vec->setauthsize_error =3D crypto_aead_setauthsize(tfm, authsize);
>=20
> Updating the comments to better match the code changes would be helpful t=
oo.
> E.g. here comments like the following would be helpful:
>=20
>         /* Authentication tag size */
>         authsize =3D random_lensel(&lengths->authsizesel);
>         if (authsize < 0) {
>                 /*
>                  * No length hints for this algorithm.  Fall back to a ra=
ndom
>                  * value in [0, maxauthsize], but usually choose maxauths=
ize.
>                  */
>                 authsize =3D maxauthsize;
>                 if (prandom_u32() % 4 =3D=3D 0)
>                         authsize =3D prandom_u32() % (maxauthsize + 1);
>         }
>=20
Agree

> >
> >  	/* Plaintext and associated data */
> > -	total_len =3D generate_random_length(maxdatasize);
> > -	if (prandom_u32() % 4 =3D=3D 0)
> > -		vec->alen =3D 0;
> > -	else
> > -		vec->alen =3D generate_random_length(total_len);
> > -	vec->plen =3D total_len - vec->alen;
> > +	alen =3D random_lensel(&lengths->aadlensel);
> > +	clen =3D random_lensel(&lengths->ptxtlensel);
> > +	maxdatasize -=3D authsize;
> > +	if ((alen < 0) || (clen < 0) || ((alen + clen) > maxdatasize)) {
> > +		total_len =3D generate_random_length(maxdatasize);
> > +		if (prandom_u32() % 4 =3D=3D 0)
> > +			vec->alen =3D 0;
> > +		else
> > +			vec->alen =3D generate_random_length(total_len);
> > +		vec->plen =3D total_len - vec->alen;
> > +	} else {
> > +		vec->alen =3D alen;
> > +		vec->plen =3D clen;
> > +	}
> >  	generate_random_bytes((u8 *)vec->assoc, vec->alen);
> >  	generate_random_bytes((u8 *)vec->ptext, vec->plen);
> >
> > @@ -2133,7 +2199,7 @@ static int test_aead_vs_generic_impl(const char *=
driver,
> >  	char _generic_driver[CRYPTO_MAX_ALG_NAME];
> >  	struct crypto_aead *generic_tfm =3D NULL;
> >  	struct aead_request *generic_req =3D NULL;
> > -	unsigned int maxkeysize;
> > +	unsigned int maxkeysize, maxakeysize;
> >  	unsigned int i;
> >  	struct aead_testvec vec =3D { 0 };
> >  	char vec_name[64];
> > @@ -2203,9 +2269,27 @@ static int test_aead_vs_generic_impl(const char =
*driver,
> >  	 */
> >
> >  	maxkeysize =3D 0;
> > -	for (i =3D 0; i < test_desc->suite.aead.count; i++)
> > +	for (i =3D 0; i < test_desc->params.aead.ckeylensel.count; i++)
> >  		maxkeysize =3D max_t(unsigned int, maxkeysize,
> > -				   test_desc->suite.aead.vecs[i].klen);
> > +			test_desc->params.aead.ckeylensel.lensel[i].len_hi);
> > +
> > +	if (maxkeysize && test_desc->params.aead.akeylensel.count) {
> > +		/* authenc, explicit keylen ranges defined, use them */
> > +		maxakeysize =3D 0;
> > +		for (i =3D 0; i < test_desc->params.aead.akeylensel.count; i++)
> > +			maxakeysize =3D max_t(unsigned int, maxakeysize,
> > +			   test_desc->params.aead.akeylensel.lensel[i].len_hi);
> > +		maxkeysize =3D 8 + maxkeysize + maxakeysize;
> > +	} else if (!maxkeysize && test_desc->suite.aead.count) {
> > +		/* attempt to derive from test vectors */
> > +		for (i =3D 0; i < test_desc->suite.aead.count; i++)
> > +			maxkeysize =3D max_t(unsigned int, maxkeysize,
> > +					test_desc->suite.aead.vecs[i].klen);
> > +	} else {
> > +		pr_err("alg: aead: no key length templates or test vectors for %s - =
unable to fuzz\n",
> > +		       driver);
> > +		err =3D -EINVAL;
> > +	}
>=20
> Can you put the "find the maxkeysize" logic in its own function, so it do=
esn't
> make test_aead_vs_generic_impl() longer and harder to understand?
>=20
I could ... :-)

> >
> >  	vec.key =3D kmalloc(maxkeysize, GFP_KERNEL);
> >  	vec.iv =3D kmalloc(ivsize, GFP_KERNEL);
> > @@ -2220,6 +2304,7 @@ static int test_aead_vs_generic_impl(const char *=
driver,
> >  	for (i =3D 0; i < fuzz_iterations * 8; i++) {
> >  		generate_random_aead_testvec(generic_req, &vec,
> >  					     maxkeysize, maxdatasize,
> > +					     &test_desc->params.aead,
> >  					     vec_name, sizeof(vec_name));
> >  		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
> >
> > @@ -2280,11 +2365,6 @@ static int alg_test_aead(const struct alg_test_d=
esc *desc, const char *driver,
> >  	struct cipher_test_sglists *tsgls =3D NULL;
> >  	int err;
> >
> > -	if (suite->count <=3D 0) {
> > -		pr_err("alg: aead: empty test suite for %s\n", driver);
> > -		return -EINVAL;
> > -	}
> > -
> >  	tfm =3D crypto_alloc_aead(driver, type, mask);
> >  	if (IS_ERR(tfm)) {
> >  		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
> > @@ -2308,6 +2388,11 @@ static int alg_test_aead(const struct alg_test_d=
esc *desc, const char *driver,
> >  		goto out;
> >  	}
> >
> > +	if (suite->count <=3D 0) {
> > +		pr_err("alg: aead: empty test suite for %s\n", driver);
> > +		goto aead_skip_testsuite;
> > +	}
> > +
>=20
> This should be at most pr_warn(), and maybe not printed at all.  We alrea=
dy know
> that some authenc compositions don't have their own test vectors; kernel =
users
> can't do anything about it.
>=20
See comment above, not my code but if everyone agrees I'm fine with the cha=
nge.

> > diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> > index 6b459a6..105f2ce 100644
> > --- a/crypto/testmgr.h
> > +++ b/crypto/testmgr.h
> > @@ -28,6 +28,8 @@
> >  #include <linux/oid_registry.h>
> >
> >  #define MAX_IVLEN		32
> > +#define TESTMGR_POISON_BYTE	0xfe
> > +#define TESTMGR_POISON_LEN	16
> >
> >  /*
> >   * hash_testvec:	structure to describe a hash (message digest) test
> > @@ -176,6 +178,302 @@ struct kpp_testvec {
> >  static const char zeroed_string[48];
> >
> >  /*
> > + * length range declaration lo-hi plus selection threshold 0 - 1000
> > + */
> > +struct len_range_sel {
> > +	unsigned int len_lo;
> > +	unsigned int len_hi;
> > +	unsigned int threshold;
> > +};
> > +
> > +/*
> > + * List of length ranges sorted on increasing threshold
> > + *
> > + * 25% of each of the legal key sizes (128, 192, 256 bits)
> > + * plus 25% of illegal sizes in between 0 and 1024 bits.
> > + */
> > +static const struct len_range_sel aes_klen_template[] =3D {
> > +	{
> > +	.len_lo =3D 0,
> > +	.len_hi =3D 15,
> > +	.threshold =3D 25,
> > +	}, {
> > +	.len_lo =3D 16,
> > +	.len_hi =3D 16,
> > +	.threshold =3D 325,
> > +	}, {
> > +	.len_lo =3D 17,
> > +	.len_hi =3D 23,
> > +	.threshold =3D 350,
> > +	}, {
> > +	.len_lo =3D 24,
> > +	.len_hi =3D 24,
> > +	.threshold =3D 650,
> > +	}, {
> > +	.len_lo =3D 25,
> > +	.len_hi =3D 31,
> > +	.threshold =3D 675,
> > +	}, {
> > +	.len_lo =3D 32,
> > +	.len_hi =3D 32,
> > +	.threshold =3D 975,
> > +	}, {
> > +	.len_lo =3D 33,
> > +	.len_hi =3D 128,
> > +	.threshold =3D 1000,
> > +	}
> > +};
>=20
> Can you please move these to be next to the test vectors for each algorit=
hm, so
> things are kept in one place for each algorithm?
>=20
Actually, these are supposed to be generic, to be shared across multiple
test vectors. So what do you think would be the best place for them?

> Also, perhaps these should use the convention '.proportion_of_total', lik=
e
> 'struct testvec_config' already does, rather than '.threshold'?  That wou=
ld be
> more consistent with the existing test code, and would also make it sligh=
tly
> easier to change the probabilities later.
>=20
I'm not quite sure if its the same thing. If someone can acknowledge that i=
t is,
I could give it the same name. But otherwise, that would just be confusing =
...

> E.g. if someone wanted to increase the probability of the first case and
> decrease the probability of the last case, then with the '.threshold' con=
vention
> they'd have to change for every entry, but with the '.proportion_of_total=
'
> convention they'd only have to change the first and last entries.
>=20
Oh, you are suggesting to change the whole mechanism, not just the name.
Honestly, I didn't like the proportion_of_total mechanism because it=20
requires you to parse the data twice. Again, I'm oldschool so I try to prov=
ide
my data in such a form that it requires the least amount of actual processi=
ng.

> > +
> > +/* 90% legal keys of size 8, rest illegal between 0 and 32 */
> > +static const struct len_range_sel des_klen_template[] =3D {
> > +	{
> > +	.len_lo =3D 0,
> > +	.len_hi =3D 7,
> > +	.threshold =3D 50,
> > +	}, {
> > +	.len_lo =3D 8,
> > +	.len_hi =3D 8,
> > +	.threshold =3D 950,
> > +	}, {
> > +	.len_lo =3D 9,
> > +	.len_hi =3D 32,
> > +	.threshold =3D 1000,
> > +	}
> > +};
> > +
> > +/* 90% legal keys of size 24, rest illegal between 0 and 32 */
> > +static const struct len_range_sel des3_klen_template[] =3D {
> > +	{
> > +	.len_lo =3D 0,
> > +	.len_hi =3D 23,
> > +	.threshold =3D 50,
> > +	}, {
> > +	.len_lo =3D 24,
> > +	.len_hi =3D 24,
> > +	.threshold =3D 950,
> > +	}, {
> > +	.len_lo =3D 25,
> > +	.len_hi =3D 32,
> > +	.threshold =3D 1000,
> > +	}
> > +};
> > +
> > +/*
> > + * For HMAC's, favour the actual digest size for both key
> > + * size and authenticator size, but do verify some tag
> > + * truncation cases and some larger keys, including keys
> > + * exceeding the block size.
> > + */
> > +
> > +static const struct len_range_sel md5_klen_template[] =3D {
>=20
> This really should be called "hmac_md5_klen", since md5 by itself is unke=
yed.
>=20
> Likewise for sha1, sha256, etc.
>=20
Good point

> > +	{
> > +	.len_lo =3D 0, /* Allow 0 here? */
> > +	.len_hi =3D 15,
> > +	.threshold =3D 50,
> > +	}, {
> > +	.len_lo =3D 16,
> > +	.len_hi =3D 16,
> > +	.threshold =3D 950,
> > +	}, {
> > +	.len_lo =3D 17,
> > +	.len_hi =3D 256,
> > +	.threshold =3D 1000,
> > +	}
> > +};
> > +
> > +static const struct len_range_sel md5_alen_template[] =3D {
>=20
> Likewise here: it should be "hmac_md5".
>=20
Idem

> Also, "alen" is used elsewhere in the test code, including in the test ve=
ctors
> themselves, to mean the associated data length, *not* the authentication =
tag
> length.  But here these lengths are for authentication tags.  So please u=
se
> "authsize".  Likewise for sha1, sha256, etc.
>=20
Fair enough

> > +
> > +static const struct len_range_sel aead_alen_template[] =3D {
> > +	{
> > +	.len_lo =3D 0,
> > +	.len_hi =3D 0,
> > +	.threshold =3D 200,
> > +	}, {
> > +	.len_lo =3D 1,
> > +	.len_hi =3D 32,
> > +	.threshold =3D 900,
> > +	}, {
> > +	.len_lo =3D 33,
> > +	.len_hi =3D (2 * PAGE_SIZE) - TESTMGR_POISON_LEN,
> > +	.threshold =3D 1000,
> > +	}
> > +};
>=20
> Is this for authenc or for all AEADs?  Likewise for aead_plen_template[].
>=20
I believe these *could* be used for all AEAD's (that don't have specific li=
mits on
AAD length, which some rfcxxxx AEAD's seem to have as I just learned recent=
ly).

> Again, "alen" =3D> "authsize".
>=20
Ok

> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
