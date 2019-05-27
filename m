Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9888C07542
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 07:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A182070D
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 07:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="bA0QJJ9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfE0H4f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 03:56:35 -0400
Received: from mail-eopbgr30125.outbound.protection.outlook.com ([40.107.3.125]:17467
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbfE0H4f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 03:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIweVhRbkV2xHkrz57pzC3pHL8zWdf29j9Twp4LoCZc=;
 b=bA0QJJ9zQteP4pVL0md9szIDOvBdbxBPUqGcHJoapnG5GEMulJSq0uE4Ni8QKfRQ8xD5VnZ+beBVsdpcLOX+8Q2RrchV9FVkagRzdcvOM5Q00uCPHPyEBQBC9xwzOT0Mh0SE51j/M8SucYhDZ3UQCFXTtE3I8xz+4hYOfbAAf7I=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2503.eurprd09.prod.outlook.com (20.177.115.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Mon, 27 May 2019 07:56:30 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 07:56:30 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        Riku Voipio <riku.voipio@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: inside secure driver update
Thread-Topic: inside secure driver update
Thread-Index: AdUUYKB8aXCt+peVQbyXh2fG0AcXnw==
Date:   Mon, 27 May 2019 07:56:30 +0000
Message-ID: <AM6PR09MB35239325EAB9CF6CF1692142D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8069ee3-e584-4ece-e33d-08d6e278d482
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB2503;
x-ms-traffictypediagnostic: AM6PR09MB2503:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB2503D19E203E0CC3D6B49576D21D0@AM6PR09MB2503.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(39840400004)(136003)(346002)(189003)(199004)(2906002)(15974865002)(26005)(316002)(3480700005)(52536014)(66066001)(64756008)(66446008)(66476007)(476003)(6116002)(186003)(3846002)(486006)(256004)(66556008)(2501003)(86362001)(71200400001)(71190400001)(66946007)(73956011)(76116006)(7736002)(305945005)(25786009)(4744005)(5660300002)(14454004)(15650500001)(99286004)(33656002)(966005)(8936002)(478600001)(4326008)(55016002)(81166006)(53936002)(9686003)(6306002)(8676002)(68736007)(81156014)(110136005)(7696005)(102836004)(6506007)(6436002)(74316002)(158833001)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2503;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GXEC0O8TN6kbDSqpf5XJ6pmJLIGQCCQBhIb7QFTYiCZbwNqw09057zfATbfGezMYS/qsIFehC+gCqNOGnM3ALtt3ilcHOOvpCfjGTM6RhBfT7++paLE/y9qJitxTtZZ1nXEf1POB1ICC1FyhOoEzzi+O0zFrQBnzhDp62AC0LfLx8OjH48VFdXS5rdeOGlhS/fsHqtJscslCKN06P7NSqeYanNhdU/q1Bkk+ejHIhv1L1l6J3nBQPE/95jdXIKypp9mEZ+Fmz5D5O3ci3jtqenZme/AnYXsPjlmO7q1QHWrBKXlqrQoxPRMMEcxyiJyaxBYUbeIffak0LFjMS6JjSpk2WJznvbcDmrgwEokaa13R5s8cuP9vErcOUVXKveWnO2PEXZepWlc2lkH5P/u3YdRm1amwp3zYaQYbeD50em8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8069ee3-e584-4ece-e33d-08d6e278d482
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 07:56:30.7325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2503
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Antoine, Riku,

This is just to inform you that I made some updates to the Inside Secure dr=
iver
to fix some issues with the testmgr fuzzing tests:
- ivsize for ECB (3)DES set to 0, not blocksize
- return -EINVAL instead of -EIO for blocksize violations
- fixed zero payload cipher hang case
- fixed zero length HMAC hang case, now returns correct value

These changes can be obtained from the usual GitHub branch:
https://github.com/pvanleeuwen/linux.git, branch "is_driver_armada_fix".

I can also provide patch files, if you prefer that, just let me know.

Regards,

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com
