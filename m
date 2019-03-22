Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4B5C10F03
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D22D2070D
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="A1XD6Je2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389468AbfCVMiJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:38:09 -0400
Received: from mail-eopbgr20068.outbound.protection.outlook.com ([40.107.2.68]:22295
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732037AbfCVMiD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 08:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oexoMcRxUEFoBm1ltS2XfrOKxSAy5snfpaNHLO636F4=;
 b=A1XD6Je279TBQJ3fCg0jM+abhurT9ZRlxoZEd0u89uAj+BrKhA0d2Dbkm+kZXjqiBLUWl7PaKPh1zwyMeHdPC0MYMxOffATlkeJmAqxxOh4KqGspnw7SpzJpF7s8ZPjUE+xytmuH1WD3COb/VXWLCoWoUWFezFKd6WFPxinK6V0=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Fri, 22 Mar 2019 12:38:00 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::211a:4b31:ec05:6b2d]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::211a:4b31:ec05:6b2d%4]) with mapi id 15.20.1730.017; Fri, 22 Mar 2019
 12:38:00 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix copy of next buffer for xcbc and cmac
Thread-Topic: [PATCH] crypto: caam - fix copy of next buffer for xcbc and cmac
Thread-Index: AQHU4KiQQPSWN7pIskqNKnHmV/Wd0Q==
Date:   Fri, 22 Mar 2019 12:38:00 +0000
Message-ID: <AM0PR0402MB347658D9B627F59F36D2DA0D98430@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <1553256750-1125-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 522b7e8c-3ee0-45e9-f8a8-08d6aec3383f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR0402MB3476;
x-ms-traffictypediagnostic: AM0PR0402MB3476:
x-microsoft-antispam-prvs: <AM0PR0402MB347692FB01E059FF6028DD8C98430@AM0PR0402MB3476.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(346002)(366004)(376002)(199004)(189003)(71200400001)(74316002)(26005)(256004)(6246003)(86362001)(4326008)(4744005)(66066001)(99286004)(25786009)(44832011)(6506007)(476003)(53546011)(7736002)(102836004)(7696005)(8676002)(446003)(486006)(76176011)(305945005)(5660300002)(186003)(106356001)(53936002)(68736007)(9686003)(33656002)(81166006)(81156014)(14454004)(52536014)(2906002)(97736004)(478600001)(316002)(55016002)(229853002)(8936002)(6636002)(6116002)(105586002)(54906003)(71190400001)(110136005)(6436002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3476;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mdjSl5Vm1pAZMuQB3rMwZUU9rL8ui46YEUYKmLOGF2VvFQcyij140mww6h68wEPzbnw6wgUxqgi7NCgmSifaRQT8/p5VaGT32j0VvN/lbeB9jwuK7dAjoZW8pKdwxRlMjs3TUI6wQg4HS/e+geOuqmqA/G1iH3eCpeT+1n13/dSw1hGWjsoJU9TYKqRRPQ7wnyqMVGEVuFd3wxP1dS6HsQThP+kRAfizY0sBe9WRrDTKVRDuH1BatWblmE9DmZJ68bf5lCujOL8dQJ8L3aod5qewdAU2v1ct1czjSNL4Fu/B0tj+RQH8Unfgw3DDzOIvzK91pFfqvGGsZKDMCliOJss/SwU/C8wgaFhHh3bRtT3Z0Ux3lqhTcehL+FV63nVYUooX5MeZcMZ1Fiz7+Cn70BRdTFWL7jbs7NSepTDKqxs=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 522b7e8c-3ee0-45e9-f8a8-08d6aec3383f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 12:38:00.4695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3476
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/22/2019 2:12 PM, Iuliana Prodan wrote:=0A=
> Fix a side effect of adding xcbc support, when the next_buffer is not=0A=
> copied.=0A=
> The issue occurs, when there is stored from previous state a blocksize=0A=
> buffer and received, a less than blocksize, from user. In this case, the=
=0A=
> nents for req->src is 0, and the next_buffer is not copied.=0A=
> An example is:=0A=
> {=0A=
> 	.tap	=3D { 17, 15, 8 },=0A=
> 	.psize	=3D 40,=0A=
> 	.np	=3D 3,=0A=
> 	.ksize	=3D 16,=0A=
> }=0A=
> =0A=
> Cc: <stable@vger.kernel.org>=0A=
> Fixes: 12b8567f6fa4 ("crypto: caam - add support for xcbc(aes)")=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
