Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB07EC7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88E972080D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:59:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="sLTIyOlZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfGRO7m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:59:42 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:18560
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726040AbfGRO7l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 10:59:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DU3ajOw9XKVDILdGE5+T+otORQ/aZdc8lH6SeHsyqVJfQ+ibBn2YeDZy1qf7QjW6c+HiwmYeOhKQ2JB/IQyFxmlPNTBX/dxJCnX2UwsSD0Lq7sSKpcR7MH4TgCFepM5dsdmLry/7wk9YNvJmR4yZu4VhlcInqThK7iFrrlheIlmtR7K1vbhyamDyzNjzJLofX3FrR+NpZMFKvVfsMw5B9R+pDObjJjTGa8I1XLO9ifxFlHirHw0cuwqETh1Jn6v14kITii9nXtNZTTqcu6z620l+GNfDbwKhRsy//UWBSzwunoHit7iVCpefnV7gv53Fd6xAsGOkYpWM4WTLEY2u7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOe7vdfm8fCk8XgvIb/oFm57CwzuPAuA6FeT0zxzzQE=;
 b=gdnGIz0t9JxBxI/VaHCjYy/Bw5vN3rJtGiN9SK/rxSz87hPUkxXaQjyciyurMfOw5fuMvNgEP00Lm+wjlz+fpFO4qzaX77uf4XnN8ALHqoJCb6HaeQ/rnmAJZX/5MJ1dMCe08H8zRkL4mxPWfiqbFgwou10pTednHWDQpKbaNZkRIIJaiLRn4SdcTYHtNmzygT38evZatxd0M5PfFLeF2qM0jK/O3iIVKFvPM76DHobTRfrnoaW4lSUs5tK2kWwnjIjB//ddKB+w0dcJK92Ge4RoJhRVfvuvuV0nRRH3N135v/iMH4sGQe74xxWVEQXafYnqwCfolXLCD/uHo3mSnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOe7vdfm8fCk8XgvIb/oFm57CwzuPAuA6FeT0zxzzQE=;
 b=sLTIyOlZlQmT/F3Rrk0+HXMX7ID0aA84YoviUM6m2IhEtVhXeXOrigt8ZYD3GtTnOXsPXUmlWilKldImusJPks0zZMUOklx+jPjoW/L87HCp2aLXmSh0ccpSQ087EdEz2JvhfvqhiZGFiZhXrA3af2yTfuZr9pMCUHwFcamcEsw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3648.eurprd04.prod.outlook.com (52.134.14.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 14:59:37 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 14:59:37 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 03/14] crypto: caam - update IV only when crypto operation
 succeeds
Thread-Topic: [PATCH 03/14] crypto: caam - update IV only when crypto
 operation succeeds
Thread-Index: AQHVPXd3cwGqxppDGUKIXr9oiBjl2g==
Date:   Thu, 18 Jul 2019 14:59:37 +0000
Message-ID: <VI1PR0402MB34855E675A58E1221ACE7B9498C80@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
 <1563461124-24641-4-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7f5eb99-9415-4d65-e077-08d70b908d89
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3648;
x-ms-traffictypediagnostic: VI1PR0402MB3648:
x-microsoft-antispam-prvs: <VI1PR0402MB364837C0D6FABE6A032AE3DB98C80@VI1PR0402MB3648.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(199004)(189003)(478600001)(316002)(446003)(52536014)(2906002)(6246003)(6636002)(76176011)(15650500001)(8936002)(33656002)(26005)(8676002)(186003)(102836004)(5660300002)(229853002)(66446008)(66556008)(64756008)(81166006)(256004)(305945005)(81156014)(66066001)(476003)(6506007)(110136005)(53546011)(7696005)(55016002)(74316002)(66946007)(66476007)(76116006)(25786009)(86362001)(68736007)(6436002)(91956017)(9686003)(71190400001)(53936002)(14444005)(4326008)(14454004)(54906003)(44832011)(6116002)(99286004)(486006)(71200400001)(3846002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3648;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gEpMCRIrZQIndidZS6FcTiV7plb0qtRzcWgtuW2L6dyaatcqvBs3StpkhU3uwdc/lFPES9U6fXF7G0bdiGlfnXlwg/HXbLuzSjfn2B5geOaBQTG3CV+IOAmEeabI63kf97YvAtf7UQ30kaoBZ3FJ9O38lvqG5PMUWgZexZd2hQO5KyXBLiIZc4WqQQ2YPT4SUPer2nD4oAGlZyzrcf6MzpShlGesQXJ3MqmGxlq0AyyZAJI/ERKG95YXmOLlM1mKGD0Kx98S52CdHuwsj2DozciHebdaEM4ls7rvbxWDOzojRFjnGIxc6FV8LdruVPq4DgnANShg4qhOW9TizXvL7aMUW0PU3/H2EM9KNzF2c1YjAZEoif2xDY40EY7UNt7jdVpp7VzHype1bdqtNnUoFvfYoMyq1EkG0QX7JVE4zBA=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f5eb99-9415-4d65-e077-08d70b908d89
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 14:59:37.3724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3648
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/18/2019 5:45 PM, Iuliana Prodan wrote:=0A=
> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> skcipher encryption might fail and in some cases, like (invalid) input=0A=
> length smaller then block size, updating the IV would lead to panic=0A=
> due to copying from a negative offset (req->cryptlen - ivsize).=0A=
> =0A=
The commit message is no longer in sync with the code base.=0A=
=0A=
More exactly, after commit=0A=
334d37c9e263 ("crypto: caam - update IV using HW support")=0A=
there shouldn't be any panic, only a useless IV copy in case HW issued=0A=
an error.=0A=
=0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg.c     | 5 ++---=0A=
>  drivers/crypto/caam/caamalg_qi.c  | 4 +++-=0A=
>  drivers/crypto/caam/caamalg_qi2.c | 8 ++++++--=0A=
>  3 files changed, 11 insertions(+), 6 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 06b4f2d..28d55a0 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -990,10 +990,9 @@ static void skcipher_encrypt_done(struct device *jrd=
ev, u32 *desc, u32 err,=0A=
>  	 * ciphertext block (CBC mode) or last counter (CTR mode).=0A=
>  	 * This is used e.g. by the CTS mode.=0A=
>  	 */=0A=
> -	if (ivsize) {=0A=
> +	if (ivsize && !ecode) {=0A=
>  		memcpy(req->iv, (u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,=0A=
>  		       ivsize);=0A=
> -=0A=
>  		print_hex_dump_debug("dstiv  @"__stringify(__LINE__)": ",=0A=
>  				     DUMP_PREFIX_ADDRESS, 16, 4, req->iv,=0A=
>  				     edesc->src_nents > 1 ? 100 : ivsize, 1);=0A=
> @@ -1030,7 +1029,7 @@ static void skcipher_decrypt_done(struct device *jr=
dev, u32 *desc, u32 err,=0A=
>  	 * ciphertext block (CBC mode) or last counter (CTR mode).=0A=
>  	 * This is used e.g. by the CTS mode.=0A=
>  	 */=0A=
> -	if (ivsize) {=0A=
> +	if (ivsize && !ecode) {=0A=
>  		memcpy(req->iv, (u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,=0A=
>  		       ivsize);=0A=
>  =0A=
> diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caama=
lg_qi.c=0A=
> index ab263b1..66531d6 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi.c=0A=
> @@ -1201,7 +1201,9 @@ static void skcipher_done(struct caam_drv_req *drv_=
req, u32 status)=0A=
>  	 * ciphertext block (CBC mode) or last counter (CTR mode).=0A=
>  	 * This is used e.g. by the CTS mode.=0A=
>  	 */=0A=
> -	memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes, ivsize);=0A=
> +	if (!ecode)=0A=
> +		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,=0A=
> +		       ivsize);=0A=
>  =0A=
>  	qi_cache_free(edesc);=0A=
>  	skcipher_request_complete(req, ecode);=0A=
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caam=
alg_qi2.c=0A=
> index 2681581..bc370af 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi2.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi2.c=0A=
> @@ -1358,7 +1358,9 @@ static void skcipher_encrypt_done(void *cbk_ctx, u3=
2 status)=0A=
>  	 * ciphertext block (CBC mode) or last counter (CTR mode).=0A=
>  	 * This is used e.g. by the CTS mode.=0A=
>  	 */=0A=
> -	memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes, ivsize);=0A=
> +	if (!ecode)=0A=
> +		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,=0A=
> +		       ivsize);=0A=
>  =0A=
>  	qi_cache_free(edesc);=0A=
>  	skcipher_request_complete(req, ecode);=0A=
> @@ -1394,7 +1396,9 @@ static void skcipher_decrypt_done(void *cbk_ctx, u3=
2 status)=0A=
>  	 * ciphertext block (CBC mode) or last counter (CTR mode).=0A=
>  	 * This is used e.g. by the CTS mode.=0A=
>  	 */=0A=
> -	memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes, ivsize);=0A=
> +	if (!ecode)=0A=
> +		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,=0A=
> +		       ivsize);=0A=
>  =0A=
>  	qi_cache_free(edesc);=0A=
>  	skcipher_request_complete(req, ecode);=0A=
> =0A=
