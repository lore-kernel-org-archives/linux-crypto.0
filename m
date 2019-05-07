Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9285AC004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 14:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015492087F
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 14:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="XmdKw5pg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEGOa6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 10:30:58 -0400
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:20390
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726486AbfEGOa6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 10:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcdTtV4/0P6asI0qpvDWF/8dw22r1KZHYyB5RTRVHIk=;
 b=XmdKw5pgBxBz0hpj2Dl6ulhkqjgFFskqwoFU83QXvVfYyqowngYoJwrdzqhMwtZQyWDobUDC6mrjY3IrBvekLRwuLob+i4BmtQeNafRDUEETpp7dXCHsLFp0nViEVyECjxzpsGnZQa88tfb/Mpa1boFqUSgTPNzb51U1Trkafac=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2767.eurprd04.prod.outlook.com (10.172.255.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Tue, 7 May 2019 14:30:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1856.012; Tue, 7 May 2019
 14:30:54 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam: fix caam_dump_sg that iterates through
 scatterlist
Thread-Topic: [PATCH] crypto: caam: fix caam_dump_sg that iterates through
 scatterlist
Thread-Index: AQHVBNn6GEV29oSxMECW3IgR0b6OeQ==
Date:   Tue, 7 May 2019 14:30:54 +0000
Message-ID: <VI1PR0402MB34850C42222FF3339BF010D598310@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557236223-31492-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f95abf46-1ed5-4c8b-3d3a-08d6d2f89cf0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2767;
x-ms-traffictypediagnostic: VI1PR0402MB2767:
x-microsoft-antispam-prvs: <VI1PR0402MB27677136BA3CCA2A3CAF39E398310@VI1PR0402MB2767.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(346002)(366004)(39860400002)(199004)(189003)(8676002)(229853002)(305945005)(7736002)(71200400001)(71190400001)(478600001)(110136005)(66946007)(44832011)(53936002)(66066001)(74316002)(4326008)(8936002)(64756008)(66476007)(66556008)(66446008)(9686003)(54906003)(81156014)(6436002)(25786009)(55016002)(558084003)(86362001)(2906002)(81166006)(52536014)(73956011)(3846002)(6116002)(76176011)(76116006)(102836004)(446003)(256004)(14454004)(68736007)(26005)(5660300002)(186003)(6506007)(476003)(33656002)(6246003)(486006)(53546011)(316002)(7696005)(99286004)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2767;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C7UmxV1O8yfey3mDkJrjH9LP5ub+QutwFvgvexdTe27MlYu/ojKYHVXBZyZUro+riRr1ioAYmq42AOo28EZf81NjyPl5kIi7FXlcLUdDH5zAp9XdxTFObE5H2tb0JM8/rr8pw18OaCU7KctV56g5iaZsDt+HeAkUFCbClOPDSt2lDUs5iLC9f1BzvwjgY7moNwe90kojXJHWDtEq34zr7oIVuZoFjE867X+0WlJwcvPR5tSP4tNZlQIVqG9W0G75OndAjPuJElpMWS3zy9MvF7kCxtp1kmHqFhK/86y7FRsWHZarVbbGoO66HfVnc0mLVFPeEbO3WwhkOni4xBOl4ru2g2buqgruWRjJrGfVGKlHN5icvafkTKQ48nqHlcPHHdv9IYXzQony0yhHI1vay628ZgTTEWNqsO+5lEhwTtI=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95abf46-1ed5-4c8b-3d3a-08d6d2f89cf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 14:30:54.4444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2767
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/7/2019 4:37 PM, Iuliana Prodan wrote:=0A=
> Fix caam_dump_sg by correctly determining the next scatterlist=0A=
> entry in the list.=0A=
> =0A=
> Fixes: 5ecf8ef9103c ("crypto: caam - fix sg dump")=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
