Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A673BC49ED9
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 18:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CFB72084D
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 18:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="wcCkACYa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfIJS6X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 14:58:23 -0400
Received: from mail-eopbgr690041.outbound.protection.outlook.com ([40.107.69.41]:23211
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbfIJS6X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 14:58:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq1G0UYVfpSXDChZtXOHtpKM8DWhPGTTNXHQ3LEoAB43hlR5ZdMRJhYRSsJegM3boh7J73gspYrvy6xZHq/h1rzCcGjwCk21Dhb6DlgaRpWc7YnvArPlnFX3UxJyR4qg2XSHQp5FPnZX2NsW1WDGDoqR995+Prpj0d09QyzoAlH6ZiwMz1A1TiXSXdN5Y5MSPnJXOyl8hVFbMb+fDvSnVMWvhnxgoJMkKyzvBFn4mi/YZDiSqtt+OYvhX50iHwrc4h8RbQXUnr8KDcG0z3rX3LLJ1QnWkiCE+jmx2YNdnyObEZFhHbZfdeM+KWbN1gk7pgGL8ec8vE4Nph9/ZBZTQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKWKpwhuHqwZYhaTmldPiNpQxxMEdEZ2CxMxlPH+cGI=;
 b=NVQrDST6cPambY1qlfhZXkisKLMJoIz/6PLq1/wEGvg2xx18u34wZ95PdfWDNinnP17YMnIR/303mVHGv+nVTF+bPJdIKbvUXdBtSC2z14HboA5v6C+XKk+WfsnFeXVIAGB3xM7qtbWNZjsLTUmssl+xbRZcAZaAB7eDm4HnB05hzh6iErUmozfqImCsjPUqdE6oqYiSRet8T/jDxQ/1hVgqJrq14z6FHbJzWH1/5N9op8GzM1RnYrdrJ5A9GV6Spnydq/N967bjvSn8io7MDYy6dgJHH6BoeG2/dN/4No5Ikko+OEuVEmHIXelVPLSAygGRDnhAu1wjaaBFxlBAGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKWKpwhuHqwZYhaTmldPiNpQxxMEdEZ2CxMxlPH+cGI=;
 b=wcCkACYav5K9FtUVE3lAkysl6wlF5ipqF7qw+JjY/dltAapg596+Q5NsUw6TVAvvl9jsqNrqlLS9uyjRu8jF3tiNI8eO68P96FLsUwkarMsz3+vJiN8O32jnti4FNoFGzr8gg9EzI/VQkCSZuD4Mu/XVh3nLOgp2gqp7gAe1J2o=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2366.namprd20.prod.outlook.com (20.179.146.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 18:58:19 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 18:58:19 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 1/2] crypto: inside-secure - Added support for the
 CHACHA20 skcipher
Thread-Topic: [PATCH 1/2] crypto: inside-secure - Added support for the
 CHACHA20 skcipher
Thread-Index: AQHVZ+4odBpV2XL9NUuE4Wxeg5/uy6clK6gAgAAWOSA=
Date:   Tue, 10 Sep 2019 18:58:18 +0000
Message-ID: <MN2PR20MB297383846FB390299EFEA0C3CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190910173246.GA14055@kwain>
In-Reply-To: <20190910173246.GA14055@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7852a2f9-51ae-4f85-82fb-08d73620d860
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2366;
x-ms-traffictypediagnostic: MN2PR20MB2366:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2366E57278CEEDB1595960D4CAB60@MN2PR20MB2366.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39850400004)(346002)(136003)(376002)(13464003)(199004)(189003)(9686003)(6246003)(476003)(53936002)(4326008)(86362001)(99286004)(478600001)(966005)(316002)(7696005)(15974865002)(14454004)(110136005)(54906003)(229853002)(6436002)(8936002)(446003)(2906002)(66066001)(6116002)(81166006)(55016002)(8676002)(76176011)(6306002)(33656002)(11346002)(76116006)(25786009)(486006)(305945005)(66556008)(66476007)(3846002)(102836004)(6506007)(74316002)(64756008)(66446008)(53546011)(26005)(5660300002)(71200400001)(71190400001)(186003)(52536014)(81156014)(256004)(7736002)(66946007)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2366;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NoCnRL3MEYI2xhYP6u7nP9w4BAIlULMxiOQbY4r4oK7HviwGYDlTU96QkATR+epzWJJeLFMEFCKIyd45KrbQR7X+BN1GOJyewtqsVYqD6q2NZOQxRB/v+zyEtt0efq7XbnkIQU/RkDglOA/PztYxByKcZzaanz8zwO4dxhk8a+gAynzDusWf0LtjduiYwl46d2WnH+pR07xu4pG1wG8hltVSupVW8Tflpw3W5p1WNX/UiO3tc5+uxBCzrSL1zSrdDTuvSwk/L0zuzzoY3NNjiisXhs642CET2sx7mQj2t7H9gNEVZWWSrdNiCLfu/mx8deVUCEkhrA+Rhw50G3TueOcyIA6WNyFr0nqkdTZ9Bj3R2sVLZP9tDIoCkVW0ybT1dY+sShW0ffC8Og7mdOZMyjDrBkgGJCRYbTIC2FuSY48=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7852a2f9-51ae-4f85-82fb-08d73620d860
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 18:58:18.9443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PNTABeH7CVVUlIXJke3MpSwCctTdWDxUOEdx9wHQlSNUCJTs27Jtk+HMCsx/yizZCGuA3ddTGtplcaDaAzr7iMSZZywJItk8GjAPZXmafks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2366
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Tuesday, September 10, 2019 7:33 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 1/2] crypto: inside-secure - Added support for the CH=
ACHA20 skcipher
>=20
> Hi Pascal,
>=20
> On Tue, Sep 10, 2019 at 04:38:12PM +0200, Pascal van Leeuwen wrote:
> >
> > @@ -112,7 +123,7 @@ static void safexcel_cipher_token(struct safexcel_c=
ipher_ctx *ctx, u8
> *iv,
> >  			block_sz =3D DES3_EDE_BLOCK_SIZE;
> >  			cdesc->control_data.options |=3D EIP197_OPTION_2_TOKEN_IV_CMD;
> >  			break;
> > -		case SAFEXCEL_AES:
> > +		default: /* case SAFEXCEL_AES */
>=20
> Can't you keep an explicit case here?
>=20
If I do that, the compiler will complain about SAFEXCEL_CHACHA20 not
being covered. And Chacha20 won't even make it this far, so it doesn't
make much sense to add that to the switch.

I suppose an explicit case plus an empty default would be an alternative?
But I figured the comment should suffice to remind anyone working on that
switch statement what it should really do. I'm fine with either approach.

> >  			block_sz =3D AES_BLOCK_SIZE;
> >  			cdesc->control_data.options |=3D EIP197_OPTION_4_TOKEN_IV_CMD;
> >  			break;
>=20
> Thanks,
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
