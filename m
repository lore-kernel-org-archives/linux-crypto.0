Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578A7C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F8F20643
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="VX3uLvcd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfCER4B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:56:01 -0500
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:64048
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726052AbfCER4B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 12:56:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jlh9Ev8lGQ5PmtmNsrwKidJ1Cnbgo2iqIwKLEYyHmiw=;
 b=VX3uLvcdKNfzIGK11aiq2SoIvCJ1Lp5+aF0wFi7oWrrWhMmJgnOuzNHrk2ynLD3WEAX7qs76uU7ot3w8+aW+/56grw4MHhrmnTLm4dzRZnHocoj7iUS9atEOiyOZ+3qm0wzD8BvPH76kT3A6pUvOCYq8dn6LYKYaIo8Kfc/hqKY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3888.eurprd04.prod.outlook.com (52.134.17.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.19; Tue, 5 Mar 2019 17:55:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1665.019; Tue, 5 Mar 2019
 17:55:54 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Topic: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Index: AQHU0yEvYfnJy4m6QkW0mfkgeeAyJw==
Date:   Tue, 5 Mar 2019 17:55:54 +0000
Message-ID: <VI1PR0402MB348534AD0A9AD49C178E9FE298720@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190305065820.13072-1-vakul.garg@nxp.com>
 <VI1PR0402MB3485BD912D8FA0E1A33CBA5298720@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <DB7PR04MB42528B5F67984BB8CBF54EDC8B720@DB7PR04MB4252.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b005f41-4763-46e1-242c-08d6a193d05e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3888;
x-ms-traffictypediagnostic: VI1PR0402MB3888:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR0402MB3888;23:csYvGcffSNWPCI/QHwzemKjvtcFQL8e+mRijg2R?=
 =?us-ascii?Q?FywepYDr56gZb1JtXviAb/Esw0VdjXLXBliAZc9IRi8PJ9KGeLc4cEIx7/dZ?=
 =?us-ascii?Q?ffOU/rM/Mi7yUXAn5YmLHPwLR/TgghMRJ7HaPAhq02Vl0tydjo4UYxkWuGvK?=
 =?us-ascii?Q?WJxGhio6vaIw4Dds779BiMoPf0EnV2yQauIFyVUtTm7YA6HJXei9hL4mbnQv?=
 =?us-ascii?Q?VbRQziN72BV/cCf3R++bkQhfGyLvJLEkYf5MrRsOTAlEBMtdhDp1D1yGv73i?=
 =?us-ascii?Q?7xaW4L0dc6RQoP8lqxoLf1Usia45ez9SJakQpq3DRo6ClTSfTikDfM/Z3FW4?=
 =?us-ascii?Q?RccQFTw/PHpTmMqESPYB6yzEW84CNCMZpI4Cy+vvXKFgTiuvDitjbG1/f9/O?=
 =?us-ascii?Q?KugYgZDo2RI0b6T//aJYyksqZQrhcQPGhpG4fLe3Q0OmoU3a4rB3t76PfgGL?=
 =?us-ascii?Q?Xlch0pwyZus8gHOKTGQIWy0xD6VbAATrxDscSBgeUTO/NgXGNlmQYJJiMIue?=
 =?us-ascii?Q?u8fnnniGntyWwo5rAUi7FvrR63lyPTTKOyPZiQN5+LMa04I7/+UiZdsctZf3?=
 =?us-ascii?Q?KXeKVK3w37gciupdjU+7CwKzkP7ZZCcl+UZ+UmRf8jCEsp+FfNi+ZkFE+UYA?=
 =?us-ascii?Q?WbDyFK9PLJvoiVwcfxIfsCXq9QFiS4NtgRz6kI/NysR6ZRXU983IPaNvsLNS?=
 =?us-ascii?Q?wOw9RTkyRAD8wD8IlhM9Zv7z1A5DCphunCTWxtgAc2ZG4hXMRfaBhHVu14t/?=
 =?us-ascii?Q?+AnizPNtPnSiDpmUmSAaMPJLJmrPxOMJ6ek4PNy1Lz0APe8hDwuNe/FLRcnB?=
 =?us-ascii?Q?bK+WLQZ5Wx8oX3uH+4EfPJ6FSLXo0d4mdqOwbm237tN6QF8JaL5u0dF4LG3V?=
 =?us-ascii?Q?oyBnrzem+AcsTKAjR0xPj5uvtdy47VM3OmEbcqdGSxAH6vMkcrtFwSm50YPZ?=
 =?us-ascii?Q?IFHSZZBY/YDsyLTpAMN50QSyzqX93TwU+ETCHKGoMRuyE/Sh04GVcojckCZ8?=
 =?us-ascii?Q?2i+TgtJEPNrTayGWV0vlRf+Og7a+QYF5ED7q26HQV49qh/Ja02xN+KZ8lIhp?=
 =?us-ascii?Q?ZLDhNCVa/FrZzaNBVAjCwj/McAUitQOMWDz0ARKNaFcgWGKe1Gn+QCNXKr97?=
 =?us-ascii?Q?IoEVxDu4UuV+9tD93KaRT3Iw/LYpPQ09//Zjl6RvYo2LOzRKbJbBbPFPZZI/?=
 =?us-ascii?Q?3jGMTc4eSpnGpFQJJr2x70+RDom87rOYbpSTto3zj4ok0/vM5KedlhtbrJI1?=
 =?us-ascii?Q?VJQTE6Rg/VEeUXWZom9vyi5ey1SOgTnQpgr24Y3S5HTsIUdBrJvzRvhYhmH8?=
 =?us-ascii?Q?v1w=3D=3D?=
x-microsoft-antispam-prvs: <VI1PR0402MB388837A95B66443C693F0B6298720@VI1PR0402MB3888.eurprd04.prod.outlook.com>
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(366004)(39860400002)(396003)(199004)(189003)(81156014)(81166006)(105586002)(66066001)(99286004)(6436002)(33656002)(4326008)(106356001)(55016002)(53546011)(102836004)(14454004)(476003)(9686003)(478600001)(6506007)(53936002)(8676002)(7696005)(229853002)(486006)(25786009)(446003)(6246003)(76176011)(2906002)(86362001)(6116002)(71200400001)(71190400001)(74316002)(3846002)(305945005)(5660300002)(7736002)(558084003)(8936002)(97736004)(52536013)(2501003)(68736007)(256004)(26005)(54906003)(110136005)(44832011)(316002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3888;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fr2yIblAFZbqoCayaqUuoG6TPcsi0CNKpP+s7+ODUhuYF17PWvYwQVU/a9DtwpBUaUaGt7UfX+TLq6Ueya6aaJL9RJYkfASVTug/4a/zRa4rgqvH9BDj8/z0C0WkJvGsZmYrhN6fABtDfIeYhUOA2HpGu8kvQ6U0sCGEDNPdyirlmis16sqqQEr08sEt6n50wHz4Qs11smTZ3XgC0XzDnC6NH2t9Am04EEAwx45BcMVHEx36a6rDI/M/XJ2PiJMf1/IKLhfgiLpuTXuwP3Z61KESxQTiYNDxVcZDm1A+ydJahJePqvZ61a0sRgN72Q2YGB3X2eNydE9zUuMtKLgpl25jVkIhHl2Syx8WvRrF13S61z2tdBMy8xwOmTJf96ga1xPmnvHjSLr/iCcs4ZlCJJXMSbNj8/qq8c0X9XHvgFI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b005f41-4763-46e1-242c-08d6a193d05e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 17:55:54.7178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3888
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/5/2019 7:35 PM, Vakul Garg wrote:=0A=
> The performance of kernel ipsec improved by about 6% on ls1028.=0A=
> =0A=
The information should be part of the commit message.=0A=
=0A=
Thanks,=0A=
Horia=0A=
