Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4AFC49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 19:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0CA3206A5
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 19:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Kn8OlEHH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfIKTeh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 15:34:37 -0400
Received: from mail-eopbgr740087.outbound.protection.outlook.com ([40.107.74.87]:4608
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728285AbfIKTeh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 15:34:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPH1qOhVrxCbVttSRSkByMJOrqoVJR778X61oWoluwH2rTplArVXe5TodRr0SiA4G7WMHANAhtyT3EQHixqEj3vVQRSVYevjRMDMLNM1o8c5Zs+oc6Qu4CPoKefRGhXE/WzBLouPvluTmErCZo6d7hVT7KB7mOk6oJVkr24+ozLH8YCdB1OiZB6xWmTr+0GuS3scPEc52qrjcP2FM1PGN7aZoRkJ3T8IYygnFF6z5TG17/MtWVNK9rmLXbcTgs/8pIZlEO27mYchqHR+AMjAc/f/xcqx9W2Z9hZa5KSNzb6v/ezYOiQJVRpm7ath/5fLj93YTehJKF8PdVWpH+PPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSQKJwIX51CfCnQ3A+M0YKAGpoxnfAiAzxAQJbRn9HU=;
 b=gSKjRT59Vq64eIzFDMhqMhat//QkEcj0zpWlGLG/Q4xLrhA+HkxWdgve+rWUyfN7P5GvwgfrbNH9mYAWJRRfqAE701r0apeUa9PbjbmhJHZrRHAY4s8XWHOs78n8ukPJKuGuQ8fX+olfsg1E+MHE/MTpujvgwLnIKO4GINRzuWCDfQsLdmHFz0aST9X7a2xgSYAQsHn6/X7O9EFILANVePZGyklQpl8YYfaKlfsdvRUU8wJVGEiD0NvgKfBz69f9zvMFiFfeG6O0qyYNZf6inJ1k6cRN+bdlidNt08gG0koQGc0Ob1G+SA1nsLeERJOuxndLvEBMHIZal1ifLS2nBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSQKJwIX51CfCnQ3A+M0YKAGpoxnfAiAzxAQJbRn9HU=;
 b=Kn8OlEHHa0W1UdGkId8XrzdMNcYmfwxPKQVIjDrDW47KTCuAXvUxwpp4Nv4YsviwsZdPrSSqMP5y+/p8I+mFf3BbuWfv+NO2otTs43ymqgbWmIKUII0BIU31cb8Nq1tO2IfQkfLDzjoLhdQ/ykFniLZtKxfvvgJfNd/6fCRW4d8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2367.namprd20.prod.outlook.com (20.179.147.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Wed, 11 Sep 2019 19:34:31 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.022; Wed, 11 Sep 2019
 19:34:31 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4)
 & cfb(sm4) skciphers
Thread-Topic: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4)
 & cfb(sm4) skciphers
Thread-Index: AQHVaJXTG1IIcgClVUajVRoPFqk+JKcmpF4AgAA2P7A=
Date:   Wed, 11 Sep 2019 19:34:31 +0000
Message-ID: <MN2PR20MB29738D497EDEEC9FBBC939F1CAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568198304-8101-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911160545.GA210122@gmail.com>
In-Reply-To: <20190911160545.GA210122@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb742163-e2cc-4ecb-19d1-08d736ef1184
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2367;
x-ms-traffictypediagnostic: MN2PR20MB2367:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB23676632B37B76ABB408A63CCAB10@MN2PR20MB2367.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39850400004)(396003)(136003)(346002)(376002)(366004)(199004)(189003)(13464003)(64756008)(476003)(486006)(5660300002)(4326008)(55016002)(52536014)(478600001)(7736002)(66446008)(76116006)(14454004)(305945005)(66946007)(2906002)(6116002)(3846002)(66556008)(8676002)(8936002)(33656002)(81166006)(81156014)(110136005)(86362001)(99286004)(54906003)(66066001)(229853002)(53936002)(15974865002)(316002)(66476007)(6506007)(53546011)(186003)(6436002)(26005)(76176011)(446003)(256004)(71190400001)(9686003)(102836004)(71200400001)(11346002)(7696005)(74316002)(6246003)(25786009)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2367;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: l8ipTfEyv14pc39IamawOLvLDVlKTcFpx6mxV7CFOv4wXAumGCvJgA2x8FiIng1XAh6bzMXSWiQboxbSD/f8gIsUCuE6mGnsmAfcuskYFHbs6wfUlJLn0WX6gieZhXJHgF/BeXaJSXfZcJB5n9cOUPIzxC/RJSpoMyAW2Aw+ruczuPD8mav8FKszcQXNj7h3KHcd1civia3ZQkxGSp43frNzSH6ipUqG5RpNUZfSBdBQlp0hGywjN+MX+lM02XyHFoqqMHao+spUO9nwQbBW9PghI6tzSDUA2rOxYnxiJR/CkpR6ChodvqYd4d/KgM/htDeHUqmxkXrn8SbWPYapBNiUBTBHqynG9iivXoxeujrm0/vKYTJMkCKmuu91G7EL+xS15/44+X6tGZPe20gpoX4m/GIIkSjvk9Mml7MBV68=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb742163-e2cc-4ecb-19d1-08d736ef1184
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 19:34:31.1530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cI6ro4DUdQ2fNtBvJhSZHPR4/v5SmsR+yuSuRbkfcK09dhkVkGb11Hvs3ijRuZcu5YE2o+NuoilTenn54xb9EPxU1xH+JpHExjKP/30VgAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2367
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Wednesday, September 11, 2019 6:06 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(=
sm4) & cfb(sm4)
> skciphers
>=20
> On Wed, Sep 11, 2019 at 12:38:21PM +0200, Pascal van Leeuwen wrote:
> > Added testvectors for the ofb(sm4) and cfb(sm4) skcipher algorithms
> >
>=20
> What is the use case for these algorithms?  Who/what is going to use them=
?
>=20
> - Eric
>
SM4 is a Chinese replacement for 128 bit AES, which is mandatory to be used=
 for many
Chinese use cases. So they would use these whereever you would normally use=
 ofb(aes)
or cfb(aes). Frankly, I'm not aware of any practicle use cases for these fe=
edback
modes, but we've been supporting them for decades and apparently the Crypto=
 API
supports them for AES as well. So they must be useful for something ...

The obvious advantage over CBC mode was that they only require the encrypt =
part of
the cipher, but that holds for the (newer) CTR mode as well. So, my guess w=
ould be
some legacy uses cases from before the time CTR mode and AEAD's became popu=
lar.

Maybe someone remembers why these were added for AES in the first place?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

