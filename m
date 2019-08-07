Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED9EC19759
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 07:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD7722AEC
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 07:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="kpjG9cvf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfHGH2L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 03:28:11 -0400
Received: from mail-eopbgr820073.outbound.protection.outlook.com ([40.107.82.73]:30784
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727415AbfHGH2L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 03:28:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WL7N/H3sqNoZpkotLbBxGPaMl1wSZ28rtiCMvU9liFMYPGHGwZ1GX/21Dlaod7eiUUkjFq5TInYLbQ3XL7TbzZLj42iKXLiddBMKw57YYWfksfGFZJ8DIjitUlYPhvRldsMTgyguap4lQX/Fp8R4PEIHiyKabRjguxmbE67CvNwOzDm1BAoAnEXa/MywPyjIcfcZjXa8kHwfOq5z9HsNprUPu2kwWzmPpbFKPkoDZLkhrsZea+GemVb+EBYTLUUlRWCPgqE0+zZ5vpsBRvL9RsJvxOX+AU577OqwmdTT91rgL1xLffkthq5xv5cpFdpqzUHQMuygCq0FTml3W32nsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4to365VcVX3ESDOBFzryiSvXs6yjOSD4cNEJbbBZIUc=;
 b=nF8hE20lkh/eGCtYVauT9jNcWRMFjrrIMW2JsSaRlXH/33d6Xeb1jLDUp1AQj+TRToCXZ4uIhrTqkGGCzFZoWBiVaPWpqlc99EFpy/5rrxno7wAFJVPfEfLpFy2iXQUs6DXGyLtx6CSfeseCU2uiUzdL7BpggPbAWqHRtNekqlhDITeHCuXsWC3r0LuTrhQIHCp0XQNZbERlqZZDVKr9/LCDDzhG/X6vXb7fJK8snaZtaRzm9T/89CLG6OvSazCFy7DvEFUK0S3e7B82Dcy1r1C7oIgSxWV66pAy/jkx/o9CW/rULW9PZ9ikLxsGxPHRQwrWIFgglZ2hwk70XQyWjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4to365VcVX3ESDOBFzryiSvXs6yjOSD4cNEJbbBZIUc=;
 b=kpjG9cvfqGGvS0kmC+5InpfAwmoAMP7PUaN8XRHzIKaRzFtImo9wsdhsGrKiNQXLNVmkzI3MaXiHpf8folwkcXpg3YBSsAM5B+OofE5ew8xL0QwJ36K1ZxahBR7CC82D7cfS5nLhpKsdkxkoyGwKG8B9WAW0QZXc242iorCLnks=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2879.namprd20.prod.outlook.com (20.178.251.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Wed, 7 Aug 2019 07:28:07 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 07:28:07 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>
Subject: RE: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Topic: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Index: AQHVTOQKWnTPkdATo0i/D1XZtRSIkqbvRQ3w
Date:   Wed, 7 Aug 2019 07:28:07 +0000
Message-ID: <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a4694f2-0445-45b7-03bf-08d71b08cb2f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2879;
x-ms-traffictypediagnostic: MN2PR20MB2879:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2879C84F38E100ABE2414E8CCAD40@MN2PR20MB2879.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(396003)(136003)(346002)(366004)(189003)(199004)(13464003)(76176011)(14454004)(7696005)(6116002)(186003)(3846002)(99286004)(8936002)(316002)(11346002)(26005)(81156014)(81166006)(446003)(54906003)(110136005)(33656002)(486006)(66946007)(2501003)(6436002)(14444005)(2906002)(256004)(229853002)(66476007)(66556008)(64756008)(53546011)(76116006)(6506007)(478600001)(102836004)(66446008)(86362001)(5660300002)(6246003)(305945005)(7736002)(52536014)(25786009)(4326008)(68736007)(15974865002)(476003)(66066001)(53936002)(9686003)(74316002)(55016002)(71200400001)(8676002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2879;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y3KQHDHZfwfAWIcdVbGB1hiVlsmwyxMsFTf0tClcy1eCFQOITynBaHWk9e/rzk3WjVn1fbX8GLSGZItZ9l3NGbEdh/28eigOMG5QBhiDGzpycUI5T8/4fVkU27+ZUdh/rNmxuKrQt6ruDJBLXZuXqpwaY6OeELygNoFm69HN/Vxl7YCMhp+1CtcWGr07KbxRY8LHzMX9JRbHmIsxf6QZ1FhmE1NuplEicbSExEoTNi2tYrYVZ0JU6rKAoCk8ABJJlWxuAdG6YNuOZwfvwEAzKaIlkW7Xi5Ao/ykutEr0YGJEW1/Ob+PeN9rJKrdJDt8BAOoDTjtLIB+inCRAogcUMXTm/tYeE5FQ+A/O3DkwK+HI1U4Xj4cS+0OLOZEkbpjs2k1jDKT//StZFWhI/z5O6Bp31pHGB1MM7eBeAh4J5Z4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4694f2-0445-45b7-03bf-08d71b08cb2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 07:28:07.5160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2879
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard,

I've actually been following this discussion with some interest, as it has
some relevance for some of the things I am doing at the moment as well.

For example, for my CTS implementation I need to crypt one or two=20
seperate blocks and for the inside-secure driver I sometimes need to do
some single crypto block precomputes. (the XTS driver additionally
also already did such a single block encrypt for the tweak, also using
a seperate (non-sk)cipher instance - very similar to your IV case)

Long story short, the current approach is to allocate a seperate=20
cipher instance so you can conveniently do crypto_cipher_en/decrypt_one.
(it would be nice to have a matching crypto_skcipher_en/decrypt_one
function available from the crypto API for these purposes?)
But if I understand you correctly, you may end up with an insecure
table-based implementation if you do that. Not what I want :-(

However, in many cases there would actually be a very good reason
NOT to want to use the main skcipher for this. As that is some
hardware accelerator with terrible latency that you wouldn't want
to use to process just one cipher block. For that, you want to have
some SW implementation that is efficient on a single block instead.

In my humble opinion, such insecure table based implementations just
shouldn't exist at all - you can always do better, possibly at the
expense of some performance degradation. Or you should at least have=20
some flag  available to specify you have some security requirements=20
and such an implementation is not an acceptable response.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Ard Biesheuvel
> Sent: Wednesday, August 7, 2019 7:50 AM
> To: linux-crypto@vger.kernel.org
> Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; agk@redhat.com; sni=
tzer@redhat.com;
> dm-devel@redhat.com; gmazyland@gmail.com; Ard Biesheuvel <ard.biesheuvel@=
linaro.org>
> Subject: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generat=
ion
>=20
> Instead of instantiating a separate cipher to perform the encryption
> needed to produce the IV, reuse the skcipher used for the block data
> and invoke it one additional time for each block to encrypt a zero
> vector and use the output as the IV.
>=20
> For CBC mode, this is equivalent to using the bare block cipher, but
> without the risk of ending up with a non-time invariant implementation
> of AES when the skcipher itself is time variant (e.g., arm64 without
> Crypto Extensions has a NEON based time invariant implementation of
> cbc(aes) but no time invariant implementation of the core cipher other
> than aes-ti, which is not enabled by default)
>=20
> This approach is a compromise between dm-crypt API flexibility and
> reducing dependence on parts of the crypto API that should not usually
> be exposed to other subsystems, such as the bare cipher API.
>=20
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/md/dm-crypt.c | 70 ++++++++++++++-----------------------------
>  1 file changed, 22 insertions(+), 48 deletions(-)
>=20
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index d5216bcc4649..48cd76c88d77 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -120,10 +120,6 @@ struct iv_tcw_private {
>  	u8 *whitening;
>  };
>=20
> -struct iv_eboiv_private {
> -	struct crypto_cipher *tfm;
> -};
> -
>  /*
>   * Crypt: maps a linear range of a block device
>   * and encrypts / decrypts at the same time.
> @@ -163,7 +159,6 @@ struct crypt_config {
>  		struct iv_benbi_private benbi;
>  		struct iv_lmk_private lmk;
>  		struct iv_tcw_private tcw;
> -		struct iv_eboiv_private eboiv;
>  	} iv_gen_private;
>  	u64 iv_offset;
>  	unsigned int iv_size;
> @@ -847,65 +842,47 @@ static int crypt_iv_random_gen(struct crypt_config =
*cc, u8 *iv,
>  	return 0;
>  }
>=20
> -static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
> -{
> -	struct iv_eboiv_private *eboiv =3D &cc->iv_gen_private.eboiv;
> -
> -	crypto_free_cipher(eboiv->tfm);
> -	eboiv->tfm =3D NULL;
> -}
> -
>  static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target =
*ti,
>  			    const char *opts)
>  {
> -	struct iv_eboiv_private *eboiv =3D &cc->iv_gen_private.eboiv;
> -	struct crypto_cipher *tfm;
> -
> -	tfm =3D crypto_alloc_cipher(cc->cipher, 0, 0);
> -	if (IS_ERR(tfm)) {
> -		ti->error =3D "Error allocating crypto tfm for EBOIV";
> -		return PTR_ERR(tfm);
> +	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags)) {
> +		ti->error =3D "AEAD transforms not supported for EBOIV";
> +		return -EINVAL;
>  	}
>=20
> -	if (crypto_cipher_blocksize(tfm) !=3D cc->iv_size) {
> +	if (crypto_skcipher_blocksize(any_tfm(cc)) !=3D cc->iv_size) {
>  		ti->error =3D "Block size of EBOIV cipher does "
>  			    "not match IV size of block cipher";
> -		crypto_free_cipher(tfm);
>  		return -EINVAL;
>  	}
>=20
> -	eboiv->tfm =3D tfm;
>  	return 0;
>  }
>=20
> -static int crypt_iv_eboiv_init(struct crypt_config *cc)
> +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> +			    struct dm_crypt_request *dmreq)
>  {
> -	struct iv_eboiv_private *eboiv =3D &cc->iv_gen_private.eboiv;
> +	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
> +	struct skcipher_request *req;
> +	struct scatterlist src, dst;
> +	struct crypto_wait wait;
>  	int err;
>=20
> -	err =3D crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
> -	if (err)
> -		return err;
> -
> -	return 0;
> -}
> -
> -static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
> -{
> -	/* Called after cc->key is set to random key in crypt_wipe() */
> -	return crypt_iv_eboiv_init(cc);
> -}
> +	req =3D skcipher_request_alloc(any_tfm(cc), GFP_KERNEL | GFP_NOFS);
> +	if (!req)
> +		return -ENOMEM;
>=20
> -static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> -			    struct dm_crypt_request *dmreq)
> -{
> -	struct iv_eboiv_private *eboiv =3D &cc->iv_gen_private.eboiv;
> +	memset(buf, 0, cc->iv_size);
> +	*(__le64 *)buf =3D cpu_to_le64(dmreq->iv_sector * cc->sector_size);
>=20
> -	memset(iv, 0, cc->iv_size);
> -	*(__le64 *)iv =3D cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> -	crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
> +	sg_init_one(&src, page_address(ZERO_PAGE(0)), cc->iv_size);
> +	sg_init_one(&dst, iv, cc->iv_size);
> +	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
> +	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
> +	err =3D crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> +	skcipher_request_free(req);
>=20
> -	return 0;
> +	return err;
>  }
>=20
>  static const struct crypt_iv_operations crypt_iv_plain_ops =3D {
> @@ -962,9 +939,6 @@ static struct crypt_iv_operations crypt_iv_random_ops=
 =3D {
>=20
>  static struct crypt_iv_operations crypt_iv_eboiv_ops =3D {
>  	.ctr	   =3D crypt_iv_eboiv_ctr,
> -	.dtr	   =3D crypt_iv_eboiv_dtr,
> -	.init	   =3D crypt_iv_eboiv_init,
> -	.wipe	   =3D crypt_iv_eboiv_wipe,
>  	.generator =3D crypt_iv_eboiv_gen
>  };
>=20
> --
> 2.17.1

