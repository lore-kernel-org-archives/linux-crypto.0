Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351E5C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E910221873
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="eJRPhoD1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfGZPzB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:55:01 -0400
Received: from mail-eopbgr700052.outbound.protection.outlook.com ([40.107.70.52]:18400
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbfGZPzA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 11:55:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ah0IfbEsn2z/m96orbmnoDn8Lw0YENk9SNH3YFy+HMldGItvOU+tugV/R2fjpT+wyj8FxF5yjH2Uv77nf/tybk/1v0915VkFbCHQsDCQpGtz/A6NibA79DYzrSgwT4Joi82SRzvoUS647e+vjIAX6UVQ3rosHWoW1w2Bo7mWW7bpXKRvnfWQEs0FSsiZeRHQLwhlkC85DBwDrXrTSccO1Xx+Zi2KMTZFlrJjic4A5PdStEMUwIJun+1m8Jd+DbBEoH8RCvB76z7DJd03bmguDfaFljVofcuOyZrqJzT+v0YfL6ea1gLjmlr1e8TUL4q1cpeP3HfuMtAHZDE1cojLlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irTkgE4LcUiULSyJdzqj7p7OE2kqxS+S6UZg60gtEpg=;
 b=JRCLYrKykQcdfEyjllKD2vdCp3FbLXcc1KlN2yYp6bkDvhUE0s+7EKioLHNNrv+RwXw2G09cB4TRdpZDgES8lHsYgLbxNnI2bqMMI5lmeegTKUtAJcW4tZjItYfTCOR7gbCbarpmbQXAI/Xm4TU4rMmrVLJCT5T/qvaQLUxDb31OrJKQQzLLn7LzJH0+1dsQumq3lLZKfBFkfEvUVY0Lfg1otav+ogeJB2SSI3//t3135VtbLx9ztH/D+XVjuCxupMdpzhm4ynEVuwHnINND+GeqvFuovw4y8nSXkADmYrG6iYseNsBO6eZq4llieQsKaQDOJxJmrEMjkCQNkEDUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irTkgE4LcUiULSyJdzqj7p7OE2kqxS+S6UZg60gtEpg=;
 b=eJRPhoD1di9Yj0lEn1Rs5Emb3t3fWjpuAShDKczBwauIslBYkfyTi9wLw82CBlkHxhXycMHQu78o2X25MoodDXFKj9+SRDxG4gmprcAuoJNfbpQ/vrDEDVCgentoFlGfvrk3aIhCTx+uvBCQ8GZAu1FZfnVkTJIvgWgSP6v35e0=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2239.namprd20.prod.outlook.com (20.179.147.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 15:54:56 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 15:54:56 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mhl@iki.fi" <mhl@iki.fi>
Subject: gcm.c question regarding the rfc4106 cipher suite
Thread-Topic: gcm.c question regarding the rfc4106 cipher suite
Thread-Index: AdVDye9KM2tcbGm7SBqcTnCLF/Sp0Q==
Date:   Fri, 26 Jul 2019 15:54:56 +0000
Message-ID: <MN2PR20MB29732701865BDB3860142CD1CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ce82425-4c89-41d3-e7a0-08d711e19b2a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2239;
x-ms-traffictypediagnostic: MN2PR20MB2239:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2239F14164255CAC4B35C85DCAC00@MN2PR20MB2239.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(376002)(39840400004)(189003)(199004)(26005)(2351001)(5660300002)(71200400001)(71190400001)(2906002)(14454004)(3846002)(6916009)(52536014)(54906003)(86362001)(186003)(66446008)(64756008)(66556008)(66476007)(66066001)(25786009)(6506007)(6116002)(4326008)(102836004)(8676002)(81166006)(81156014)(33656002)(55016002)(2501003)(15974865002)(478600001)(8936002)(14444005)(256004)(316002)(53936002)(7696005)(7736002)(305945005)(74316002)(76116006)(66946007)(486006)(9686003)(68736007)(5640700003)(99286004)(6436002)(476003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2239;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M3Weudmga2Ma9BiM+t/50C/ZJPK6IOiFCAvEOTcrT5JzjJ1pb4OZeTGlUchRwQfs1tC2lYR4qStoennz+iwc5ARLKySQgmj1puZ5ovNBNDbeMIC0nWHOd0MHOQZ99DlalZG8+KJlQeS3orwRwv9JrSTS3N3paG2YLbOZn6yekGpMmxdxCPYeL8ON3Wvpk+kETrM/yAgr+pIKnyQNU0CnvGXkc8C78LCQcxuLulqdlcyI6xAnEtDiL99SQHlG1QxBiaAs6XfcV+YDushLfb6eHbfP7LfL2Odwn1Nc7Jb1+oFY26YqN9zTUrj41qF+APsgODlZ5FcbJMw0i64/5KH468X30qZc7old259y8F4I+UkpBkJiY5QrBBuXIZP8IxEF3rIXRguMOHX9XxZb21tmLmdLHVQZbtChKTuB/2FyQck=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce82425-4c89-41d3-e7a0-08d711e19b2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:54:56.4308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2239
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I recently watched some patches fly by fixing issues in other drivers regar=
ding the checking
of supposedly illegal AAD sizes - i.e. to match the generic implementation =
there.
I followed that with some interest as I'm about to implement this for the i=
nside-secure
driver.

And something puzzles me. These patches, as well as the generic driver, see=
m to expect
AAD lengths of 16 and 20. But to the best of my knowledge, and according to=
 the actual
RFC, the AAD data for GCM for ESP is only 8 or 12 bytes, namely only SPI + =
sequence nr.

The IV is NOT part of the AAD according to the RFC. It's inserted in the en=
capsulated=20
output but it's neither encrypted nor authenticated. (It doesn't need to be=
 as it's=20
already authenticated implicitly as its used to generate the ciphertext. No=
te that GMAC
(rfc4543) *does* have to authenticate the IV for this reason. But GCM doesn=
't ...)

So is this a bug or just some weird alternative way of providing the IV to =
the cipher?
(beyond the usual req->iv)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

