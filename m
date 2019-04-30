Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA07C43219
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7D1D21670
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="x4lvN82w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfD3Nlb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 09:41:31 -0400
Received: from mail-eopbgr20127.outbound.protection.outlook.com ([40.107.2.127]:43491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbfD3Nlb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 09:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWSIMsovNfEEP2aqFtGvjt3fmIAnC5FJ2OZguiToldE=;
 b=x4lvN82w1Bi0E6UUf3zHmahcSe0+ulWS+cklJLjYUEhL9Ixyb4Yj70iVWfO2TxZQ2H2bF0otapcizthSuxMcGw5jVC9SXruKDCqoQFwPQ1FeSClosJkO0xY26AKEDZY+eJvOT+obQuQMeVdCg3z8xG8yjupst7d7rdU8uLVjHog=
Received: from DBBPR09MB3526.eurprd09.prod.outlook.com (20.179.47.151) by
 DBBPR09MB3190.eurprd09.prod.outlook.com (20.179.47.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Tue, 30 Apr 2019 13:41:27 +0000
Received: from DBBPR09MB3526.eurprd09.prod.outlook.com
 ([fe80::171:fd11:2244:d091]) by DBBPR09MB3526.eurprd09.prod.outlook.com
 ([fe80::171:fd11:2244:d091%6]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 13:41:27 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>
Subject: RE: crypto: inside_secure - call for volunteers
Thread-Topic: crypto: inside_secure - call for volunteers
Thread-Index: AdT/U6NOlHK52506RKGw2EuTDrqaWQABLx+AAAA8mJA=
Date:   Tue, 30 Apr 2019 13:41:27 +0000
Message-ID: <DBBPR09MB352652D305657569DCA6E436D23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
References: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430132653.GB3508@kwain>
In-Reply-To: <20190430132653.GB3508@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b069dffe-337a-4d05-fd00-08d6cd718b9d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DBBPR09MB3190;
x-ms-traffictypediagnostic: DBBPR09MB3190:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <DBBPR09MB3190CBE6200DB8961388D1C0D23A0@DBBPR09MB3190.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(39850400004)(376002)(346002)(13464003)(199004)(189003)(6916009)(25786009)(4326008)(7696005)(966005)(74316002)(11346002)(71190400001)(8936002)(3846002)(446003)(186003)(305945005)(71200400001)(6116002)(7736002)(14454004)(2351001)(6246003)(5640700003)(2501003)(102836004)(53546011)(53936002)(6506007)(6436002)(316002)(14444005)(54906003)(26005)(256004)(8676002)(81166006)(2906002)(99286004)(81156014)(229853002)(66574012)(52536014)(486006)(478600001)(55016002)(76176011)(73956011)(76116006)(66066001)(66476007)(64756008)(66446008)(66556008)(5660300002)(66946007)(68736007)(97736004)(86362001)(6306002)(9686003)(33656002)(476003)(18886065003);DIR:OUT;SFP:1102;SCL:1;SRVR:DBBPR09MB3190;H:DBBPR09MB3526.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jWN+GCYTla8OnIpI4VJRnTzHMRdkvuR9pS8qTY14fhuJy29VwVCU+9YqmZHOqw4vrbplIq8ePJJtRPf4pteRiaT+mv5jDNhdjaIx5fOJuqKvHhqPTZlg5oOzth3FEaheVFI5EVtNLqpIIIfKFKBub6EHWdwmtUi/mOrPREdzUAnzuLB3xLMby6hWB1BRug/dWu7DJp6pRityslJX8WxaOlF0IoCZ9Uqv6IqIuoYP6Q9Q5lpLRym9/n2DEpjUHK1QEgs/TWjjgprChTmmRuUs/Pnz+k90+LbKYHzpyDHzjFIQr2LttuBDdVkeSLzGYJ8INzJIsU6BzEOutLU3m4fdZloWj3mCtqezS8063Cn4sZMTbc8YqwO+YVOO7o3Sjp8PdPEx04foEE6jbvPOXe+VAyvd1sHSsgkW8zGfeTlT6aM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b069dffe-337a-4d05-fd00-08d6cd718b9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 13:41:27.5118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR09MB3190
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of antoine.tenart@bootlin.com
> Sent: Tuesday, April 30, 2019 3:27 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; Herbert
> Xu <herbert@gondor.apana.org.au>; ' David S. Miller '
> <davem@davemloft.net>
> Subject: Re: crypto: inside_secure - call for volunteers
>
> Hi Pascal,
>
> On Tue, Apr 30, 2019 at 01:08:27PM +0000, Pascal Van Leeuwen wrote:
> >
> > Over the past weeks I have been working on the crypto driver for
> > Inside Secure (EIP97/EIP197) hardware. This started out as a personal
> > side project to be able to do some architectural exploration using
> > real application software, but as I started fixing issues I realised
> > these fixes may be generally useful. So I guess I might want to try
> > upstreaming those.
>
> That's great!
>
> > My problem, however, is that I do not have access to any of the
> > original Marvell hardware that this driver was developed for, I can
> > only test things on my PCI-E based FPGA development board with much
> > newer, differently configured hardware in an x86 PC. So I'm looking
> > for volunteers that actually do have this Marvell HW at their
> disposal
> > - Marvell Armada 7K or 8K e.g. Macchiatobin (Riku? You wanted a
> driver
> > that did not need to load firmware, this your chance to help out! :-
> ),
> > Marvell Armada  3700 e.g. Espressobin and Marvell Armada 39x to be
> > exact - and are willing to help me out with some testing.
>
> I do have access to Marvell boards, having the EIP197 & EIP97 engines.
> I
> can help testing your modifications on those boards. Do you have a
> public branch somewhere I can access?
>
I do have a git tree on Github:
https://github.com/pvanleeuwen/linux.git

The branch I've been working on is "is_driver_armada_fix".

I don't actually know if that's publicly accessible or if I need to
do something to make it so ... first time Git user here :-) So let me
know if you have issues accessing that.

Alternatively, I can also send a patch file against the driver that's
currently part of the kernel mainline Git. Or a source tarball FTM.

> > Things that I worked on so far:
> > - all registered ciphersuites now pass the testmgr compliance tests
> > - fixed stability issues
> > - removed dependency on external firmware images
> > - added support for non-Marvell configurations of the EIP97 & EIP197
> > - added support for the latest HW & FW revisions (3.1) and features
> > - added support for the Xilinx FPGA development board we're using for
> our
> >   internal development and for which we also provide images to our
> customers
>
> I'm happy to see some activity on this driver :) I too was working on
> making the boot test suite pass (some tests were not working since the
> testmgr rework and improvement), and on performance improvement.
>
> > Once I manage to get this upstreamed, I plan on working on improving
> > performance and adding support for additional algorithms our hardware
> > supports.
> >
> > Anyone out there willing to contribute?
>
> If there is a branch publicly available, I'll be happy to give it a
> try.
>
> Thanks,
> Antoine
>
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

--
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
http://www.insidesecure.com

