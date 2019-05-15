Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D17C04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C2E92084E
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="blEEux41"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfEONfU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 09:35:20 -0400
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:63207
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726659AbfEONfU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 09:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLsTI+j+O7oH1BdJEYE2sbG2Nf4tUiqfHR/gPpdO61U=;
 b=blEEux41HDQ7Hdr7Jb/RUEZtMjiTeQQfy7/NYyLW2Ph1WvNulqe2R4WuFATM+6iRosE7rKO94/dSPuiocjsNgQzjBtQZQzrYGL0JYfZcg4x1unF2uSnEG5V0TDVd65fSUFychMXkMsibgX6iQ68xwWafhzVlSY/cotETLj1Kgrw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3806.eurprd04.prod.outlook.com (52.134.16.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 13:35:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 13:35:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
CC:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: ctr(aes) broken in CAAM driver
Thread-Topic: ctr(aes) broken in CAAM driver
Thread-Index: AQHVCx8ztYDI45kiAkWqyLHDh7QIDQ==
Date:   Wed, 15 May 2019 13:35:16 +0000
Message-ID: <VI1PR0402MB3485ED478A2A3E0087E81F7C98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190515130746.cvhkxxffrmmynfq3@pengutronix.de>
 <CAOMZO5CJvcipPNY6TXnwwET2fc=zaP3Dj3HPT-zfZpzfqHkeHQ@mail.gmail.com>
 <20190515132225.oczgouglycuhqo4l@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b6e17b7-3c49-4e27-53eb-08d6d93a2ad2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3806;
x-ms-traffictypediagnostic: VI1PR0402MB3806:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB380633FF30A315EF84B371B998090@VI1PR0402MB3806.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(8936002)(316002)(81156014)(8676002)(81166006)(4326008)(25786009)(86362001)(52536014)(44832011)(446003)(476003)(55016002)(9686003)(6306002)(966005)(478600001)(2906002)(486006)(14454004)(66066001)(3846002)(6116002)(14444005)(256004)(5660300002)(26005)(71200400001)(54906003)(71190400001)(110136005)(68736007)(229853002)(186003)(305945005)(7736002)(6506007)(76176011)(7696005)(53546011)(102836004)(6246003)(99286004)(76116006)(73956011)(66946007)(66476007)(66556008)(64756008)(33656002)(66446008)(53936002)(74316002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3806;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IVxWZfhVR5/QD9bX6CPSqaEzhRc4S6cV+kEbza4BAd7lpCtMlPtglHKMIQzUkhZt0tCO8o9CkVFrPfNXXcOnCC17BCXSFfCEbYmd23ttDnDlyFAo7sKW3rCH5k7NpYffPf0erd7b0iXO8XA/5kSbkNgA1AdNiRpDdMKyz4PQ6X0At5Z7kqpYaf/RjZhBZzZofAW6/ENtNllryXKpV1m44KS5ACKfAqLXMnGfcoXqiv7EM4HEjDhNVcUB4iFfX98kwbhiyKh3M+VSG2/B5LtFFZ6l5oczbDkLhp9YlNB6bTyNxMMG0X6KWywx0PzUO1jpOqAspKes/7muOjF2Xt7TFr3CUjWUKR4u3wZ1QMKO82d4D3QO0XcK07fZm2eF46CULZAlB9+zyYFoaXYh59MSA6xAewlPN+lvlJ+kgE6MY3E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b6e17b7-3c49-4e27-53eb-08d6d93a2ad2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 13:35:16.7850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3806
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/15/2019 4:22 PM, Sascha Hauer wrote:=0A=
> Hi Fabio,=0A=
> =0A=
> On Wed, May 15, 2019 at 10:17:19AM -0300, Fabio Estevam wrote:=0A=
>> Hi Sascha,=0A=
>>=0A=
>> On Wed, May 15, 2019 at 10:09 AM Sascha Hauer <s.hauer@pengutronix.de> w=
rote:=0A=
>>>=0A=
>>> Hi,=0A=
>>>=0A=
>>> ctr(aes) is broken in current kernel (v5.1+). It may have been broken=
=0A=
>>> for longer, but the crypto tests now check for a correct output IV. The=
=0A=
>>> testmgr answers with:=0A=
>>>=0A=
>>> alg: skcipher: ctr-aes-caam encryption test failed (wrong output IV) on=
 test vector 0, cfg=3D"in-place"=0A=
>>>=0A=
>>> output IV is this, which is the last 16 bytes of the encrypted message:=
=0A=
>>> 00000000: 1e 03 1d da 2f be 03 d1 79 21 70 a0 f3 00 9c ee=0A=
>>>=0A=
>>> It should look like this instead, which is input IV + 4:=0A=
>>> 00000000: f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd ff 03=0A=
>>>=0A=
>>> I have no idea how to fix this as I don't know how to get the output IV=
=0A=
>>> back from the CAAM. Any ideas?=0A=
>>=0A=
>> Is this problem similar to this one?=0A=
>> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg37512.html=
=0A=
> =0A=
> Different algo, different hardware, but yes, it seems to be the same=0A=
> type of failure.=0A=
> =0A=
For talitos, the problem is the lack of IV update.=0A=
=0A=
For caam, the problem is incorrect IV update (output IV is equal to last=0A=
ciphertext block, which is correect for cbc, but not for ctr mode).=0A=
=0A=
I am working at a fix, but it takes longer since I would like to program th=
e=0A=
accelerator to the save the IV (and not do counter increment in SW, which=
=0A=
created problems for many other implementations).=0A=
=0A=
Regards,=0A=
Horia=0A=
