Return-Path: <SRS0=1Cfx=ZR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EB0C432C3
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 18:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E800120679
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 18:00:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="by/zC5UQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfKYSAm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:00:42 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:46722
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfKYSAm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Nov 2019 13:00:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MC5tbBL45mQY74WHpa5W+qUuW2me7WrglIyRefwe+Gqp3noLrYaa0jTRtS8LxgxT8F98GdL0f+OUQGm/YRBq98MAX+5xo8NWAkftZJreo6AKGUIYenRHVHgPPEehjn+GzQopCpYy3bnK/LujpL03jFPQ06Dsjbwqwdp3qKVumRcaVouAvRIGRD7NGyB5XHSPCH+cIIuKZmYu/SktZiGop3TNvIr1R0D6M15Kpj6tMKdYTegPdNe7AMbIAKucKe3tfilr/ouViHNH7nAksqlo1tLSolHRWHrp/NFX2Iu4TfpUsnc4aBaWRHaGzKtY+hQCF3O8ZPyB9S1cnNL8qOTcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzZFIW+Bmqkr+ah9ZFrfXBvLi8IuPaAGXXyFMuiiRWQ=;
 b=ZkUO3mmiewdTcZKoVxtjUCtMKh9KuUCH6IHXnvSzFtPbkWWMFZlVGAVlwSQP9fdst+SoYpNHf6q1610zHwZWYlK4pX/GFcIuhDVVA54IPeWLAwGH5jll1argF3tMqhgCSfAyP6415T8oC0oKCRuwvAIvLxZe4u1qo8VzguvyX9kq7jRK4U9/bMILco+X5sa5acv2Zmpmu9zzR6YSs89B/5U/aeI0lRFbsy21KDqsPnpbkrAAwtSHr62lzA78yCfbK0MDuRvzu9waNM21QLejnzVWs2/+ficSSS599myeWWyFCdQTaCI5XJZf4lbxPQMN+eOdNmzP8Vta4blMBD57rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzZFIW+Bmqkr+ah9ZFrfXBvLi8IuPaAGXXyFMuiiRWQ=;
 b=by/zC5UQzcXrcdspztvsljV1+kjixnhFlxZHC75NZGYEPMGwc8Kjkac3vcWt28CtGeBIKxlwQOBuK1GcY/RcxUifkAkITLaU6p/POFYgYruXceCpJOykGmpTxoCQ7WOO9IgQR022Y03BnN5nm3oMFhDvgP59MxzdYqeO6+eqhbw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2768.eurprd04.prod.outlook.com (10.175.24.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Mon, 25 Nov 2019 18:00:38 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 18:00:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Alison Wang <alison.wang@nxp.com>
Subject: Re: [PATCH] crypto: caam - do not reset pointer size if caam_ptr_size
 is 64 bits
Thread-Topic: [PATCH] crypto: caam - do not reset pointer size if
 caam_ptr_size is 64 bits
Thread-Index: AQHVoxctUNzeX8yZBkC+zm/l8nUrRQ==
Date:   Mon, 25 Nov 2019 18:00:38 +0000
Message-ID: <VI1PR0402MB3485FCCAA68F78EAA9F1B360984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574634784-10571-1-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB34857C5B83AC9811BB87F419984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR04MB44455C61E2D64EFF88CE39768C4A0@VI1PR04MB4445.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 175346c2-961e-4c20-6abe-08d771d1612a
x-ms-traffictypediagnostic: VI1PR0402MB2768:|VI1PR0402MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB27683A764395B9E1FB048563984A0@VI1PR0402MB2768.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(189003)(199004)(66946007)(76116006)(91956017)(6116002)(54906003)(66476007)(14454004)(86362001)(3846002)(558084003)(446003)(6436002)(2906002)(33656002)(4326008)(25786009)(55016002)(44832011)(256004)(74316002)(305945005)(8676002)(186003)(7736002)(478600001)(9686003)(229853002)(81166006)(102836004)(26005)(99286004)(52536014)(8936002)(6246003)(66446008)(316002)(64756008)(66556008)(5660300002)(7696005)(71200400001)(76176011)(71190400001)(110136005)(6506007)(53546011)(66066001)(6636002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2768;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aRThMw85jlpfjuzJpcwZRN+oG4PXSn6LDD+FtmR/xwwvZ9x/ZIAAd+uqKq2nFsXxSpkbZmynKn1hsV1HTG2gX1Q6yhFOkXSnRElImHQIiHkPzFjA2tkFygT2uorg/qwbPi6vaHeNSrphD6TGsK0FsJI8IgqYsOfCIZgcXR2n41X7enskR7T4K7G+VkfPaX4mNAT84GjtVeV5B6F4Xnv4mbfT1MSImvfjh8kfVzsHE4kLTIFLzi1+vDdv/8PkxXG4uGhaa9GC7c9AXza/wZecQ23+ZLk40wTDOzUE+nu5etSDjASn72SKdiSVIi3lyn+qSM2/J4WOJL83CqM2zpVePKpRXdUuccKpaBwMYdIRSV3TP8LvOuOwLjQdEs2b+WjrdEEfzHpuJ7fA57N+1OOQnuMxLRoqIgrW74esV7r/1Kwk6TNtItff4AY+h/RW4m1/
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175346c2-961e-4c20-6abe-08d771d1612a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 18:00:38.7258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLe1X7q2IvmhGl8o1Pd3I+uq7g/G2mCk3M2afxUT6qg6b38t6PM3exoW+utJtqdnDFQMqmcApGCc0MIgUWgHAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2768
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/25/2019 2:02 PM, Iuliana Prodan wrote:=0A=
> So, what's your suggestion? We shouldn't reset the MCFGR[PS] at all? We =
=0A=
> should use the value set by u-boot?=0A=
> Yes.=0A=
=0A=
Horia=0A=
