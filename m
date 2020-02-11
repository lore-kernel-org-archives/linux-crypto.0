Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90715C35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE1C2082F
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DYGVY/nK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgBKSxp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:53:45 -0500
Received: from mail-eopbgr60053.outbound.protection.outlook.com ([40.107.6.53]:56363
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727722AbgBKSxp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:53:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbRD19NFMsSzP9pLY6QUA4MvPx3jSf40kuffhXGckrZrrpAhOc6FvPrMg2EFI4diZXLtapgLw58pm2HJqJ9z65bMitRaoiZO/T03kT29E/9aqENYmoFU3pzT/nOTFW0R765VuECq0A1poJOLzmt68RKB9CLXkaAwVwJtl1KBMEfuebHO/Pkqn3sF6G+P42OmkPE+bfZKDF0nh4vubVuoHooxuUafN/qF4QxVVFlloQEevz4JheQzVMUw0CQkcR/HX18D7dnPDJWBAPdv3v03lx+3lx91kj0DLVCd7w09K+OirUmYiAL5UqztcchUJpffZg/NmDtE31R2E920SpRBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EorlvC4y/V5Oor8pHisTaW0aW0TqdSVDWI+Bioph3Yo=;
 b=mH0yOTh9U9UjEM17dKUcMA2hrmtto81Gq4p+tpScW2ayQEVj/Xu18N9IBWmu/Tgw6mUiMQE6ej16wk131d7Du9ZmVLa4g0p4dxAwQf/5rl8mE6zfOPAYmXKS0/jIWGZUhIOWBNOTg12NTqQZs5k5DztViDO54XMcpm8ZX3WE6kYp4d2L1eJrfKK7CdUjI1OgUotwYqshKdr9rMH3IfQKuTykD0iTZ9idcf4jT9iy38eQAl6ha2bEYDWe8LgV1N6cZsctJhY2CE9cAwHxourUppl0shPvjkMo4IjofguSALqKkWWWIZ246scPbDH/i/duLgvuYpjCZRm5gxVphjBDMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EorlvC4y/V5Oor8pHisTaW0aW0TqdSVDWI+Bioph3Yo=;
 b=DYGVY/nKh2YA/tBM2OZsRAVNHMiGUKyH4tVOxLD54Yp0I+EXa+eCg1wOtMtuE3qxwrMqTGJh2Gckej+j+TRfAem2S5nVxPzLVaC//k6f8WTSsoSaAfkxsrjaa7AbFiKHFFQr9AXrZ+93c1T8/WUFsvpH4HkBNtt2gSiZgUdP+oo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3934.eurprd04.prod.outlook.com (52.134.13.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 18:53:41 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 18:53:41 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v7 4/9] crypto: caam - drop global context pointer and
 init_done
Thread-Topic: [PATCH v7 4/9] crypto: caam - drop global context pointer and
 init_done
Thread-Index: AQHV1TLT2rTrmTBv2U6pvLOb9zqi1Q==
Date:   Tue, 11 Feb 2020 18:53:41 +0000
Message-ID: <VI1PR0402MB34851436875DA6CB8524C92298180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-5-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56f65fb0-d8fb-4b37-2ac5-08d7af23b663
x-ms-traffictypediagnostic: VI1PR0402MB3934:|VI1PR0402MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3934D2F233741CC08A7DB21C98180@VI1PR0402MB3934.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(55016002)(81156014)(66556008)(8676002)(66446008)(64756008)(81166006)(9686003)(66946007)(6506007)(66476007)(7696005)(53546011)(316002)(44832011)(8936002)(966005)(33656002)(91956017)(5660300002)(71200400001)(110136005)(4326008)(45080400002)(2906002)(54906003)(52536014)(26005)(186003)(76116006)(478600001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3934;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JNQXAY5JE+G+wzGeWEdeGGxfGA/KVYD0xsLpJOGdMzXyJ1ACZp4xD9VPup/fBPKyGuRyyaNtPG++xRCV4QyvKp2yoQlpeui5c37F4tybJh55OUJBUSDJiq0DRFKTInXRB5NIFzZ/zR9lcasjfy//YDff10ig2pHU0VBXTOTIDdyM3A1oG1JX3a5n5BEOkzMb0dAEjRT6P/PTYiW7dMvPCEqxRPEdHgK2JdFchulu7o5oruyNR4q1k12324e9NZRj356QOY5+Cvh47gKkfvnIF/BC1BRinbuOK+TG8M1BszRZl3oSJ6UYaS2M/DrzremaxwJcHeVQAC5hsdydBO5S+beRXM2P88VRlkZQHtDqQJjRdMGaHcoQd2Gq9eeOcYzEEdYV6qwDtx5aJXeBGKRATUeN2IFWcvE9emen63/hwN1UooEqy2KpS2f8CeBaC7HYiRcVPuhjPavQycDNUekGty+3jPjzbKVPW8tIw3Mut51kgh+KqhWLaUbUqF+SqoOW8zxHzzuZ4ktSrfrJuf4ZHA==
x-ms-exchange-antispam-messagedata: 5dYm/b+hbjUEpVkLejx6te/NtNqV6JaRP4HhtXviuokB66OVrYQ6hHwqOrqawNnRpiAPSiOCqr/C39u4X3QJ9OtvNhq9a9wSxwIx8PVW27HTDGPTcQEFKJaD0GfXsv0uLrPVc2f5GIhMRlsg2kydzg==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f65fb0-d8fb-4b37-2ac5-08d7af23b663
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 18:53:41.3134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9QziBJaFkegC6XDevCZrLFp/2ZuIDdB2QCMCugz6pgenW4QyQmj+QtdGzZ/ewxyNBWiajBdIuGfAu4CQBdmG7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3934
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> Leverage devres to get rid of code storing global context as well as=0A=
> init_done flag.=0A=
> =0A=
> Original code also has a circular deallocation dependency where=0A=
> unregister_algs() -> caam_rng_exit() -> caam_jr_free() chain would=0A=
> only happen if all of JRs were freed. Fix this by moving=0A=
I wouldn't call this a circular dependency.=0A=
=0A=
I think the discussion & patch here:=0A=
https://patchwork.kernel.org/patch/11140741/=0A=
https://lore.kernel.org/linux-crypto/VI1PR0402MB34859D108C03F3AB0F64EE6598B=
10@VI1PR0402MB3485.eurprd04.prod.outlook.com/=0A=
=0A=
describes more accurately the problem:=0A=
"The issue in caamrng is actually that caam/jr driver (jr.c) tries to call=
=0A=
caam_rng_exit() on the last available jr device.=0A=
Instead, caam_rng_exit() must be called on the same jr device that=0A=
was used during caam_rng_init()."=0A=
=0A=
> caam_rng_exit() outside of unregister_algs() and doing it specifically=0A=
> for JR that instantiated HWRNG.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
> Cc: linux-imx@nxp.com=0A=
Current patch is similar with the one mentioned above and solves the proble=
m.=0A=
Thus, with rewording the commit message (and squashing patch 3/9)=0A=
you can add my=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
