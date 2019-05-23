Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423DBC282DE
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 08:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F4F204EC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 08:08:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="mGGvxHny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfEWIIy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 04:08:54 -0400
Received: from mail-eopbgr40054.outbound.protection.outlook.com ([40.107.4.54]:27552
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbfEWIIy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 04:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7TW7SrGZyFu1JjCdwNDBFdcM4EAzwrJk58onsTZD0g=;
 b=mGGvxHnyjYxFd3dxTFWM7DJADIkjyO8kXDeyA/TQ5oFH2VQcJFfZ0NKdUQQv7oQIhhQbb/tILqB/wrn22Mm6OHk98zqISllbBaHgqWk6Q1iNGygBEKj3dWE/lmpctuGI9cl5T51/6tOFy1k+1C/eVVVLB3NoM8hyADIrGA+Ovc0=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5150.eurprd04.prod.outlook.com (20.177.50.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Thu, 23 May 2019 08:08:50 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872%7]) with mapi id 15.20.1922.018; Thu, 23 May 2019
 08:08:50 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Topic: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Index: AQHVCxD1/1xcZwH7eE+osRH9ZRl26A==
Date:   Thu, 23 May 2019 08:08:50 +0000
Message-ID: <VI1PR04MB44452D9C82BB8835DDF759298C010@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
 <20190523061202.ic2vgimgzvvm6dzc@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf0ff7c2-6cf7-49e6-1d45-08d6df55e3b4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5150;
x-ms-traffictypediagnostic: VI1PR04MB5150:
x-microsoft-antispam-prvs: <VI1PR04MB515086496B62B865F41A2D5E8C010@VI1PR04MB5150.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(366004)(346002)(396003)(199004)(189003)(66066001)(52536014)(99286004)(8676002)(25786009)(55016002)(316002)(4744005)(478600001)(76116006)(229853002)(73956011)(7696005)(64756008)(66446008)(66476007)(66946007)(66556008)(33656002)(26005)(74316002)(76176011)(186003)(5660300002)(68736007)(6116002)(6916009)(3846002)(6506007)(102836004)(53546011)(7736002)(4326008)(6436002)(486006)(44832011)(2906002)(305945005)(71190400001)(6246003)(14454004)(71200400001)(53936002)(9686003)(81166006)(81156014)(476003)(86362001)(8936002)(54906003)(446003)(256004)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5150;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AZFoy4EQkloD8QRcbg92lvtDMtkHRhRg/iOCa9DeOqOmfVchKcIf4rnDuF4Vrew2lYGSNdrQKZoT7eDiOMojHFp/OGLPYzCz5PV0F7K9BFwdvtwtI4YTK4vPofAn6yBY1BWEapHZ2qLLbl+JG6pmf1/ucV8J3GDeZ7pwzIhitiO7tVgmAvSC2AHLYd5bbM9CB4upxo3dTKIBEP0Ct4x906YWxKBIdNSzWhTO52ZexeQfu97EFKqb5cRthHrsSfCzVpRc4zDIHAg7ZFyS3Aixlzmpoaxd9/z/AxLjFpcawmao4kkM2xf0Ae2TUfCGBk+/94/UjGUPAVEcI3lg1KXvgxBH+9axN6LvoydUmxpDyJ37TYBKFqc9HBpYMznCGjrHPIcPZWZbb1pWWjlvluCGjBj5kj1VGgmxnH8Bk3A0Csg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0ff7c2-6cf7-49e6-1d45-08d6df55e3b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 08:08:50.3430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5150
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/23/2019 9:12 AM, Herbert Xu wrote:=0A=
> On Wed, May 15, 2019 at 02:25:45PM +0300, Iuliana Prodan wrote:=0A=
>>=0A=
>> @@ -1058,6 +1105,14 @@ static int __init caam_pkc_init(void)=0A=
>>   		goto out_put_dev;=0A=
>>   	}=0A=
>>   =0A=
>> +	/* allocate zero buffer, used for padding input */=0A=
>> +	zero_buffer =3D kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_DMA |=0A=
>> +			      GFP_KERNEL);=0A=
>> +	if (!zero_buffer) {=0A=
>> +		err =3D -ENOMEM;=0A=
>> +		goto out_put_dev;=0A=
>> +	}=0A=
>> +=0A=
>>   	err =3D crypto_register_akcipher(&caam_rsa);=0A=
>>   	if (err)=0A=
>>   		dev_warn(ctrldev, "%s alg registration failed\n",=0A=
> =0A=
> This patch does not apply on top of the caam patch-series from Horia.=0A=
> You're also going to leak zero_buffer if crypto_register_akcipher=0A=
> fails.=0A=
> =0A=
> Cheers,=0A=
> =0A=
=0A=
I'll fix the conflicts and also the leak of zero_buffer if =0A=
crypto_register_akcipher fails and send a new version.=0A=
=0A=
Regards,=0A=
Iulia=0A=
