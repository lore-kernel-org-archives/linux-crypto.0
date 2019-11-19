Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CF9C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29789222D1
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:21:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="nnweqsnK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfKSPVk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:21:40 -0500
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:43294
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbfKSPVk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:21:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+UgQmTJmy7BDM497MhrWRT44Q99XvltIVagFhb7apbBgpiPlBQs8Sraj1ffRL8GMRkFxsnuV8+G8AkH3Suwht+HQMdrfAqKnzVIEJ8ghz88udCx/keiXpmJLgLdCBMDnP48acxfeNO8kESxN91GTsjWhyAxwe+ALSACl1fEVGX/Rb+kvv3mOAEkV2hEBE+8Un/EufKpeuphSTrRWSi1iKJfDMmlG3RAB0jwnhpIGwrJyWEan3wjJIwOOXK9RW/HgGy3mBPvTejJzMSw1iPwi8mYX/kQ7+8rG4rJUi0hQ4UgiGUit3DJtJonAQdQ94z3vlU8SscFdexJorsAco5CSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWQ7hxpCZF/Sq19Jgy58W0aQAWfhlJjYBqa0vsaWWwY=;
 b=mAe/C193IVIu6YxgoPMG5ABStqvGxbWfPViWk195lOYGpEbDFvX8Pg4m/E48ttIdbJxfZbMr+gqSU1uth/Ib3x9lkiyGx7CRsWB1dmwQBUt6Wlzu0KL26w2UnI7En9PKk3m7PVE/ai7qNtfkdnrXABfUiCd3yZHLL/nm68Kjn9aZXczWzTKxup325xtNnSr2oJjJ60xp4HYQkySFy5HuUX3d/ddKoVICFk/Kan8FmYyMORcfWTreL4LrZSsSIHwTWmjBZ0vxpvntQvOhgAMBW6QxQfWIH0lDfRf2b4tZk7PEB9aqsIEX16fhjZMFbavPZ1v/clENUDRPkzYe2hgv+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWQ7hxpCZF/Sq19Jgy58W0aQAWfhlJjYBqa0vsaWWwY=;
 b=nnweqsnKQs529QSiLGmFZHT/45wjX/Oj/mGEC5plW50mNkIh19g45Pe1C8t2HCEP9MudrtdrUH/7MV3pAI4GTKZaGI1JngfbfQ/lGz1NCUiQaFqZkYbqAKlLB06dcDF9ZwpwGftm78v2v19R/Ai/WsD/brvo4IrKu7a8K1R/QXk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3552.eurprd04.prod.outlook.com (52.134.4.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Tue, 19 Nov 2019 15:21:34 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 15:21:34 +0000
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
Subject: Re: [PATCH 06/12] crypto: caam - change return code in
 caam_jr_enqueue function
Thread-Topic: [PATCH 06/12] crypto: caam - change return code in
 caam_jr_enqueue function
Thread-Index: AQHVnZazktuTKSk1mUevNvsTpcH2mA==
Date:   Tue, 19 Nov 2019 15:21:34 +0000
Message-ID: <VI1PR0402MB34859E24D0F95C9809B88901984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-7-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5313c76-42b9-49d8-1fc2-08d76d0429b1
x-ms-traffictypediagnostic: VI1PR0402MB3552:|VI1PR0402MB3552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3552FBE47302866C4794F0CB984C0@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(199004)(189003)(4744005)(53546011)(44832011)(71190400001)(74316002)(446003)(91956017)(66556008)(64756008)(76116006)(66476007)(66946007)(66446008)(4326008)(66066001)(8676002)(6246003)(486006)(6116002)(6636002)(3846002)(14454004)(6436002)(25786009)(9686003)(52536014)(316002)(8936002)(5660300002)(55016002)(99286004)(2906002)(476003)(81166006)(14444005)(54906003)(81156014)(229853002)(110136005)(102836004)(186003)(6506007)(7736002)(256004)(86362001)(478600001)(26005)(76176011)(71200400001)(33656002)(7696005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3552;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 46uOYyNu754Wq82F90plTmtp6cJmIGV2pUZgl9VN3SzfWKrMCUl19BX1LvJs/6AGAaD2hXLI8WCap3JTyfPGizGmvPhgWwdOkYWjtwzwbxERhMrmBewZa3dEabmJWOnJkRHWV+wRhPy5KDe2Td3PRdbLkYYs/tFjIbgGuIDQ3hkcH1damCFT4pOmUJ+7Wkz2ZOzrDF127U5Rmg1nEj/cInkH/GuMdBErPzWBklsNrAfiyPNhk757vS7BKteOLzKhBE9Bta3Uc7LHtkZHP38Ipg+L90JWFbrbxzJcJFM8ULIs9x1P7KNtSJFXby1pzQdB6NfSHpTnWQfCt0XcET6i6OSAEF6cUuwLAKgNzUxoHJgAtIhr6gAmRvTeqQsr2jy2OAgFJvnqusQ97UGgSGLkOoWfYh2R/EwfdLJz9j0xiFURMoQKeQHiiCMs+OXUYUtp
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5313c76-42b9-49d8-1fc2-08d76d0429b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 15:21:34.1835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CqoYY+YWoUrwh6HHfLIzWIHoLS1JeSMiUx4Qsjlb/SttSNTV3U6pjdVo4Xv23LM39Meyguuq5JYRZaL1YSWUqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Change the return code of caam_jr_enqueue function to -EINPROGRESS, in=0A=
> case of success, -ENOSPC in case the CAAM is busy (has no space left=0A=
> in job ring queue), -EIO if it cannot map the caller's descriptor.=0A=
> =0A=
> Update, also, the cases for resource-freeing for each algorithm type.=0A=
> =0A=
It probably would've been worth saying *why* these changes are needed.=0A=
=0A=
Even though the patch is part of a patch set adding "backlogging support",=
=0A=
this grouping won't be visible in git log.=0A=
=0A=
There's another reason however for the -EBUSY -> -ENOSPC change,=0A=
i.e. commit 6b80ea389a0b ("crypto: change transient busy return code to -EN=
OSPC")=0A=
=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
