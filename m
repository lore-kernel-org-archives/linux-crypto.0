Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B2DC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 12:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60730208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 12:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Bo0wCAuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392162AbfIFM0R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:26:17 -0400
Received: from mail-eopbgr10072.outbound.protection.outlook.com ([40.107.1.72]:57216
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731928AbfIFM0R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 08:26:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwqL/l3v5L3jYQYqIO6x3QSMXU5AfbmukJD+wfTABIISyHQKm1UXdvJJNdBVm+KLKRR7ZokuhJ4xLFCEG9EHj6WZG5uqqtbin9WlR+zSGTzbYryFI2TRGwRoksSTdoRmW0N0qqBNotHr5s1nt4Iu3dOI89BKPYgLf8VTRvv/kD0hkV5BRCu/4mYHPlDbT2Cj7OZwU23UDm09kxzUyHJfPcWKYENnpiYlxeMzVpGyq5G8QREyGb51SVyHVhHTzxML3BAAWNnmvekNI3wfBEPgcNUkKcyRN3GoXQw/hOZYWhJTw3qMz3knNWPiG9m7xJehy1vohVjdidOdPuGpEk3GrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4qKuXOvUE6W4lL+8F5mZty+q16+l7nC8gQokWhAN0Q=;
 b=McbgHibO1+Ne5Pa8LWN4bwl0WHbFlawPsq636QIqYL1bm0z6L4OlHC6MXDJ8OfA899G5XwN+W6FsdDybcSnJv3xrxTtrcf3av8DX8Fl0MmR9Usko9bFyJUShjaV5kaGLS7M9BGBlCR9gh7BDmmafW3J81oFLB9U+LPfv2b7R3J/yNj7rqQ4veSBMr0WB2Ur4gFMhhZUiWh9i8L7KJKYqZFhg/BWicoEKnzL1WentX8JNhFySxdTWSMX+/RdpBXS2sx1f0J4EJ+J/ExZ2x+maR3KWvjLu/bu+GhiDRmGWHmMHVS4qOnqrUg49YWozsa956MGLjVLvaKvYlwWtJT9MYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4qKuXOvUE6W4lL+8F5mZty+q16+l7nC8gQokWhAN0Q=;
 b=Bo0wCAuOpZBOSATwC2lJZLzIdKvUkZQWwTfxiA/0E4D+CjoyAxA1lODFukLLxgbHeyFGJHW5BswbDmlPTSrIbOEa4WjNgl5xJ3VxGxnfkxEw9iDKlUICvFPn+j9wSUQ1BZDThwSRn6CXBwdReZnO0s8LIwtFuGqKhvAbvkZEFQ4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3471.eurprd04.prod.outlook.com (52.134.3.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 6 Sep 2019 12:26:13 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Fri, 6 Sep 2019
 12:26:13 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/12] crypto: caam - dispose of IRQ mapping only after
 IRQ is freed
Thread-Topic: [PATCH 04/12] crypto: caam - dispose of IRQ mapping only after
 IRQ is freed
Thread-Index: AQHVYslwb7liAWd2nUa/9cDFJAb3gQ==
Date:   Fri, 6 Sep 2019 12:26:12 +0000
Message-ID: <VI1PR0402MB34859D023EE16F42244535D398BA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-5-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28708405-f4bb-484d-3c45-08d732c567fc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3471;
x-ms-traffictypediagnostic: VI1PR0402MB3471:|VI1PR0402MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3471F47EA82CE1F02BF4EFDC98BA0@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(199004)(189003)(102836004)(6506007)(53546011)(6436002)(486006)(476003)(66066001)(446003)(55016002)(186003)(9686003)(44832011)(53936002)(478600001)(26005)(14454004)(86362001)(4326008)(25786009)(3846002)(66476007)(66556008)(64756008)(6116002)(66446008)(76116006)(66946007)(6246003)(76176011)(7696005)(91956017)(71190400001)(71200400001)(99286004)(52536014)(7736002)(33656002)(74316002)(5660300002)(2906002)(229853002)(110136005)(54906003)(305945005)(316002)(8676002)(14444005)(8936002)(256004)(81166006)(81156014)(2501003)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3471;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 69YrurzpaHhKi7Wxr4VOu9HISmoT+Os3dDt1CKJyoMo4hH2YlXr5cz5hRywzcWn7Vt7VLJDCkelAv/4pWoj1kFyukN0Jxw0fABIpYXwnvCSeGSxUih4sy5sDiT4KjgMuyiS/V2G1piarAtxCPBn0J3hwSRohlZZ3IJKcYsRpRzCfChyScb/bZjyjtbIhpfcpcK1+bNt33A9AMV9oaggOMEtCAdhfjgebcqzrfzEnp+yo6PCyGl6koJtmB2n0EujjO2lZF6xJc8TLSPPIVP0DkdKjiWQzF5EWcjPnMglHsyr7AeDTcGw6dlCv0P5XnLKTyq2hSwqzuyYbQ/9WMs3e3GYWGEqZc4m83u3gNfRNz0HRya6mfePadmVxZUmwKb7dGQLhbUUlgB5wvtMB5996Blm8GeYrgixZuIQ8aPVogYo=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28708405-f4bb-484d-3c45-08d732c567fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 12:26:12.9804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u5fxUaW3BTfv7eCa4dFVg3zOg/SqmMUlbeHnoNx3MXS/RyeMPfV35WKDrkY9Acqb8y8TIwm0RbcrH73+nOgXDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> With IRQ requesting being managed by devres we need to make sure that=0A=
> we dispose of IRQ mapping after and not before it is free'd (otherwise=0A=
> we'll end up with a warning from the kernel). To achieve that simply=0A=
> convert IRQ mapping to rely on devres as well.=0A=
> =0A=
> Fixes: f314f12db65c ("crypto: caam - convert caam_jr_init() to use devres=
")=0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Cc: <stable@vger.kernel.org>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
I'd prefer pushing patches 1 and 4 first, considering they are fixes=0A=
while the rest are optimizations.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
