Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0456C388F3
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 20:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D79B22518
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 20:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="rJKZfeud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfI3Ui7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 16:38:59 -0400
Received: from mail-eopbgr810042.outbound.protection.outlook.com ([40.107.81.42]:46352
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729636AbfI3Ui4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 16:38:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfHHkDnRSqOxZzcrwKkGakWhQOj/0nb+rDfJUHmFhghksX/E21MQQJzXc70cEqs+NsV0Lkxkz+CHmLiLydM44lMWELJgdF4g9+arjsirwnAcXw5G7HIK5FGmkzrvrXwVagMlb/LXJvjWa1OuSre7sEYOV+kLsi1/g/fEgDh1s0nTvMTc62AOme1JagFhvaw1Hrj1AoMw4P1ZoWcIR6nr311QsC5Jdl01TSdEIWYqETbbmoyKteX5bDIp8XPsxqDQvSWy8/u3CVGLFgi9LKgLXvK5KNaagWGJeeomZNYunV/WUdjPFrm3pq4is05QaA+zrsPuhtsTg+Ws5sqkKM52Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FL1Voe/YukiInIpN+TRUbtVw0raKOWtIDr3KoQi9GxI=;
 b=QAFGt+HDgz9AL6PK14VeKMM9tl/wjvRcXbN1vNbOMGf1p9SP34PU0i9rjKkDTejNY/Q7q7D1AAMXSxVYGZ27wyDtmOYsFi709bwEoXcqFXpGUuNwCkt5V04/8KipWlMRQC6q7PBT1szbfQZtm0iOKv0AJ+hcyia+wxMq8PFeHydF3K4vkXq5SLKcGsHWAicvAZ2YqOToVhvc5fP6ivQxs3JGFlW+Ubs0x0hX45PohbKMW/xApt4AE3H2Toy7B7nGJpEHV0w2DZmC1srDz8H7h49i5O4UQzNtFhKYl4skpCUyKFXA4g8rwi7/X+aG//PLVopdy/lMAEfhm1kkMAWDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FL1Voe/YukiInIpN+TRUbtVw0raKOWtIDr3KoQi9GxI=;
 b=rJKZfeudlRzsnzrlTxblD3vRbIdxqtu7Wor1QsJCVj8f/TL5wbh2R7u1W0l9TL5B6yyeA7w+kPIkHod4zbmjGdyt3MaR1PIDTj0QxxFcDoh5q5oRVEKeYUGciJGC5Gw7Vv8SGiuYewpJMVLAhZoAOQx5piJSD2+4Cd8wjbTf0t4=
Received: from CH2PR20MB2968.namprd20.prod.outlook.com (10.255.156.33) by
 CH2SPR01MB0005.namprd20.prod.outlook.com (10.255.155.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Mon, 30 Sep 2019 19:04:24 +0000
Received: from CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae]) by CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae%5]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 19:04:23 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
Thread-Topic: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
Thread-Index: AQHVd4jLpZQEIOemw0ukUdKdGUz6fqdEkO9A
Date:   Mon, 30 Sep 2019 19:04:23 +0000
Message-ID: <CH2PR20MB2968B7855D241C747BEB68B9CA820@CH2PR20MB2968.namprd20.prod.outlook.com>
References: <20190930121520.1388317-1-arnd@arndb.de>
 <20190930121520.1388317-2-arnd@arndb.de>
In-Reply-To: <20190930121520.1388317-2-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbdcd030-0bf0-4ec9-c0bb-08d745d901cb
x-ms-traffictypediagnostic: CH2SPR01MB0005:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CH2SPR01MB00058F2AC4E1631B5DF69476CA820@CH2SPR01MB0005.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(346002)(366004)(136003)(189003)(199004)(13464003)(51444003)(256004)(5660300002)(2906002)(478600001)(76116006)(99286004)(9686003)(86362001)(26005)(8676002)(81156014)(6506007)(76176011)(229853002)(53546011)(14444005)(81166006)(8936002)(15974865002)(66946007)(14454004)(66476007)(66446008)(66556008)(6436002)(55016002)(52536014)(7696005)(186003)(33656002)(7736002)(3846002)(71200400001)(305945005)(476003)(74316002)(71190400001)(66066001)(316002)(102836004)(54906003)(446003)(64756008)(25786009)(486006)(4326008)(11346002)(110136005)(6116002)(6246003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2SPR01MB0005;H:CH2PR20MB2968.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +vQG8ViFzOzrmj/9kjXkYFrZoTfiqqZ4XGy6OjTlRbs88sZSjCtEn8IykEdWTgSd914pCSA+ZgepV2GAzZazEtO2nsvMnzdELfM0Wy50YuvmCdgXlo5tutzvEhrB34jn1iV9A7zh4bqX/Yx8jHMIQnNOqsKCdexUAzpPTorMCRTQewODKy/iFiw7cHt+1RNisJQBEyB/bF6ST+PX709cPWoYdwkz64LXjMIPrLUAjGvo8PkEptTNNRexaA/fAI4NBU48qyDCEZfNdi/2sUNQuJoctJkfbX2tglneG0uwtivg/JP3EVlmtW9n2DyBMKUMG5FceFDrXHG18SypZX5vaeXhA5l8//RgDd5nTXLVxfFTHoKBWqMEsAtuQgZUbNYYBy+pAHtDHEZJ3J9mdppkJsY9y28iuBhhU+wxg6Ae+/I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbdcd030-0bf0-4ec9-c0bb-08d745d901cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 19:04:23.5635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EIua5YWqSTkQw1wXlQq9MRxCvR6PggX22phHAxZS+4XZjUng9HT2lLTMOYe13Rnh9ir3nQS/9YD9GNwPrWIZxhArqu3ru2MIngxI+NB8THg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2SPR01MB0005
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann <arnd@arndb.de>
> Sent: Monday, September 30, 2019 2:15 PM
> To: Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gond=
or.apana.org.au>;
> David S. Miller <davem@davemloft.net>
> Cc: Arnd Bergmann <arnd@arndb.de>; Pascal Van Leeuwen <pvanleeuwen@verima=
trix.com>; Pascal
> van Leeuwen <pascalvanl@gmail.com>; Ard Biesheuvel <ard.biesheuvel@linaro=
.org>; Eric Biggers
> <ebiggers@google.com>; linux-crypto@vger.kernel.org; linux-kernel@vger.ke=
rnel.org
> Subject: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
>=20
> safexcel_aead_setkey() contains three large stack variables, totalling
> slightly more than the 1024 byte warning limit:
>=20
> drivers/crypto/inside-secure/safexcel_cipher.c:303:12: error: stack frame=
 size of 1032 bytes
> in function 'safexcel_aead_setkey' [-Werror,-Wframe-larger-than=3D]
>=20
Ok, I did not realise that, so thanks for pointing that out to me.

> The function already contains a couple of dynamic allocations, so it is
> likely not performance critical and it can only be called in a context
> that allows sleeping, so the easiest workaround is to add change it
> to use dynamic allocations. Combining istate and ostate into a single
> variable simplifies the allocation at the cost of making it slightly
> less readable.
>=20
Hmmm... I wouldn't exactly consider it to be not performance critical - it
can be under certain circumstanced, but I guess it's already wasting lots
of cycles on allocations and key precomputes in safexcel_hmac_setkey, so
for now dynamically allocating the state is fine.

> Alternatively, it should be possible to shrink these allocations
> as the extra buffers appear to be largely unnecessary, but doing
> this would be a much more invasive change.
>=20
Actually, for HMAC-SHA512 you DO need all that buffer space.
You could shrink it to 2 * ctx->state_sz but then your simple indexing
is no longer going to fly. Not sure if that would be worth the effort.

I don't like the part where you dynamically allocate the cryto_aes_ctx
though, I think that was not necessary considering its a lot smaller.
And it conflicts with another change I have waiting that gets rid of=20
aes_expandkey and that struct alltogether (since it was really just
abused to do a key size check, which was very wasteful since the=20
function actually generates all roundkeys we don't need at all ...)

So I'll get rid of that struct anyway and doing it in this patch just
complicates applying your patch to my code or rebasing my stuff later.

> Fixes: 0e17e3621a28 ("crypto: inside-secure - add support for
> authenc(hmac(sha*),rfc3686(ctr(aes))) suites")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../crypto/inside-secure/safexcel_cipher.c    | 53 ++++++++++++-------
>  1 file changed, 35 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-
> secure/safexcel_cipher.c
> index ef51f8c2b473..51a4112aa9bc 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -305,10 +305,10 @@ static int safexcel_aead_setkey(struct crypto_aead =
*ctfm, const u8
> *key,
>  {
>  	struct crypto_tfm *tfm =3D crypto_aead_tfm(ctfm);
>  	struct safexcel_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
> -	struct safexcel_ahash_export_state istate, ostate;
> +	struct safexcel_ahash_export_state *state;
>  	struct safexcel_crypto_priv *priv =3D ctx->priv;
> +	struct crypto_aes_ctx *aes;
>  	struct crypto_authenc_keys keys;
> -	struct crypto_aes_ctx aes;
>  	int err =3D -EINVAL;
>=20
>  	if (crypto_authenc_extractkeys(&keys, key, len) !=3D 0)
> @@ -334,7 +334,14 @@ static int safexcel_aead_setkey(struct crypto_aead *=
ctfm, const u8 *key,
>  			goto badkey_expflags;
>  		break;
>  	case SAFEXCEL_AES:
> -		err =3D aes_expandkey(&aes, keys.enckey, keys.enckeylen);
> +		aes =3D kzalloc(sizeof(*aes), GFP_KERNEL);
> +		if (!aes) {
> +			err =3D -ENOMEM;
> +			goto badkey;
> +		}
> +
> +		err =3D aes_expandkey(aes, keys.enckey, keys.enckeylen);
> +		kfree(aes);
>  		if (unlikely(err))
>  			goto badkey;
>  		break;
> @@ -347,56 +354,66 @@ static int safexcel_aead_setkey(struct crypto_aead =
*ctfm, const u8
> *key,
>  	    memcmp(ctx->key, keys.enckey, keys.enckeylen))
>  		ctx->base.needs_inv =3D true;
>=20
> +	state =3D kzalloc(sizeof(struct safexcel_ahash_export_state) * 2, GFP_K=
ERNEL);
> +	if (!state) {
> +		err =3D -ENOMEM;
> +		goto badkey;
> +	}
> +
>  	/* Auth key */
>  	switch (ctx->hash_alg) {
>  	case CONTEXT_CONTROL_CRYPTO_ALG_SHA1:
>  		if (safexcel_hmac_setkey("safexcel-sha1", keys.authkey,
> -					 keys.authkeylen, &istate, &ostate))
> -			goto badkey;
> +					 keys.authkeylen, &state[0], &state[1]))
> +			goto badkey_free;
>  		break;
>  	case CONTEXT_CONTROL_CRYPTO_ALG_SHA224:
>  		if (safexcel_hmac_setkey("safexcel-sha224", keys.authkey,
> -					 keys.authkeylen, &istate, &ostate))
> -			goto badkey;
> +					 keys.authkeylen, &state[0], &state[1]))
> +			goto badkey_free;
>  		break;
>  	case CONTEXT_CONTROL_CRYPTO_ALG_SHA256:
>  		if (safexcel_hmac_setkey("safexcel-sha256", keys.authkey,
> -					 keys.authkeylen, &istate, &ostate))
> -			goto badkey;
> +					 keys.authkeylen, &state[0], &state[1]))
> +			goto badkey_free;
>  		break;
>  	case CONTEXT_CONTROL_CRYPTO_ALG_SHA384:
>  		if (safexcel_hmac_setkey("safexcel-sha384", keys.authkey,
> -					 keys.authkeylen, &istate, &ostate))
> -			goto badkey;
> +					 keys.authkeylen, &state[0], &state[1]))
> +			goto badkey_free;
>  		break;
>  	case CONTEXT_CONTROL_CRYPTO_ALG_SHA512:
>  		if (safexcel_hmac_setkey("safexcel-sha512", keys.authkey,
> -					 keys.authkeylen, &istate, &ostate))
> -			goto badkey;
> +					 keys.authkeylen, &state[0], &state[1]))
> +			goto badkey_free;
>  		break;
>  	default:
>  		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
> -		goto badkey;
> +		goto badkey_free;
>  	}
>=20
>  	crypto_aead_set_flags(ctfm, crypto_aead_get_flags(ctfm) &
>  				    CRYPTO_TFM_RES_MASK);
>=20
>  	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
> -	    (memcmp(ctx->ipad, istate.state, ctx->state_sz) ||
> -	     memcmp(ctx->opad, ostate.state, ctx->state_sz)))
> +	    (memcmp(ctx->ipad, &state[0].state, ctx->state_sz) ||
> +	     memcmp(ctx->opad, &state[1].state, ctx->state_sz)))
>  		ctx->base.needs_inv =3D true;
>=20
>  	/* Now copy the keys into the context */
>  	memcpy(ctx->key, keys.enckey, keys.enckeylen);
>  	ctx->key_len =3D keys.enckeylen;
>=20
> -	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
> -	memcpy(ctx->opad, &ostate.state, ctx->state_sz);
> +	memcpy(ctx->ipad, &state[0].state, ctx->state_sz);
> +	memcpy(ctx->opad, &state[1].state, ctx->state_sz);
>=20
>  	memzero_explicit(&keys, sizeof(keys));
> +	kfree(state);
> +
>  	return 0;
>=20
> +badkey_free:
> +	kfree(state);
>  badkey:
>  	crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
>  badkey_expflags:
> --
> 2.20.0

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

