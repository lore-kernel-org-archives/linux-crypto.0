Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2013BC5B57D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 00:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D80CE20673
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 00:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="H5hES8BD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGCAe5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:34:57 -0400
Received: from mail-eopbgr690065.outbound.protection.outlook.com ([40.107.69.65]:18247
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726430AbfGCAe5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 20:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hubw44glFv8KwRPw9xCChZtEBqTfch5z2OYgvYStFEA=;
 b=H5hES8BD2hneV2+wfsNYQZmO8V73rMMCcTsKOQEfOVM/DIIietxkOxZQKFmqyL6hBEeKl1v3we5RN5Mr23Uh8JLuhja9xKvtBX50gH+Rm4wo93PTxAGOc7KhCZ/CH9klQzLOVvC2JaBSxOeKvX8X+aNDAKXxQTZZAkPpAJrry/A=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2477.namprd20.prod.outlook.com (20.179.147.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Tue, 2 Jul 2019 21:21:07 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 21:21:06 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 0/9] crypto: inside-secure - fix cryptomgr extratests
 issues
Thread-Topic: [PATCH 0/9] crypto: inside-secure - fix cryptomgr extratests
 issues
Thread-Index: AQHVMOzENO2jPvPcUU21WpG/kvUyzaa31aBw
Date:   Tue, 2 Jul 2019 21:21:06 +0000
Message-ID: <MN2PR20MB29733CA883E1CB7B72F5532CCAF80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3689335-bd40-43fc-f2ff-08d6ff33322b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2477;
X-MS-TrafficTypeDiagnostic: MN2PR20MB2477:|MN2PR20MB2477:|MN2PR20MB2477:|MN2PR20MB2477:|MN2PR20MB2477:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB24775E2751EEA70088536AF8CAF80@MN2PR20MB2477.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(346002)(136003)(366004)(396003)(189003)(199004)(6246003)(74316002)(4326008)(71200400001)(71190400001)(6506007)(25786009)(81156014)(99286004)(305945005)(8676002)(229853002)(68736007)(7696005)(7736002)(52536014)(6436002)(66066001)(53936002)(9686003)(55016002)(5660300002)(76176011)(81166006)(33656002)(3846002)(6116002)(11346002)(446003)(476003)(66556008)(64756008)(66446008)(26005)(66476007)(76116006)(102836004)(73956011)(66946007)(558084003)(110136005)(54906003)(2501003)(316002)(86362001)(15974865002)(14454004)(256004)(478600001)(2906002)(186003)(486006)(8936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2477;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3d/NpqujfvW/C5A5b+JjaIRHs1fY5QD8iTbB7y92F35E5mxFGv2JRjUDMaBgkADlIO55+9yrFG9UjyOi3Utxi+FISh8HbEu5Um5io69NtDKHDE/tzJCcYu0BctHzHmQoDcZhAslc9o9LPnxpwbN/jPIsN16t9yAPi0S+biRJB2cUkdf7zsoKOLI+qDD3wAo2fFHgjbjU+UJrdGAgZdHPY3c1SmiCZL4MPExkxAD1qajcN8dl/z6nebdBty1cQSQUjdK9s1MV3swXVFQ5+cb7IAP2wfn8PRFKSkmk/NEhPYy+7L3jeD6yl5ea5pAUE9ij2ES+DVrbVW91j0tdyug4LJLcoWfAsGV7sHXZIgGNmpUTlmFecVYYAJCFMKD6iW5lRwMAo9aS83R3CoZXAsNHjX2kZW9DsXZhpL6ww5FQh4g=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c3689335-bd40-43fc-f2ff-08d6ff33322b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 21:21:06.8150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2477
X-OriginatorOrg: verimatrix.com
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I just noticed two bogus unnumbered (i.e. just designated [PATCH]) patch fi=
les got accidentally
included in my patch submission. Please ignore those.

Sorry about that,

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

