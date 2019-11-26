Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4770C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 17:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D9892073F
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 17:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZYSjrdq7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfKZRDq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 12:03:46 -0500
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:39398
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727674AbfKZRDp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 12:03:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfJzHBdjZlFe1i/5o7CGd7yZwIcs6gS4OF7YKeugJgwb9QJZymrJuWk/1nx/I6Dfcbd0Pc6dIArGGnk5CY4xRBE98rbMu1DtO4EfhkGDiidz76w1NzrCdDB3waBxfr/9pMxf/XHhCzpyL6KbyVeSJYk1dfCFL98+xJby7ZQ3ZENzzTxvo0cZhx2uTo2JYRHK1SNhQNCjRZ4rT+JDK/fuTPst9KANqTvBkfeJWzetTK8TOTGLimgfbJC7lvLktLJ5IwszTBM+YQb/+2GItYsDt8EK6kiTxuXDs2zGHQSD49QbpxCwfzQXnp3QTWeBA86vBrtJL5pUmDNX5wYD8gAnAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzQluj4kON/3vA+0cSGYCjKVAZWpwEFQQm2uRS4p6dE=;
 b=lBIXdjOncVA1sbx76U0ehPlrW+Ph+KfCqKqLLBTQyv2yP+b8vuun3JXeRzswlzh2rKnRcQsYZjwXIyjW+P/2JJ0NkfcUV+/jtM6daIaJ67Lyuz/BYBAHsN9gffQ34GV7NMrAKCPv+/8X5Lb2XrToiSjLQyg+9RVTKlaTf780ml8omlSw/CrCR5r/WZUlcBeU872q4xCcGgGpclX2+3447Qt1u8y5vjxlKrf73LYrtWagaN9UWoY6LKMN5/spqVtl1arfaLt1ZGyxkHxlz/Tid8bfMZC59b9tRhBxw7pdcuuU2bymUNhF1xuHRK5BmHx5hQOM0aJcLIZr7okdR3yjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzQluj4kON/3vA+0cSGYCjKVAZWpwEFQQm2uRS4p6dE=;
 b=ZYSjrdq7ZWwr2QWNs5ISEWfULf+c1nsucI/ZLRMs8yRP8sEKXrDl0IoBHn6eEsWO+xEQXkd3or0mI4If9Gf4B9e1bncXbVLiNYOgUHD5ptvIumPIA3uEbWc+/LxLxHT1C69lkIXpgoO9EHeaNcAj/jaChsIyDakX37RI8ij9uGw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3405.eurprd04.prod.outlook.com (52.134.1.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Tue, 26 Nov 2019 17:03:42 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2495.014; Tue, 26 Nov 2019
 17:03:42 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
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
Thread-Index: AQHVpFRUdqDc3ecVmUOullCcW0ooTg==
Date:   Tue, 26 Nov 2019 17:03:42 +0000
Message-ID: <VI1PR0402MB3485B4E651C554ECC0D91BF998450@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574771003-17208-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c583cab-12ac-46a5-4320-08d772929787
x-ms-traffictypediagnostic: VI1PR0402MB3405:|VI1PR0402MB3405:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3405188A2C99C25FCBAAB0B398450@VI1PR0402MB3405.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:218;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(189003)(199004)(99286004)(478600001)(53546011)(81166006)(26005)(6506007)(55016002)(6636002)(446003)(25786009)(2906002)(74316002)(186003)(102836004)(81156014)(316002)(54906003)(110136005)(4326008)(6436002)(6246003)(9686003)(3846002)(44832011)(71200400001)(86362001)(71190400001)(8936002)(66066001)(5660300002)(33656002)(76176011)(64756008)(66556008)(6116002)(66446008)(66476007)(7696005)(66946007)(4744005)(305945005)(52536014)(76116006)(7736002)(14454004)(256004)(229853002)(8676002)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3405;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9pQFEP9/IRlj5R7eHeYhRelSNDkg1n0oYBmW1GBOn8FSEYvOhlGVi1aGVah/nxODCpAcdYyv3hoHLuonpOYk32FCMuu/QIDm3MHun8EzQnmH3VxNXr7Ou0zVoXl1SREXDLjU2e0aAlicjPvl2i0aKfDwHnMqSvwdf8vSQPdw3hOqEZ+IH+ZXsnj9+8l8eqO3abmJFjp7+CNIF3Fq5IEYTtwfBpah7/96eEmI4kfc3YQK17WQLVxLtUhbNjmtEAEPuBpIdof7wB4/D+c+UWGtfnZkxTMzURtq6go6p7OenM/3kHZbF/kC4oJlEhaLAZ2e0VK0qFe0T6agoLzHs3msr0cKDS46Tu7wfp0ujPH7zf5Mozjw2jcz3xlJpNPJKecgbx5o47UFs4fAHYiL1nYG7KFRWYZNYs12P+2SXCfemsR8iqW/jvfLmNDmjSk0Ng8h
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c583cab-12ac-46a5-4320-08d772929787
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 17:03:42.7501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e0PheNWvEuBltnrLXvJaLg8Ebx3esh+86KX4pTcXPrWnwQS156IOX30ikUCudm3Uv1uxZJ4JF8QV4ClF5yT3dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3405
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/26/2019 2:23 PM, Iuliana Prodan wrote:=0A=
> In commit 'a1cf573ee95 ("crypto: caam - select DMA address=0A=
> size at runtime")' CAAM pointer size (caam_ptr_size) is changed=0A=
When quoting a commit, it shouldn't be split across several lines.=0A=
=0A=
> from sizeof(dma_addr_t) to runtime value computed from MCFGR register.=0A=
> Therefore, do not reset MCFGR[PS].=0A=
> =0A=
> Fixes: a1cf573ee95 ("crypto: caam - select DMA address size at runtime")=
=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: <stable@vger.kernel.org>=0A=
> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Alison Wang <alison.wang@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
