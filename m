Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7B1C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 15:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ABE8208C4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 15:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="MSq7XK1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHIPAn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 11:00:43 -0400
Received: from mail-eopbgr820080.outbound.protection.outlook.com ([40.107.82.80]:47840
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbfHIPAn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 11:00:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wq4qL59P/vyhTsSs9Ho4a3cyD1+E6JPZ+D3wEDskFCGm6PFPl9h5p8CB+1S6+YsGaCg1REhrtsxNPlwSjqbyR+hjMaj0dhVFYu5iOZ3R24J/LAM+vhfH8/nyuIn8wxn06tIDAos3X2mr7HW42WfiAIX14DIQOmjv/w2TViqjy/z68AABtbZLmF/T2aX5s6BZbGoWLNcFhYCmKIwqdoMvfMFebXa8JEnDj++A52U6TmUvq969WqOFC5wll/SJnChyixDT9sdi6iaQbIu7Wth1qCsQ906KxDdwVKQcmHd5t/dOUjgkreFKrcVFQ774tUtMjNmCCgH1XfrCjwPLcfLOaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfFr5XLfsoreULrF+iIwSuX4CmN1kgnIFIFs58sFNHM=;
 b=WdbGK7eSjOAq+TbwFR8ArbnskB5SpoVO3APiCatXVn/uUhkGTF0bnwpIqe9YG0slp8XDWsullRLHtS6GsyaZWa+sRQMpnF5dv9ncbgILSwg0gxnLBqUxA+kK1Tn5tdVHPF2Ig3eqXNpc4dvq1Iw7WBMNULWRrXVDHN3sZYPbW+x4OsPn59bz0pjdLIz6nulRhefdvbDxE0pQkcXJdVYkxtyJTjZrfFZNnU8bVdFIm7oaWcvM5FyTtLqyxdXbOT5klxw01Z4p63I5vJ2UlYlUtXVYUXoRWLQ7CUgtODL/4cgQ+sOtDkXeq1OCAiHxZny73U7H08b3y7BhgFCavIa0jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfFr5XLfsoreULrF+iIwSuX4CmN1kgnIFIFs58sFNHM=;
 b=MSq7XK1PYgmrmkOn57cY5lmbhl5rFUs7wSws4GYFe+iSc5bVTGSQSGZYPvLXBOhShtz/LXSDaNhsD9NsD8yBaALclhwESPCL1yHNlGZxCky8HgeeUECcBdvgo0dF2zvxmH/exptY2zWFeOkjchOoJhuMvctTdwwF4nAI1J1EVo0=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2463.namprd20.prod.outlook.com (20.179.147.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Fri, 9 Aug 2019 15:00:34 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 15:00:34 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: RE: [PATCH] crypto: xts - add support for ciphertext stealing
Thread-Topic: [PATCH] crypto: xts - add support for ciphertext stealing
Thread-Index: AQHVTnwNHJj3hPZDbECkSBDG5hcnjKbylmMQgABRK4A=
Date:   Fri, 9 Aug 2019 15:00:34 +0000
Message-ID: <MN2PR20MB2973503920A627A165A2B507CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190809063106.316-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB29733DD62DC12B6C321713A1CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29733DD62DC12B6C321713A1CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 906454a3-ecb7-4296-e547-08d71cda547b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2463;
x-ms-traffictypediagnostic: MN2PR20MB2463:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR20MB2463D10FB5A7274E674294BCCAD60@MN2PR20MB2463.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39840400004)(366004)(376002)(346002)(396003)(199004)(189003)(13464003)(7736002)(486006)(6246003)(53936002)(256004)(14444005)(81156014)(99286004)(476003)(81166006)(8676002)(2940100002)(446003)(66476007)(66556008)(64756008)(66446008)(55016002)(33656002)(6436002)(11346002)(66946007)(66066001)(2906002)(2501003)(74316002)(15974865002)(305945005)(8936002)(71190400001)(229853002)(71200400001)(9686003)(6306002)(76116006)(102836004)(186003)(6116002)(53546011)(110136005)(54906003)(14454004)(3846002)(478600001)(966005)(26005)(86362001)(76176011)(52536014)(4326008)(5660300002)(6506007)(25786009)(7696005)(316002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2463;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aDz9ZgRhbTYfto7llYicQ16F1bBQT2aA+9iczNdTtp7+vV+cKIT+5n6tItJjr+sRnbq1WA/XziF3IuUk2voNxPMcKkjGkTWneJuatzvxQbn51V9OH3vVbwSdllX93EFVH8zooeYR8D0yYtGwYX3naTzQVR6BwoIzIxWJOeNqFjE/RQjlhCEJ1rr9/iyFwKJwQONnCC8UmeEZ/TxuqRDyklqeOzw246egiokx5en4veJpZiVOAxxO8T6gnNVL98bL8pJS2R4UbkglHlslwXJd/ij0aTG3qomlL4o9FQRSfxO2HLs6E1B+eQIthdF9ORDPgGNrrWtFgCO8nqGMNrH531DOxQKzp+Bxvm5KXbVGWbZid1tVrqyWeAaCwgkQedE0SNWWHnzyOjlk+MvdfTb9alxZtfuo2XPsg//adChQyk4=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 906454a3-ecb7-4296-e547-08d71cda547b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 15:00:34.0809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbsIfn2VYa50BNVMvtJEvieoc6sbGDZTOQ3GuneXhgTeCnIxgjWM8QVyh5pVq76PXX7rNASMXVUidlSucYDB+9/0p2ma5J1/hhqXPEK6UO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2463
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Pascal Van Leeuwen
> Sent: Friday, August 9, 2019 12:22 PM
> To: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.=
org
> Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ondrej Mosnacek
> <omosnace@redhat.com>; Milan Broz <gmazyland@gmail.com>
> Subject: RE: [PATCH] crypto: xts - add support for ciphertext stealing
>=20
> Ard,
>=20
> Nitpicking: you patch does not fix the comment at the top stating that
> sector sizes which are not a multiple of 16 bytes are not supported.
>=20
> Otherwise, it works fine over here and I like the way you actually
> queue up that final cipher call, which largely addresses my performance
> concerns w.r.t. hardware acceleration :-)
>
Actually, I just noticed it did NOT work fine, the first CTS vector (5)
was failing. Sorry for missing that little detail before.
Setting cra_blocksize to 1 instead of 16 solves that issue.

Still sure cra_blocksize should be set to 16? Because to me, that doesn't
make sense for something that is fundamentally NOT a blockcipher.

>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Friday, August 9, 2019 8:31 AM
> > To: linux-crypto@vger.kernel.org
> > Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ard Biesheuvel
> > <ard.biesheuvel@linaro.org>; Pascal Van Leeuwen <pvanleeuwen@verimatrix=
.com>; Ondrej
> > Mosnacek <omosnace@redhat.com>; Milan Broz <gmazyland@gmail.com>
> > Subject: [PATCH] crypto: xts - add support for ciphertext stealing
> >
> > Add support for the missing ciphertext stealing part of the XTS-AES
> > specification, which permits inputs of any size >=3D the block size.
> >
> > Cc: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > Cc: Milan Broz <gmazyland@gmail.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>=20
> Tested-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
>=20
Eh ... tested yes ... working ... no ...

> > ---
> > This is an alternative approach to Pascal's [0]: instead of instantiati=
ng
> > a separate cipher to deal with the tail, invoke the same ECB skcipher u=
sed
> > for the bulk of the data.
> >
> > [0] https://lore.kernel.org/linux-crypto/1565245094-8584-1-git-send-ema=
il-
> > pvanleeuwen@verimatrix.com/
> >
> >  crypto/xts.c | 148 +++++++++++++++++---
> >  1 file changed, 130 insertions(+), 18 deletions(-)
> >
> > diff --git a/crypto/xts.c b/crypto/xts.c
> > index 11211003db7e..fc9edc6eb11e 100644
> > --- a/crypto/xts.c
> > +++ b/crypto/xts.c
> > @@ -34,6 +34,7 @@ struct xts_instance_ctx {
> >
> >  struct rctx {
> >  	le128 t;
> > +	struct scatterlist sg[2];
> >  	struct skcipher_request subreq;
> >  };
> >
> > @@ -84,10 +85,11 @@ static int setkey(struct crypto_skcipher *parent, c=
onst u8 *key,
> >   * mutliple calls to the 'ecb(..)' instance, which usually would be sl=
ower than
> >   * just doing the gf128mul_x_ble() calls again.
> >   */
> > -static int xor_tweak(struct skcipher_request *req, bool second_pass)
> > +static int xor_tweak(struct skcipher_request *req, bool second_pass, b=
ool enc)
> >  {
> >  	struct rctx *rctx =3D skcipher_request_ctx(req);
> >  	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> > +	const bool cts =3D (req->cryptlen % XTS_BLOCK_SIZE);
> >  	const int bs =3D XTS_BLOCK_SIZE;
> >  	struct skcipher_walk w;
> >  	le128 t =3D rctx->t;
> > @@ -109,6 +111,20 @@ static int xor_tweak(struct skcipher_request *req,=
 bool
> second_pass)
> >  		wdst =3D w.dst.virt.addr;
> >
> >  		do {
> > +			if (unlikely(cts) &&
> > +			    w.total - w.nbytes + avail < 2 * XTS_BLOCK_SIZE) {
> > +				if (!enc) {
> > +					if (second_pass)
> > +						rctx->t =3D t;
> > +					gf128mul_x_ble(&t, &t);
> > +				}
> > +				le128_xor(wdst, &t, wsrc);
> > +				if (enc && second_pass)
> > +					gf128mul_x_ble(&rctx->t, &t);
> > +				skcipher_walk_done(&w, avail - bs);
> > +				return 0;
> > +			}
> > +
> >  			le128_xor(wdst++, &t, wsrc++);
> >  			gf128mul_x_ble(&t, &t);
> >  		} while ((avail -=3D bs) >=3D bs);
> > @@ -119,17 +135,70 @@ static int xor_tweak(struct skcipher_request *req=
, bool
> second_pass)
> >  	return err;
> >  }
> >
> > -static int xor_tweak_pre(struct skcipher_request *req)
> > +static int xor_tweak_pre(struct skcipher_request *req, bool enc)
> >  {
> > -	return xor_tweak(req, false);
> > +	return xor_tweak(req, false, enc);
> >  }
> >
> > -static int xor_tweak_post(struct skcipher_request *req)
> > +static int xor_tweak_post(struct skcipher_request *req, bool enc)
> >  {
> > -	return xor_tweak(req, true);
> > +	return xor_tweak(req, true, enc);
> >  }
> >
> > -static void crypt_done(struct crypto_async_request *areq, int err)
> > +static void cts_done(struct crypto_async_request *areq, int err)
> > +{
> > +	struct skcipher_request *req =3D areq->data;
> > +	le128 b;
> > +
> > +	if (!err) {
> > +		struct rctx *rctx =3D skcipher_request_ctx(req);
> > +
> > +		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 0);
> > +		le128_xor(&b, &rctx->t, &b);
> > +		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 1);
> > +	}
> > +
> > +	skcipher_request_complete(req, err);
> > +}
> > +
> > +static int cts_final(struct skcipher_request *req,
> > +		     int (*crypt)(struct skcipher_request *req))
> > +{
> > +	struct priv *ctx =3D crypto_skcipher_ctx(crypto_skcipher_reqtfm(req))=
;
> > +	int offset =3D req->cryptlen & ~(XTS_BLOCK_SIZE - 1);
> > +	struct rctx *rctx =3D skcipher_request_ctx(req);
> > +	struct skcipher_request *subreq =3D &rctx->subreq;
> > +	int tail =3D req->cryptlen % XTS_BLOCK_SIZE;
> > +	struct scatterlist *sg;
> > +	le128 b[2];
> > +	int err;
> > +
> > +	sg =3D scatterwalk_ffwd(rctx->sg, req->dst, offset - XTS_BLOCK_SIZE);
> > +
> > +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> > +	memcpy(b + 1, b, tail);
> > +	scatterwalk_map_and_copy(b, req->src, offset, tail, 0);
> > +
> > +	le128_xor(b, &rctx->t, b);
> > +
> > +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE + tail, 1);
> > +
> > +	skcipher_request_set_tfm(subreq, ctx->child);
> > +	skcipher_request_set_callback(subreq, req->base.flags, cts_done, req)=
;
> > +	skcipher_request_set_crypt(subreq, sg, sg, XTS_BLOCK_SIZE, NULL);
> > +
> > +	err =3D crypt(subreq);
> > +	if (err)
> > +		return err;
> > +
> > +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> > +	le128_xor(b, &rctx->t, b);
> > +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 1);
> > +
> > +	return 0;
> > +}
> > +
> > +static void encrypt_done(struct crypto_async_request *areq, int err)
> >  {
> >  	struct skcipher_request *req =3D areq->data;
> >
> > @@ -137,47 +206,90 @@ static void crypt_done(struct crypto_async_reques=
t *areq, int err)
> >  		struct rctx *rctx =3D skcipher_request_ctx(req);
> >
> >  		rctx->subreq.base.flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > -		err =3D xor_tweak_post(req);
> > +		err =3D xor_tweak_post(req, true);
> > +
> > +		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> > +			err =3D cts_final(req, crypto_skcipher_encrypt);
> > +			if (err =3D=3D -EINPROGRESS)
> > +				return;
> > +		}
> >  	}
> >
> >  	skcipher_request_complete(req, err);
> >  }
> >
> > -static void init_crypt(struct skcipher_request *req)
> > +static void decrypt_done(struct crypto_async_request *areq, int err)
> > +{
> > +	struct skcipher_request *req =3D areq->data;
> > +
> > +	if (!err) {
> > +		struct rctx *rctx =3D skcipher_request_ctx(req);
> > +
> > +		rctx->subreq.base.flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > +		err =3D xor_tweak_post(req, false);
> > +
> > +		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> > +			err =3D cts_final(req, crypto_skcipher_decrypt);
> > +			if (err =3D=3D -EINPROGRESS)
> > +				return;
> > +		}
> > +	}
> > +
> > +	skcipher_request_complete(req, err);
> > +}
> > +
> > +static int init_crypt(struct skcipher_request *req, crypto_completion_=
t compl)
> >  {
> >  	struct priv *ctx =3D crypto_skcipher_ctx(crypto_skcipher_reqtfm(req))=
;
> >  	struct rctx *rctx =3D skcipher_request_ctx(req);
> >  	struct skcipher_request *subreq =3D &rctx->subreq;
> >
> > +	if (req->cryptlen < XTS_BLOCK_SIZE)
> > +		return -EINVAL;
> > +
> >  	skcipher_request_set_tfm(subreq, ctx->child);
> > -	skcipher_request_set_callback(subreq, req->base.flags, crypt_done, re=
q);
> > +	skcipher_request_set_callback(subreq, req->base.flags, compl, req);
> >  	skcipher_request_set_crypt(subreq, req->dst, req->dst,
> > -				   req->cryptlen, NULL);
> > +				   req->cryptlen & ~(XTS_BLOCK_SIZE - 1), NULL);
> >
> >  	/* calculate first value of T */
> >  	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
> > +
> > +	return 0;
> >  }
> >
> >  static int encrypt(struct skcipher_request *req)
> >  {
> >  	struct rctx *rctx =3D skcipher_request_ctx(req);
> >  	struct skcipher_request *subreq =3D &rctx->subreq;
> > +	int err;
> >
> > -	init_crypt(req);
> > -	return xor_tweak_pre(req) ?:
> > -		crypto_skcipher_encrypt(subreq) ?:
> > -		xor_tweak_post(req);
> > +	err =3D init_crypt(req, encrypt_done) ?:
> > +	      xor_tweak_pre(req, true) ?:
> > +	      crypto_skcipher_encrypt(subreq) ?:
> > +	      xor_tweak_post(req, true);
> > +
> > +	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) =3D=3D 0))
> > +		return err;
> > +
> > +	return cts_final(req, crypto_skcipher_encrypt);
> >  }
> >
> >  static int decrypt(struct skcipher_request *req)
> >  {
> >  	struct rctx *rctx =3D skcipher_request_ctx(req);
> >  	struct skcipher_request *subreq =3D &rctx->subreq;
> > +	int err;
> > +
> > +	err =3D init_crypt(req, decrypt_done) ?:
> > +	      xor_tweak_pre(req, false) ?:
> > +	      crypto_skcipher_decrypt(subreq) ?:
> > +	      xor_tweak_post(req, false);
> > +
> > +	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) =3D=3D 0))
> > +		return err;
> >
> > -	init_crypt(req);
> > -	return xor_tweak_pre(req) ?:
> > -		crypto_skcipher_decrypt(subreq) ?:
> > -		xor_tweak_post(req);
> > +	return cts_final(req, crypto_skcipher_decrypt);
> >  }
> >
> >  static int init_tfm(struct crypto_skcipher *tfm)
> > --
> > 2.17.1
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
