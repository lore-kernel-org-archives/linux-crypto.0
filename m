Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C97C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 16:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4453E2175B
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 16:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DUC5xhkl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbfCUQmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:42:22 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:44318
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728550AbfCUQmV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 12:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htNCW2Tg1mb6lCRjM/0/JdtDJy8Gzcw92v5a0w/K9WI=;
 b=DUC5xhklFYMKc7nGZ9+4HRllObmEaA0kULvGyEm06QbZZWokitD0u/m0lYFbj9W8eE3CQDsXgbqAReuKtouDpTVhFb8hjJbncbFavpTFJGNeTZA6x3FQct09V9EakQPIgO7uorDQ81HxpqePm6NdHhb9diyUEDQswLt90btNwDM=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3391.eurprd04.prod.outlook.com (52.134.1.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Thu, 21 Mar 2019 16:42:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 16:42:18 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>
Subject: Re: [PATCH v2 1/3] crypto: caam/jr - Remove spinlock for output job
 ring
Thread-Topic: [PATCH v2 1/3] crypto: caam/jr - Remove spinlock for output job
 ring
Thread-Index: AQHU2yHHjPma0Lfjuk6emVhctwtQ+A==
Date:   Thu, 21 Mar 2019 16:42:18 +0000
Message-ID: <VI1PR0402MB348522B24752AB158E1D4DF198420@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190315112238.24337-1-vakul.garg@nxp.com>
 <20190315112238.24337-2-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de9e0d42-b86b-42b4-aa00-08d6ae1c2ef9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3391;
x-ms-traffictypediagnostic: VI1PR0402MB3391:
x-microsoft-antispam-prvs: <VI1PR0402MB3391F65318F09F206F2C405B98420@VI1PR0402MB3391.eurprd04.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(366004)(396003)(39860400002)(189003)(199004)(2906002)(71200400001)(14454004)(8676002)(4744005)(4326008)(486006)(105586002)(81156014)(110136005)(2501003)(53546011)(478600001)(186003)(33656002)(81166006)(52536014)(305945005)(6506007)(102836004)(44832011)(446003)(25786009)(106356001)(476003)(97736004)(229853002)(71190400001)(8936002)(6246003)(53936002)(7736002)(99286004)(256004)(6436002)(9686003)(7696005)(86362001)(76176011)(74316002)(66066001)(316002)(2201001)(26005)(3846002)(5660300002)(14444005)(6116002)(68736007)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3391;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: plO7Cb+kFnDz5PK1Wcblhd+9rV+wiGXFI5vA7PGNHPCdQA7CAnVurvqWgrGCWGyakKwFnRfNPNqlEHm8o1B2oz+4UQc83lXZUTghjHE0/Co0nwm3luWoY2nRLhwOOFbvzQdUndEwcH2HtrOryCgn97W1rVzjnJMrpcTqtAIsvc+0BwxtMre/nLkL7Nlsz7i9Ei5oYKpvVCksloybUInWfaTma9i1AfPUmWj6RfleHDiKNHZvNFLK1o1cyytm1rmmd9KUek7eoKAzZ8GqjRF3Q98oRenBG/9IN08MU9iAB5+y/zW+zR2cEuk82uij4hATXNK21mt+vOX2e1U09BNup/niA7d46wTVh868ofgyDGZo69pWLVD//coK5/8kQBtBSpedF4VBtT89BUH17i2nbd+5mPu5A21AuEw2MPUC7dY=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de9e0d42-b86b-42b4-aa00-08d6ae1c2ef9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 16:42:18.8273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3391
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/15/2019 1:25 PM, Vakul Garg wrote:=0A=
> For each job ring pair, the output ring is processed exactly by one cpu=
=0A=
> at a time under a tasklet context (one per ring). Therefore, there is no=
=0A=
> need to protect a job ring's access & its private data structure using a=
=0A=
> lock. Hence the lock can be removed.=0A=
> =0A=
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
