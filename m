Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E73C43219
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E22F320835
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="0SfahpKE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfD3NIb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 09:08:31 -0400
Received: from mail-eopbgr140118.outbound.protection.outlook.com ([40.107.14.118]:13789
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727383AbfD3NIa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 09:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ve7rfPGC3Wht6fuIips+feGXvtrfkugS7u9DBmo0zGw=;
 b=0SfahpKEODgpe7Hwxy11yozpixy4tbwRslMtIKL6KpIsMXSj9pRnLLN+UigkFBMAXDcBn7utK0ugoMoNutXheZOU+tyDjSFGkt7SgAlQ4aJWrcph+33tLXENqdiHHP31XVeZjFvhwU5BsagTSHZhzJIcgPUBHSbwPcXs7xZUxO4=
Received: from DBBPR09MB3526.eurprd09.prod.outlook.com (20.179.47.151) by
 DBBPR09MB3525.eurprd09.prod.outlook.com (20.179.47.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 13:08:27 +0000
Received: from DBBPR09MB3526.eurprd09.prod.outlook.com
 ([fe80::171:fd11:2244:d091]) by DBBPR09MB3526.eurprd09.prod.outlook.com
 ([fe80::171:fd11:2244:d091%6]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 13:08:27 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>
Subject: crypto: inside_secure - call for volunteers
Thread-Topic: crypto: inside_secure - call for volunteers
Thread-Index: AdT/U6NOlHK52506RKGw2EuTDrqaWQ==
Date:   Tue, 30 Apr 2019 13:08:27 +0000
Message-ID: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8626e605-900a-46e5-93f8-08d6cd6cef38
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DBBPR09MB3525;
x-ms-traffictypediagnostic: DBBPR09MB3525:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DBBPR09MB352518438E86BA3634D27A32D23A0@DBBPR09MB3525.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(136003)(346002)(39850400004)(53754006)(199004)(189003)(68736007)(2501003)(2906002)(52536014)(33656002)(478600001)(305945005)(74316002)(71200400001)(3846002)(7736002)(53936002)(71190400001)(6116002)(9686003)(26005)(55016002)(6506007)(97736004)(102836004)(476003)(486006)(99286004)(256004)(14444005)(8936002)(7696005)(5660300002)(316002)(81166006)(81156014)(186003)(66066001)(8676002)(110136005)(64756008)(66446008)(14454004)(15974865002)(25786009)(66946007)(73956011)(66556008)(66476007)(76116006)(86362001)(6436002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:DBBPR09MB3525;H:DBBPR09MB3526.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TEQHH7rum+wZyl/6LLQCetQZM+Btn9sl403OsJSnZ7sbK1HFhDddzEqw4g3rwv5nGCaECTurvc0BrT+5F+6Z1eu1GtHtJyz6gjnpyCejJzCLfhIASnhwCdjCRbOQzvh2hPSOzBJtgzCOqABXutlaXENSde0fHNm9oi5wy/+phfORJZUQ5syl1cpngTE+OsspMVreyuVpa42QYu3KIYQ55D//yC4FcjGRRQiQkpUa1fFV+uLGjy/6X+XMuhRgFaH0Y1XGnLgGdo9ALqtRBlmU3Nvih/5gf0JqmOBAXDbLPcZ5I6B+MOdJYyJsGX0E4lGA5h/589Et7SQ68HNchbCloKiE92oZ6mjwU8p5qQ5VzTKHcVdLwuy+Xj9TxnETawUwhndY2xJkW1CSaqt0lhaCg4ew2QJxNq1boOzLP/Bg3qg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8626e605-900a-46e5-93f8-08d6cd6cef38
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 13:08:27.1547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR09MB3525
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

Over the past weeks I have been working on the crypto driver for Inside Sec=
ure
(EIP97/EIP197) hardware. This started out as a personal side project to be =
able
to do some architectural exploration using real application software, but a=
s I
started fixing issues I realised these fixes may be generally useful. So I =
guess
I might want to try upstreaming those.

My problem, however, is that I do not have access to any of the original Ma=
rvell
hardware that this driver was developed for, I can only test things on my P=
CI-E
based FPGA development board with much newer, differently configured hardwa=
re in
an x86 PC. So I'm looking for volunteers that actually do have this Marvell=
 HW
at their disposal - Marvell Armada 7K or 8K e.g. Macchiatobin (Riku? You wa=
nted
a driver that did not need to load firmware, this your chance to help out! =
:-),
Marvell Armada  3700 e.g. Espressobin and Marvell Armada 39x to be exact - =
and
are willing to help me out with some testing.

Things that I worked on so far:
- all registered ciphersuites now pass the testmgr compliance tests
- fixed stability issues
- removed dependency on external firmware images
- added support for non-Marvell configurations of the EIP97 & EIP197
- added support for the latest HW & FW revisions (3.1) and features
- added support for the Xilinx FPGA development board we're using for our
  internal development and for which we also provide images to our customer=
s

Once I manage to get this upstreamed, I plan on working on improving perfor=
mance
and adding support for additional algorithms our hardware supports.

Anyone out there willing to contribute?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

