Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B308C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 16:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB3120883
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 16:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kmawYSKq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfE0Qa1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 12:30:27 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:56153
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbfE0Qa0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 12:30:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IpUbrVPJFSCBKW80LlGo9HKXNMiYICi7OMPtUZ/cLY=;
 b=kmawYSKqS0QM1vSPCP98hqDRozfWvvlJ7Ijg5xfx5tPOp99UolkQpMeCEUffI+Zn/2XTQ35h92S6mcRU8q9h9ixKGoEfIgl4lE8pdgqDMp/tJg/Ijpo3yV7cCwFLPTLlyhxglmgGxUsJbgMKcp9kupf8HeKxnSkm9DWwExQIu58=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3758.eurprd04.prod.outlook.com (52.134.15.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Mon, 27 May 2019 16:30:22 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 16:30:22 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4] crypto: caam - strip input without changing crypto
 request
Thread-Topic: [PATCH v4] crypto: caam - strip input without changing crypto
 request
Thread-Index: AQHVEj+TCpX7zm1be0iJB21tAPCJpA==
Date:   Mon, 27 May 2019 16:30:22 +0000
Message-ID: <VI1PR0402MB34859949EAD2EF75B5888FBE981D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1558709189-7237-1-git-send-email-iuliana.prodan@nxp.com>
 <1558709189-7237-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9b22d44-2937-4198-7af7-08d6e2c09db8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3758;
x-ms-traffictypediagnostic: VI1PR0402MB3758:
x-microsoft-antispam-prvs: <VI1PR0402MB37583A1977D2FB759FA55C3F981D0@VI1PR0402MB3758.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(66476007)(66556008)(25786009)(64756008)(14444005)(66446008)(66946007)(256004)(76116006)(73956011)(2906002)(8936002)(7696005)(99286004)(305945005)(8676002)(7736002)(33656002)(86362001)(102836004)(54906003)(110136005)(6506007)(53546011)(76176011)(81166006)(81156014)(44832011)(26005)(6436002)(446003)(4326008)(6246003)(6116002)(3846002)(74316002)(6636002)(316002)(14454004)(478600001)(186003)(9686003)(66066001)(229853002)(71190400001)(71200400001)(486006)(68736007)(5660300002)(476003)(53936002)(55016002)(52536014)(4744005)(473944003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3758;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 68aY5EARcwUTWvbJjLXa/qWHT4eZnZ4JhZpWheGdFwaOrXFX/dMaZEx2IIXmtoxENdf1fRQuR+Mcmw+NZr0WtASaIEh3Aun+H37b7Zc5FFvLpUejRxW2hnsNSUU+phczIs/GlVwskqp9VBDYMulpfkO/m5b36hpWcHxQHfXCGlt2odXyOFihrNU9ibQhK4aAKHAGxxABjDrHkXYTn7Zt1mVpVS2jlvhAiR+mSuOQwj5veyr5KvLlS9mK5OILmkF4lBwQxZbI3XCJZKO3FddS7WsvVLAj1iPAu8An4/BCaW5Q6Yqmems7chUZKSrc4RBTu8OzEKzUn7JtX8FaQBaseKWENr4rnDEUhA8jeUUVMhH8oulEhYFqceg/Bs/3AqaEjaA32r4Kkuzm5695hmXo283c8qsxenIeEiODZFSRcOc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b22d44-2937-4198-7af7-08d6e2c09db8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 16:30:22.6405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3758
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/24/2019 5:47 PM, Iuliana Prodan wrote:=0A=
> For rsa and pkcs1pad, CAAM expects an input of modulus size.=0A=
> For this we strip the leading zeros in case the size is more than modulus=
.=0A=
> This commit avoids modifying the crypto request while stripping zeros fro=
m=0A=
> input, to comply with the crypto API requirement. This is done by adding=
=0A=
> a fixup input pointer and length.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> ---=0A=
> Changes since V3:=0A=
> 	- no changes.=0A=
Since there were no changes, you should have kept the Reviewed-by tag I pro=
vided=0A=
for v3.=0A=
=0A=
Another thing: don't send a patch set with=0A=
[PATCH v3 1/2]=0A=
[PATCH v4]=0A=
=0A=
It's confusing:=0A=
-patches belonging to a patch set should have the same version / prefix=0A=
-makes one think patches are missing (where is 2/2?)=0A=
=0A=
Thanks,=0A=
Horia=0A=
