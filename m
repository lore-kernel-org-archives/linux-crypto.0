Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46D1C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 14:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D2D62070B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 14:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="rCT5lzEA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfGZO5Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 10:57:25 -0400
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:62018
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727555AbfGZO5Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 10:57:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRsqfTJV1W3ekCbAHbh01hfMpEe6oKPR5VLXa0Lf3WoybHTGEc1BlMSlh2/Wcx/c2qGzGqGN89X4AdCqAj8/dKfpWlolPnao8WbFuTIrBgR+U2oJSmTrA82VZ+rnIO/ZzmOt2AKQkLe8EvGF7LCLTlAH/Ao5fJstpk65HkU0CifTXKXIdGFBVE7HGcF/EWnVqnvhA5THoxOlGeUYSin2euwRcMgr/+L9bOqeK4UMp92WQfsMuYTqD3DTEXIDS/xmWbFIcOPTdb6KyRvJqrGEEPGfG9MAUkEl34+qTYMHD8/AzR019i1zysUYTtLTQaW2a3/FUzv3zU9qszW0YSyDwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSNMibKJcVzN5iO108bf2k1MIjL8OCXBeFgImgOl8FY=;
 b=acubs+fP3QsyHQ19N9GdVBJQr9A0JdsmpjkIgI8Cy7IsHTJNVd0UDvTzAeh0KhxcvXod6buntmUaRhB34tlIUkJhacAsJ9eS9aYuKO0QPJHJmuKd7tQrxLpVh5f1ZsYlBD4F6BfbnOjbE9llLNqWi8bwiUAQRXZ81YbrEw6PKRvPoLjWh7ao3IZBW9XxdQUb64YbFYaHM+dwsFiYSUbhIECjsx+p7cWRVF7uH8nUuulrZLWEXohDNE7uVSUCyriAST4pUJyDD/6L/gFwTWz9+7H1N2BKn7tUDkZZ2PDBndcd5uCpBXvQDxhLIMSDm5GAzyppp4RuuReI3ZA5F34gOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSNMibKJcVzN5iO108bf2k1MIjL8OCXBeFgImgOl8FY=;
 b=rCT5lzEAPjgp1VAjYhOG3FzOPGae1GyBBkYrbVIugj+C6I98pLRLzbIL4ZITV604nLU7IbDG3j1krAfEoVs0MAVM3IPO/c6wp+BM1XIkGDSQdWWosYXsnBu6QrC2c1yZClx6qguJWBGC9Jk6Uo407Oo0pm7GiitY4tXGjk8Hb3o=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3503.eurprd04.prod.outlook.com (52.134.4.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 26 Jul 2019 14:57:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 14:57:21 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 03/14] crypto: caam - update IV only when crypto
 operation succeeds
Thread-Topic: [PATCH v3 03/14] crypto: caam - update IV only when crypto
 operation succeeds
Thread-Index: AQHVQvEPStOeEBJ20UmxvWZK57s6pw==
Date:   Fri, 26 Jul 2019 14:57:21 +0000
Message-ID: <VI1PR0402MB348507281FD21A17DB4B80FF98C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
 <1564063106-9552-4-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19b08ace-fa1f-4577-495f-08d711d98feb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3503;
x-ms-traffictypediagnostic: VI1PR0402MB3503:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB3503BF95D532795D9CDDAB3098C00@VI1PR0402MB3503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(189003)(199004)(99286004)(71200400001)(4326008)(71190400001)(15650500001)(486006)(44832011)(316002)(52536014)(6246003)(229853002)(8936002)(86362001)(81166006)(4744005)(305945005)(54906003)(966005)(66476007)(81156014)(5660300002)(476003)(256004)(66556008)(9686003)(76116006)(66946007)(66446008)(6306002)(55016002)(110136005)(64756008)(446003)(8676002)(91956017)(45080400002)(14454004)(6116002)(7736002)(3846002)(6636002)(478600001)(53936002)(2906002)(66066001)(74316002)(186003)(33656002)(6506007)(25786009)(76176011)(26005)(68736007)(6436002)(7696005)(53546011)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3503;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ieeOGf7sr+S3jMjkd7GxoTCxcLijqIZtiEUkzGTH9hq47GRZqLJUZwtZM29E++imYLz/+fYpAWIvcGZdjMnpVudfI0EX0gTmc7Nhhts44PaQlHbqFRC54Rh4xs7kxnRW91HQZ+a4bpy3kEU1dFK/HjB+ecNBJsoVortI/gMI4EYfkwuE82ddNbQoRhfA76LgQJnCED1+JCd7ebsdQWL/lLQOX0jIPBt8U/EDc9++/u4c6F0FQf+hrrq7p0hoDv13xoGBCR24YEHq8rHuQt814by7xBHzR5WgeFyIh7pvRO4Hk8xWRK2HHvZsuGSL5geabwirgzR1/aeqt/PmcgHqyLYsip5snfX7D6qLxKwOJdV03y8cvUevuzwucTUOVG6DKrfHBWs3rYkX/0R/89CRnXzUpI/aCIr6aon65aTTuBM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b08ace-fa1f-4577-495f-08d711d98feb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 14:57:21.5292
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

On 7/25/2019 4:58 PM, Iuliana Prodan wrote:=0A=
> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> skcipher encryption might fail and in some cases, like (invalid) input=0A=
> length smaller then block size, updating the IV would lead to panic=0A=
> due to copying from a negative offset (req->cryptlen - ivsize).=0A=
> =0A=
In v1 I mentioned the commit message needs to change:=0A=
https://lore.kernel.org/linux-crypto/VI1PR0402MB34855E675A58E1221ACE7B9498C=
80@VI1PR0402MB3485.eurprd04.prod.outlook.com/=0A=
which happened in v2, however somehow v3 is identical to v1.=0A=
=0A=
Horia=0A=
