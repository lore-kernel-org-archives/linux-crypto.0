Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1996CC282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 10:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C45042081C
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 10:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="WmyRzGCW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfEWKSS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 06:18:18 -0400
Received: from mail-eopbgr50079.outbound.protection.outlook.com ([40.107.5.79]:23862
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbfEWKSS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 06:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Yp/Hy/sDeI2eRvPa+UnJf1WoyGfZ+JmYgnojpOgIvM=;
 b=WmyRzGCWsX2ku7rMuM8zc939fJ/tD0aI9vUXt9++c6VEH2SmmmHeha1wKYJ7+NTCPFR6i5oMT7806HeqtACHnSgtDZIffQBzTcpO4Xm+uXPx+7lFcEi/2CK7XqFGXMGsCTbjWOenHVuXrzBLUPsDH6MhZIgVjWchG3aDjIebiP0=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3587.eurprd04.prod.outlook.com (52.133.51.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 23 May 2019 10:18:15 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::1cc6:b168:7419:aa48]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::1cc6:b168:7419:aa48%6]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 10:18:15 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH v2 0/4] crypto: CAAM: Print debug messages at debug level
Thread-Topic: [PATCH v2 0/4] crypto: CAAM: Print debug messages at debug level
Thread-Index: AQHVEUSc2of3cAqKSUGNhSCWHYD5tQ==
Date:   Thu, 23 May 2019 10:18:15 +0000
Message-ID: <AM0PR0402MB3476985FE87BA5FD5BC8C03798010@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <20190523085030.4969-1-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e39d38a9-5f55-4322-c160-08d6df67f7f2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR0402MB3587;
x-ms-traffictypediagnostic: AM0PR0402MB3587:
x-microsoft-antispam-prvs: <AM0PR0402MB3587C5BD0E6373984414B4EE98010@AM0PR0402MB3587.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(39860400002)(376002)(136003)(189003)(199004)(76116006)(33656002)(66066001)(3846002)(6246003)(6116002)(2501003)(4744005)(26005)(229853002)(2906002)(14454004)(25786009)(9686003)(4326008)(5660300002)(44832011)(256004)(55016002)(6436002)(74316002)(305945005)(8936002)(478600001)(71200400001)(71190400001)(81166006)(446003)(64756008)(66946007)(7736002)(66476007)(66556008)(52536014)(81156014)(66446008)(53546011)(53936002)(8676002)(316002)(86362001)(68736007)(476003)(486006)(7696005)(99286004)(76176011)(102836004)(6506007)(110136005)(15650500001)(73956011)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3587;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5BLy/Z3+IofPDXAKTDBCch/Xpdz17GD9u3FwEq0sMzp1yipqKwiRWHg3++EIw54brzp/jwHTzPQ8OH1pNPqMe7gOzD/HD0Mxa5pbDpbJlnNSMyxlR2Wu5ofLnWr+mnKn9LgEPpVyLna2pHAlXqwuE39fZCKCpTp1g2xV1OoNxVyU+GJVwKRwBIFgH0BasRaIJhKwYHVxWornGkOZ3zswdhx8XEHXN+k6KNzprt+tcsdJJj1Bc/pl/fw+x3UVo3lk7LjNfiygIL4OzSVweBo83q06VXRskVvNPEJiKrI5CYWwcSscdNmUNa4rJ//vF+N0Uo/XTPXH8ZkGrRiDJgYOEILPSz6k+1JAkE83YH3MiQxuwYUqwmpzUBUBB5tAJR/SpptTaXE8SdMQSQ9quvCdSbGcsbK4ldZlinKA1PICfGU=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39d38a9-5f55-4322-c160-08d6df67f7f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 10:18:15.3401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3587
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/23/2019 11:50 AM, Sascha Hauer wrote:=0A=
> The CAAM driver has most of its debug messages inside #ifdef DEBUG and=0A=
> then prints them at KERN_ERR level. Do this properly and print the=0A=
> messages at DEBUG_LEVEL as they are supposed to. With this we can get=0A=
> rid of a lot of ifdefs in the code.=0A=
> =0A=
Thanks Sascha!=0A=
=0A=
For the series:=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Horia=0A=
