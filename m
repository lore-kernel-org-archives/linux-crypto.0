Return-Path: <SRS0=5U1R=QL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA6AC282CC
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Feb 2019 12:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC717214DA
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Feb 2019 12:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZSzB9VKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfBDM0a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:26:30 -0500
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:53529
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727284AbfBDM0a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Feb 2019 07:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OH0vCZGOt//nvRXoni7kMoWwHTDBD6eOLThITEfzlo0=;
 b=ZSzB9VKNWi8p1q/PzyzM9DHRsTmw2+91Mxov9fdwN8sJt4r/jRYYHFlDNHUsk8Z0/litiAB2nYvDW7Jby9rjOakZaGf/JU//5myMAP2Z4E4F70+esKd5QMVDLUKkd7kHM/T8tOZLgHq4wa4xqlu/+cCq6TwL5cbvwcZ9cGHUzuY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3933.eurprd04.prod.outlook.com (52.134.17.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Mon, 4 Feb 2019 12:26:26 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1580.019; Mon, 4 Feb 2019
 12:26:26 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Thread-Topic: [PATCH] crypto: caam - Do not overwrite IV
Thread-Index: AQHUuSvyCmTFYLEeOE2P2XtmnR+/Zg==
Date:   Mon, 4 Feb 2019 12:26:26 +0000
Message-ID: <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3933;6:TyGz6+kFAyZt8Ui7QxtWAqiViKeQ9HvO3q2oMeFSQFHEy8ahWZy/8wd0Ppct+ijnYM4zokZE6qw7fn30PVhNJ0Y6BwkfrrgQ0CRqBOccpUX9WXa81Sxq1cWuc3zXh0/d+Ws3sCoqZynURok+syB6gF4SV6TIkvveVlOiHzOuH5ZGost9AUtH2gLl2FZzGx2IBoXlA77TzSZ6Nkd5/gKXbsKP/zVuRxN0Z9Sbk0TNnMsvb5Fk/mLwM0gDdOI5KzagQY61+UiozzLJSNSsb55Oa2lG7MIQYT7A6KjF0Zd628j2IQdulXdNpGc9mB9mFdI4UHnWWiwTayUIfx/vP1nP5gl9SVUJb6g+Brw3Y5AIwuaYhuXRnbUTzqxNLcDZ5iALo5tl9nVh8lo2j/hIl8aT2kghhvZSCyV/TgciGFwiBJq2hwhYj2d1u9xtTOORpkQ1r13fHQFylUOhvkiyu0uwog==;5:BNOu4OG8z18GD9yByzj+KxHAdcrFsvhdjwHfiDVbPYyCb2lURayi0vnSRj2utaHtg9KCZwPIkI3xaK9bx0AudRGjq4mW9V2EikRqoYJcTp6a1jS/ec/R3ERbn5+jz51vLZeuSY8+MBXGi1caldLCeYjdu/oklpklMsSZ7oLg2VQLpgz+eOLVMqoiyG7wD799rHYANAwQ5Mp4iMJpzF2ILQ==;7:gUvFDnmCHSpGFxHZizT1zxjQ7B1XEsolQcwreybCPMAZd3FBFDdrKQhk3GwMPw4Vo8uH2KsStdbNYmpJr0+wSi8NB5VI2mn/gDLQfD/UvQ76j/Jgxx27hG/CkZXP+2ZMsq2a5cE8gQ8tSuRv24y3Jw==
x-ms-office365-filtering-correlation-id: 446c8e97-5693-4105-6587-08d68a9bfbad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3933;
x-ms-traffictypediagnostic: VI1PR0402MB3933:
x-microsoft-antispam-prvs: <VI1PR0402MB3933C0A3C226ECF839E2CFB9986D0@VI1PR0402MB3933.eurprd04.prod.outlook.com>
x-forefront-prvs: 0938781D02
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(376002)(346002)(39860400002)(199004)(189003)(86362001)(68736007)(3846002)(2501003)(256004)(6116002)(14444005)(6436002)(476003)(446003)(81166006)(97736004)(229853002)(66066001)(74316002)(55016002)(9686003)(8936002)(7736002)(486006)(186003)(44832011)(25786009)(81156014)(33656002)(6506007)(4326008)(6246003)(26005)(305945005)(53936002)(2906002)(102836004)(8676002)(478600001)(76176011)(105586002)(106356001)(316002)(110136005)(54906003)(99286004)(71190400001)(53546011)(71200400001)(7696005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3933;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s6b9LePqJduUhdmBSDixyEY8yVrpyo8UoSLOHQmp6r+IhSf9tDkwlNFwG2GDN/+6KiSdZP/Ma0TxrEd0eNxiN+0OHsthLREUCbnTMa7nq9/nyXOU7+qGxiqKzrHn+f0/mRe8yFR43zjuu1bLwiZya4z3bJTSlpNFQTb1pYr0kNIsJKeBA1eqFGV8H2SiZ329NMNxsNe8OjJf/ySYy44dJRExsqzORiwrFDkC40OQE/6jy1U3wKSQhwpV1Z7C6dqWvFMhBuh6+J841IatZmXx5OfQRI79B18arBhoet8W/d6z4Kj/1ASOb5TDdwn2rFonhBG7HA/SRJecCmMCDd488/DcgVQ3Fa7riXMDGQyNH8TsfyKgVO3t9HcbjfkW3ktpGzUvUEiuf15YQ3T8GeN80Q0om/AyKQ5tL3UvkfXWOtY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446c8e97-5693-4105-6587-08d68a9bfbad
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2019 12:26:26.5291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3933
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/31/2019 8:12 AM, Sascha Hauer wrote:=0A=
> In skcipher_decrypt() the IV passed in by the caller is overwritten and=
=0A=
> the tcrypt module fails with:=0A=
> =0A=
> alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-ge=
neric): ret=3D74=0A=
> alg: aead: Failed to load transform for gcm(aes): -2=0A=
> =0A=
> With this patch tcrypt runs without errors.=0A=
> =0A=
This doesn't mean the patch is correct.=0A=
crypto API requires skcipher implementations to update the IV with the last=
=0A=
ciphertext block.=0A=
=0A=
The root cause of the issue is cache line sharing.=0A=
=0A=
struct crypto_gcm_req_priv_ctx {=0A=
        u8 iv[16];=0A=
        u8 auth_tag[16];=0A=
	[...]=0A=
};=0A=
=0A=
Since caam does not support ghash on i.MX6, only ctr skcipher part of the g=
cm is=0A=
offloaded.=0A=
The skcipher request received by caam has req->src pointing to auth_tag[16]=
 (1st=0A=
S/G entry) and req->iv pointing to iv[16].=0A=
caam driver:=0A=
1-DMA maps req->src=0A=
2-copies original req->iv to internal buffer=0A=
3-updates req->iv (scatterwalk_map_and_copy from last block in req->src)=0A=
4-sends job to crypto engine=0A=
=0A=
Problem is that operation 3 above is writing iv[16], which is on the same c=
ache=0A=
line as auth_tag[16] that was previously DMA mapped.=0A=
=0A=
I've checked that forcing auth_tag and iv to be on separate cache lines=0A=
-       u8 auth_tag[16];=0A=
+       u8 auth_tag[16] ____cacheline_aligned;=0A=
solves the issue.=0A=
=0A=
OTOH, maybe the fix should be done in caam driver, by avoiding any writes=
=0A=
(touching any data, even seemingly unrelated req->iv) after DMA mapping=0A=
req->src, req->dst etc.=0A=
Having req->iv and req->src sharing the same cache line is unfortunate.=0A=
=0A=
Herbert, what do you think?=0A=
=0A=
Thanks,=0A=
Horia=0A=
