Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAC9C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 12:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1984B214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 12:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ky1+6Cjq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfLKMUR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 07:20:17 -0500
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:3930
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729220AbfLKMUP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 07:20:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbA6ra3RLFt4C9dCGxeQpWnDOZ9ptErSdVanpM6a8dXMysWjP5ui07BmpwLV+R3Kt64PFfUko0jz9f8fPswNc68E3mclHBG8Q4AKwanavDt0zPpsFTrrLT27IxW8PHw86XfUD6F+Vt1/DterABUQrJC4zdO5wMA2C0EPYIpGZyRl8ZFva8rham6sy3iQXV4Q1v8DPmY2ZAXJ9ma3BYj7q/taboGOazscPeg5CV7CrJBPmnZR+P5MY13N0yzFEItrRKO7v0tbsTiWEBAqhPMeDSARfix9ZeXYOvcM+EY4kCUR43Ud7qv4SfeaG8o05lb1oRvKU31JCoJ4/0VCNbhT4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iuKx/crf9ymX992o3BlYkqaznBMTlcAbNO0Prwtv84=;
 b=jS/uRwq2t5uLhhhT1jvwdlS4F3SIpzVo3tY7xUwZe/o8VlHbizxwVeuRzK8ruFsF+ottoz43S6UOKiGs+73xDIcOyQTreNjHGKeX545eDP+CLKW2KYaNpPD39pT6Mz/nbVPOiMurSeHRpGNv/7zLZYw5r6fV6qMZZCjyLf+b1IiXIhk6BMXXVa8fhv3pAoJsqbyGRh4/mN0cQoJ64mtuYKVqZvQJ4tjN7dp+B2u5KZChVVg8Giu3tC2234huwvKOamu6YFtFaQQODQhGaPIBfn72v916hiwPbE5vmwESGvA+Avuj47HLaQdHHbyrx4zy/TFS436UxG8CjGIvT+YWzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iuKx/crf9ymX992o3BlYkqaznBMTlcAbNO0Prwtv84=;
 b=ky1+6Cjqb0YezGZM6iKjHK2Mv2D0w8ZRpip6pddTkwEt56g3k7ucaYUTKh8BVteHAHgDAgKrta24A6mWwV/XY6wpqNYATfDGa/1u7IA65SNoBeuom+9OHnNkUFtOSGXd49rQ5U6GjNgOxdogSANkY689VsQX41dSu6dumYv4c90=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5359.eurprd04.prod.outlook.com (20.178.122.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Wed, 11 Dec 2019 12:20:12 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2538.012; Wed, 11 Dec 2019
 12:20:12 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Bastian Krause <bst@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Topic: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Index: AQHVnZa0/lOdW2TUXUqvGjTaL30gkA==
Date:   Wed, 11 Dec 2019 12:20:11 +0000
Message-ID: <VI1PR04MB44458A1566067B5456337AEE8C5A0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
 <c0fa1e68-107d-f9ee-fbf2-0d0e6ef8d39d@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d72f027-6742-4f12-ab74-08d77e34786f
x-ms-traffictypediagnostic: VI1PR04MB5359:|VI1PR04MB5359:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5359F5C9658591BA6F86C1F88C5A0@VI1PR04MB5359.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(51234002)(189003)(199004)(478600001)(8936002)(7696005)(26005)(186003)(52536014)(55016002)(316002)(2906002)(5660300002)(110136005)(4326008)(66946007)(44832011)(6636002)(81166006)(9686003)(66556008)(54906003)(91956017)(86362001)(8676002)(76116006)(6506007)(64756008)(33656002)(66476007)(71200400001)(53546011)(66446008)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5359;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tjEyQvJsykQhptlRdCOMf+2rfT0aeG4pw8WApwg54/PYVu46N4CbFUDhqYWYXmEyFNu6zjDL9+nCjy2+cn2sJaL21bzg25nB5kNk2MrDhEWUpqrCVWL5PkXzvGVEZx93OM7CNrXmopaTYciLpURAwzJ30YczByz5w1UY7jJnspmtdXyxF5iZuV20YG/7x09aRvyOjUWlwZEtEYIU5rcC+ehNOI8B1F5HDzWR6G1jWRgDpmuprvVNg4pbpLNDIstN3l8l4rp+Wk5fj7ewmiJrX6mf4tGgVIo1zbe/rhjwZESTdHVQnD+tS54basBfeuDTPJmIe9tngv3wFSUMu0k2kz84NkaUhtglpjGv5cCazcvuL6z63kDYo4g7PQ+a7DRDr2MxlYPMm2Xzm459bRlDvqCvLG7gx/E2TrU+RgSpUNLRyEoQHzyZqjn9t5cnsbAlH4Xcn2wFQZtdMIN/gQhNUV0jHQmxVcAf0JNpO4sLEJBoT/C1u1a5H2Q2KQ76Ezl8
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d72f027-6742-4f12-ab74-08d77e34786f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 12:20:11.8498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rseVABsPJDtP3vBH49bMzGt+mRNwZvxAi48wMOh9bjnpn9NgghziOfy65bVOEw4AlGOfZ5TdfJlgbOIgvruTNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,=0A=
=0A=
On 12/10/2019 5:27 PM, Bastian Krause wrote:=0A=
> =0A=
> Hi Iulia,=0A=
> =0A=
> On 11/17/19 11:30 PM, Iuliana Prodan wrote:=0A=
>> Integrate crypto_engine into CAAM, to make use of the engine queue.=0A=
>> Add support for SKCIPHER algorithms.=0A=
>>=0A=
>> This is intended to be used for CAAM backlogging support.=0A=
>> The requests, with backlog flag (e.g. from dm-crypt) will be listed=0A=
>> into crypto-engine queue and processed by CAAM when free.=0A=
>> This changes the return codes for caam_jr_enqueue:=0A=
>> -EINPROGRESS if OK, -EBUSY if request is backlogged,=0A=
>> -ENOSPC if the queue is full, -EIO if it cannot map the caller's=0A=
>> descriptor, -EINVAL if crypto_tfm not supported by crypto_engine.=0A=
>>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>=0A=
>> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> ---=0A=
>>   drivers/crypto/caam/Kconfig   |  1 +=0A=
>>   drivers/crypto/caam/caamalg.c | 84 +++++++++++++++++++++++++++++++++++=
--------=0A=
>>   drivers/crypto/caam/intern.h  |  2 ++=0A=
>>   drivers/crypto/caam/jr.c      | 51 ++++++++++++++++++++++++--=0A=
>>   4 files changed, 122 insertions(+), 16 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig=
=0A=
>> index 87053e4..1930e19 100644=0A=
>> --- a/drivers/crypto/caam/Kconfig=0A=
>> +++ b/drivers/crypto/caam/Kconfig=0A=
>> @@ -33,6 +33,7 @@ config CRYPTO_DEV_FSL_CAAM_DEBUG=0A=
>>   =0A=
...=0A=
>>   =0A=
>> +static int skcipher_do_one_req(struct crypto_engine *engine, void *areq=
)=0A=
>> +{=0A=
>> +	struct skcipher_request *req =3D skcipher_request_cast(areq);=0A=
>> +	struct caam_ctx *ctx =3D crypto_skcipher_ctx(crypto_skcipher_reqtfm(re=
q));=0A=
>> +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);=0A=
>> +	struct caam_jr_request_entry *jrentry;=0A=
>> +	u32 *desc =3D rctx->edesc->hw_desc;=0A=
>> +	int ret;=0A=
>> +=0A=
>> +	jrentry =3D &rctx->edesc->jrentry;=0A=
>> +	jrentry->bklog =3D true;=0A=
>> +=0A=
>> +	ret =3D caam_jr_enqueue_no_bklog(ctx->jrdev, desc,=0A=
>> +				       rctx->skcipher_op_done, jrentry);=0A=
>> +=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>> +		skcipher_unmap(ctx->jrdev, rctx->edesc, req);=0A=
>> +		kfree(rctx->edesc);=0A=
>> +	} else {=0A=
>> +		ret =3D 0;=0A=
>> +	}=0A=
>> +=0A=
>> +	return ret;=0A=
> =0A=
> While testing this on a i.MX6 DualLite I see -ENOSPC being returned here=
=0A=
> after a couple of GiB of data being encrypted (via dm-crypt with LUKS=0A=
> extension). This results in these messages from crypto_engine:=0A=
> =0A=
>    caam_jr 2101000.jr0: Failed to do one request from queue: -28=0A=
> =0A=
> And later..=0A=
> =0A=
>    Buffer I/O error on device dm-0, logical block 59392=0A=
>    JBD2: Detected IO errors while flushing file data on dm-0-8=0A=
> =0A=
> Reproducible with something like this:=0A=
> =0A=
>    echo "testkey" | cryptsetup luksFormat \=0A=
>      --cipher=3Daes-cbc-essiv:sha256 \=0A=
>      --key-file=3D- \=0A=
>      --key-size=3D256 \=0A=
>      /dev/mmcblk1p8=0A=
>    echo "testkey" | cryptsetup open \=0A=
>      --type luks \=0A=
>      --key-file=3D- \=0A=
>      /dev/mmcblk1p8 data=0A=
> =0A=
>    mkfs.ext4 /dev/mapper/data=0A=
>    mount /dev/mapper/data /mnt=0A=
> =0A=
>    set -x=0A=
>    while [ true ]; do=0A=
>      dd if=3D/dev/zero of=3D/mnt/big_file bs=3D1M count=3D1024=0A=
>      sync=0A=
>    done=0A=
> =0A=
> Any ideas?=0A=
> =0A=
=0A=
Thanks for testing this!=0A=
I reproduced this issue on imx6dl, _but_ only with the bypass sw queue =0A=
patch. It only reproduces on some targets, e.g. on imx7d I don't get the =
=0A=
-ENOSPC error. So, I believe there is a timing issue between =0A=
crypto-engine and CAAM driver, both sending requests to CAAM hw.=0A=
I'm debugging this and I'll let you know my findings.=0A=
=0A=
Best regards,=0A=
Iulia=0A=
