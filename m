Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012F1C4740C
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7F8A218DE
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kqtf4Tz/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfIIN0h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 09:26:37 -0400
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:54985
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729836AbfIIN0h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 09:26:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVuqK4zHQTB3LM9HdQawKq9P4IAUYyCFs9xsatxd5onRfhczRGrV9bkhP34BoE/njIzeoVe6z9at0GEVTJqvIuShRZkU+aloOFJhXecaKikgeX7TrCO2FMjnAYrMZSgi5G7rc8bWeMk8IPhizaSm4KfIWbDXb8EguCIyE3CkSk5PqMomrRUidYc/Xff8/krgNJyP9klyv662chZQ2DRrr1ZzD9fdvEfbF+bP4clh/XcktNXW2KdFHSTQvS6y946gi8ALDw4e7EV4sJYmGB0HMcAHTyxkNJUJJ+oTvWdDULzrw3rMkKTrBBUnmJwouWZMHgO4M7eY+vOUn89+HBce8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4AdrKGMZgdk+mCYUSopBt17mOe/HZiNK7JQ+NC/5j4=;
 b=IJuLreafy909wbLGb40vWZOzHxZKNkt8tkX46UP1LdQ0otCCBsi9Z7y2LNRAc8m+m7pTInbX9v0fr5D4ywBNdNe8VnO/eND00Fx8DhCha4xHO+a6HG2sMHiR7+macczy4LY5YlkVZ5lirC/e4WSpy0R+hfVgjNu6864L72YMrfjf6Ruu/06iFz6kAnnT3UYGSfBxpiF0HyF1tmvA2xmFp8LzxA/tALTtz+t/EQ9gdOo5aW6iDQXgzh3tY6odI2Y14Lni9thePZRAfqNNfGp5GWgDwLJskb+Y9MZXEj5TwPCAoEldvs9UKqaFUutFYGkP83BskWkju7apJ0/0xJOUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4AdrKGMZgdk+mCYUSopBt17mOe/HZiNK7JQ+NC/5j4=;
 b=kqtf4Tz/BQwSspixzwUDcfLk+fDx/5fKyV5C8sEpNcv7b64bOigkkStWL6n7YJuGG1mLSroIyb+AKcQznUVCiocNAykh1V5jqdg+FRGZu2LN2WtbfRg1N0jQmYKAoC9Zp78euY1e5mxo9uAh0RG1m39AMtWFruMQg9rMC/qWyCo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2797.eurprd04.prod.outlook.com (10.172.255.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 13:26:31 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:26:31 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] CAAM bugfixes, small improvements
Thread-Topic: [PATCH 00/12] CAAM bugfixes, small improvements
Thread-Index: AQHVYsltKfzOWzulykSXuTfZEkbAhg==
Date:   Mon, 9 Sep 2019 13:26:31 +0000
Message-ID: <VI1PR0402MB3485F92981F1CC1891FBAB1D98B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190909075308.GC21364@gondor.apana.org.au>
 <VI1PR0402MB3485DC32B1789CB76C16F23798B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190909125213.GA8982@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af883484-436d-4926-ec23-08d735295415
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2797;
x-ms-traffictypediagnostic: VI1PR0402MB2797:|VI1PR0402MB2797:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2797DB4EED2B410362923B0198B70@VI1PR0402MB2797.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(199004)(189003)(476003)(86362001)(4744005)(99286004)(6916009)(478600001)(316002)(7696005)(33656002)(14454004)(54906003)(229853002)(6436002)(8676002)(81156014)(81166006)(66066001)(446003)(2906002)(8936002)(6116002)(55016002)(76176011)(44832011)(91956017)(6246003)(76116006)(25786009)(486006)(9686003)(52536014)(186003)(74316002)(3846002)(305945005)(53546011)(6506007)(102836004)(26005)(5660300002)(71200400001)(71190400001)(64756008)(66446008)(66556008)(66476007)(7736002)(66946007)(256004)(4326008)(53936002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2797;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6mFprxwKGnlCZaD/ufXYiWAJ4FmEnpn85bASy0kHOT08aWp4GR0f8YmMBD2Dv/1jfMuSI9bPCsbj/GdKd/3NOw7gKqU/GoIYuG9bOCOS5QG7C+R69TsHBnJS6hPQthCApUIPRqAI3wdo6A8hUfwfM+UXc2ub4XpCG/Z5ndW9AYeX0TwaDqPdli5Q+yBwAHzDiHsCQRztgMZfQw5BXjppFvGFiMsWqcfOullP7KtOSrtZst+JlosA82aKABhwuLMYxNHooCqvXLR2YHWaVpTJ5XHoH7ye2Zt8w82YyPcmzXENXlsReKuvcDyFxYMAZlN33lVh9Ox2zRMIWQ2YAzL+E3gdVYF8u20Y79Ewf3sln1SVBT01kHhXzdUMB7F0NCygqEdtvqsNES2F8ZRiK8rpCjEV7maMtavZ4V/0zbhVDS4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af883484-436d-4926-ec23-08d735295415
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:26:31.5879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hjg15gt/K7obD4AzVjPXJBw48lPFrBJOMK3oQlJFYw8AVfltAG0qz7fu2Hf2FyuC5zMm1w6ZqvjCIhjtMKY0+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/9/2019 3:52 PM, Herbert Xu wrote:=0A=
> On Mon, Sep 09, 2019 at 12:07:17PM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> Why all?=0A=
>> I've ack-ed only 1 and 4.=0A=
>>=0A=
>> Besides this, patches 11 and/or 12 break the functionality,=0A=
>> i.e. driver gets stuck during crypto self-tests.=0A=
> =0A=
> Should I back out 5-12 or everything but patch 1?=0A=
> =0A=
> Patch 4 can't be applied without 2/3.=0A=
> =0A=
Let's go with patches 1-4, and revert 5-12.=0A=
=0A=
Thanks,=0A=
Horia=0A=
