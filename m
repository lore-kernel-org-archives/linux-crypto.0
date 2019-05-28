Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53839C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 15:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A7F521473
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 15:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="r4UUAwYy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfE1PrO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 11:47:14 -0400
Received: from mail-eopbgr50105.outbound.protection.outlook.com ([40.107.5.105]:52100
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbfE1PrO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 11:47:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbiz4Czne7iJ7Mzu+5mtJcKxG5nvXVf2cqYt6HZzeDs=;
 b=r4UUAwYyIWhzOvw1uJFo8jNfWM4egeh+YOZPxGJLQ2ro/CDMDi1GWaKxpWExtciperKIdkQ8iKzJbo5re3gjpP8Vhpwio7e8HaHA6LILUrE7nENrfl7yZuYoSbVCN/gFz1Y7/OW4ROLAlMuakFB/iXHHSxzv/d1Mc7GjtI9HcKA=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3009.eurprd09.prod.outlook.com (10.255.96.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.21; Tue, 28 May 2019 15:47:11 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 15:47:11 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Conding style question regarding configuration
Thread-Topic: Conding style question regarding configuration
Thread-Index: AdUVadXkEfSYWnL2TvyyCw6EdJwBbw==
Date:   Tue, 28 May 2019 15:47:10 +0000
Message-ID: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bb9a465-a36c-4fe2-3c44-08d6e383bf69
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3009;
x-ms-traffictypediagnostic: AM6PR09MB3009:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB3009F2AAF2CB9DA8A2D53806D21E0@AM6PR09MB3009.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(39850400004)(346002)(396003)(136003)(189003)(199004)(26005)(99286004)(66066001)(186003)(8676002)(53936002)(86362001)(6916009)(102836004)(2906002)(8936002)(7696005)(316002)(6506007)(81156014)(5660300002)(9686003)(81166006)(52536014)(25786009)(76116006)(66556008)(64756008)(66946007)(66476007)(66446008)(73956011)(2501003)(6116002)(5640700003)(55016002)(74316002)(6436002)(7736002)(71190400001)(305945005)(33656002)(71200400001)(14454004)(486006)(476003)(14444005)(256004)(2351001)(478600001)(15974865002)(68736007)(3846002)(21314003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3009;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AqMZa5+0dXc+ppQ30sZpNJzDwPx7t2Sb/b0nu6G2yawIpZ1SDFwpmgReeJriapf+fVKipUdTxeHRLYn9s1TGoO9a10ZzSzP/ryq9scE7oZhVOC5FayruUzjL5rz9uPQ/2EVaohYx/hqgitD0jYPz2RfubfdTCoAPkZ3yZ/REKuzebV3Y5mfjhm1MHgkOWGNsWlxK4OGuxOm3YEHg0jRU8NfJZfVaTb420BWH8myfWBotIoKjQmkSOFMNcCIbt0+v5Vs1mIcwu/3K8mwmbFqqmm3AhoeggXtSq+LQISoIQf9Jsi83C2xYnC64t/oOKQH5YXrgKgtklhxOiXQScTduYerJWmLwwJX4v0i43Yt94P/X/qhKKu6fJpRAaxEYgQld9D13sMLIOCZQmRXfBUjFOF+eqbc0PQ00SRwdJwDEW8U=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb9a465-a36c-4fe2-3c44-08d6e383bf69
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 15:47:10.9730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3009
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Quick question regarding how to configure out code depending on a CONFIG_xx=
x=20
switch. As far as I understood so far, the proper way to do this is not by
doing an #ifdef but by using a regular if with IS_ENABLED like so:

if (IS_ENABLED(CONFIG_PCI)) {
}=20

Such that the compiler can still check the code even if the switch is=20
disabled. Now that all works fine and dandy for statements within a
function, but how do you configure out, say, global variable definitions
referencing types that are tied to this configuration switch? Or should
I just leave them in, depending on the compiler to optimize them away?

Obviously the code depends on those variables again, so if it's not
done consistently the compiler will complain somehow if the switch is not=20
defined ...

Also, with if (IS_ENABLED()) I cannot remove my function prototypes,
just the function body. Is that really how it's supposed to be done?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

