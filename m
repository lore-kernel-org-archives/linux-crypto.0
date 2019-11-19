Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7C0C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BB1F222B0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="fPYbFEu9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfKSPGw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:06:52 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:6069
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728183AbfKSPGv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:06:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHCOGUGQ3Jrm6MjpwTHDr8turWDsxAKlPKp0aZT5Fc3nUfjGriSvnFK12LLroLLg0IApefTl30jz27PMyHJIqiYGig5aiAY5+rYg4J2HibGdsrFdUFhG1BBZ9hvKSJqiiUgwtLIFab7I8TTLjO1JA+5pZDBod6VmOJN05LcqzE0EZECEj63O8JE9IRjcRLKjQfLKXnQeFOii8ZjrzPg/R3p4tUA+vp/urRZsqGaT/47KS2ff++L6B2HhYtVkm8FOW12XOM3taGsR2oXn3e+cvalV3VaDcTcvL+A5RHxPblKj9FAKccX85jc7GEuJy0ZmcJ/i+GSMTccUIG4h/MiQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Idkh/xqgBlrEs054AVuq2VLyBHuLFRPtOBflyt4hIL0=;
 b=EmosnYE93ZLTvy4vDJcTVOB45keRU0w4FJ5c49j7NPipSZF2Nf7JuHXpomqLI0c+W3kooGVB/VNdBDZAoh5Jcj+HnG9Hq0+CtwCI/PM6ywtl83SVGtMoPFH02jVagFT+VNQrYUIdMr/NBKGl4b/NrfSm4ODCoN0jfyh5mYZlA6e6Ltef2GmlTLuvX5Q2eCcXQtXIDiOtnryY20YTD5/NCNFdnT214JIfX/uNorKu2yiVQ9KcpzS3JMpwKfFstAmJuXKKqRvdvej6KHofzTxWrkFOXeFntB4dyIBtBrw1l9mVVLWE28s8pl14N1hPpKWfdATZeaPA6nT8mAYcC+stPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Idkh/xqgBlrEs054AVuq2VLyBHuLFRPtOBflyt4hIL0=;
 b=fPYbFEu9f43ITgeBGC90eYHBFwKJowdaSZpbYDN51H0/bdd+nvQbMu3xSg3NP13fegaG2HgA/swXqjeR6j9rbCjJj+QTD4+TkUvHS01pkJ43AwFFVnV3m88HUtbpfEU7t1fyMKnffDzSihGnyxMzeMPxmw5w3kZJ52BIM50t6AA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2927.eurprd04.prod.outlook.com (10.175.23.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 15:06:48 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 15:06:48 +0000
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
Subject: Re: [PATCH 05/12] crypto: caam - refactor RSA private key _done
 callbacks
Thread-Topic: [PATCH 05/12] crypto: caam - refactor RSA private key _done
 callbacks
Thread-Index: AQHVnZazsI3fpRN49USmTfGT8iFAAw==
Date:   Tue, 19 Nov 2019 15:06:48 +0000
Message-ID: <VI1PR0402MB34857BE41F9A3571F0D2C0BF984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-6-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f6ad517-f679-4556-1f3b-08d76d0219e3
x-ms-traffictypediagnostic: VI1PR0402MB2927:|VI1PR0402MB2927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2927F14316A051159A1FDE2C984C0@VI1PR0402MB2927.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:425;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(189003)(199004)(558084003)(52536014)(186003)(74316002)(5660300002)(256004)(26005)(476003)(91956017)(102836004)(446003)(6506007)(66556008)(66066001)(486006)(64756008)(66446008)(44832011)(66476007)(53546011)(76176011)(76116006)(33656002)(7696005)(3846002)(6116002)(6246003)(55016002)(229853002)(6636002)(71190400001)(25786009)(66946007)(71200400001)(86362001)(478600001)(14454004)(54906003)(2906002)(8676002)(305945005)(8936002)(7736002)(4326008)(99286004)(316002)(6436002)(110136005)(81156014)(81166006)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2927;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c+FQ5g0JnGwf3mxvA2uFCO9P47Y+ln/zEclTjBf/waLgW1n24pX50XSt5QtLgpwzQVv1udbnSU8EFpPqN34YwIiRWnisEsWbSyKrH1aPPLgvBn9SmahlJIq+crurDL6bwF8P+8X2h419/ZlM+w6IA9GwwfDv6D9VZ/fL8lbXexLoLPNwtSbHrrfqJEJmlQLTOEmLxA8UBKJcGMzm9dIQbIpiCzr2EYNgZkc5WLTwrqHXjv0mTTRVW7RjzzZV4V6x4WJUruDPBIMsrTpgYWmHyjhTXO2LtvYnijeTijL2ZnDGp/dR4LI1o/QSB5/b+WYt6kl6KBQccvJnH4HC01wRAWlkHFm08iKB1673g54N2lJamVASz32Nsu0H5w/k/qTqsSs400PCQL9StkCdKFitCyBxwJJSR478eJT1TF1HlcOmKjCvZDcDAUlnKPYsKv99
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6ad517-f679-4556-1f3b-08d76d0219e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 15:06:48.6952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2j0/KO1hTRn4J1kfX5VWYwPfn7upBuRnOuCJUcATPx+G3eyiJf1IR2TsU1+Rl5jG+vTIrRT+pMOuK155+Nv1wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2927
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Create a common rsa_priv_f_done function, which based=0A=
> on private key form calls the specific unmap function.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
