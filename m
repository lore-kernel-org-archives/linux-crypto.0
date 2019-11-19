Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A06C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 14:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7196D2231C
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 14:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="V++5GjXS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfKSOlq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 09:41:46 -0500
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:36737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfKSOlp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 09:41:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6NFVeAVCLgLF4XDthC91vYSkXrszZoUq0j1rhtWYPAy5a1h62pqrN1fSHRRrB5l7L0WBMauHu5sEYYNHftmx0+sLjyohEciRBeA/0KhS4hVEdJ/837ARlx4FM4Kb4ywgUfpcjtnCGWLTGDEZc9qW9EUQQ6lAyu0q7ph/F/1WgR2f3/7mYBB/UZVHsJp6h/U5lfWxlpYwVfa209Lf47jq/dPyrSv37U025+yes9nMyt9kfuAHolnT2QBfa+MZDuBziBfktlY7bzvx/KZBojBHoKg5P4D1nqD/mxHhr/nLZB717uAakWLTiRisaHl8Dvq/lWqeuWf5OtKSrvUWWxrzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbpTrBpBpK7tUErCYXfrAt5TPzEYLq3/FXIUC1qyvEs=;
 b=dNX8ACtRDogTQhlJPQ4ODYxu457oXr/YOcmU1WuueVqwAuhu6R5GW06QccGcQGm4rB0+bOS7+iNgELvwS4ME8M7eXBNp3KXeTwel0XGZQmpFXpa+3yUlbMyebO52p1oYpGN1bV786f4p2f5Jkl0cZ/kH/1bKHRCknNDBiX5GjO6idgASovjq6oKamYA1FW+fHDkE29PJDZsWqIL+9NzaFq027zwocjDAXAUHlR7cgfwpR04CP4AHx+gCzBVdiV3zeYZGGFuwTPjJyNYRBebPpGhQx9yT3n0W2TTNm2dOqVcEInTmcBxGlio4mmkYkbB9aJPaoXDWeU3NaHZ3HCD0/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbpTrBpBpK7tUErCYXfrAt5TPzEYLq3/FXIUC1qyvEs=;
 b=V++5GjXSelXzulv0NaomFkCY57yyWjlwKjeGAebQozwgf3gNdjZH/VqTpm+Rh4jo7CE/5DG+L16fnIOhT8O09kWQonm8Z1U7vm8XXVyQ5IzV58JByZaMXeQxQGk+uE0R+acV+vi+ZxBABcQb56XfYUMTUjQPiWUaS3Ome3rSU94=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2765.eurprd04.prod.outlook.com (10.175.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Tue, 19 Nov 2019 14:41:42 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 14:41:42 +0000
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
Subject: Re: [PATCH 02/12] crypto: caam - refactor
 skcipher/aead/gcm/chachapoly {en,de}crypt functions
Thread-Topic: [PATCH 02/12] crypto: caam - refactor
 skcipher/aead/gcm/chachapoly {en,de}crypt functions
Thread-Index: AQHVnZaz+/Zm2ucDTE2Qav3gvXdqGw==
Date:   Tue, 19 Nov 2019 14:41:42 +0000
Message-ID: <VI1PR0402MB34853C56F5CCBCA440BDB7F6984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-3-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5cbb2678-0bfc-46f1-088d-08d76cfe984f
x-ms-traffictypediagnostic: VI1PR0402MB2765:|VI1PR0402MB2765:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB27650964CA4562F65DF253D6984C0@VI1PR0402MB2765.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(189003)(199004)(6506007)(44832011)(7696005)(76176011)(53546011)(8936002)(102836004)(6636002)(33656002)(91956017)(76116006)(478600001)(25786009)(14454004)(74316002)(305945005)(26005)(86362001)(316002)(71200400001)(7736002)(52536014)(486006)(6436002)(476003)(64756008)(66946007)(66066001)(6246003)(4326008)(66556008)(4744005)(55016002)(71190400001)(110136005)(9686003)(54906003)(446003)(8676002)(5660300002)(2906002)(256004)(66446008)(81166006)(81156014)(6116002)(3846002)(66476007)(186003)(229853002)(99286004)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2765;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pDLFR7f1qMGKtc0iqFPAl+/jSyOFsy8RDyc0KrdVYkls235EdTn0Mr0Gw1RBgazzFqPF1WaN7IA83r12sgGwUjvpDQIeToUQ6FJMTxCPsHIB+MTDJg2Yr6768xtM4j+O2TI4DzKA8XmOX10UqGWNLEHbZ6JGMpGXTmBV0s4qwg9GRRSHJyzf/HoaELT/qmif86uqU0NyauWrjXrLzKgJA4UfvETb1R/tzlzPRUtFanYfArg09dlGeq38JkXdZqGBrVsIHBiec+FLd/S9w2njBAUSy7wkACGoLVowPS39iRsodVCwgAQo+CvyNssgHR1fqXfjZY6Vc9uGG/iG5Ih0y567bDTGEPyB/a/wx8Y/eASb65sXqBMa+m7Hi6WWXyvT/hK4gm9rfLFTmCQddeQLqEKA9OG4tM7SgT71BIIc5xo3sikcyWVg6RCNxmzswZde
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbb2678-0bfc-46f1-088d-08d76cfe984f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 14:41:42.7324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YPRjd7vHqIXFas3xNvvjcpW9lDwm2NN/fFc49qcRuCcjyLNZdbJALCiNx9XteG3CgppvRIzT8sg5oIuZGolciA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2765
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Create a common crypt function for each skcipher/aead/gcm/chachapoly=0A=
> algorithms and call it for encrypt/decrypt with the specific boolean -=0A=
> true for encrypt and false for decrypt.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
