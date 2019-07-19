Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A46C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50E6121872
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kitO/d/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfGSQWd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:22:33 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:31878
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728051AbfGSQWd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 12:22:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M22pN9Xr2NnF6NNBIELY2MKwfd/Ww442i97azfL6RE07Ur941UQh8KJS7gyj2gozPn4t8hC2JEfdOeOGzDnFAhvmuz65tlWtcSSZgK8z9vn01Jbbs/xB+cTx169v+Vz6cp/X24gjisrqFCecAYcGLOa517o3ainSC7U1nXS/T0G4TLf/wCmFMr3VAWfF11NcVmsarUIdJY/4uGjR5z/XmSqAUN4KizvEL+Jfd7v3D3xX7PCHIACOezoVwTFbM0g6HsR1MZFpswDx9bCsujVrlV0mQ3ukhHavr4/QY3VowE9VtXK9MGfe6ndbP24WjMbFYAtogfoJ21C92qbe+zyXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXvMH3EYvtdQBLH+2TGWjHmrGTQAsV0nroFpuk2lFfQ=;
 b=YneFolO4Y5biUhlAC4xFCPqzWvh6o6hlcbG2OnnPxeV2556lMHAIAeYXXHkS8n/5eiv3eti1kSDJxoseCB9WZzffwHrtVhd73APA4kgZ8cTY3vMxS6lyEhHK5EDSKt2p0Ar/2lkMfpGvDQKxRTLa4VmSj6D/PMh88dIH+gl8ApJtlDfn3r1P1PfWkjvdXX68AiHgTjX8Qqnwfe4tyA8qOCLs4ScRv6WS1Teb+6rXEZYQRUKZDt7DBEk/r9ySV7aan0UXd3+c67oPlFAdfJOctEQYGt1d/6ct0eUJwdli95cqzz4IjCnLJzJBBnjEqz/LBEY26yx0GOPBfdA0IL9npg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXvMH3EYvtdQBLH+2TGWjHmrGTQAsV0nroFpuk2lFfQ=;
 b=kitO/d/XaOvd0UqYTODNG0QAPX+TPY2zty6cc6y34k2tZh+cYl5bukzXlYCwEt2tH1AReVARoHxA46siwg8ACNnXq5GSoXLXNYsiB2kw3PC5Q0SQO/6R0Gc6qehdEWn5x604bQ1pjBTAnyxCd0l7T5mxMbr1Ke3a0JkzLbStFyM=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3503.eurprd04.prod.outlook.com (52.134.4.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 16:22:30 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 16:22:30 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 13/14] crypto: caam - unregister algorithm only if the
 registration succeeded
Thread-Topic: [PATCH v2 13/14] crypto: caam - unregister algorithm only if the
 registration succeeded
Thread-Index: AQHVPcSsFwzUAMu1w0K2RlACiJdUtg==
Date:   Fri, 19 Jul 2019 16:22:30 +0000
Message-ID: <VI1PR0402MB34850F9DBB14236022D6B7E198CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-14-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d81a2ea-2a19-4b01-3951-08d70c654c38
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3503;
x-ms-traffictypediagnostic: VI1PR0402MB3503:
x-microsoft-antispam-prvs: <VI1PR0402MB350382D61736C692EC43303898CB0@VI1PR0402MB3503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(189003)(199004)(71200400001)(71190400001)(8936002)(4326008)(486006)(99286004)(44832011)(4744005)(52536014)(86362001)(6246003)(81166006)(256004)(316002)(110136005)(54906003)(5660300002)(91956017)(476003)(81156014)(53936002)(66476007)(66556008)(66946007)(229853002)(446003)(66446008)(64756008)(76116006)(9686003)(55016002)(7736002)(305945005)(74316002)(3846002)(6636002)(66066001)(2906002)(186003)(6506007)(53546011)(26005)(25786009)(7696005)(76176011)(68736007)(8676002)(33656002)(6436002)(14454004)(6116002)(478600001)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3503;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CD5lxbfX0PjbSZd47Gmo0ebeZpCAZ8wI5orK6dKyQ3M9PxRavLGoe7GDMh2xVsYjErIPdTGXTBjBusdert8tWGh1MEbSEJzOYVp4W0w34SauKwrdpV1MTpOGRdSV69DwMZc/NkLJ/XMX/8j4r8e01mF5Vj1ITmh1RmHNdo+li5DagWyAiJqtGqsFOWJBQbgfP23Nclu2HLJ3LCRqjqUvqhN+1Ayd/Zdw1tP5eDZbD+OTZWL70jcYWXS46YQhn8dmmwVLw1UvURrUuoHjTMm5tZ/yODX7pIG5+9GpfGT2eeRhVYpHAf+ogXNdccid+w/GDkt8rF58ogo/0vKF94BUrltq4LppzebgaSnp8h6sA6stoI+ZBBbvpItsvAVcR9oHf3zjWArRcm6NMcuhVNiov3cYZYvqm7tn+JABkcyAnIM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d81a2ea-2a19-4b01-3951-08d70c654c38
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:22:30.5178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3503
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> To know if a registration succeeded added a new struct,=0A=
> caam_akcipher_alg, that keeps, also, the registration status.=0A=
> This status is updated in caam_pkc_init and verified in=0A=
> caam_pkc_exit to unregister an algorithm.=0A=
> =0A=
Fixes: 1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries=
")=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Horia=0A=
