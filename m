Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAC5C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 14:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD98218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 14:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PVxs0XNF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfAYO0b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 09:26:31 -0500
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:36096
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726321AbfAYO0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 09:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hA+7B+0izQIZ9wV39KBL/XmNCx2I7548S25mQkKRuxA=;
 b=PVxs0XNFHLiRZuQL3Am27DTrJXH8JGagmUaLnfNdJq+ItWxZsFiOO7UYXvCUo7JR2mx5QkIdkdyEwAYdml4WjHEjw/aRSoyaji9TFvPBOSTYZYmYicTOqxBtjkNPniEW2WNgfaJp1tM37IdxmFETgjtHRmzjSnOomv7ZcpTZBVA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3503.eurprd04.prod.outlook.com (52.134.4.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.17; Fri, 25 Jan 2019 14:26:27 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%5]) with mapi id 15.20.1537.031; Fri, 25 Jan 2019
 14:26:27 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Roland Hieber <rhi@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Roland Hieber <r.hieber@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 2/2] crypto: caam - fix DMA mapping of stack memory
Thread-Topic: [PATCH 2/2] crypto: caam - fix DMA mapping of stack memory
Thread-Index: AQHUsmbwIdQhV/qgPk+dqH8znmHDkA==
Date:   Fri, 25 Jan 2019 14:26:27 +0000
Message-ID: <VI1PR0402MB34859DF7A32E650C9E2E1A34989B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190122152651.1150-1-rhi@pengutronix.de>
 <VI1PR0402MB348525A6FEFD55F6896C9249989B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190125134756.5f5e2uxmwvtnc6bb@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3503;6:Vetx9obzWRMWFHe7Mjmhb2Vu2VqCv33Pkvrr9F9PMzzPxslOsDc3TTNg26eOT+i9kDfHsPJ5xPezK9aL2TyRqgz/lC2nzNo61dSNOorjHw0iq4JqLNvzy2mKhLZEqEtKfFcKmYVTp+bZHOPwR3N3oQBJ/4JnkQaCHAkK1egluycbi68CIPuiAqy/HgndagINJ6x6AnQT06v0Pb5eDlnMbaM/H1CwTBJZOxvIgxKWtUMaIaXE2lBnUJ8dVj2lu0DrkLmalAlCox3eVx+D9d7lnY2rptjxhIwKSfPZk5fONOiqOV7Urg4HCaDDdUCfQ+9KJPUrMAB1bQ8lfGKjmsJXe2O7PRQWICLr7B22f5QGX0acTk37gjPd2sBRsHQZchcovSnh90iP6E7IX5HkJgxgvSZNyXGhY9n6rbdiYnAm8kvMRgQ/YYFdLZxnwMOwM+Ntf5nQtR0KCeCVQ0LYZDkDcQ==;5:n14byrqnUnT+0iTgcdM8wMyvKbjIDO/Bt4BHShbE3xP623bTeSwfIsZE2YzvSY4zs3WIeyO3dkFsKwo8vF7MCr0ZSusoibd+4hFNpY9PE7lW6LvRqD9tmNHZJnEgOpt+XwF/H+1SiTuVC3yzoPOgsr1n26sAO3fSMhzra2YdNQ6Mj4/E2LzmsELVXYYl2nTDAxbHbKvOeYhKq6lXKqi8Hg==;7:qaDCyEXhBHnmCZ9EwY7p4yDBI4/jHKUuvXfkNFWQH9F2ugJj/THC1xDrUjoodY9bhiNW9kP7THXSjjLxzeqBr1gvtrpLdYlQn9BHI7bAC5yVjCXIqyLq9jMox5E9bUGrueQ+7IYi1C5VSBSn+k8VSA==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: bcd2ed57-eb05-47fa-7453-08d682d117b1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3503;
x-ms-traffictypediagnostic: VI1PR0402MB3503:
x-microsoft-antispam-prvs: <VI1PR0402MB3503B2FD281DFB1DFB4C88B0989B0@VI1PR0402MB3503.eurprd04.prod.outlook.com>
x-forefront-prvs: 0928072091
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(346002)(376002)(396003)(189003)(199004)(3846002)(14454004)(6116002)(478600001)(106356001)(81166006)(97736004)(8676002)(9686003)(81156014)(74316002)(105586002)(4744005)(486006)(55016002)(71190400001)(71200400001)(7696005)(53546011)(76176011)(6506007)(102836004)(86362001)(44832011)(68736007)(14444005)(256004)(53936002)(33656002)(7736002)(305945005)(6246003)(186003)(6436002)(25786009)(26005)(476003)(39060400002)(446003)(6916009)(4326008)(2906002)(66066001)(8936002)(99286004)(54906003)(316002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3503;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QLVSZ8dCK0w+2juOtr9sQ3dr05wME+k9CQ2mOzxZanwsW6adJul6bSu7k7Jigc5r9E3HNM93vxeThCAzKi1q1rVBZ2VTSmoMBimk80iRZczrzk4bmh3C5eGeMbCL0VMRJqa/7Xmc6ezoFfMl+5ZsbpfhqeDXrmZgpjOAKqztV22iTIW/RdyiGPe3p1PY+P1tfeqrONREzobB9mWQHcNOpw/JomGcYOjOt+eSuGSCWk+MWB+KCH950u6T9M+Tbz/PpSjNXWkJsS3+ZgAHgwUgBFTKPvYqA6S+ZP88GR9zN9lC+J0LOKKdyqKYZMwXYxaIIVyJ7htlLixH6EQYof/ofE0P7kVwXVzoWseyeFCXJS8xfYub7jPdw+u7lO6Kdx9pW8HFPo8g11ZmkBosKdWm3T0AgcQrpyRT8ccrooC4E90=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd2ed57-eb05-47fa-7453-08d682d117b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2019 14:26:27.5222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3503
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/25/2019 3:48 PM, Herbert Xu wrote:=0A=
> On Fri, Jan 25, 2019 at 12:43:21PM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> Herbert, is there something we could do to avoid this?=0A=
> =0A=
> Async crypto requests cannot be allocated off the stack.  So=0A=
> whoever is doing this needs to stop.=0A=
> =0A=
IIUC, the crypto request is allocated in ima_calc_file_hash_atfm() using=0A=
ahash_request_alloc(), so this seems to be fine.=0A=
=0A=
However, further below the req->result pointer is set to a location on stac=
k:=0A=
out2:=0A=
	if (!rc) {=0A=
		ahash_request_set_crypt(req, NULL, hash->digest, 0);=0A=
=0A=
More exactly, the call sequence is:=0A=
ima_collect_measurement() -> ima_calc_file_hash() -> ima_calc_file_ahash() =
->=0A=
ima_calc_file_hash_atfm()=0A=
and "hash" is allocated on stack in ima_collect_measurement().=0A=
=0A=
Thus, it seems the problem lies in the fact that ahash_request structure de=
fines=0A=
the digest buffer as "u8 *result" - thus the memory area might not be DMAab=
le.=0A=
=0A=
Thanks,=0A=
Horia=0A=
