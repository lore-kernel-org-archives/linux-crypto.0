Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA105C35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70ACA206D6
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qaogSs3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgBKSXc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:23:32 -0500
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:5443
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729169AbgBKSXc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:23:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cS76Go5dIgSaOXXvrINr9EhlRYZuPXR/jgHwNMh8GwtBvMuz4ruXMgDgMRQSyvEgfjYqRArPyeCTuh6w8TCH+4hBzOT2HSSCz4jD9VCa3XTVQL1ysw0hApPs0jUmtuPzaSeqn2YSAVh5jzqm0w6tAznhDBy2YDBgqFyLUk8LNMBfSvCJ4FVGGQrATCtBGlxOIB842dFjV0r9JvRsO37p9RV6uu43qrMT+QpbkhgHHBNX6fqEL6NHLRCFWHWjJg6V4+2hToDM4kS+s+7+MxH6Nfj5pftCA4gdBwLQDPaxo0g9o0exen8ThKsq9S7DVf2y90UkDd3l5t6b96TqaNXLNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xs20VpbpUL9XF2WJlkF6Mvu7881/xB2hjEaPx0vvgk=;
 b=edsYjrM+MNv9OCrpOSIuh6a0AtK8VHC4r1tRPFGHytCoHH7Wr6Lewt75lMJJLKcNt7eIHpgtDEc1ZI+sbj5Z6Eahz1Ef7ek95b3vm7PwILd/DTB4qsCR0BlCGSbRC91n5LzikWhtzOuMbVWggX850en6DmxWCmAeplhr2X1qh/UjBmGLc2D2xA0+xFuxFIaYxHNUF55xL717m5c9KjV2H3gYGwZC0UjUhKqZ6ogfl+cykloDgIbnPllHVsRkbNWfHjy2NLFJhW46KpAQTIT+smk0NKkthRaUH0wcWa/pvpaG03l6SrarWJ5zGEAOJedv8aYZxB/uE7+LJvXG7lxdbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xs20VpbpUL9XF2WJlkF6Mvu7881/xB2hjEaPx0vvgk=;
 b=qaogSs3m6U3sFq5rRUlvprleAfDPCxFc0SfISWu68FnnucfpbWcDx/aKQp1PNatspxOkKOt40U2NQ0lzgxFoNz6ZFl7T0Oiis3mcuu0t5GDKTNbZIehxODigKyCnsODID3ZbJ3kDYC274IM9jTYqstOYmuw8AG4Jm02rqLTkeY8=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3901.eurprd04.prod.outlook.com (52.134.12.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 11 Feb 2020 18:23:28 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 18:23:28 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v7 3/9] crypto: caam - use devm_kzalloc to allocate JR
 data
Thread-Topic: [PATCH v7 3/9] crypto: caam - use devm_kzalloc to allocate JR
 data
Thread-Index: AQHV1TLRWesVqHI1ZkCUMB3X/8VqBg==
Date:   Tue, 11 Feb 2020 18:23:28 +0000
Message-ID: <VI1PR0402MB348585D73873E2DFE6B8751698180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-4-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bb5e2784-d242-49a6-ffa5-08d7af1f7dd4
x-ms-traffictypediagnostic: VI1PR0402MB3901:|VI1PR0402MB3901:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB39019ABD5D16F0EE32A3C2B098180@VI1PR0402MB3901.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(189003)(199004)(54906003)(4744005)(26005)(110136005)(186003)(91956017)(8676002)(44832011)(8936002)(81166006)(81156014)(66476007)(66446008)(66946007)(66556008)(64756008)(478600001)(76116006)(71200400001)(2906002)(6506007)(53546011)(33656002)(316002)(86362001)(7696005)(52536014)(9686003)(5660300002)(55016002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3901;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u0Dw3+qX+03Ct2DGvoiNqVhc28RI7+51BySRc3YR8rKe8YUzigI4HEPG/4boC1PuOuwcsn1dUzZNSQBzteUZE1eaugMvB+PDerbf3C9sQvxJNkAmzqEfqt34aeSC3Xr56yIWuCNtuJ9Vxcwbyr+x4eBRowxk5E1Suwe0w9wXHDtAkMCk01zoqT9z+tnyNTKgvGsC7C3QZJk8jqaoUPKhviPu7wYtTC8K4inVYGCHA+a0Ai6E49PMkK+gMXooT+gGWkz+0Mo1Xlj6illEG2pNUXwktHrqn9OXxD59ns6qXxQlzYQabGfxMlfqG7KBML4pGBVlJJC1tfzsjCf1pkdhtXpRK2MQsxlRrY+EyordR7G8yVJjWox8FKezrBt4zuI7FWRl5cgbLEtvicxdAlfz0K0jfnjdu6SSwOMOzQaPd93SZTXapgocMzCBG0Vra2DC
x-ms-exchange-antispam-messagedata: SYhgYwUlHsdf744tksmOJzF7Gri2tspLbZLVc4S1dmAPcCJNXsQGWcgYD1dcd8YMXRrCVOQ2uJXDM3uPqyXCbqr0bZ5WNlMSIMai6uJmmkzvw3KSboO86PD5P55XdYbAckjvynFk/o4X18W+gy5zcQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5e2784-d242-49a6-ffa5-08d7af1f7dd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 18:23:28.4473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4d5bVzWf6XJFS8hIyI/S104yeHKmBHq8OX0Kadp0mlpqHJBzM2HuWtjYRQU3no6EG/jkAtcYlQlAMSzfR2RlqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3901
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> Use devm_kzalloc() to allocate JR data in order to make sure that it=0A=
> is initialized consistently every time.=0A=
> =0A=
The commit message is a bit vague.=0A=
=0A=
I assume this is needed in patch 4/9, which adds a new member (hwrng)=0A=
in caam_drv_private_jr structure.=0A=
=0A=
If so, it's probably better to have the change merged into patch 4/9.=0A=
=0A=
Horia=0A=
