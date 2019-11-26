Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CABC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 22:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24EE42075C
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 22:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="fpCxA0Qu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfKZWZn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 17:25:43 -0500
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:24223
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726103AbfKZWZn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 17:25:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWFWIjxVBwpnB2QeYiCBC55tzMNmO8lo3p6SaupvmYhlMIehzxKYSkr06vrj1insmmYTgJfVTtGJGYFX6KRdQ40Swq1ESKEJBYmbmTHoJ+uqH0Hg8Yrt+Kk6LDYHveQR0gLU2ZRuLSzc19USSKNXQhBqgqSaUp0UKftH7f/lvaTVwAlTznpgS00NJSdXVl6eIYSUTUvutiKr37Ys+h7rvxlaljP9QRjaoLphkyfU1cJzOGI399iGhvdLRnv04eOWvtsEgDzYhqLTueWLAJ4imSEMDrkMeA87tw9/IF4vuMLhDXVZyrzHFVs6MFY6VSrhM5/u9yXAI3XBsWfiitamPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCAfHV0lMw5dGUwYR13mR7GbXcJGHbMqLetpo3r/H/w=;
 b=d1vUczcyCgCLQbpSMtA1cuTKgVQcspI4tmLx4tEzcss1UT3z2Dn9xGcVuvyVIS+OkMpQrOYGDdhxf2uNyPJsyk999cuul+O+QPCR1Spmsepecq+bv4cKWhhiOQcxViQtIKlRIJVwb7lLxegid9Ws7+r7PkUp4Yat5TplmsxY/sqjbBUxCZm/0JivPocuApFSVK0Tz+JTMQg+9NhWCBxGvEtop9vfHxQ1eXdNJXYOPyJVkDvuoiPSJ7tLpnkueTOYp8Piax1eaxWyaJGk3aBbyRumc243e37bVYpSVv24JrWzlFM0gp9LO0WlK5Ii0KksGsfaPvbhiKkoyMiRdPZK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCAfHV0lMw5dGUwYR13mR7GbXcJGHbMqLetpo3r/H/w=;
 b=fpCxA0QuFZIIPY0xtGllX1q7RUjZJ1U42Tl9mBXVoGvTLMtDle4Jio+gkdUNDHT5ezj4RE2datCaFE+CFuZ1ODas1J+rjnS3+RsMaDtSMPNrtLfYOV48ADO7GMGjS6ea4AhySp5uisgbA6r9PbaYKrLlky5dFnKq1nOLUGYyYDs=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB3998.eurprd04.prod.outlook.com (52.134.122.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Tue, 26 Nov 2019 22:25:39 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d%5]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 22:25:39 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Alison Wang <alison.wang@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2] crypto: caam - do not reset pointer size from MCFGR
 register
Thread-Topic: [PATCH v2] crypto: caam - do not reset pointer size from MCFGR
 register
Thread-Index: AQHVpFRU4thNKQr6WUKZ9I2dDwrpAA==
Date:   Tue, 26 Nov 2019 22:25:38 +0000
Message-ID: <VI1PR04MB4445DBB28CDB92553B5BDB8C8C450@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574771003-17208-1-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB3485B4E651C554ECC0D91BF998450@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [188.27.86.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a266a698-3882-4417-f757-08d772bf90e6
x-ms-traffictypediagnostic: VI1PR04MB3998:|VI1PR04MB3998:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3998537511F1EA8582B299858C450@VI1PR04MB3998.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:218;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(110136005)(7696005)(305945005)(55016002)(54906003)(6506007)(53546011)(3846002)(6116002)(4326008)(71200400001)(71190400001)(256004)(9686003)(316002)(6246003)(478600001)(102836004)(14454004)(99286004)(76176011)(2906002)(33656002)(66946007)(66446008)(64756008)(66556008)(25786009)(4744005)(76116006)(52536014)(186003)(5660300002)(66476007)(26005)(6636002)(7736002)(74316002)(6436002)(229853002)(81156014)(8676002)(86362001)(44832011)(81166006)(66066001)(8936002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3998;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cmp3WiYPUh+aKdsK7adrHCFLYhqllRW+QIe+FIT8QlVvuil+w8uDyXPZQkd5zWlUThxERQamMggCzUcz8DHw7uIpL7GDG4I/p1JxzzOtDpnZ7WPj7sRa4BV2T0qhIsNKD4YE6AfOqDobJFzcdPy7pGSktAIwV0fppczWHdFr9ll0If0ay7Vr0IhgDxP8fOBEdbbRUMTViq+t7C8njXjtdqOSpEvAUr2OjGX3seaKfVzIJhNsO5ryl3KunEXzszP5ZcAhUgcDVKVGYGx/eJEc6sh3JGChLtfNMkyuK7ao5XH/ma0JTEyAwJvGImfmWxryDIXMqtvhJPfGmg+uSexk+9RJ1R5r58qTKGxeynlVf0AoJoqSzNLztPeTcm167jIxid/cQ/tdtI9jZHhE6eqZ0beV9IVUyzZbuCNIsTN8qDxT7Q89RacV1AafFv8Z2rME
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a266a698-3882-4417-f757-08d772bf90e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 22:25:38.9010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mnMRVrwvDun08uId1tjXVcTtBNU0nD0MzWJQv8ZnvX+w+qQ513fHoYT7mYC/2W+orneeQLCp0zQ82Qi26YUIrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3998
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/26/2019 7:03 PM, Horia Geanta wrote:=0A=
> On 11/26/2019 2:23 PM, Iuliana Prodan wrote:=0A=
>> In commit 'a1cf573ee95 ("crypto: caam - select DMA address=0A=
>> size at runtime")' CAAM pointer size (caam_ptr_size) is changed=0A=
> When quoting a commit, it shouldn't be split across several lines.=0A=
> =0A=
Right, I'll send a v3.=0A=
=0A=
>> from sizeof(dma_addr_t) to runtime value computed from MCFGR register.=
=0A=
>> Therefore, do not reset MCFGR[PS].=0A=
>>=0A=
>> Fixes: a1cf573ee95 ("crypto: caam - select DMA address size at runtime")=
=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> Cc: <stable@vger.kernel.org>=0A=
>> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
>> Cc: Alison Wang <alison.wang@nxp.com>=0A=
> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
Thanks,=0A=
Iulia=0A=
