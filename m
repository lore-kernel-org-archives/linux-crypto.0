Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7C4C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F0A0208CA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="jsCDzQiu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfDZQfJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:35:09 -0400
Received: from mail-eopbgr40048.outbound.protection.outlook.com ([40.107.4.48]:61042
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbfDZQfJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Apr 2019 12:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8obRCqLnvl2a0U30yDLnDSJpqTYOOc9dcLCITNlinkc=;
 b=jsCDzQiuXwJ/VFYvhTHg3yssy1nm3camZQpTeN9kZD5CfKOVTOpBNH/X1UAlxbJn0iXRMcQAc1FEwP6uePFlQMyjpeUfO2WgasZCf7mQoMKyRI/NoH3JgTBKlfhT81gXF2dAPoYjm0BqIFZ8Gl6eIK3x3F3GR9pNBoMEINhieww=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3502.eurprd04.prod.outlook.com (52.134.4.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Fri, 26 Apr 2019 16:35:06 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1813.017; Fri, 26 Apr 2019
 16:35:06 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Thread-Topic: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Thread-Index: AQHU/E4B9cUiZnJ1EEuei1pU1G4SaA==
Date:   Fri, 26 Apr 2019 16:35:05 +0000
Message-ID: <VI1PR0402MB3485A6BE1840DD5B060FACB7983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190412045742.1725-1-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.230.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bbeb98d-84fb-4f79-a91c-08d6ca6523dd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3502;
x-ms-traffictypediagnostic: VI1PR0402MB3502:
x-microsoft-antispam-prvs: <VI1PR0402MB35020B86A07A6D751C0387EA983E0@VI1PR0402MB3502.eurprd04.prod.outlook.com>
x-forefront-prvs: 001968DD50
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(376002)(346002)(199004)(189003)(54094003)(66946007)(74316002)(6436002)(256004)(7696005)(66476007)(446003)(64756008)(66446008)(7736002)(305945005)(9686003)(55016002)(66556008)(53936002)(6246003)(478600001)(66066001)(97736004)(110136005)(86362001)(486006)(99286004)(316002)(476003)(44832011)(6506007)(102836004)(229853002)(186003)(26005)(53546011)(4744005)(33656002)(76176011)(71200400001)(71190400001)(5660300002)(73956011)(52536014)(3846002)(2501003)(25786009)(2906002)(68736007)(14454004)(6116002)(91956017)(76116006)(81156014)(81166006)(8676002)(8936002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3502;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BtX0yk8ZGYXXo/sG9D/ZLebH1sKyOiBqmRxw/CkZYr/iJCAJvg1LL1Po2etYNRr7vd8rwEmxZ4ff6aY2mbHtpUnmAfzx5In6Vrkf7U0jDRspWqsivBPxuwJu9EsSAq3Hd1vY6RLFYVaJLAqCGZfOgMpdYTnUB4Xyn12SQSGgHGZuYecvHL5/ZWn4yTRg79BSgSozT+7rc9MHvxyjsJ84QCiiq+JC+T6uR5MrfWJHnScx9HZM71JD+Q9IGHINYgMxIANWSnMoWb3WatiqzOt1BQ6TrkkqfOru2IL2pvXluHoWVZV4tQadLCVvUoV8QxJJqSswyPfP9teZ/wNubK9CLgTWd3rZWk8aBEgGWuhM3xw3lUnc09AYjuFFNMoN5ulWxdySm9bvzu7CVJ4ZW//RWAuVcN6t7wRp4Oh3IoLsQgg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bbeb98d-84fb-4f79-a91c-08d6ca6523dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2019 16:35:06.0219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3502
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/12/2019 8:00 AM, Eric Biggers wrote:=0A=
> So far I've tested all generic, x86, arm, and arm64 algorithms, plus=0A=
> some PowerPC algorithms.  I have not tested hardware drivers.  I=0A=
> encourage people to run the tests on drivers and other architectures, as=
=0A=
> they will find more bugs.=0A=
> =0A=
I am seeing some errors in caam hardware driver.=0A=
They are due to error code mismatch b/w generic algorithm implementation an=
d=0A=
what caam driver returns.=0A=
=0A=
Random skcipher tests for block cipher algorithms are expected to fail when=
=0A=
input size is not a multiple of algorithm block size.=0A=
Generic implementation returns -EINVAL.=0A=
caam driver returns the status received from HW.=0A=
=0A=
This probably has to be fixed in caam driver, but I wonder if there's an=0A=
agreement on what error code should be returned in every single case (since=
 I'll=0A=
have to do a N:M mapping b/w errors returned by HW and errors expected by c=
rypto=0A=
API).=0A=
Should I take the generic S/W implementation as reference?=0A=
=0A=
Thanks,=0A=
Horia=0A=
