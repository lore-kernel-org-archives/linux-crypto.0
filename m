Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCE1C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 09:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04271207FF
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 09:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="c+oeEFfU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfLJJbw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 04:31:52 -0500
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:31495
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726915AbfLJJbw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 04:31:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT0dZ59o8t0Zz5KulJ0ocL143aF51zSHXRADA8Z6Qweguqtl89IKqXO+N+Fdw4VaZ6Ro941GEsoljgo/g/DCR/qGrXJSL1nZI0vMjzJ+a0iAs3bdwzkSC3pq97BkL9SXah1IGnWXashQwgd2UrxHIwIQ9c5iOZLv+zdbzu1pG92v80CXfhxAdfCkENxqCPEIyadF8oq3KbSOmAU4OUpZGNoYZlQBcRH3Uj1XF1wSJVg6evFNujz5epaO02wjqEz1L/vETTca/u5wQ01WoMAt+7nAQQwL7+oOHp+Bl+jX8QwyES4I0WlMRJmfxFbiW7PYMBPCEvRdHiFUJ98cfvqVBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j8MCDT2xr4+/zoAj+Ms/v4LbIXbuAZDmLTTi6A6dY4=;
 b=dIWWbDR0sOX7LL9P8uiljH2S4zKjxq0S9DsWMiVfVG6zERdD2ANkXVJfjhYBAbRFS7yNzsg7qptGRODewL+uKtg10K7GCheluCH8t9uRkhomuHst31yOEyqRL38tpsgEc5rOH929KjWjA6xSnDS76upu+qLje2X//j86IDUsUEdhuNkY75fzR0icRdIAa+GxjhvsXA7/5VyoH5BaAiJT7k5fp3qxhca4Tgk9tejtXed2MskgsFWdMwEdWq7Ghw54vVZOPqzBifWpmk4dbhyUhzq5BU+w2RZRwjhvMkpffRPL7FPNN8netThPf/HqAptQdLljFNSXINkeKtLP9bbA9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j8MCDT2xr4+/zoAj+Ms/v4LbIXbuAZDmLTTi6A6dY4=;
 b=c+oeEFfUuPB4V8GBVjAFd903LhaoYPXqhfF6X+Lue8uRP8MB/JhH3FqQNpgMTqbpk7wy+AuR66mA6yUbfllKD5Y3dVgyi20uCDRszaQ6tQyjgqUZJpDL/iEPMii+6z1Q+LkcaKV1oZj8rttuczqcJ6GJTr6iRKW6tLUvQKTKr2I=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3502.eurprd04.prod.outlook.com (52.134.6.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 09:31:48 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 09:31:48 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrei Botila <andrei.botila@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] crypto: caam/qi2 - remove double buffering for ahash
Thread-Topic: [PATCH 2/2] crypto: caam/qi2 - remove double buffering for ahash
Thread-Index: AQHVrrIh3yV1/0x7hkmMMJGBljM36Q==
Date:   Tue, 10 Dec 2019 09:31:48 +0000
Message-ID: <VI1PR0402MB34851B7EE78BAF4FBCCF534D985B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1575910796-13897-1-git-send-email-andrei.botila@nxp.com>
 <1575910796-13897-2-git-send-email-andrei.botila@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 274e6c6b-aed3-4f96-6828-08d77d53c7d9
x-ms-traffictypediagnostic: VI1PR0402MB3502:|VI1PR0402MB3502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB350287E6D0FBAA6AE63D5E81985B0@VI1PR0402MB3502.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(189003)(199004)(71190400001)(52536014)(55016002)(9686003)(66556008)(71200400001)(64756008)(33656002)(66446008)(305945005)(110136005)(54906003)(91956017)(86362001)(76116006)(66946007)(66476007)(229853002)(6636002)(8936002)(478600001)(316002)(5660300002)(53546011)(6506007)(44832011)(186003)(4326008)(4744005)(26005)(8676002)(2906002)(7696005)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3502;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XeNNEdhXOQAv2oIy5CaOzZ5oYivLiJfKH0hdXcmnAjU0Y/Xg7p2kXHLU60T2Ry4Vcot2iBW4jjuvffJt5N/FVOKet0MsS8rkBoVInZqOrfxN52z+E6mqNwI3kEnQnvPWGoYETUmWEHpcuilD4YKvGu7NKwAfestAWy0n6O3k7rqQLs2DFMhH4UHtVnqceXHU/Lu54jhyRNeyg9onBv6T+QVR15nJ3wa2b0GiiLGbP677Gy63z7m+ol4j8tJPZ7cho6CevUt2jGRVY9/3kUT5xQpa6mqxrIEmzeuHEchNiipeFcYn8BnOAstrtgHBgYiU7TzxTFruAr2yQc6GkU3spHcYsHN2yiJlII1z5iQltV9jQvRLdQ9GThFsIb+iV1aC4sujPHmGzq51I9g5hhQ+X2lUq7qHU2kRtELRRwmyS8/XNrJWwXs44rfwgkRFTpxE
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274e6c6b-aed3-4f96-6828-08d77d53c7d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 09:31:48.3177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZBvQ8qWN4JOYiZeqlVhH55XnjtVOguRqfTiqv+AlrWQJgwM2++UECDhOb1VeCd5KmArXKENXnv5m9iHmj4DFFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3502
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/9/2019 7:00 PM, Andrei Botila wrote:=0A=
> Previously double buffering was used for storing previous and next=0A=
> "less-than-block-size" bytes. Double buffering can be removed by moving=
=0A=
> the copy of next "less-than-block-size" bytes after current request is=0A=
> executed by HW.=0A=
> =0A=
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
