Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F261C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 12:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D055A21883
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 12:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="dXi4woBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfIDMpE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 08:45:04 -0400
Received: from mail-eopbgr710044.outbound.protection.outlook.com ([40.107.71.44]:37056
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729594AbfIDMpE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 08:45:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWgW60ifj51exDwSnx7/XwGW7XX7dKzwB9doz2apkD1TCS1S9yuNibN4CZHVVpia6KvamNoI8gU1gUv7CS3Sn4kgX+0dkXvxBZrEzKcOpXi6C0BIGM+6wWGp5sBpP9xH8KNgORI/Nl7RjmMOBU7QHI1XSivCr0U3pnNMjDegDz80ZC6jLGJRTXjtuB0Ia3VPWgTincIYtawvhjU2TPR5q0WvcdLaVtNnzpHJzWxGdGqUSYDGX7bSDQytxJUiAaNODH1b9SS35BE5RFaDx8CPHOmOTuT5DFXJL807BmVkLluRGmPjEkcq40V+jDAT83hWzRo6iyG7duglvsvFFoy2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVCCklNd4uD7Cj32555JuwbPR0YJLJRnOgsl+QdmAi4=;
 b=VdIgiPlc+TXdJy4npR/iFmZroZCMI3h2VJxWfStQ9/ldXR5UgcxzL8Kvup7ISZKkSOLOOBbXyLyHyyRyoxT2rv9xijQXt07bj8NvMrYfPoYUJaIt7/H72LMEPD7FaGBu42hUtgYEpdezydYq29MpSxlu90EU11Y/CSwcavw+GuHZz923Qm7/wPYI21rccbxXaxvrB3DWRky5RaqsDv9t6+Q2KnCvVvgkxSwS3Whq3B2i8noS4gUk22lbTSrW8oLsk0f3eoOk//fA5oubiufvpCTWOpJlsVQdMi0O0e9gFjY1nlVLB5KUXuw9lx1b5E7ZNE/LTTTeqGosBbHlGZpGxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVCCklNd4uD7Cj32555JuwbPR0YJLJRnOgsl+QdmAi4=;
 b=dXi4woBWw2wVcb61PsX2BnSgDJOJafFXz4RxiZzOhUfQ7C0zKz/IXUrbydgTmCV44jrV8nykl4UMU3orVzFuSWafeq01axVgAdREU1WB9u9uPgDSeNJpGabIQlICc7ZJkrguc5GGnq3veT5vDqqRRsG3SFrKMRO2ezhBbQcYrsM=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2816.namprd20.prod.outlook.com (20.178.253.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.22; Wed, 4 Sep 2019 12:45:01 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Wed, 4 Sep 2019
 12:45:01 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pvanleeuwen@insidesecure.com" <pvanleeuwen@insidesecure.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 -next] crypto: inside-secure - Fix build error without
 CONFIG_PCI
Thread-Topic: [PATCH v2 -next] crypto: inside-secure - Fix build error without
 CONFIG_PCI
Thread-Index: AQHVYfrTy4jcxbeEsEeyU2s27hKUDqcbaoBwgAAFDACAAAHAQIAAAu6AgAABToCAAANUEA==
Date:   Wed, 4 Sep 2019 12:45:00 +0000
Message-ID: <MN2PR20MB2973A03BFD630B654A46ACB8CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190902141910.1080-1-yuehaibing@huawei.com>
 <20190903014518.20880-1-yuehaibing@huawei.com>
 <MN2PR20MB29732EEECB217DDDF822EDA5CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8PVYyA-mzjrhR6r6upMc=xzpAhsbkuKRtb8T2noo_2XQ@mail.gmail.com>
 <MN2PR20MB297342698B98343D49FC2C82CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_EA8-=Vc3aAdJSz7399Y5WBeKNjw_T3LEq7yOY2XQ+BA@mail.gmail.com>
 <20190904123158.GA29870@gondor.apana.org.au>
In-Reply-To: <20190904123158.GA29870@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ca3f9d8-834e-41f7-4e2f-08d73135b399
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2816;
x-ms-traffictypediagnostic: MN2PR20MB2816:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB28164B74CDA51688A739EAC6CAB80@MN2PR20MB2816.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:98;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(366004)(346002)(136003)(189003)(199004)(13464003)(74316002)(186003)(7736002)(15974865002)(6246003)(14454004)(53546011)(305945005)(7696005)(6506007)(76176011)(55016002)(26005)(71190400001)(14444005)(256004)(71200400001)(9686003)(6306002)(6116002)(53936002)(102836004)(2906002)(33656002)(86362001)(81156014)(3846002)(476003)(229853002)(8676002)(99286004)(66066001)(8936002)(316002)(54906003)(110136005)(76116006)(6436002)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(478600001)(4326008)(446003)(5660300002)(486006)(11346002)(966005)(81166006)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2816;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 98+amSvjE1uuHP3AMd7lsKWPLdyarasUp85gJ9MJu1VCTCeS6Z2UTKRy9cR5nUADvuJ0RiY9g/vl+U9OZTabHRFBb/O50uRNKHyIs6AjgqXhjQBl2iw9STcR/pv42PsdtzCyQgnJwiKATqKG9WHiejNTtAIj+qiWtwUFue7vlYxei7cYtqGrlK9A9IcYXaH/k8Z3tMz3VuGoiC6xgMNN/ni3vwR6S93VdZch2vWgAWSBB/BhgLYTZr9QjPZefpwK8zzyYWKYw09ub4nRFssQNyWISAIiPh+iRHJvEueRYLXIjPje60OdiYq3l8L9pW5TpPqZXH/gU4DmUdl2gY6oCvOLo1NCPO0/UZU2e4gNN5sObrMQRCWSAWFXPUH51vQ2Dz/XUTrhiFCJsAVdVWo09A9qNqPlpFv/v8HQLdEfeyo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca3f9d8-834e-41f7-4e2f-08d73135b399
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 12:45:00.9562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LStbX4FIT5gDw0k6RC038iYzEBZUud8uw+ORyC/5zPsxWHjuBrzHrOqGvt/D2h+WcjQyYkD+ymhHVtYgB6KfsbGV85Qte4NSNHoViIJk/0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2816
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

So, with that patch you ONLY get a warning on that unused int rc, right?

I do understand that one, that should have been inside an #ifdef as well.
Everybody happy if I just fix that and leave the rest as is?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Wednesday, September 4, 2019 2:32 PM
> To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; YueHaibing <yuehaibi=
ng@huawei.com>;
> antoine.tenart@bootlin.com; davem@davemloft.net; pvanleeuwen@insidesecure=
.com; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 -next] crypto: inside-secure - Fix build error wit=
hout CONFIG_PCI
>=20
> On Wed, Sep 04, 2019 at 05:27:19AM -0700, Ard Biesheuvel wrote:
> >
> > Did you try disabling CONFIG_PCI?
>=20
> Indeed.  Even with my patch if you compile with CONFIG_PCI you still
> get a warning:
>=20
>   CC [M]  drivers/crypto/inside-secure/safexcel.o
> ../drivers/crypto/inside-secure/safexcel.c: In function \u2018safexcel_in=
it\u2019:
> ../drivers/crypto/inside-secure/safexcel.c:1506:6: warning: unused variab=
le \u2018rc\u2019
> [-Wunused-variable]
>   int rc;
>       ^~
>=20
> We should fix that in inside-secure.
>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
