Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40721C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED6FC20684
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Hsl1IDMv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfBVLCb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:02:31 -0500
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:23424
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfBVLCa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 06:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXXJ3cNQenlBuf6vUrVq2wQWW4co/zNzPknIM2QRRi8=;
 b=Hsl1IDMvuCc4d58tLiQMLnyAOn6RhJYcw2c6vBClKfp0BofGRx1uN+lMDpxKhTKeNFUvALRqdjo8j8QsAQO+jPgslc50IiKpW6eU5RDr74kXNmZ2FvGcbzdOa//c3jPR29qdssOzxThqhw9IX+iCmHQrn+vU8Qb+NeFVB1XIr6U=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3680.eurprd04.prod.outlook.com (52.134.15.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.15; Fri, 22 Feb 2019 11:02:27 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e%3]) with mapi id 15.20.1643.014; Fri, 22 Feb 2019
 11:02:27 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Chengguang Xu <cgxu519@gmx.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: caam - remove redundant likely/unlikely
 annotation
Thread-Topic: [PATCH v2] crypto: caam - remove redundant likely/unlikely
 annotation
Thread-Index: AQHUyp4Y10SR30XGuUOgOpYDnjHUjw==
Date:   Fri, 22 Feb 2019 11:02:27 +0000
Message-ID: <VI1PR0402MB34852008387066A66D9F6069987F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190220104918.32637-1-cgxu519@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16bb0a7c-e23e-4ab1-3f35-08d698b53bd2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3680;
x-ms-traffictypediagnostic: VI1PR0402MB3680:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;VI1PR0402MB3680;23:5NJsLNTgnwLHeBa95oDgMTmYl7nFnlT8J3hRD?=
 =?iso-8859-2?Q?DlArfV3NBeyE6aTEeibjxwv05lVqkwWktXB267fsQCkvOU3+cfYmC1JGJX?=
 =?iso-8859-2?Q?Zk1x4fx2fgvV2TmAvzZJZubOROQ+DBH6D4e6ICeV9CbybwYrVT/xKpnWrQ?=
 =?iso-8859-2?Q?NRjtoGq9QGIBAiA7WVqNpHuInvYAbWM8K6G0MqOMuH0ewCHyhVML1KkCgA?=
 =?iso-8859-2?Q?ZpBLTHsh4HWeM3aiPR86rzRMdfhUwSa+sKhrua2LEJbtDi8C5oS4nfuihE?=
 =?iso-8859-2?Q?wBzAwVeAlr+9OIWJr2vScnu1iHKUSiS6EXFl8ZoFV4MiRLaua/x5uB7+Wf?=
 =?iso-8859-2?Q?pc3I8++Ofu7Xtq1JJ41hm+sT7eMCq25U+z0tplfuK6WrXYdD7N+vqLSOZh?=
 =?iso-8859-2?Q?/Jh5Qn2wbcHlc8tus0Q3vygDgxgLC7IMddVhPJLb5Sct+4d3bSQxfNBbC3?=
 =?iso-8859-2?Q?ZerIwPlEJnHwhPY56V5dmtFModT+p9lVg5yORdzMSquAI8nDuBx/gEStmq?=
 =?iso-8859-2?Q?0G08g9moBAKZfEmpsSFT2sNDTX3hS0BJxXnkmvnHYcaudEJr+74FTje0Mp?=
 =?iso-8859-2?Q?5ZeilGUY4un+MHWqG7lNMgMpKYcgjl0PW5IHgMm2jVJd1wS7tPNT5U9a24?=
 =?iso-8859-2?Q?71Fc3QqZ3m5fa5BCYGdSrcG4EA57+6wsT5pNUO9mWl+mXo+QfZ82Ebckhu?=
 =?iso-8859-2?Q?hCZ/AQJrDcASLQXu4WoTBasotlp454MdfoyXNbgXUv6R1W3BIg5CP8iR+9?=
 =?iso-8859-2?Q?l2QVQLeAJna1NWRBfpgM3Mild7YYgdt/ZEpk4iN0OQA3qHh4Tm0dm9mWyW?=
 =?iso-8859-2?Q?GyN8NdPFw9gLxW+adwNYFbpl7Snf+uXtXtTEmPQtIJ3yorvERfiyOejIit?=
 =?iso-8859-2?Q?h2gVEJ61fGAEA2RdW8KzEVWi3M+FieVXacWTR8WA8m8uuVqnq6hLFxbXHw?=
 =?iso-8859-2?Q?8DJ5zaA0l8lS2nyvgd8dGKb8Z+5jlW0d8rZ8vVnazoeIELbLDGOvSiixcy?=
 =?iso-8859-2?Q?lTqUMcKSVNArSfwWDs4axDdUFEiSmv3tiJSU/Bpbn7aG8eyIDQpqpUsQfp?=
 =?iso-8859-2?Q?gbIjxwxunneFNsDVSpAg20tF+NBudnNZLtaATQ6rvgdCMMKEEeEgKCLSpn?=
 =?iso-8859-2?Q?n6RJqINURwGVli+ZaW1eIoYnM3WxvthQmXY2HdvSCITuQcuu4meLyouj+R?=
 =?iso-8859-2?Q?thaOODnl0RAl+9U5WzVVre3eSdRo3VOSuxDTgBw+U/Oq5DAFO8Om8j4B6k?=
 =?iso-8859-2?Q?e/1xSM6cUCDE+q+mxsseK8HzE2XgrnrvsLYEwhZSzVWkXQ6/KMQ1T56yGi?=
 =?iso-8859-2?Q?Foic=3D?=
x-microsoft-antispam-prvs: <VI1PR0402MB3680CB9DECFAADE5BD72C57A987F0@VI1PR0402MB3680.eurprd04.prod.outlook.com>
x-forefront-prvs: 09565527D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39860400002)(366004)(136003)(189003)(199004)(6246003)(229853002)(102836004)(14454004)(2906002)(6506007)(4326008)(53546011)(25786009)(3846002)(99286004)(478600001)(6116002)(446003)(6436002)(186003)(26005)(476003)(9686003)(7696005)(486006)(76176011)(71200400001)(71190400001)(55016002)(44832011)(53936002)(110136005)(558084003)(97736004)(2501003)(105586002)(7736002)(106356001)(68736007)(8936002)(256004)(81166006)(74316002)(8676002)(66066001)(2201001)(305945005)(86362001)(5660300002)(33656002)(81156014)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3680;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 49DEW5RBxeotoey9kA2q025jEj+oIxi+QPwUHOtJ9ufVfkxB/O1hqCeB6o4eFcRi40aaRwuNS0Zy17NhMCuHhTWE/kjoKM9yLTng5fEFGop7fNsdCpnf6WLATXxaTPHH2U13g3InFRV4hsg9cOC5XdWuDKr4DPJsfBGzCtJ/PlH/vpTLez5SxVPVkt5U6OfzRpdg1AnJaEhAiOyQ1+kfm6vcPXIKAb5umFu7XDgNuJzga3rRwvdoFXLk5mlwKwfF3H4gxwD4METk+Yuq6wSLO3LvQV7+po6k1SXA4eEcD+GzbSVt/XY/DQJy8Pu9Xnj9stPvpdcjaeTbCuKE1TeDW/VLAhHhXam5l0fcod+j0FONaIBRG6sQlcwnQB1tIEYBrfB5Tp6EB/K90c0mkMkk7BO+NpmFy3mMch88pAbtCLI=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bb0a7c-e23e-4ab1-3f35-08d698b53bd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2019 11:02:27.8399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3680
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/20/2019 12:50 PM, Chengguang Xu wrote:=0A=
> unlikely has already included in IS_ERR(), so just=0A=
> remove redundant likely/unlikely annotation.=0A=
> =0A=
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
