Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AF8C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E74F2082F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="iUxjap41"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfF0JVz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 05:21:55 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:32928
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbfF0JVz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 05:21:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=BBhh+ywQpUW6/p4XUA3yAvUJnu7hb9hoc6vGHeA2vIleER+rDA7IDHeXgEdNbTEyCoweOMMBc8kEp0/4gCA6KZNNcGMEJK6EHd6zur7hVSh4/s2ikOPBBmbOC1wYNT66U2ayRF2VuOLR/h2w04996oC0Ecyi6jR+9PAr1dSpepI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghNMK8mo+X6HGaE1INlU1+hCZXcMFNhU8ks5VPEZf8Q=;
 b=xqMpg4TpTXRQz59nk6+sQG+EABSTigFOea8isT8+A4dpVnuxhcdZYvndaNbYhqGAVsXrvbAOwB4u8Cf6dxyjl4mKSWBKjs3twrpca9LtaNvZHT0j3sJ+ubQuGoGtSER3180/Aw3ZW0XC0s/kFug57hJeG5SMwigPdbut++ZMz2I=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghNMK8mo+X6HGaE1INlU1+hCZXcMFNhU8ks5VPEZf8Q=;
 b=iUxjap419detr5oxIrSur8fc46q/TICb+J+UXeFA0+VgJHmbA3KYZ9TgDrclQUEo5iYnMBLblHjKmvs7K7jIyeU1UwQtMhsrap9Pww2GXSdH34Hn6SQI+q5Xx7SKCGLdzL8c1kowB9CAYQ7CbvOPKsEEBihvETSRYgM4Hqv9zGI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3695.eurprd04.prod.outlook.com (52.134.15.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 09:21:52 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 09:21:52 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [PATCH] crypto: caam - fix dependency on CRYPTO_DES
Thread-Topic: [PATCH] crypto: caam - fix dependency on CRYPTO_DES
Thread-Index: AQHVLMg6bRP/EUM6h0yuxgQigJ2Bog==
Date:   Thu, 27 Jun 2019 09:21:51 +0000
Message-ID: <VI1PR0402MB3485DE37447B7A0F55A90E9898FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-28-ard.biesheuvel@linaro.org>
 <VI1PR0402MB3485E399D27D2D86674DBE6198FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu_YWFO0+rzNJv=FrdR2rrLEK7d1vHzAOBgCHUeOFu7oZw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c267f449-4f44-47f8-333f-08d6fae0e3d0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3695;
x-ms-traffictypediagnostic: VI1PR0402MB3695:
x-microsoft-antispam-prvs: <VI1PR0402MB36950E94F966B0707EC8467D98FD0@VI1PR0402MB3695.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(376002)(39860400002)(396003)(136003)(189003)(199004)(74316002)(6506007)(54906003)(53936002)(478600001)(316002)(66066001)(81156014)(86362001)(66556008)(52536014)(8676002)(7696005)(99286004)(14454004)(305945005)(25786009)(6436002)(256004)(81166006)(66946007)(66476007)(8936002)(9686003)(76116006)(7736002)(73956011)(229853002)(66446008)(64756008)(55016002)(33656002)(446003)(6116002)(486006)(68736007)(476003)(14444005)(71190400001)(71200400001)(5660300002)(4326008)(6916009)(6246003)(44832011)(2906002)(3846002)(186003)(26005)(53546011)(76176011)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3695;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VWF1bAAXb/b547RJcbr80tJNhB7nBm+oY9W38txfCRClCeKsCOKY144fRAsEOr6CY8aYrCxd1Kx6aUh21EtlprQd7qR04o/frZMxPQVxuB6XSpIUMkJSd83z1ckr8NkyVUV2wHG8HoqGSliteHZMm3VZBHnwncjKQL/k+lVEjiluuBu73i4nAMnnZf9I2xxln+a41FDvlnHiXmMcrN+1P/MPJGkQx4Wb4hL6TxCOa/ya+6jwcOwOV+VlHexOnEf1VGYi3zm3yImdmtrfyB8r3m0nujd0wbb3/bcJfsynXnRi1RhlH/rYP1b9IMecVlykxPjDUPK0/657eXgogKHuIy9nIAErJQgW241Pxq6LGI7xFWzBTA6dDtywpLxrb1uOA0v3VAbqSRFq5PuS6oQIK+vijE4848Tcn7mdeVKxE+E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c267f449-4f44-47f8-333f-08d6fae0e3d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 09:21:51.9965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3695
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/27/2019 12:12 PM, Ard Biesheuvel wrote:=0A=
> On Thu, 27 Jun 2019 at 11:10, Horia Geanta <horia.geanta@nxp.com> wrote:=
=0A=
>>=0A=
>> (changed subject to make patchwork happy=0A=
>> was: [RFC PATCH 27/30] crypto: des - split off DES library from generic =
DES cipher driver)=0A=
>>=0A=
>> On 6/22/2019 3:32 AM, Ard Biesheuvel wrote:=0A=
>>> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig=
=0A=
>>> index 3720ddabb507..4a358391b6cb 100644=0A=
>>> --- a/drivers/crypto/caam/Kconfig=0A=
>>> +++ b/drivers/crypto/caam/Kconfig=0A=
>>> @@ -98,7 +98,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API=0A=
>>>       select CRYPTO_AEAD=0A=
>>>       select CRYPTO_AUTHENC=0A=
>>>       select CRYPTO_BLKCIPHER=0A=
>>> -     select CRYPTO_DES=0A=
>>> +     select CRYPTO_LIB_DES=0A=
>>>       help=0A=
>>>         Selecting this will offload crypto for users of the=0A=
>>>         scatterlist crypto API (such as the linux native IPSec=0A=
>>=0A=
>> There are two other config symbols that should select CRYPTO_LIB_DES:=0A=
>> CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=0A=
>> CRYPTO_DEV_FSL_DPAA2_CAAM=0A=
>>=0A=
>> True, this is not stricty related to refactoring in this patch set,=0A=
>> but actually a fix of=0A=
>> commit 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=0A=
>>=0A=
> =0A=
> The 3des key checks are static inline functions defined in des.h, so=0A=
> there is no need to depend on the library or on the generic driver=0A=
> AFAICT=0A=
> =0A=
True, des3_verify_key and __des3_verify_key are in des.h.=0A=
Please ignore this.=0A=
=0A=
Thanks,=0A=
Horia=0A=
