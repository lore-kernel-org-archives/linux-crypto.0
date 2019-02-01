Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A26C282DB
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 258C920B1F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="gYIevhah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfBAGvt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:51:49 -0500
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:50688
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbfBAGvt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YBOnkAhcpmQEQmZHtwpDoqZE0ITxDZUA2w2Ob7oGzk=;
 b=gYIevhahX3aqmF2qUbiS61JL+Wr0GDUJt/u+11wSJUg3mIHY4KUoFdqCmJtWJH5rQlRzpok/IBq42cnh1ldhQoYXrsz7y+Rt8hXIq/MiZx85hme2SCmLGSlgcHOpBKWDpzgIv4igQQIIsOdF4klU/pogoJRNp/dwgdulextkAV0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3599.eurprd04.prod.outlook.com (52.134.5.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.17; Fri, 1 Feb 2019 06:51:45 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1558.026; Fri, 1 Feb 2019
 06:51:45 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arun Pathak <arun.pathak@nxp.com>
Subject: Re: [PATCHv2] crypto: caam - fixed handling of sg list
Thread-Topic: [PATCHv2] crypto: caam - fixed handling of sg list
Thread-Index: AQHUufH8tCVCznNt00adQuBMFV2fbg==
Date:   Fri, 1 Feb 2019 06:51:45 +0000
Message-ID: <VI1PR0402MB348556C81076E5CF26E218BF98920@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190131070556.44832-1-pankaj.gupta@nxp.com>
 <20190201053812.71275-1-pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3599;6:L0J4gHxSet5ti1knb7AHpIsL9qIlDh2QvY4mkwBNt+Lam64RGX/Xp2eubitBBgO/nMEq2w6XLSdJ6Gt6dcFp17vIrRJjd/anp0lN/LXfgx8Mk2cxWkPEOIcDhf6ryiDXSlnccqUP7AX2jbILpwiXk4mFO+JDDgdN6QrjWm/KejAogNG7R31fvxXOksfumwGooGyKqemIckC5iK7NohCmz0Hs0zCxMNmT6mf19gsCoS7SRwkqZ5j2Lk/ZMOxyYah6x1fyBBHxPJYEIPJJlKBu9qIiMkUrljKc6kTkPk8VNGTOSCQlFPl7Kz6+gp4oiSxKVuahcJeh3pueQLbQK9XzJ2CXjzosf7BLySO9EsBsmKPmu1e71chn58DR1tAYwl82123TrHLm5+DgChD0FUXWNs3CMyA9whM4qjTi4RIMKN79Sry8BI8kVip8ge0Oqd6jt8tiSGi56xBOdKJ8OEQ+ag==;5:jzfbWpG719nz7LT8xjYOz2iibb8EJTyqDGAG2kUFCVDfhGjvdiLSri++WYq98pA2SqjTMVwxdsPAJ6g0e4z4X6siKV5Lrqo+oVZEKyWCbmKYXOZxm8teLhsHyE/tSFpYlxnI6fCE8UAnWh3c37kUw7E7HqKifjJBOp6X/VKJgABkyUzr5LgQlotln8ova45qsK+WazzrY2/1GewUizlayA==;7:gbu8l0XnV66gg3jlSysP5DGuT7BkqDfaMeSRMePTRoRKVUJEVW5bNKYSvcduxgDWekr1m29U7jobTYvkTWCUGM5mhcEWO93bUKkIczz8jsePXKB9F3kJPnZU6WucdbTqA5VLF+uOfP4oW6XNDDUkQg==
x-ms-office365-filtering-correlation-id: d1dcd066-9e46-4e6b-818c-08d68811bb64
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3599;
x-ms-traffictypediagnostic: VI1PR0402MB3599:
x-microsoft-antispam-prvs: <VI1PR0402MB35994E0576D0822F72FDB2C098920@VI1PR0402MB3599.eurprd04.prod.outlook.com>
x-forefront-prvs: 09352FD734
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(366004)(136003)(199004)(189003)(6246003)(4326008)(53546011)(44832011)(25786009)(186003)(14454004)(66066001)(26005)(446003)(6506007)(102836004)(486006)(53936002)(97736004)(99286004)(54906003)(110136005)(476003)(76176011)(7696005)(316002)(4744005)(9686003)(68736007)(55016002)(229853002)(81166006)(8676002)(81156014)(8936002)(3846002)(106356001)(71190400001)(71200400001)(6116002)(105586002)(256004)(478600001)(33656002)(305945005)(86362001)(74316002)(7736002)(2906002)(2501003)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3599;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cZ1r2qOrwo1DA1y/WFh9BECBR5sYMdWUdiC7alMOz0IfFKM+ils+BXPDIhIyzj/8rW0tM/5MPn6rS/8I5tF5JNI7XpfCg7i6rYGjSVWmgKQJFWMHT16KHyqlfZSnUKaq5YVzIkQcdJEGxNl+d/MRrpwuoJkEtMjZ6eMPbuQkS+PkVUChC7tzHW/Qw81FmM8dz4aydKDrfhIrCBbpzHxT+870ZrKjc2qvEylB5Z6/QkuYsxeC5G4TYWZhDcqmxpsuV6IEZs7jWWEIpaay3b5Se08PjI92HtsuxGDOILs7LqVM7Zy41IyyFlThVBjE20B9o1WCHqtyOvBufN2JHQ4dFCJdXlcrw8j3+JTXpjUktiZS+HFOWLuoC2cFm8ZnF8/KLaKpZD3qq28/nILqz29U+g4yxFnU68DLQh5NvwGja/s=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1dcd066-9e46-4e6b-818c-08d68811bb64
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2019 06:51:45.7820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3599
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/1/2019 7:50 AM, Pankaj Gupta wrote:=0A=
> when the source sg contains more than 1 fragment and=0A=
> destination sg contains 1 fragment, the caam driver=0A=
> mishandle the buffers to be sent to caam.=0A=
> =0A=
> Fixes: f2147b88b2b1 ("crypto: caam - Convert GCM to new AEAD interface")=
=0A=
> Cc: <stable@vger.kernel.org> # 4.2+=0A=
> Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>=0A=
> Signed-off-by: Arun Pathak <arun.pathak@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
