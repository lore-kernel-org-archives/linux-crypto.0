Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C2CC76194
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 05:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314B5206DD
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 05:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="avWtvc28"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfGYF5d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 01:57:33 -0400
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:18230
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728660AbfGYF5c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 01:57:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRmMODcGucD5gaIlYRs52mWlf9mt5vnQactYhhU8aDyCdVjiDzo1+W3v6Al43QqBqOD3dpT0a6hrG/36+y1BrFwOLorkfJ7DbCGp2ii+RbWmx2CjSY0nqvRxPlqTYQEy0Hccf81DL22Z7krK2zUqcQh/16mpWlK2MWYN2zwu6JR91wXmdU9VaqlVqO/0q+vMPv4+8/wT2X9FEb3lXohmz2X4/RY5imMDVIQ2i+e49eCY8IhiH1Wlc/RUaxU5ViMfS1d9WUrFsjG+2AfjSWsJ7t2RnzvJf1my0rMslV3qMcf4uO/r1t8rjy4V3W+Ihvzo+hFObRVX3GNQzXni4znZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxIixHS6XV3lXoUW3Kh64YP3d/5AXKJ+ghq0NUXKWjg=;
 b=KGa2QhLdIETr36PkMm+smmCsiRZ+9pKhPoSJpaD88UOak0+BmseY8dD8dkN1rgw7gsGeB5KVOKWL8dP1xwtaarnhLUubv/7HAV+5zPRFJ5iqbXA/efGaB5DCVGtUnS2GJVb/tDiwgfBgd/+P3vf+LOY36vAS/31o/V571mtFkqQT04JNM5ZDCxOXJpfzIHdP4nR8Q8HT2NLGCHm7XLJqMYRSu8dzkoCSpzlHjKtECGIWyrF4sn697VSLh4JD1jgkQpwbUdiP7+NE2rbQVMTcaA117ZjkI5dBXfsYFPGbmtpIhmXTT5tK8IWIIlSyNAedCJMB5rgWxyrPKnv5iFcngA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxIixHS6XV3lXoUW3Kh64YP3d/5AXKJ+ghq0NUXKWjg=;
 b=avWtvc28K91xMSovzByN+xZ9SUSTY02BuppuW6jlJRaplRDJ7nf77KJW1lhUrI1KtkHk5FXR7n1Oge25PCro5/G348//+vD7rHmWhFEN7Ihe7NWMa7aqUk2XjtE9y8hbBw0IAXqWAnU3tHg1hjsJKF4eJBLo1naVTVddVYOwfRE=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2799.eurprd04.prod.outlook.com (10.175.20.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 05:57:28 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Thu, 25 Jul 2019
 05:57:28 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Richard Weinberger <richard@nod.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>, david <david@sigma-star.at>,
        Baolin Wang <baolin.wang@linaro.org>
Subject: Re: Backlog support for CAAM?
Thread-Topic: Backlog support for CAAM?
Thread-Index: ARBzCkuiRpn89WxIsrxtpCssT2oQQg==
Date:   Thu, 25 Jul 2019 05:57:28 +0000
Message-ID: <VI1PR0402MB3485A27D2D9643F70E1873A398C10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <839258138.49105.1564003328543.JavaMail.zimbra@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9548ee40-3a2e-4ba7-4288-08d710c4f99b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2799;
x-ms-traffictypediagnostic: VI1PR0402MB2799:
x-ms-exchange-purlcount: 5
x-microsoft-antispam-prvs: <VI1PR0402MB2799D3A48C46BD13057664F098C10@VI1PR0402MB2799.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(199004)(189003)(66556008)(7696005)(6306002)(102836004)(476003)(53546011)(86362001)(44832011)(186003)(66476007)(256004)(66446008)(5660300002)(55016002)(76176011)(14444005)(64756008)(2906002)(486006)(26005)(76116006)(53936002)(4326008)(52536014)(6506007)(6246003)(966005)(478600001)(14454004)(446003)(9686003)(91956017)(66946007)(305945005)(74316002)(81156014)(68736007)(81166006)(3846002)(8936002)(7736002)(6116002)(316002)(66066001)(2501003)(71190400001)(229853002)(110136005)(54906003)(33656002)(3480700005)(71200400001)(25786009)(99286004)(6436002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2799;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qISRV5ez/5hlreqJq452u82zuj3req+WisHdXGAzH2QhkqPv31YIWzW4Y/llxxnnhqi8EkEXD8RQiNJ3juMuCfICm6wDNRXFHx4AY4RIsdezSk4raq12w8IlqvgsOJNSFWK8ParZf+CoVPuS6wPAL9pP6o+LpXQGkv2qb4qs4KgnrAt9kXR1p8cbydmgBmo2FEr8wv/8C2GEcK3wFduH9ywXgiH2jsk/zQWat2gvIuV9ASQKVhxtnDTTaMHwFZ8npVSBAaiIUpPoBdxwtmip6UI6uUnbYUfCa4NCK0q7hcTbhw6Vsw6Y7B2VZ2w12/b95Hp78se93KnCMx1zDhBBdEpuvjtscfzzbgcTDVhp1/Z1z60tQv0g6rC8ghAhwecZQFjtBgl2e+U1Ifr9U69t7p2SG0TBF0I7OMM3xbherV0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9548ee40-3a2e-4ba7-4288-08d710c4f99b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 05:57:28.1871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 12:22 AM, Richard Weinberger wrote:=0A=
> Hi!=0A=
> =0A=
> Recently I had the pleasure to debug a lockup on a imx6 based platform.=
=0A=
> It turned out that the lockup was caused by the CAAM driver because it=0A=
> just returns -EBUSY upon a full job ring.=0A=
> =0A=
> Then I found commits:=0A=
> 0618764cb25f ("dm crypt: fix deadlock when async crypto algorithm returns=
 -EBUSY")=0A=
> c0403ec0bb5a ("Revert "dm crypt: fix deadlock when async crypto algorithm=
 returns -EBUSY"")=0A=
> =0A=
Truly sorry for the inconvenience.=0A=
Indeed this is a caam driver issue, and not a dm-crypt one.=0A=
=0A=
> Is there a reason why the driver has still no proper backlog support?=0A=
> =0A=
We've been rejected a few times or the implementation had performance issue=
s:=0A=
v1: https://patchwork.kernel.org/patch/7144701=0A=
v2: https://patchwork.kernel.org/patch/7199241=0A=
v3: https://patchwork.kernel.org/patch/7221941=0A=
v4: https://patchwork.kernel.org/patch/7230241=0A=
v5: https://patchwork.kernel.org/patch/9033121=0A=
=0A=
and we haven't been persistent enough.=0A=
=0A=
> If it is just a matter of -ENOPATCH, I have some cycles left an can help.=
=0A=
> But before working on this topic I'd like to figure what the current stat=
e=0A=
> or plans are. :-)=0A=
> =0A=
Right now we're evaluating two options:=0A=
-reworking v5 above=0A=
-using crypto engine (crypto/crypto_engine.c)=0A=
=0A=
Ideally crypto engine should be the way to go.=0A=
However we need to make sure performance degradation is negligible,=0A=
which unfortunately is not case.=0A=
=0A=
Currently it seems that crypto engine has an issue with sending=0A=
multiple crypto requests from (SW) engine queue -> (HW) caam queue.=0A=
=0A=
More exactly, crypto_pump_requests() performs this check:=0A=
        /* Make sure we are not already running a request */=0A=
        if (engine->cur_req)=0A=
                goto out;=0A=
=0A=
thus it's not possible to add more crypto requests to the caam queue=0A=
until HW finishes the work on the current crypto request and=0A=
calls crypto_finalize_request():=0A=
        if (finalize_cur_req) {=0A=
		[...]=0A=
                engine->cur_req =3D NULL;=0A=
=0A=
Horia=0A=
=0A=
