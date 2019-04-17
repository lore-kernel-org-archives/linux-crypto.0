Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D0EC282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 19:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 756FF205C9
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 19:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="ekW8lWBS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfDQTvM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:51:12 -0400
Received: from mail-eopbgr80098.outbound.protection.outlook.com ([40.107.8.98]:5186
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729291AbfDQTvM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 15:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1urD/FJKz+EyoqgdDDHfBmFKXCGsFPYsT1rIgT0vT6k=;
 b=ekW8lWBSaVbdi2tV2QzDR7ZCW8dCdGYO/exEn9kcZ02kkAuIEO6D9VmMnMx4D8lcELd8M0fO5SEmal8fkDA3n7fQYldmZlnByfSks9ZZo+caywjK1Cfz4/iea9161NTbPNWY/iOvGihh5nxNeuRPytA86YyWDjygUfrgnlII2/c=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6SPR01MB01.eurprd09.prod.outlook.com (52.133.25.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.11; Wed, 17 Apr 2019 19:51:08 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd%5]) with mapi id 15.20.1813.011; Wed, 17 Apr 2019
 19:51:08 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Question regarding crypto scatterlists / testmgr
Thread-Topic: Question regarding crypto scatterlists / testmgr
Thread-Index: AdT1UrNnwXz5dYegQq+/zS0mWvhdgA==
Date:   Wed, 17 Apr 2019 19:51:08 +0000
Message-ID: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fe0c836-0e93-43b7-d378-08d6c36e0905
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600141)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6SPR01MB01;
x-ms-traffictypediagnostic: AM6SPR01MB01:
x-microsoft-antispam-prvs: <AM6SPR01MB01289BB672273F71C4C9EAD2250@AM6SPR01MB01.eurprd09.prod.outlook.com>
x-forefront-prvs: 0010D93EFE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(346002)(366004)(39850400004)(52314003)(199004)(189003)(8676002)(26005)(81166006)(81156014)(5660300002)(256004)(14444005)(7736002)(52536014)(8936002)(25786009)(97736004)(102836004)(305945005)(71190400001)(186003)(33656002)(53936002)(68736007)(476003)(74316002)(9686003)(486006)(55016002)(6436002)(6506007)(2906002)(99286004)(66066001)(86362001)(478600001)(6116002)(3846002)(71200400001)(105586002)(106356001)(110136005)(7696005)(316002)(14454004)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6SPR01MB01;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CVq0lJRGEOizGSyPVg1xXQ/DZDOKdJcMbGVzSy8YKtagFUeVIgSrVzuNboUcwy4VkhHWsdpN+9UZthE1Dppjxv7QOlFQUSMzpI7VRsq2dXvU1mK9gE8JZ059jr5AexkvRCUWmcolSv0IrTzxmFp/V9D0kHiS+S03WCwvsyycnVignmYkrdpkDN+6GglUiKbaHsQqAEYg5wDU4F51m8BE05DtPkd1O6CPMgZ/v3Ir0FstjeVhgRv/JhK9E3pq+y9hf5UqcQO6BWZ6qBUGcribZR1vmiDJ5JfjgTs3i7JI7hmN6Ci9JUyhSh2J0c0B/Ah4RA4Qky8IrRtdhCja3BOY4HaHiVS8SQbBmSRCE34jeS0XKNqSV2un+11QRPMMvDTXjorNDtqay+DQTEJFNs5NEUXQvT++yezhguPkFDyGbo4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe0c836-0e93-43b7-d378-08d6c36e0905
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2019 19:51:08.3748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB01
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I'm trying to fix the inside-secure driver to pass all testmgr
tests and I have one final issue remaining with the AEAD ciphers.
As it was not clear at all what the exact problem was, I spent
some time reverse engineering testmgr and I got the distinct
impression that it is using scatter particles that cross page
boundaries. On purpose, even.

While the inside-secure driver is built on the premise that
scatter particles are continuous in device space. As I can't
think of any reason why you would want to scatter/gather other
than to handle virtual-to-physical address translation ...
In any case, this should affect all other other operations as
well, but maybe those just got "lucky" by getting particles
that were still contiguous in device space, despite the page
crossing (to *really* verify this, you would have to fully
randomize your page allocation!)

Anyway, assuming that I *should* be able to handle particles
that are *not* contiguous in device space, then there should
probably already exist some function in the kernel API that
converts a scatterlist with non-contiguous particles into a
scatterlist with contiguous particles, taking into account the
presence of an IOMMU? Considering pretty much every device
driver would need to do that?
Does anyone know which function(s) to use for that?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure

