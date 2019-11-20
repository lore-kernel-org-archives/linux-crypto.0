Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011B6C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 06:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05B2206F4
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 06:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DuBfJgC0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfKTGsu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 01:48:50 -0500
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:37892
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfKTGsu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 01:48:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MywdcaNfUoXwboFXnTWWiz9pQ0rfEvQy10bHKUSQ3EoNckbUm0fEIA5RNXAfD7QQaLAH6ihI9RZ0SECm+97pZUzTmgp09GO6C+p3Y2hZZQH3j4TFtdXQkQWvju3WGfIv04XT+fXk+8p4HZZAmu2lj6zzHSb9sLKevVsMdE/HW1SFNEff0YBbtFnwlY7AknOW92aC/EN7mIe1xAIGAvXjdysXcrTkn1xdqQsqpAG7qRFO4CNf9gy9UAA+hsP1Pl1mqfMISx70nFuGblqoZLoVUmArMaPMkELp2cLZeJ7g7pFxdUjhjlUwmcx4FDnf9wk5EhSne7i+js5bfa+OxCU/mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OE4wwLvuXgSjPKi+br6ukVBWvo8q9PudQXLCtsLbgAo=;
 b=R+XtPtOeMGX7Ngk1O1hz3Fw1hWzKBsgHFuZJre17NPKkS7iQO88t0W1L3yZ/5IdhpkCibDCEWrl4AjXoMqXRLUclg2Wsy25HlD/yUYkxXfZD6g+0UpiSW1iuuM7422np/3nGj6BZrBdHViJO18Pbapo/skAdki8pXcFnZZSWa2ELh0bRCvJg6apKy2gUcf5hpAzu6u9Pj7g459nmw0kJFLnESqVgsYm53U22KUWLhBjQ8fx2D/45bQ8Xea4UTjr81Cet1BCN7ZfqeUmhz1gA6aMJqzFhCpa3vayxvCgeeUYuh53J98ruvNSoAeO6Ha9DplsWezHPrbmJulIdUm5u1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OE4wwLvuXgSjPKi+br6ukVBWvo8q9PudQXLCtsLbgAo=;
 b=DuBfJgC0DP5gTJDrHEeU9DG7kPhs4fb3kceRcUBBk6q4yXUPI876yBYWgaPhzDSmnXeH5jJP6Ut/oo6agA52NBm6FnYRXIqwTYE04YtSVSMlJmGlBsq4Xh7TfWfYZ2Wcwlz3BYKlUXnLkq8Y+oCWMYi3B4HANLTD7VxcUug3Gcs=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2718.eurprd04.prod.outlook.com (10.175.21.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Wed, 20 Nov 2019 06:48:46 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 06:48:46 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 07/12] crypto: caam - refactor caam_jr_enqueue
Thread-Topic: [PATCH 07/12] crypto: caam - refactor caam_jr_enqueue
Thread-Index: AQHVnZa0sS6CFfezokOAnr5a2apfuA==
Date:   Wed, 20 Nov 2019 06:48:46 +0000
Message-ID: <VI1PR0402MB3485EAC0D46F50CCF68AC891984F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-8-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB34853893505F95195F4C125B984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR04MB44452654BA9716CA43992AA68C4C0@VI1PR04MB4445.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bfa70ebc-be06-48c9-9fc4-08d76d85b133
x-ms-traffictypediagnostic: VI1PR0402MB2718:|VI1PR0402MB2718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB27182128A95F30A76F895AB7984F0@VI1PR0402MB2718.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(189003)(199004)(8676002)(6246003)(316002)(4326008)(81166006)(7696005)(81156014)(71190400001)(33656002)(91956017)(25786009)(44832011)(476003)(5660300002)(55016002)(8936002)(76116006)(229853002)(9686003)(186003)(486006)(66066001)(99286004)(6506007)(53546011)(6436002)(86362001)(66946007)(110136005)(446003)(76176011)(6636002)(478600001)(14454004)(74316002)(66446008)(26005)(6116002)(102836004)(64756008)(66556008)(14444005)(52536014)(2906002)(71200400001)(7736002)(3846002)(54906003)(66476007)(305945005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2718;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TvLU7SuwCILgPL1mB+GxJsBTgPJ8YmI78KlhUJvMvSu/M87Qs72GciU1CeBy9tqY2w09aFt7kAiqPs0awnIQ4LP35sjPvREvIQtqaAJvRZAMHX3Kh+9gsc4iP1EOx6fru7qDonEayGnZC87x/TQIGSuY62Kc6dY9u7LSV7z1PkOsrM83abZGNDuBBcsBycfoMPWWPHdVWxaSQJlT+kIBHp5Vj1Mv4uFdTpqFT82YP2/VsKvAt3vTQLC8IHl/9k/KjB5qYZ7gL/pnPGEWy+rukfbJAh60+Y9wV7Q4HnBL1ZwmdsfVSSb057kMM5E+JejVXQDbrsUOGDv8xYPumoeG8fCm/dCHoT4NnAu0mpKsFzWhfvmnjUOw6AJ2SdtfgBki65CJm7ifh2oQXWM6AjYyJ5LgaXcu9AYiXJgoHGC+/1fZ4VP+zBdez3+/on+aY8Jq
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa70ebc-be06-48c9-9fc4-08d76d85b133
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 06:48:46.6013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Smik4Jj11py1morsMbIkxmcmB5uqTCz0HZbXIjiJVblh31ekj6S1aH20CRdzlUAUeK+yo7cV98ZaHFqQvsJW7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2718
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/20/2019 12:49 AM, Iuliana Prodan wrote:=0A=
> On 11/19/2019 7:55 PM, Horia Geanta wrote:=0A=
>> On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
>>> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamh=
ash.c=0A=
>>> index baf4ab1..d9de3dc 100644=0A=
>>> --- a/drivers/crypto/caam/caamhash.c=0A=
>>> +++ b/drivers/crypto/caam/caamhash.c=0A=
>> [...]=0A=
>>> @@ -933,11 +943,13 @@ static int ahash_final_ctx(struct ahash_request *=
req)=0A=
>>>   			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>>>   			     1);=0A=
>>>   =0A=
>>> -	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);=0A=
>>> +	jrentry =3D &edesc->jrentry;=0A=
>>> +=0A=
>>> +	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);=0A=
>>>   	if (ret =3D=3D -EINPROGRESS)=0A=
>>>   		return ret;=0A=
>>>   =0A=
>>> - unmap_ctx:=0A=
>>> +unmap_ctx:=0A=
>> That's correct, however whitespace fixing should be done separately.=0A=
>>=0A=
> Should I make a separate patch for these two whitespaces?=0A=
> =0A=
Whitespace fixes should be moved out of this patch set.=0A=
In general, patches handling this go through the whole file / driver.=0A=
=0A=
Horia=0A=
