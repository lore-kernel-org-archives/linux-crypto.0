Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD22C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 14:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3F36222B0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 14:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aDLU/c8V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKSO1V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 09:27:21 -0500
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:38293
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbfKSO1V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 09:27:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuKrVoTd3i35WaiZKa1zZWpUd9CdDwPfwyC4n7UprciU533eFm+k3MAxNfPNGeihtYFSkRekoZkSNVsqs9+RoaNQbcICsOGNR5y3IxaV6XODYDzzRc6ZrxgS3addTqJOUwO/NGEohCXJKgjcnBUbpuI9nX09xhIsFWaTKniVe+nEi1CKoGgD+pUE23kUt8hm46Q6vPD2Ev2Q6nCovHg/3bjpKhVhbOxplmdQMzGI71kAgiafyk4tL7u+xmaCYnmDoNKusBTMmiEwMJ1xIUAAZIw1C5UllHCcgZySvIQM3JysBP+T+FsLAhsMD+RwGK16lE0AIgvW1CkmD7Q5JLn6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdYd4wO4gMTlZSd+VdxqWOnlIfsmwAJBvXjpAPuH7ls=;
 b=F5WlwBEpxkCab64YeShsorMYCPI5ti3G0FsX5JJ72qXhuAl3IzpuXff/Rdf/Y6bjjzonD6w7A4zH6idSbeBpiGKOZq7RWFjZirP0L/7gpPbmWIpTdtmxWfGEBN6WQfBbSbHhAzR8oPrLpDoJCTV0UR1lTg2MX3/b/b2kg9Re6TK2g0dKe/DOFN5lXhH45T4fDigkAWcFHfjASXbCpwLig5H6PJHne74xGxShpATUHmiywrvgYQ1sglVwy8gSRHrr5zapDs+WiDwzByvxrAw6vCwc0tLCsLYIqyAYKlJYpzV5pKH5YLDLk0cI8TpZpfgcMWktfd8UUGeu8+yWthqpag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdYd4wO4gMTlZSd+VdxqWOnlIfsmwAJBvXjpAPuH7ls=;
 b=aDLU/c8VSIuifLEE9KVufeFIKrjGqr80QoT4hL8nSqg4EFG9B4B2tVbJaGA4Q0zWzAIRLjMVZRnUZBk0BZWaKbhvJ7Sg5Dl6ZbomKcid4IRU76bcDcqjS6O4lS2SJVMmqNp0k/+5ZNTA7MdPCsdW8+SIpDZGqpDkcqsG8QYenHI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3582.eurprd04.prod.outlook.com (52.134.4.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Tue, 19 Nov 2019 14:27:17 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 14:27:17 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 01/12] crypto: add helper function for akcipher_request
Thread-Topic: [PATCH 01/12] crypto: add helper function for akcipher_request
Thread-Index: AQHVnZazqrmBlKxNcEutgiCvx01rpA==
Date:   Tue, 19 Nov 2019 14:27:17 +0000
Message-ID: <VI1PR0402MB34859CB3D27C1063490A8E02984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 931da169-8eef-4675-0cd7-08d76cfc9471
x-ms-traffictypediagnostic: VI1PR0402MB3582:|VI1PR0402MB3582:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB35822F8016C215FFB3E07AA0984C0@VI1PR0402MB3582.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:298;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(189003)(199004)(81166006)(7696005)(71200400001)(71190400001)(102836004)(8676002)(7736002)(478600001)(66446008)(64756008)(66556008)(66476007)(99286004)(14444005)(14454004)(6436002)(25786009)(26005)(9686003)(55016002)(486006)(305945005)(476003)(446003)(229853002)(8936002)(186003)(316002)(81156014)(6246003)(74316002)(6116002)(4326008)(3846002)(53546011)(44832011)(6506007)(256004)(76176011)(66066001)(5660300002)(558084003)(33656002)(66946007)(86362001)(52536014)(6636002)(110136005)(54906003)(91956017)(76116006)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3582;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FL0epi24d8fRkjnF9LxDceDl2Jz7PF3suMG1K9vhHIh/8Xx9L7Obm/NtDwgaJil+ivKgp2a31EghdzHdMrqyzUJFW7TyTeZBkl/8NxgWysEIwmXmdjy+vG7GCiEh8J/q9/9Zq/BN6Y17QUEFeYmbQNYnydemCwir2aEhRs6NfezCAV25wjBNKF0ZrM8X5BPsajIbE5garNviL7ML27JLAfR1oSSc037T06W2ssEpkS/GlRIkaYn83x82ybN19SDxmWr2d9AZAUjRS55spKBF2ncbYxjP40XrIhEYdX/iBTaYjjApsAb/Guo34yNfeAZ0voCgBayCH8li5GgziTfxHDL/u8xMPZnTFtjDVVlOGSNDTc1lFy35SHMCqLVSpZi/jRh2at2g2Wc8yCgDp3oXUMtNtnula1WL+JdZiVQ7fN3bpZiDOoTkvcn93IeC11Gx
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931da169-8eef-4675-0cd7-08d76cfc9471
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 14:27:17.2840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCeuvO/aHgsWVOtzLrQR+YonwalZvzm2/fj3UzOambgSijbxaUEjRgUbH+Y0yq06Jqb7P0TW1bQ6xOwLEs15KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3582
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Add akcipher_request_cast function to get an akcipher_request struct from=
=0A=
> a crypto_async_request struct.=0A=
> =0A=
> Remove this function from ccp driver.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
