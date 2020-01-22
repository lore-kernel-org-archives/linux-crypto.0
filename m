Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FD3C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 13:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279C020704
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 13:37:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="NdA8pk76"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgAVNhS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 08:37:18 -0500
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:41918
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbgAVNhS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 08:37:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXIOdc2xE9K6Lkc+Czt4g9igA21i7CGtmeDpOelSFBU9RpRNKtkZ0rxFb2baiKYV47jZ1/CPIOs2d+JTAAgPnIme1AF1cl3GTZtiMpMtFvETkl6Spx/WAxhYyxb6in14m4fUFrcpgkcSvbB4M8IAWx1uRPgvG5r7wOaWWiisQ6tIeFNyk8i/qM35hAAAcq0dvphdxj8ozrID+/T8YUVpzfkO+KKYiptOn8Yu7se/BmefOxUZ24UC/hWL3mpI150v6YYzZ5l0gHgKn7kxKyIMISbXzF8MHJiLWeJILTORDvzJT9srYE8Yb0xC2pnX3IH/unbnI3w+jBekJkSV66VG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xe+kS4aN8Hji4TO5CgRKSkA3+PT6jIorPf4+ua+HAs4=;
 b=bnhvY2SXN6qpCHudPVF8tJkJq4tBIuVlYMJ4xOGsVsOsYFbHlk0uEwmF9rq7NC9OCVXaYLOYKtla7H0PhCPXK+vGn5z0BpPvE5wf38ZTA7MlT/TveL2jkflyIITTCXhxRe/inHS8MR913/i6tszd4OPOY/jp0oXJot+T17VYYGYK1v98j+1LiE88hCumtwGsohKS817yCCqID4IUbzk851IlSgdewBpTGCAnvl/7Hl6dB7HlB27kLk93j8B9/Lu09x6F+Ke3rJbi6iOPXWIx2VUvZYwhqnZEMRof5ys7mQFTo+KOdb/VgpkJk/rqN8WZErmMxr6FkQJktgKIf2/0Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xe+kS4aN8Hji4TO5CgRKSkA3+PT6jIorPf4+ua+HAs4=;
 b=NdA8pk76E3R+uDBeaqPhtNbMqPFE9jJaJ0WlQTzLU7+0osUq9oaaP8DF3BRqjxDVzNPFNd9wIxKTHnlr2gKPUzyXI/GDtORcnyf2waURlW8njiRbR5gVcMDk5Mj9J1Fz+SdkQGD9uPlQzRh2cY0/OkT5P33mCL39SKcril1cJFc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3551.eurprd04.prod.outlook.com (52.134.5.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Wed, 22 Jan 2020 13:37:12 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 13:37:12 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Topic: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Index: AQHVxjouh/c8xz5csUKnQ9CkhtEExg==
Date:   Wed, 22 Jan 2020 13:37:11 +0000
Message-ID: <VI1PR0402MB3485015AD186F00B258F76D4980C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-7-andrew.smirnov@gmail.com>
 <VI1PR0402MB3485B3F4C3E39D0D94A1D8C6980D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 648ffc44-697d-4c76-abb2-08d79f402f8b
x-ms-traffictypediagnostic: VI1PR0402MB3551:|VI1PR0402MB3551:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3551740D42BB27A39ACC3C72980C0@VI1PR0402MB3551.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(189003)(199004)(4326008)(52536014)(71200400001)(9686003)(478600001)(86362001)(55016002)(54906003)(2906002)(110136005)(33656002)(66476007)(64756008)(66446008)(7696005)(66946007)(316002)(76116006)(91956017)(66556008)(81156014)(8676002)(8936002)(81166006)(6506007)(5660300002)(186003)(53546011)(44832011)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3551;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cyZduGGIIYXQnEPVqnb2DwjRjRBwwq8o6NxeP/4GZDhcUKa5APlcgYsd2Z81ZIPOozjBSndx9EFocnZEgWZw99+4Gzp6x9hEjKTskSmlhfCu7As7pjHazPivLwjSjPZooTl3AbHNe+PXYpFL9AgWAGlPqRBOgGLZnWlUlQwwe5clQDRWepTldEAw4FhHHNgtqu2X5Ve7wjSFgZKVdl5ysn0u7SdV8Q0bmn1Rn2R7ijuDBrwE6Dx+mgIjL85NRGHygwPgtLpn2NHvOMgZ/Ji9Ln7JtqV4BiwPkX7JHGoxm+6FZi/k0Herj4jfsOi3/1iFzzEUUkNvXq0JFidcqejIZmiM1lr6WUcd9ttzCkpbgImmRRtam+vX1Qscf5DQttMF4s7o0h2jrF+DF14qUe61X43zxK78AZJhcoY/IW2VFTqySVREJnEz80bmLz0a3tLZ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 648ffc44-697d-4c76-abb2-08d79f402f8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 13:37:11.9567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AHF57iDF2E4AloJaJTIEOo2g+urgR55OLbr+H5TAJGQOFrVMhiIwdUG4DftpP2GqI6ahzgosmw6iN2w+3g/q0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/21/2020 6:38 PM, Horia Geanta wrote:=0A=
> On 1/8/2020 5:42 PM, Andrey Smirnov wrote:=0A=
>> @@ -275,12 +276,25 @@ static int instantiate_rng(struct device *ctrldev,=
 int state_handle_mask,=0A=
>>  		return -ENOMEM;=0A=
>>  =0A=
>>  	for (sh_idx =3D 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {=0A=
>> +		const u32 rdsta_if =3D RDSTA_IF0 << sh_idx;=0A=
>> +		const u32 rdsta_pr =3D RDSTA_PR0 << sh_idx;=0A=
>> +		const u32 rdsta_mask =3D rdsta_if | rdsta_pr;=0A=
>>  		/*=0A=
>>  		 * If the corresponding bit is set, this state handle=0A=
>>  		 * was initialized by somebody else, so it's left alone.=0A=
>>  		 */=0A=
>> -		if ((1 << sh_idx) & state_handle_mask)=0A=
>> -			continue;=0A=
>> +		if (rdsta_if & state_handle_mask) {=0A=
>> +			if (rdsta_pr & state_handle_mask)=0A=
> instantiate_rng() is called with=0A=
> 	state_handle_mask =3D rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;=0A=
> so if (rdsta_pr & state_handle_mask) will always be false,=0A=
> leading to unneeded state handle re-initialization.=0A=
> =0A=
Sorry, I missed this change:=0A=
-#define RDSTA_IFMASK (RDSTA_IF1 | RDSTA_IF0)=0A=
+#define RDSTA_IFMASK (RDSTA_PR1 | RDSTA_PR0 | RDSTA_IF1 | RDSTA_IF0)=0A=
=0A=
which means code is correct (though I must admit not so intuitive).=0A=
=0A=
Horia=0A=
