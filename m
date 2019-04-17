Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3973BC282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 21:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF1F12183F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 21:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="DdD4eGU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfDQVWd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:22:33 -0400
Received: from mail-eopbgr20126.outbound.protection.outlook.com ([40.107.2.126]:39907
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfDQVWd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 17:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3sywqmFhzoy8IwB8q1bsk1jiSPjKzJpcBCLGHSHWkU=;
 b=DdD4eGU3D/Gi2mRTZpR+j7EEVMlvflNQtyZlcpQoi0fFdpDiL/g4I4AVZGfX7/QxNunRw+itZJayf0lJV6P1wkgH++uXCcOYTCN45xQ82bsR9oLQp+Ah7ZhVwaaHKONJoGuu3ceS6Iq4MT3gBlF3/meXxjS34vfQSysLjDGDcm4=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3238.eurprd09.prod.outlook.com (20.179.244.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Wed, 17 Apr 2019 21:22:27 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd%5]) with mapi id 15.20.1813.011; Wed, 17 Apr 2019
 21:22:27 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: RE: Question regarding crypto scatterlists / testmgr
Thread-Topic: Question regarding crypto scatterlists / testmgr
Thread-Index: AdT1UrNnwXz5dYegQq+/zS0mWvhdgAACM8MAAAEghoAAANhrYA==
Date:   Wed, 17 Apr 2019 21:22:27 +0000
Message-ID: <AM6PR09MB35238364D49784A702B2B064D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190417202407.GA96242@gmail.com>
 <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62609846-e802-4c32-b719-08d6c37acabc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600141)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB3238;
x-ms-traffictypediagnostic: AM6PR09MB3238:
x-microsoft-antispam-prvs: <AM6PR09MB323861A1BA9F3FBED61DC3BFD2250@AM6PR09MB3238.eurprd09.prod.outlook.com>
x-forefront-prvs: 0010D93EFE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(396003)(346002)(136003)(376002)(366004)(189003)(199004)(52536014)(446003)(4326008)(33656002)(305945005)(53936002)(66066001)(7696005)(3846002)(74316002)(6116002)(2906002)(54906003)(7736002)(25786009)(55016002)(8676002)(81156014)(2940100002)(81166006)(256004)(9686003)(99286004)(106356001)(105586002)(8936002)(71190400001)(68736007)(6436002)(6246003)(26005)(71200400001)(86362001)(93156006)(97736004)(6506007)(76176011)(102836004)(6916009)(229853002)(478600001)(11346002)(316002)(476003)(486006)(14454004)(186003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3238;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /I6ohsdq1KVB/srpYbX7AFrQhkOraOR0bDA1X107o738jacSGiB5uwVklfqk3FTR6N7JoDankDAnhvwtIOLyLKu/kHa/ienn+9fi3TGebhJgBQxXxqtf4DORP/RLVqz9icuWD42v36+edfO2Q17duWAyU/OA4EnAA9aspbFtdlrReY4gwQk55dmoGX7DF/aooHD5VNzY0E0e8HIWWZtR3qnyF6AhQ4y7ZRLpn8HUzAsTJ5CVvurSoSy2B0p6fDGtp1ePznpaKiRhpMZw2VAwA22p9/RQMl5dCJTngA7bvnbPEQXfF9pATY5vP+rqTTI1r3dnx5Q0ZPSuvCl7CEUhxyZes/xHr1JFRmgDf3uOzQeg7N2IMcxWPbzI9WdXeZFeA1io/F9Ai6tPAVMYgYZQ2uTMjw1wPMQb4f88wLdVNJI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62609846-e802-4c32-b719-08d6c37acabc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2019 21:22:27.3174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3238
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > Indeed, since v5.1, testmgr tests scatterlist elements that cross a
> > page.
> > However, the pages are guaranteed to be *physically* contiguous.
> Does
> > dma_map_sg() not handle this?
> >
> I'm not entirely sure and the API documentation is not particularly
> clear on *what* dma_map_sg() actually does, but I highly doubt it
> considering the particle count is only an input parameter (i.e. it
> can't output an increase in particles that would be required).
> So I think it just ensures the pages are actually flushed to memory
> and accessible by the device (in case an IOMMU interferes) and not
> much than that.
>
> In any case, scatter particles to be used by hardware should *not*
> cross any physical page boundaries.
> But also see the thread I had on this with Ard - seems like the crypto
> API already has some mechanism for enforcing this but it's not enabled
> for AEAD ciphers?
>
> >
> > BTW, this isn't just a theoretical case.  Many crypto API users do
> > crypto on
> > kmalloced buffers, and those can cross a page boundary, especially if
> > they are
> > large.  All software crypto algorithms handle this case.
> >
> Software sits behind the CPU's MMU and sees virtual memory as
> contiguous. It does not need to "handle" anything, it gets it for free.
> Hardware does not have that luxury, unless you have a functioning IOMMU
> but that is still pretty rare.
> So for hardware, you need to break down your buffers until individual
> pages and stitch those together. That's the main use case of a scatter
> list and it requires the particles to NOT cross physical pages.
>
> > The fact that these types of issues are just being considered now
> > certainly
> > isn't raising my confidence in the hardware crypto drivers in the
> > kernel...
> >
> Actually, this is *not* a problem with the hardware drivers. It's a
> problem with the API and/or how you are trying to use it. Hardware
> does NOT see the nice contiguous virtual memory that SW sees.
>
> If the driver may expect to receive particles that cross page
> boundaries - if that's the spec - fine, but then it will have to
> break those down into individual pages by itself. However, whomever
> created the inside-secure driver was under the impression that this
> was not supposed to be the case. And I don't know who's right or
> wrong there, but from a side discussion with Ard I got the impression
> that the Crypto API should fix this up before it reaches the driver.
>
Long story short: testmgr appears to be doing nothing wrong AND the
driver appears to be doing nothing wrong, but it seems like there's a
bug in the Crypto API itself with the scatter walk for AEAD ciphers.

Regards,

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
