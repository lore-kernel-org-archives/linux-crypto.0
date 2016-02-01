From: Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH] fix out of bound read in __test_aead()
Date: Mon, 1 Feb 2016 16:40:33 +0100
Message-ID: <56AF7C71.9080408@redhat.com>
References: <1454073009-13665-1-git-send-email-jmarchan@redhat.com>
 <20160201142640.GA11363@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4AnkpU47xDX9sm0jtJag6IrAQiEvhnLHG"
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160201142640.GA11363@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4AnkpU47xDX9sm0jtJag6IrAQiEvhnLHG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/01/2016 03:26 PM, Herbert Xu wrote:
> On Fri, Jan 29, 2016 at 02:10:09PM +0100, Jerome Marchand wrote:
>> __test_aead() reads MAX_IVLEN bytes from template[i].iv, but the
>> actual length of the initialisation vector can be shorter.
>> The length of the IV is already calculated earlier in the
>> function. Let's just reuses that.
>> This fix an out-of-bound error detected by KASan.
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>=20
> This patch creates a new warning that iv_len may be uninitialised.

I see. iv_len is set for each templates. I don't see why we would like
to call crypto_aead_ivsize() more than once. Moving the initialization
of iv_len out of the loop should solve the warning.

>=20
> Please fix this and resubmit.

Will do.

Jerome

>=20
> Thanks,
>=20



--4AnkpU47xDX9sm0jtJag6IrAQiEvhnLHG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWr3xxAAoJEHTzHJCtsuoCYT8IALR/KgjXrniwCCw9MhXw5i8T
CqMTXKeFx5AB5DPYBN41ouhxLHQG/Z0gJ2EFQ7b2GSWCoM+75J2tqJ/kOQdMFfRB
Fw3NVQ2KOnd4QQR4v5p//7oA9Tu0K9ucS3wjHZwy1QFAOTft6of8ujRt9P+NmX3X
9h5xweFJAH4uVeAcNVDJSDiLjzvpr8VwJVPVl4RyEtS91269AqzVAHgw67u+lwT+
LxiW6a5cpL0DJ9KLmevdzveBnnpGMpsvnH++kMUKERQ1DH+JanWVWFCeX7nEp4um
XT4rd4iDlcRpwwkTmRuehkWpkwVzc2+oXSmTZK18MYYt8FHZTyeHn/cWKlaG5jk=
=Ln+h
-----END PGP SIGNATURE-----

--4AnkpU47xDX9sm0jtJag6IrAQiEvhnLHG--
