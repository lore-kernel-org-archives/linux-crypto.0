Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEB6C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B80E3206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="jqAdC5GU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfG3MYi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:24:38 -0400
Received: from mail-eopbgr720072.outbound.protection.outlook.com ([40.107.72.72]:14496
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728219AbfG3MYe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:24:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlnaKHCCvhYUz2MVxJRZ0D2+dzWyqktNrlpH23gx5K4SVBZ3Z6FVoVvvwOjLDE7la9oXuAQvk1ZTCiG3AdyaGntKSao+taaMahP2h32wWP47IcbI31Ab9+Db/ZTdMlwzeBnjuaAhezeKebpbPhCA84RZI1nmmt5gPUTFHPCnBRnchV6u+bLSh+Z/O6HMEZJtoBu8SAJE7vMoCOUUy5lfuVrlEW9RWEAjjc7RE30JrYLznCUajBPwdEktf+v1cNDXMhz2q5VtrteVqw/y5isXwUKHxavN1qK9lUJID16o8LCfxP0kVMExZ4GV24C9bQ9Xj1jkFAOTe/myzbnGmRJAXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWUeAVAMlglKatkQSnfVdmjGOUMvKyW7K4SeR20JxGk=;
 b=cEMLUlvoA9N4+iHJuc73XJzkXa/kwp8aTYCZkGhTTsEkdx5MQ1t1SQOzoQXQ2FQYW652InHIsQ60kGJIIORV7gimagydtT1WUaB8kkxEqbxpBvrZ22dVEhJzHy+fer2Qtqskv7MuCg1DbfDqwAvS+kB+rGULO3inFWdYslb+meC2fr6Ed6zmpGgH4Sda0Onw0rk/7bcNouOqHGj+TJmiOTjYDbwSbvI9kZn1SKx41onBcnVJxjcVtxhjdedakEFd9HVOqV74i+2/dFaAMP80omDB+gl45WiQlAZqeH69Fq4KWWceVgu5G7uVmQJFeojDBU5kobkD6g4un0zM1dN+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWUeAVAMlglKatkQSnfVdmjGOUMvKyW7K4SeR20JxGk=;
 b=jqAdC5GU2j7mSdCCumFCaTaeWL6rsO4Aet6nHpVGueqgrrPvHijMeGtAk+z/Taa5oqoWLYsSmoqBI7gllan8se7e8+sFt++tvY1cSy6i1lAN9hTSU0exHESJ2UphznIx/NNms0msKzmN9NykqyLsdr7pacfzIVd+4E5YKiSV/7g=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2912.namprd20.prod.outlook.com (10.255.7.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 30 Jul 2019 12:24:30 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 12:24:30 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - Fix null ptr derefence on rmmod
 for macchiatobin
Thread-Topic: [PATCH] crypto: inside-secure - Fix null ptr derefence on rmmod
 for macchiatobin
Thread-Index: AQHVQ8/iMgPRTLq6dkWB1iRsEnMin6bi1VCAgAAlDcCAABOfgIAADSaQ
Date:   Tue, 30 Jul 2019 12:24:30 +0000
Message-ID: <MN2PR20MB297392C24E17DE2AE96C2C44CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564155069-18491-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730081203.GB3108@kwain>
 <MN2PR20MB2973F225CFE1CBA34C83ACFBCADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730113453.GA7595@gondor.apana.org.au>
In-Reply-To: <20190730113453.GA7595@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d1d1f2f-e852-4b39-f9cd-08d714e8df4f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2912;
x-ms-traffictypediagnostic: MN2PR20MB2912:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB29123016DE5AC22CF43E1CA8CADC0@MN2PR20MB2912.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(376002)(346002)(366004)(13464003)(199004)(189003)(53546011)(52536014)(6116002)(316002)(966005)(7696005)(7736002)(64756008)(66946007)(3846002)(81166006)(256004)(66476007)(305945005)(66066001)(8676002)(54906003)(53936002)(186003)(71190400001)(5660300002)(14454004)(8936002)(99286004)(26005)(76116006)(74316002)(6246003)(71200400001)(66446008)(6306002)(68736007)(9686003)(4326008)(6916009)(446003)(478600001)(25786009)(476003)(11346002)(81156014)(66556008)(55016002)(86362001)(76176011)(15974865002)(486006)(6436002)(6506007)(229853002)(102836004)(33656002)(2906002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2912;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +SVGv8RgBt/A1ezYG88xXx6NJ86nG5FApN8TJIXHot6JhdLh2fBGDk2uy9TqKDsCykJoO6kru2W70Q8go2oE5n1lV/1qjTPULDrFPtHtzaBkSg9Q9ULwOEQE5xVoSFCyuxYRjd4aTw/fUwQbMeR+ZQzIyZcIt/SHX7vITbo0n/+uAVyn8kICEA20TtEuspGIpeZjQA7+rvDmYSyzC4DNAdZw4atlbj/p4w+moK6RgrR/NG78WnuzO21BYYtkjlYCLJIiKvceuCI93SZ43XKW73iumOybCBRChYUzRSThhpJI8wkIsUOscnqoHaHDckS9A3WtZ6R6Nq+0yDlmxNY1KFyL6JZuTRtzfKij1Sk0CyMWuo3SXNTk9FWGgUo9U+JqmUG3BR/rUr5NAeVF4q1U1L3Y9kIkgPaKOI6HKD4DGGU=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1d1f2f-e852-4b39-f9cd-08d714e8df4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 12:24:30.7383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2912
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, July 30, 2019 1:35 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; davem@davemloft.net
> Subject: Re: [PATCH] crypto: inside-secure - Fix null ptr derefence on rm=
mod for
> macchiatobin
>=20
> On Tue, Jul 30, 2019 at 10:27:26AM +0000, Pascal Van Leeuwen wrote:
> >
> > As you already figured out by now, this patch just fixes something
> > that was broken by one of my earlier patches (which has not been
> > applied just yet). So I don't think it applies to stable trees.
>=20
> If your earlier patch has been applied to cryptodev already then you
> should use a Fixes header.  If not then you should repost that patch
> with the fix folded into it.
>=20
Yes, I understood that much. But thanks for spelling it out ;-)

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
