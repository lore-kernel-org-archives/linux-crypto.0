Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA85C2D0D2
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3101824680
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OcSHhzyh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfLTHJC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:09:02 -0500
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:27534
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726030AbfLTHJC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 02:09:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iteSw1DRyC7prXjgY5EkZKH8u1UtiKtpyfM/KsIMbGdhO9ilG2Lvc9n8aS/nKwGpqhvT+misqtWCrDBxZfS7YVJF/qXDq9J2u9ppYPlZL0WlbrIrfQcXLMyObfjPC0LXCqeUoz3dr2Bv9kmLkd3/APRKaTRZoD1kRB/fNSV+vbascFZQM3ABPCgU8ZEYlQBU8/WZJQUT7GWZ8E6MD+JiD2CgGD4l56+Y0tVdotx7BN77nGvqG01NERUs2kvTo85FNIB6OwG948lBjvZFhgHByzN3+0TVBaiwLbPI6g8mJ9RjtN0OIOgWP3VVr4I5ymnoaTwfixYLXZkTgXjgMJzg9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUbK6qd8pyegHrh3axa0QBYf2i/k/2R5b4uW0voqH14=;
 b=S3jRrlxjDx0YChr0ReGab/5mSPA727KBwrTt9SPuJhTpR7IQvPJnoPS5+kEmf5iOS0dgeYoq4X7Dah/YK7QljGkXMnsP+BVtsxf/OCzui1LssZH+gHZ9FTONf+G5Cq9vWA0DHKsioxY5FBA35Vo99Vb4/wrzvqhnJS/MtsHGkbU+CEMb4u9yxNaUSrWL4yKwkpaSQhaJTyxm0oqGfNl4Pweb7CNgGbXahAf8YCS3Gf7aUch0i1e3dV3N3mS9DHH33/jE3KvnOlV6yGfGBNVyeXekCyv5ioKg6Alf//lXzJS+o3e+cF3oi8DoF2fR9BdLOFV8dPMbL1kUMxplXj6mPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUbK6qd8pyegHrh3axa0QBYf2i/k/2R5b4uW0voqH14=;
 b=OcSHhzyh/eg74Nlb4AFqUkjbRvWeyYjdlH61IX0wpLTy7Ye6MYTPuQvq28ZN8vCJQjwuoPUcZDCR6ngJhhCRerr+tNUDpYJLMsjI5tmejUsAj5LRd3TWuSBPT99npAWOZtHJZc+GnqcgHyG3u+k4mXUNtMylSfK33BtwtDDgwEU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3328.eurprd04.prod.outlook.com (52.134.8.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Fri, 20 Dec 2019 07:08:58 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 07:08:58 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Adam Ford <aford173@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH V3 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Thread-Topic: [PATCH V3 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Thread-Index: AQHVtaP5bVLk+LtFv0Os3iLGq42xGg==
Date:   Fri, 20 Dec 2019 07:08:58 +0000
Message-ID: <VI1PR0402MB34858B611ED0ACD84CC5EC06982D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191218130616.13860-1-aford173@gmail.com>
 <20191218130616.13860-3-aford173@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4cec1f50-e608-40c9-6339-08d7851b7bc6
x-ms-traffictypediagnostic: VI1PR0402MB3328:|VI1PR0402MB3328:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3328AD75EECC356193EC29E5982D0@VI1PR0402MB3328.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(199004)(189003)(44832011)(66556008)(5660300002)(55016002)(2906002)(33656002)(9686003)(6506007)(26005)(316002)(110136005)(54906003)(66446008)(91956017)(8676002)(81156014)(8936002)(81166006)(478600001)(86362001)(76116006)(7416002)(52536014)(186003)(64756008)(66476007)(4326008)(7696005)(66946007)(558084003)(53546011)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3328;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qHR59k+fUTH8J6Gob0ATg4i9+dHc+ooxq01NR81o8r+dxHaPVV8Shp09m+i31HQLCRXRylylw9WD2/0S6QOz9N7/Lsofu3p5o/N218Jl9n64KGHkeE/mfYq2oy7EXcdM5Gi8CN1LjSRpHwDXH0l2aw8EUtdSqjUFz1Y2SIEZ/SHmn0DmlTpuDkCQX2yzWotIVm1JPYlAR4rPN+/5eLIIxroZb6n8XIZZqu77QHQ6XlpPcfWrZJboesseuPI1bRKOw6nEfuLTY4khBlnlxOCYqrOkYl/lZHsimXIS8V7ZoCNVtElxul4qAXEhgBa1woFQxGd0iIzhIAtU2MGs7NXHvEZyUg5RI26XVDhVoFhEKfQlIZazc1ahhzE6uhB6k8zbuZfqOxnNGlGPHlHNx/qdZ7ddxTDH7P1cGC3dDilg58GRNlUHzkyzua3DPKEmqQlT
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cec1f50-e608-40c9-6339-08d7851b7bc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 07:08:58.2955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elRtOe1Y5AD1lCpsi3WmiMU32TLv4oRjtgsGoY4WyZb+1HpO28+N2qLZ0Y+e39m4FxvgTmQynG0M/NqoMOHirQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3328
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/18/2019 3:06 PM, Adam Ford wrote:=0A=
> Both the i.MX8MQ and i.MX8M Mini support the CAAM driver, but it=0A=
> is currently not enabled by default.=0A=
> =0A=
> This patch enables this as a module.=0A=
> =0A=
> Signed-off-by: Adam Ford <aford173@gmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
