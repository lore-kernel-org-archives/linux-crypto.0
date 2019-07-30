Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC84C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63FBA206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="rd3g0H7r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfG3M2B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:28:01 -0400
Received: from mail-eopbgr10064.outbound.protection.outlook.com ([40.107.1.64]:62511
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbfG3M2B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:28:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4CDS7NQuNYaC50HyQfSGEZZfxoSTRTcWVO8yoWPfr1Mdl/UFBcAsUgQybYmW5G7SihllJykFhwRmv/48bqDcXh9AqMpBE8UWfdBzUkqd+aK1QojPwneT/ug1XiblMjtfdNJ9VH/RZl+wfHuZRthiOqg48zqMhTRS+OdIFme+im7g1IfMKHQJ6hefk+TNpjX6m+PRIwGh2q+X6EGTZOQ6cDMixqSm+NMtAdcrene9VK10SSXIW3GqEbScA7Spgv8Ke/nuShNoWU8UhDC+mVer0s3lztZoNIxH7YJuHw2Tq2GVQZMkq2Wh+8Bwu2Bz3Ad4CakAVV8Q9CneR/QJ4PszA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwoxgYJDfCkn2n8/y2mCQ+M7ba+48jQyrxholrGcctU=;
 b=KQJD5ul+QC1wNQYchKzxF1U/qMqH9xVoJCu5Xn08vK05sYUJicTMkCMs/5xVtb2++YMMHDfnpAUVqBFsgRW37Z1h2+VlzZzxv/JqxhQQ/75m7nqEdyDxFe7btyyBW1ajIxLXqW2KbFgcVieMtvlmYYpzS5kDdA/vXNtFP3tX9fDewwZoU1F6eGgddgGa6O+iTbHMgX1QXeHaz0AbF5f+Ez71A2TTQJ3OEbW+37toOUa5HUzMtecxAN0cTOWjlpZCPju7tmoK7dLE7IsHxtkEpRQVog5kfKFJfIjW2vX7fXKAi2VjWjSBqBze3T6eWrxN2RnOtjcTZbD1EHmu01hlpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwoxgYJDfCkn2n8/y2mCQ+M7ba+48jQyrxholrGcctU=;
 b=rd3g0H7rTgmdBA/+yL2dDDBwURzJmESdL66JU8CC63VlftvNZD/VUWjXlRl2y6fp+MQipo2EsPvHSy7qdsvhujglK5E8fPBkB3iYsShtHJo3dqr9U7umewjq6VCYNnUk4iaPLeFeM1qhfXm+/u6tomvJxhFh5RaAcxNvsIwVKmY=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4112.eurprd04.prod.outlook.com (52.133.14.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 12:27:56 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 12:27:56 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 10/14] crypto: caam - fix MDHA key derivation for
 certain user key lengths
Thread-Topic: [PATCH v4 10/14] crypto: caam - fix MDHA key derivation for
 certain user key lengths
Thread-Index: AQHVRsbnGt/UawgfPUat+h6bvvIJAw==
Date:   Tue, 30 Jul 2019 12:27:56 +0000
Message-ID: <VI1PR04MB4445047FD7ABADD93F3D70338CDC0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1564484805-28735-1-git-send-email-iuliana.prodan@nxp.com>
 <1564484805-28735-11-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a43c3b2-a8d2-48e7-b857-08d714e95a11
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4112;
x-ms-traffictypediagnostic: VI1PR04MB4112:
x-microsoft-antispam-prvs: <VI1PR04MB4112D27F3B78C43C81A5DD3C8CDC0@VI1PR04MB4112.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(189003)(199004)(6506007)(64756008)(4326008)(446003)(52536014)(71200400001)(71190400001)(256004)(486006)(66476007)(86362001)(7736002)(229853002)(66946007)(53546011)(478600001)(76116006)(305945005)(91956017)(68736007)(66446008)(66556008)(6246003)(74316002)(6436002)(5660300002)(3846002)(4744005)(6116002)(2906002)(76176011)(53936002)(66066001)(7696005)(55016002)(14454004)(8676002)(8936002)(110136005)(9686003)(25786009)(44832011)(54906003)(81166006)(81156014)(102836004)(186003)(316002)(476003)(33656002)(26005)(99286004)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4112;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Uo9ZZkubFo3LrqPUi60Af05Nji716AHwFaQocKQOL3OgDebrlIRxhwXi7oZKMy3X9AGmc9mtY5ZLuupBJyyR+qgoruTs2TgMHUHD9SoNKxYRG0aLK21Qs+AKFoKDEIV88oyYgT7yoi+lWsBZgnzP2ncqRsAXBSUSYAnOSlLB4MxNggtiZW2adB/wDhJOeglRUvFsMjiAjhCcYu2LPN7yvFsZrcbVCE9QxJA6IwlFudfHy1BS/j6zKZ9diiXg7T+/QIgMlTeWTOSihNZlIVX7M8fKEF51LlEdHv1s7KMP8fLPk8qWEFqk2NketH1vvZvSPQ9LK+BiIJLmh8aEOrB1zmwPfNqYYkE4cMW8lz7qMbhv4akD+CBadfiKUFxfQwp+L+LK4qTiIWOUAzBKqeQGJJQO+cG5Wlh7q2Wqtu3zxaU=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a43c3b2-a8d2-48e7-b857-08d714e95a11
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 12:27:56.5431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4112
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 2:06 PM, Iuliana Prodan wrote:=0A=
> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Fuzz testing uncovered an issue when |user key| > |derived key|.=0A=
> Derived key generation has to be fixed in two cases:=0A=
> =0A=
> 1. Era >=3D 6 (DKP is available)=0A=
> DKP cannot be used with immediate input key if |user key| > |derived key|=
,=0A=
> since the resulting descriptor (after DKP execution) would be invalid -=
=0A=
> having a few bytes from user key left in descriptor buffer=0A=
> as incorrect opcodes.=0A=
> =0A=
> Fix DKP usage both in standalone hmac and in authenc algorithms.=0A=
> For authenc the logic is simplified, by always storing both virtual=0A=
> and dma key addresses.=0A=
> =0A=
> 2. Era < 6=0A=
> The same case (|user key| > |derived key|) fails when DKP=0A=
> is not available.=0A=
> Make sure gen_split_key() dma maps max(|user key|, |derived key|),=0A=
> since this is an in-place (bidirectional) operation.=0A=
> =0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> ---=0A=
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
Thanks,=0A=
Iulia=0A=
