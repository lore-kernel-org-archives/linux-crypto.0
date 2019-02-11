Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81609C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 07:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16B5820811
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 07:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZF/AVF0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfBKHsV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 02:48:21 -0500
Received: from mail-eopbgr60052.outbound.protection.outlook.com ([40.107.6.52]:5657
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbfBKHsU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 02:48:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2aD3DjmZ7NRQOIK0dSZrnZXCc8eiVdYQBg2Ia5Lizg=;
 b=ZF/AVF0A43WfHGgmlnTV1c3jq+JOCs64Ew2ooh7szKS5FY1NRHTBbRkxhDvvErXVN3PtcQ47OLiw3KJAgmas5e27XOwzFW4W9sI0w4681QoVk5pSKwyC1Oc9GTdBleve5i1gNyuUsqvs+72t/4RQb32tqAu1gLAyWbSGeTzy6bE=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3774.eurprd04.prod.outlook.com (52.134.15.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Mon, 11 Feb 2019 07:48:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1601.023; Mon, 11 Feb 2019
 07:48:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Wen Yang <yellowriver2010@hotmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: caam - add missing put_device() call
Thread-Topic: [PATCH v2] crypto: caam - add missing put_device() call
Thread-Index: AQHUwEEdF2TWagIXnEe8JyHpqqHt8w==
Date:   Mon, 11 Feb 2019 07:48:16 +0000
Message-ID: <VI1PR0402MB3485ADB2A3B8394DAFE03C4798640@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <HK0PR02MB3634C3869A390146183A1862B26A0@HK0PR02MB3634.apcprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3774;6:9gTMVzhUV2MZJtCUlCz0XWTIAsX2bgynQlgm3n/Ch6vQl+QsHJvuCSb3aZZtXELN18PsLRVsGfibow1X7oRHheSNQ/On5dV7vlTr7h+zPv/8q043lOWyYppQQfJ6e4KKmoaUgbMeGTchSBlHP4kp2gV+EHyFXROW+zQfjDgfXO6GHk+HuLQLE/mwZsDl4BgW22qCaKcbGoXhosVJYYODOX84zeMzj7NaccyxAFRZ6q44eSK/+lWi6KkYGdGmk3MKQoYswTGSejleiRLbIRczV07+mdh+DepnfqHYTBkMDm8TFoyi3NF93vK7heW8C/wK2IgNBpHgjB4SKw1LRjgE9O/pIsKRCFARGptAWo+Y89JVsNUeQqjAIQ8zcb2tQ3BwJQsyPYD9k1bCTXd1CE21/vsned83LF2aqlwjYULb41ISXKcMbl4RMF2wbSYp3Ct1RVhxlB9E03+rILlM6ZDNPg==;5:yu006qOZ5H5uyDoJVajWv4RtEEj5o3DF72+fkgmA4l4Jf3yhNRTtHlLFhASx+FCZcM2XBoZ2RWAJqwil+492bWhmb14xO6387wRs8nAnHnB38de6v5m1o/xiu1NpjHezT09cJMDkkhpO+wxxWi7Y8NMNXf9AG9mZ+d6nVNFdH/CHT5MKbyFXYYG+3vz/brZpfDGAPjvqqUTIFh8QpeMM/Q==;7:7sxN1S7d1LEVHHu7Z13/PNsnBRQp4PkW25rCAYiicZSc+cZMxi7l8dImCAmJGYmgKrW2mZIdr2qgHGS/851njApM8Slf50/uFVjgwqcmvQYgMPetIBA5M1WF5nWk8E+Zq4y05foMT9emS3Xqw/JDXA==
x-ms-office365-filtering-correlation-id: 8e0b4ace-855a-441c-6e6a-08d68ff548a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3774;
x-ms-traffictypediagnostic: VI1PR0402MB3774:
x-microsoft-antispam-prvs: <VI1PR0402MB3774CEE46A17EEB297DAF22098640@VI1PR0402MB3774.eurprd04.prod.outlook.com>
x-forefront-prvs: 0945B0CC72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(136003)(376002)(346002)(396003)(189003)(199004)(97736004)(256004)(71190400001)(71200400001)(6246003)(4326008)(476003)(486006)(44832011)(2501003)(446003)(106356001)(25786009)(53546011)(6506007)(102836004)(33656002)(26005)(2906002)(105586002)(186003)(3846002)(7736002)(74316002)(6116002)(9686003)(229853002)(305945005)(55016002)(66066001)(316002)(14454004)(4744005)(478600001)(76176011)(53936002)(99286004)(6436002)(54906003)(7696005)(68736007)(8936002)(8676002)(81156014)(81166006)(110136005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3774;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kk4uu5P4lMpoOtB4WQyj8eQvBSBJo0ESmgHjG2+6gbSQ1zegHs5UYD/LELgsPvgPF1j51yelWw7PovgRxuU/NNrMiQwdXVcaVDGk8CuuO2krqVfPBAyrNb91xMFVCNPihWhtIj9AogJcFDSigY2xRMd3r1N7GeWyezHI3Kor6PTncT+OqOio4t2lkg6+S2vOmEy7ex9nSAUUeZrKLVlSs3SDcA6h7P+oktNGJbQaAXy9E27fbehS6D96EY9CSq72pVPfMAfipQU7FrkH2+vnClF11EpJBftz1yrmGH8zO4kVWCKTKIscNCrNlpCBFBlt7Rj0OFb2CTqUzIuTpEqqR0kF7jLPdLlNKXYOPl8kXP1c/t9q8mVFy+Xn2M0CXgx5ozTan9iw3yrGIBdzL4O5jWlrayBKGDRpEFQK+oH+b0w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0b4ace-855a-441c-6e6a-08d68ff548a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2019 07:48:16.6142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3774
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/9/2019 8:31 AM, Wen Yang wrote:=0A=
> The of_find_device_by_node() takes a reference to the underlying device=
=0A=
> structure, we should release that reference.=0A=
> =0A=
> Fixes: 35af64038623 ("crypto: caam - Check for CAAM block presence before=
 registering with crypto layer")=0A=
> Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>=0A=
> ---=0A=
> v2->v1: This patch also fixes caamalg.c, caampkc.c and caamrng.c.=0A=
> =0A=
caamalg_qi.c is also affected, could you please include it?=0A=
=0A=
Thanks,=0A=
Horia=0A=
