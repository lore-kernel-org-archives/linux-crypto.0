Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491C7C10F13
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 12:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBCA205ED
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 12:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="x3zXdmN8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfDPMxA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Apr 2019 08:53:00 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:55428
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbfDPMw7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Apr 2019 08:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iukaT7Z6++yyXm0IaZt51Ws21DKaUj0HHE+/2n4adPQ=;
 b=x3zXdmN8sDOqGv6snVTbuSzCuQnkKLldvVAClT9fd35i33buR028kexm0Xf6dCZ4Zwq9gGSiPNP50NbbAucnd2iVMasUVDyiON8cyLgRaZ3vM1GGBZfT8XJDH7oS46pYRbF6kj5zxs5HLUdiAhQlXVjVJosGfrh5CDd8/jYbAPA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3565.eurprd04.prod.outlook.com (52.134.4.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.11; Tue, 16 Apr 2019 12:52:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1792.020; Tue, 16 Apr 2019
 12:52:54 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 6/24] crypto: caam - Forbid 2-key 3DES in FIPS mode
Thread-Topic: [PATCH 6/24] crypto: caam - Forbid 2-key 3DES in FIPS mode
Thread-Index: AQHU9FNO+WpXRZBCEkm7LQIIWA/sKA==
Date:   Tue, 16 Apr 2019 12:52:54 +0000
Message-ID: <VI1PR0402MB3485E82FDF2C54E98F32FDA398240@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
 <E1hEVQE-0006mC-7q@gondobar>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41b1d1be-dc50-4465-fea0-08d6c26a716e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600140)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3565;
x-ms-traffictypediagnostic: VI1PR0402MB3565:
x-microsoft-antispam-prvs: <VI1PR0402MB3565072702E76C26F92E7F7A98240@VI1PR0402MB3565.eurprd04.prod.outlook.com>
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(396003)(366004)(346002)(189003)(199004)(478600001)(2906002)(76176011)(14454004)(25786009)(86362001)(71200400001)(71190400001)(33656002)(55016002)(9686003)(66066001)(53936002)(7696005)(5660300002)(97736004)(52536014)(81156014)(81166006)(8676002)(8936002)(6246003)(99286004)(229853002)(6436002)(44832011)(486006)(446003)(476003)(256004)(186003)(6506007)(53546011)(3846002)(6116002)(102836004)(316002)(7736002)(110136005)(105586002)(26005)(106356001)(305945005)(558084003)(68736007)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3565;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RDUh8QaiqhNShgSadGW/2+Ig/JQKSbfrnMbcTtbY6jjhxXnpqJz7BqEwNfu/nz3R4VNYZJEeghppDhHDJokoNnKbcOTAO9WzwJ8C/tzcdB3VA5E6LUduTKn+aU8fZHTA4NLZHb7uPQSbwVGm88eYrsBFEXbUv7DS2ePBDnv5xMFU0A8uRv2L7Y4tZ593R1GJzf/KTTqSRH5qbKvy6hZY6fmjCZ/ys8QugS145fxAMlfauJtfhmLDbPXoe0gY/gZUxUtdRJjaeNsSqJ+YUzQxmIDb7hGUF3OEXxBhH7xabsFATC6uvvy+Qtl3rGACXi1xTjt3mmLVbP5fO34Po1aERoq9XyX2AXkkzWrC455ikF47lTJy5lluundnWcNagBqIsIJ7Fljrp5JjcTzrbvdWuhyPXVSlKnJz2k3Th6vC4Ts=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b1d1be-dc50-4465-fea0-08d6c26a716e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 12:52:54.3334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3565
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/11/2019 11:51 AM, Herbert Xu wrote:=0A=
> This patch forbids the use of 2-key 3DES (K1 =3D=3D K3) in FIPS mode.=0A=
> =0A=
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
