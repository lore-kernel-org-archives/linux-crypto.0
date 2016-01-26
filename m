From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH] eCryptfs: Clean up crypto initialization
Date: Tue, 26 Jan 2016 17:09:22 -0600
Message-ID: <20160126230921.GF27823@boyd>
References: <20160125142311.GA15355@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jkO+KyKz7TfD21mV"
Cc: Michael Halcrow <mhalcrow@google.com>, ecryptfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbcAZXJ2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 18:09:28 -0500
Content-Disposition: inline
In-Reply-To: <20160125142311.GA15355@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--jkO+KyKz7TfD21mV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[fixed mhalcrow's email address]

Hi Dan - thanks for the alert. I think the code is fine in this situation.

On 2016-01-25 17:23:11, Dan Carpenter wrote:
> Hello Michael Halcrow,
>=20
> The patch e5d9cbde6ce0: "[PATCH] eCryptfs: Clean up crypto
> initialization" from Oct 30, 2006, leads to the following static
> checker warning:
>=20
> 	fs/ecryptfs/crypto.c:1625 ecryptfs_process_key_cipher()
> 	error: get_random_bytes() 'dummy_key' too small (64 vs 4294967295)
>=20
> fs/ecryptfs/crypto.c
>   1593  static int
>   1594  ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
>   1595                              char *cipher_name, size_t *key_size)
>   1596  {
>   1597          char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
>   1598          char *full_alg_name =3D NULL;
>   1599          int rc;
>   1600 =20
>   1601          *key_tfm =3D NULL;
>   1602          if (*key_size > ECRYPTFS_MAX_KEY_BYTES) {
>   1603                  rc =3D -EINVAL;
>   1604                  printk(KERN_ERR "Requested key size is [%zd] byte=
s; maximum "
>   1605                        "allowable is [%d]\n", *key_size, ECRYPTFS_=
MAX_KEY_BYTES);
>   1606                  goto out;
>   1607          }
>   1608          rc =3D ecryptfs_crypto_api_algify_cipher_name(&full_alg_n=
ame, cipher_name,
>   1609                                                      "ecb");
>   1610          if (rc)
>   1611                  goto out;
>   1612          *key_tfm =3D crypto_alloc_blkcipher(full_alg_name, 0, CRY=
PTO_ALG_ASYNC);
>   1613          if (IS_ERR(*key_tfm)) {
>   1614                  rc =3D PTR_ERR(*key_tfm);
>   1615                  printk(KERN_ERR "Unable to allocate crypto cipher=
 with name "
>   1616                         "[%s]; rc =3D [%d]\n", full_alg_name, rc);
>   1617                  goto out;
>   1618          }
>   1619          crypto_blkcipher_set_flags(*key_tfm, CRYPTO_TFM_REQ_WEAK_=
KEY);
>   1620          if (*key_size =3D=3D 0) {
>   1621                  struct blkcipher_alg *alg =3D crypto_blkcipher_al=
g(*key_tfm);
>   1622 =20
>   1623                  *key_size =3D alg->max_keysize;
>=20
> My concern here is that arc4 has a max_keysize of ARC4_MAX_KEY_SIZE (256).
>=20
>   1624          }
>   1625          get_random_bytes(dummy_key, *key_size);
>=20
> Potentially leading to memory corruption here.  This is static analysis
> work so I may be wrong.

There are two things stopping this from being an issue. The first is the
check on key_size at line 1602. The second is that eCryptfs only
supports a small set of ciphers that have max key sizes well within
ECRYPTFS_MAX_KEY_BYTES:

fs/ecryptfs/crypto.c
   962  /* Add support for additional ciphers by adding elements here. The
   963   * cipher_code is whatever OpenPGP applicatoins use to identify the
   964   * ciphers. List in order of probability. */
   965  static struct ecryptfs_cipher_code_str_map_elem
   966  ecryptfs_cipher_code_str_map[] =3D {
   967          {"aes",RFC2440_CIPHER_AES_128 },
   968          {"blowfish", RFC2440_CIPHER_BLOWFISH},
   969          {"des3_ede", RFC2440_CIPHER_DES3_EDE},
   970          {"cast5", RFC2440_CIPHER_CAST_5},
   971          {"twofish", RFC2440_CIPHER_TWOFISH},
   972          {"cast6", RFC2440_CIPHER_CAST_6},
   973          {"aes", RFC2440_CIPHER_AES_192},
   974          {"aes", RFC2440_CIPHER_AES_256}
   975  };

Tyler

--jkO+KyKz7TfD21mV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWp/yhAAoJENaSAD2qAscKGGcP/3wnbNSmF3UfAIaRUSKMa1fs
IY864HZc2lq2TTKKAledLs8uIhmpRg/jc8wqiPA/VZjieHSgJCoQQoUGprJHoDq3
H1bf6u9n6PRP3K1BrowjsxmSPm2/w5F/yiGizqjGoQwsWOd+d4n6jkRlIgx0OFW9
y7L/t5QZkxSBLtwVchny3V1CZzzufAYx8jjLh69fMG91fuKRcT9SpQQDm1LXPWhP
fvJcdxhZha68hCsan4SI6k+IABPWM4xBDnE/i5RC16dCjNR8hI4Xhfhbcz+i9BOF
XHeyQBhY3ZU9fQoCeOQ717xvb83CXjWtF2l5yfF4eRILdrzSNw/pE/ba3QXpYK/x
9RRU1PTCwbE2hMF3WosjokaRzqYCaUR5G4v8sDT4ZV2L5dkdje88baTFqSbcsBJi
lVGMZZQ2RXjza7mrYmmB0UvpX59mhOkBN+4aAwSvPlNCaBsqA3rUOJMQdig4Qqsz
nUIWSv2brMZJjsYGiKSPnU3w9fl7UH44R5qgqFcCF0X9wj64vN0X0gdV8v384j5p
oVR1RwTL89pmjcNtlSLNf5Ymj46Dgw3usNnaCThrCL7z2tEyJbvTwCNcaqh3Xxom
mcNbBlvxiVZdHlegHy89h9GoELW6rOUKY5iRr/XTagC64gOmHDBqMTfxLVo1LGso
GyEADsXhweMd/285OUBk
=UAWT
-----END PGP SIGNATURE-----

--jkO+KyKz7TfD21mV--
