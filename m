Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3931C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 10:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BE632085A
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 10:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="FYqGJkn6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfHIKVj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 06:21:39 -0400
Received: from mail-eopbgr800089.outbound.protection.outlook.com ([40.107.80.89]:46880
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfHIKVj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 06:21:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xq3M3zPJ2Y39HHGFuJo6aUYhW+uCmMmsmAjpMyrUZIx3gqHBhYjwjUsD+ItrDbcn0g+Zt9ixaJhP7fRolaW032TvIm5Ws8/hulIkX0zIWVUfh50S5ngwAFjNo1q7KuZviOynm3RFLFIA98iAi1ECE+Z7IoqOVt8b5nM5yeRWAPgz1pZubN0oduZyBbCf2x33qfKUrDlk+NG4CgS5viW5y1Qkv5PzgABDHFsZc7MhW1mdEHqjAIAdgGai+IM5sWDJB8YZ7l9v2mil/6ym+AJoCazYxop/RG6oCEezcbu/4sBQQNuMiktVxiEwy4fk3wm3siB7ZVMAhmTQFgasp+jDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkeLFILqsVBxecr8UqtZAWfHbN5U2NBjMAs629Mghjs=;
 b=m53Z55O8fBawGipCxMj2PdpPMeKGBBtuYPJgQ7tysPCLFNk6edyj64wFaR3IwL6PGGJck3OErc3hXC/yNGMSU0RyHXhuDPCtJZYq/i42tx1kYqlpVoSyCSogPTZwWwMftSI/cXHyxRZh72RN0/fR0zq2qVQohDxJrrUX6pQLLZGKspQqohU9B+/mxBqrKQaMUA6NFkNoEuS/cHmZqNyuBM+1zFO4T7+TyAlDLIDrWaBcMffzutHoCU8xcsDx58ArOwrMus+IzMf9+661MLXXfaoEGccKD9hIjQC629el4HvBMYmmitcm7QZoipCnBK74JZQkkKXciBrofEsVw5Vl9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkeLFILqsVBxecr8UqtZAWfHbN5U2NBjMAs629Mghjs=;
 b=FYqGJkn65bypJrCgFWQb1Ir7K8OChvFYKSNHCloZRVos8MwHlg0/1nm46qeD/JldJfc5s7Z89eL4Rr3EOwnvke+/b+G3U2AjCcfU5t5LFBpEM5ZK2b3GotrbPbPded4VsexWvyUBrdg7Y6iLU0qa4M/wjgc9u5Vzy3un1n8iONA=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2384.namprd20.prod.outlook.com (20.179.146.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 10:21:31 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 10:21:31 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: RE: [PATCH] crypto: xts - add support for ciphertext stealing
Thread-Topic: [PATCH] crypto: xts - add support for ciphertext stealing
Thread-Index: AQHVTnwNHJj3hPZDbECkSBDG5hcnjKbylmMQ
Date:   Fri, 9 Aug 2019 10:21:31 +0000
Message-ID: <MN2PR20MB29733DD62DC12B6C321713A1CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190809063106.316-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190809063106.316-1-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41027ecc-65df-431d-b4f9-08d71cb35929
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2384;
x-ms-traffictypediagnostic: MN2PR20MB2384:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB23845312C67528357E8CDB5ACAD60@MN2PR20MB2384.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(376002)(366004)(396003)(136003)(39850400004)(13464003)(189003)(199004)(76116006)(4326008)(6436002)(6506007)(53546011)(76176011)(8936002)(14444005)(2501003)(5660300002)(33656002)(186003)(102836004)(966005)(14454004)(26005)(81156014)(81166006)(8676002)(229853002)(99286004)(66066001)(53936002)(66446008)(54906003)(6246003)(110136005)(2906002)(86362001)(64756008)(66556008)(66946007)(66476007)(71200400001)(71190400001)(52536014)(6116002)(55016002)(256004)(7696005)(6306002)(9686003)(3846002)(316002)(476003)(25786009)(305945005)(7736002)(486006)(74316002)(446003)(15974865002)(478600001)(11346002)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2384;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e9Y0zVY9l3/uYIcBTILSVtiD7RXiW2dT/IRJ7DCvpE1WOKffL6/4bm8dHKAommNe+tsb/n3zWYIe+DYktEtKz73ArdJgbtCawngAOBReRprFzA7DZQ1GmqGu46ReU9JFride4kAOevoxW12zJ1dlsO1LxDZS2Cl1pTVUJ+9pgpfLWXJKZFN7Vj9YTHo2HJOkQXsa4BpcH7CzNIPqBe5XM8fLEgo+jttnj0pgQ3f1ahQOcoPw36zxQCH56wRprvn+0sjFrxujyya7jFm3LfGrqrCAar8yIUbJzL9Gizk65o4peJObHgQPPAmAH2oB9EKRCvuFbI3iGMmaXLbMtrXUOjoCUw0EXAbBbGKfQICH8HTPCOeHwgZNCMz+IReCDwdPuCaCh0mf+U5eV21mVNMIVvwlKvDLOHP63xFVJ/pCbC4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41027ecc-65df-431d-b4f9-08d71cb35929
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 10:21:31.5504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Th+/kSER7UU0x8+6zKxnEWJD7Jj4ibmZwIz/oaAKEq1vHqlo2DRZaFI4vvYcEEdnrgfJy62UJHRWPwkMFhkjDnZnH9B3oF/20bnLnz7fH04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2384
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard,=20

Nitpicking: you patch does not fix the comment at the top stating that=20
sector sizes which are not a multiple of 16 bytes are not supported.

Otherwise, it works fine over here and I like the way you actually
queue up that final cipher call, which largely addresses my performance
concerns w.r.t. hardware acceleration :-)

> -----Original Message-----
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Sent: Friday, August 9, 2019 8:31 AM
> To: linux-crypto@vger.kernel.org
> Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ard Biesheuvel
> <ard.biesheuvel@linaro.org>; Pascal Van Leeuwen <pvanleeuwen@verimatrix.c=
om>; Ondrej
> Mosnacek <omosnace@redhat.com>; Milan Broz <gmazyland@gmail.com>
> Subject: [PATCH] crypto: xts - add support for ciphertext stealing
>=20
> Add support for the missing ciphertext stealing part of the XTS-AES
> specification, which permits inputs of any size >=3D the block size.
>=20
> Cc: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Cc: Milan Broz <gmazyland@gmail.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Tested-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

> ---
> This is an alternative approach to Pascal's [0]: instead of instantiating
> a separate cipher to deal with the tail, invoke the same ECB skcipher use=
d
> for the bulk of the data.
>=20
> [0] https://lore.kernel.org/linux-crypto/1565245094-8584-1-git-send-email=
-
> pvanleeuwen@verimatrix.com/
>=20
>  crypto/xts.c | 148 +++++++++++++++++---
>  1 file changed, 130 insertions(+), 18 deletions(-)
>=20
> diff --git a/crypto/xts.c b/crypto/xts.c
> index 11211003db7e..fc9edc6eb11e 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -34,6 +34,7 @@ struct xts_instance_ctx {
>=20
>  struct rctx {
>  	le128 t;
> +	struct scatterlist sg[2];
>  	struct skcipher_request subreq;
>  };
>=20
> @@ -84,10 +85,11 @@ static int setkey(struct crypto_skcipher *parent, con=
st u8 *key,
>   * mutliple calls to the 'ecb(..)' instance, which usually would be slow=
er than
>   * just doing the gf128mul_x_ble() calls again.
>   */
> -static int xor_tweak(struct skcipher_request *req, bool second_pass)
> +static int xor_tweak(struct skcipher_request *req, bool second_pass, boo=
l enc)
>  {
>  	struct rctx *rctx =3D skcipher_request_ctx(req);
>  	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> +	const bool cts =3D (req->cryptlen % XTS_BLOCK_SIZE);
>  	const int bs =3D XTS_BLOCK_SIZE;
>  	struct skcipher_walk w;
>  	le128 t =3D rctx->t;
> @@ -109,6 +111,20 @@ static int xor_tweak(struct skcipher_request *req, b=
ool second_pass)
>  		wdst =3D w.dst.virt.addr;
>=20
>  		do {
> +			if (unlikely(cts) &&
> +			    w.total - w.nbytes + avail < 2 * XTS_BLOCK_SIZE) {
> +				if (!enc) {
> +					if (second_pass)
> +						rctx->t =3D t;
> +					gf128mul_x_ble(&t, &t);
> +				}
> +				le128_xor(wdst, &t, wsrc);
> +				if (enc && second_pass)
> +					gf128mul_x_ble(&rctx->t, &t);
> +				skcipher_walk_done(&w, avail - bs);
> +				return 0;
> +			}
> +
>  			le128_xor(wdst++, &t, wsrc++);
>  			gf128mul_x_ble(&t, &t);
>  		} while ((avail -=3D bs) >=3D bs);
> @@ -119,17 +135,70 @@ static int xor_tweak(struct skcipher_request *req, =
bool second_pass)
>  	return err;
>  }
>=20
> -static int xor_tweak_pre(struct skcipher_request *req)
> +static int xor_tweak_pre(struct skcipher_request *req, bool enc)
>  {
> -	return xor_tweak(req, false);
> +	return xor_tweak(req, false, enc);
>  }
>=20
> -static int xor_tweak_post(struct skcipher_request *req)
> +static int xor_tweak_post(struct skcipher_request *req, bool enc)
>  {
> -	return xor_tweak(req, true);
> +	return xor_tweak(req, true, enc);
>  }
>=20
> -static void crypt_done(struct crypto_async_request *areq, int err)
> +static void cts_done(struct crypto_async_request *areq, int err)
> +{
> +	struct skcipher_request *req =3D areq->data;
> +	le128 b;
> +
> +	if (!err) {
> +		struct rctx *rctx =3D skcipher_request_ctx(req);
> +
> +		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 0);
> +		le128_xor(&b, &rctx->t, &b);
> +		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 1);
> +	}
> +
> +	skcipher_request_complete(req, err);
> +}
> +
> +static int cts_final(struct skcipher_request *req,
> +		     int (*crypt)(struct skcipher_request *req))
> +{
> +	struct priv *ctx =3D crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> +	int offset =3D req->cryptlen & ~(XTS_BLOCK_SIZE - 1);
> +	struct rctx *rctx =3D skcipher_request_ctx(req);
> +	struct skcipher_request *subreq =3D &rctx->subreq;
> +	int tail =3D req->cryptlen % XTS_BLOCK_SIZE;
> +	struct scatterlist *sg;
> +	le128 b[2];
> +	int err;
> +
> +	sg =3D scatterwalk_ffwd(rctx->sg, req->dst, offset - XTS_BLOCK_SIZE);
> +
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> +	memcpy(b + 1, b, tail);
> +	scatterwalk_map_and_copy(b, req->src, offset, tail, 0);
> +
> +	le128_xor(b, &rctx->t, b);
> +
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE + tail, 1);
> +
> +	skcipher_request_set_tfm(subreq, ctx->child);
> +	skcipher_request_set_callback(subreq, req->base.flags, cts_done, req);
> +	skcipher_request_set_crypt(subreq, sg, sg, XTS_BLOCK_SIZE, NULL);
> +
> +	err =3D crypt(subreq);
> +	if (err)
> +		return err;
> +
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> +	le128_xor(b, &rctx->t, b);
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 1);
> +
> +	return 0;
> +}
> +
> +static void encrypt_done(struct crypto_async_request *areq, int err)
>  {
>  	struct skcipher_request *req =3D areq->data;
>=20
> @@ -137,47 +206,90 @@ static void crypt_done(struct crypto_async_request =
*areq, int err)
>  		struct rctx *rctx =3D skcipher_request_ctx(req);
>=20
>  		rctx->subreq.base.flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -		err =3D xor_tweak_post(req);
> +		err =3D xor_tweak_post(req, true);
> +
> +		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> +			err =3D cts_final(req, crypto_skcipher_encrypt);
> +			if (err =3D=3D -EINPROGRESS)
> +				return;
> +		}
>  	}
>=20
>  	skcipher_request_complete(req, err);
>  }
>=20
> -static void init_crypt(struct skcipher_request *req)
> +static void decrypt_done(struct crypto_async_request *areq, int err)
> +{
> +	struct skcipher_request *req =3D areq->data;
> +
> +	if (!err) {
> +		struct rctx *rctx =3D skcipher_request_ctx(req);
> +
> +		rctx->subreq.base.flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
> +		err =3D xor_tweak_post(req, false);
> +
> +		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> +			err =3D cts_final(req, crypto_skcipher_decrypt);
> +			if (err =3D=3D -EINPROGRESS)
> +				return;
> +		}
> +	}
> +
> +	skcipher_request_complete(req, err);
> +}
> +
> +static int init_crypt(struct skcipher_request *req, crypto_completion_t =
compl)
>  {
>  	struct priv *ctx =3D crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
>  	struct rctx *rctx =3D skcipher_request_ctx(req);
>  	struct skcipher_request *subreq =3D &rctx->subreq;
>=20
> +	if (req->cryptlen < XTS_BLOCK_SIZE)
> +		return -EINVAL;
> +
>  	skcipher_request_set_tfm(subreq, ctx->child);
> -	skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req)=
;
> +	skcipher_request_set_callback(subreq, req->base.flags, compl, req);
>  	skcipher_request_set_crypt(subreq, req->dst, req->dst,
> -				   req->cryptlen, NULL);
> +				   req->cryptlen & ~(XTS_BLOCK_SIZE - 1), NULL);
>=20
>  	/* calculate first value of T */
>  	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
> +
> +	return 0;
>  }
>=20
>  static int encrypt(struct skcipher_request *req)
>  {
>  	struct rctx *rctx =3D skcipher_request_ctx(req);
>  	struct skcipher_request *subreq =3D &rctx->subreq;
> +	int err;
>=20
> -	init_crypt(req);
> -	return xor_tweak_pre(req) ?:
> -		crypto_skcipher_encrypt(subreq) ?:
> -		xor_tweak_post(req);
> +	err =3D init_crypt(req, encrypt_done) ?:
> +	      xor_tweak_pre(req, true) ?:
> +	      crypto_skcipher_encrypt(subreq) ?:
> +	      xor_tweak_post(req, true);
> +
> +	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) =3D=3D 0))
> +		return err;
> +
> +	return cts_final(req, crypto_skcipher_encrypt);
>  }
>=20
>  static int decrypt(struct skcipher_request *req)
>  {
>  	struct rctx *rctx =3D skcipher_request_ctx(req);
>  	struct skcipher_request *subreq =3D &rctx->subreq;
> +	int err;
> +
> +	err =3D init_crypt(req, decrypt_done) ?:
> +	      xor_tweak_pre(req, false) ?:
> +	      crypto_skcipher_decrypt(subreq) ?:
> +	      xor_tweak_post(req, false);
> +
> +	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) =3D=3D 0))
> +		return err;
>=20
> -	init_crypt(req);
> -	return xor_tweak_pre(req) ?:
> -		crypto_skcipher_decrypt(subreq) ?:
> -		xor_tweak_post(req);
> +	return cts_final(req, crypto_skcipher_decrypt);
>  }
>=20
>  static int init_tfm(struct crypto_skcipher *tfm)
> --
> 2.17.1

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
