Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6032AC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3BE2186A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="oMj0kjVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbfGSQCr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:02:47 -0400
Received: from mail-eopbgr30072.outbound.protection.outlook.com ([40.107.3.72]:41779
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727927AbfGSQCr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 12:02:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYeMI6sNTU0lyKdC0B8n0j0NYc8OoA+6wBNgcTopm7WGqpPS+UTww93ITnW2o8yImzzCalFmIyxhUmdkk62DlJj7hnc78PttVG906vPmTmXl2Grq/3zphwDXr9x1D3M9hj+Z9iVp6tD9dSArDQbVoG8Zwt/aQ/FwbXJYS7T2uzerOTmpz7KpMXO/douO0s/OAYbfDB8RWQhHVCxFrwGIP1jFE5xZzDtJRTLw+c2XVKkbD5fGkgN3eop4vBSNJNrh7N83l/XDHTCAHxGNM7WtjYtbdHZTAVr2of85/h6e/hgkknR7RvS9AErCxZgNpaFFSTXmZSN9fxiO4SSWm392qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9vK4Kan4j/X0Wzb5RYjPaesAla3B3x24HiV3OqTgow=;
 b=LB8PqEA2nwgiuahO5bu2p6Hf3+Caczgerg3rabGm6/NxNkqk7zlQgwekfL/+i+TUmdE4+BPjE9RgWLMYZo3QKZZUxvqIzh5kYbi3CL+oBkTIKl6mDfZVBvhahJn2jFxgmACK6xrU+JxO3qXlwSKNjN99g7KrsZOhtJosTbHPfiWFuLdFHbiAzIFKgywkBPatVaf+R1NuQLf3I0iEUEMcYV2rt8J0+a0azjQ148z218S9AVfmYqaz2oFVTeVYAZULRPteuXAPg9LOkMTfx0Tg9h1tzYEyJ2yI25kX0STE6OLco7WM3CSXX55qQXrNL3IoyIlW9asbX6z9JrOXpcN+Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9vK4Kan4j/X0Wzb5RYjPaesAla3B3x24HiV3OqTgow=;
 b=oMj0kjVMBKfpOEIdEivuisbdoNW5l9ErFaJK5/ZW5ffMubMsxlxlo0mgi3x/zKLojkNcjcHjMhnUCKDFYLzNrI1JbELAtKg3EthecmgSL+dZUGnzwNt554pTGelwTngjkRF6juZwG8/w8bEURCiK1uWv/mUYlRLMq+Qzfku8TnI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2703.eurprd04.prod.outlook.com (10.172.255.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 16:02:43 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 16:02:43 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 12/14] crypto: caam - execute module exit point only if
 necessary
Thread-Topic: [PATCH v2 12/14] crypto: caam - execute module exit point only
 if necessary
Thread-Index: AQHVPcStiAIT9TbcE0SDhHkawC8d2w==
Date:   Fri, 19 Jul 2019 16:02:43 +0000
Message-ID: <VI1PR0402MB348569A551EE8B9AA99FF2D898CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-13-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5dcaa5c-e979-4d96-6aa4-08d70c6288b1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2703;
x-ms-traffictypediagnostic: VI1PR0402MB2703:
x-microsoft-antispam-prvs: <VI1PR0402MB2703BA7A7B8B573C637ED7A098CB0@VI1PR0402MB2703.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(199004)(189003)(44832011)(486006)(3846002)(6116002)(7696005)(229853002)(55016002)(6436002)(66476007)(66556008)(64756008)(6636002)(2906002)(4326008)(14454004)(91956017)(71200400001)(66946007)(66446008)(71190400001)(76116006)(256004)(6246003)(53936002)(9686003)(8936002)(25786009)(446003)(33656002)(476003)(305945005)(7736002)(478600001)(5660300002)(52536014)(76176011)(53546011)(6506007)(102836004)(26005)(186003)(81166006)(74316002)(68736007)(99286004)(86362001)(66066001)(54906003)(81156014)(110136005)(8676002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2703;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QU1/vFJCnkooUq80XOhOiIF/2M4L76JUdje0BGu1V+c+bjWptBA4xvKxth+lY+022iWBeMD8+za0ySvHkRpJHePdPj99q4WxDYs7kyFLoIIsTDv/3KpI9fdS7SMUDOAsHxvLCmJaqzXJo5R4yaVdD8zuTcO++IRe+Fzk1+mU+FjZE12coRi1YxXRmi1BbzNd8PpeU36+/aWZOHT2zikDoeBNml7/g+X/JMMUd7WEM7jTIKeUbmEosWdNj1sSJFQ1+hjPKoFR53pbLX5wQxZTfmYfw5Eddr4YLvFTLV2nuPkLQvTlDCXw5fmtFeFpLLHRHmidPkYDXgPydaEQYA7TKsfMQIjgM+QLHDw9WXF8iwizdkChaCGL5T4uh5zvlhBlHnl+7Z1Mh4zfvcS1mL5AYel5c4Lr6/e3ETeM6QhZ/I8=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dcaa5c-e979-4d96-6aa4-08d70c6288b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:02:43.5241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2703
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> Commit 1b46c90c8e00 ("crypto: caam - convert top level drivers to librari=
es")=0A=
> changed entry and exit points behavior for caamalg,=0A=
> caamalg_qi, caamalg_qi2, caamhash, caampkc, caamrng.=0A=
> =0A=
> For example, previously caam_pkc_init() and caam_pkc_exit() were=0A=
> module entry/exit points. This means that if an error would happen=0A=
> in caam_pkc_init(), then caam_pkc_exit() wouldn't have been called.=0A=
> After the mentioned commit, caam_pkc_init() and caam_pkc_exit()=0A=
> are manually called - from jr.c. caam_pkc_exit() is called=0A=
> unconditionally, even if caam_pkc_init() failed.=0A=
> =0A=
> Added a global variable to keep the status of the algorithm=0A=
> registration and free of resources.=0A=
> The exit point of caampkc/caamrng module is executed only if the=0A=
> registration was successful. Therefore we avoid double free of=0A=
> resources in case the algorithm registration failed.=0A=
> =0A=
> Fixes: 1b46c90c8e00 ("crypto: caam - convert top level drivers to librari=
es")=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Horia=0A=
