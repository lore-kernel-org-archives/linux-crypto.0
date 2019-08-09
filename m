Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06107C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 11:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B262F21743
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 11:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="WQ6ERYR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406567AbfHILjR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 07:39:17 -0400
Received: from mail-eopbgr730043.outbound.protection.outlook.com ([40.107.73.43]:58386
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406551AbfHILjR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 07:39:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OuV2QgjvwdDgacwkmPWv6YGi+odixHogcsGtZDvCkdk5BDoDoxMddTPMUJ4nWSjjsShF2WuvNaI/c6fKu+tm1vsO4URVYGCviLUH12mzitGAvppDMN8FMjrMGO6k/yCCULDAkc9J/S9V/SV1eriK5H9PJAC4ZnI7cVdYyVKiJL9gqTcNly6VzwjTfm7tIqIJLVbdl/mHq+W+aYzeG6qiXvGz5CSfOezBsWxGRPrEIzZjEInC3eXEw2sqD2z1in2ETwwkg7O+Zwk9FlXSle+BQt+Jt3XBFgz8QVetRePmsSIBB2p4Zbf/hWgHD7x7i/kQaBzx7Ptr355Hohxf7mcbqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsyocIw1Ej3rIis2VyqiMYLFwxO66VrZPkXK7P+zx0k=;
 b=Ez2F8Va+4ro92Sp2RCM+kp6fshcR8t64wJmfOKuuBPWmsBrdkA01C7gN8YtIQdxzyRBAg3SFzPGgqZBzSl8dwaqHKaNKweClgvmsbwjoB1HVnrFgfntafdrI2JJ+KU9QPoTOSeyqVSZ2+VJ67HumGBkqfEk8hi+4NXWhJcAe3MFFB3hMTr2RVfubWTHcgxuMUSQwU+OL6g64QqJZeRRbiPeijM1IKtTTjzr28upRr3K88/mfrHIH7M5CdQEoRSa4EAIixbnCzsY/cogAe74hdWgrQiYrmCc+RXspRGEKVFj3xquCbXYA9j7KOrB2g7IDAXUqgahG1sen4MiJLVVewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsyocIw1Ej3rIis2VyqiMYLFwxO66VrZPkXK7P+zx0k=;
 b=WQ6ERYR6lSnD931iozKEwFEo8lAnEJZu1xe2bXgDzaomcQ1xJoQEg/h8swhXUyMyiQoxdiYtr4BcGF7Ii6d6sSE42m5h/zR7i4RxkMWwzivGj6q3CpocwT0AJRHTr1/6Z/uEtZ2rxi3WO0uzeE0ZeC50IwxxlkbbOoKyiytaNoo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2845.namprd20.prod.outlook.com (20.178.253.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 11:39:12 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 11:39:12 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Subject: XTS template wrapping question
Thread-Topic: XTS template wrapping question
Thread-Index: AdVOpvQVifejpBWTRVyvNwtV/QL5zQ==
Date:   Fri, 9 Aug 2019 11:39:12 +0000
Message-ID: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 537af8c5-0861-41b0-d95e-08d71cbe335d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2845;
x-ms-traffictypediagnostic: MN2PR20MB2845:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB28455475334FDCA73927ABE8CAD60@MN2PR20MB2845.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(39850400004)(376002)(199004)(189003)(55016002)(3480700005)(7736002)(305945005)(5660300002)(53936002)(9686003)(71190400001)(74316002)(86362001)(15974865002)(71200400001)(52536014)(25786009)(66066001)(476003)(2201001)(6116002)(486006)(186003)(8936002)(110136005)(81166006)(81156014)(8676002)(14454004)(316002)(7696005)(3846002)(99286004)(33656002)(256004)(66446008)(478600001)(102836004)(66556008)(64756008)(66476007)(76116006)(66946007)(2906002)(6506007)(6436002)(2501003)(26005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2845;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U0bDRN0cJU23wv12u/7xNRvl1Ou9/4gidvuFs4ityZf9U5LbeR+wM4cva5CTnsHTAp8ytpyIyps3bVt1u+HG58umuIpiV+7pYDYf/MAB1nfK8GS0CmqVviCrlI5r0k7ftt8zsbaFvBCX1ScbvaozrWRdcskxuO70nfJeK57UmDG8rnN3knzKb6pavjCW7WGuPlHYLiOgR3idPcDlT8aC6S0o4cA9FYhw8P7LJw/OSHWOlUT/lF72x0ApJI4JCNLWIj/Q69TFWf3vvX7g0LsDD+IsgNIy1EPARU6JZ1Y41gayMQMMLPJTGjM/RRQXtjuTsBRH8NuIJg7ghNSpIsnshuRVgS1n2zRxd6daeyZDqXTSiGKHtWne5jLZqxIuG1jAg/WqWOQhonCdrUUKgPPXC4tZ5EvWP951Uqg6pfE63XI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 537af8c5-0861-41b0-d95e-08d71cbe335d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 11:39:12.6377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uEaoBUkjbdOVQkzY6rhTOVeuiEPNm02r8JVl1qWHdeivXUkovd4MCC8/us1pbDcqcgCga5VJfelrVAnFCpxDvMDpRc4xV0Pd1/vt7ge/8Rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2845
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert, Eric,

While working on the XTS template, I noticed that it is being used=20
(e.g. from testmgr, but also when explictly exported from other drivers)
as e.g. "xts(aes)", with the generic driver actually being=20
"xts(ecb(aes-generic))".=20

While what I would expect would be "xts(ecb(aes))", the reason being
that plain "aes" is defined as a single block cipher while the XTS
template actually efficiently wraps an skcipher (like ecb(aes)).
The generic driver reference actually proves this point.

The problem with XTS being used without the ecb template in between,
is that hardware accelerators will typically advertise an ecb(aes)
skcipher and the current approach makes it impossible to leverage
that for XTS (while the XTS template *could* actually do that
efficiently, from what I understand from the code ...).
Advertising a single block "aes" cipher from a hardware accelerator
unfortunately defeats the purpose of acceleration.

I also wonder what happens if aes-generic is the only AES=20
implementation available? How would the crypto API know it needs to=20
do "xts(aes)" as "xts(ecb(aes))" without some explicit export?
(And I don't see how xts(aes) would work directly, considering=20
that only seems to handle single cipher blocks? Or ... will
the crypto API actually wrap some multi-block skcipher thing=20
around the single block cipher instance automatically??)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

