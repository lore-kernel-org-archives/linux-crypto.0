Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3356C04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 09:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B311520862
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 09:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="V011aUFb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEOJCu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 05:02:50 -0400
Received: from mail-eopbgr20122.outbound.protection.outlook.com ([40.107.2.122]:15520
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725929AbfEOJCu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 05:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCbafZCjBDYg0wBkjY4yRoQTxPYcqrhujQpw0mJGJY4=;
 b=V011aUFbhm2HUAu+dhc+HNqY5bSeAUV2u4P+6DznLLB1fwlJ9dNaxlUE9uA2j9l3v6UG/PDUmwCQu95/x5J3A9mwxVsd6oYpKCKvgT5Xp7meJvQOBNXgq2m8ZUgzkRu9t2ucaoN/N7jjvLJ2KUBAwyfrqklIv9SCCvKfJ3OD004=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2422.eurprd09.prod.outlook.com (20.177.113.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Wed, 15 May 2019 09:02:42 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 09:02:42 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        Riku Voipio <riku.voipio@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: crypto: inside_secure - call for volunteers
Thread-Topic: crypto: inside_secure - call for volunteers
Thread-Index: AdT/U6NOlHK52506RKGw2EuTDrqaWQABLx+AAAA8mJAAAMUMAALn8IMw
Date:   Wed, 15 May 2019 09:02:42 +0000
Message-ID: <AM6PR09MB3523E393D4EA082FDDBC9251D2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430132653.GB3508@kwain>
 <DBBPR09MB352652D305657569DCA6E436D23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430135542.GC3508@kwain>
In-Reply-To: <20190430135542.GC3508@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aaccfc97-7d66-4380-cb87-08d6d91416bb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2422;
x-ms-traffictypediagnostic: AM6PR09MB2422:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB24227DC22FAE4399CFDC1699D2090@AM6PR09MB2422.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39850400004)(346002)(136003)(199004)(189003)(3846002)(74316002)(305945005)(6116002)(7736002)(33656002)(8676002)(81156014)(2906002)(15974865002)(110136005)(81166006)(2501003)(68736007)(4744005)(446003)(256004)(186003)(316002)(99286004)(66066001)(102836004)(6506007)(73956011)(4326008)(71200400001)(71190400001)(66946007)(7696005)(76116006)(486006)(478600001)(26005)(8936002)(6246003)(76176011)(6436002)(86362001)(53936002)(14454004)(476003)(66446008)(64756008)(5660300002)(66476007)(52536014)(55016002)(9686003)(25786009)(11346002)(66556008)(229853002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2422;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uKfqgAvwUU7j/2J2+1IaJOb2ouBaAuH+yESK5zEqOEnsWypksE+xLZ2V/2XTFmxUoSHvMWvO3KJTzTqIR5vrEyPmSR97Yv2Aqq1pqQdwo4xp5FOixn7hrFxK+2VkKV5jLvPLAOq5XCbD2K/Lu+EvXlblXJj+QWctoC9Stcv9+0IuQfFILXCn6GsLiIhnIDwoxhVNcAtwP8VhCU3+s8vm8ASECGDavNp3XsgrRg3C3iwVIyn+9BeaDudC8QsWdGQRPkFwdP0B48E+716CJM052ia74oNzXu2M8a58G5ljomwQV91/q/YX2az53wB3ycUsp41zjIV7U3QsrCHO6fjBaSjcq4T2714268RUxg63EVhlInWD1bpLsvRR4sB6CSoIL2AtdTKj0Tpjh+QjHkGLF15sZcCqlUnaFsyvJb20RA8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaccfc97-7d66-4380-cb87-08d6d91416bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 09:02:42.1854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2422
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Riku, Antoine,

It's been 2 weeks already so I'm kind of curious if either one of you
managed to try anything with my modified Inside Secure driver yet?
Note that if you experience any issues at all that:

a) I'd be very interested to hear about them
b) I'm fully willing to help resolve those issues

BTW: if there are no issues and everything worked fine I'm also
interested to hear about that :-)

Regards,
Pascal


Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure

Tel. : +31 (0)73 65 81 900

www.insidesecure.com

