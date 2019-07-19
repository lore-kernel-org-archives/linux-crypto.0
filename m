Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42464C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE3342184E
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CCXCB7/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbfGSQy1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:54:27 -0400
Received: from mail-eopbgr00080.outbound.protection.outlook.com ([40.107.0.80]:54020
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727717AbfGSQy1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 12:54:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3qvtkes1gMnIZhRO/KCADEcXvkW4cChBBjTUWIqvQ7e7d3qm+PH8n+KujCHpL7wj9IkLotEFgVUfN+X2YKDhNMwWQI/8jDdOnGJkvD+ZNhZcAUxstiAV4tXjILGJN/5AZzQxJ10yvtWIswFwVOe+wGlwPzITKFkp+WrIFxdIo6iALhW12QdV1yUfNT85wfo7UB8Q3g//3j1Yyiw9E9LpATWy/aO7kzeFIecjWMsNPcPSFufO/3Wve7cUYvRMhBUcf5PFXma/YVrr6QnlhLL2SEF7b9OKV0fFtmEOAAyL0KTz3ACvDI3GHrwFJ1Gy4qRZ3MepfvkLQe9WuAoG1aeiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kja2S85RDloG+p8N6O3qZiR8zxkUy9/1g54+ViR6xxs=;
 b=dwc2aabElo7RzgLYgdZNiM2xAj0t3C4yXm6Nh/RIO1RF3wMikIPixakuJqKNm2TzfS+jwjJvLPQAcEK7cU9Q+mMtjDRGCKKPWzLidYGJwG9xfo0GZxleOnFLdP0IBNVJPherKqQcI7PfBC3eFziiY1/EOkVuWv9ZbN3mbjiWFbbXHZRWC9SevEsACkO27rnKoAg21f5eJnT/EFbfjyrrFvxWLUGuV6mQyHfU9wq52M8JXeghBDSMjNAI7dXZy96y5DjrCTSGeNyA2mHETvDw0ywZp1YgtLqvPtEqcND5L6elix25RK1S7TntqY2zUKTE0uWQI3MzII68g1C2uePKlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kja2S85RDloG+p8N6O3qZiR8zxkUy9/1g54+ViR6xxs=;
 b=CCXCB7/97px9tTRxVDcgvr5e6u+u9SivxX5YLnVSILdJQaizpr9dAhvffyKREl6ExGiZQ4oYOFNgxP0G/ESThY+00kdM6072f9v856pOzmfUUJ0n3LeEpcPnZxXXWXaqeH62MrRa3LiBIYAgroHns9aAbutTYRu5Cps2DivgQic=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3471.eurprd04.prod.outlook.com (52.134.3.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 16:54:24 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 16:54:24 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - move shared symbols in a common location
Thread-Topic: [PATCH] crypto: caam - move shared symbols in a common location
Thread-Index: AQHVPXf545kw5yPbckquQ4tXhhNyVQ==
Date:   Fri, 19 Jul 2019 16:54:24 +0000
Message-ID: <VI1PR0402MB348518BD7B051CBA90DAFF4998CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563461349-24876-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e7f8979-ff02-436e-e4ed-08d70c69c0da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3471;
x-ms-traffictypediagnostic: VI1PR0402MB3471:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB347196C08EFEAE3ED11679C398CB0@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(199004)(189003)(6636002)(3846002)(74316002)(305945005)(2906002)(186003)(66066001)(6116002)(14454004)(7736002)(8676002)(33656002)(68736007)(102836004)(966005)(6436002)(478600001)(6506007)(53546011)(26005)(25786009)(7696005)(76176011)(53936002)(4744005)(81166006)(6246003)(86362001)(8936002)(71190400001)(71200400001)(99286004)(44832011)(4326008)(486006)(66946007)(66476007)(64756008)(66446008)(446003)(229853002)(66556008)(81156014)(476003)(91956017)(76116006)(6306002)(9686003)(55016002)(256004)(316002)(54906003)(110136005)(5660300002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3471;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gmSNR8F0myLoa86vGzMRWH+NmbfmT9NSgy1U+Qx9soyrHabZLqewLtINMEu9S9SSxd1DQaIkRpcxIFIRmbK8a2buTVY2pU8hxgbtDCb6Gk9Dbf5YbxjX3cRabE9hogPRkjVbFx5nySbFFdgwS+5/RW2e6w0LMRJ1No41SvGzyzLTdJ51EsW1ZgyW4GFmHVCPPcoyyscOAgNpMLiV0z8GaZNh8zYESBIwgTlNBuOunO7JeAm2duzeejhY7WSzjieLa3tgm6NkU4tCaEB7n7n60ZTll11fKrwMJGzw1JCr6uvisVbpNqoSC0hlyik1RhiB3w58euPSt0txAPPkIvv+En/mDzAY+wbZnvYh+4J3mWoIDKzzS70Pk8IkxOF9Ud/mkru//oVD9LlFlQTQ9KE0SxHJqVGK5wHQ2B8WBQYU+Dg=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7f8979-ff02-436e-e4ed-08d70c69c0da
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:54:24.1895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/18/2019 5:49 PM, Iuliana Prodan wrote:=0A=
> Moved to a common location the symbols shared by all CAAM drivers (jr,=0A=
> qi, qi2).=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
> ---=0A=
> This patch depends on series:=0A=
> https://patchwork.kernel.org/project/linux-crypto/list/?series=3D147479=
=0A=
> =0A=
Note however that the patch will have to be respinned,=0A=
since common_if needs to be reworked according to:=0A=
https://lore.kernel.org/linux-crypto/20190719151526.uqvg4q4pbpztojnv@gondor=
.apana.org.au/=0A=
i.e. generic helpers should be moved into crypto API=0A=
=0A=
Horia=0A=
=0A=
