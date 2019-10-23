Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E194CCA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 17:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96C272086D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 17:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="YDGE49MM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfJWRIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 13:08:00 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:23249
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725796AbfJWRH7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 13:07:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F70pGD5Oppzpv+xpEvw2ONohNW/iRHW9G68oW0Myxm7SWEUXSJNcALmu2/pCQSqcYHWGVBBU7XD0Ll4Rj27uXEAH2RirXlTunUKmukeSfg/002aJ9Ke0Wb5odf17aUC05rIu+xtRst9qwO9nJB40pZzWVX8FzTkGabHZmxz2FARjTRQbX64drloUw0BGTWqXiGJBBursNjPdN31KLGGkxVN67FwQp7K+YibcKveoLMV9xcclT9Fp6U+pwq9vpuku4lRow+OJWwLHqY7eU23nZCqnrvecP/+q3onn8rFNPuPWiypNWSMGT4W588mnbO8ONwZSa0Lm2LTsysP7c44pgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojdnikd8BWcYGDJ4hbYJfrEmZfebCvFHBpIpvjHkn5I=;
 b=Uob2hNsd4R75/9cRQv2G0YEHVoL+0+ItLUwa7aAWYDV5NIypnM9fQWpwJkPfqfyviAl3BrYfsqKuD4hST66vZpkhYG3oKDAuDipSgUd1t6g4daFsgBRzKsgnNEk3CQK9PSNB4Bg6fL/cih50nvvtMpiYiun5by94L8ybx75e8RLelEwZRHtBIvOUMiMxQlwokx/sP9yXLVehvwQ4F4uCSKpYfDN2jTsPEHhEOzcQAUNqcIYHo2NQxHWe7ulSQ2Z/bTXyZiDHT2vgRaZN/Ca+KDZbWITY/oAWH3P2QzQ9mkxQR0IPY18DrMN0pfkN3HuEeIltPnbQhtbpf2hxz25RLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojdnikd8BWcYGDJ4hbYJfrEmZfebCvFHBpIpvjHkn5I=;
 b=YDGE49MMmr56vLzrWriRNIYzv1c3jE0HxyBTgvjAf/mnxw/Bl/XbmxLs+/N8vUWO0ad3Zt8Q+xwXAxUyFwoz1RFDsBtllS75GYxSu96DEvMxwtDMzmB2LLb98gBNu39Tl5OMLyUwM8Y3FN6fNJCxKDMdiVL8VkzQP0qeP3yc5BY=
Received: from AM6PR0402MB3477.eurprd04.prod.outlook.com (52.133.25.15) by
 AM6PR0402MB3431.eurprd04.prod.outlook.com (52.133.23.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 23 Oct 2019 17:07:57 +0000
Received: from AM6PR0402MB3477.eurprd04.prod.outlook.com
 ([fe80::a1b5:b818:c136:bf86]) by AM6PR0402MB3477.eurprd04.prod.outlook.com
 ([fe80::a1b5:b818:c136:bf86%6]) with mapi id 15.20.2347.030; Wed, 23 Oct 2019
 17:07:57 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] crypto: caam - use devres to de-initialize the RNG
Thread-Topic: [PATCH v2 3/6] crypto: caam - use devres to de-initialize the
 RNG
Thread-Index: AQHViO2kRpecYPaWy0GLIKrqCInqQQ==
Date:   Wed, 23 Oct 2019 17:07:56 +0000
Message-ID: <AM6PR0402MB3477E7F4276A90B67A026793986B0@AM6PR0402MB3477.eurprd04.prod.outlook.com>
References: <20191022153013.3692-1-andrew.smirnov@gmail.com>
 <20191022153013.3692-4-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9ea74606-7fde-4efa-cdb8-08d757db8cf7
x-ms-traffictypediagnostic: AM6PR0402MB3431:|AM6PR0402MB3431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB34311688E1707662FD2ACECA986B0@AM6PR0402MB3431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(189003)(199004)(186003)(6116002)(26005)(7696005)(76176011)(99286004)(53546011)(6506007)(3846002)(7736002)(476003)(486006)(86362001)(74316002)(14454004)(305945005)(102836004)(44832011)(76116006)(66446008)(64756008)(91956017)(66556008)(66476007)(229853002)(6246003)(446003)(66946007)(256004)(6436002)(2906002)(54906003)(25786009)(81156014)(55016002)(5660300002)(66066001)(81166006)(9686003)(52536014)(4326008)(71190400001)(71200400001)(2501003)(33656002)(110136005)(8676002)(316002)(8936002)(478600001)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3431;H:AM6PR0402MB3477.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gpDp7TpVvh6BlxH8WZI2Rb30dOGzJ5FuDQ4qSGAfIDNIu35bW9pmt8zrA+LnzeZlvx/D6iN1pyxq5JIR98KCbOk5APkfS6qsFViGFZLoPYCiOv0bK6c50KjUWp0KQiRVlkEZ6trk3Pw0siB/bB4UoTRfwGLnvt2jYTuLTLPDOUQW99crLsw4wiJkOMRXwHuecJcK/Ua9hy5BgLV2OggVcKnCODBEXqh7T/rg81QafBqXnyfMk5QlqnRH4yZQD+kF/oDrXTS9k66DJ0VArbsJ08KBqNjUTM/gfSK0DKgsBDIuyqdtCuOOkjQfR3EtBZPb3Ro4cE2ZWzBJTeXMGYMhLf7h5nbMictHecssDyaR2qH+OGHLFaJGt8G1mPVbAO0cySnv4bVBu46U8zZXyIoTPxtTM+AACBVA1/WVJlKkVfIWoYVegULdmZy6X1vTVWu0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea74606-7fde-4efa-cdb8-08d757db8cf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 17:07:56.9809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bw0jrxyMKXpHJ1HfkSemwkj+ZvcIt7PTjJl4qAVSjUrUHlVRyya2l2NGKPpg3YDXnDrVMMFUlovu3Sm2ETULPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/22/2019 6:30 PM, Andrey Smirnov wrote:=0A=
> Use devres to de-initialize the RNG and drop explicit de-initialization=
=0A=
> code in caam_remove().=0A=
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
