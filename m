Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738CDC46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B41F2184C
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="WVsiINsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfGEPvB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 11:51:01 -0400
Received: from mail-eopbgr800052.outbound.protection.outlook.com ([40.107.80.52]:12944
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728168AbfGEPvB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 11:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kjTujl2B5HoyYXlMgSD999DfWxmdZm/5RQgZ/M23W0=;
 b=WVsiINskanoxDtSkaamlw0sBiAahcCXEIcAQcU1evxwEOOONVBt+UfWdeDqQF82vGr1IMOQHL82f1V3R8nYKv9mtBzCbcwvQUQvijFPanHHvB7DID66dTYpHpnpKhPa4kqqufpISaqvpe8tL2HOLpcc1zUg4dmVF2UHH7HLuOhM=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2399.namprd20.prod.outlook.com (20.179.145.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Fri, 5 Jul 2019 15:50:59 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 15:50:59 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>
Subject: FW: skcipher and aead API question
Thread-Topic: skcipher and aead API question
Thread-Index: AdUzFZSC+g/TbhjQSoOcPg+7Aq6e8gAG+c8AAANZNuwAAnSTLgAAFjEAAAAS0kA=
Date:   Fri, 5 Jul 2019 15:50:58 +0000
Message-ID: <MN2PR20MB2973FBDEDAAB2EFF244F3877CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <BY5PR20MB296261AC5E07B6E7E2B7E6A9CAF50@BY5PR20MB2962.namprd20.prod.outlook.com>
 <20190705125930.7idte7awvhixvsnc@gondor.apana.org.au>
 <MN2PR20MB29733314C9338A20E587AF3ACAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190705143516.s2ynxaej4qzfj4md@gondor.apana.org.au>
 <MN2PR20MB2973C66C8DE5380B91F03ACECAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190705154530.4g26hjwsyzymvghg@gondor.apana.org.au> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18bfa8e9-d0bb-4eef-a39d-08d70160930b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2399;
x-ms-traffictypediagnostic: MN2PR20MB2399:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB23997A8C7528B13CF6DE7826CAF50@MN2PR20MB2399.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(136003)(376002)(39850400004)(189003)(199004)(66446008)(4744005)(478600001)(64756008)(73956011)(256004)(6436002)(66476007)(8936002)(102836004)(4326008)(66946007)(33656002)(66066001)(66556008)(5660300002)(229853002)(55016002)(6506007)(9686003)(2473003)(316002)(6306002)(966005)(2906002)(53936002)(2501003)(5640700003)(99286004)(6916009)(14454004)(74316002)(76176011)(86362001)(68736007)(6116002)(71190400001)(52536014)(25786009)(305945005)(2351001)(7736002)(71200400001)(8676002)(476003)(486006)(186003)(81156014)(81166006)(446003)(76116006)(15974865002)(26005)(3846002)(7696005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2399;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AJ7Ds2qdGfdscTuDdOauuKd/yMDt1aud26wVUBM6T8YJ/tLy+JH1cjft7v5V1LjPLIptZ85RB+SvDDF+NuqWbe6BOL6++GcSgU0G9x6jKapIXTSnj11cJWJHoLhV2EYLXcT3aHVDanQRPu3ORC1KGuAViGHimNZs19NMi6CYF46EXvO8o7LBOFOa1F0ogSm6JlIVol2CnY77aiY9KBHwiX8PUOfpD5qWonmAUILbl+EYN61WO96BQ07wxLXx/YDGIhf0jKyrMy+s+WEOOcKmT5Lt4pzHepkKPo0rmvQK5ZXUdUjV6jGDC950UmuDJcI2Da0veRh5oF5ZKSDsMG3d7HibBwwDZZOLaq/68q48Lc+avfE9SSuPqbiqw3yhG2HOyPOeSJIitnXvsL+HvFJwJpKHGGWhwh9SoGMCsC8d5Lg=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18bfa8e9-d0bb-4eef-a39d-08d70160930b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 15:50:58.9707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2399
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+mailing list +davem)

> > > You can just read tfm->authsize as that's what the default
> > > setauthsize function will set.
> > >
> > I was referring to the case where it actually needed to be configurable=
.
>=20
> No that's what I meant.  Look at the generic authenc template.
> It supports truncation but doesn't actually provide a setauthsize
> function.
>=20
I get it. The callback is only needed to do the checking if you don't suppo=
rt
the full range. Otherwise the value is already conveniently stored for you =
:-)

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
