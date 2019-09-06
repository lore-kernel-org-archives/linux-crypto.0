Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFB9C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 12:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C6A208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 12:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="WUqAOWYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388922AbfIFM37 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:29:59 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:41646
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388289AbfIFM37 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 08:29:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmeCZVGPkah16iUaQNwuUmD9zwOX14M0+IrlgcRoMqjtAcxvV0huF0dIdGm0o0Q4ftROA88SOsdVhLwUfPOVuefHyCFMtoJ/hXw0zcx2T8NIZwxx0JfFJd3svYtzd853BzPyXuT+Nlcb7P42nNlK3bHAWIKVyc3kXayfVXvVfbAjesedp9YERtnbqjKJJgohJf4qcQIvHjnMw2syqyE0JrWbBvPjlc0i4r6VoI7p5w084wBTM4yGzPIEqehl0ceRu/fGs8RZ/BZzez4neCFEFqu/aylULgzYrD7pJT/a2xGtPnVe+UAnr/Fw+roXZgk/f3F+eS7HCTTa5KVSqz1/xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ABPAep2hE6lzBHz3cEYrFttcUabZDToRro3Zncvykk=;
 b=miQMb7nesY54DvvMp7Em98J2e1Nr3h/bxun47YJSpcSmchfQ5KoaELOj++Xs+kkFiqyhlVus1zgmHSmxV1K9qwQINqOAFmK7tlMYXt7wdVwdzGax36XeZwu4ES2EQJ3zEMnrYFkO3noy6aRCILaGhdASj7Lu1wKBwrkt8HLOy6qGp+bvLbc88XXuwhhmOT7zQmNrTHS+E3FHY6/RoyEhynPHv0/g4vyXC7ifuwh0DnQp0hFrabzddzr1M5RVca4hiWRm86g8tLjVHKaGqVKND6a9FhCugtEjxFPqCM6lwkBwY1KNxRafMh+qazvccTDoytxWmXMmEf2fz5Xm7kpn3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ABPAep2hE6lzBHz3cEYrFttcUabZDToRro3Zncvykk=;
 b=WUqAOWYvfLdmBLDU2ro95BX/zrOdpYbXxlVd02kuMIorv0RPe4RuE8rHBSUj4unyy6/2sFcPIAstnld52sIdK0OwHo3WjlYviTqLzck+4riZ6tm0aEQB0UQ25b3yGO1OB5XS1GOzpXWPOhU3u2fKYqlGWanAyQLN6cOGURy1pTw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3471.eurprd04.prod.outlook.com (52.134.3.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 6 Sep 2019 12:29:56 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Fri, 6 Sep 2019
 12:29:55 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] crypto: caam - check irq_of_parse_and_map for
 errors
Thread-Topic: [PATCH 03/12] crypto: caam - check irq_of_parse_and_map for
 errors
Thread-Index: AQHVYslviTxj08g6kkOsrhjdCVtBqQ==
Date:   Fri, 6 Sep 2019 12:29:55 +0000
Message-ID: <VI1PR0402MB3485608F57C2CA49A8C1BDD898BA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-4-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ceccfdd-28fd-48c7-a949-08d732c5ecd6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3471;
x-ms-traffictypediagnostic: VI1PR0402MB3471:|VI1PR0402MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3471098B47D76BD66755F5D498BA0@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(199004)(189003)(102836004)(6506007)(53546011)(6436002)(486006)(476003)(66066001)(446003)(55016002)(186003)(9686003)(44832011)(53936002)(478600001)(26005)(14454004)(86362001)(4326008)(25786009)(3846002)(66476007)(66556008)(64756008)(6116002)(66446008)(76116006)(66946007)(6246003)(76176011)(7696005)(91956017)(71190400001)(71200400001)(99286004)(52536014)(7736002)(33656002)(74316002)(5660300002)(2906002)(229853002)(110136005)(54906003)(305945005)(316002)(8676002)(8936002)(256004)(81166006)(81156014)(2501003)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3471;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QEGnEN+dcydRrjYIDciQRLHCYS3msm6nUBZqZmeX8ba2qEcNG0yIK9Zr4CIzm2tiYA13ieGh6Xv/z2fjqsnDHjfy/qn3dDple86rJOM2p0sFhd2mDKZ68/d6Ng1qCsQsG+K+sjGYKlPVC2Fx42YkfTRaB/WcQiChB5Y1hIevPBLniP6RR02MQ9R0ZyquTMJglUoSc6jeTRGEQ2MHsdEiBOlYcm2FrZZVJyyYpqW3P4SUbzjB8ts+NJk9irjqn0f4Ada54a7OwP+LfDcu6frNnk6iJKVC5nIXE8hjjfkd51JK+q2atMmiBI++xLTCVDcre+w9psasV1J9XErR7jc1HKWK9Zg+n5R70ZE1za+HgkMtFdL4/nVRU2UUcS0KS+OTwej09Eg0TIIZLtrKD3d08FFL8WvJ0jnDxjchM5kZ8mY=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ceccfdd-28fd-48c7-a949-08d732c5ecd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 12:29:55.8822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: On7IJ8dxYeqs3tw2+FvMaIArsovAtRuL5hHqbJYs5+7QJIjrWXeUdZ0D9U+tDtv9+QPwiNsuwBMDuhPIrvtNxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> Irq_of_parse_and_map will return zero in case of error, so add a error=0A=
> check for that.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
