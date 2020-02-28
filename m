Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A128C3F2CF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 06:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E9C424672
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 06:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="QjHNJUFS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgB1GkP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 01:40:15 -0500
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:2526
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgB1GkP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 01:40:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bga7rKdBuUC4dSGifyGXOoM3R2ft3UIT1E9u67d2HgztMYwKHXWzbQypMqq7gJBFPh8I92hn73qQCvMt6T+waSqeiC3bsfPAH23lar1ItoLSX+zWXfzGYsccOWpJGScTMxfi+oyLnqWpwHKrWbNkVXAFp+aZpRoxtWRaC9qRq3c3eD5BY28KqEzCZ38yF11q/vIBV8cWVlkk2Kk9B0Qesc4QHNLEiQ/+LedgDxYTfCxUs4lgZt/hgynf983Tfpj+5EeAEEjMELlMGHLBR8fvmR+UxTUi8dX1nXjTLsHaXls2Gerc6izuw85WZOZdayEiec+Ku1WYsfBQ/TVmL9OGeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+18kptvqW8YOujQG/t+23gU6KXYvgUZO2ISJht5MlY=;
 b=Poq7oal926l482MHMccMegi4hT6B7ZOsTyvNZq+7Wr5+k2xgA2kFiMRSiw6hM8/z5g6tbO4wzA2Ksn5zoPID3yBhSoW4yM1w8ylIPTraE4ggNd37vEBiNp7RDLT4Du46tw4KIFlF5CUVqLd/tWi7nSOWc+f3AIbB3DtZMDC0T1zLgtKyR6VOkkBTegXvcbAjGZMMlYxRtLoOhqmYkuMhPEQ/3RTCBGDdlqpQbw+gU4ywvHpR/QvMw5+6ygtrwmqR//URt0tJ+2bu5AEMsFFuzuOOVi6bPi2UY2zbJnN7/B7Ki/d3z8nXBevsRzsSlj4PuVgpSCTH254w/sUzrVwQWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+18kptvqW8YOujQG/t+23gU6KXYvgUZO2ISJht5MlY=;
 b=QjHNJUFSPfhiqPSTBm2bgrNG0h4oilxythnBvj4556z1hn9aNRL8pr3BIms/92rx4Hv3rBIKjCyYIKct0r5oAtx1dnnaEHqOR/I9ZdXTY0o/4g1YhWzzzooXnV/crghvIbCRGouEPH2l20W+63UoTbPFjKjowfCAcmA+LqC5HsQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3695.eurprd04.prod.outlook.com (52.134.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Fri, 28 Feb 2020 06:40:12 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2750.021; Fri, 28 Feb 2020
 06:40:12 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi2 - fix chacha20 data size error
Thread-Topic: [PATCH] crypto: caam/qi2 - fix chacha20 data size error
Thread-Index: AQHV7gHsrEsorQs4ikqBr5jkreFUxw==
Date:   Fri, 28 Feb 2020 06:40:12 +0000
Message-ID: <VI1PR0402MB34858272BF3305BFCBC21BFB98E80@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200221075201.5725-1-horia.geanta@nxp.com>
 <20200228004235.GB9163@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dff58d88-c25e-4416-e1d6-08d7bc190fd7
x-ms-traffictypediagnostic: VI1PR0402MB3695:|VI1PR0402MB3695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3695E14026E632CBB71CB19698E80@VI1PR0402MB3695.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(199004)(189003)(71200400001)(53546011)(6506007)(64756008)(316002)(66476007)(2906002)(81156014)(8676002)(44832011)(81166006)(66946007)(9686003)(66446008)(76116006)(91956017)(66556008)(478600001)(8936002)(7696005)(33656002)(52536014)(5660300002)(54906003)(6916009)(86362001)(26005)(4326008)(55016002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3695;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BzpjJ+pG4QtSVWIyNWO8USxXCkR1ApvzWmecgqY8jbySOBmPqzKINXfs1arnnz8iPBk1xvxxWivEcP08rkt+zOEs/zBvmSQ2ylz+Lun5vOMn71ZH+IyMywAwHMq2HxoIS0DA9HfEpHHHxW5Wz4EngkltN734WAVc0U8PcT9EhDNGuXbzCoIol5uhPf0Nk+K0nKo4w9pXjl+q5EuY5X2FOjJZ0M0RVRp/udRIlLa5+GdfT9ZOPKUw+bFMIzqzgxvjpPCJrIGFvgABSNBfZt5KO8zX7N3+vzD25oHBHqBKMZIE2/JVf0EyMzAY2nz6E9rRZLT1X5acMZdJBN+vWct3mf46cbuqFRc8jFXc8FbA/hLoiFKES4S5Sx9lZIP8zMtjdpOySiGLqxdmmqtdsCdQlQXoEo0W0tQBGsWzfusxc7mGRVzstPWmQ8CPi5RE3M8G
x-ms-exchange-antispam-messagedata: 0uGL1dpYBNAPcHbYOk97XleHTf09v5Drv/p643hldvr5hu2Ds4rbqM1VOYcYWOf722mqHUR//F0rb2snJoxVN4Z+pFEfvL8D1Dn46CEuJy7pDcp3AGyaTsFIqM4/fVUtO/6K2H6LOh1hxoe44KJlCA==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff58d88-c25e-4416-e1d6-08d7bc190fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 06:40:12.0216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z9wDSdD9mULDBV/6GTfm1nSp4Wks1WHAtU9STEoqSw6kQ0G4yw5G0Kln00HNve8g6DBVn8Qmh/wxXywKpp9RYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3695
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/28/2020 2:42 AM, Herbert Xu wrote:=0A=
> On Fri, Feb 21, 2020 at 09:52:01AM +0200, Horia Geant=E3 wrote:=0A=
>> HW generates a Data Size error for chacha20 requests that are not=0A=
>> a multiple of 64B, since algorithm state (AS) does not have=0A=
>> the FINAL bit set.=0A=
>>=0A=
>> Since updating req->iv (for chaining) is not required,=0A=
>> modify skcipher descriptors to set the FINAL bit for chacha20.=0A=
>>=0A=
>> [Note that for skcipher decryption we know that ctx1_iv_off is 0,=0A=
>> which allows for an optimization by not checking algorithm type,=0A=
>> since append_dec_op1() sets FINAL bit for all algorithms except AES.]=0A=
>>=0A=
>> Also drop the descriptor operations that save the IV.=0A=
>> However, in order to keep code logic simple, things like=0A=
>> S/G tables generation etc. are not touched.=0A=
>>=0A=
>> Cc: <stable@vger.kernel.org> # v5.3+=0A=
>> Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> ---=0A=
>>  drivers/crypto/caam/caamalg_desc.c | 14 ++++++++++----=0A=
>>  1 file changed, 10 insertions(+), 4 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/ca=
amalg_desc.c=0A=
>> index aa9ccca67045..372d3d4ed6c5 100644=0A=
>> --- a/drivers/crypto/caam/caamalg_desc.c=0A=
>> +++ b/drivers/crypto/caam/caamalg_desc.c=0A=
>> @@ -1379,6 +1379,8 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, =
struct alginfo *cdata,=0A=
>>  				const u32 ctx1_iv_off)=0A=
>>  {=0A=
>>  	u32 *key_jump_cmd;=0A=
>> +	bool is_chacha20 =3D ((cdata->algtype & OP_ALG_ALGSEL_MASK) =3D=3D=0A=
>> +			    OP_ALG_ALGSEL_CHACHA20);=0A=
>>  =0A=
>>  	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);=0A=
>>  	/* Skip if already shared */=0A=
>> @@ -1417,14 +1419,15 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc=
, struct alginfo *cdata,=0A=
>>  				      LDST_OFFSET_SHIFT));=0A=
>>  =0A=
>>  	/* Load operation */=0A=
>> -	append_operation(desc, cdata->algtype | OP_ALG_AS_INIT |=0A=
>> -			 OP_ALG_ENCRYPT);=0A=
>> +	if (is_chacha20)=0A=
>> +		options |=3D OP_ALG_AS_FINALIZE;=0A=
>> +	append_operation(desc, options);=0A=
> =0A=
> This patch doesn't compile.=0A=
> =0A=
Thanks for catching this.=0A=
Not sure how this slipped through, probably it happened due to=0A=
piling up too many *.patch files...=0A=
Will fix in v2.=0A=
=0A=
Horia=0A=
