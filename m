Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5431C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95CE21872
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CY4IvMAE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbfGSQ0K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:26:10 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:64321
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727602AbfGSQ0K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 12:26:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZ+C1jx8XbwQx1aARJS3wMKnEOBOq3yjPX1LHyuN8IMXNSTGdCFHBEj9+x7UvQnQvWqL5rlZNG6P4/c7NpqhIsKoCImXepjFwxmcArZvVmyh5sO+PJ/pSY6+KjjCk9dXy9L6DOvxAfaskdP6RO2tHyJkkFMFLEQowhR5wAMzl+JJH6PBKkbSQymh01xmlVl76BqP/y36cX4Uf3VTfrW4dW9z22HLOTj2lgkc1pfSPAHoxSpf+Qv4AYzLED/XKSVNqZuWl0NUG0/fEErs6qTGBE73FJZigtLm49m3uQvNQrVN3+IZyxLAmNzX2AMWK6CM/aIFHanOHlncgfxEsczaiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ispZD/cF8C0dTRVVVe5vJyHpdCpFzD8ukydhIufDedg=;
 b=AfRRvuJ7H2M8e2iErDkG/EryRxrVZL2IqDvgyfsDXPn0YNFkFhW65QQLfndEFc+tluaX5GDMMkf0F1CA5mwgbFoSDzYnNO8N/OHS+AXwT9qf+VCYvb7k38x4Ss5MglFchDnk9zkkKYoEgfeKIberdA6Y5zzgm8X/+2a5jA/H96xn4cOJGieLLOcnRdXHOYS/KXdzP1sChSHJgXKWXivx6VSUuGJ/YkIKPtBk6pTdPS+2sgMZne3Pj0BuGuHY6p+iXrhH95AAALOVLlEtjMLic4lKtQ3JCod24gk+CxWpNJPYihU6ZWPumkg+wG0xBzmc6AYpECOeUhQMKrDBH3cg+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ispZD/cF8C0dTRVVVe5vJyHpdCpFzD8ukydhIufDedg=;
 b=CY4IvMAENXbl5n3I8D0S7NgvxTToyFWNiLdcrBE4JMYYwIz2MS98m/UMzd7RazUAPFRUL/orBdXGuwKDxHDW4t6xCznlg5w7lT8KFTZabNx3tcNbe80+O0LshztITO21anmXIHWgnOAkb2HC7KLkwfNbmsDCP6U9I1oH5zQzU3o=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2896.eurprd04.prod.outlook.com (10.175.23.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 16:26:06 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 16:26:06 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 14/14] crypto: caam - change return value in case CAAM
 has no MDHA
Thread-Topic: [PATCH v2 14/14] crypto: caam - change return value in case CAAM
 has no MDHA
Thread-Index: AQHVPcStE+bX21wLbUG0wjauqQHVJQ==
Date:   Fri, 19 Jul 2019 16:26:06 +0000
Message-ID: <VI1PR0402MB3485A340013C46A5163C74DD98CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-15-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd4091c0-2501-4b9d-f077-08d70c65cd0c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2896;
x-ms-traffictypediagnostic: VI1PR0402MB2896:
x-microsoft-antispam-prvs: <VI1PR0402MB2896DFAAE18BC1437EEED4C398CB0@VI1PR0402MB2896.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:226;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(189003)(199004)(76116006)(66946007)(91956017)(14454004)(8676002)(66446008)(68736007)(52536014)(33656002)(66066001)(66556008)(478600001)(86362001)(25786009)(74316002)(4744005)(66476007)(7736002)(305945005)(64756008)(229853002)(2906002)(6636002)(4326008)(256004)(44832011)(486006)(81156014)(8936002)(81166006)(55016002)(9686003)(6436002)(5660300002)(6246003)(99286004)(316002)(54906003)(110136005)(53936002)(102836004)(476003)(6506007)(53546011)(71190400001)(71200400001)(7696005)(76176011)(3846002)(6116002)(26005)(446003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2896;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3MkWA1l4mTXc20XaMP/v8Q7l5XDy7aJ+ayKc6oAP/fqsijix9uAJMTJwlaPZdsE9iAsbHKLWwayDS78ZSuH4h5WtRh0gyrIFXKBO8xlNnPqnuTh5vYvsqCo2dbejj1oWmumqXdeUq/hmtvdYFwZ6m93LvdIOOFScB9DwCucu5mgfrcUsz2/8YDZ0w0TuK4ILRE3zZEXm1wYQpDgBHKtizL9NpNFNdzNUul306chAY9VJbLmV61ie0zKEZMluGcxOxQcGpzNNGy5AMR5mtKBvdGbh9IsHPoxzpREqreVB6+vlDKggQRerWoh6IcLCEzocIF0zQMRmoc1HkLYZmRvh6CkguX04XigKNJBD0dyh4L9hi7UXCUm3jhAHp0BtKVusYcbulOsfpSQBGocHYc1FAK61AfoAYXH0/z8swTOJ87c=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4091c0-2501-4b9d-f077-08d70c65cd0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:26:06.6542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2896
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> To be consistent with other CAAM modules, caamhash should return 0=0A=
> instead of -ENODEV in case CAAM has no MDHA.=0A=
> =0A=
> Based on commit 1b46c90c8e00 ("crypto: caam - convert top level drivers t=
o libraries")=0A=
> the value returned by entry point is never checked and=0A=
> the exit point is always executed.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Horia=0A=
